From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 0/14] crypto: aead - Phase oute seqniv
Date: Mon, 13 Jul 2015 11:09:34 +0200
Message-ID: <4183187.0RpMVHFSDO@tauon.atsec.com>
References: <20150708231330.GA28797@gondor.apana.org.au> <1566279.T44EXs4eLd@tauon.atsec.com> <20150711023918.GB24197@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47956 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbbGMJJl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jul 2015 05:09:41 -0400
In-Reply-To: <20150711023918.GB24197@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 11. Juli 2015, 10:39:18 schrieb Herbert Xu:

Hi Herbert,

>Weird.  The C version does the very same check:
>
>static int crypto_rfc4106_decrypt(struct aead_request *req)
>{
>        if (req->assoclen != 16 && req->assoclen != 20)
>                return -EINVAL;

I rechecked my test code: I accidentally only used gcm(aes) instead of 
rfc4106(gcm(aes)) for validating the C code. Using rfc4106(gcm(aes-asm)), I 
get the same error. Sorry for the inconsistent description.

Based on the patch to the testmgr.h test vectors for RFC4106, I include the IV 
inbetween the AD and the plaintext.

That code now works with rfc4106(gcm(aes)). But using that code now fails with 
the "regular" GCM implementation as well as CCM. The regular GCM 
implementation works when not providing the IV as part of the SGL/set_ad. Is 
that difference between "regular" AEAD and RFC4106 AEAD intended?

Apart from the GCM vs RFC4106 invocation, the code seemingly requires to 
provide the IV twice -- once with the buffer/set_ad and once with the 
set_crypt call. Is that intended? Providing the IV twice is visible in the 
testmgr.h patch where .assoc now includes the previous .assoc plus the IV data 
which is also set in .iv.

Thanks
Stephan
