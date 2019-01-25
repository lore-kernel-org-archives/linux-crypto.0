Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2620C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 08:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C195D2184B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 08:49:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="WOkV3jNP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfAYIt0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 03:49:26 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52257 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfAYIt0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 03:49:26 -0500
Received: by mail-wm1-f68.google.com with SMTP id m1so5926616wml.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jan 2019 00:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3i4VSVBNJKNuInAMRTH6x98wcOlfnlNxdkcXRyELG3M=;
        b=WOkV3jNPR1KFdSATKSBt83Av+J5wm3/Fl7piyMS0+79fo+majgdNlXYpBLPEBOjs3f
         vJm6vW4JmUFftUoNnMGe5FbZym5jkf2NiN6H/butQcBl/U7UElpctMFACibJpfmBJn7L
         uMMRpCu3uvFsNAr/os/SvoX0EGx/RFxdyDrjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3i4VSVBNJKNuInAMRTH6x98wcOlfnlNxdkcXRyELG3M=;
        b=OhdolyTZDvhTiL7zB3Oa95rMJ6ASmTbH96MZsZPVpUf314vexMWghIkUxyz8VeWWPt
         3y5LtShc8SkDaFMiXyNCylsvLEFQhzJjtuszK8JsuS9jOigR9t0S3XFlW2dU+DSnWfzZ
         KZvKMC8qhgRUWP+j0DBDMlOcOvDPRCG/BNNcTcmiOEW/DfCJvSf/loeRQpSvd/KiKJ+m
         LwwPszYxRIb2WLoeKcGdXhVh38Z+i838vzxdUjxHmpIXJHUPVFECfVFJ3I3PufzR8Ql0
         +S3TNOJoTy+YJO25qm8N+bOPBi9an4ookbAWvJr9Ps6YAvpnE2gSM9eIy/9EB1YBWfL2
         iSwA==
X-Gm-Message-State: AJcUukdm9d60RU6TcJGXo9K7CMWDzo8qnU2jjgBvO3PXU3KuCryZIKzZ
        BxL2RHd6ekfXW8hOn5+fPCoINef3pdCP6g==
X-Google-Smtp-Source: ALg8bN5yG8VMjw023AkQ/AMmf2MX+4ykzzQvDE3Yd6enJgPt+TEHVaBIa3Ieb2e3vAY8244r90NbuA==
X-Received: by 2002:a1c:570d:: with SMTP id l13mr6050823wmb.139.1548406164011;
        Fri, 25 Jan 2019 00:49:24 -0800 (PST)
Received: from dogfood.home ([2a01:cb1d:112:6f00:bcd4:806e:230a:673e])
        by smtp.gmail.com with ESMTPSA id 125sm112594574wmm.26.2019.01.25.00.49.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 00:49:23 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 3/4] crypto: arm/crct10dif - remove dead code
Date:   Fri, 25 Jan 2019 09:49:14 +0100
Message-Id: <20190125084915.25411-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190125084915.25411-1-ard.biesheuvel@linaro.org>
References: <20190125084915.25411-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove some code that is no longer called now that we make sure never
to invoke the SIMD routine with less that 16 bytes of input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/crct10dif-ce-core.S | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
index 16019b5961e7..d058fad423c2 100644
--- a/arch/arm/crypto/crct10dif-ce-core.S
+++ b/arch/arm/crypto/crct10dif-ce-core.S
@@ -342,7 +342,6 @@ CPU_LE(	vrev64.8	q7, q7		)
 
 	cmp		arg3, #16
 	beq		_128_done		// exactly 16 left
-	blt		_less_than_16_left
 
 	// now if there is, load the constants
 	vldr		d20, rk1
@@ -353,18 +352,6 @@ CPU_LE(	vrev64.8	q7, q7		)
 	addlt		arg3, arg3, #16
 	blt		_get_last_two_regs
 	b		_16B_reduction_loop
-
-_less_than_16_left:
-	// shl r9, 4
-	adr		ip, tbl_shf_table + 16
-	sub		ip, ip, arg3
-	vld1.8		{q0}, [ip]
-	vmov.i8		q9, #0x80
-	veor.8		q0, q0, q9
-	vtbl.8		d18, {d14-d15}, d0
-	vtbl.8		d15, {d14-d15}, d1
-	vmov		d14, d18
-	b		_128_done
 ENDPROC(crc_t10dif_pmull)
 
 // precomputed constants
-- 
2.17.1

