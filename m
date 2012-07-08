From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto/arc4: now arc needs blockcipher support
Date: Mon, 09 Jul 2012 00:55:28 +0300
Message-ID: <20120709005528.134177mvf7k1exc8@www.81.fi>
References: <20120626161346.GB6509@breakpoint.cc>
 <20120627065247.GE22920@gondor.apana.org.au>
 <20120708174624.GD2872@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:32982 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2GHVzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Jul 2012 17:55:31 -0400
In-Reply-To: <20120708174624.GD2872@breakpoint.cc>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Sebastian Andrzej Siewior <sebastian@breakpoint.cc>:

> On Wed, Jun 27, 2012 at 02:52:47PM +0800, Herbert Xu wrote:
>> > On a side note: do we pull in the blkcipher block mode for each =20
>> cipher now to
>> > gain some extra performance like the openssl project? I was under =
the
>> > impression that is in general not worth it.
>>
>> You mean normal block ciphers? Does it really make that much
>> of a difference?
>
> Yes. Jussi added block mode for RC4 instead that auto block-mode that=
 is
> prefered over the "automatic" one that is generated otherwise. I don'=
t know
> how much performance it brings but I would be supprised if it is a lo=
t on an
> average CPU. With this patch in I think it is a matter of time until =
we get
> the AES-CBC & and friends block mode optimized code (which should be =
a little
> faster since comparing to calling a function call for the XOR=E2=80=A6=
) you get the
> idea.
>
> Sebastian
>

I made quick tests with aes_generic, added block iterating loop into =20
aes_encrypt() and aes_decrypt() and registered ecb(aes). Encryption =20
0.97x vs auto block-mode, decryption 1.03x. So I'd think, for real =20
block ciphers, it makes no difference if looping is in ecb-module or =20
in cipher module. ARC4 performance difference can be found in =20
d366db605c8c4a9878589bc4a87e55f6063184ac commit log.

-Jussi
