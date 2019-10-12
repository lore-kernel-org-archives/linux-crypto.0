Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72772C10F14
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F54A20700
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dzzB+q06"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbfJLSt0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 14:49:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38811 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729655AbfJLStK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 14:49:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id y18so5794976wrn.5;
        Sat, 12 Oct 2019 11:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=44TuELDtNCusYZupj5B8B0t5vnjX1mlerc4abRfeM5Q=;
        b=dzzB+q06UqsEKkd/hCvau1TGM+qAedC7qRk2up+oQYXYidRqXwKi+IujeOcbW8Tdza
         +y9qtXZG02ID99EELK1Qp9UnnYeXSm4jQ5g1hmK5M9Tyn4PRNNjEcXV9j8X9PHQPLlRV
         FCU3qiXrrfvlgF0CNS1aw7imeHDPVLVGJhB4kqiWUGaC4jZNqa68fUOOR075Kf+Y5S98
         Zjo1CJAwrdYWwGlFzoD6839RfGyvQI2ue4l2PIoRJ1W7Vf0fjCDeaj0TLPcAFHa8jMc3
         MiK2mt3Dl7rzrG/mQ/MOOiXXzCTaS5dat5W4zYj/AERzXrc5XgRwZ+qCprTOnRQ5ZzOb
         eiaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=44TuELDtNCusYZupj5B8B0t5vnjX1mlerc4abRfeM5Q=;
        b=ixOYt1PxY9AskthZzbn2H2Wc/+OK1urO8UvzPUA1UMZvEVMCdYhnPD8Pn8P417QGkO
         qf8CwLS5B6Pvz5OsxYHz9rr81aUYnxDjwaOZ0LdL+FRYHBR2IOaykhtHFtu1rfFltHol
         4/KNdrhYOtllyfRNIz3oCarJGyJ+GROPhqh3JLGUD41VK3tDLwLvTsWiTvS4F2b3Bnrp
         GGYKUDZVCdVN4BZXtUqRhKQHNkvrpb1rz2qxwfAE/OtIlRzwBTJJWCzp6a3SAkx5zzJV
         EvjokPoFsckCsxdO8FdsvTr3ty25TzMoLivSQRKG6YxMecvjSbHqa1VrpDsa7VmbYBDw
         OwZQ==
X-Gm-Message-State: APjAAAXlLkIAuoELLIYyjUBy93wI6W9E4nCSUt0l488jO+BmZ1Ij2gA7
        HRHqtEdxzWnvHAyYDFXiOSE=
X-Google-Smtp-Source: APXvYqyy/UEDWZoan35QEd0/+NNFjoMtsEhnijIS1wPhQdHMbMDEHQjZNxamZHffRDjdA8nBUhNxeQ==
X-Received: by 2002:adf:e90d:: with SMTP id f13mr18611162wrm.104.1570906147711;
        Sat, 12 Oct 2019 11:49:07 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a13sm33670580wrf.73.2019.10.12.11.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:49:07 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 08/11] ARM64: dts: allwinner: sun50i: Add Crypto Engine node on H6
Date:   Sat, 12 Oct 2019 20:48:49 +0200
Message-Id: <20191012184852.28329-9-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
References: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Crypto Engine is a hardware cryptographic accelerator that supports
many algorithms.

This patch enables the Crypto Engine on the Allwinner H6 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 5d7ab540b950..89d09b441abc 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -149,6 +149,15 @@
 			allwinner,sram = <&ve_sram 1>;
 		};
 
+		crypto: crypto@1904000 {
+			compatible = "allwinner,sun50i-h6-crypto";
+			reg = <0x01904000 0x1000>;
+			interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>, <&ccu CLK_MBUS_CE>;
+			clock-names = "bus", "mod", "ram";
+			resets = <&ccu RST_BUS_CE>;
+		};
+
 		syscon: syscon@3000000 {
 			compatible = "allwinner,sun50i-h6-system-control",
 				     "allwinner,sun50i-a64-system-control";
-- 
2.21.0

