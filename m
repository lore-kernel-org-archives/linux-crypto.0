Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E8C26F444;
	Mon,  5 May 2025 20:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746477436; cv=none; b=RGzgI4OHFNK/qQM2bvyqcPr4gmYebeR+QACsD8DxxDwcjm1CV4ip1wjhkKk9y9D3sEwQAigBD/2ljO5rkI0B7OZkkhyo6u7rM9YNJGgX41kfDCSfMeaREGkQ6E0vXff6X6E6oKFKJLe9Zld3dU/thVhsq7WVFm6CO9UZE4bQSsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746477436; c=relaxed/simple;
	bh=zLJNQbTBpTtCkwbzaJ94Y+qs9Gluucy9HpN7NqXx5bM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEw+N/SU5ZUzK3tkCwsa8gXf0jhvip2t5pw2VSBiG7l+MD5xgKPHayv09w6BQOUdrn6wkv6uVsUij1GQR3o8k6LEG5MpBzdKVNdykhHxNijPs3G3V7O+bNWKNEqgavsH1le3GYlWjtj1swclNwK2Hv7Nw0l3i934aocuVYCqsA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jc7XqS8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jc7XqS8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9917C4CEED;
	Mon,  5 May 2025 20:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746477435;
	bh=zLJNQbTBpTtCkwbzaJ94Y+qs9Gluucy9HpN7NqXx5bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jc7XqS8dS/NpJkiQO2+I+i3mG1b3NSqmWPHpIBjOPrlxUcj5fjqb3bTmsykH9huLS
	 +zwG7qI8xqnbylr1qv/qOZuCJOcFAFrZawhEb77FIhWHYsSMuJWp312NrLV9c2471m
	 8tcwY/85MEyAAvIcAAEiweMubtdWGxUjAhn882zXJoSsJ4qhLfEIbpMxFp81vbLuYv
	 G3E9u9QIavNJfXMo8R4WSpM4AIszNIZNh5pMZ98SrAU/RUq5sIZg/HZ2/IbBG0P8g1
	 /zb7Hii3XJ9sCiJihd+gSy2EqwQBMyEGqNkYYXpEcZG4jnXVVW7jwossHl3UVVAiJZ
	 UYzkN1SJGC/Wg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/7] crypto: testmgr - remove panic_on_fail
Date: Mon,  5 May 2025 13:33:40 -0700
Message-ID: <20250505203345.802740-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505203345.802740-1-ebiggers@kernel.org>
References: <20250505203345.802740-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The cryptomgr.panic_on_fail=1 kernel command-line parameter is not very
useful now that the tests have been fixed to WARN on failure, since
developers can just use panic_on_warn=1 instead.  There's no need for a
special option just for the crypto self-tests.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f100be516f52..1c71616ae2cf 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -43,13 +43,10 @@ MODULE_IMPORT_NS("CRYPTO_INTERNAL");
 
 static bool notests;
 module_param(notests, bool, 0644);
 MODULE_PARM_DESC(notests, "disable crypto self-tests");
 
-static bool panic_on_fail;
-module_param(panic_on_fail, bool, 0444);
-
 #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
 static bool noextratests;
 module_param(noextratests, bool, 0644);
 MODULE_PARM_DESC(noextratests, "disable expensive crypto self-tests");
 
@@ -5852,15 +5849,14 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 		rc |= alg_test_descs[j].test(alg_test_descs + j, driver,
 					     type, mask);
 
 test_done:
 	if (rc) {
-		if (fips_enabled || panic_on_fail) {
+		if (fips_enabled) {
 			fips_fail_notify();
-			panic("alg: self-tests for %s (%s) failed in %s mode!\n",
-			      driver, alg,
-			      fips_enabled ? "fips" : "panic_on_fail");
+			panic("alg: self-tests for %s (%s) failed in fips mode!\n",
+			      driver, alg);
 		}
 		pr_warn("alg: self-tests for %s using %s failed (rc=%d)",
 			alg, driver, rc);
 		WARN(rc != -ENOENT,
 		     "alg: self-tests for %s using %s failed (rc=%d)",
-- 
2.49.0

