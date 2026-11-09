Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794232540;
	b=uUZPYYFJY/r7EfAZN+8HjsWjFj0oXL7L6/1jO10S25JegAKC63OpK2V3yBt5uceLpQaV
	 eiAfRuE+F2PZgyrUbrnhuGZoCp+iFQqQqUycdTxTTdGcQDnyV87lgCgfeuk408whakoUu
	 jBHXwzxPtnBuZ/UAzHIvpX08WLZZ9yXiSsXLZ9wKUiOS+ztwHwEulZPA3Dg3FpbXbwRTo
	 2NGTnpF2vIkqtqwUmlrU+838QmQ6nVdBPOKhwAfWTjsaxvu0PLdWTwuPvtjaHag5HKzYP
	 U+4MN5gHGpUyy+8CBqAo/HUoDMGGQjnPsjfAo1A4vKuNte7Fr6/3pCbisjUZxk4CxMQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794232540;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NBQpXzU3ySaI25xlrBMnFQxxVdhQdx3KwAIpbcylXis=;
	b=OIGOExmbIwsfh9KLoawPK5K63AmWW2Eg8QRjt4Y2qBFSOaYZxVgkhNjlFFH2JBs+f1nt
	 5mzaXPOzTquphdUXlRYEkRIEMRMmBrp7uyu4Axp3dNa9n/yU7I8JZ50x0qnTkeDg8tPJY
	 3eo9OP7tZA4b8/qiEdZixnAAELuHv/X/3diWXreu8N5OYdA4i6KfWzQuDMn5moSOIvKLJ
	 aCpF/pPmsnGcOrREen7WfjFDniN17YxujH8hBMzOHgL0ZZCew5bFTnzyvSGpQW0gTv/FF
	 FGbH1NQ3kRZozjC6kYNkTlRKJpZYX40C6mb1UQQputFpOifPOOL1T2DGhrlKIRq6SdQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UFdtLVTp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6AA606D805;
	Mon,  9 Nov 2026 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UFdtLVTp
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794232540;
	b=mwhAdQQq1UHg8eyzhHa5WlHaqo17HDnb5ADZw6fVhyUOS4MVv8H7pzfGuAjnJqn2QRes
	 /aFNlHid0KDKCg2inu5t+qgR+LmXMeXSAEva8pBzZoiNHKYifHNw7JMPBH07I8e/6MulX
	 JtRFTu1b5kcOuhEKjnRQK6X2Zy9jgoqmghmb0uCWeKdZ0f1ZJWfdAl2Gw/YkFoBwke38R
	 rnNfPNRWnB1FaA1fJZ50BDoL89hqQKc2X6X3dHwRL7LTa1I/sF2IHyVkFydFz/z+9Btsf
	 8/kcsu9Pcr1xf8fTZVs1NbKYRfbwdRSrPiVGry0Ij77fw9gW4ckBdN0mk1BMenz1Rhg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794232540;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NBQpXzU3ySaI25xlrBMnFQxxVdhQdx3KwAIpbcylXis=;
	b=YkoSfDN0oVnZKG5CmW2hSXBh4B0PRX+xsjvuRewR/rSGSlXUly/dYqjVjf3Si271g2a4
	 9r5APjoxXluwuNanenptHZvLgxh43F/If+1X5zqcpuSHq3t0axedyGFhNZABKsrlNRE49
	 M0BtAkVLIwnrLN9fFByOcUBAponwRgyAky5qYpykqMQ/L+kAAwDYriTP2ilh3XAM+350t
	 ba7wQ1xCnmIGsteO3Uo/uctiTABfQnEI2RvtXn+2WCDsG08N/wztCXW0L+QKx1hkH6U2o
	 ayUwhrWsXwamy5Cqc6jN2yVE20UwzELRCDL5j6ZXt6d7tLdSHN0YhMWYqDq5RHHc9vQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 765A11F008A3;
	Mon,  9 Nov 2026 13:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794232540;
	bh=NBQpXzU3ySaI25xlrBMnFQxxVdhQdx3KwAIpbcylXis=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=UFdtLVTpZWyghWr5K28FwirwtSk8bwq0ZDE4k4Z0LGieD0SWCv+oaCi5KxuhupsM8
	 MVbRn4AO0kJtDqNlzb6RGqJ5qtZdwivx1PG1PvQlpORbhPi8f1DdEqv2HdBNBPJsN2
	 2aj+r1DPNRNREEZ0C7pk6z7dyNAUz3RMxCUj93rdGw7SKDcHEKguj8hMP/Cwjyueqi
	 AOlysYk/2/cU3rOKh5q0G0wme0Nchh5G3NdUg8F7ibdsrZWRsUK7npfNm5zLcKTAW2
	 ywzPOHs2CDIEbqJQ7gjM7Qxxz1e4d/SMj+TBBL7Dk69zAwNXZb1FhCK/W0hiFG9pfR
	 BVoZEUOG/xBSA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 02397484CF;
	Mon,  9 Nov 2026 13:55:39 +0000 (UTC)
