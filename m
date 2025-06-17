Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABEB52EF9DA;
	Tue, 17 Jun 2025 19:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750188626; cv=none; b=k37D29sO/rSRtNaI0KEHpvI3ep6Jew566tjGh1TREAsSwAQXG9tT/ucKOf0Tch99KuciO4aKqITaB5fgK1MXMUoCPxALmZelYI636liUvhRiFDTAKTh9WSode9/UEGkokRMQ0efjoFxJTgJavc9SX8Vgvnzc/9P1G5T6MyBorow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750188626; c=relaxed/simple;
	bh=Q22B5BmjRWYDJ3wy+OdZ8UrQI/3O8aKyIep+1+rXazw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qhHIMlkYohvGS8upudHJ1kbTsL9Bl7L9iRZZwKIlxXWCAXqVa+BEtvIScxj2ZxT5F27HfuCgd+v1mUrrsq5pngOLQSp66Q6gA5TWOwaHDgcPCVZyBHUkVfhdcG6Dd2gjseHx0q57AG6yedjmP/1N1d+cQKYYRGISX3jvdkwbCP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=sCtpF/Kl; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="sCtpF/Kl"
Received: from jeffbarnes-ThinkPad-P14s-Gen-2i.corp.microsoft.com (unknown [52.167.115.14])
	by linux.microsoft.com (Postfix) with ESMTPSA id 28EFC2117FA0;
	Tue, 17 Jun 2025 12:30:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 28EFC2117FA0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1750188617;
	bh=ir/SqTy2ukWEw+C/xLgwNOdq2SInlhwjnmgWuEINj/o=;
	h=From:To:Cc:Subject:Date:From;
	b=sCtpF/Kl1X5bBd6TwkG+r70cURR8EDUFjxvtU2bpAN2QVJyFdN0Y7qAKHrdNP0vlK
	 e34WBgisU2nz6dyum/n91kqiVVnvH+5Lj2YISWrmKmzEVpn48aiPevukwHnDRtTyc6
	 FF6A+emSTVx2v6AGYJXsz/GGjMjvnb+o+RX8dYEU=
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jeffbarnes@linux.microsoft.com
Subject: [PATCH] crypto: Restore sha384 and hmac_sha384 drbgs in FIPS mode
Date: Tue, 17 Jun 2025 15:30:05 -0400
Message-Id: <20250617193005.1756307-1-jeffbarnes@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set .fips_allowed in the following drbg alg_test_desc structs.

drbg_nopr_hmac_sha384
drbg_nopr_sha384
drbg_pr_hmac_sha384
drbg_pr_sha384

The sha384 and hmac_sha384 DRBGs with and without prediction resistance
were disallowed in an early version of the FIPS 140-3 Implementation
Guidance document. Hence, the fips_allowed flag in struct alg_test_desc
pertaining to the affected DRBGs was unset. The IG has been withdrawn
and they are allowed again.

Furthermore, when the DRBGs are configured, /proc/crypto shows that
drbg_*pr_sha384 and drbg_*pr_hmac_sha384 are fips-approved ("fips: yes")
but because their self-tests are not run (a consequence of unsetting
the fips_allowed flag), the drbgs won't load successfully with the seeming
contradictory "fips: yes" in /proc/crypto.

This series contains a single patch that sets the fips_allowed flag in
the sha384-impacted DRBGs, which restores the ability to load them in
FIPS mode.

Link: https://lore.kernel.org/linux-crypto/979f4f6f-bb74-4b93-8cbf-6ed653604f0e@jvdsn.com/
Link: https://csrc.nist.gov/CSRC/media/Projects/cryptographic-module-validation-program/documents/fips%20140-3/FIPS%20140-3%20IG.pdf

To: Herbert Xu <herbert@gondor.apana.org.au>
To: David S. Miller <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Jeff Barnes <jeffbarnes@linux.microsoft.com>
---
 crypto/testmgr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2f5f6b52b2d4..815d1f31dbac 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4897,6 +4897,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		 */
 		.alg = "drbg_nopr_hmac_sha384",
 		.test = alg_test_null,
+		.fips_allowed = 1
 	}, {
 		.alg = "drbg_nopr_hmac_sha512",
 		.test = alg_test_drbg,
@@ -4915,6 +4916,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		/* covered by drbg_nopr_sha256 test */
 		.alg = "drbg_nopr_sha384",
 		.test = alg_test_null,
+		.fips_allowed = 1
 	}, {
 		.alg = "drbg_nopr_sha512",
 		.fips_allowed = 1,
@@ -4946,6 +4948,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		/* covered by drbg_pr_hmac_sha256 test */
 		.alg = "drbg_pr_hmac_sha384",
 		.test = alg_test_null,
+		.fips_allowed = 1
 	}, {
 		.alg = "drbg_pr_hmac_sha512",
 		.test = alg_test_null,
@@ -4961,6 +4964,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		/* covered by drbg_pr_sha256 test */
 		.alg = "drbg_pr_sha384",
 		.test = alg_test_null,
+		.fips_allowed = 1
 	}, {
 		.alg = "drbg_pr_sha512",
 		.fips_allowed = 1,
-- 
2.34.1

