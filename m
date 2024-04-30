Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB9913D630
	for <linux-crypto@vger.kernel.org>; Tue, 30 Apr 2024 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714479288; cv=none; b=kYb0wIFaNEKSpvawzCLtnH+tuzPcIu6Pk/NvRuZN8AiBPf5jCgTdrEecG1+R2T3qtWlg7a93L0Lz0MCpSHSp5ir499FNSiNPHI9o8Oc0yy+Z35o1fOIW+HUVnMel6dinAGJapt7WMgwf2HXNVC6K2yPqzxqsCLGTY55d90E7XeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714479288; c=relaxed/simple;
	bh=qNIA5EMU9xvgHBe+A6KG+hvCP5I6GulvFtaoEYlIlL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntptK+lodWBcwuaKjQNIjWZta4O9QI5VR1RM7t1jU94E5jw+RKoZdlCzv9zV1kVephZnt+6fNX01T0TF3NEpP1PozkAlov2oNl0eoeHTtup2ivI7elmgSLq4T/ikA0A3+QVXPyJ11WoeBIjtuOptbCcRBY0Y9r8RDtLOhohkupg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=N58fYvrr; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="N58fYvrr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=from:to:cc:subject:date:message-id
	:in-reply-to:references:mime-version:content-transfer-encoding;
	 s=k1; bh=x7T5Lr+a3DoMbqwUUTK79IE4qIGWEgz3E1JCC4o9bkI=; b=N58fYv
	rr/3avZlx8n6oPfQLrCim2xv5doFHRuAL4bj9pC+H/n0o4Plg357bbEQ5grn/Bx0
	pImXfLMmh2Kn0A3YKDMeXOlxKWu/KCzd+ufEaHNWpbXjP1zvpv9diLLa2Mp2iXWD
	L2/Vq/LCMLR/zW7eCBUvhx6R2bZUxRa4bKBK7PaM5PQ20wtHwolKvhoJneVGcjct
	qyaFbM3np1TQlpvnzKuGahXzsHG7/hbRLuvqQ5Es2BdbId7u0peG3T1/fZVUVUH5
	8+AMh+JiNOtvw5VUj6R+9KCp04q8CJbebwgQo9HZSSbG7RXCeSJ8iucl1snJBhct
	m/lbW6Q/44A4hEww==
Received: (qmail 2627871 invoked from network); 30 Apr 2024 14:14:44 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 30 Apr 2024 14:14:44 +0200
X-UD-Smtp-Session: l3s3148p1@TG2yUE8Xtuxehhrb
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-crypto@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/1] crypto: api - use 'time_left' variable with wait_for_completion_killable_timeout()
Date: Tue, 30 Apr 2024 14:14:42 +0200
Message-ID: <20240430121443.30652-2-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240430121443.30652-1-wsa+renesas@sang-engineering.com>
References: <20240430121443.30652-1-wsa+renesas@sang-engineering.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a confusing pattern in the kernel to use a variable named 'timeout' to
store the result of wait_for_completion_killable_timeout() causing patterns like:

	timeout = wait_for_completion_killable_timeout(...)
	if (!timeout) return -ETIMEDOUT;

with all kinds of permutations. Use 'time_left' as a variable to make the code
self explaining.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 crypto/api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 7f402107f0cc..6aa5a3b4ed5e 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -202,18 +202,18 @@ static void crypto_start_test(struct crypto_larval *larval)
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval = (void *)alg;
-	long timeout;
+	long time_left;
 
 	if (!crypto_boot_test_finished())
 		crypto_start_test(larval);
 
-	timeout = wait_for_completion_killable_timeout(
+	time_left = wait_for_completion_killable_timeout(
 		&larval->completion, 60 * HZ);
 
 	alg = larval->adult;
-	if (timeout < 0)
+	if (time_left < 0)
 		alg = ERR_PTR(-EINTR);
-	else if (!timeout)
+	else if (!time_left)
 		alg = ERR_PTR(-ETIMEDOUT);
 	else if (!alg)
 		alg = ERR_PTR(-ENOENT);
-- 
2.43.0

