Return-Path: <SRS0=+ioq=2Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDA8C3276F
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Jan 2020 15:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6209F24655
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Jan 2020 15:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578151365;
	bh=Ym8SYG07h6MSMiq3hCZsshutvz9c46Tk7032If5mw2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=q7yAkvRh9TIeJayTtxMcmvuVPLNHsU0NIGbMi5hJZbtuXRgwxSFAaamFVXxonAqgW
	 h3RgSkQnJpn27O8TzbiYjDDzPqoeNC70NRkls+93wE+6+y1CQv47e909ylY4AKo9Kx
	 Ed5CoSXMFeY0/iUhU0H9E4551E3vHrxZ04UgnBbI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgADPWl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Jan 2020 10:22:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgADPWk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Jan 2020 10:22:40 -0500
Received: from localhost.localdomain (unknown [194.230.155.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 903CB24655;
        Sat,  4 Jan 2020 15:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578151359;
        bh=Ym8SYG07h6MSMiq3hCZsshutvz9c46Tk7032If5mw2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YC29VBJo024Lx3valzVs8SaGm5VfUau3M8ZqcOuIDHKioew0hsMBefxcaLYXkHUYu
         QCRcZ9kU7HPgODeaIJCJNSUHYQ3+DAbcRxT3PehjE01Qf2bk3/shyQa93F/LhCBN/X
         IMXazKPWUe5zeh0OsneZR+qN2aT/j5aOp6jEdes0=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 12/20] crypto: exynos-rng - Rename Exynos to lowercase
Date:   Sat,  4 Jan 2020 16:20:59 +0100
Message-Id: <20200104152107.11407-13-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200104152107.11407-1-krzk@kernel.org>
References: <20200104152107.11407-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix up inconsistent usage of upper and lowercase letters in "Exynos"
name.

"EXYNOS" is not an abbreviation but a regular trademarked name.
Therefore it should be written with lowercase letters starting with
capital letter.

The lowercase "Exynos" name is promoted by its manufacturer Samsung
Electronics Co., Ltd., in advertisement materials and on website.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index d02e79ac81c0..de0b40889680 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -430,7 +430,7 @@ config CRYPTO_DEV_SAHARA
 	  found in some Freescale i.MX chips.
 
 config CRYPTO_DEV_EXYNOS_RNG
-	tristate "EXYNOS HW pseudo random number generator support"
+	tristate "Exynos HW pseudo random number generator support"
 	depends on ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_IOMEM
 	select CRYPTO_RNG
-- 
2.17.1

