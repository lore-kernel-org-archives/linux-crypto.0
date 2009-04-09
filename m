From: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [2.6.30-rc1] device-mapper: table: 254:0: crypt: Error allocating
	crypto tfm
Date: Thu, 9 Apr 2009 14:46:29 +0200
Message-ID: <8db1092f0904090546j54ac6759i9c36f214ce1109bc@mail.gmail.com>
References: <8db1092f0904081235x58081f1by842ab45ad861e294@mail.gmail.com>
	 <20090409021804.GA1756@gondor.apana.org.au>
	 <20090409023547.GA1878@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, arjan@linux.intel.com,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Jiri Slaby <jirislaby@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:44827 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZDIMqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2009 08:46:33 -0400
In-Reply-To: <20090409023547.GA1878@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2009/4/9 Herbert Xu <herbert@gondor.apana.org.au>:
[...]

Yes, patch helps. Thanks

Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>

> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> index d5fa565..384ca8b 100644
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -34,7 +34,7 @@ extern int __request_module(bool wait, const char *=
name, ...) \
> =C2=A0#define request_module(mod...) __request_module(true, mod)
> =C2=A0#define request_module_nowait(mod...) __request_module(false, m=
od)
> =C2=A0#define try_then_request_module(x, mod...) \
> - =C2=A0 =C2=A0 =C2=A0 ((x) ?: (__request_module(false, mod), (x)))
> + =C2=A0 =C2=A0 =C2=A0 ((x) ?: (__request_module(true, mod), (x)))
> =C2=A0#else
> =C2=A0static inline int request_module(const char *name, ...) { retur=
n -ENOSYS; }
> =C2=A0static inline int request_module_nowait(const char *name, ...) =
{ return -ENOSYS; }
>
> Thanks,
> --
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>

--=20
Maciej Rutecki
http://www.maciek.unixy.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
