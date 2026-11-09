Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794232540;
	b=eROqrX+c9l9tIPeikm9Nznc4+8tbzWMDe5ATVkBOSNlSl2cxt0kJQ4jAy/IoKbDPn8DA
	 lF+PVzdMVsAJay7QoEQZet1wjS5is7I9pyMVYmLAoNFwqJge/YPkHf6cDKnD1mUoKvwjk
	 lvbnjToCOeHkES94urZoQgv6AQ4Kbsn7CwRzIdescLi4RFs+flih3QyD/mWI6mTcYsbn/
	 U8AYfoRepCJONrqCfRWPzZkaKyNqEiQF6KZc7+hOY8Fija2zXG9krOZD6hfIFXL4N4sBs
	 cenglfq1Lgk6KzRvY4r0VSimmtAME+ObWTEzFOdRc56KSANFC92DnPecjcQg7m95MPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794232540;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=eci4ybDXfc0nhoGpvtpOFnwxOheVmbKvqPqrPjaKWkY=;
	b=JvjZb1Lyt1SS9ifdq2Bb/shN2mc5sJjbfRLnnE9JKGh2WTbcf1cg5j1ENjzC3w9Zo2Hp
	 dZz0KUXYRPaPl1bLFGjJoyBgwXQO1t/0msB4lGW+NPBVwxsVLaAOVHwSi85VkghmQayF/
	 ULoPcMN+EpP4DNJJeB1OrtIWOcsXnJMqFKXYIiR+R6WZmuKIJGg/r3AWyn1oEqcNBmCoG
	 K+PHtCJPSAmIwZ/c2mMXZz0XDLGZs+gOxodBoRkyUCh091uzsBPIzca1RkmvIA/QVcsoB
	 zJO0tSTGrxihsUwG2aMdb149jghKWqeM1ACdXg8i/QGgO8k75wQ4A2LaO2BDE2rB8AQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F1TS9L+e;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE2C606A339;
	Mon,  9 Nov 2026 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F1TS9L+e
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794232540;
	b=gHtPeKJaBw7ZJofJgrwoIbnV3mSnj94O/cFfwew2tCuykUCD7iqIYxIQTU2PYROGUHkG
	 x8qAM1RgGVyIzZwYm2R0RsnVUNUu23TpSoGKMOAprKW2Vaa++Xb0/G73EQV5g8E6wqoq9
	 XaKFdZK2KXFgdtRN3XmajtNolptLJDQpY/j7Ffi4vx4P14qsuHrg1DnUi4IFf4npD3iCO
	 B9fjW9J8v4eCjcBwOReuY9Lqm2RwInMWBl9B1bbxIdnBB41XWBfX2d1lP01JJg6N1DnIj
	 Rhth5zBRJhJv6TE0EkeYWFKq1+i0we2LoTnlLlWPLSCsR1D5jCveV+3Lm+Ge7rgyeDw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794232540;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=eci4ybDXfc0nhoGpvtpOFnwxOheVmbKvqPqrPjaKWkY=;
	b=BRkAvNn0hgEpNikUw9TXfAo6kYOMCGg0xewsyM93KgD71PpxzlpBoYHO/MMqbtzH52QE
	 C6MvOw1EKQfVRdjvIO8jwc5wQMY9f9sq1OpuvYhVHqItERaRIbHiyMi1o4RynBNPb7Lbn
	 RTSReRypypK+SSr54C8cqYAM5vtE/623ygBSF4hQ6AsrQC6/K+VPv/fu4Z4E5lFb2xfPW
	 L7l9a1IFVvlwpRM4pM222rI4Mw4xSJXrI8iHsNDBQ+rGWHGdbvMvttcCdT4weembQ8s8E
	 wwcge+W/5cEwzFWfOQ6q4JmnwkKAILkTQeLP/trF0mpsw91ZYT6VWaE1zr+SFj2uVXA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 762A31F008A2;
	Mon,  9 Nov 2026 13:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794232540;
	bh=eci4ybDXfc0nhoGpvtpOFnwxOheVmbKvqPqrPjaKWkY=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=F1TS9L+eUeCbotT8eWwjyShYDLlejvmqQmH42DnHmAnsirJfewwbyNoLT3t7BNsbt
	 uNuTI6B3F707/2Caz/LiCBDujj+sOzsemwz6U2lc/7RGyDhWjyz6aMZXU3wyHjFA+g
	 VflymN3rnUNZQprsr96jl6degU4tvVpW9Z9G8BKetjbLzi3Tqk3uBSB7C/0+Uk1Kcf
	 FkFKsdxE20IyamPyNk8eKt/JdH3NaMTIMNliOvy/wWNv3oncVTUDBxsI5py6hovPrN
	 rsf4XCFgvwYOq9ciBoMNlnGb99V7h+zOhRzqUOWDhpkGqTk2qbj2OmOoJ2ofbyhBju
	 zJ5JvgjEjpTzg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CCF7D484B9;
	Mon,  9 Nov 2026 13:55:38 +0000 (UTC)
