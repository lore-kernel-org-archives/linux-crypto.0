Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 79D8B13C3F6;
	Mon, 21 Apr 2025 08:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745224306; cv=none; b=VC8bFzxHOX5vvFhN6Z9VyF0/IKGuZ3G/+kmzDqTF8ymERGUUm83x6EK0EbR22euxrqIH10skgxVEAhnl4kvSr9WRNtX0mzDQikbFmwiQ34/kRIOPywOn5T/TGRPbRV/wMHnGCVj0yhyrIROAbCEX1zQ1+smkLUKZGYfuAf732G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745224306; c=relaxed/simple;
	bh=SuprFvyqOOqRDNuoKe72pzRM0BLb5KK2WvwZPlimvrY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version; b=AMAsc8njDyU3dkYdC5ek67SlvLGw9zMGxLtGs2KarRPVCSSAW4PA1Xs2ntnrOKDNK4vq7Hmqb0q+slok+e+54IRT+Glp/CFzfoR9G2QeD303vvcVHA4es39E8D1SzaL4ZWMrTr1pF9gVgxfb0yDve3Eji+wWIyeQFZCBCyaxeoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from longsh.shanghai.nfschina.local (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id 371EA60260752;
	Mon, 21 Apr 2025 16:31:38 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	christophe.jaillet@wanadoo.fr
Cc: Su Hui <suhui@nfschina.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2 1/2] crypto: using size_add() for kmalloc()
Date: Mon, 21 Apr 2025 16:31:16 +0800
Message-Id: <20250421083116.1161805-2-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250421083116.1161805-1-suhui@nfschina.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's safer to use size_add() to replace open-coded aithmetic in allocator
arguments, because size_add() can prevent possible overflow problem.

Signed-off-by: Su Hui <suhui@nfschina.com>
---
 include/crypto/aead.h     | 2 +-
 include/crypto/akcipher.h | 3 ++-
 include/crypto/kpp.h      | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 0e8a41638678..8df3d112bf6a 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -433,7 +433,7 @@ static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
 {
 	struct aead_request *req;
 
-	req = kmalloc(sizeof(*req) + crypto_aead_reqsize(tfm), gfp);
+	req = kmalloc(size_add(sizeof(*req), crypto_aead_reqsize(tfm)), gfp);
 
 	if (likely(req))
 		aead_request_set_tfm(req, tfm);
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index cdf7da74bf2f..6927664bc3d7 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -184,7 +184,8 @@ static inline struct akcipher_request *akcipher_request_alloc(
 {
 	struct akcipher_request *req;
 
-	req = kmalloc(sizeof(*req) + crypto_akcipher_reqsize(tfm), gfp);
+	req = kmalloc(size_add(sizeof(*req),
+			       crypto_akcipher_reqsize(tfm)), gfp);
 	if (likely(req))
 		akcipher_request_set_tfm(req, tfm);
 
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 2d9c4de57b69..ad120bbc8b7c 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -182,7 +182,7 @@ static inline struct kpp_request *kpp_request_alloc(struct crypto_kpp *tfm,
 {
 	struct kpp_request *req;
 
-	req = kmalloc(sizeof(*req) + crypto_kpp_reqsize(tfm), gfp);
+	req = kmalloc(size_add(sizeof(*req), crypto_kpp_reqsize(tfm)), gfp);
 	if (likely(req))
 		kpp_request_set_tfm(req, tfm);
 
-- 
2.30.2

