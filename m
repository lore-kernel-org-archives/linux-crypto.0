Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FF8C7619B
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76CD22470C
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oXNQSHd8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbfLMPj1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:39:27 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43265 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbfLMPjZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Dec 2019 10:39:25 -0500
Received: by mail-yw1-f67.google.com with SMTP id s187so1402463ywe.10;
        Fri, 13 Dec 2019 07:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=faL4fxrbC05HIHUTwDCWI1dvLvUSDjG03Flb8SzrLH8=;
        b=oXNQSHd86d/tmceWqTGR558AlsJ2egWE0oMQLzhFX0wG7k0h+k9pXRqUYYj7t4UunF
         lZOxKiHajcdSdXfGeeRutpYG7l1gzbqwHtjC18Md6l0UosyyLe/AJo2llVEDmSs2Apcy
         SNmmVA1GdJK7f5M76159d0DmCAhIbSDZgYWkafNPJ//AZTokA9Weix/2ESFYo2KydViq
         fzecdysxqcPIyfBwJE5kuDHgV18C48xN8ZRHAJO05dJDndAMCTCF8h+AUoFuOVVDE+4G
         1si2SWR7YqiRPYBWCSYbPrevK1F6kzJmIhnjYaiUtwgslszzxjDTteePwt8KdViaRlnD
         96Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=faL4fxrbC05HIHUTwDCWI1dvLvUSDjG03Flb8SzrLH8=;
        b=kqi12hb+mB5MPa5LuyoGzPRmuTIZuw3+rQz29JGSAxZA+Z5uIC5l2JaEaAOQFnoeEv
         E59XpF9Er++am2nnQV79Ff5rmmOFgcu5uRMaFdV5d/s3giaaSnHbYcLj+qqn5P/iNzcV
         ive/VN/06g5hIaNT301S+du1BomNczPMjXio40U2ik4jIjxtrEsnpNM2TA6XdSMFK2sQ
         cNQVPXd74IJ0BoWi4w4T6u8gFtNIamkYEt9P8vRtLupeI0Tr+1WzCxVjkHy4GCI372Vo
         3OKIlbbrlE2NCzrkXR3BT2Qu1b86okj7Yi5xaBSnhkFOwIF36Ai2euI8UXOtREWXKoJG
         f8ew==
X-Gm-Message-State: APjAAAXrVDB8SVMdcWg/KnztUfKovPowP23COuJNh+JlG80Ig9uZ10q7
        QKtHUXu2KEngxhIeieMFlaM=
X-Google-Smtp-Source: APXvYqzsMZhR+ug4aRPHSvjvIJVkEj72cpT+DpcfyV3rG/uXTykso2NKhi2h4s4rMHV1FhFPykZ4pg==
X-Received: by 2002:a25:6c86:: with SMTP id h128mr8532669ybc.53.1576251564652;
        Fri, 13 Dec 2019 07:39:24 -0800 (PST)
Received: from localhost.localdomain (c-73-37-219-234.hsd1.mn.comcast.net. [73.37.219.234])
        by smtp.gmail.com with ESMTPSA id i17sm4300474ywg.66.2019.12.13.07.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:39:24 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     horia.geanta@nxp.com, Adam Ford <aford173@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH V2 3/3] arm64: defconfig: Enable CRYPTO_DEV_FSL_CAAM
Date:   Fri, 13 Dec 2019 09:39:10 -0600
Message-Id: <20191213153910.11235-3-aford173@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213153910.11235-1-aford173@gmail.com>
References: <20191213153910.11235-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Both the i.MX8MQ and i.MX8M Mini support the CAAM driver, but it
is currently not enabled by default.

This patch enables this driver by default.

Signed-off-by: Adam Ford <aford173@gmail.com>
---
V2:  New to series

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 6a83ba2aea3e..0212975b908b 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -845,6 +845,7 @@ CONFIG_SECURITY=y
 CONFIG_CRYPTO_ECHAINIV=y
 CONFIG_CRYPTO_ANSI_CPRNG=y
 CONFIG_CRYPTO_DEV_SUN8I_CE=m
+CONFIG_CRYPTO_DEV_FSL_CAAM=y
 CONFIG_CRYPTO_DEV_HISI_ZIP=m
 CONFIG_CMA_SIZE_MBYTES=32
 CONFIG_PRINTK_TIME=y
-- 
2.20.1

