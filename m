Return-Path: <SRS0=Rknj=QD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065D9C282C0
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 09:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA6AE214C6
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 09:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="CgF/Io8R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfA0JRV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jan 2019 04:17:21 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38540 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfA0JRU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jan 2019 04:17:20 -0500
Received: by mail-wr1-f65.google.com with SMTP id v13so14592778wrw.5
        for <linux-crypto@vger.kernel.org>; Sun, 27 Jan 2019 01:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G/cXfni8tC087b78yKP77hOg0xmVLVtxIh5Ne/oqtbI=;
        b=CgF/Io8Rul3HwRKGuljVs2V0IcBHdz7kEXJPBSfz8qtJDIBrQHsbFJaNlBS2RODl3C
         Lq4ZL2T9PPQ7H6HGcMwCcTEmBFctsznC8u03Mjr+Ml2tBRH4gLAtZMTaAfSLcE6VG4z2
         GbInX3fWlhiwulKzWbMysYKydEuox9VZZVN/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G/cXfni8tC087b78yKP77hOg0xmVLVtxIh5Ne/oqtbI=;
        b=UyBNyBB2wfgZaZzk21Ghsc6qHGhscyTWoPKJjtOERpC0Eb0TVXigWk2gri4zvmLvb/
         lJZrXalgDDEUE5kKs07552txnGWBJqaA066Iw68MtWA6T2+mDf4P0zWpxOiFTZUGXSFJ
         WLHaRnKpIc8OqjuI7PhxzX9B4a//qbi6cg3eYE7MEOnLQcVKYP342jiUrSinRFTrjHxo
         onD/RKDszZrMdWg1Lh/6KYqK5kb9sH1Ef2BJtFRcio9vYXBU2Dii4z5CDuMvwhSy7pLk
         Fu6xqRxyBiczP6/UM6+hDMktf2xIPJ5lOcvHjLanwRmu6cIeAsh4cXvlfvGnSMT/Yddi
         Z/SQ==
X-Gm-Message-State: AJcUukezkLrn1fu8Tmy2GBVhTccabFFGzvm9NLt6CnUxLpv2iJPu1tmh
        mva3HJG8KgoAQrZeHRahwQsRTnAe1Ud+rQ==
X-Google-Smtp-Source: ALg8bN5PaFo7l6DPGI5mROPqb7PvE/mkfUbmorXFNBCNUoXuoNZ5mquXBh66keUFYiWOH0bRovtlgA==
X-Received: by 2002:adf:dbcb:: with SMTP id e11mr18293645wrj.58.1548580638478;
        Sun, 27 Jan 2019 01:17:18 -0800 (PST)
Received: from sudo.home ([2a01:cb1d:112:6f00:887d:32e9:9391:d3bf])
        by smtp.gmail.com with ESMTPSA id o5sm45397013wrw.46.2019.01.27.01.17.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jan 2019 01:17:17 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 4/4] crypto: arm64/crct10dif - remove dead code
Date:   Sun, 27 Jan 2019 10:16:55 +0100
Message-Id: <20190127091655.6262-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127091655.6262-1-ard.biesheuvel@linaro.org>
References: <20190127091655.6262-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove some code that is no longer called now that we make sure never
to invoke the SIMD routine with less than 16 bytes of input.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crct10dif-ce-core.S | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index 9e82e8e8ed05..f7326259c40d 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -497,7 +497,6 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 
 	cmp		arg3, #16
 	b.eq		.L_128_done_\@		// exactly 16 left
-	b.lt		.L_less_than_16_left_\@
 
 	ldr_l		q10, rk1, x8		// rk1 and rk2 in xmm10
 	__pmull_pre_\p	v10
@@ -509,16 +508,6 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 
 	add		arg3, arg3, #16
 	b		.L_get_last_two_regs_\@
-
-.L_less_than_16_left_\@:
-	// shl r9, 4
-	adr_l		x0, tbl_shf_table + 16
-	sub		x0, x0, arg3
-	ld1		{v0.16b}, [x0]
-	movi		v9.16b, #0x80
-	eor		v0.16b, v0.16b, v9.16b
-	tbl		v7.16b, {v7.16b}, v0.16b
-	b		.L_128_done_\@
 	.endm
 
 ENTRY(crc_t10dif_pmull_p8)
-- 
2.20.1

