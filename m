Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5248C48BE8
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7745520657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZhEjEvQI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfFVTe7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43957 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfFVTe7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so9694043wru.10
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wZx82U9voWItQ7XjqUeJC5jib2swTQ8RphpE15DMS1M=;
        b=ZhEjEvQIqhA5GX3sES588EqzaZ0VJ2PTS8uVFfg7XONw+MNc+ACw15XwxZsHu0RC/Q
         Ht/GVajnrlhCzulhZhDNLW4sDkmggVVmC1qBPzTkX/32sLMFLHf8FRxevQgeBnvv4nyc
         G+rmAo+m6NIaiIdf1gox9fRBqVscbmRo3AGjjT76BzXXwXNdrk4w3nmrqPfWiDetBnUz
         bG5mQei/re7ml0qWsDrYinGkQmyLT47zeQc278WBrBCjnfWVnrAbEdJerPxDMLz0YtUD
         FBhpkfBECKsGQlkNz4tP3I5MME0dEpQK/JaQulCMzac7Ony+m6CwI3PEwHJG7psPQ7KP
         /b+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wZx82U9voWItQ7XjqUeJC5jib2swTQ8RphpE15DMS1M=;
        b=lUynpF3AuNckWnkqrFCmMT7BJ7JXFsMx47wQnnQHPcTfzk/Gi0OBlOEobY3Pp0TrFF
         Wcr8vgqiSXv7YpgoPJFD8dwysLLg8wpbtjPjJiOyzEMKxXXaHkdRBI+djHnemLRHvLyF
         qFkMnx/6iS9NEdLHYsQQCntO3KNIgR9dXzbO6PHUCw+KZ2RkD1lGGcqz2rIAFSVRrXE4
         wzn6SGEWzN3u8Cmep75iRb3RB3Xc+joxKeCdeg6D2N217Y3KByt85/9OM0DJo3mczVRo
         zLzxCD6IvxBnG8uMGDYP+6qBfPOOkf4FtNNzKAF6368jbaBNwYmBR0kVPhJ9yzJIMFVc
         y+ZQ==
X-Gm-Message-State: APjAAAXdbAZuo+BU2cM63AiSFJjWdFz8UkAx/IFm6o9X+1urNiCdttxv
        NPrNrfXdS3qwvIhkwSLmqjeX5qSOFP7WhTlZ
X-Google-Smtp-Source: APXvYqy5vxZMCruOEj+CU3NznNQdLYAX99rPA5U7zT6A8GdhvCja/MUov+uxTWcEgJEzHIRxtgkIdg==
X-Received: by 2002:adf:e8c8:: with SMTP id k8mr73848941wrn.285.1561232097032;
        Sat, 22 Jun 2019 12:34:57 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:56 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 16/26] crypto: ctr - add helper for performing a CTR encryption walk
Date:   Sat, 22 Jun 2019 21:34:17 +0200
Message-Id: <20190622193427.20336-17-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
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
 include/crypto/ctr.h | 53 ++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/include/crypto/ctr.h b/include/crypto/ctr.h
index 4180fc080e3b..b441274e9b27 100644
--- a/include/crypto/ctr.h
+++ b/include/crypto/ctr.h
@@ -13,8 +13,61 @@
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
 
+#define CTR_HELPER_MAX_BLOCK_SIZE	16
+
+static inline int crypto_ctr_encrypt_walk(struct skcipher_request *req,
+					  void (*fn)(struct crypto_skcipher *,
+						     const u8 *, u8 *))
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	int blocksize = crypto_skcipher_blocksize(tfm);
+	u8 buf[CTR_HELPER_MAX_BLOCK_SIZE];
+	struct skcipher_walk walk;
+	int err;
+
+	/* verify some assumptions that help us keep the code simple */
+	if (WARN_ON_ONCE(!is_power_of_2(blocksize) ||
+			 blocksize > CTR_HELPER_MAX_BLOCK_SIZE))
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
+			nbytes = round_down(nbytes, blocksize);
+			tail = walk.nbytes & (blocksize - 1);
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
+			dst += blocksize;
+			src += blocksize;
+			nbytes -= blocksize;
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

