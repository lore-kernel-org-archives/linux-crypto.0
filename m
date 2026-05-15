Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499EE31CA4A
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 05:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778823743; cv=none; b=Ub+kjPnHMd6RG5AfX7CFC+/ZT8RqXGPD3RgqBAoNyqkd8Rd8zppJCSZV3Ay/0tv4gt+nDS+/c7NnvfRdL4QmGmN7hoBhyK4r+Rnp69wWzfPKX0Pj+xue1Os2PL26Pq3xOUPxgYuNmRzExlHIys5rQ9z1g+bxZVaTHNE9hogZbaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778823743; c=relaxed/simple;
	bh=4ujO8YPn+C6kly/QIxgqk2+iFaoJUzR0JdPeVgifXGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvqinM4H8mizcQ8KgnQHPZx2Bf3SyYzQgcZ/ykhUUS4OViL2BUIikPxsusSCryH9/W7FLTHxXrZaIq9xuWBn1AGN9dPNbBG22zc86iUg6ldSzOUSZnvjRK0RN29QR1HYnM9wd1Iwm7FBbBBEiryp71vrrG1rLLg4IB4nSwCPoPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F/uTGYHL; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/uTGYHL"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c8021c8c42fso3826803a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 22:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778823742; x=1779428542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5BD6jb0vjKtzgJh8F8xKpey20kEfF+Odim4ezk9P1XI=;
        b=F/uTGYHLT8VYmGW7uUL+D8T/AA74P6prWB53VB35e1Kcxs9A1li02lUUJfl59m2XPG
         UY9OLwSN6S+/GyHL7u9w6UurHJG2uXT6EofbCa31igySqpYGx2ecTIpBe5XaqdKQrW0c
         zMB0Q5Vt/vCsG/kUXnNwsxqCm2edDNVb6h7iwTs6LrrYPs0mGDZOywnYqXOq//V1Xq8N
         Z3CgISE7MVDvS/pAtRj4lRWSEYv5Mbaxe+nEhv/DucluH8eIFkne84tkuLaoGmLlu12m
         Y6Wr6qgXaZu8EKxu1EzW/9XGVTu+kYxXKeeW/icfozYKB0+QwoxhDMuq+FGy/7nj9Oxd
         8Z4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778823742; x=1779428542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5BD6jb0vjKtzgJh8F8xKpey20kEfF+Odim4ezk9P1XI=;
        b=qmuJCV3VkNr0oDsAY/piyTiaEljCAoFPmJDM6FkbqjZD39PPOP5b+AgmJQAi1MZGOq
         EZdV/UYl2mMDFwBQyMzSExUCIsL83az0o/4qh0LbLWLCMCTVPSkEz6JLZqiUusHeHQmR
         YlR/gXuckr0BHrveVXElCo58ZcaEgcqtMVmaJ/icsoK9+3DQlMDlTSgGwG/Iv1ut8R/l
         vHz1Ks8SG4GEjXeWsMCKB7wFZNqJJ0Ec40hL5JAfUg57Uu1OSn8R3SYV4g7bt2QKEuB0
         aaKrYx0oWi5NH80js/GaZHd00lh5zCUIzJptgffkfo+LLQ/fKxVojxIW6nesBsJNcjYb
         bYqg==
X-Forwarded-Encrypted: i=1; AFNElJ/nHLnjY5sf1zM8q3mUshcfhcI6gDZlnzFvyEnxvG98a5/dO+CYMbDE6lG+V7sBvfA/prXW+siyZPxQC7A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzABSoB5WdnmelqgS4IAZyxCef30yDZXj7forMb9We65dI5harc
	qBOZnR01WXdJyNlQYz/gWBpq7htp/uRRuf0n4eVktMOD2aeCoYVln5oW
X-Gm-Gg: Acq92OGkUpKtPfPaCpKZ7ryvm5god8KLk33c7yK+3bKaG75zdjYu1Gen6EKXUtNj1kv
	UDqhvAUdPqCrvlhtsQTuD2IihtDnu9rbwySiX/VsdCpJoNSHBsjTpdOCpvkNwYlWu4psAPCFAAu
	7jai7CIvN4cV1iL5e2NWbbCek6hAxYBIl5Z4dy53L1AcL2k01YDnbWdSWzFbu2NjbJC6PBVD8GX
	nZHTFWt0SHsNG+3qnKXzc5MCDaCAg5RIdsyUZLHhykyJnCAzPgwZhlmXyJY4cX4xm1KfYy9gTYI
	CRfyxsR5NaLnH53IezkMlNlPCdEt6zlQvErEPHfbfiVPiQK1x3z1dMpelvZBhoRX8PhB7PF0QPj
	A7cr3tGGL+c/kAMJe2rTkw1UmEqZpk6RTOykD9/fjYXge97wHSWUqFAslTDlGPQd6xlaQ7rBXuS
	y2PViDXBDSLEg8jYCvckylOb9qZ28P0gp/lZCHKY7E1oxALF/t/AwlR5oH7FvcbcrJdNxL0E6IF
	sklSKvaTu8mY4/KFcjdzOwM1/w=
