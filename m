From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: alg: cipher: Test 1 failed on encryption for aes-asm
Date: Sat, 20 Dec 2008 07:55:10 +1100
Message-ID: <E1LDmNK-0003HV-LF@gondolin.me.apana.org.au>
References: <20081219202603.GA31265@lst.de>
Cc: linux-crypto@vger.kernel.org
To: hch@lst.de (Christoph Hellwig)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55224 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751078AbYLSUzN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Dec 2008 15:55:13 -0500
In-Reply-To: <20081219202603.GA31265@lst.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Christoph Hellwig <hch@lst.de> wrote:
> On my new thinkpad with a Intel Core2 Duo T9600 I reproducibly get
> this message during boot:
> 
> [    0.657034] alg: cipher: Test 1 failed on encryption for aes-asm
> [    0.657111] 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
> 
> I'd assume it's not a hardware but, so my the assembly code doesn't
> like the debian toolchain?  It's
> 
>        binutils 2.18.1~cvs20080103-7
>        gcc 4.3.2-1
> 
> (all the Debian package versions)

You forgot to list the kernel version :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
