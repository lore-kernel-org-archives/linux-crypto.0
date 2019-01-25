Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8EBC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 08:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B1EA2184B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 08:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="SPkraV46"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfAYIt1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 03:49:27 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45455 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfAYIt1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 03:49:27 -0500
Received: by mail-wr1-f67.google.com with SMTP id t6so9323675wrr.12
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jan 2019 00:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QFSZhvF+yrpzjeTHaCnpll1v88xs3SlfZeNFA3N5zyA=;
        b=SPkraV46WkjaW96OwSsLHJMGUz4QGmjYGjX4wvViBe4uTu0FlvEpLmiXh907DhbGxt
         K7cM8SNRpdVFV8YkWhm+E0Ugw1qjVVx0Irlc+nyFjBhcmTQY4sURfRa+4HUejlv6+RdM
         XxVs1X/+XrwY1jjHIUfVix8D5cbTYvwWYgaeA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QFSZhvF+yrpzjeTHaCnpll1v88xs3SlfZeNFA3N5zyA=;
        b=K8PNHvDtu5QMsI8TfJ87R4b5CmVRSjVNX7mNnLy/PAhr/4sLbfJ3BkPWy1GazP2AN0
         02lMMadlYK2KqmbABLv6wDHTD96FQa3S/j1oeRnpa1BGn74ar4VC3Zz0EOobClJ5uZ2h
         asZWB1vpIZjtCLqmrwVStTltHbK/0b0RreZmt0Pd5pDG+IzOWpfGf5J1FPVK16Za++jM
         tWI8V1UUw0F4Gy43Bd4awtWYCgyGKW2uLCMuqINEhqazRCVBJsrHapps+ApOT6tYbu9Q
         N6vD5UywgRbPL/z7YONkxPh6p1Zw3yJPTbSAgR8amDSIJZjJ8IrY9/l8hebUrOz7CYHP
         zKkQ==
X-Gm-Message-State: AJcUukd8CMt2ukF7wR3pcrWnvXAlaKIPN+3Sph+zYYe7YVvJYQVkoPAe
        W8ivMGFVRRDHWnt2lTHuXnHYQmVw4gVa7w==
X-Google-Smtp-Source: ALg8bN4E27F/EvY+d21USspOx5C4QpSR+ymFl6dX/SHKbCQiDY4T0CwMUi4CpB3PoLhC1xYzqOFIyA==
X-Received: by 2002:a05:6000:12c4:: with SMTP id l4mr10349471wrx.134.1548406165286;
        Fri, 25 Jan 2019 00:49:25 -0800 (PST)
Received: from dogfood.home ([2a01:cb1d:112:6f00:bcd4:806e:230a:673e])
        by smtp.gmail.com with ESMTPSA id 125sm112594574wmm.26.2019.01.25.00.49.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 00:49:24 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 4/4] crypto: arm64/crct10dif - remove dead code
Date:   Fri, 25 Jan 2019 09:49:15 +0100
Message-Id: <20190125084915.25411-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190125084915.25411-1-ard.biesheuvel@linaro.org>
References: <20190125084915.25411-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove some code that is no longer called now that we make sure never
to invoke the SIMD routine with less than 16 bytes of input.

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
2.17.1

