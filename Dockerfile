ARG VERSION=ltsc2022
FROM amitie10g/msys2:$VERSION


ARG MSYSTEM=MINGW64

ENV MSYSTEM=${MSYSTEM}

RUN setx path "C:\msys64\mingw64\bin;C:\msys64\mingw32\bin;%PATH%" && \
	bash -l -c " \
		pacman -S --needed --noconfirm --noprogressbar --disable-download-timeout curl git mingw-w64-x86_64-gcc mingw-w64-x86_64-cairo mingw-w64-x86_64-poppler bzr zip && \
    wget https://repo.msys2.org/mingw/mingw64/mingw-w64-x86_64-go-1.18-2-any.pkg.tar.zst && \
    wget https://repo.msys2.org/mingw/mingw64/mingw-w64-x86_64-pkg-config-0.29.2-3-any.pkg.tar.zst && \
    pacman --noconfirm -U mingw-w64-x86_64-go-1.18-2-any.pkg.tar.zst && \
    pacman --noconfirm -U mingw-w64-x86_64-pkg-config-0.29.2-3-any.pkg.tar.zst && \
    rm -r mingw-w64-x86_64-go-1.18-2-any.pkg.tar.zst && \
    rm -r mingw-w64-x86_64-pkg-config-0.29.2-3-any.pkg.tar.zst && \
		rm -r /var/cache/pacman/pkg/* \
	"

WORKDIR C:/work

ENV GOROOT=C:/msys64/mingw64/lib/go \
  GOOS=windows \
  GOARCH=amd64 

RUN bash -l -c " \
    go env -w GOMODCACHE=C:/work/.tmp/go/pkg/mod && \
    go env -w GOMODCACHE=C:/work/.tmp/.cache \
  "

CMD ["bash", "-l"]

ENTRYPOINT [ "go","build" ]