Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B0CC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 08:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8851C218D2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 08:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="gQAHsQPA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfAYItY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 03:49:24 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39150 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbfAYItY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 03:49:24 -0500
Received: by mail-wm1-f68.google.com with SMTP id y8so5769633wmi.4
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jan 2019 00:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JD/Pi2kZaELwRAgMBI67I7DkYZJn4nUbk7rRyg7KRPY=;
        b=gQAHsQPA3EQJ2spnhqB9b8/zrowsf9lfNBgtq/u8ZeciSgbkRRQTHvelGFhlCRv6kx
         xrxhyZYpPFLg6smeWj5jZA6YbRD0JKKCgcvGUYKDJYJrYBGrMzz8xRdjBxjpF/nDsIvz
         dXEmvug4EVKT1LRK4rQu1yB0hhtpkjKNpcr70=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JD/Pi2kZaELwRAgMBI67I7DkYZJn4nUbk7rRyg7KRPY=;
        b=IRVtqX9ePv0IdcS6M/Qp1X+LkM672+zL0pbPQXY0FJPowNNrQZ4kOlPq6RMfOE5Kcz
         6gYTrnzaAgiXjbdXzxCQ2S4VzDU/1FHZf0o6vDQ7NBxGeU++MQYYeV1vIewjkDj1ImN8
         VPOY1JaDZ0CKm7ynpACJNrc56PCwg5djoZLnMUKAXI7dILzH2AkqNcQbxyj+Af6JEPm0
         5D0boqIoiGOIJ6DC4XYq+G4C3SFk+uDL5/+yrfGFgem9Qo82wmV9eKw7kKHRqH2rhzVX
         Vu5wEn3zpI2VR5adFqZMUCIMVqD8hvNU9ICHTSqqqFlydyVQsko3KmfJzS3nT1DnkrHs
         Xghg==
X-Gm-Message-State: AJcUukdLU9eyAk2NP1zc/i6cxIYFysqRKGIYlExOJtU2+4nteJUSgjcP
        Q0/3SGv+GPGsIOZc65z8PHrezT5VLwf/Qg==
X-Google-Smtp-Source: ALg8bN6iAjm1C9zmxKZ86cj+QOgziSPaRndh33v5n+5iMuIGdgsU3aZpSl21ynW47+ql7XRiPnd9Cg==
X-Received: by 2002:a7b:cd85:: with SMTP id y5mr5710268wmj.129.1548406162511;
        Fri, 25 Jan 2019 00:49:22 -0800 (PST)
Received: from dogfood.home ([2a01:cb1d:112:6f00:bcd4:806e:230a:673e])
        by smtp.gmail.com with ESMTPSA id 125sm112594574wmm.26.2019.01.25.00.49.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 00:49:21 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/4] crypto: arm64/crct10dif - revert to C code for short inputs
Date:   Fri, 25 Jan 2019 09:49:13 +0100
Message-Id: <20190125084915.25411-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190125084915.25411-1-ard.biesheuvel@linaro.org>
References: <20190125084915.25411-1-ard.biesheuvel@linaro.org>
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
input is more than 16 bytes.

Reported-by: Eric Biggers <ebiggers@kernel.org>
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
2.17.1

