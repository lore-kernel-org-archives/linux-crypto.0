Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFE4284663
	for <linux-crypto@vger.kernel.org>; Wed,  7 Jan 2026 08:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773192; cv=none; b=hNBNKMRYh+qZGHTDQfmDQNybrSITYiUxY5zLf5AlupdD7idJopT8WieDDHzhM6yUWbIVc/suIz3alDE63GpNaamyzpJ42xabV5vxz7xHO446vx10U2xx7Zxc35avTccpJy4f20vicZ0qi3ufFg5cW1EFbhnq0nC5SMgPtqs30QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773192; c=relaxed/simple;
	bh=ZqBIugg5K7/ysfpKey8yK6cRDkhGfiVM24dyT/kjpXc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pmy/E+rY9B3qbev8eBDGFpjWEwBRl6DMqLieGoLIV94l2yLfZ5hOYA7kx8XHW2dL3h3Y74lCwYrqwwUmSkSpoRNpvVI4k+N2K5mBImlk+bvgo5+umMabX/cGrvtymnVrZOMb/9sLUiRvR1fwy83z3jTnprZK58bZe7bB0cYE9hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=A4/y5f6a; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="A4/y5f6a"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b9cb94ff5so2473394a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 07 Jan 2026 00:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1767773183; x=1768377983; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4RvfqlwGsUfw8nkyrkO8zG6AiaNNt3piIyxZCLBKwM=;
        b=A4/y5f6aH1h3eh7GFKKIOWzPstJw1gJb9OQCynzoTI/m+gGpTwREvSq1pPiS2JF3tp
         HxXqRjnOyjB880aCuyATS8X3GTrgDd8itY6t2UPhFh9Qx4TL+AtQVjPLrv/tnlBVjOv2
         6sbXIhXf/5hqOuivBEfpQVmaz0jdk3XmhVEN4OuTQR9/1uLqHXPD6DSg+pfrI2vKcqQU
         gzuW4jx1QXB/I2bUK27cX/pWuyYbGXiRWVmi+2mMZ17hS8TK3f2tlaBijJjEluLnwIrr
         MKCMM4bFkg1po/Htoo6lIDmXa0rAcq8w3X4xhs7n0tqTurzRhR31LBHGWPhv2E9U57aq
         SaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767773183; x=1768377983;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O4RvfqlwGsUfw8nkyrkO8zG6AiaNNt3piIyxZCLBKwM=;
        b=wR7+KSSXLbTNogprXR+uc2qpLdambLUnf5pDqteYo7ad8cwKqVu6FU3l45DFWarCDA
         CaMbMXgwav5IRVPkXqvDoY6obeQsXn1KmNKa82cjG64IRG4zhxwUEWSOgcQgpRMhG1yU
         FycsM7QXbVTohmrhqamz+AFvpRo306ih59CVl2EB+Xmrqg5m0yS482taejWLq5AVG4jT
         kvmFURpS+ACDjT/4wRtKi1On2SJvOBjcVXcRmW9PrDtstC7u8SY5S6kZUae2Z/tbMfL1
         3722ZdgdPeByd1BzgMtTtfePThLQ/qbrM7jtalVfj3xPQkR/Jm9ToKRgL5hgKrx9s829
         3g7w==
X-Forwarded-Encrypted: i=1; AJvYcCUoqKLWZEpfnv7hbp6rW/l5Bvx7MCpEh2agipgbTX5XhowNQxK3YhMfsovM7W1v+x2lNqH2V6vlHxmAyII=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5trWZv0m5Qss1XSNkevwYIRvfbiWBj2rixxVX7VhqClwwu7NV
	ZSvYUMs/Q0A6RBqyJcmVn1YBt3kj8OSwTkg6+NSfFUA8mbT6FNhA1W773QN/PpvSyss=
X-Gm-Gg: AY/fxX6H+Q7HvOQeKtcqEw1DhsdnMZw8KSJlSKN3lBIO1rYvVlX1p9wlLMVditWb63J
	+5taJIOC0x+d4NLZYQShRLMnJh99//vs71X4gcaltbF+i8MDxVbREVc5To4Q8j04DyIZahWtaI2
	8TA7tpGYB633A1jKWeu3XPCQhpf6jgNFftZVv1GqFuC75CbZnDl71sCTldEKp1XUibeWbhpF/EX
	mrb6/nO41nzHXLyGq4ghFk8GJAZUR8uMAK3LDs+aJzu6ANxTjYxTGAzlrKDkMMwj/Lbix/gka1D
	xWglcbAGKwKfM0QhGWmvuNA2SeHo6s9K+lX2q21tyVB+YVrEbNww9akdRJMdH2blNnz5d9DRzWX
	rF8WjPp5psOvxOYwLa9irvJuJVUHTWE8zBWvV90tfacDcrABP+EYbNKQAzAfXGRPe/PI+M7Sigq
	4I4WIO9Bu7b0JBfNaonF6pya8FsQ==
