Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F794350A22;
	Mon,  2 Mar 2026 23:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772495381; cv=none; b=uf82yIm0HukIoKtrbg/GpBtUMiDRlvMwATkOij9GPtEQMArxtg2aT+qQmId5nk6fUteqqHL6upMJuxDscMxCbAelaAM+EWbXIX6hGo0Scqbwg6MmGPajSfxLwC9+J8JeFExpNZNZ2chsUmvTrW7eQmFF3G+PZC7Jex5aeZbORMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772495381; c=relaxed/simple;
	bh=lVckU9fV0K96txaKWynH+hEQtPyhAQIPx0S58PLEBsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rL9V4qd9361hgGzrD2YlEM74SNU+OvPvhig4uSDU/49mar8oVcBqdBVp8V1T3BYjwxqECeo2P2mDSRzZbJfy7DCAi/fp+MWA5F80NYNmGlTz4zPMjvshigsmbUIPpdZo4nMXFNV7hlCvTmgNmA/hFfP2awsX7AxDjhImCoU3BGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezsHrkR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezsHrkR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BACC19423;
	Mon,  2 Mar 2026 23:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772495380;
	bh=lVckU9fV0K96txaKWynH+hEQtPyhAQIPx0S58PLEBsw=;
	h=From:To:Cc:Subject:Date:From;
	b=ezsHrkR7SJ5/AB/1JwP0CQxXesQpVctWyV03GlXdVn3VILq3dwQM0k77yJpo/p48V
	 OGxc3IOnzoNWLvMwS4EPMMe04uWPVmt0CwMe/eZVRvyfgr8fqhOUGhD7niJ2vli5TX
	 reSO0kn0Y4H07Wzh2RuUXxtBRGkV8fj4ctcLbsDpoO8n6im06iM26bpAHruhudwDcw
	 MopyUEJ05Bk2F/cyCfBEfmn2K5IbRWa1MIxPVHP/g7xlOq+LqFtSZYRxN8+r5tGnYl
	 AyMMqf7CFwTMo9HI7k4ZfaIP0eEgSWfYxNUrT1H4UvIz0+jUStMyVmKc9MJeZNf32q
	 CLbgP6ZLnsN2g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: testmgr - Fix stale references to aes-generic
Date: Mon,  2 Mar 2026 15:48:56 -0800
Message-ID: <20260302234856.30569-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Due to commit a2484474272e ("crypto: aes - Replace aes-generic with
wrapper around lib"), the "aes-generic" driver name has been replaced
with "aes-lib".  Update a couple testmgr entries that were added
concurrently with this change.

Fixes: a22d48cbe558 ("crypto: testmgr - Add test vectors for authenc(hmac(sha224),cbc(aes))")
Fixes: 030218dedee2 ("crypto: testmgr - Add test vectors for authenc(hmac(sha384),cbc(aes))")
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-fixes for v7.0

 crypto/testmgr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 49b607f65f636..4985411dedaec 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4130,11 +4130,11 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha224),cbc(aes))",
-		.generic_driver = "authenc(hmac-sha224-lib,cbc(aes-generic))",
+		.generic_driver = "authenc(hmac-sha224-lib,cbc(aes-lib))",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = __VECS(hmac_sha224_aes_cbc_tv_temp)
 		}
 	}, {
@@ -4192,11 +4192,11 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha384),cbc(aes))",
-		.generic_driver = "authenc(hmac-sha384-lib,cbc(aes-generic))",
+		.generic_driver = "authenc(hmac-sha384-lib,cbc(aes-lib))",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = __VECS(hmac_sha384_aes_cbc_tv_temp)
 		}
 	}, {

base-commit: f33ac74f9cc1cdadd3921246832b2084a5dec53a
-- 
2.53.0

