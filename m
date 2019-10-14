Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124CDECE58C
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF4E821783
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:19:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BD+S0sfz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbfJNFSw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 01:18:52 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53226 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729706AbfJNFSw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 01:18:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id r19so15712115wmh.2;
        Sun, 13 Oct 2019 22:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IYELzo9paCdNSHZmbtgi4XuRP3zt69X3tMzTrt8WAxw=;
        b=BD+S0sfz4B7A/bxxA6b4D/PzrFOg/tbJ6HIHK6u8MQCD5Y6fmIxJlq7XsFAih10qFc
         fe+7G+8Oq7sseBQX30ziTyxqsqKOnX1+lj4Di4mwwp4zxrcpvGFD2Au6c+XoKTnhxtFh
         aOwDZgV/o/jeeInR/ue6gDpFrOYcsEn67ZBKYx9u3JNVojcx5qMKOwy/GgZtb3sQ6/FK
         bexRD373A4R0XwRpS+/pkfx5dS6Fx1ujfkeCxV/SvFFTtI4ZHqZFARwzri4sAHt/j1MU
         FKn9U3Do26GNlOWfYg7E4d1jfyVWzTQni+tBYRsoTjmL2ODBxKYwQ3T1h3b6rf9vsDg/
         e14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IYELzo9paCdNSHZmbtgi4XuRP3zt69X3tMzTrt8WAxw=;
        b=mOXQxff7vJfHaAYIs0dGPp2Y9scHPyOWp2wMWfQ5fFvkN64ZsrmJqxhItd8zpeqKQL
         ndM7rFhGRT8mx1BT0qMKSJFp8qFbMSoH40OAziGUjPZDcdMSg+kb9NNbi8nX+tFyb1Na
         X24qhgpPAgZ6SP9dEnoGDBAREi8Fn2L5XTALo5HNu65BNuQfK1vhRPIEt8mdwFIoPG+x
         cJiUVHUng9Ak9jVopX9zyy4dxTM3p7btg3v1uIhLfWwjfM/9CDqaUScxcuPSrIO+Ib+O
         fwC/LeoIOgkSYwmC8sQ5j62zZqXaL+Iz5kdGkFtSZLQMma98f4voE5xMUREo5XTcYUbe
         SVdw==
X-Gm-Message-State: APjAAAV+JSzgLt0NRFQr1biZJgyNf2Jt0TFU8LdcMoAavF+FSBkl6HSq
        f89G29cpi60iHlShfHnoXyI=
X-Google-Smtp-Source: APXvYqzDeIQMzuATD9N9pJOIMujxL8TUHVaFwMZVR/+YhNBw4jMhgGwy4f0S8CRJNje0FHxlYVxgMQ==
X-Received: by 2002:a7b:c8c5:: with SMTP id f5mr13251625wml.170.1571030329786;
        Sun, 13 Oct 2019 22:18:49 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 5sm14660340wrk.86.2019.10.13.22.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 22:18:49 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        khilman@baylibre.com, mark.rutland@arm.com, robh+dt@kernel.org,
        martin.blumenstingl@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 4/4] ARM64: dts: amlogic: adds crypto hardware node
Date:   Mon, 14 Oct 2019 07:18:39 +0200
Message-Id: <20191014051839.32274-5-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191014051839.32274-1-clabbe.montjoie@gmail.com>
References: <20191014051839.32274-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds the GXL crypto hardware node for all GXL SoCs.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index 49ff0a7d0210..ed33d8efaf62 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -36,6 +36,16 @@
 				phys = <&usb3_phy>, <&usb2_phy0>, <&usb2_phy1>;
 			};
 		};
+
+		crypto: crypto@c883e000 {
+			compatible = "amlogic,gxl-crypto";
+			reg = <0x0 0xc883e000 0x0 0x36>;
+			interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
+			clocks = <&clkc CLKID_BLKMV>;
+			clock-names = "blkmv";
+			status = "okay";
+		};
 	};
 };
 
-- 
2.21.0

