Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F929C282C5
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 18:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E167E218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 18:27:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="aIpSZUY3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbfAXS1X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:27:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34529 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfAXS1X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 13:27:23 -0500
Received: by mail-wr1-f66.google.com with SMTP id f7so7621514wrp.1
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 10:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3/1JsJbOO9AapMWTRThG5LlPeoGHhP1SPxErwHi+5nY=;
        b=aIpSZUY3HDECVs6ewDdoEN9Hdyis2ferKU36Vhx9iyGGId0acU/LfAtbxIhx6gcIuE
         7XMpikyGfot/vqiMvqbqgqh7pC9Qnp7EPME7IXlJRVzkUbJFdwNoHJfXc82NiVyZWluV
         7PGeqVprHgmqPoVodW4vgj54HJ0cZh7Y33O5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3/1JsJbOO9AapMWTRThG5LlPeoGHhP1SPxErwHi+5nY=;
        b=GdXNK/WowIHtb6udMnXriiQx5PW8FacQ0lQ2i7Gee5iirQOzcq7XiJ8o7MBh0kWZsC
         TfBudkpSAt94eXTq8iJmlwqvieWNLy63wVvOyfSHxNjiqFkjAGGjNlaiJ1GZJZm+PUyl
         483gWTq2br5mSUMB+UuCrZD9u04KdBdoQmgHIDIwi8Ns5fDbXUIfEMao22ee+Z5C02wr
         EynjfgWMAIu1U5W6iRdWIzwFkbe/edsYDFa2UWljZeUm38wZjE+AYq9jn2PGxJ+McuxK
         jXiquPPw0mWlDc1xeFTC6SE6oHHyuKbLozQ0C0hLoX7ayNvlXeOBvmN80xwt7u0AhqiJ
         mprA==
X-Gm-Message-State: AJcUukc9nGMY1f/m7NigUZrwFJPU2RYIFOg9qtDXsQNzLcJCCDsT2tPB
        WoDd0y1NBVSL7AYBHEGqDBogsS4v/WBveA==
X-Google-Smtp-Source: ALg8bN5yh+PmaunQIPmSunyPL7mY0/f+bAONZd8HEZ9jOTYMa5GuN6haDGb2R1JUvqukAQ09htcm7g==
X-Received: by 2002:adf:f550:: with SMTP id j16mr8145818wrp.258.1548354441226;
        Thu, 24 Jan 2019 10:27:21 -0800 (PST)
Received: from dogfood.home ([2a01:cb1d:112:6f00:bcd4:806e:230a:673e])
        by smtp.gmail.com with ESMTPSA id 202sm73247138wmt.8.2019.01.24.10.27.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 10:27:20 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: arm64/crct10dif - revert to C code for short inputs
Date:   Thu, 24 Jan 2019 19:27:12 +0100
Message-Id: <20190124182712.7142-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190124182712.7142-1-ard.biesheuvel@linaro.org>
References: <20190124182712.7142-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The SIMD routine ported from x86 used to have a special code path
for inputs < 16 bytes, which got lost somewhere along the way.
Instead, the current glue code aligns the input pointer to permit
the NEON routine to use special versions of the vld1 instructions
that assume 16 byte alignment, but this could result in inputs of
less than 16 bytes to be passed in. This not only fails the new
extended tests that Eric has implemented, it also results in the
code reading before the input pointer, which could potentially
result in crashes when dealing with less than 16 bytes of input
at the start of a page which is preceded by an unmapped page.

So update the glue code to only invoke the NEON routine if the
input is more than 16 bytes.

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
2.17.1

