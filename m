Received: from mta0.migadu.com (out-108.mta0.migadu.com [91.218.175.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD1941BA93
	for <linux-crypto@vger.kernel.org>; Sat, 15 Aug 2026 15:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786806619; cv=none; b=gyOZ4lp3Wvvi1p4WlMW7TzKH/nIZv9JVYhzFLK5ZnOBqzkCG+CiLzeOnardq5LyzS1IXjFQnEvmBrDjWBCLfKUAGLShgL8ZW5J4BOp5IzmLGwdT1rtmdb5Bw0Ed0bx9zZ0bzrfR656b29x8TZcSQSjLxPZIuttsQLfbUeQel9rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786806619; c=relaxed/simple;
	bh=qvXpYtZQiS50L4EroTO0ZWxFba1GTrjyyBktNyDx0zo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TaJ5kTCqjLjSFLpGMYzmvP+U3lOovqvhEWx6qbWr9KF4g4/YGNA3Q48yYrvBZMttPurU4kTQUklHFgHDSDoQg9SwUYqEZF0qfmsyQEzFvqrEaRG7mjP6hp+QSg0Bn0837h4m2pKaZzvjkgHSKguRPQQXkX8YwzN+OWL8HQe0jdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iybzikoE; arc=none smtp.client-ip=91.218.175.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iybzikoE"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qvXpYtZQiS50L4EroTO0ZWxFba1GTrjyyBktNyDx0zo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786806614; v=1; x=1787411414;
 b=iybzikoECoF2B3QVk4IuVjC/aXvzwqZplW8pPqT8CCOzpdZYydLAnevYpuaQsDYPfOlYIgx0
 6JgxnZwAYEmJOt0HhPGE0kesIUYne/tkrrfnamtkp73UL6Akka3SsuLtmLA17IDGi8QinSAa4q9
 Uu/0KONXvHw8ztTSFFYgDqco=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: from fedora.fritz.box (62.216.208.217)
	by mta11.migadu.com with ESMTPS id e4bd89cc808414b0;
	Sat, 15 Aug 2026 15:10:04 +0000
X-Migadu-Flow: FLOW_OUT
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Bartosz Golaszewski <brgl@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qce - simplify control flow in register functions
Date: Sat, 15 Aug 2026 17:09:47 +0200
Message-ID: <20260815150946.12142-3-thorsten.blum@linux.dev>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2177; i=thorsten.blum@linux.dev; h=from:subject; bh=qvXpYtZQiS50L4EroTO0ZWxFba1GTrjyyBktNyDx0zo=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkNjVa/Ldsv7W+/xljp9iHI/6P5lO/T5gaefaHZfs5Ac kPy/RfHO0pZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAif/8y/GK+xl/ferXyMDOv kHc869+YwPY897XpWnq/joq0rVfe84OR4Yd9q83joBqhpc8cj/3RXi36wDfO/MMu4wjuap6uyT1 HuAA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Remove the goto statements and handle errors directly to simplify the
control flow in qce_aead_register(), qce_ahash_register(), and
qce_skcipher_register().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/qce/aead.c     | 9 ++++-----
 drivers/crypto/qce/sha.c      | 9 ++++-----
 drivers/crypto/qce/skcipher.c | 9 ++++-----
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 1647d2329982..db2e2d7bfd07 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -829,14 +829,13 @@ static int qce_aead_register(struct qce_device *qce)
 
 	for (i = 0; i < ARRAY_SIZE(aead_def); i++) {
 		ret = qce_aead_register_one(&aead_def[i], qce);
-		if (ret)
-			goto err;
+		if (ret) {
+			qce_aead_unregister(qce);
+			return ret;
+		}
 	}
 
 	return 0;
-err:
-	qce_aead_unregister(qce);
-	return ret;
 }
 
 const struct qce_algo_ops aead_ops = {
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 87071f315088..915ba2dcc660 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -527,14 +527,13 @@ static int qce_ahash_register(struct qce_device *qce)
 
 	for (i = 0; i < ARRAY_SIZE(ahash_def); i++) {
 		ret = qce_ahash_register_one(&ahash_def[i], qce);
-		if (ret)
-			goto err;
+		if (ret) {
+			qce_ahash_unregister(qce);
+			return ret;
+		}
 	}
 
 	return 0;
-err:
-	qce_ahash_unregister(qce);
-	return ret;
 }
 
 const struct qce_algo_ops ahash_ops = {
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index b9a931037fdc..6e6c5f4b33a5 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -511,14 +511,13 @@ static int qce_skcipher_register(struct qce_device *qce)
 
 	for (i = 0; i < ARRAY_SIZE(skcipher_def); i++) {
 		ret = qce_skcipher_register_one(&skcipher_def[i], qce);
-		if (ret)
-			goto err;
+		if (ret) {
+			qce_skcipher_unregister(qce);
+			return ret;
+		}
 	}
 
 	return 0;
-err:
-	qce_skcipher_unregister(qce);
-	return ret;
 }
 
 const struct qce_algo_ops skcipher_ops = {
