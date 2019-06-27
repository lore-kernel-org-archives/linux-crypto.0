Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E63CC48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3750820828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yMCUEiJ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfF0K2L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:11 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40814 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfF0K2K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so5106135wmj.5
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u6Q45pPiPnuFNJpKPysKttSzbQMmfbBttYB0PrnTC+o=;
        b=yMCUEiJ1wmfKpip7QF0/jBbHIedZntLzBTadFMegGfUEfCiOukmCkANW6wl5JX5rnZ
         +EB1PLnwabwL8NvVy1tBiGhk0qlyeLMLpGp/1heEFvlMA+TJoF4d6I0UNYgMS/MBGrKM
         wKa1B85dJI9lxm2mK/GLdr9pDSRkWFsWYBzNQrUAFKz4Fhv4xOPI4yP5lxPV2VjrIFYa
         0YgD6d9oBFnB3MBbEZkDhSqEqQ/lsePZd8SydDG1xLdrE3RIoi7w1jF1/UQM8ec3j9dH
         KkNiD43dGdQ0pb9wxUK1wixPV9JUrj08x1n6xrHW4Jd3Q0TKTMygGgdyXC2ApFwnRIk5
         JDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u6Q45pPiPnuFNJpKPysKttSzbQMmfbBttYB0PrnTC+o=;
        b=FfBzfiJ4UawB6Mf9cY/cUKdlC1uQbrrPrqvXXpw+TbefV7zuBp0uFldMlxzC6sy5Ck
         1Qb9pVa+Pdju9KcjQuzEQcIqHixPgWKOiAdIspnDQAGrMdnt4djVsFi8Dp/QGRi/60Rq
         /qSbDvCxGstGnIthc09lbtfPe34PDlNCIpYInoq6/EBD8yxXIrGtTcyxaq3HWzD/erTr
         iF+/kR7tV6RVdaSBa66aTo+s8McX5Y5tdBfoCRHhC6OubIDvHOxriMTd+mB5C0Jp98H0
         DcnWhmcVowzdGisDpV08KQebIV6qbBClDIe7hbM2n0wIaKgv3oXMyO/GdtxCaSt/MaQs
         zwfw==
X-Gm-Message-State: APjAAAU1aom8ByObHh2xhzCVy5qEOhT22DgJLzg0jzDhqQ1mJ+o+t4Ba
        TvJXRfZs5GdMl7bMf5q75w1FjE96AgU=
X-Google-Smtp-Source: APXvYqzSfXg4THsIhxZONj9oVQQhq7bnKNdKqW7ffju3C6anAdRC3DC6q1Dtgj4GZLiwgdn8pWWxfg==
X-Received: by 2002:a7b:cc97:: with SMTP id p23mr2833802wma.120.1561631288174;
        Thu, 27 Jun 2019 03:28:08 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:07 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 16/32] crypto: ctr - add helper for performing a CTR encryption walk
Date:   Thu, 27 Jun 2019 12:26:31 +0200
Message-Id: <20190627102647.2992-17-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a static inline helper modeled after crypto_cbc_encrypt_walk()
that can be reused for SIMD algorithms that need to implement a
non-SIMD fallback for performing CTR encryption.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/crypto/ctr.h | 50 ++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/include/crypto/ctr.h b/include/crypto/ctr.h
index 4180fc080e3b..d64017fae41c 100644
--- a/include/crypto/ctr.h
+++ b/include/crypto/ctr.h
@@ -13,8 +13,58 @@
 #ifndef _CRYPTO_CTR_H
 #define _CRYPTO_CTR_H
 
+#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
 #define CTR_RFC3686_NONCE_SIZE 4
 #define CTR_RFC3686_IV_SIZE 8
 #define CTR_RFC3686_BLOCK_SIZE 16
 
+static inline int crypto_ctr_encrypt_walk(struct skcipher_request *req,
+					  void (*fn)(struct crypto_skcipher *,
+						     const u8 *, u8 *))
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	int blocksize = crypto_skcipher_chunksize(tfm);
+	u8 buf[MAX_CIPHER_BLOCKSIZE];
+	struct skcipher_walk walk;
+	int err;
+
+	/* avoid integer division due to variable blocksize parameter */
+	if (WARN_ON_ONCE(!is_power_of_2(blocksize)))
+		return -EINVAL;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while (walk.nbytes > 0) {
+		u8 *dst = walk.dst.virt.addr;
+		u8 *src = walk.src.virt.addr;
+		int nbytes = walk.nbytes;
+		int tail = 0;
+
+		if (nbytes < walk.total) {
+			tail = walk.nbytes & (blocksize - 1);
+			nbytes -= tail;
+		}
+
+		do {
+			int bsize = min(nbytes, blocksize);
+
+			fn(tfm, walk.iv, buf);
+
+			crypto_xor_cpy(dst, src, buf, bsize);
+			crypto_inc(walk.iv, blocksize);
+
+			dst += bsize;
+			src += bsize;
+			nbytes -= bsize;
+		} while (nbytes > 0);
+
+		err = skcipher_walk_done(&walk, tail);
+	}
+	return err;
+}
+
 #endif  /* _CRYPTO_CTR_H */
-- 
2.20.1

