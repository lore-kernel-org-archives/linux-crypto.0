Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAF221C170
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 21:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730324063; cv=none; b=j/M47KNQRjdaNBdftraiGS+OlBY5SgwPuYTq4x5K932RbvmjuQlSTV/HA6iHu/8N9MTZHXU44KGas97IM2G+7422LDIK/NQqCNmHQ6hK/UOaW7cb29pMPPmu3ATCN1b7Xy0pyiYdG0LcYWdaMp76mrYsvSKUWiYrf08875tkKTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730324063; c=relaxed/simple;
	bh=cfEZglRfXM92Rs9VKa/QxGF7CCG/G8uo3RqbR+JtOMM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HXx1/1mftxV2VF+2GdLgzKbQkunm03bbof2zSZf1FxBWqTZiVA2m89gLJcJx0HldiPf6Xyf1tgl1iiyJxX2OU2SaXXwdf0p6L8Cal2zHZDXSB9I9um5c3Q/Z6EAOzkQdKLa9XmO2z5x7sWLjYRM0N4PeYdkNL1ykcbuINGNQFLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=QJCFMNv3; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QJCFMNv3"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2e56750bb0dso216739a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 14:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1730324061; x=1730928861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=57fEAwok3+kDJ02oPopU87vkGpDlety/NkYvCBCJnWo=;
        b=QJCFMNv3e6krGhwq382HjR23u1liVL+u2cUJoX9WgQxOoKk3oUx2+NmhNxxKdjlF+P
         CXlPyCV14Rm49MUTaUfK0bzGcU+m0B75KE78Pecvl/1EHb8SCeioR1L7DvrtK1akGjkM
         rju8vjrEsKK8omNvWLGwWlaxnplOy07WdmY8c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730324061; x=1730928861;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=57fEAwok3+kDJ02oPopU87vkGpDlety/NkYvCBCJnWo=;
        b=pWu2m9ImKin4eWS0rN9Pn7A7L8dtrxsK2GkvCkSb+tNv5+xF//0mGICxlXf+Elgf/m
         y9ElwqLra+H0icVzqWDT+Zx+GpUMCb5X6ITWD2pRciw5tPVsQeqQn1WIfL/wC8J0VgpY
         xFh9eEEaWHS2lP2xfVlfv23hFDRDfGzQSXic7Zz8K9WrzTxfG4WVBm7YB1VEzHXlJD8I
         jCvEnIo+E3sr4gU3kg19HLjuE+wsD2oevnfFsMv1HLTszYXgay4VLaRNdy1/BL6FmfcI
         BJeH8p/eZS/zIyFP0tnuFqs/eY77IiNAuGm3usrArQROp9QG/bPA4av5Zyx3dEQi6XHF
         H9xQ==
X-Forwarded-Encrypted: i=1; AJvYcCXST4eE0DU5YlE1rqxvAlwe+FV3QSI1l+j08wwIpZHbWUnIaiGT3d04B7VJe4lBXus1gY7F5ujtGidDzQM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwylm1ewyWjEbcM6Gm5+WOCdn/HBOo61EMn3c9hu0C7oN2i0e3
	7+bPdB4REb52FP6lHvxNyzOlrIvSymZNPEwUHn0o5dn4OjpTZ8bI3KtojsX5Ig==
X-Google-Smtp-Source: AGHT+IFB0HWyN1/DBBH21gB+sB5G4OUo/anMiUMkhzLTxGINvoKiV41KlsMj+eULdwz0SKgQKoCYKg==
X-Received: by 2002:a17:90a:8a05:b0:2e5:5e95:b389 with SMTP id 98e67ed59e1d1-2e8f11baca9mr17595045a91.35.1730324060684;
        Wed, 30 Oct 2024 14:34:20 -0700 (PDT)
Received: from lbrmn-mmayer.ric.broadcom.net ([192.19.161.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa5f70fsm2372458a91.33.2024.10.30.14.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 14:34:20 -0700 (PDT)
Received: by lbrmn-mmayer.ric.broadcom.net (Postfix, from userid 1000)
	id 4222A886; Wed, 30 Oct 2024 14:34:19 -0700 (PDT)
From: Markus Mayer <mmayer@broadcom.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Rob Herring <robh@kernel.org>
Cc: Markus Mayer <mmayer@broadcom.com>,
	Device Tree Mailing List <devicetree@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] hwrng: bcm74110 - Add Broadcom BCM74110 RNG driver
Date: Wed, 30 Oct 2024 14:33:53 -0700
Message-ID: <20241030213400.802264-1-mmayer@broadcom.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds a driver for the random number generator found on the
BCM74110 SoC.

Markus Mayer (2):
  dt-bindings: rng: add binding for BCM74110 RNG
  hwrng: bcm74110 - Add Broadcom BCM74110 RNG driver

 .../bindings/rng/brcm,bcm74110.yaml           |  35 +++++
 drivers/char/hw_random/Kconfig                |  14 ++
 drivers/char/hw_random/Makefile               |   1 +
 drivers/char/hw_random/bcm74110-rng.c         | 125 ++++++++++++++++++
 4 files changed, 175 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml
 create mode 100644 drivers/char/hw_random/bcm74110-rng.c

-- 
2.46.0

