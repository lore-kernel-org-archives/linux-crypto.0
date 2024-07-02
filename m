Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219F91CB313;
	Tue,  2 Jul 2024 18:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719946612; cv=none; b=XIBbAfnNdjgbmtrYSU1adDWmaujmPMvisL6zpROAkNrkK6rzJP6m4abW5JULkSNVdKcn6xobrmxvYC5IvBEr6ujJt8PnOV+BEDu7F3XaYDaXnfxHYh6lcRXlxtvs5uJbeymCuqVGM/jAUu5+/dyEth663megaAroHtuxKkszXLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719946612; c=relaxed/simple;
	bh=oZCuWrk77Oh6MOcRNODRuXQLaDoO86CGQtEiADu7gFY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eMZ9m0sqcjAJ6nNiy+DaUUATtZY1Tl0RYoepOBdNEpPBC5a/jqkEcFf1NeC+gVQUaJx0oShFxSG8OSTUWvcrwVVJJMleQO7W7AVdOR8oKmYTbdkKAaAohpn+xU0g4gFkUB+C8izpGs8DFo3sjULmcf2ATRpCijmV91KrGoor5MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a732cb4ea31so610612566b.0;
        Tue, 02 Jul 2024 11:56:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719946609; x=1720551409;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DTTcbpXMOFADYW0lRHSPwqJdZc7vf70BCGyE+fxxMmA=;
        b=MkcFnSG9/wkJxaZg5Vnt5i4blqcNl6qML9L81VMQ2od4mGrpNYjGPc/GbjEMxh/Bif
         BFm7Tzp6wnsA/NT35W5Zz5z/dgfqFY9duc9Sv5j3xFXoDp93pqWVUM61Sdac7cANe0EQ
         T5csQgDktn1Yiqz0+xmuOPLyHkTd6+wYZyKON9dFhBG5rZzHKA54ec0PGCNMf+gjMWaD
         M51mJrmI5943oskiqz9gVChAje7KvZaUVvymbQ8OeewHue1JO3kDtnH+lCzwPGueq2oL
         9LOqcwFmNrqB5umJ6ecR4UJ4spHiQHVmnyTPDe7xD1tx5Glv4+M5wQnS/Ev1gWLPW0m2
         SFEA==
X-Forwarded-Encrypted: i=1; AJvYcCX+XsCvoymkN9uPCLwjANFUKTJb5ex8VBq+ZCxOxsZnE20uoaVYFeyH5gk68zf7ttmTp4ZKw3k5WsyKT8yRbI2WbOh6zXFOV2G6ZUG2MS8TMXZJ7K/Iik3/W4UxUF1OCsJc4PtMjWJlItocihSEl1/z6bGNbYtH1bdWBq2+XCpAO+Au
X-Gm-Message-State: AOJu0YzhBDXxG3wk7mawZOHXJpeCjRHNCIr5tZZqqT8jkFGP6+4y3Mn0
	LWN3c/02antmVqBiy03TaCfWl4p9J11/pTjuG7VjMDxr/j719EXW
X-Google-Smtp-Source: AGHT+IGdP6OiJHfi7JEGv9W7ei+6MpmPcS2a8RBrZUry8A/33/AybdkBk5mhiEmuBAcjdpUEwGdfdQ==
X-Received: by 2002:a17:907:c1f:b0:a73:9037:fdf5 with SMTP id a640c23a62f3a-a751386d999mr908347766b.6.1719946609215;
        Tue, 02 Jul 2024 11:56:49 -0700 (PDT)
Received: from localhost (fwdproxy-lla-114.fbsv.net. [2a03:2880:30ff:72::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72ab0900f1sm441886766b.168.2024.07.02.11.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 11:56:48 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: kuba@kernel.org,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	linux-crypto@vger.kernel.org
Cc: horms@kernel.org,
	netdev@vger.kernel.org,
	herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 0/3] crypto: caam: Unembed net_dev
Date: Tue,  2 Jul 2024 11:55:50 -0700
Message-ID: <20240702185557.3699991-1-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will un-embed the net_device struct from inside other struct, so we
can add flexible array into net_device.

This also enable COMPILE test for FSL_CAAM, as any config option that
depends on ARCH_LAYERSCAPE.

Changelog:
v3:
	* Fix free_netdev() deference per-cpu (Simon)
	* Hide imx8m_machine_match under CONFIG_OF (Jakub)
v2:
        * added a cover letter (Jakub)
        * dropped the patch that makes FSL_DPAA dependent of
          COMPILE_TEST, since it exposes other problems.
v1:
        * https://lore.kernel.org/all/20240624162128.1665620-1-leitao@debian.org/

Breno Leitao (4):
  crypto: caam: Avoid unused variable
  crypto: caam: Make CRYPTO_DEV_FSL_CAAM dependent of COMPILE_TEST
  crypto: caam: Unembed net_dev structure from qi
  crypto: caam: Unembed net_dev structure in dpaa2

 drivers/crypto/caam/Kconfig       |  2 +-
 drivers/crypto/caam/caamalg_qi2.c | 28 +++++++++++++++++---
 drivers/crypto/caam/caamalg_qi2.h |  2 +-
 drivers/crypto/caam/ctrl.c        |  2 ++
 drivers/crypto/caam/qi.c          | 43 +++++++++++++++++++++++++------
 5 files changed, 64 insertions(+), 13 deletions(-)

-- 
2.43.0

