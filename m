From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 1/3] crypto: add interleave option to cipher_alg
Date: Thu,  6 Feb 2014 13:25:02 +0100
Message-ID: <1391689504-28160-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:34716 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbaBFMZF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Feb 2014 07:25:05 -0500
Received: by mail-we0-f170.google.com with SMTP id w62so1246205wes.29
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2014 04:25:04 -0800 (PST)
In-Reply-To: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Many ciphers perform better when allowed to operate on data sizes that are
larger than the natural block size of the algorithm.

This patch adds a struct member .cia_interleave which holds the preferred
number of blocks processed in a single invocation. The invocations themselves
should occur through .cia_enc_interleave and .cia_dec_interleave.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/crypto.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b92eadf92d72..4f09a10a4efa 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -252,6 +252,10 @@ struct cipher_alg {
 	                  unsigned int keylen);
 	void (*cia_encrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 	void (*cia_decrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
+
+	unsigned int cia_interleave;
+	void (*cia_enc_interleave)(struct crypto_tfm *tfm, u8 *d, const u8 *s);
+	void (*cia_dec_interleave)(struct crypto_tfm *tfm, u8 *d, const u8 *s);
 };
 
 struct compress_alg {
-- 
1.8.3.2
