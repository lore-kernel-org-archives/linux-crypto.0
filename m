Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A5FC33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 16:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F7F42087E
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 16:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579193506;
	bh=iw+zIid3D37r/9X/VDFDJgW7dHV4hqA+p5fH4rA1mNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mt6ZjgQM0pYZXsS60pLoi7j9dOGP+f/OjHBfHMiDMN6enZUroHhXanT0sLEwgi7Kz
	 PtY/s6jrnZdjFH2DN1J134yblSZZzLjlAyeeE/xlc0hBzVDOCAfJOgl3RGY4/xnFIY
	 OeA1djbKjW1/9OxqHTVKW/etMU8NJ2d5wl3sHhnI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgAPQvq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:51:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbgAPQvp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 11:51:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6078205F4;
        Thu, 16 Jan 2020 16:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193505;
        bh=iw+zIid3D37r/9X/VDFDJgW7dHV4hqA+p5fH4rA1mNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9ScuHI9lN/g3ZjhXYrOZ6UgeWyW3/wEVbVVkC85CG+U05Aui6/JYtSmbb4nopHnE
         PbmDD4C2PysSPvVXPtm6VipCQPuD9hrb/WTwddSJA/yd9mRJV+e0DbKKsh1jV77obO
         ny4rOw8R0qfFUm4PgS28QXxO3uLc20MRJMyWvatY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 092/205] crypto: amcc - restore CRYPTO_AES dependency
Date:   Thu, 16 Jan 2020 11:41:07 -0500
Message-Id: <20200116164300.6705-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit 298b4c604008025b134bc6fccbc4018449945d60 ]

This patch restores the CRYPTO_AES dependency. This is
necessary since some of the crypto4xx driver provided
modes need functioning software fallbacks for
AES-CTR/CCM and GCM.

Fixes: da3e7a9715ea ("crypto: amcc - switch to AES library for GCM key derivation")
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8eabf7b20101..7316312935c8 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -333,6 +333,7 @@ config CRYPTO_DEV_PPC4XX
 	depends on PPC && 4xx
 	select CRYPTO_HASH
 	select CRYPTO_AEAD
+	select CRYPTO_AES
 	select CRYPTO_LIB_AES
 	select CRYPTO_CCM
 	select CRYPTO_CTR
-- 
2.20.1

