Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAE93A0E99;
	Sun, 19 Jul 2026 15:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473259; cv=none; b=m/4X02rgwJBYYmWvpTJ8Z56jAWhAIV/XuaSXd9IkvxPXILbc2atv20OzWbdcW3TJ7h9+tM+pRPVe7ayAPW78Qwmo+T+wsLIsQZ1AI1J/QAWKGB3n1S9zDyV2pVIEJUPkluJZ2qhD4cy+idb8LQZMxITjytk0uwR3im+8dzcvifY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473259; c=relaxed/simple;
	bh=FYBK2mbUYGvPfaJo1sURGLI0FW0b6PWgrhVdmgbLKYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kP+uXl4x6qeIInqCr4daYeRl+77qxFMCNZ7AuE6DE1C4/zQZI4PDtOJOiUvuWLxAH9QJ/if+23LXgKdgxBNzsAojVmhVsesrHmWMAyFpUABB9/2lESKxf6Bbm8jklv2HyNKJJs4h9Rzd0Qfj2mostiaMo2/K7l//kHF0G8UhbW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAxliiwP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAxliiwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14841F00A3D;
	Sun, 19 Jul 2026 15:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784473256;
	bh=tiiqypAbzZsC/bb9/3cNsoPUtzvwfv9sXr7zNAPEmdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAxliiwP72YqurX1uZ//bdmZkU3Jsh0aVXxYgN2M6EmaVdj5pk6EdnZF7EUGal09q
	 0f3/glZCoFJAnGG3T+FQgxpSNv3fNAy1rnmbFM4EtruMegLE+IqTzZCEPspCAhsuFz
	 mYFy/e1Kz8nlDM216PZvXDqfcf9y2cUPBvfi4jdrKJ9XqWPgH/Z6zXrQgLh4Rsoprr
	 FzFAiy8W6hjWrBXFVcCQt11JjKeUN1ErGpGTFHH0mJb2ZZJITn45RVdzpFx39Mo7gq
	 MQoJQ4sFhBoEPx51GtPvyKSL/thJnZjhz8QZtPb/i52DQ0ptRN7ABRA3/5nKB6cZRr
	 VdfzAricn8Suw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-crypto@vger.kernel.org,
	Weili Qian <qianweili@huawei.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6.6,6.1,5.15] crypto: hisi-trng - Remove crypto_rng interface
Date: Sun, 19 Jul 2026 11:00:29 -0400
Message-ID: <20260718192718.0015-stable-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260717034254.328204-1-ebiggers@kernel.org>
References: <20260717034254.328204-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> drivers/crypto/hisilicon/trng/trng.c exposes the same hardware through
> two completely separate interfaces, crypto_rng and hwrng.

Queued for 6.6, 6.1, and 5.15, thanks.

-- 
Thanks,
Sasha
