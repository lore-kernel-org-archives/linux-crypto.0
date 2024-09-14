Received: from mxc.seznam.cz (mxc.seznam.cz [77.75.79.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34B546425
	for <linux-crypto@vger.kernel.org>; Sat, 14 Sep 2024 12:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.75.79.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726317797; cv=none; b=RbrEvZVn+iJ+4OO0qMKO8mMbp4YO0vGFTsMHwhfwOFwIThNztN9VacoScnP0y2uzXSgUHooWkQS8QN49LvShN8spBP8J6A3LIaiJoXxXdy33qxMqGhS1+rHaD0Bg9w2tR4E7/dYih5JX7nTqQHEsBLtQw9uC/OXjkweX2nG1+Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726317797; c=relaxed/simple;
	bh=8gDdLYHG/bPQhFBekHGZlHMBrkBrj2F7insIxZX006A=;
	h=From:To:Cc:Subject:Date:Message-Id:References:In-Reply-To:
	 Mime-Version:Content-Type; b=kedfPHZCTbdrw4IxogihaZlimoDGJiWsUttNJi1/+uMJReF1/d4cunnj1Qp+VdXsyotJyZmLKZ0ogJ9AVW/dZHiw03+uSGM3+O8mZbtteg6klVRRBAG1zUhPhQo+mCihj3dGlhBn/LR1f5Emg/CTNkgbmJunNikETPMsPVVdl4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.cz; spf=pass smtp.mailfrom=email.cz; dkim=pass (2048-bit key) header.d=email.cz header.i=@email.cz header.b=hmPKfbJn; arc=none smtp.client-ip=77.75.79.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=email.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=email.cz header.i=@email.cz header.b="hmPKfbJn"
Received: from email.seznam.cz
	by smtpc-mxc-75d4bf4556-9mrqt
	(smtpc-mxc-75d4bf4556-9mrqt [2a02:598:128:8a00::1000:99a])
	id 1ffe80ede10a32471f700ef5;
	Sat, 14 Sep 2024 14:43:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz;
	s=szn20221014; t=1726317792;
	bh=8gDdLYHG/bPQhFBekHGZlHMBrkBrj2F7insIxZX006A=;
	h=Received:From:To:Cc:Subject:Date:Message-Id:References:
	 In-Reply-To:Mime-Version:X-Mailer:Content-Type:
	 Content-Transfer-Encoding;
	b=hmPKfbJnOAjk5VVxd4w7jvMUWaU3oDmnTY2e/tP9XTm/cEEIOvCjtlGGrkAhLtbSq
	 cP5404FJxfGP/9CBlzb2O+Oi+mw2r4TQaGCpC1ndmwNnRLJsew6PsQSrI1LvHR9uAG
	 66lXpnQZfQg+MAZng5xaBb4uHchfxR7KEnu9pAuVOfvtfvQY8P0QK7ulL3y8aWRmqM
	 3aJXJbCnEvLEc0F7R7P5r00j21K/oS2Ohj+Bf5g7qTBrCeCrcZEFDmvYrz0B5YEtDr
	 Nzshsdcq+FsU+BLh2tD3aW/KjfmYByG6WCLc1qaeJXabQrwvhAq6zJVSPua2TgfOZn
	 zF3GDIUMLEz3w==
Received: from 184-143.ktuo.cz (184-143.ktuo.cz [82.144.143.184])
	by email.seznam.cz (szn-ebox-5.0.189) with HTTP;
	Sat, 14 Sep 2024 14:41:23 +0200 (CEST)
From: "Tomas Paukrt" <tomaspaukrt@email.cz>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Shawn Guo" <shawnguo@kernel.org>,
	"Sascha Hauer" <s.hauer@pengutronix.de>,
	"Pengutronix Kernel Team" <kernel@pengutronix.de>,
	"Fabio Estevam" <festevam@gmail.com>,
	<imx@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_crypto=3A_mxs-dcp=3A_Enable_user-spac?=
	=?utf-8?q?e_access_to_AES_with_hardware-bound_keys?=
Date: Sat, 14 Sep 2024 14:41:23 +0200 (CEST)
Message-Id: <26J.ZcYd.2XLMv9N98Uy.1cvOHp@seznam.cz>
References: <1di.ZclR.6M4clePpGuH.1cv1hD@seznam.cz>
	<ZuVKtuMqiCu67hn2@gondor.apana.org.au>
	<24h.ZcXr.7FvRaSxxibG.1cvNHL@seznam.cz>
	<ZuV1zguLBsBZnGB5@gondor.apana.org.au>
In-Reply-To: <ZuV1zguLBsBZnGB5@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (szn-mime-2.1.61)
X-Mailer: szn-ebox-5.0.189
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

> In that case I would suggest introducing a flag so that the key
> can only be accessed through the keyring subsystem.

Do you mean CRYPTO_ALG_KERN_DRIVER_ONLY instead of CRYPTO_ALG_INTERNAL or =
something else?
