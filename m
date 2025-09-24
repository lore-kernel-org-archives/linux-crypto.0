Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F03225401;
	Wed, 24 Sep 2025 19:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758742021; cv=none; b=syuiRDXXwl9MeSFNPi9izJpPHHNf0dnuXe7VhkOWDEX26UobbfbAKkac3pa/T8/FeM8wYYjGsiuAPAk30IkgSU1O153h2HJeI1FkcCSlLIHjcIwYSSirE3fNHBuXVs4Zn7o2wnlzmHjtdUTZd18UKSxMNNYP1q+Nm4x9pOE9rZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758742021; c=relaxed/simple;
	bh=dxxN/csxez4Q5Z//UTpS7TKxWDYcBbVXQtb+yPreT5A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X76Om6QYdyCBhO7cOefdIs/FxhIW2YI/GnFnMhoUjuCFZk5w+/MztZALeba8izP49JzJvmIrZT7GpAJakqOB1IrD1U+994jJEE/EudJg1we8DWwaI9UI8m4kQbKrqdQuzixqBEshhMcOaIc2ZIwhzdfRuwTiLLoyuCmAZSn+hvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BRU9q1AT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRU9q1AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D035CC4CEE7;
	Wed, 24 Sep 2025 19:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758742021;
	bh=dxxN/csxez4Q5Z//UTpS7TKxWDYcBbVXQtb+yPreT5A=;
	h=From:To:Cc:Subject:Date:From;
	b=BRU9q1ATeJTOQvnF1sQVjH90o7fQy4m4fsHTxbjQzDpIeU8mBOKWLJWbZCr8jlK/T
	 5Uth40Rm6L44h9wAXoSBJhSvCXtCNI2rh0UpFxF30QgXI8TGTwYxv+2KPmJNZLn6Ye
	 jOv7YsTm2fQ525zOv7eQrgOHWbUGfsA/KwoeWwlVuSYiG3cvISxE3ZlvvAZD5eLDze
	 1LAzb69MpuA7ZcTEocg0i2mDwDOWRSjqYnBRyoMVdP20yxtvkxHmA+EMjQf9pmEEVg
	 9FLFB9d8VKPs7IseGuclByhHsoqvkoxkK2lNSRKDleCj+FFkg15IVAsh5/saegyq15
	 hJ2MTdHaF5qnw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: af_alg - Fix incorrect boolean values in af_alg_ctx
Date: Wed, 24 Sep 2025 19:26:41 +0000
Message-ID: <20250924192641.850903-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 1b34cbbf4f01 ("crypto: af_alg - Disallow concurrent writes in
af_alg_sendmsg") changed some fields from bool to 1-bit bitfields.
However, some assignments to these fields, specifically 'more' and
'merge', assign values greater than 1.  These relied on C's implicit
conversion to bool, such that zero becomes false and nonzero becomes
true.  With a 1-bit bitfield instead, mod 2 of the value is taken
instead, resulting in 0 being assigned in some cases when 1 was
intended.  Fix this by restoring the bool type.

Fixes: 1b34cbbf4f01 ("crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/if_alg.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 0c70f3a55575..02fb7c1d9ef7 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -150,15 +150,15 @@ struct af_alg_ctx {
 	struct crypto_wait wait;
 
 	size_t used;
 	atomic_t rcvused;
 
-	u32		more:1,
-			merge:1,
-			enc:1,
-			write:1,
-			init:1;
+	bool more;
+	bool merge;
+	bool enc;
+	bool write;
+	bool init;
 
 	unsigned int len;
 
 	unsigned int inflight;
 };

base-commit: cec1e6e5d1ab33403b809f79cd20d6aff124ccfe
-- 
2.51.0.536.g15c5d4f767-goog

