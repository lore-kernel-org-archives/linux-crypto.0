Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1E0C06513
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0A1B21850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u38mRObk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfGBTme (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:34 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34597 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfGBTme (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:34 -0400
Received: by mail-lf1-f67.google.com with SMTP id b29so2309621lfq.1
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cNds9JAEq1hTUuemrXbQh9sj10to3vETzPkNzlmk2jM=;
        b=u38mRObkPGCNBpkUfqFku8ZoUy0UumUJnobS0qIyeuCnatakwjiXwIbv5q+4gcD1/f
         hYpaqvE42a5zxZ/usTOvnSI8b3jOwElOCHwPQYQW3ROwY/T2690uL/bfxsmeTasOeTP3
         9usz4Xg7U/zL5Xtoa92i8QccFmxZu5LiBt6Ipvj3Y2kEaHVTy6XUT+GE07S2tHMP/m+W
         YafR6IEU/XjJV87YhXqBOdImyaydmRwGupfGaakTMPiY7kH/v5V/mJoPhiR1Jz3TrGom
         WMZlYooS06YsixisHAUprj9ISqe2Sl8EmSfT7rydvgUt5MBpqvgTW13w//FgPcJYvY5R
         tmLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cNds9JAEq1hTUuemrXbQh9sj10to3vETzPkNzlmk2jM=;
        b=TxQpWk94ywE5dwYcUijjmJ7td3fO8M8iHFNOpZejxv5quDMZlk93ADJS21iNaNk9F0
         gbi2+NXVA8je/YlbJGmrW32tbaKvDWpvWREoRHaBZc9VxkNgCWeMKxDAwH8ACIZekLyX
         wuSgjXQUSSmc2hLg20qfu4CBAf+C7O6HjXqfa26LZSLlCZubgUQBW6y2NiQyqJoT20QN
         NDgHoznDaJUH69hwtDuxrYon2mRxCtMLtILdhZBvCaXNaFBPGTaUfDqib8GLqlRSVIB1
         XEdjCUg6aaqUxdPinyTBBdfMPtQrmwmvNXdUV0NSpdh03Bo8CsOl4b2YgRXPJRSH7zAU
         bARA==
X-Gm-Message-State: APjAAAWmanSc4WxJi6hCn5+oL3h4wCghKfeVWq7qh1IecxpMZWCGwOdU
        8Q28y8O0zXHCXqpoBgVAfAnWs25A4NWA8OnF
X-Google-Smtp-Source: APXvYqzoQDKNn9zBHjWWLG+oR2fk4DwVcuX6BG6wvz8DceyjSULfNtgT48RLa68sJoZqXCcfOtJnxg==
X-Received: by 2002:ac2:52b7:: with SMTP id r23mr1871076lfm.120.1562096551941;
        Tue, 02 Jul 2019 12:42:31 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:31 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 16/32] crypto: ctr - add helper for performing a CTR encryption walk
Date:   Tue,  2 Jul 2019 21:41:34 +0200
Message-Id: <20190702194150.10405-17-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
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
2.17.1

