Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B64F101EE;
	Sat, 21 Jun 2025 01:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750470663; cv=none; b=WJ8XP1kG/39iFZmzFlLpAscU0c+iOiX/7hwQHgPa3vHZSoIfDKTYOI0vL8dKEijsHJwTLa8bgCr0WVJC9dGMAKJK5CucEgjrgozR37jB88Rf+liOeCJ1pMp6XxImYKGNdKi8gWia3JNzOxtGLeiC2/HaMMJ2U6WQRa0dRNAX6+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750470663; c=relaxed/simple;
	bh=CqB9U1kAeWjj00zaEbXn60zKQ0vRDB/j9sJHI+2TPao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eP8x9YoJPiH3gAUVbj7uny+YGkWzMTbCvWhp3CxoEfDweTfTP9mXVCYPJjydISPM07HFkdXigwMnoC/CkLXW4waH7+nEjjAZG51g+77LnGv7/jFkH74b7TXYmyabLDcu2aIioH0G/cYPPWR8Xg7uvgF74YEmHt2G4Ah5PtNJb3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cy9H482d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cy9H482d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA20C4CEE3;
	Sat, 21 Jun 2025 01:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750470663;
	bh=CqB9U1kAeWjj00zaEbXn60zKQ0vRDB/j9sJHI+2TPao=;
	h=From:To:Cc:Subject:Date:From;
	b=cy9H482d/LPVT6Z10rQA/pRBwBRNaVCJQrxku13iKsfV4l9UP/OgB0+O12q0qCOih
	 oMaohiiNE7RnEWJgUTCJOfKvZY88AnB36C2fl8DtpbdqQPyBL30qaTqU+Rr8K6auFn
	 fB4sbRIlvl22Q5FQKy4FV5BFxd/C83np/uMwxzmP+S3IchQ7MzDvD027nDUT8AsXo0
	 WycQxS+3vAYwoND/9LsVNqD9pRL1f9GTIHmDjFPFpoxUAx3d8h5jZ7GR+rDxQTPC/i
	 kqLCZYkgOOXohMoZOqiy5SS9gyxPmQoGg0AuSX6jMZVwxYODgGvNQlmZDzGsHwEa/h
	 czGmPclNEvSBg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld " <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: testmgr/sha512 - Omit generic_driver for no-op tests
Date: Fri, 20 Jun 2025 18:49:23 -0700
Message-ID: <20250621014923.25064-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some of the entries in alg_test_descs[] exist purely for the benefit of
marking the algorithm as "FIPS allowed", and they use a no-op test
function.  These entries don't need generic_driver filled in.

Fixes: 50058ca36580 ("crypto: sha512 - Replace sha512_generic with wrapper around SHA-512 library")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

I'm planned to fold this into the fixed commit, as this patch just
removes lines that commit added.

 crypto/testmgr.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 9b4235adcb036..825a3a617f2a7 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4318,11 +4318,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.aead = __VECS(hmac_sha384_des3_ede_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha384),ctr(aes))",
-		.generic_driver = "authenc(hmac-sha384-lib,ctr(aes-generic))",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha384),cts(cbc(aes)))",
 		.generic_driver = "authenc(hmac-sha384-lib,cts(cbc(aes-generic)))",
@@ -4330,11 +4329,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.aead = __VECS(krb5_test_aes256_cts_hmac_sha384_192)
 		}
 	}, {
 		.alg = "authenc(hmac(sha384),rfc3686(ctr(aes)))",
-		.generic_driver = "authenc(hmac-sha384-lib,rfc3686(ctr(aes-generic)))",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(aes))",
 		.generic_driver = "authenc(hmac-sha512-lib,cbc(aes-generic))",
@@ -4357,16 +4355,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.aead = __VECS(hmac_sha512_des3_ede_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha512),ctr(aes))",
-		.generic_driver = "authenc(hmac-sha512-lib,ctr(aes-generic))",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha512),rfc3686(ctr(aes)))",
-		.generic_driver = "authenc(hmac-sha512-lib,rfc3686(ctr(aes-generic)))",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
 		.alg = "blake2b-160",
 		.test = alg_test_hash,
@@ -5350,16 +5346,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "pkcs1(rsa,sha3-512)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
 		.alg = "pkcs1(rsa,sha384)",
-		.generic_driver = "pkcs1(rsa,sha384-lib)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
 		.alg = "pkcs1(rsa,sha512)",
-		.generic_driver = "pkcs1(rsa,sha512-lib)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
 		.alg = "pkcs1pad(rsa)",
 		.test = alg_test_null,

base-commit: c075093bd9493fb2032a2e1cbb3df4c03f92fa1f
-- 
2.50.0

