Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2220F768EA;
	Sat, 30 May 2026 02:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780106831; cv=none; b=Fji0+PB64OmDscldUhXBBcv7gaCM2M/m/7u2ANMC47CLMikP706LXPNYm5eK/CNoxM+ASczg40sloXWqo3aBJ2ts6zziKqDC/mnCRpYVRh72FPPs6hohn9y2FpACSd4/L8FlnEcld0FSpynCLfRRqz7nNdsjER+OlgX1F3ZGipo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780106831; c=relaxed/simple;
	bh=D6Y7LkS+4Ug9cuUqLdTI7BCQwA/dMN9E+f3gXcLslsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J7p0j48gZzaMXibNBdMZFFcd3leC77K/O4j8WgDxjbtVUPlLdVesB1qJ8W76oAi4Oica9gy+DmPQsevX2+lO8hvShZvPlVDHwyOGRc57r1m5eSu53jcXo2zdWJm1qJPWjEy+8cIW0WclqUhnuEjoO30SuXnaIVcMXYCATnrqs9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/d5oZN7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/d5oZN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFC51F00893;
	Sat, 30 May 2026 02:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780106829;
	bh=pPyJS3QIPzkvmjhvTqjOfTZhcj4mFErXU6nWdVkUxME=;
	h=From:To:Cc:Subject:Date;
	b=d/d5oZN7NczMhKa9LYopaDwiQjNZYVZZRC3Ic5cIHbUaiciGZLRhUogeEeHe5cLoX
	 +4USSQQAHmn7F4y8HcQRutTJHCUuD7EY9xhVWHh/FmIpfvlLNwTyXphR2T1qnsweF1
	 byGvvmKcNZGSHAnpKq7Gt3LXDABzSm5MkLm8jfYddfAm3FHaIBEDxsudta7GvzfndU
	 MmAwUqaWkvb/gpeo6E3sRvkq3J3BkH8Oi2836+/UFu++D+65HKBP3xisKWgPcrQiZx
	 WQgNdrjDxh+ZvP886nTqFez1u2DTcmbY4MLIRq2oUjMeCKpfM7N0hZLkoqmoHg3jsx
	 XhS6HZkCo5XXw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Om Prakash Singh <quic_omprsing@quicinc.com>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	linux-arm-msm@vger.kernel.org,
	Olivia Mackall <olivia@selenic.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/4] qcom-rng fixes and cleanups
Date: Fri, 29 May 2026 19:03:28 -0700
Message-ID: <20260530020332.143058-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes several bugs in qcom-rng, including failure to enable
the clock before accessing the hardware, generating biased random
numbers, and generating duplicate or non-random numbers due to missing
locking.  To fix the latter bug, it drops the support for the
duplicative crypto_rng interface, which isn't used in practice, leaving
just hwrng which is the one that actually matters.

This series is targeting cryptodev/master

Eric Biggers (4):
  crypto: qcom-rng - Enable clock in hwrng case
  crypto: qcom-rng - Allow zero as a random number
  crypto: qcom-rng - Remove crypto_rng interface
  hwrng: qcom - Move qcom-rng.c into drivers/char/hw_random/

 arch/arm/configs/multi_v7_defconfig |   2 +-
 arch/arm/configs/qcom_defconfig     |   2 +-
 arch/arm64/configs/defconfig        |   2 +-
 drivers/char/hw_random/Kconfig      |  11 ++
 drivers/char/hw_random/Makefile     |   1 +
 drivers/char/hw_random/qcom-rng.c   | 132 +++++++++++++
 drivers/crypto/Kconfig              |  12 --
 drivers/crypto/Makefile             |   1 -
 drivers/crypto/qcom-rng.c           | 276 ----------------------------
 drivers/gpu/drm/ci/arm64.config     |   2 +-
 10 files changed, 148 insertions(+), 293 deletions(-)
 create mode 100644 drivers/char/hw_random/qcom-rng.c
 delete mode 100644 drivers/crypto/qcom-rng.c


base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
-- 
2.54.0

