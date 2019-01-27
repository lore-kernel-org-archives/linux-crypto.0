Return-Path: <SRS0=Rknj=QD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACABBC282C0
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 09:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B13C214C6
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 09:17:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="jZTaJGSE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfA0JRS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jan 2019 04:17:18 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35339 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfA0JRS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jan 2019 04:17:18 -0500
Received: by mail-wm1-f67.google.com with SMTP id t200so10674535wmt.0
        for <linux-crypto@vger.kernel.org>; Sun, 27 Jan 2019 01:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=efcg/0yUjs1pm8V27XtFMWmj9BDdcImS71CJ7F3LlQw=;
        b=jZTaJGSE32DaGdlVksqdLs+l9lWzTKelFKhE47NUJFPoXkjdPsPo6DGUE64TIEZetr
         XSFKNQAAmfwO5s1KxoE4qd18G9DYFi7JmR8y1XPMlw/CHKYme1cw66THlcn5u8UvNAwo
         /N0KCT2VGR/ZpjlUQ4nz5G1Ca0mFsh2vjSGS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=efcg/0yUjs1pm8V27XtFMWmj9BDdcImS71CJ7F3LlQw=;
        b=IzY1EHWhQiXVXg2mEBpgfBSjPGilcFsOq78Fbloeoh5JcZfXxXGYW4BZzE5Wo4LLyA
         HftPLwL6G49eyvstel01LOiynx1BXToYULIfltAXh+Up4qp1xI+gt01rqVzwHKHiDbJk
         FaSaTq6Af6JBVCayY0w1/azbOE+XcBLd+U1TNQwfwqcaDnV3gfK/P65zyJh68YW6l34n
         JkS4i338oRMUYWVPaT3eJaoNSRFvrdZvyn2LqHo/aGbvsVDQHhM3rYfbLqrNAKqkk6P0
         1oEIA2ngv+dmqZxCbxt0MplbOajq1BSa0iXzAN1zNtm5srBM2XAUOCeLN0cw60EIcttn
         +AXg==
X-Gm-Message-State: AJcUukerHsdkvBedD904V4o21qJdYW7kxhIQau9T6t90uOPdCBdQn/kX
        EwH9GhjEXDHziCe4nxdJ3fP8ME67uktmAg==
X-Google-Smtp-Source: ALg8bN7vPrYCs4kTxtuhY+W4B65t/QqJbd84Uxq6kO6BBLM3vReSP/R32WjMINBk5rpgiPqpuF1Z8w==
X-Received: by 2002:a1c:96c5:: with SMTP id y188mr1002476wmd.103.1548580635847;
        Sun, 27 Jan 2019 01:17:15 -0800 (PST)
Received: from sudo.home ([2a01:cb1d:112:6f00:887d:32e9:9391:d3bf])
        by smtp.gmail.com with ESMTPSA id o5sm45397013wrw.46.2019.01.27.01.17.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jan 2019 01:17:14 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 2/4] crypto: arm64/crct10dif - revert to C code for short inputs
Date:   Sun, 27 Jan 2019 10:16:53 +0100
Message-Id: <20190127091655.6262-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127091655.6262-1-ard.biesheuvel@linaro.org>
References: <20190127091655.6262-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The SIMD routine ported from x86 used to have a special code path
for inputs < 16 bytes, which got lost somewhere along the way.
Instead, the current glue code aligns the input pointer to 16 bytes,
which is not really necessary on this architecture (although it
could be beneficial to performance to expose aligned data to the
the NEON routine), but this could result in inputs of less than
16 bytes to be passed in. This not only fails the new extended
tests that Eric has implemented, it also results in the code
reading past the end of the input, which could potentially result
in crashes when dealing with less than 16 bytes of input at the
end of a page which is followed by an unmapped page.

So update the glue code to only invoke the NEON routine if the
input is at least 16 bytes.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 6ef5737f3931 ("crypto: arm64/crct10dif - port x86 SSE implementation to arm64")
Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crct10dif-ce-glue.c | 25 +++++---------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index b461d62023f2..567c24f3d224 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -39,26 +39,13 @@ static int crct10dif_update(struct shash_desc *desc, const u8 *data,
 			    unsigned int length)
 {
 	u16 *crc = shash_desc_ctx(desc);
-	unsigned int l;
 
-	if (unlikely((u64)data % CRC_T10DIF_PMULL_CHUNK_SIZE)) {
-		l = min_t(u32, length, CRC_T10DIF_PMULL_CHUNK_SIZE -
-			  ((u64)data % CRC_T10DIF_PMULL_CHUNK_SIZE));
-
-		*crc = crc_t10dif_generic(*crc, data, l);
-
-		length -= l;
-		data += l;
-	}
-
-	if (length > 0) {
-		if (may_use_simd()) {
-			kernel_neon_begin();
-			*crc = crc_t10dif_pmull(*crc, data, length);
-			kernel_neon_end();
-		} else {
-			*crc = crc_t10dif_generic(*crc, data, length);
-		}
+	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && may_use_simd()) {
+		kernel_neon_begin();
+		*crc = crc_t10dif_pmull(*crc, data, length);
+		kernel_neon_end();
+	} else {
+		*crc = crc_t10dif_generic(*crc, data, length);
 	}
 
 	return 0;
-- 
2.20.1

