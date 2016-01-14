From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: lib: sw842: select crc32
Date: Wed, 13 Jan 2016 22:36:57 -0500
Message-ID: <CALZtONBUR98zDt+hHmbDtCCxv7PbwR-D79xaJCTw37f2hw9yiw@mail.gmail.com>
References: <4168537.6I1FVkp3DA@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4168537.6I1FVkp3DA@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 13, 2016 at 5:24 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The sw842 library code was merged in linux-4.1 and causes a very rare randconfig
> failure when CONFIG_CRC32 is not set:
>
>     lib/built-in.o: In function `sw842_compress':
>     oid_registry.c:(.text+0x12ddc): undefined reference to `crc32_be'
>     lib/built-in.o: In function `sw842_decompress':
>     oid_registry.c:(.text+0x137e4): undefined reference to `crc32_be'
>
> This adds an explict 'select CRC32' statement, similar to what the other users
> of the crc32 code have. In practice, CRC32 is always enabled anyway because
> over 100 other symbols select it.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")

Acked-by: Dan Streetman <ddstreet@ieee.org>

>
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 1ce5af9cc418..ee38a3fd2814 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -217,9 +217,11 @@ config RANDOM32_SELFTEST
>  # compression support is select'ed if needed
>  #
>  config 842_COMPRESS
> +       select CRC32
>         tristate
>
>  config 842_DECOMPRESS
> +       select CRC32
>         tristate
>
>  config ZLIB_INFLATE
>