X-Google-Smtp-Source: AGHT+IFco/AIFD5fqL2upehjsvFAsI3pjosHbxzjhLr008+cfjzyFgmWnzpdlEcgUXZJ8GeoC7fn5g==
X-Received: by 2002:a05:6402:270a:b0:647:54ba:6c42 with SMTP id 4fb4d7f45d1cf-65097dcd9fdmr1486656a12.4.1767773183403;
        Wed, 07 Jan 2026 00:06:23 -0800 (PST)
Received: from [192.168.224.78] ([213.208.157.247])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf6d5absm3941299a12.33.2026.01.07.00.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 00:06:23 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 07 Jan 2026 09:05:55 +0100
Subject: [PATCH 5/6] arm64: dts: qcom: milos: Add UFS nodes
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260107-milos-ufs-v1-5-6982ab20d0ac@fairphone.com>
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
In-Reply-To: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, 
 Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767773155; l=4338;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=ZqBIugg5K7/ysfpKey8yK6cRDkhGfiVM24dyT/kjpXc=;
 b=4+q92hc4E5FncGMKXsvkFnr2XdU5Xsgch8jTz/DF/1zlb/Wzyqfx0gA19Q1ogrwRzX+vA/MOD
 Yvr2gqnsc1bBsIUyHwoTXp+p5tIBk9+GgMO7OqsLvlXU+7p6sJBpG5N
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Add the nodes for the UFS PHY and UFS host controller, along with the
ICE used for UFS.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/milos.dtsi | 127 +++++++++++++++++++++++++++++++++++-
 1 file changed, 124 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
index e1a51d43943f..0f69deabb60c 100644
--- a/arch/arm64/boot/dts/qcom/milos.dtsi
+++ b/arch/arm64/boot/dts/qcom/milos.dtsi
@@ -797,9 +797,9 @@ gcc: clock-controller@100000 {
 				 <&sleep_clk>,
 				 <0>, /* pcie_0_pipe_clk */
 				 <0>, /* pcie_1_pipe_clk */
-				 <0>, /* ufs_phy_rx_symbol_0_clk */
-				 <0>, /* ufs_phy_rx_symbol_1_clk */
-				 <0>, /* ufs_phy_tx_symbol_0_clk */
+				 <&ufs_mem_phy 0>,
+				 <&ufs_mem_phy 1>,
+				 <&ufs_mem_phy 2>,
 				 <0>; /* usb3_phy_wrapper_gcc_usb30_pipe_clk */
 
 			#clock-cells = <1>;
@@ -1151,6 +1151,127 @@ aggre2_noc: interconnect@1700000 {
 			qcom,bcm-voters = <&apps_bcm_voter>;
 		};
 
+		ufs_mem_phy: phy@1d80000 {
+			compatible = "qcom,milos-qmp-ufs-phy";
+			reg = <0x0 0x01d80000 0x0 0x2000>;
+
+			clocks = <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
+				 <&tcsr TCSR_UFS_CLKREF_EN>;
+			clock-names = "ref",
+				      "ref_aux",
+				      "qref";
+
+			resets = <&ufs_mem_hc 0>;
+			reset-names = "ufsphy";
+
+			power-domains = <&gcc UFS_MEM_PHY_GDSC>;
+
+			#clock-cells = <1>;
+			#phy-cells = <0>;
+
+			status = "disabled";
+		};
+
+		ufs_mem_hc: ufshc@1d84000 {
+			compatible = "qcom,milos-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
+			reg = <0x0 0x01d84000 0x0 0x3000>;
+
+			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH 0>;
+
+			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>,
+				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
+				 <&tcsr TCSR_UFS_PAD_CLKREF_EN>,
+				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
+				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
+				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
+			clock-names = "core_clk",
+				      "bus_aggr_clk",
+				      "iface_clk",
+				      "core_clk_unipro",
+				      "ref_clk",
+				      "tx_lane0_sync_clk",
+				      "rx_lane0_sync_clk",
+				      "rx_lane1_sync_clk";
+
+			resets = <&gcc GCC_UFS_PHY_BCR>;
+			reset-names = "rst";
+
+			interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &cnoc_cfg SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "ufs-ddr",
+					     "cpu-ufs";
+
+			power-domains = <&gcc UFS_PHY_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
+
+			operating-points-v2 = <&ufs_opp_table>;
+
+			iommus = <&apps_smmu 0x60 0>;
+
+			lanes-per-direction = <2>;
+			qcom,ice = <&ice>;
+
+			phys = <&ufs_mem_phy>;
+			phy-names = "ufsphy";
+
+			#reset-cells = <1>;
+
+			status = "disabled";
+
+			ufs_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-75000000 {
+					opp-hz = /bits/ 64 <75000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <75000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <150000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_svs>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <300000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
+		};
+
+		ice: crypto@1d88000 {
+			compatible = "qcom,milos-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0x0 0x01d88000 0x0 0x18000>;
+
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0x0 0x01f40000 0x0 0x20000>;

-- 
2.52.0

