Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8978BEF
	for <linux-crypto@vger.kernel.org>; Fri, 23 Aug 2024 06:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724395776; cv=none; b=kCSeNdZhD3CRE2FyR/G/qSQQexmQWVoa1eE2iAZcrGmIqYQOsFypH1FGDlcomOwOYWPL/T1RwqtP1GONZzlo5E/kazDC7yQz7ks2t1KJrjGLPp4l/a33cFGW1g193Kz+clh4DBHq4u0f+fPeb0rrNZ1hKWqsENlCYAZLUeArsV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724395776; c=relaxed/simple;
	bh=9r7QjXJU+C65NYSaWLGbHkGD+S+NexOdaZyZM3lk07A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bSDRTGK1U6t9Yg+nXFKlaTNaux/uEHvs2sgiHxV8X/aXlt4mbi6yT9U5RtPTc8UzQAcZc5KLdifFg/qHUWuLmQ6fqxWbIDggLfcTI6QpNAwNLDHj77uoSjChcoBuyFXZEeFd1BCLgMPmCnYqZu1inxVkjRNqm7gKYSSraH2BgGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WqrK11dx4z2CnGZ;
	Fri, 23 Aug 2024 14:49:25 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id E0D6114013B;
	Fri, 23 Aug 2024 14:49:29 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 23 Aug
 2024 14:49:29 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <lihongbo22@huawei.com>, <linux-crypto@vger.kernel.org>
Subject: [PATCH -next] crypto: Remove unused parameter from macro ROLDQ
Date: Fri, 23 Aug 2024 14:57:07 +0800
Message-ID: <20240823065707.3327267-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)

The parameter w1 is not used in macro ROLDQ, so we can
remove it to simplify the code.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 crypto/camellia_generic.c | 42 +++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
index c04670cf51ac..0c552868ebdd 100644
--- a/crypto/camellia_generic.c
+++ b/crypto/camellia_generic.c
@@ -316,7 +316,7 @@ static const u32 camellia_sp4404[256] = {
 /*
  *  macros
  */
-#define ROLDQ(ll, lr, rl, rr, w0, w1, bits) ({		\
+#define ROLDQ(ll, lr, rl, rr, w0, bits) ({		\
 	w0 = ll;					\
 	ll = (ll << bits) + (lr >> (32 - bits));	\
 	lr = (lr << bits) + (rl >> (32 - bits));	\
@@ -555,35 +555,35 @@ static void camellia_setup128(const unsigned char *key, u32 *subkey)
 	/* kw2 */
 	subL[1] = krl; subR[1] = krr;
 	/* rotation left shift 15bit */
-	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, 15);
 	/* k3 */
 	subL[4] = kll; subR[4] = klr;
 	/* k4 */
 	subL[5] = krl; subR[5] = krr;
 	/* rotation left shift 15+30bit */
-	ROLDQ(kll, klr, krl, krr, w0, w1, 30);
+	ROLDQ(kll, klr, krl, krr, w0, 30);
 	/* k7 */
 	subL[10] = kll; subR[10] = klr;
 	/* k8 */
 	subL[11] = krl; subR[11] = krr;
 	/* rotation left shift 15+30+15bit */
-	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, 15);
 	/* k10 */
 	subL[13] = krl; subR[13] = krr;
 	/* rotation left shift 15+30+15+17 bit */
-	ROLDQ(kll, klr, krl, krr, w0, w1, 17);
+	ROLDQ(kll, klr, krl, krr, w0, 17);
 	/* kl3 */
 	subL[16] = kll; subR[16] = klr;
 	/* kl4 */
 	subL[17] = krl; subR[17] = krr;
 	/* rotation left shift 15+30+15+17+17 bit */
-	ROLDQ(kll, klr, krl, krr, w0, w1, 17);
+	ROLDQ(kll, klr, krl, krr, w0, 17);
 	/* k13 */
 	subL[18] = kll; subR[18] = klr;
 	/* k14 */
 	subL[19] = krl; subR[19] = krr;
 	/* rotation left shift 15+30+15+17+17+17 bit */
-	ROLDQ(kll, klr, krl, krr, w0, w1, 17);
+	ROLDQ(kll, klr, krl, krr, w0, 17);
 	/* k17 */
 	subL[22] = kll; subR[22] = klr;
 	/* k18 */
@@ -613,18 +613,18 @@ static void camellia_setup128(const unsigned char *key, u32 *subkey)
 	/* k1, k2 */
 	subL[2] = kll; subR[2] = klr;
 	subL[3] = krl; subR[3] = krr;
