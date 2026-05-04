Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164E5331213
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 08:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777883368; cv=none; b=WKoh/ZRqZmNhdtXfbEFQ/7HMPWbU3dyLigtGFhRQDl+0AoeJALN2hyiiB621aiq3/UCGn0G5IiqLSyruCRZVz1My/FOJnLOzMMyRG28azynsGki9XQcl6q1JJK2kFeYI5kTiRZCGOl+XWxhECO3jIYcX7g1zAZ368ovX2HMAtW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777883368; c=relaxed/simple;
	bh=kxCLel+WOWkBqYAdfGWuFypK7wNRvgFOfPUthTpJoMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdQ9HqXhQFhD0kxs3A+8DJgiJ16QEs6L6MU6Tu+m9PzMKtdO4PwK+Q4QoPDMPLfIOlPe9Fb+v8m/8d2e3LJxbJfZE9TM4Ru27ahIKB1eV39V12+LDTgVYwDiaNe9N+Q6ZdxM2v2LnweE+AzZbRLE+loOw760h0VeQmgZvZI6PT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xvY/JXNE; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xvY/JXNE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777883365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eAVzWlbj/l3TP0OJkmodc8FLDbMV6iVh9d7fcSiYSXc=;
	b=xvY/JXNE1XD+U7HTKfNkI+KBvOXVZZKhsb5+u5hEi2DuBK1JSXyDLmxCLcIAL1MytY+YXQ
	e3tQZfXANKNEhe7pp+p9OV1+cVGaY6CEyDWnizWtWPagM3/KBOPnFcg9yxshUeFmYbDY41
	BHpj79s0dDCgd9EgkuSGc+ey26vWSEs=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: jitterentropy - fix URL
Date: Mon,  4 May 2026 10:28:51 +0200
Message-ID: <20260504082848.7194-5-thorsten.blum@linux.dev>
In-Reply-To: <20260504082848.7194-4-thorsten.blum@linux.dev>
References: <20260504082848.7194-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=831; i=thorsten.blum@linux.dev; h=from:subject; bh=kxCLel+WOWkBqYAdfGWuFypK7wNRvgFOfPUthTpJoMI=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJk/Ig52J7xYrq7jtYlX9WyAvXbZFpUqvYcvsrN92S6+L kg6nRfUUcrCIMbFICumyPJg1o8ZvqU1lZtMInbCzGFlAhnCwMUpABN5N5/hn+HlD2/KIrgWZ1+O e50oxbgvO2uJR+7bZQmB/xclc8Z6xTMyLF7YIbnzpPo7s8Z5x/ZlO29ZsjZl3s3ZP++4BjyLMdh xjAEA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The URL https://www.chronox.de/jent.html resolves to a 404 Not Found.
Use https://www.chronox.de/jent/ instead.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/jitterentropy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 6ac0257e8e0a..b024bff7024a 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -7,7 +7,7 @@
  * Design
  * ======
  *
- * See https://www.chronox.de/jent.html
+ * See https://www.chronox.de/jent/
  *
  * License
  * =======
@@ -47,7 +47,7 @@
 
 /*
  * This Jitterentropy RNG is based on the jitterentropy library
- * version 3.4.0 provided at https://www.chronox.de/jent.html
+ * version 3.4.0 provided at https://www.chronox.de/jent/
  */
 
 #ifdef __OPTIMIZE__
