Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5769F3838D
	for <linux-crypto@vger.kernel.org>; Sun, 21 Jan 2024 19:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705866553; cv=none; b=rnmYYV4+EBNcB+D+Ac/dklZJHziNAVGgtb2hbpPd+8xtqvAJsWFyRJXeKd3S9sou8FrzKhrPU5MAPFhaJ7eD3f8zlayazaMQIVzvs10ooS8xXHhb9eknNMsoo8M5OCW3PX3tdq5MxY9GpWVUL/yodBeWlVtrK6hNj7sBDf3D4U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705866553; c=relaxed/simple;
	bh=Io8CZinL8nPZ8HMB8amdcvs5wzCPD4xojiPD9RtJ8Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qqA1ilNeStl+k2O+Nb2nxLN+6sY09WT3aWu7fClnY3gmeIOir5swjIqtL6pW9bpE50k9k9JndETbknbv+jrkphs4kWEdMupqtF8p2Zf42k+AA4OHelJTXKR1PZ66XtvjzWyZdD0g2fDM8xw2PYM+M1qt1d9/1RYQxZDnEbPX5+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=vXvqKi5x; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="vXvqKi5x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1705866551; bh=Io8CZinL8nPZ8HMB8amdcvs5wzCPD4xojiPD9RtJ8Ac=;
	h=From:To:Cc:Subject:Date;
	b=vXvqKi5xA75THLzKTY73FRgEos5YiEJ8NtqkXA6FsfZPIUv9Fk10mw+Fp0VdWKTvy
	 W0/8Xtks9Jb2qdNu8Eytth14zbPRNc6bF/PV+FKEjB52zBDmHIGEeemioSBOCvrJRn
	 AUwBFkzF8rICSZBBduYeY3OjFTWkEnXZYeF1ydddfL1qnI9pBWOTPf6LAbPlVRwdDy
	 m3m+ELjGrOCVJnxMf4VNfrPO9npIiRba8K+7A3+9Vmjoqjex8Gz474oCa238ZPy65G
	 RlvAxuyhyfBZ4e+aZSec5+z7+Zq2QsFJmWufprBSAgH+24xeUSjFfKCN/jhES6e3+i
	 vCejpwwfgcgJg==
From: Joachim Vandersmissen <git@jvdsn.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH] crypto: rsa - restrict plaintext/ciphertext values more in FIPS mode
Date: Sun, 21 Jan 2024 13:49:00 -0600
Message-ID: <20240121194901.344206-1-git@jvdsn.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SP 800-56Br2, Section 7.1.1 [1] specifies that:
1. If m does not satisfy 1 < m < (n – 1), output an indication that m is
out of range, and exit without further processing.

Similarly, Section 7.1.2 of the same standard specifies that:
1. If the ciphertext c does not satisfy 1 < c < (n – 1), output an
indication that the ciphertext is out of range, and exit without further
processing.

[1] https://doi.org/10.6028/NIST.SP.800-56Br2

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
---
 crypto/rsa.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index b9cd11fb7d36..b5c67e6f8774 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -24,12 +24,36 @@ struct rsa_mpi_key {
 	MPI qinv;
 };
 
+static int rsa_check_payload_fips(MPI x, MPI n)
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
+	/* For FIPS, SP 800-56Br2, Section 7.1.1 requires 1 < m < n - 1 */
+	if (fips_enabled && rsa_check_payload_fips(m, key->n))
+		return -EINVAL;
+
 	/* (1) Validate 0 <= m < n */
 	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
 		return -EINVAL;
@@ -50,6 +74,11 @@ static int _rsa_dec_crt(const struct rsa_mpi_key *key, MPI m_or_m1_or_h, MPI c)
 	MPI m2, m12_or_qh;
 	int ret = -ENOMEM;
 
+	/* For FIPS, SP 800-56Br2, Section 7.1.2 requires 1 < c < n - 1 */
+	if (fips_enabled && rsa_check_payload_fips(c, key->n))
+		return -EINVAL;
+
+
 	/* (1) Validate 0 <= c < n */
 	if (mpi_cmp_ui(c, 0) < 0 || mpi_cmp(c, key->n) >= 0)
 		return -EINVAL;
-- 
2.43.0

