Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 856A0C43215
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 14:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5921B20718
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 14:48:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Os9bzdSg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKNOsf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 09:48:35 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52350 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfKNOsf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 09:48:35 -0500
Received: by mail-wm1-f67.google.com with SMTP id l1so5954805wme.2;
        Thu, 14 Nov 2019 06:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ggk/mvnlQ8Jt4FcutNAyCyRhydpHaULB3AS25CsNBLk=;
        b=Os9bzdSg8XJne/XanYWGrKRoigS1FkiDzKmNjJ4IhWXIRhZ+Yqc2Es3G9k4Fxs1Dz3
         GpXSy7NM5gL18ExW9ugW+WGGSm5wZIO/qxRRpxRBTExh1phz2aMozmOIS1sVGzER7hNb
         cDeztSQTwxWaBFBdueT2PmqbJvPbI7RL2Vg2PZVgCuSe1Q1KrNfuRZWp4N4P2/ZBO/Ab
         +zatx/g77SSn0ltVMgRBt+nkncmovSIJSp/rfub0qpA9zQRCV8VoMZf+FNIHKtDE5GFe
         XUz25dd2fXQ3tEVNWhMjHlcLafgdnyffFpIWEKj3MBt1a5hyvAUvOdTRPe+t3PR0XMHL
         VeGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ggk/mvnlQ8Jt4FcutNAyCyRhydpHaULB3AS25CsNBLk=;
        b=O0A0zfyRy28W9DvZuUQlI/7WrZoj+VX5rIBIqIw1fQvd18MlsWngRSGwpP+oVHN7f+
         0Lc2jlJ+/b8vmlRHU9X79kAUumhb4N/r/E34+GbC3B3iLN0w70SvBzqL4DlBLhUrzUsM
         hjX9R1kdKKDG5VcVWjnlnD22TUqYnIBsoPejVKXvESPoX6BoPsUfF/FFTsZvZiVP0WCW
         9XU9g8XxejfemRG3yA0/lE29n7EyPirQzxdcNxgOOo0NSMyEaaVB43mOoIhwmtIiSklt
         op/xr42oKm40M1iroPclFaSyifqWNb8/lr+jHHVkPgFfaedMEEHPUJfFH3jSXNSBSceM
         7wRQ==
X-Gm-Message-State: APjAAAWNJoxu6kAE7+Pg2BYJUdRd9Ns0hWQ9iSg82HugQC35yV+6K2RV
        5CARM2ywxCPTFirUi42VppY=
X-Google-Smtp-Source: APXvYqxDRQ9TrW0gvpev6smmX5yzgSdLocWJ9OZ8fPvJlZ7ZOgn1OoUyW7Mqe0RPXBhADmvAM1tbIw==
X-Received: by 2002:a1c:96d5:: with SMTP id y204mr7999297wmd.63.1573742913360;
        Thu, 14 Nov 2019 06:48:33 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id v9sm7153223wrs.95.2019.11.14.06.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 06:48:32 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/3] ARM: dts: sun8i: a33: add the new SecuritySystem compatible
Date:   Thu, 14 Nov 2019 15:48:11 +0100
Message-Id: <20191114144812.22747-3-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114144812.22747-1-clabbe.montjoie@gmail.com>
References: <20191114144812.22747-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the new A33 SecuritySystem compatible to the crypto node.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun8i-a33.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-a33.dtsi b/arch/arm/boot/dts/sun8i-a33.dtsi
index 1532a0e59af4..5680fa1de102 100644
--- a/arch/arm/boot/dts/sun8i-a33.dtsi
+++ b/arch/arm/boot/dts/sun8i-a33.dtsi
@@ -215,7 +215,8 @@
 		};
 
 		crypto: crypto-engine@1c15000 {
-			compatible = "allwinner,sun4i-a10-crypto";
+			compatible = "allwinner,sun8i-a33-crypto",
+				     "allwinner,sun4i-a10-crypto";
 			reg = <0x01c15000 0x1000>;
 			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&ccu CLK_BUS_SS>, <&ccu CLK_SS>;
-- 
2.23.0

