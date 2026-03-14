Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4BF32E137;
	Sat, 14 Mar 2026 04:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773460852; cv=none; b=FLkwhPvrYkXaDx/GY6Lr4NVm9b6o2v+knsZkUaBCDNY/DlPFGV8laNENxcu1VEds8EEqQo8Gji6jo8KIOsHVjv3vfGnsYJsJ/i9INY4vefJlwtzo5iS5ZS4t4N63CZvdyFHTmr+roZLbrffUbzlGpZocESmmhFKjDZcmt1I94Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773460852; c=relaxed/simple;
	bh=OzwIUsmn7tIpMA2qVnLTpeuoM9drGQlSPkWx/dqKUWg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VSIS53PSb3LOHxdBJxHI15rOtS+doTO/3SrHZPtAOBI1a9rAvarCoN/MPPKumv0JzHjJ8Nu5HIE2z+qS6zvCRLjn8RlrFNqqcbW+wHAAOt+KX4qcKzAvpYBzlegs59p/waIA2U2bvSXv07IqmI4rigd3AiclP7Ywmn6ir+PAzsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3GROioR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3GROioR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE0BC116C6;
	Sat, 14 Mar 2026 04:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773460852;
	bh=OzwIUsmn7tIpMA2qVnLTpeuoM9drGQlSPkWx/dqKUWg=;
	h=From:To:Cc:Subject:Date:From;
	b=O3GROioR1iy+10GCL7MYJf0CROtpYbOynpv9/et78MvCDHyPrT+vMMwUo+yX35MCY
	 /9k6mNsI99zDBtykxb0aB/g2rT3Nswr1yjxTW67VrRjaX8NdMhL1PmsDj6XWNp9JoO
	 OegQaznlPlxd/XtagFhiJfH1iLf+P7+NSlUA7PvVnDe8S0gSHFpPd8GM8MekXEFQIY
	 HpE+jc+PRUMa87fBc5eLA+u4TABvVuohTvn5jAH5MAuN1OsTM4A3T5wVVJH/lPKuxe
	 i3It5By1oNnCZcl3sZL4y2uf8OSDytok3VBdglA3IKQV0XUdJZhxp5YSOOPIRFxjrS
	 VbwiWpHK9RhTA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	Brendan Higgins Brendan Higgins <brendan.higgins@linux.devbrendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.comRaeMoarraemoar63@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] Make 'kunit.py run --alltests' run all crypto library tests
Date: Fri, 13 Mar 2026 20:59:25 -0700
Message-ID: <20260314035927.51351-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series makes the KUnit all_tests.config enable all the crypto
library options that have KUnit tests, so that all these tests will be
run in testing systems use 'kunit.py run --alltests'.  (For example,
KernelCI is planned to start doing that [1].)  To do this easily in both
that file and in lib/crypto/.kunitconfig, introduce a kconfig option
CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT for this purpose.

This series is targeting libcrypto-next.

[1] https://lore.kernel.org/kernelci/4fd302e0-ffa7-4bbf-a94a-c8879fde32f4@sirena.org.uk

Eric Biggers (2):
  lib/crypto: tests: Introduce CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
  kunit: configs: Enable all crypto library tests in all_tests.config

 lib/crypto/.kunitconfig                      | 22 +-----------------
 lib/crypto/tests/Kconfig                     | 24 ++++++++++++++++++++
 tools/testing/kunit/configs/all_tests.config |  2 ++
 3 files changed, 27 insertions(+), 21 deletions(-)


base-commit: ce260754bb435aea18e6a1a1ce3759249013f5a4
-- 
2.53.0

