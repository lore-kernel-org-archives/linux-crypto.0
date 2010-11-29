From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Subject: Re: linux-next: Tree for November 29
Date: Mon, 29 Nov 2010 19:53:02 +0100
Message-ID: <AANLkTinV35OkDownhmqU5=5=2c=6G+sWEhdYpobVMM-U@mail.gmail.com>
References: <20101129140335.19800705.sfr@canb.auug.org.au>
	<AANLkTikiZoNM9zpXw3wSK7-uqh+ZYMpJ+wg0wPpBs_kx@mail.gmail.com>
	<20101129145717.GA20232@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20101129145717.GA20232@gondor.apana.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

2010/11/29 Herbert Xu <herbert@gondor.apana.org.au>:
> On Mon, Nov 29, 2010 at 09:47:38AM +0000, Zimny Lech wrote:
>> Ave
>>
>> 2010/11/29 Stephen Rothwell <sfr@canb.auug.org.au>:
>> > Hi all,
>> >
>> > Changes since 20101126:
>>
>>
>> Setup is 14188 bytes (padded to 14336 bytes).
>> System is 1267 kB
>> CRC 61cea148
>> Kernel: arch/x86/boot/bzImage is ready =A0(#1)
>> =A0 Building modules, stage 2.
>> =A0 MODPOST 537 modules
>> ERROR: "sock_no_mmap" [crypto/algif_skcipher.ko] undefined!
>
> I hope this patch fixes it for you.

Thanks, I'll check it in tomorrows -next.

>
> commit 7451708f39db19a8303bb7fb95f00aca9f673cb5
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date: =A0 Mon Nov 29 22:56:03 2010 +0800
>
> =A0 =A0crypto: af_alg - Add dependency on NET
>
> =A0 =A0Add missing dependency on NET since we require sockets for our
> =A0 =A0interface.
>
> =A0 =A0Should really be a select but kconfig doesn't like that:
>
> =A0 =A0net/Kconfig:6:error: found recursive dependency: NET -> NETWOR=
K_FILESYSTEMS -> AFS_FS -> AF_RXRPC -> CRYPTO -> CRYPTO_USER_API_HASH -=
> CRYPTO_USER_API -> NET
>
> =A0 =A0Reported-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
> =A0 =A0Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 467491d..96b0e55 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -848,6 +848,7 @@ config CRYPTO_USER_API
>
> =A0config CRYPTO_USER_API_HASH
> =A0 =A0 =A0 =A0tristate "User-space interface for hash algorithms"
> + =A0 =A0 =A0 depends on NET
> =A0 =A0 =A0 =A0select CRYPTO_HASH
> =A0 =A0 =A0 =A0select CRYPTO_USER_API
> =A0 =A0 =A0 =A0help
> @@ -856,6 +857,7 @@ config CRYPTO_USER_API_HASH
>
> =A0config CRYPTO_USER_API_SKCIPHER
> =A0 =A0 =A0 =A0tristate "User-space interface for symmetric key ciphe=
r algorithms"
> + =A0 =A0 =A0 depends on NET
> =A0 =A0 =A0 =A0select CRYPTO_BLKCIPHER
> =A0 =A0 =A0 =A0select CRYPTO_USER_API
> =A0 =A0 =A0 =A0help
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>



--=20
Slawa!
Zimny "Spie dziadu!" Lech z Wawelu

That is not dead which can eternal lie.
And with strange aeons even death may die.
