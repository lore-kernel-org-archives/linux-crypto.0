Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D2B22154F
	for <linux-crypto@vger.kernel.org>; Wed,  7 Jan 2026 08:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773163; cv=none; b=F3NiB/w3SLmILhJ8fTzt4u62NfhicwYAH81dhlPYYn6qJ3tsMYYfHJdIM8bJDthL2DUTDsCp090RmYo7StIngYO+xh1YBGsuZvLpOUU/QNmdAoAW3yt7uFOyVY15fxiVmIYV3EkQDEifJSbyF51Ow7nP4jv62O/c2XX00bZC2DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773163; c=relaxed/simple;
	bh=pB3wFfFcfrB8Ff4wD4ThceQT023SqfNJq63rMjQeuWY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=aADcs86cqj3N1+4BcuFP8qCE/txU1L39CTeSlXCCPT0SUfv9UZ9WlqNelRhnwB9APWa50zekNyA9vmOepaAC86XRPXgW4MMWp1w6Q9089l5vRbK6BHj9YqiLOxwPFaA5KkUVM2JDqMeU9rxGP2xHmvWTDyktpUqJ8S4fMJoXXiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=t2n2Qap2; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="t2n2Qap2"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64baaa754c6so2403601a12.3
        for <linux-crypto@vger.kernel.org>; Wed, 07 Jan 2026 00:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1767773160; x=1768377960; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aea4uA3J/1hwOpuMUNDquHCAnGDE82D8jnGDI33DmmI=;
        b=t2n2Qap2snXJ1sgPwbbQSUltKuOtstCzls6HfXSYUXWTBv5cdXFmeTdOGG4SnRWyDY
         MqqWN91J07Y+/hd6pN4ySo8kJ53+bB0T3AUZ408/w02hYT+l9PhRqlv2VO/T8MZMSabn
         eGMvl5Zyv5QwfvzyLQcJSBUV58pflnm62BDPiS1JB/gIOR7idVbMhRuvm4XeHYPv4ewl
         N+4CqXRszLiTa0GYaYul86i66yIcqluvyhH88hevJ6oDnmxhcDPd4G71CCL32A1kIZgA
         Rr0KqRVEC229UFHiq7TQKY6ItjG159SC670qThAvSysNHAolhZ2EVmYt6aRLTnpJ7d3l
         WBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767773160; x=1768377960;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aea4uA3J/1hwOpuMUNDquHCAnGDE82D8jnGDI33DmmI=;
        b=Z/bAoVOnXV1qeKgXIhpvt7L0kPSs2PuLpI630/jsoEKu/OTOofC8MvJ3hnCdH7Hu/c
         0DwRhaAZUu2xR0Z4288bwzmfrfXY1pnNs/+zVFZyeZ8HWB6lKQmza5YQx4B3zrRY9IxN
         YwqA0dOLlhj3+lzY4+QGzDeAWXGPyPA9/sOBQr4kwMNFb64ngK4GW/RON+cQz6PO20qi
         Oz0RYSzUVj1toqdusCrtLLwSqD0+3F7DwSKO6RU6eFnVL9vSfb2ivdMDnDsou/grIjzF
         TS09DavxbNFsgbFYjHuiyY8TjDQ67jyYh4zdqwgeQKp9fZhwShiRxCt0oymiyymLEAAW
         4OmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUw2ce0Hq7bZCfk/QRlQUSx2bSwC6zExPlLq307hvILDAc/ZNzTY0Nf9ffd1aM2XRvxrVDRVrLCq4CUeuo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7bwi7hlfzFc2qE6TpLdhWHTB6K6qkK0pxdYvmIiZdD4uo+DSz
	/xAMTsNE8kLU973d6v+rJ2x0ituj2PGVfE/CD3KkaZ7WFryhzFgBv2Eay1Uw+EWqLbfRn5yDC5t
	rXpNNk10=