X-Received: by 2002:a05:6a00:1954:b0:835:366f:5da2 with SMTP id d2e1a72fcca58-83f33d80937mr2828691b3a.37.1778823741521;
        Thu, 14 May 2026 22:42:21 -0700 (PDT)
Received: from harrison-Surface-Pro-12in-1st-Ed-with-Snapdragon.wework.com ([203.117.161.34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f2b9bec8fsm3106116b3a.33.2026.05.14.22.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 22:42:20 -0700 (PDT)
From: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
To: andersson@kernel.org,
	konradybcio@kernel.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	neil.armstrong@linaro.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	jikos@kernel.org,
	bentiss@kernel.org,
	luzmaximilian@gmail.com,
	hansg@kernel.org,
	ilpo.jarvinen@linux.intel.com
Cc: Douglas Anderson <dianders@chromium.org>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-input@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH v2 0/7] Add support for the Microsoft Surface Pro 12in 1st Edition (Snapdragon),
Date: Fri, 15 May 2026 15:41:45 +1000
Message-ID: <cover.1778822464.git.harrison.vanderbyl@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <177869930359.1496076.12020223802779537187.b4-ty@kernel.org>
References: <177869930359.1496076.12020223802779537187.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes in v2:
Ice device tree: 
 - Updated to use 0x0 formatting

Panel: 
 - Add edid to commit message

Device tree:
 - Fixed formatting and ordering nits
 - Removed extra dmic audio declarations
 - Added suspected devices on i2c busses
 - Fixed incorrect usb regulator
 - Describe panel pin regulator
 - Added defaults for volume button GPIOs

QSEECOM patch (4/8 in v1):
  - Applied by Bjorn Andersson
  
Hid patch (5/8 in v1):
  - Acked by Jiri Kosina, but not applied yet.

Link to v1:
https://lore.kernel.org/all/cover.1778498477.git.harrison.vanderbyl@gmail.com/


Currently supported:
  - UFS (with inline crypto)
  - Touchscreen, pen, cover keyboard and touchpad (via SAM)
  - USB 3.2 x2 with DP Alt Mode
  - Audio, WiFi, Bluetooth
  - CDSP, ADSP, GPU
  - Display (BOE NE120DRM-N28 panel)

Not yet supported:
  - Accelerometer
  - Front, back, and IR cameras
  - IRIS video decoder

Note on the compatible string: unlike other Microsoft Surface devices
upstream (denali, arcata, romulus13, blackrock), this device does not
appear to carry an internal codename in firmware. The DSDT, SMBIOS, and
EFI variables only refer to it as "Surface Pro 12in 1st Ed with
Snapdragon" (SKU 2110). I have used `microsoft,surface-pro-12in` as the
compatible. Suggestions welcome.

Although the device is marketed as just a smaller version of the denali,
it has enough differences that it warranted a different compatible and
device tree.

Tested on Surface Pro 12in 1st Ed with Snapdragon (SKU 2110).

Harrison Vanderbyl (7):
  dt-bindings: arm: qcom: Add Microsoft Surface Pro 12in
  dt-bindings: crypto: Add x1e80100 inline crypto
  platform/surface: SAM: Add support for Surface Pro 12in
  hid: Pen battery quirk for Surface Pro 12in
  drm/panel-edp: Add panel for Surface Pro 12in
  arm64: dts: qcom: hamoa: Add inline crypto for UFS
  arm64: dts: qcom: Add Microsoft Surface Pro 12in

 .../devicetree/bindings/arm/qcom.yaml         |    4 +
 .../crypto/qcom,inline-crypto-engine.yaml     |    1 +
 arch/arm64/boot/dts/qcom/Makefile             |    2 +
 arch/arm64/boot/dts/qcom/hamoa.dtsi           |   10 +
 .../dts/qcom/x1p42100-microsoft-sp12in.dts    | 1201 +++++++++++++++++
 drivers/gpu/drm/panel/panel-edp.c             |    1 +
 drivers/hid/hid-ids.h                         |    1 +
 drivers/hid/hid-input.c                       |    2 +
 .../surface/surface_aggregator_registry.c     |   15 +
 9 files changed, 1237 insertions(+)
 create mode 100644 arch/arm64/boot/dts/qcom/x1p42100-microsoft-sp12in.dts


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
prerequisite-patch-id: a34133ba03bd1d31c0ed08612c31131b62015654
-- 
2.53.0

