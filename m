Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795793083;
	b=d0zeKs5gV+M98c1WONMwzkqXlNd7V6ec1NUEv5vO0CR1qLcjP4q1oVIby0sUJDP6LRhq
	 g3/YZmaYevBsj4Rst1/g0YKXisoAUhHBjuiIk4M8CppTT6Dw9XZTYayAhrzzzRbfmsVq1
	 anMF4oq9FzA7G5U7sKP9uz3F30VZ0cMDebqmudWaEvV524KZ56hZ+6lo0Jhud7xJe5iC5
	 jFF3AOWIDPo6mB2xJTZIiCT5+ctS/tFfi4RvJEWFsF3oKV5avdZuCMc0tF08W/V1R42HY
	 1TW6YE6qgRqtWqG2XN4+3sG5ip9L8aa7vLbQZSzSGjZidoW3S203Oq4rUpZ7BTdrqLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795793083;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=rE9eGkBgkXI/A0OiZBA/yiezOBbNdxNuTrMvP1S1OT0=;
	b=GjVV4GN97ZDxARRMmBs20Qd7IXfUtiZ3wPXkZ24tXTQJL68uH4Log3/HLzfdhdUWOo5E
	 u7P5bEtAhkZ1o2A2fbMPuWax3iBYIrT27bVell3SiBRPEgdl0+aqoD6V64xWTXtnc+zX+
	 GK1GpnWFzgti5yupVyPMaDZuJwU8YRceUbQGDJSgoEPbqk9+Auax73TkrVLwNJfZN4os1
	 8yp9h3s9HHkRykigOEiLTuy3PNivGTRrFq6Kw7lNj1f5fP6uLFZRgN8QJOjNVaMHX8aqX
	 oD9welx3RqIkbZbwu9E+ZhQlSpb+GbtZjnoM+mzTUiem2KlrFMj2GbCOAR8mIISvTPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d+2UOwRF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3E1606A32C;
	Fri, 27 Nov 2026 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d+2UOwRF
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795793083;
	b=PccJP4W7Dmm3EJ9yVtvUYsHSAQWFY8IkGA/85XhfTQisCCS5ahf6IWqjpnLkg+zHiFUd
	 ckO5X/rXIvJTJB3FYIFe0i6xr1rc+hojzK4enBX2LrIMx1E147dbRllnUahs2S7EowxGx
	 xo4nOOKMUax61fabsSVYfTP1bHI0XZQazbNKAiOFDumPehbL0prsmBtvUfx3L3UrtXAy+
	 JSDVXqSXnKrsluG2/FFdEwJx6lsgltPiy0U5szg4y2/JQtBvlM390mwISVahZhrY+Sjmw
	 3YcYFUn/Kc+Y4HOPLG88AU/hSEEZ4Y2dloELuWRNEXG2cex5FIafCRFtfR1VgIcsFmA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795793083;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=rE9eGkBgkXI/A0OiZBA/yiezOBbNdxNuTrMvP1S1OT0=;
	b=d6SmXERqz3XCEl+bi3wYmcEvRRJUSkzRrd3lK6AC22j3b6grFjSvv/dESrxIuw/BMmrV
	 uuJAw4ji59j5W5ZGYhdOoCIxaVU9uo+zm+KtXR5v7jxVRl02M4+JhtkXHydsiIsJsN2Tj
	 U3HgYoLCq06JwpX35uHb6AV/+vN4YimAW3XwV6fobjPQKv6VOqQyQZaIdingDuFpw5b3M
	 2PWX4XquNmHfj2dgpLM/JxIp9ceJeRylLjNG2TD2nKli/KTVWYDbZiagn2OqwQg/2VXUh
	 z+ZRPPPXUPtyhhS5lGp/4qlGDyO3rdH4lS/LSfVuhCYU7swDmcYZa6SIVwxIogDj9PQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9C16B1F000C1;
	Fri, 27 Nov 2026 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795793083;
	bh=rE9eGkBgkXI/A0OiZBA/yiezOBbNdxNuTrMvP1S1OT0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=d+2UOwRF9HjguS2yA+ycdhZy/wtRG12qxYOhd8gmo4r/HPgYR0W8oxBunozEqBa6w
	 M8TPdiRouZa3DrEHg8/1xySDn8l0MLeZLLGfOUtPkNeLpeQfCJNQU/7ZYYGlQLxibx
	 VLDud7KEHAI5JgfZm7M5Fdu1L4TfpTpCQHtjD4MDLICScF2ws7DQDAe2HyKaEsO5Gv
	 NW11MFPaTdd3wKgyuZ5NjHznc1bwhwSeocaaXfsp/DZkSPOZ84xaXeIScYwbweH8Kg
	 tAC2UNcBN9gkXJSFIBVWC840Tl0R4lgjqT/qLeJmDAWASbv++QyPj6aVwXhSEeFs2x
	 xLVx/wughbwKg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 297134D11D;
	Fri, 27 Nov 2026 15:24:28 +0000 (UTC)
From: Demeter Barna via B4 Relay <devnull+me.fromdisposition.org@kernel.org>
Date: Fri, 27 Nov 2026 15:24:26 +0000
Subject: [PATCH v3 2/2] arm64: dts: qcom: sm8350: Add the inline crypto
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
Message-Id: <20261127-b4-sm8350-ice-v3-2-39c5b4f562cd@fromdisposition.org>
References: <20261127-b4-sm8350-ice-v3-0-39c5b4f562cd@fromdisposition.org>
In-Reply-To: <20261127-b4-sm8350-ice-v3-0-39c5b4f562cd@fromdisposition.org>
To: Abel Vesa <abelvesa@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Demeter Barna <me@fromdisposition.org>, 
 Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795793066; l=1526;
 i=me@fromdisposition.org; s=20261012; h=from:subject:message-id;
 bh=zxW8jDNFW4qc/Eyi8Ue01FHv0GrQD3Xmn2cTviIeaNA=;
 b=YVuDA781UT1ExpM5nAp2kWVtTBsxtJv1HThvvaNBihcqIkFZNXPyLbty9KoIrSEKvmWIPOFqi
 gwK1ciGqO2ACu3cgwOolHFsBe/GCltvYk+J7u3w6O5KX/wiB3VE9UPJ
X-Developer-Key: i=me@fromdisposition.org; a=ed25519;
 pk=S0QFlGq1BQEaAtPPdAH8YKEOXMeRuSkTgctXuvtU+1Y=
X-Endpoint-Received: by B4 Relay for me@fromdisposition.org/20261012 with
 auth_id=1163
X-Original-From: Demeter Barna <me@fromdisposition.org>
Reply-To: me@fromdisposition.org
Content-Transfer-Encoding: 7bit

From: Demeter Barna <me@fromdisposition.org>

Describe the UFS inline crypto engine at 0x1d88000 and hand it to the
UFS host controller with qcom,ice. The region is 0x18000, as on SM8450
and later SoCs; it is clocked by the UFS ICE core and AHB clocks and
powered by the UFS PHY GDSC, as on SM8450. Without it the UFS driver
logs "Disabling inline encryption support" and fscrypt has no hardware
path.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Demeter Barna <me@fromdisposition.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 7b9966e8f..bc38c7173 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -2135,6 +2135,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 				<0 0>,
 				<0 0>,
 				<0 0>;
+			qcom,ice = <&ice>;
+
 			status = "disabled";
 		};
 
@@ -2160,6 +2162,17 @@ ufs_mem_phy: phy@1d87000 {
 			status = "disabled";
 		};
 
+		ice: crypto@1d88000 {
+			compatible = "qcom,sm8350-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0 0x01d88000 0 0x18000>;
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