X-Gm-Gg: AY/fxX5BzXsKk0W1xuhKFnhtowZdQ8EUR7fpQqXlCyEKT2XzQn1eJc7XumVOQZ95eGm
	u1akGSW1QP8Fumnj11vQMemQqoOJONCk2hX8TIiW6KcUSbiDubR2grOFCfZdsS+os3e4VvT1gy9
	Ei7pOveKNn3DzhChBFpVercLObtZXz6nxFXieUTo1Hs/zidt5Kn/DjVOMQlkE5N9bk/EjU0CD0f
	5sJ46QEagzxkxOJYIjuKYHRzJ2BeNAw0CyX0uTZCtrSFG4xLiz7/buqxrGClxXtAhn905X3nHmz
	dlQNPPGznMWYmzZFA1OwCQ9SNDF9TXD3si9Ut+oNf0/OnizegzWE25ZhuKte5zOHBETMmcxiYdp
	YJwNenDxSK8v7qPoHdaHuZCIrHGaIKzZu/2Fk9vnbjHCFfTv6Z44wiAFrGwhK1oW6G80inCgrdE
	6/dQvhl+zCmJKyEJbiLmKW055whg==
X-Google-Smtp-Source: AGHT+IHQhvsajZNsAjIqdeTR55Pw24pMGEFgeV3TrZGwVgpku5ShlzsTTOU37V7fY7XTDRiYIV76WA==
X-Received: by 2002:a05:6402:26d4:b0:649:cec4:2173 with SMTP id 4fb4d7f45d1cf-65097de6edfmr1372195a12.9.1767773160150;
        Wed, 07 Jan 2026 00:06:00 -0800 (PST)
Received: from [192.168.224.78] ([213.208.157.247])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf6d5absm3941299a12.33.2026.01.07.00.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 00:05:59 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 0/6] Enable UFS support on Milos
Date: Wed, 07 Jan 2026 09:05:50 +0100
Message-Id: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN4TXmkC/y3MQQrDIBCF4avIrDtgQomQq5Qs1IzpQNXWMSUQc
 vdKk+X/eHw7CBUmgVHtUOjLwjm16G4K/NOmhZDn1tDrftCdHjDyKwuuQdC44GZj7t4aD+3/LhR
 4+1uP6exCn7WR9RzBWSH0OUauo0q0VbxYA9Nx/ADuaakFjAAAAA==
X-Change-ID: 20260106-milos-ufs-7bfbd774ca7c
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767773155; l=1231;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=pB3wFfFcfrB8Ff4wD4ThceQT023SqfNJq63rMjQeuWY=;
 b=Ijl4D0+iLyVGZ0M1qfLy2I2IXvmtEOs7o+3vK2uEs/UcQ6h1855hoeK3mjwjmyOcn4UdfWtNz
 38+258XrMLvAUktnYO0rAjq9N0IzcQtdcJnuqwDjihz3MjNAQHtFREY
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Add inline-crypto-engine and UFS bindings & driver parts, then add them
to milos dtsi and enable the UFS storage on Fairphone (Gen. 6).

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
Luca Weiss (6):
      dt-bindings: crypto: qcom,inline-crypto-engine: document the Milos ICE
      scsi: ufs: qcom,sc7180-ufshc: dt-bindings: Document the Milos UFS Controller
      dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: document the Milos QMP UFS PHY
      phy: qcom-qmp-ufs: Add Milos support
      arm64: dts: qcom: milos: Add UFS nodes
      arm64: dts: qcom: milos-fairphone-fp6: Enable UFS

 .../bindings/crypto/qcom,inline-crypto-engine.yaml |   1 +
 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    |   2 +
 .../devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml |   2 +
 arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts   |  18 +++
 arch/arm64/boot/dts/qcom/milos.dtsi                | 127 ++++++++++++++++++++-
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c            |  96 ++++++++++++++++
 6 files changed, 243 insertions(+), 3 deletions(-)
---
base-commit: ef1c7b875741bef0ff37ae8ab8a9aaf407dc141c
change-id: 20260106-milos-ufs-7bfbd774ca7c

Best regards,
-- 
Luca Weiss <luca.weiss@fairphone.com>