From: Demeter Barna via B4 Relay <devnull+me.fromdisposition.org@kernel.org>
Date: Mon, 09 Nov 2026 13:55:30 +0000
Subject: [PATCH v2 2/2] arm64: dts: qcom: sm8350: Add the inline crypto
 engine
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261109-b4-sm8350-ice-v2-2-fd5e84985e90@fromdisposition.org>
References: <20261109-b4-sm8350-ice-v2-0-fd5e84985e90@fromdisposition.org>
In-Reply-To: <20261109-b4-sm8350-ice-v2-0-fd5e84985e90@fromdisposition.org>
To: Abel Vesa <abelvesa@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Demeter Barna <me@fromdisposition.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794232535; l=1535;
 i=me@fromdisposition.org; s=20261012; h=from:subject:message-id;
 bh=D6BUds9SxEA685Rzubo4gGj7fm7khF99ZYP/XeTNyDQ=;
 b=0W8t+eSCuo4ppfZiiZgklYWeFq6LPpLSbbeACf7KjIDwos87XAaUwYG8+6kDZngXeKl1IkG9S
 1NGoCazcVvGAN2EKY+rOTn92d126IuXWK56/oxVkFT2H+E+nJhiOs47
X-Developer-Key: i=me@fromdisposition.org; a=ed25519;
 pk=S0QFlGq1BQEaAtPPdAH8YKEOXMeRuSkTgctXuvtU+1Y=
X-Endpoint-Received: by B4 Relay for me@fromdisposition.org/20261012 with
 auth_id=1163
X-Original-From: Demeter Barna <me@fromdisposition.org>
Reply-To: me@fromdisposition.org
Content-Transfer-Encoding: 7bit

From: Demeter Barna <me@fromdisposition.org>

Describe the UFS inline crypto engine at 0x1d88000 and hand it to the
UFS host controller with qcom,ice. The region covers the engine and its
hardware key manager (0x8000 + 0x9000), as in Qualcomm's SM8350 device
tree; it is clocked by the UFS ICE core and AHB clocks and powered by
the UFS PHY GDSC, as on SM8450. Without it the UFS driver logs
"Disabling inline encryption support" and fscrypt has no hardware path.

Signed-off-by: Demeter Barna <me@fromdisposition.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 55b32050c..2b258c4b4 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1782,6 +1782,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 				<0 0>,
 				<0 0>,
 				<0 0>;
+			qcom,ice = <&ice>;
+
 			status = "disabled";
 		};
 
@@ -1807,6 +1809,17 @@ ufs_mem_phy: phy@1d87000 {
 			status = "disabled";
 		};
 
+		ice: crypto@1d88000 {
+			compatible = "qcom,sm8350-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0 0x01d88000 0 0x11000>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
+		};
+
 		cryptobam: dma-controller@1dc4000 {
 			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			reg = <0 0x01dc4000 0 0x24000>;

-- 
2.53.0


