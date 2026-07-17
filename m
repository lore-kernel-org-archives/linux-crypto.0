Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1862619E992;
	Fri, 17 Jul 2026 02:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256507; cv=none; b=Z32S2pBfd3xbKOyZ8BPYwWdZy/O8by4sfKgZRidsdRWGSHxfDukbRiAGwiKw3Y2piV+u5bKHtMil0Dnz50aOznLibGKRO/OYukmMUlmV+KSD4RGfuyM9Kd+mRItVOaGHbRlBflxxhTVx8AKzi1iC3IjSDY/dN+yDML3rSIoZKKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256507; c=relaxed/simple;
	bh=qUdKPOWhvKpCAZNjoiiHvpMB8rSPJjuaez3+k+lwra8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sVLuCFnrda/vZqooDklRHcbVz08R2kvMcEdIWeauKchmacJt7hg55FHsv4Qb0ngCiF8JutOW6CyKFw4he0HG2hxWGQ0jB1jYaVgp0JKr8k/e8BkrSEuuoFD+ZPWPnxkIQE74nISW9thGRDwS/nUT5o8EXizkHw6bLfdSoFYjwEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NXv8VZbM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXv8VZbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC861F00A3A;
	Fri, 17 Jul 2026 02:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784256505;
	bh=qI1fcBRYf67H0Pdsn6efpipZ2swQYLxkGQ0LD3be7+Q=;
	h=From:To:Cc:Subject:Date;
	b=NXv8VZbMPu1VE+ETGb85NoK1uh2ENUbii72M4Q6L7I/VWff4aWP0XsCuZ83xluZBN
	 iGhy1if9QVJb77IojoOAP0XtOpWUhVCBJFh791n0E9cowFOOVjL/aJ8KFMgQde0Xq/
	 VTmtnjZgqgBseFJ78NP3A+rtuT7dEo5SbkJOnvSFiKmWgXyMftDPo60gMy7FGsNIgq
	 unaAoh/P7cucQZEE+3SZtp3K529ZvWyaBrawJsd8XcuBGAFOZ0DooRR8YZ00+uek2d
	 PX9pNlpqTcUSqolRbgGnPSKjlMqF1ctiyAlYltZomZAQAqeLtOGsjwxQ5VoXBGxfr2
	 AgNT0PJxh5k+g==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 0/3] crypto4xx stable backports
Date: Thu, 16 Jul 2026 19:46:02 -0700
Message-ID: <20260717024605.87486-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes for the crypto4xx driver.

Aditya Srivastava (1):
  crypto: amcc - fix incorrect kernel-doc comment syntax in files

Eric Biggers (1):
  crypto: crypto4xx - Remove insecure and unused rng_alg

Herbert Xu (1):
  crypto: crypto4xx - Remove ahash-related code

 drivers/crypto/amcc/crypto4xx_alg.c     | 114 +-----------------
 drivers/crypto/amcc/crypto4xx_core.c    | 148 ++----------------------
 drivers/crypto/amcc/crypto4xx_core.h    |  15 +--
 drivers/crypto/amcc/crypto4xx_reg_def.h |  19 +--
 drivers/crypto/amcc/crypto4xx_sa.h      |  18 +--
 drivers/crypto/amcc/crypto4xx_trng.h    |   2 +-
 6 files changed, 30 insertions(+), 286 deletions(-)


base-commit: 738ac465e4e900d4a391a27da4e20c090eaa1e75
-- 
2.55.0

