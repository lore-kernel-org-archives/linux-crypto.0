Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E559914A4E2
	for <linux-crypto@vger.kernel.org>; Sat, 10 Aug 2024 06:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270867; cv=none; b=sak4dA5XePwd2OT9aZyfuixsysydy3bObVGoDp2CSaGrvcVy3mBpM6dBfh8exwP1w3IE6ucmMPA0JjwHY5koXO2YzRQi9Xh6mIJLFJmXGHLKf1HmmG8QEi5kCFze/11lgf216j9rzff3kPFTky6dEiR/MGDZyUbpz71MlL84tb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270867; c=relaxed/simple;
	bh=/65+FTKuZlsUWPZTt/0hxNzYN8tOIuDGX1ok1Ea6nH8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=BJLJtwP0Hs+3QP4p6s/geScn3V9cK/8iGhEEgsSR6d9Of66W1oEkGnxG3/DzWuy/UxkXEWM1ukB7hdnSr5XFk4hZbD41IN55awikV8Qbej1RgNBFsnDPPIJ/zPuCclhQRjvI+FJrrF5E66gL84WtDMhbWDjIqD7TAa+qKkIFbbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scfKr-003ipk-0a;
	Sat, 10 Aug 2024 14:21:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 Aug 2024 14:21:02 +0800
Date: Sat, 10 Aug 2024 14:21:02 +0800
Message-Id: <aa38ba68a9e91e8e426c4c07d0ebd6a44a59bcea.1723270405.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1723270405.git.herbert@gondor.apana.org.au>
References: <cover.1723270405.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 4/4] crypto: rsa - Check MPI allocation errors
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Fixes: 6637e11e4ad2 ("crypto: rsa - allow only odd e and restrict value in FIPS mode")
Fixes: f145d411a67e ("crypto: rsa - implement Chinese Remainder Theorem for faster private key operation")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/rsa.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index d9be9e86097e..78b28d14ced3 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -98,14 +98,13 @@ static int _rsa_dec_crt(const struct rsa_mpi_key *key, MPI m_or_m1_or_h, MPI c)
 		goto err_free_mpi;
 
 	/* (2iii) h = (m_1 - m_2) * qInv mod p */
-	mpi_sub(m12_or_qh, m_or_m1_or_h, m2);
-	mpi_mulm(m_or_m1_or_h, m12_or_qh, key->qinv, key->p);
+	ret = mpi_sub(m12_or_qh, m_or_m1_or_h, m2) ?:
+	      mpi_mulm(m_or_m1_or_h, m12_or_qh, key->qinv, key->p);
 
 	/* (2iv) m = m_2 + q * h */
-	mpi_mul(m12_or_qh, key->q, m_or_m1_or_h);
-	mpi_addm(m_or_m1_or_h, m2, m12_or_qh, key->n);
-
-	ret = 0;
+	ret = ret ?:
+	      mpi_mul(m12_or_qh, key->q, m_or_m1_or_h) ?:
+	      mpi_addm(m_or_m1_or_h, m2, m12_or_qh, key->n);
 
 err_free_mpi:
 	mpi_free(m12_or_qh);
@@ -236,6 +235,7 @@ static int rsa_check_key_length(unsigned int len)
 static int rsa_check_exponent_fips(MPI e)
 {
 	MPI e_max = NULL;
+	int err;
 
 	/* check if odd */
 	if (!mpi_test_bit(e, 0)) {
@@ -250,7 +250,12 @@ static int rsa_check_exponent_fips(MPI e)
 	e_max = mpi_alloc(0);
 	if (!e_max)
 		return -ENOMEM;
-	mpi_set_bit(e_max, 256);
+
+	err = mpi_set_bit(e_max, 256);
+	if (err) {
+		mpi_free(e_max);
+		return err;
+	}
 
 	if (mpi_cmp(e, e_max) >= 0) {
 		mpi_free(e_max);
-- 
2.39.2

