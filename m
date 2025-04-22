Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9045328FFE8;
	Tue, 22 Apr 2025 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745335336; cv=none; b=gvXafXXLnryTNFiRSknOlp0NAA3xPzCKkjuacQXkLRj/wy+GsfVMtvCArMwlZYUOQ7JuZSZsn2FebRi0dAUZm6Q56sI5OI+y0mRzdAqPeOH50NojjyGngcmyVoWVIsVuhi9/aEYDPi0gN1XsgE8BISpor680ICYGlgwHHEa63M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745335336; c=relaxed/simple;
	bh=trDDcXrh7y3OzpqD2wifq5sdMAi38DCdBzrHd/YZRPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXF+ziMxuoa6d/dJU/NWSEBv+9IPGYhfwTaOZbgfJE/CccWTHdDnvAXO1elFuNxNWeIYR81sL10SsPuribLlxVHOttyKz2kW5/a9aN7DAdWc0OVXD5Q5T+Go2FBi7YPJ3z8BriLfRmbJ4Y1Nl14JcThJP2cCpzOBbtjCHWAmaEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VT8osEfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VT8osEfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AECC4CEEE;
	Tue, 22 Apr 2025 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745335336;
	bh=trDDcXrh7y3OzpqD2wifq5sdMAi38DCdBzrHd/YZRPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VT8osEfY+lfmLE3yGoxA0DKD3sk7siiwh6nCduxQharQiZGL3tN65Rmx8dJ8WTbT5
	 W/0SDtVkzl2vzMhAey/9JP6gvC4tEGicqRBJUFne5ONm6qW9vTBl4gjRS+tH03CUMc
	 UZQ35o76JS8xBxZ4DRugMXC870ilWq4vMUHlorO7tl3jIDsCD8h2L51Eale/ti3BZ1
	 XD+sRaxpeoXVSlZtuY/+2FBGU/CIshJyfpZxNpPMBI5XooHSYDMUTqcPUwj/l1zlWV
	 xAhzFc/z5c8TeRVL3GV7Rd1CMNQpWMaxC2J8jVcoOeXMQemzi0SK95fN6ExNwaIxdt
	 SPUAEsU2mGAig==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/9] crypto: testmgr - remove panic_on_fail
Date: Tue, 22 Apr 2025 08:21:46 -0700
Message-ID: <20250422152151.3691-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422152151.3691-1-ebiggers@kernel.org>
References: <20250422152151.3691-1-ebiggers@kernel.org>
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
index 82977ea25db39..d075c48ff1a21 100644
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
 
@@ -5858,15 +5855,14 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
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

