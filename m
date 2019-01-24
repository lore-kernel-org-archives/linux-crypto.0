Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CABB8C282C5
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 16:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AF332184C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 16:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="QCP0TruD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfAXQd4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:33:56 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40825 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbfAXQdz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 11:33:55 -0500
Received: by mail-wm1-f67.google.com with SMTP id f188so3705689wmf.5
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 08:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G41sgJAH7cOGISzvmX0cU+gy3eCXCkMtDvUqIcUHa8o=;
        b=QCP0TruD5NqlWG78qRspIyKRhyZUDVgHDQI6xFIOtZOj1rVYG8KkE0iTaYViG+1TF+
         lgTNQBFMdHW0ilDblDGlHSd2HFrTY0F44c2hg62rU689AVCNCgc6ez3g4AlDNqAb6FX7
         5UhgeDBHb0H5+zuFslLxAva0WV+GbeRo3FTtA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G41sgJAH7cOGISzvmX0cU+gy3eCXCkMtDvUqIcUHa8o=;
        b=b1pJDxdzO8VEIpeR3JRHIq3qhHclJiLhhFQ8hiTiaagMPco1NSn6t4GHB50zoFeshb
         Ut7Dq1nv/nWnNkgTZpxiU7rUaDzpslJ/B+Je8LGjQYqWnNBpsI2KmWXQmy9SHG15/qQc
         44VdLjEE+cH8RwSsVYGnC2ttBRmJbdoRwai2M8I6stXSen5wFSlMibJAS0nmaG6pULNt
         Atiza89aivFTX4BWNkCuoHSUMv0MRMUtXmFEYRo33iPJ2LKSmpuOSrO400JnHPtkID+d
         p72QLAOZsNvNHozQnAFPRJ4dxXT2naU3iDEUCmtC5bCUKYQfw8fYpbjVZ4Ra3ohrUqbW
         dbtA==
X-Gm-Message-State: AJcUukcPRiYT7L4G273Up/sjTOMZDFgaHQ+NZ16MbCg28HNnbe1ElnVD
        xk6k/EJbJ67Qj4zcD4gn1WBUHy8GM3HtXA==
X-Google-Smtp-Source: ALg8bN6oB+x2kI6DWIpBc+U7TXurFfxX5fkxngZL462Xg4lPh3a3WXp91uwEjEgcuW6s1XeIawcGnQ==
X-Received: by 2002:a1c:9cce:: with SMTP id f197mr3381997wme.135.1548347633691;
        Thu, 24 Jan 2019 08:33:53 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id t12sm99629069wrr.65.2019.01.24.08.33.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 08:33:52 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/3] crypto: arm64/aes-ccm - fix bugs in non-NEON fallback routine
Date:   Thu, 24 Jan 2019 17:33:46 +0100
Message-Id: <20190124163347.12653-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190124163347.12653-1-ard.biesheuvel@linaro.org>
References: <20190124163347.12653-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 5092fcf34908 ("crypto: arm64/aes-ce-ccm: add non-SIMD generic
fallback") introduced C fallback code to replace the NEON routines
when invoked from a context where the NEON is not available (i.e.,
from the context of a softirq taken while the NEON is already being
used in kernel process context)

Fix two logical flaws in the MAC calculation of the associated data.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 5092fcf34908 ("crypto: arm64/aes-ce-ccm: add non-SIMD generic fallback")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 68b11aa690e4..986191e8c058 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -125,7 +125,7 @@ static void ccm_update_mac(struct crypto_aes_ctx *key, u8 mac[], u8 const in[],
 			abytes -= added;
 		}
 
-		while (abytes > AES_BLOCK_SIZE) {
+		while (abytes >= AES_BLOCK_SIZE) {
 			__aes_arm64_encrypt(key->key_enc, mac, mac,
 					    num_rounds(key));
 			crypto_xor(mac, in, AES_BLOCK_SIZE);
@@ -139,8 +139,6 @@ static void ccm_update_mac(struct crypto_aes_ctx *key, u8 mac[], u8 const in[],
 					    num_rounds(key));
 			crypto_xor(mac, in, abytes);
 			*macp = abytes;
-		} else {
-			*macp = 0;
 		}
 	}
 }
-- 
2.20.1