-	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, 15);
 	/* k5,k6 */
 	subL[6] = kll; subR[6] = klr;
 	subL[7] = krl; subR[7] = krr;
-	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, 15);
 	/* kl1, kl2 */
 	subL[8] = kll; subR[8] = klr;
 	subL[9] = krl; subR[9] = krr;
-	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, 15);
 	/* k9 */
 	subL[12] = kll; subR[12] = klr;
-	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, 15);
 	/* k11, k12 */
 	subL[14] = kll; subR[14] = klr;
 	subL[15] = krl; subR[15] = krr;
@@ -632,7 +632,7 @@ static void camellia_setup128(const unsigned char *key, u32 *subkey)
 	/* k15, k16 */
 	subL[20] = kll; subR[20] = klr;
 	subL[21] = krl; subR[21] = krr;
-	ROLDQ(kll, klr, krl, krr, w0, w1, 17);
+	ROLDQ(kll, klr, krl, krr, w0, 17);
 	/* kw3, kw4 */
 	subL[24] = kll; subR[24] = klr;
 	subL[25] = krl; subR[25] = krr;
@@ -671,12 +671,12 @@ static void camellia_setup256(const unsigned char *key, u32 *subkey)
 	subL[12] = kll; subR[12] = klr;
 	/* k10 */
 	subL[13] = krl; subR[13] = krr;
-	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, 15);
 	/* kl3 */
 	subL[16] = kll; subR[16] = klr;
 	/* kl4 */
 	subL[17] = krl; subR[17] = krr;
-	ROLDQ(kll, klr, krl, krr, w0, w1, 17);
+	ROLDQ(kll, klr, krl, krr, w0, 17);
 	/* k17 */
 	subL[22] = kll; subR[22] = klr;
 	/* k18 */
@@ -688,17 +688,17 @@ static void camellia_setup256(const unsigned char *key, u32 *subkey)
 	subL[31] = krl; subR[31] = krr;
 
 	/* generate KR dependent subkeys */
-	ROLDQ(krll, krlr, krrl, krrr, w0, w1, 15);
+	ROLDQ(krll, krlr, krrl, krrr, w0, 15);
 	/* k3 */
 	subL[4] = krll; subR[4] = krlr;
 	/* k4 */
 	subL[5] = krrl; subR[5] = krrr;
-	ROLDQ(krll, krlr, krrl, krrr, w0, w1, 15);
+	ROLDQ(krll, krlr, krrl, krrr, w0, 15);
 	/* kl1 */
 	subL[8] = krll; subR[8] = krlr;
 	/* kl2 */
 	subL[9] = krrl; subR[9] = krrr;
-	ROLDQ(krll, krlr, krrl, krrr, w0, w1, 30);
+	ROLDQ(krll, krlr, krrl, krrr, w0, 30);
 	/* k13 */
 	subL[18] = krll; subR[18] = krlr;
 	/* k14 */
@@ -743,12 +743,12 @@ static void camellia_setup256(const unsigned char *key, u32 *subkey)
 	krll ^= w0; krlr ^= w1;
 
 	/* generate KA dependent subkeys */
-	ROLDQ(kll, klr, krl, krr, w0, w1, 15);
+	ROLDQ(kll, klr, krl, krr, w0, 15);
 	/* k5 */
 	subL[6] = kll; subR[6] = klr;
 	/* k6 */
 	subL[7] = krl; subR[7] = krr;
-	ROLDQ(kll, klr, krl, krr, w0, w1, 30);
+	ROLDQ(kll, klr, krl, krr, w0, 30);
 	/* k11 */
 	subL[14] = kll; subR[14] = klr;
 	/* k12 */
@@ -770,12 +770,12 @@ static void camellia_setup256(const unsigned char *key, u32 *subkey)
 	subL[2] = krll; subR[2] = krlr;
 	/* k2 */
 	subL[3] = krrl; subR[3] = krrr;
-	ROLDQ(krll, krlr, krrl, krrr, w0, w1, 30);
+	ROLDQ(krll, krlr, krrl, krrr, w0, 30);
 	/* k7 */
 	subL[10] = krll; subR[10] = krlr;
 	/* k8 */
 	subL[11] = krrl; subR[11] = krrr;
-	ROLDQ(krll, krlr, krrl, krrr, w0, w1, 30);
+	ROLDQ(krll, krlr, krrl, krrr, w0, 30);
 	/* k15 */
 	subL[20] = krll; subR[20] = krlr;
 	/* k16 */
-- 
2.34.1

