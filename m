Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBD8416857
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 10:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785493583; cv=none; b=nGJVXrvRSaykiA1KrJ2uXsQAJZsRGTISw8EYpiH2zf0wE6Ib8FolK+DQosvt7W9dWxc35Jp7Wvg372w0nVqK/rdNc52lA0xzdRo5Nnh0GMfp9H0w+skTR+5UuDE6FEV1XgU8+K52itYCeAizNuZz6dRKQeuHCDBxGDIlq/c5u08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785493583; c=relaxed/simple;
	bh=21lXlh7LScmqJ9+uO/k2S4w+EtBuWDm7JN0eeAyQ1do=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SOJfmH2N7IP0YV89YZFvDw+kPuG/TYHDGh5HT/WXgTRZzYWXrHI1pQcD2Y8okGeIsxb4AdEhGPC63I2N1BJ5Lj677Kroe1Ke5KSruxK/boRIzN8v+IuLe4eCeqFXWzZTMnL/h8F8sHF+mAKjC2tXyPo6eJfGvkrV1Wbr7QrRjA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nvmNWWnT; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nvmNWWnT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785493554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U+75GsPxfpTGhplg5M7ghyzuNkAix39xXhgO52Sm88o=;
	b=nvmNWWnTBPsJomdKp4xAj9q2/Q7yqkAQ22NweNAGAjAGJnIvLKlryVFximAaHtPF6ISjmd
	++dNmF/yi+SBR3WbrZCnnDoDTA+pVX2n1SUgvtW6MbhDOqNlomSbrXgo4NHuPejY5i4G4l
	u+C7oZaxqzj8laDUtnL54brfos9aD7E=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Bartosz Golaszewski <brgl@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: qce - simplify devm_qce_register_algs
Date: Fri, 31 Jul 2026 12:25:32 +0200
Message-ID: <20260731102532.742739-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=941; i=thorsten.blum@linux.dev; h=from:subject; bh=21lXlh7LScmqJ9+uO/k2S4w+EtBuWDm7JN0eeAyQ1do=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFk5FTKHU3Ve5U65OnelXbJ+zKGeljCrt09ZZvxULRbdP NPQnmtjRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAExkxwdGhifch/jaGXi4H9bt vKG+KaZx3fSdt2Ky7MQqCy7auFyRi2f4w9917zK7e0a5HNPZ6VMXn6qLTnWvPnw6RKvicK5wccd /bgA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Drop the redundant ret = -ENODEV initialization. Use a while loop and
reuse the local index variable i on the error path.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/qce/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index ea5b9689ce68..a848fd58a354 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -51,14 +51,14 @@ static void qce_unregister_algs(void *data)
 static int devm_qce_register_algs(struct qce_device *qce)
 {
 	const struct qce_algo_ops *ops;
-	int i, j, ret = -ENODEV;
+	int i, ret;
 
 	for (i = 0; i < ARRAY_SIZE(qce_ops); i++) {
 		ops = qce_ops[i];
 		ret = ops->register_algs(qce);
 		if (ret) {
-			for (j = i - 1; j >= 0; j--)
-				qce_ops[j]->unregister_algs(qce);
+			while (i--)
+				qce_ops[i]->unregister_algs(qce);
 			return ret;
 		}
 	}