From: Demeter Barna via B4 Relay <devnull+me.fromdisposition.org@kernel.org>
Subject: [PATCH v2 0/2] arm64: dts: qcom: sm8350: Add the inline crypto
 engine
Date: Mon, 09 Nov 2026 13:55:28 +0000
Message-Id: <20261109-b4-sm8350-ice-v2-0-fd5e84985e90@fromdisposition.org>
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
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WOwQqDMBBEf0Vy7pYkGrE9+R/FQ4wb3YJGslZax
 H9vtOceH8y8mU0wRkIW92wTEVdiClMCfcmEG+zUI1CXWGipS6WkgbYAHqvcSCCHgN52hcFbrks
 tUmeO6Ol9+h7Nj/nVPtEth+RIDMRLiJ9zcFVH7p97VSDBG4Ml2gqVs7WPYeyI58C0pJ/XEHvR7
 Pv+BRhzvH/GAAAA
X-Change-ID: 20261105-b4-sm8350-ice-efad45e93262
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794232535; l=1627;
 i=me@fromdisposition.org; s=20261012; h=from:subject:message-id;
 bh=iEvs/mRmPbkyFB2ueYR7aReCKd4lWIPF0+wKUolEjTM=;
 b=0eKFcFbHOOY66ttJSOqjNRwmxTPtozm6mbhfCF34b+vka5QQjZmzCFeRKeUWZ3WszvpZezeLz
 QOs2CFVgBtCCm9/rKi7XgKExoDxccLuVKfirFVALavSnnHulU+34MSr
X-Developer-Key: i=me@fromdisposition.org; a=ed25519;
 pk=S0QFlGq1BQEaAtPPdAH8YKEOXMeRuSkTgctXuvtU+1Y=
X-Endpoint-Received: by B4 Relay for me@fromdisposition.org/20261012 with
 auth_id=1163
X-Original-From: Demeter Barna <me@fromdisposition.org>
Reply-To: me@fromdisposition.org

SM8350 has an inline crypto engine (ICE v3.2.0) next to its UFS host,
but sm8350.dtsi does not describe it, so ufs-qcom runs without inline
encryption. Add the compatible to the binding and the node to
sm8350.dtsi, as on SM8450.

The region covers the engine (0x1d88000, 0x8000) and its key manager
(0x1d90000, 0x9000), as in Qualcomm's SM8350 device tree; the clocks and
the power domain are those of SM8450. The TrustZone offers the raw-key
SCM calls but not GENERATE/PREPARE/IMPORT_ICE_KEY, so qcom-ice uses raw
keys.

Tested on a Razer Edge 5G with fscrypt v2 on ext4: "AES-256-XTS using
blk-crypto (native)", and files written with and without inlinecrypt
read back correctly either way. dtbs_check is clean for all SM8350
boards.

Signed-off-by: Demeter Barna <me@fromdisposition.org>
---
Changes in v2:
- dt-bindings: drop SM8350 from the legacy single-clock list. It was
  added there by mistake; SM8350 does not need the exemption, its node
  has both clocks and the power domain.
- Link to v1: https://patch.msgid.link/20261105-b4-sm8350-ice-v1-0-f55e6ea8e1ca@fromdisposition.org

---
Demeter Barna (2):
      dt-bindings: crypto: qcom,inline-crypto-engine: Add SM8350
      arm64: dts: qcom: sm8350: Add the inline crypto engine

 .../bindings/crypto/qcom,inline-crypto-engine.yaml          |  1 +
 arch/arm64/boot/dts/qcom/sm8350.dtsi                        | 13 +++++++++++++
 2 files changed, 14 insertions(+)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261105-b4-sm8350-ice-efad45e93262

Best regards,
--  
Demeter Barna <me@fromdisposition.org>


