Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF219304985
	for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 11:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759146567; cv=none; b=i7nA477rUErAw4M1bItgLm4UnrU0QP7bOheIARk8qytGmPba9KstXiXevjRboKqfP6EexWDbmDLa+eHGobUbhZ9YarivDbQv3l4pA5pzLKgwd8jMaqLUQCYmCQmC4Mv8s/7IKBxL+NUxh2FkhX7ab2BLYWD0AnHlCFjWt1FMQfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759146567; c=relaxed/simple;
	bh=3xOYS52/3sAqAFoOAMM7xyJw/GbBkIDjCptmDIQUZYg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=A5adj3lDqs+3uNBgbynVKyguOb+9xHPf6c4R6gYMWHASJDircCx6cRycD5EokspBN9jqqOSBDOCDAygq0/vBQMxkESHGD84KoPrHDyPUtdPlgBCrKriboIeHVVoJrf9A4YREfN1PlQYynKBiOPiHtE4tW9X2qd/aDN+1aMl7zog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=duPNxDDJ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="duPNxDDJ"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e3cdc1a6aso23437735e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 04:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759146564; x=1759751364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=AA8qJbDS2PXrHXWRwL/CsSJDqnLVXMkoJNGc5ktbBCE=;
        b=duPNxDDJaN3WnEy7gBXhvYagfiWrCVdjAsfepRv492uwHQ09vz1pWMuysobNgW2j6x
         CyGO+jx7T4uoD4W1x3q1CjXnfn2aPdlrt3sSwmJiMtBH5Kyu0jbolHRo6SAFzJs7CfQW
         5pYychuu14C9rZdNSXu/EoRuKGKcMqqr10LepIsg5LgZeVObP52KsrF+x1J2zjGoDSJq
         YEqLSPYhiDkfUEmUpi766LDSpHo+aR1y9tHg/ONd012WzjJsX32tVKwvE7s+iig+ORSX
         3C7iYCY61bdj/QVVGg33+uMXpFZMKFWjwTSJVCr9s+5YtcN5R+aDKVhSgC/iWqFcyQmw
         bekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759146564; x=1759751364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AA8qJbDS2PXrHXWRwL/CsSJDqnLVXMkoJNGc5ktbBCE=;
        b=vOwrzQUgjyrc8Jhc0GMEBFyVCYrAL+MgYR1r/+TIVwliLi/EQ5gpWRixTyyFVEBJyZ
         V0KKvNP4BYc9XtV/jH6XAySLtvzxdZWIC00mIKJ5HtXWXDg4kf2U9gYkSSoRVK1xP52S
         RVeuc9vwYN4EausravZS9ibc8gJvSKeI97sBLPXR9XkJri6TxyD5eEeSPl71DY1HHxrg
         Zx/ieyWMsQ3FdYGB1/SmN4ik0CL6VWa4yV/qm0ZRxPOp31burymlbddsLio4AfskUabd
         +zXbM88Fq2hm+aqGAymxZ7cyPw5H0kqDd4uapoInFLQryJ+EmLWb5h7KYzF7xJvaPzfj
         OCgw==
X-Forwarded-Encrypted: i=1; AJvYcCWNgun98HBUSTZkHK0JAoKKk1GsGykamMCwXzouxz9XH1Hd35XH31sfku35tWyuFiVygq1uH+FvDg56bTI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxkn8Wcl4SMvdzLd9pnnuW3/+bTloqv2kn67rPpLRQzQRzaXuww
	JIOzLTyO1XHpK7Rp6MW6tDTQdQf2rCFw9Td5UGqFhTxkQAm57KM2oEhF
X-Gm-Gg: ASbGnctLNy7caPqRrxYAExUWQ1mNPhAPFF4g8mmBtRtwLgTvPLF3BCZteWm1Jdc7iCV
	WSB7Kn3TFDp4JV/VUIPzvUgzHQrxRBeagUUVTTKb/8feaBqmYEMuc+OASVFnj0ReASJ/o+NTyMf
	dng6MazAL0DL1ESXftENNG8imB8gPac4+1DcFtrL2SidoW/wQrrlXMd2b68UNduoEQdMYXfk9U0
	7yM4FOVsyN2+h0fU9fpCx+gdo28oE3UgNk/T4vlaaiBJ/ibAWOGYhqTg39LELeEyVxmTfM0Jtu9
	MNwY1CYcMi1/fAPKWVVBVSHIPanX96UtECXdfwGyY2VpmMUXdqRBNe2sEm3xsj5b31r90ypv/s9
	DUzY2hfgDb4rkZz/wU5dRwqMyFszuGPvunlATDoRSKOckYRebNj0hUCX5sJem6oirVEOORdM=
X-Google-Smtp-Source: AGHT+IHWIIGjN6nhJ28ac9trCVEFZnQxU7WiTxI9XitTonZzPwwSA3UglkJvouFg2U2iPv1aIzbnYw==
X-Received: by 2002:a05:600c:4e46:b0:45d:dbf0:4831 with SMTP id 5b1f17b1804b1-46e58a02073mr3602305e9.0.1759146563815;
        Mon, 29 Sep 2025 04:49:23 -0700 (PDT)
Received: from Ansuel-XPS24 (host-95-249-236-54.retail.telecomitalia.it. [95.249.236.54])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-46e56f77956sm10030835e9.20.2025.09.29.04.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 04:49:23 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	John Crispin <john@phrozen.org>,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-watchdog@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v4 0/4] arm64: Add AN7583 DTSI
Date: Mon, 29 Sep 2025 13:49:11 +0200
Message-ID: <20250929114917.5501-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simple series to add initial AN7583 DTSI. More node will be
included as they will be supported.

Changes v4:
- Add review tag
- Fix alphabetical order in Makefile
- Move PSCI node after CPU node
Changes v3:
- Fix typo EN7583 -> AN7583
- Add specific compatible for watchdog and crypto engine
Changes v2:
- Fix DTB BOT warning (fix crypto compatible and OPP node name)

Christian Marangi (4):
  dt-bindings: crypto: Add support for Airoha AN7583 SoC
  dt-bindings: watchdog: airoha: Add support for Airoha AN7583 SoC
  dt-bindings: arm64: dts: airoha: Add AN7583 compatible
  arm64: dts: Add Airoha AN7583 SoC and AN7583 Evaluation Board

 .../devicetree/bindings/arm/airoha.yaml       |   4 +
 .../crypto/inside-secure,safexcel-eip93.yaml  |   4 +
 .../bindings/watchdog/airoha,en7581-wdt.yaml  |   6 +-
 arch/arm64/boot/dts/airoha/Makefile           |   1 +
 arch/arm64/boot/dts/airoha/an7583-evb.dts     |  22 ++
 arch/arm64/boot/dts/airoha/an7583.dtsi        | 283 ++++++++++++++++++
 6 files changed, 319 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/airoha/an7583-evb.dts
 create mode 100644 arch/arm64/boot/dts/airoha/an7583.dtsi

-- 
2.51.0

