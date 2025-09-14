Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4A7184E;
	Sun, 14 Sep 2025 14:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757859992; cv=none; b=foEKzDsAKqKLWQQfYJH2pVMRJBszmY0XTrL9zRaXc7f44v36pVUoI9cx6vvSbupPGYGmSgNda7WKUQ6qn9a30QpUSnfV/g/pB1A1ytoda2qbS+vhFVOcooqcjR58QSRgk4Ru85TDdOSnfMAMwg2LxA6VHJE+Bx8izimlgwmqzNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757859992; c=relaxed/simple;
	bh=1m54E6z+0Mk4nf5vMNWvCREU3ZAJWokdJ3oPr2wNYGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PBOSLr1VQxN69t+5oMAIO3wUN24pTas226WLHaLFGlKQ4lXMl6tIUhDnm5q/IOMI7DeHpyf2qL68pewezytMnHI05fv2gfNyklUCjucPXUC/LYXhzeFH66Pq05iBSzwV711YRAqmJo0vlcqnROWzc6pbNz4xpHyslk7B+59NCug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a20E1wF5; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a20E1wF5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757859986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=O7iyoIjcxJMbNLJLlMdaYswICU8BUkx3Wp/zw4L19d4=;
	b=a20E1wF5dZtag3b6uixm5ITRZgTRLqc77hBMtotjk5uJKfkR8t4ZVSzzZQw/gHu4RrULra
	rl7x3xMbjstacN4ec7gd9dgBNacTDZmqv2XD9ufSJ0lxXIVsfCM9iN7fWuEIdBh5jjWUZF
	G7BF/hQlW9sfLx8qg94zkXKQNT2wJ+I=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: anubis - simplify return statement in anubis_mod_init
Date: Sun, 14 Sep 2025 16:25:55 +0200
Message-ID: <20250914142554.1917199-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Return the result of calling crypto_register_alg() directly and remove
the local return variable.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/anubis.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/crypto/anubis.c b/crypto/anubis.c
index 4268c3833baa..4b01b6ec961a 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -683,10 +683,7 @@ static struct crypto_alg anubis_alg = {
 
 static int __init anubis_mod_init(void)
 {
-	int ret = 0;
-
-	ret = crypto_register_alg(&anubis_alg);
-	return ret;
+	return crypto_register_alg(&anubis_alg);
 }
 
 static void __exit anubis_mod_fini(void)
-- 
2.51.0

