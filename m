Received: from smtpcmd0642.aruba.it (smtpcmd0642.aruba.it [62.149.156.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEF32D5C7A
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 08:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757925834; cv=none; b=GqqKumNNLU3iFx3jHtnxBWIpS5NlfilSTaHQ9Gi70FZnEkM6vsQk+clsVnYm8VbU9cgLKHtrDxV+ICs6Dmd7nfb4z2ClvXGQ8xAPrhbXWkgDgR20mVmqv6x49eD7XqZdZ3kgfzbS7j1PUrQ2+CI18nG2S4ahPZFBRUftO9NLz3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757925834; c=relaxed/simple;
	bh=/cbqv5fB+zT6uZXISeaVKCoUndMssg4px/djArenn7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OBbHU0zUFUgr/KJ24irwtvmKe0CVJgG/8iB53A46g8DLegGCmzIEvveJyPsgSOw4F4FfHvIabqC8sj11BvIm44XEFRL9GpQAM6+2M+lDR7SluxDe3q1p4UCWL4iTtJnh7LkBp0afpX5kTe9wlhe/W7KzxeQmZaA911lUrkulfyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com; spf=pass smtp.mailfrom=enneenne.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=hipJnvdZ; arc=none smtp.client-ip=62.149.156.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="hipJnvdZ"
Received: from polimar.homenet.telecomitalia.it ([79.0.204.227])
	by Aruba SMTP with ESMTPSA
	id y4lLumNEnL0Iyy4lNuiWib; Mon, 15 Sep 2025 10:40:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1757925641; bh=/cbqv5fB+zT6uZXISeaVKCoUndMssg4px/djArenn7k=;
	h=From:To:Subject:Date:MIME-Version;
	b=hipJnvdZIwAkCaLZniadayUZwXSP8mRWLKwbljBZKSWct8lPe/IDzvpQut0zs9bo1
	 Nc9Zp1RPu0XTuq+CgCxo9+W1Kei//+ckr9wB48dd1NG2QjvFc78qYIAmkTrjUYKDyV
	 bbGKu2vV1teYLEaihbaojIHSs9Rvx0CNXOzT5SDe5ue6EEdKPwoXw6qgcU9Gnt7DEp
	 luH89SBNi7voyIvPerARhOS1424kpIREgAEMbtIPdhUvuC2EoWJJW1PBVVdY9I5VFh
	 8SIHn/71RCDUOX/O3r1Ajm8knlbT5G7QL5lOFWlTHgdyR8JLIHhwrP2JglQnkSKxrl
	 +4QVfQw1yNMRQ==
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: [V1 3/4] crypto ecdh.c: define the ECDH set_secret_raw method
Date: Mon, 15 Sep 2025 10:40:38 +0200
Message-Id: <20250915084039.2848952-4-giometti@enneenne.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250915084039.2848952-1-giometti@enneenne.com>
References: <20250915084039.2848952-1-giometti@enneenne.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfOrdSnTy6aGUheSaeHuq2fLET0sbwdBPstiNi97WtbflMzFWGRuBdT77JZcQEoGauyrUj7eUDHNZZXAk1ahNMXcuhGL137S2IFace7Y7G0spwR5SK4xv
 5JUPc2TXHJ1gbDomOn1O2W7C8aUmMWM9n5WI9Nn4hTafF7goC+sKX/ou4viH6o2MI36FnLyBE00d7aJqZ0xmqSMgw3KmLmBYgxmBK+FIGfuXUmFhMlNJopn4
 IxXP5eZGOkZmYlkE4E4QwYnvuWlo/HDZ6WyDoTvyUTOjRIRoW6kahDW4jz5J0od0GNKKT+vRQlth4OLcFnToBWhhmnwnlivQrvxgMIYyHMU=

Adds new function ecdh_set_secret_raw() and sets it as set_secret_raw
method for ecdh_nist_(p192|p256|p384) algorithms.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 crypto/ecdh.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 9f0b93b3166d..548099f26c65 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -52,6 +52,34 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	return ret;
 }
 
+static int ecdh_set_secret_raw(struct crypto_kpp *tfm, const u8 *key,
+			       unsigned int len)
+{
+	struct ecdh params = {
+		.key = key,
+		.key_size = len,
+	};
+	u8 *buf;
+	unsigned int buf_len;
+	int err;
+
+	buf_len = crypto_ecdh_key_len(&params);
+	buf = kmalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	err = crypto_ecdh_encode_key(buf, buf_len, &params);
+	if (err)
+		goto free_buf;
+
+	err = ecdh_set_secret(tfm, buf, buf_len);
+	fallthrough;
+free_buf:
+	kfree_sensitive(buf);
+
+	return err;
+}
+
 static int ecdh_compute_value(struct kpp_request *req)
 {
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
@@ -139,6 +167,7 @@ static int ecdh_nist_p192_init_tfm(struct crypto_kpp *tfm)
 }
 
 static struct kpp_alg ecdh_nist_p192 = {
+	.set_secret_raw = ecdh_set_secret_raw,
 	.set_secret = ecdh_set_secret,
 	.generate_public_key = ecdh_compute_value,
 	.compute_shared_secret = ecdh_compute_value,
@@ -164,6 +193,7 @@ static int ecdh_nist_p256_init_tfm(struct crypto_kpp *tfm)
 }
 
 static struct kpp_alg ecdh_nist_p256 = {
+	.set_secret_raw = ecdh_set_secret_raw,
 	.set_secret = ecdh_set_secret,
 	.generate_public_key = ecdh_compute_value,
 	.compute_shared_secret = ecdh_compute_value,
@@ -189,6 +219,7 @@ static int ecdh_nist_p384_init_tfm(struct crypto_kpp *tfm)
 }
 
 static struct kpp_alg ecdh_nist_p384 = {
+	.set_secret_raw = ecdh_set_secret_raw,
 	.set_secret = ecdh_set_secret,
 	.generate_public_key = ecdh_compute_value,
 	.compute_shared_secret = ecdh_compute_value,
-- 
2.34.1

