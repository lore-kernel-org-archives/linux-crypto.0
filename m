Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14075315BE
	for <linux-crypto@vger.kernel.org>; Tue,  7 Nov 2023 15:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="lb1Z3uYh"
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518EF46B6
	for <linux-crypto@vger.kernel.org>; Tue,  7 Nov 2023 07:55:46 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-507ad511315so8432593e87.0
        for <linux-crypto@vger.kernel.org>; Tue, 07 Nov 2023 07:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1699372544; x=1699977344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dwIY2rn/dEbSPVpdhU2+f4uOVwzcygzYY5LLYZc61cU=;
        b=lb1Z3uYhdRyz+ZQZdcQkp/JsP7erLsukxm7K8ttXw7a4MDTx7nAjWilC6/ykwBsSiz
         9ah6PDdkJFggacY5pjPL/Dq9458r7WcbRlWSuHNZrawPl+jMNbPcocRSU9L1BsGC77GW
         FW9k5tqQQ8MZmTjtZWEEPfP74P6wO0N2OKZ/SjGTjTtmLjx4/x06Z09vLqa4MJhaPx5E
         NPoDdY6iEM7EFGmVlMzlAOqj5jw/Flee7uU1q+yourjDzxHunDhuyLDrpCDqGQMDdHmr
         3IJKP8KAXqO/2agU9twgDZHpNndk2Uxwycnu60orLpYw6bUYHcN//VsfEJVr2kBmC6qu
         h1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699372544; x=1699977344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dwIY2rn/dEbSPVpdhU2+f4uOVwzcygzYY5LLYZc61cU=;
        b=onhmzsXACSXfIE40NvPKzOWvDNLyhDmSdWdUy9eYGBAqHXnRlQGCHP4Ys794KLAZXq
         HjM0Ggp0wdDoqY7eFmoCUvCSlEKblD1Ftwbv7wo2OCkNdkMqraV6fH+OOr/2uHkxHcmV
         Vdhu/Ezn3n+zPughblhEqZoGExPdd7FGUwgAjx7Q4/XFzvADbLxK2TrAzlJzN9ikQFer
         LvrgFXrQJXTQRyMNb9SmIl+ZRlINKWADgdztjv62QYNywr+CF2+QK5HeJFEdNPsaU0bq
         oMxCzvQFo49b437M7TYLQI8lRwdiyAccyzs2ulcudpQS6dQ7fHPizD09uL92wVrDNb33
         GWaA==
X-Gm-Message-State: AOJu0YwSHzLmYWrG74n0rANmafTmgQpFknrPTTAbqZ4YcK0tdYEzz6R+
	8bKVLcGAavxUFiD3AcqOLgse5Q==
X-Google-Smtp-Source: AGHT+IEW/M54tsfmWAXd/ApYtb7f8HXdpcpbgcYJR/UxDO6jor1uWlDWpgFp9h1Fwj1h6vqEmi/WOg==
X-Received: by 2002:ac2:430a:0:b0:503:257a:7f5d with SMTP id l10-20020ac2430a000000b00503257a7f5dmr21683796lfh.31.1699372544418;
        Tue, 07 Nov 2023 07:55:44 -0800 (PST)
Received: from arnold.baylibre (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id f6-20020a05600c4e8600b003fefb94ccc9sm16579085wmq.11.2023.11.07.07.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 07:55:43 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net,
	heiko@sntech.de,
	herbert@gondor.apana.org.au,
	krzysztof.kozlowski+dt@linaro.org,
	mturquette@baylibre.com,
	p.zabel@pengutronix.de,
	robh+dt@kernel.org,
	sboyd@kernel.org
Cc: ricardo@pardini.net,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-clk@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 0/6] crypto: rockchip: add support for rk3588/rk3568
Date: Tue,  7 Nov 2023 15:55:26 +0000
Message-Id: <20231107155532.3747113-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello

This patch serie add support for the new crypto rockchip IP found on
rk3568 and rk3588.
It was tested with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y

I would like to thanks all people which helped to test this driver

Regards

Corentin Labbe (6):
  dt-bindings: crypto: add support for rockchip,crypto-rk3588
  MAINTAINERS: add new dt-binding doc to the right entry
  ARM64: dts: rk3588: add crypto node
  ARM64: dts: rk356x: add crypto node
  reset: rockchip: secure reset must be used by SCMI
  crypto: rockchip: add rk3588 driver

 .../crypto/rockchip,rk3588-crypto.yaml        |  65 ++
 MAINTAINERS                                   |   1 +
 arch/arm64/boot/dts/rockchip/rk356x.dtsi      |  12 +
 arch/arm64/boot/dts/rockchip/rk3588s.dtsi     |  12 +
 drivers/clk/rockchip/rst-rk3588.c             |  42 -
 drivers/crypto/Kconfig                        |  29 +
 drivers/crypto/rockchip/Makefile              |   5 +
 drivers/crypto/rockchip/rk2_crypto.c          | 739 ++++++++++++++++++
 drivers/crypto/rockchip/rk2_crypto.h          | 246 ++++++
 drivers/crypto/rockchip/rk2_crypto_ahash.c    | 344 ++++++++
 drivers/crypto/rockchip/rk2_crypto_skcipher.c | 576 ++++++++++++++
 .../dt-bindings/reset/rockchip,rk3588-cru.h   |  68 +-
 12 files changed, 2063 insertions(+), 76 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
 create mode 100644 drivers/crypto/rockchip/rk2_crypto.c
 create mode 100644 drivers/crypto/rockchip/rk2_crypto.h
 create mode 100644 drivers/crypto/rockchip/rk2_crypto_ahash.c
 create mode 100644 drivers/crypto/rockchip/rk2_crypto_skcipher.c

-- 
2.41.0

