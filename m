Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F192459DB;
	Wed, 15 Jan 2025 13:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736946445; cv=none; b=jDPYaLXcfFXeNFyuPFFWL7EtBEE7QdQGOS90Str5RjpWfz04XPjlKcA7TKKBzq21uCT0jEhcS7GPtcIPNe3Kv5UG17ULPNhaCswSd7tOe/ylB/B02NfRFW6BOeG1mKWT1Y2Ll+YIvOWI9p0i55iu+FlAL5MedU/lCgxvjyj+yYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736946445; c=relaxed/simple;
	bh=jiUzQQYgNYgTkX2QH/oSmKotnYBcVHh+BfGQNqtZiak=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PH91AkjDEhEYlqZx4368qW+pcFteJE1zotwmMBFo7zUN6aNkSWRkIh33F/lFTyt++9vx9UU16RSXgfP77jcaFOLdJ/y0PUfqewqdc1XHNQ7uV1J0UWcMqzbXbkG2QW/+WgRAIF1eyvgYg5ZV0gke4lQ4zGCH8pPlfScH6wsibAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=ixlqWyr1; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="ixlqWyr1"
From: Dragan Simic <dsimic@manjaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1736946441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3cC5veSeJJFc2J0NIeHsX+/1bikH/GXrFqWH05XyBv8=;
	b=ixlqWyr19PZrwel9Ou9xLDILbVeFav9F3Bdk9rkpij4mKuNYHbo5LQ8TH3cxWKI6odHrFH
	kHhdQFPElQSHMsxlNj+BRYC8snDfJSFjRM1nh9sT7it3ZC3okH7pntZu8jvsk+GkGNQWB0
	LUM3aIgDe9+1Rcc6FGwN36ZCis9gpiO5AXLIJcJm6wzknvxah7paJYlA/KErGQ+VXXzK4W
	VOKemeF27WuyF6XeOH+0jcMWM0qTVI0sHVAdviXcboFdT+ZxdXnSJPM0w56zXsSbmnM9rK
	C6tBZDhWDJUP05YoVLiEpTsXVK1w0EGsDSiXi8mpWzqgEV66LuB8LFNy0acYbw==
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	didi.debian@cknow.org,
	heiko@sntech.de,
	dsimic@manjaro.org
Subject: [PATCH 0/3] No longer default to HW_RANDOM when UML_RANDOM is the trigger
Date: Wed, 15 Jan 2025 14:06:59 +0100
Message-Id: <cover.1736946020.git.dsimic@manjaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

This is a small patch series that makes the already existing HW_RANDOM_*
options in the hw_random Kconfig selected by default only when the
UML_RANDOM option isn't already selected.  Having the HW_RANDOM_* options
selected doesn't make much sense for user-mode Linux (UML), which obviously
cannot make use of any HWRNG devices.

Along the way, some additional trivial cleanups of the hw_random Kconfig
file are also performed as spotted, in separate patches.

Dragan Simic (3):
  hwrng: Use tabs as leading whitespace consistently in Kconfig
  hwrng: Move one "tristate" Kconfig description to the usual place
  hwrng: Don't default to HW_RANDOM when UML_RANDOM is the trigger

 drivers/char/hw_random/Kconfig | 84 +++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 42 deletions(-)

