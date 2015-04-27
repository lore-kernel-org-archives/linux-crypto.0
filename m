From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: add key wrapping block chaining mode
Date: Mon, 27 Apr 2015 16:58:51 +0200
Message-ID: <3344357.7kIb8DDjMB@tauon>
References: <1515730.LIeS5qas5m@myon.chronox.de> <3407264.GJDOVGtEDe@myon.chronox.de> <20150427082935.GA21691@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34535 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964784AbbD0O65 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 10:58:57 -0400
In-Reply-To: <20150427082935.GA21691@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 27. April 2015, 16:29:35 schrieb Herbert Xu:

Hi Herbert,

>On Sun, Apr 26, 2015 at 12:08:20AM +0200, Stephan Mueller wrote:
>> This patch implements the AES key wrapping as specified in
>> NIST SP800-38F and RFC3394.
>
>This is my attempt at turning kw into a givcipher.  The encrypt
>part is complete but untested as I gave up after finding the
>reverse SG problem with your decrypt code.

Is it that easy? I was struggling to understand what to do in the alloc 
function.

Thank you very much for that hint.

>static int crypto_kw_givdecrypt(struct skcipher_givcrypt_request *req)
>{
>	int err = crypto_kw_decrypt(&req->creq);
>
>	if (err)
>		return err;
>
>	return memcmp(req->creq.info, "\xA6\xA6\xA6\xA6\xA6\xA6\xA6\xA6",
>		      SEMIBSIZE) ? -EBADMSG : 0;

This memcmp implies that the final block->A from the decrypt is memcpy'ed to 
req->creq.info. I wanted to avoid any additional memcpy calls to not hurt 
performance even more.


Ciao
Stephan
