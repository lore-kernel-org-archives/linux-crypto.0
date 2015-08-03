From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Proposal for adding setpubkey callback to akcipher_alg
Date: Mon, 03 Aug 2015 08:39:51 +0200
Message-ID: <1704807.Rn4DsddD6R@tauon.atsec.com>
References: <905E1812-AD9B-4188-A668-3CD8985EA1BF@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>,
	linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48061 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbbHCGjz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 02:39:55 -0400
In-Reply-To: <905E1812-AD9B-4188-A668-3CD8985EA1BF@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 2. August 2015, 22:28:33 schrieb Marcel Holtmann:

Hi Marcel,

>Hi Tadeusz,
>
>I think we need to split the akcipher_alg setkey callback into a setkey and
>setpubkey.
>
>diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
>index 69d163e39101..ca93952b6d19 100644
>--- a/include/crypto/akcipher.h
>+++ b/include/crypto/akcipher.h
>@@ -91,6 +91,8 @@ struct akcipher_alg {
>        int (*decrypt)(struct akcipher_request *req);
>        int (*setkey)(struct crypto_akcipher *tfm, const void *key,
>                      unsigned int keylen);
>+       int (*setpubkey)(struct crypto_akcipher *tfm, const void *key,
>+                        unsigned int keylen);
>        int (*init)(struct crypto_akcipher *tfm);
>        void (*exit)(struct crypto_akcipher *tfm);
>
>If the cipher actually uses two different formats for the public + private

The public key is n + e.

The private key is n + d.

Both are encoded in the BER structure the current API requires. It is 
perfectly valid to provide only n + e when you do public key operations.

Please see in the testmgr.h for the 2048 bit key test vector (i.e. the one 
with public_key_vec = true). The BER structure has nice comments from Tadeusz 
to indicate it only contains n and e without d.

Thus, I do not currently understand your request. May I ask you to give more 
explanation why the use of BER is insufficient?


Ciao
Stephan
