Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DB34EB25
	for <linux-crypto@vger.kernel.org>; Sat,  3 Feb 2024 07:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706945379; cv=none; b=UzoiOeT8QGbkHNUHynmZU9SGhsx/q0MQJB75ics6C+D+He8VwyoKcW+tmLKpM0gbbuauFNaVtJtYcNRMeklpPcNsPn8FloLCaNqfWhtg8vH6vwGe0e1CXkX58NEuzTmlysMXmr7Fy9w5ag2aIpm8bUCNquuBNuPn+L9S/+52JNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706945379; c=relaxed/simple;
	bh=PTOpCCEM3IxbhvuSFFypmEAY+7vzYF1umsDvuUrgiXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rF5Hc+WcyM/U7B2AMwqZ1MHP+isc3nBRDE2lLmuSjh5HEbdzv3F+6tLIjrWIDVDKJmzqJ3fhwFDO0wyDw3eHVxh52qI2+KQp8v3GSGoO5t4EaaF13+MVDctPozkz03qDeUrhCuOL+uTui7Ccgk1wD0qPM6M0bxOp31vWgz7+2g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=O9Ki0kuH; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="O9Ki0kuH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1706944814; bh=PTOpCCEM3IxbhvuSFFypmEAY+7vzYF1umsDvuUrgiXI=;
	h=From:To:Cc:Subject:Date;
	b=O9Ki0kuHyXgz6hB8GZG2xrVRL5oWLrqyVfO171cWUMsxxrB6I/OV4T1My0XFwZ0P+
	 J5WZu8f8zTeL4rUWAHf7U1nNJNEmA4ROLjWlORjKhQjfN5gTrOyVJa9gU/II/bY4at
	 Juv14sn6g31bgNvikWLl9HlQNhtraNaUh+ltk2f3i05S6jEmwdMgW7VsF6SSd+ANLb
	 hLpnp4PYC19WzFyvjAsp9U7EO7Xou9MYbzcgUJL/yrrvVMUWQh2qCr3aHyQgnPZ5PF
	 JnLRQJ6Whzrr7J5VtDYB8dGF3s66NTNPVlianCNKYsN0O0Ual163IEFFA0G1vHhwc8
	 LukaM9EAPy5fQ==
From: Joachim Vandersmissen <git@jvdsn.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH v2] crypto: rsa - restrict plaintext/ciphertext values more
Date: Sat,  3 Feb 2024 01:19:59 -0600
Message-ID: <20240203071959.239363-1-git@jvdsn.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Herbert,

As requested, I replaced the existing check with the new SP 800-56Br2
check. I verified that the restriction is now applied in both FIPS and
non-FIPS mode. I tried to make it clear in the comments why the code is
now deviating from RFC3447.

---8<---

SP 800-56Br2, Section 7.1.1 [1] specifies that:
1. If m does not satisfy 1 < m < (n – 1), output an indication that m is
out of range, and exit without further processing.

Similarly, Section 7.1.2 of the same standard specifies that:
1. If the ciphertext c does not satisfy 1 < c < (n – 1), output an
indication that the ciphertext is out of range, and exit without further
processing.

This range is slightly more conservative than RFC3447, as it also
excludes RSA fixed points 0, 1, and n - 1.

[1] https://doi.org/10.6028/NIST.SP.800-56Br2

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
---
 crypto/rsa.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index b9cd11fb7d36..d9be9e86097e 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -24,14 +24,38 @@ struct rsa_mpi_key {
 	MPI qinv;
 };
 
+static int rsa_check_payload(MPI x, MPI n)
+{
+	MPI n1;
+
+	if (mpi_cmp_ui(x, 1) <= 0)
+		return -EINVAL;
+
+	n1 = mpi_alloc(0);
+	if (!n1)
+		return -ENOMEM;
+
+	if (mpi_sub_ui(n1, n, 1) || mpi_cmp(x, n1) >= 0) {
+		mpi_free(n1);
+		return -EINVAL;
+	}
+
+	mpi_free(n1);
+	return 0;
+}
+
 /*
  * RSAEP function [RFC3447 sec 5.1.1]
  * c = m^e mod n;
  */
 static int _rsa_enc(const struct rsa_mpi_key *key, MPI c, MPI m)
 {
-	/* (1) Validate 0 <= m < n */
-	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
+	/*
+	 * Even though (1) in RFC3447 only requires 0 <= m <= n - 1, we are
+	 * slightly more conservative and require 1 < m < n - 1. This is in line
+	 * with SP 800-56Br2, Section 7.1.1.
+	 */
+	if (rsa_check_payload(m, key->n))
 		return -EINVAL;
 
 	/* (2) c = m^e mod n */
@@ -50,8 +74,12 @@ static int _rsa_dec_crt(const struct rsa_mpi_key *key, MPI m_or_m1_or_h, MPI c)
 	MPI m2, m12_or_qh;
 	int ret = -ENOMEM;
 
-	/* (1) Validate 0 <= c < n */
-	if (mpi_cmp_ui(c, 0) < 0 || mpi_cmp(c, key->n) >= 0)
+	/*
+	 * Even though (1) in RFC3447 only requires 0 <= c <= n - 1, we are
+	 * slightly more conservative and require 1 < c < n - 1. This is in line
+	 * with SP 800-56Br2, Section 7.1.2.
+	 */
+	if (rsa_check_payload(c, key->n))
 		return -EINVAL;
 
 	m2 = mpi_alloc(0);
-- 
2.43.0

