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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40963ECE58D
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17E9821920
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JbWgnsDu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfJJSYG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 14:24:06 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43192 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfJJSYF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 14:24:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id j18so9043708wrq.10;
        Thu, 10 Oct 2019 11:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LKdxoiXO2qcL2j7u49KVkFwVEXUyQJUfWzDkZKrEpxA=;
        b=JbWgnsDuMhLpVCjb+YdJezFjZG8aXtqnOKnJXXWeKs7moUL5bxI6rQpxAQ7KEawMWh
         sPtpY6fMpMZIJLHl99Z0xBpbzmjsMnI4twZIUMajJ+QVKz1pHi3I0wv+u28p+18X/Ab8
         mQhU0Z8IBU/kHkULCMgYxZYcFdLgzBYRDD2oynFkHbgBq6cyPMDQQT/b0pXWo3PQV8S2
         WcNI2/uaDmFEo7l1GIusjX3GYEYu2We6fd0uFKuAVZuA7IyCwYjcrj3RSvpuBbBXRztg
         3fgzz+50Jk4oFOoAc/7iHdNucBVVI5zInrZ7lj5WObSsD8XI1Rd7CDLTCJFiXgXP9V1q
         0hnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LKdxoiXO2qcL2j7u49KVkFwVEXUyQJUfWzDkZKrEpxA=;
        b=fHHQ3U6n8CQkKP6NvEhJfWl3MFQNw3k4kSjo5qK1RZyRPtNDRelosPfvGjaiqiXuJv
         SVusqAQcn6YIJXxr5O7yeqStR29CVZ6dpSqFyMthL1Qrul00yhWQLuMBADszWndPfVvo
         E2rA6CRBEctURSQGK6QENbTiw02VBKjYqDUPLNhRCHO20lRptgYc8pIpBgrjWYOPk5ht
         5SPGcrFjIuCoxAnQ1LSxW/gG84fEOalR2iSz9jGiNLioeZR6Zmp6io9XIVNJMd7XzylB
         aNvIKfhRdbsz2jG8sdymZshgR5Pqbbe+gLZ0+Sp030PlcrmCYXQsfdEzXCsmiv56VBr0
         6NfA==
X-Gm-Message-State: APjAAAWukYH2LWIlGh8aQ8Apw/GSAjqh6WXL671wyVvHZOA6pKL5Ki3L
        B58fnmJ1SO70mKk5z6URVDo=
X-Google-Smtp-Source: APXvYqz3MCgqtkhNoSBxMkDnoDYLi2oXfF1XS84vQAfiTka5MhJvT1m4xOCTpFmxMe4HuKqops47tQ==
X-Received: by 2002:adf:f90d:: with SMTP id b13mr9538028wrr.316.1570731843957;
        Thu, 10 Oct 2019 11:24:03 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y186sm11367664wmb.41.2019.10.10.11.24.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 11:24:03 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 08/11] ARM64: dts: allwinner: sun50i: Add Crypto Engine node on H6
Date:   Thu, 10 Oct 2019 20:23:25 +0200
Message-Id: <20191010182328.15826-9-clabbe.montjoie@gmail.com>
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

This patch enables the Crypto Engine on the Allwinner H6 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 5d7ab540b950..68697cef8e5f 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -149,6 +149,16 @@
 			allwinner,sram = <&ve_sram 1>;
 		};
 
+		crypto: crypto@1904000 {
+			compatible = "allwinner,sun50i-h6-crypto";
+			reg = <0x01904000 0x1000>;
+			interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>, <&ccu CLK_MBUS_CE>;
+			clock-names = "bus", "mod", "ram";
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "bus";
+		};
+
 		syscon: syscon@3000000 {
 			compatible = "allwinner,sun50i-h6-system-control",
 				     "allwinner,sun50i-a64-system-control";
-- 
2.21.0

