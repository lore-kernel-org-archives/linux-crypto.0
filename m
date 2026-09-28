Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B154D6C2A;
	Mon, 28 Sep 2026 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790604075; cv=none; b=I/ZV4ukabhipXR5tR4L9OvPv/GV8Ib+m49tRUyTLdWiwi/zbVmBt9Z7Ghu429vxri6g4vUQpBOdyrxoVS2d6zkEK3ibHWKPHgQTai+8bW3CWI5lxfSX5xbBq3E2PUilBmIMOnGeWxzC0qZqa2+KNB/ED3fav3rN4aIr5hcvooRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790604075; c=relaxed/simple;
	bh=XYrNlKJfrj2ruygfi45wHsY8oQRCp3XANErbO8AegLA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=IpCCGl7Z0zcT0IIE3EjPtXbztQnpanqR3KRuh93uhJCiKU1Xurd/YjHuKuR/bav7JFfbS175GCItzutXCn0MUa6UAgZfBwX7DlzIijRKglMuq21cGCExaghWLYPFLaPWwvOBFe+Gp0QBoHBlRh21bbaNSeYAOVncIspH60F9Hqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h851FyLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h851FyLT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F118C2BCB3;
	Mon, 28 Sep 2026 14:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790604075;
	bh=XYrNlKJfrj2ruygfi45wHsY8oQRCp3XANErbO8AegLA=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=h851FyLT/b4LdRtD8KIrWOtGBnJm+DA24eRW7am59L7Sf37RgUm+yEkURGgwrLRuW
	 wME/uSBQxpV70jBHRDC6KI3O3+RtBpWt/lFLZNerXI9v1silXEJK/i8mwyXogJXqd1
	 MaEJzvd6Kh8S9oM6quEUEFOuvsUoGQlTd1wkElzupl6fkCgnIjYBBzhuijV56dftfC
	 oc3I2w2XzGsl4TBVHl14eOMZn6DJ6qtiWx9izX6Jo8y2/18Wed3KDRXnBI0oydeJoS
	 zPSVd1lkVkA50Hk6eh/Un3dYrkXlaZbVSHjeZqYoYEohCmuLS0I8Fry6UHg8YL3VJW
	 mXyf6/wgSTT0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E1DCA5FA5;
	Mon, 28 Sep 2026 14:01:15 +0000 (UTC)
From: Vincent Jardin via B4 Relay <devnull+vjardin.free.fr@kernel.org>
Subject: [PATCH 0/3] crypto: caam/qi2 - algorithm priority configurable
Date: Mon, 28 Sep 2026 16:01:02 +0200
Message-Id: <20260928-for-upstream-caam-qi2-priority-v1-0-e4a8e5f01dbc@free.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAB5zumoC/x2Nyw5AMBAAf0X2bJOqpB6/Ig7FYg+0tggR/65xm
 WQuMw8EEqYAdfKA0MmB3RolSxPoZ7tOhDxEB620UZUucXSChw+7kF2wtxEba/TCTni/sTC5yrq
 SutwaiBEvNPL1D5r2fT8//3uZcAAAAA==
To: =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, 
 Sahil Malhotra <sahil.malhotra@nxp.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Gaurav Jain <gaurav.jain@nxp.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 devicetree@vger.kernel.org, Vincent Jardin <vjardin@free.fr>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790604073; l=1011;
 i=vjardin@free.fr; s=20260525; h=from:subject:message-id;
 bh=XYrNlKJfrj2ruygfi45wHsY8oQRCp3XANErbO8AegLA=;
 b=SdkmtfGZjjyyX3oa2lSJEBtFOAmanXuPOAaDp1mtzN1RuMUa+Y52jJu05K55rB8zeuLMLG36R
 eRyBKiGjGwnBrpEwXp7KE9npVKRbFJnvsBrIOWJ+3VOJmvS3LRsHF61
X-Developer-Key: i=vjardin@free.fr; a=ed25519;
 pk=hppgLeFpGpKOi7LNwGEZ4jOYofJCoGd4Jf1ltAabiLw=
X-Endpoint-Received: by B4 Relay for vjardin@free.fr/20260525 with
 auth_id=871
X-Original-From: Vincent Jardin <vjardin@free.fr>
Reply-To: vjardin@free.fr

dpaa2_caam registers its skcipher, aead and ahash algorithms at a fixed
priority above the ARMv8 Crypto Extensions, so on DPAA2 SoCs
every in-kernel consumers of AES, SHA or GCM use the SEC.

Patch 1 adds dpaa2_caam.priority module parameter
Patch 2 doc fsl,qi2-crypto-priority property on the SEC node
Patch 3 reads it at probe, the module parameter takes precedence

Signed-off-by: Vincent Jardin <vjardin@free.fr>
---
Vincent Jardin (3):
      crypto: caam/qi2 - algorithm priority be a parameter
      dt-bindings: crypto: fsl,sec-v4.0: add fsl,qi2-crypto-priority
      crypto: caam/qi2 - priority from the DTS

 .../devicetree/bindings/crypto/fsl,sec-v4.0.yaml   |  9 ++++++
 drivers/crypto/caam/caamalg_qi2.c                  | 35 ++++++++++++++++++++--
 2 files changed, 41 insertions(+), 3 deletions(-)
---
base-commit: 67aefeccc4101a93627f36abbd049f191b54f903
change-id: 20260928-for-upstream-caam-qi2-priority-76301b8eb3a6

Best regards,
-- 
Vincent Jardin <vjardin@free.fr>


