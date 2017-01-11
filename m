From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v4 2/3] drivers: crypto: Add the Virtual Function driver for CPT
Date: Wed, 11 Jan 2017 13:39:33 +0100
Message-ID: <1522639.tMShRcNLPc@positron.chronox.de>
References: <1484132211-917-1-git-send-email-george.cherian@cavium.com> <2395769.pOGQxxvRjM@positron.chronox.de> <587616D1.6050503@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: George Cherian <george.cherian@cavium.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        david.daney@cavium.com, clabbe.montjoie@gmail.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: George Cherian <gcherian@caviumnetworks.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55440 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751802AbdAKMjn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Jan 2017 07:39:43 -0500
In-Reply-To: <587616D1.6050503@caviumnetworks.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 11. Januar 2017, 16:58:17 CET schrieb George Cherian:

Hi George,

> I will add a seperate function for xts setkey and make changes as following.
> > ...
> > 
> >> +
> >> +struct crypto_alg algs[] = { {
> >> +	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
> >> +	.cra_blocksize = AES_BLOCK_SIZE,
> >> +	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
> >> +	.cra_alignmask = 7,
> >> +	.cra_priority = 4001,
> >> +	.cra_name = "xts(aes)",
> >> +	.cra_driver_name = "cavium-xts-aes",
> >> +	.cra_type = &crypto_ablkcipher_type,
> >> +	.cra_u = {
> >> +		.ablkcipher = {
> >> +			.ivsize = AES_BLOCK_SIZE,
> >> +			.min_keysize = AES_MIN_KEY_SIZE,
> >> +			.max_keysize = AES_MAX_KEY_SIZE,
> >> +			.setkey = cvm_enc_dec_setkey,
> > 
> > May I ask how the setkey for XTS is intended to work? The XTS keys are
> > double in size than "normal" keys.
> 
> 		.ablkcipher = {
> 			.ivsize = AES_BLOCK_SIZE,
> 			.min_keysize = 2 * AES_MIN_KEY_SIZE,
> 			.max_keysize = 2 * AES_MAX_KEY_SIZE,
> 			.setkey = cvm_xts_setkey,
> 
> Hope this is fine?
> 
Sure, please do not forget to invoke xts_verify_key.

Ciao
Stephan
