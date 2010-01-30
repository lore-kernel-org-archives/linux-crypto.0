From: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] geode: Fix cip/blk confusion
Date: Sat, 30 Jan 2010 16:48:19 +0100
Message-ID: <4B6454C3.1030606@gmail.com>
References: <4B62E388.1070707@gmail.com> <20100129145152.GA31953@Chamillionaire.breakpoint.cc> <25e057c01001290720k529a5ee3i6bef74c9217abbf8@mail.gmail.com> <20100129203008.GA5828@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Sergey Mironov <ierton@gmail.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:55564 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab0A3PmZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Jan 2010 10:42:25 -0500
In-Reply-To: <20100129203008.GA5828@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

a crypto_cipher cip member was set where a crypto_cipher blk members
should have been.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
>> I think my previous patch missed one
>> blk to cip conversion in geode_setkey_cip():
> 
> Please send an incremental patch.  Thanks!

Ok, here's the missing part

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 03e71b1..c7a5a43 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -141,7 +141,7 @@ static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
 	ret = crypto_cipher_setkey(op->fallback.cip, key, len);
 	if (ret) {
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
+		tfm->crt_flags |= (op->fallback.cip->base.crt_flags & CRYPTO_TFM_RES_MASK);
 	}
 	return ret;
 }
