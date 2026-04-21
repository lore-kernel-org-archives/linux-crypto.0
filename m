Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEE43DE424;
	Tue, 21 Apr 2026 21:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776805598; cv=none; b=PNpasHa0WfVYOhsPYCV1zX5iFiir1qDJSpnQS9L9zzJwIoEeTErfWtMPoscyGuR7O7K9kjQN6wBlFD/DkZZC2cKYpkESkSCq63xJlPhOlY196Q9rsQMvCXn9au6HfU9k4bHHwJ+yVQXYKD/AvX4qNRU6bV9jJrZyrOxASP1ljfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776805598; c=relaxed/simple;
	bh=5s4kdV/iEU/zEiTGaUU5/TQPjOmkSlyDLflPMg3LKFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2qgIBMPOeqhoJXA9zDybEBcYHSQqkiFL6wzr+f6qFe62tWksnZzyyrllWMxo3S5fwNZ2w1YLNzohltzoqw6wxEg26DsAJyNtQhCc+JNzKmHkbtzvuMxaib8Tf4szMG0jItZ5P68A6ZOoJMWx3CFduH6olLORaacQCnvptucZuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dmky/hFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dmky/hFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F32C2BCB7;
	Tue, 21 Apr 2026 21:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776805597;
	bh=5s4kdV/iEU/zEiTGaUU5/TQPjOmkSlyDLflPMg3LKFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dmky/hFlBRserCEqDTlj9A/8n0WHMMtd3ELE/pN6vGkzm0Zu6WclJG/KYkrKsph9g
	 EMagepnW3lgsdV8h95UWfcCS+cXHDu/CA8t2duzwvUrc0togPP3En9wGLvASjyovkU
	 iaufWBCrkKfChNNp+0ekKF03YhZCYgyoc/CJ3LE1OoC/szl+3n86dWFrh5kbpVY9ms
	 j1zad7549CkMx9HxIL3nXsQCwosqrVPKwUvdLQdnnJBgevrstRcRU2V1smS6VlGPHn
	 csX/PUAK4wxNPp0A1j9ps5nkNTUKBpVZk2AW88gOVHozqKy3i6+0jrUpteP9gxgzPK
	 dbb4KGLANM1vg==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 7/8] kunit: configs: Enable all crypto library tests in all_tests.config
Date: Tue, 21 Apr 2026 14:05:53 -0700
Message-ID: <20260421210554.36096-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421210554.36096-1-ebiggers@kernel.org>
References: <20260421210554.36096-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 8d547482231fef30d0d6440629b73560ad3e937c upstream.

The new option CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT enables all the
crypto library code that has KUnit tests, causing CONFIG_KUNIT_ALL_TESTS
to enable all these tests.  Add this option to all_tests.config so that
kunit.py will run them when passed the --alltests option.

Link: https://lore.kernel.org/r/20260314035927.51351-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 tools/testing/kunit/configs/all_tests.config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/kunit/configs/all_tests.config b/tools/testing/kunit/configs/all_tests.config
index c1d3659a41cf0..bccc2c77196d5 100644
--- a/tools/testing/kunit/configs/all_tests.config
+++ b/tools/testing/kunit/configs/all_tests.config
@@ -42,10 +42,12 @@ CONFIG_DAMON_PADDR=y
 
 CONFIG_REGMAP_BUILD=y
 
 CONFIG_AUDIT=y
 
+CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT=y
+
 CONFIG_PRIME_NUMBERS=y
 
 CONFIG_CRC_ENABLE_ALL_FOR_KUNIT=y
 
 CONFIG_SECURITY=y
-- 
2.53.0

