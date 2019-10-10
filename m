Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B023C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E2E221920
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bQzvJTB8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfJJSYE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 14:24:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37299 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfJJSYD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 14:24:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id p14so9069852wro.4;
        Thu, 10 Oct 2019 11:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dXbxgE6IvVwjy7Z7gvOGJEOv7GKvY5T5anjn+ffzgGk=;
        b=bQzvJTB8qC7u7C1JtmsouLn+KP418i/G56OMyMJXZstuB+aXGCC7k7akIuWs4qd+AC
         u25R1WgrB7eA97QlFO8sJXseglKHCwhDfJX3xt3UaCzV/2XIY3rTtpyGEnCtRub7rNmS
         3EnxRnHMsgJXNGHAZPz81tpcsHUl0yJxZjE60RH1z0DY1OVtfvwRn6dI0VYwYfBAUwSR
         MrOFdQe+o2wtbXQ0Ya8KsGQboNUkra8aW4aGOYnIs57oQqM+UfpQrkl4NlmuG0Dg6Hq+
         ABgKVZ2AChEwcnStQTbOEt/lWuMoib7ENDcsSnB1nDS3LafCHfyHyRnNt4F625a1uDgw
         BeVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dXbxgE6IvVwjy7Z7gvOGJEOv7GKvY5T5anjn+ffzgGk=;
        b=G2K+clhH/nzU+lhWWHx4sBMtcOsWGhgHPoTSRylk0XgRn3Jt5O0PTbDySCcc/7fpKK
         JyrIPW9MLkGszrBMEKH1/b557L+7vljlH5+Al2uDaN3HYz/WIMOkQQToBdYFNJtT7Uud
         VD/Si9K9T1SvLEH5WqKbuVPFJ3v/nRwlez4WDGv79u3HyHilwAWcTLa7k0JI3I1fFJ4E
         NASaUWVyhy4xjnk3pUfDNF1piUIWgdWqIKOwPssrnd2DYwCmXbZq+RnsxpetVqvxhXsw
         oOh5iSQMF1ZCSC09peY/wIYYIBjb0j2dgbTfNqW4ISwmNuCbbMLhYbqie/UcdJxyrO5k
         aG7Q==
X-Gm-Message-State: APjAAAWn1yIQcGWH2qheueaO3XkZLWmRmI0NpWxYnped1pR9aCAls49b
        63o/jHCeW7KKzMhwKDa/lUY=
X-Google-Smtp-Source: APXvYqy6aLVBJ7a1cy+OQbhapwaL8GSDbU2K0JXUHvRBkxooMg5EzYFtZ/rclbK2t3qp1Z55ITRVXw==
X-Received: by 2002:adf:ecce:: with SMTP id s14mr9299104wro.47.1570731841237;
        Thu, 10 Oct 2019 11:24:01 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y186sm11367664wmb.41.2019.10.10.11.23.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 11:24:00 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 06/11] ARM64: dts: allwinner: sun50i: Add Crypto Engine node on A64
Date:   Thu, 10 Oct 2019 20:23:23 +0200
Message-Id: <20191010182328.15826-7-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
References: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Crypto Engine is a hardware cryptographic accelerator that supports
many algorithms.
It could be found on most Allwinner SoCs.

This patch enables the Crypto Engine on the Allwinner A64 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 70f4cce6be43..e5d50978a6b8 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -478,6 +478,16 @@
 			reg = <0x1c14000 0x400>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun50i-a64-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "bus";
+		};
+
 		usb_otg: usb@1c19000 {
 			compatible = "allwinner,sun8i-a33-musb";
 			reg = <0x01c19000 0x0400>;
-- 
2.21.0

