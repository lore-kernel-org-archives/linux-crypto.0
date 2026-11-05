Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793892593;
	b=1n1p4Mz6qcUzy1EBDVi5FnUu5LMKNj74oVSz2uZdINzM+Ai/av2iZJhh9xbVjzzCh5du
	 tcocHPYtkKAvTM7BPNILfhAmPd6huPFdIMZRM8zvaPLG5fC5cozDD7JAcIO4widCayISi
	 yfDn32dOQ0d4h3tW1AgyBoP+2GojhKIjNChzmHXfuVa7jK/4aeSJBlUy/SY44GTWkhlL8
	 7/zAu8ickoMV3/AE/F9JbVjUOqfJ7louu06ZM+wacBxUYx4Vo7tn3M3oo5pc60irPZK1O
	 f92bIV7CN8esTs7sLUUgwVJvqR0lX0sfegPCIbOjfjk74PTcEkKtH4FO9FvbLm4Dqhg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793892593;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NBQpXzU3ySaI25xlrBMnFQxxVdhQdx3KwAIpbcylXis=;
	b=QA483+klbzPmKHGbF2FucMPXhQEBEtrMJoB7xlzQo+XePErFKsHxDgqker20C6MiXdwI
	 XCthN71oiumsvRiL2sWdJA/vdZiv6Xdf2BkKZNRFE6KhcDrXKVuGVXWdOAsxRix5qSjnb
	 GsVP0Ze4E8f4CswKjrcfVv5/siTIOyjBsTWLa8RaabJlJcOstsCAmfNesqSE2UoIvphhm
	 SFmo256DbOD8tcw6zPjc4vZQ1yvSddVcXa/PShVBWP4NCCtj0EGighJH5/RoTmEjQndlA
	 YutxIeuVCXEZ/c1/FDA+kqzz9wks3wASFNxZyqsM4Rm1Ghcyi1zpdDoKGkVN7ys01SQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AB9606D838;
	Thu,  5 Nov 2026 15:29:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793892582;
	b=mvAtLOFc+e1qS08pc2Qqw4+4boYg2KK6jF10uf1ddxNDqi0G8s/EqKRyPZEZQ4W6jTo7
	 r1VPSMXjf6OdwUmrtXP7dqvWLQhZ8isYR5fJl3VGBfSvnaZkUe4E5gefYuxL9SSXJq0S5
	 Q67jauLLdfU0lzVe6tTMqOi6RDalpuHGwtW+dCy2ndDFkyDnyInHWtZ9JDwkR4IHZhrXZ
	 vuoB+z5USuZzM0YMbFs/qJqK04hbG+V8iY00rvaV3QhKbSrAe0gbqri2Wr6DqbHJv8Mew
	 oOL2E5ACfbZmj8tcvJ1frGNP6XZUWIKhMx+t6cCm1R2+oMLtO+pK+GehnmCGHjLxWIg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793892582;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NBQpXzU3ySaI25xlrBMnFQxxVdhQdx3KwAIpbcylXis=;
	b=VqxRazaTOZFC1tLcCzgTUZf+87//HPs3n+Rbsp73jOOEQNYbET51Tvze1leKrMUgxDEO
	 GYFNnnaPdbVe6AX4a2Vi9aAPbnoyWp0sS09k8mRZ4E/YE//nBhBP6W7robWSINbBh3LXQ
	 fmYjWkU+tvRX3DD/kMNphkBvcinHGPAzd2VGkZigqGzwQs6m27nCeoYi3zMWgcb0GiSIQ
	 Tr6CtfjED74R/8s5Thbrxh5VQijf855B6iQaOuhzUoPhv1NyYL8+7IiyFrPESjsjyhdAM
	 nEjEi1ivC4HzDlTDxJgzH6F7YlmBhpaKm/uNhaNHz5qj976p6Yr38U3Urt4SG461q4A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BEBCC1F00A18;
	Thu,  5 Nov 2026 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793892582;
	bh=NBQpXzU3ySaI25xlrBMnFQxxVdhQdx3KwAIpbcylXis=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=XuF4ZBNVdz49lUewD6UKTzbdXBvQuMDLqNLUEJ8IXhNiJ5IszqZo5s9jCjZjvn6ez
	 86dRITNP3RGiigfXtllkAFCPK62OKrP/DWLxkad9d0rE/RYGxDW+ObAGJvTZbyCLW0
	 s9gwvpp612v4Ll/QFWsOxT/KWNkn5nb4mj7zT5nclKYyAiCkCsE4GfLaP5q7k5LKV6
	 Pd2izWjGjlU9k2P9mFA3BbnUETQesjziQawIYJK6QPWhf08ENoCqhBxGGxBmWhj56f
	 TF2hg3Iw3R4XublNBFFY1LdFu55+KRzQ3pYhDvz3/PqiSnGN0BugXBSwFj35rA/c//
	 B/BBcz3l8/FEw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 46D16472F3;
	Thu,  5 Nov 2026 15:29:41 +0000 (UTC)
From: Demeter Barna via B4 Relay <devnull+me.fromdisposition.org@kernel.org>
Date: Thu, 05 Nov 2026 15:29:31 +0000
Subject: [PATCH 2/2] arm64: dts: qcom: sm8350: Add the inline crypto engine
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
Message-Id: <20261105-b4-sm8350-ice-v1-2-f55e6ea8e1ca@fromdisposition.org>
References: <20261105-b4-sm8350-ice-v1-0-f55e6ea8e1ca@fromdisposition.org>
In-Reply-To: <20261105-b4-sm8350-ice-v1-0-f55e6ea8e1ca@fromdisposition.org>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793892578; l=1535;
 i=me@fromdisposition.org; s=20261012; h=from:subject:message-id;
 bh=D6BUds9SxEA685Rzubo4gGj7fm7khF99ZYP/XeTNyDQ=;
 b=2jcu39RQqSrRH/baSy0Uj/GVFNQm+3yDZe3gZgVELwFkB0LyPD4QOAlhHB8RvqpaMH3dgQdZo
 BKt2uFoUAhtDQXlxr2ZC6W+LP9fS7qH7HueyTkzQEVaZtRXHFssaTzb
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


