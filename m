Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEF3241699;
	Wed, 15 Jan 2025 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736946446; cv=none; b=rGyvMwdyMLOX/kNCadp95icPDsZsozwyAncQONdAv0GOE3Vrj7mK5ZUoTN+fxVNFet0YBuu+wJvCeL6SPlEVarftDey9tFd2DoMCc5tDjqUM6/dDR6YnV8CkuM1ikVbmb7hL+wbw8GRDo2kx4ABInAyTZ+m7/nFcAOby7eqlTxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736946446; c=relaxed/simple;
	bh=ukzKgbsdkZXZRHmaAiUpzyJ0aw9IxcNOmeqo144mu6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ku1LxsI+OzsmgUcRl0/rEz4kgcLa0TsGVE28mU1lNsLC2ya8u9mChm/EYCg3BjCrUftDExtinQX0m2JmzC3lPSjf9KUxwJWerjOOPY9X2gSGzA5ILA8DMHJix1HV5OjTVwPI0l1Vr/gDWY5eICriVG+DV0FgY8qDawuupBrfF3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=gzRBe6fm; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="gzRBe6fm"
From: Dragan Simic <dsimic@manjaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1736946443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rJo0rOx2QxWkj5/VaolJ2k0fcuLfsY4p05VifL9KrrM=;
	b=gzRBe6fmeV8Ps4quPBtcKjaOhPNC5rbmCKT9J11SpgDe2HTotpH9atONESRIsddH7tCrXR
	bLt+QhneabpeTGNPt8y66W7aoCS7UUhnqfDHpeoyVo+ryPF7jbSqj2J6TzoYKNq6SgDCP3
	5P5poCa3jmH3xWBifWVs/ncZnXU8OMvaCbqu04TqD3xJ0gMlHpceuluVhl4Bs0KnHHykpJ
	GNN8GlPwCLQTPJPwJr6RUSRFnCKgB33UScM/y8jOGBYZ9kExcxv8yYrcQwdPxDGMueMHjy
	yAwuWwSnXiQMzmiTtuV1/mHpul4VNv6xMLQNq6DUkIyE5A1L4s7ZY0XbCBnDww==
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	didi.debian@cknow.org,
	heiko@sntech.de,
	dsimic@manjaro.org
Subject: [PATCH 2/3] hwrng: Move one "tristate" Kconfig description to the usual place
Date: Wed, 15 Jan 2025 14:07:01 +0100
Message-Id: <3c08ac4dc06212d7d0408e97b5f92ab8af0dd1a1.1736946020.git.dsimic@manjaro.org>
In-Reply-To: <cover.1736946020.git.dsimic@manjaro.org>
References: <cover.1736946020.git.dsimic@manjaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

It's pretty usual to have "tristate" descriptions in Kconfig files placed
immediately after the actual configuration options, so correct the position
of one misplaced "tristate" spotted in the hw_random Kconfig file.

No intended functional changes are introduced by this trivial cleanup.

Signed-off-by: Dragan Simic <dsimic@manjaro.org>
---
 drivers/char/hw_random/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index e0244a66366b..e84c7f431840 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -534,10 +534,10 @@ config HW_RANDOM_NPCM
 	  If unsure, say Y.
 
 config HW_RANDOM_KEYSTONE
+	tristate "TI Keystone NETCP SA Hardware random number generator"
 	depends on ARCH_KEYSTONE || COMPILE_TEST
 	depends on HAS_IOMEM && OF
 	default HW_RANDOM
-	tristate "TI Keystone NETCP SA Hardware random number generator"
 	help
 	  This option enables Keystone's hardware random generator.
 
