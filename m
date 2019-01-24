Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9868CC282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 16:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68EBD218A2
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 16:33:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="kXmE1bWh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfAXQdy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:33:54 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51606 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfAXQdy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 11:33:54 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so3856416wmj.1
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 08:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OLi5gHDALg2HIynknA0SAYqbdOxodGcDILlCdC99Kpk=;
        b=kXmE1bWhgBruckURkRoo23Ne8trpq1XGAqJ40Tl7m7ukZxhzHhTfSvmrzBYjvrXia/
         5c/oS8tXAiFpxHT4kc+lEkpRnSxMOKAKRvHi21ISNWEBbmA5XC8tTuKejfYDSN2ezPQq
         +rPgTa8bEMizRgi5VobIzGTR0gFmfnuyOenCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OLi5gHDALg2HIynknA0SAYqbdOxodGcDILlCdC99Kpk=;
        b=coutmh7XdmcJ5spwCHnhVXIaaKzmhhMC5mb18KzCMvidKVt8BftgiXsvAsfioayvo6
         5NHL+yEBu1U5SoKiNYjLImRT3WK5MD09VTy9hv3oGmxsW56uHIPEK59IRojLgmywsKja
         617Ix+hMVxtTJ0dXlqjZonbRCLrII+Qk8dMG7sLMiZJtN3DN1bwyBGocqF5hzYdoLBoO
         p1wPzksub9DXTDCWRA+zok6OQ5qUfTyp6U2pQnVscKOEMc41ilXCIChO3ZxY1KwBorRO
         3MN89tRuD1IeuJ8tr/cZfgVXHMTAdyqFe86HypifjUF9VA+BFKZLyS/kjYnUqswVQ4Pz
         7BvQ==
X-Gm-Message-State: AJcUukdZ+m/HKfZRWLZQu8IX8NWO1g6azQulG7bnVlakXm6df0BB5bJj
        GgvkIvISXtCW+kjsiO4NtHz7//XjBob2Ag==
X-Google-Smtp-Source: ALg8bN5VwTHuGAF96C0j0ra0Jp4M+qLYESGcUjgk7GgHIF+7diXhmoEdAKacK6gjLgHEQMJj6kOboQ==
X-Received: by 2002:a1c:1d81:: with SMTP id d123mr3286230wmd.112.1548347632214;
        Thu, 24 Jan 2019 08:33:52 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id t12sm99629069wrr.65.2019.01.24.08.33.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 08:33:51 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/3] crypto: arm64/aes-ccm - fix logical bug in AAD MAC handling
Date:   Thu, 24 Jan 2019 17:33:45 +0100
Message-Id: <20190124163347.12653-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190124163347.12653-1-ard.biesheuvel@linaro.org>
References: <20190124163347.12653-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The NEON MAC calculation routine fails to handle the case correctly
where there is some data in the buffer, and the input fills it up
exactly. In this case, we enter the loop at the end with w8 == 0,
while a negative value is assumed, and so the loop carries on until
the increment of the 32-bit counter wraps around, which is quite
obviously wrong.

So omit the loop altogether in this case, and exit right away.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Fixes: a3fd82105b9d1 ("arm64/crypto: AES in CCM mode using ARMv8 Crypto ...")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index e3a375c4cb83..1b151442dac1 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -74,12 +74,13 @@ ENTRY(ce_aes_ccm_auth_data)
 	beq	10f
 	ext	v0.16b, v0.16b, v0.16b, #1	/* rotate out the mac bytes */
 	b	7b
-8:	mov	w7, w8
+8:	cbz	w8, 91f
+	mov	w7, w8
 	add	w8, w8, #16
 9:	ext	v1.16b, v1.16b, v1.16b, #1
 	adds	w7, w7, #1
 	bne	9b
-	eor	v0.16b, v0.16b, v1.16b
+91:	eor	v0.16b, v0.16b, v1.16b
 	st1	{v0.16b}, [x0]
 10:	str	w8, [x3]
 	ret
-- 
2.20.1

