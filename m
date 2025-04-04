Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1794A1607A4;
	Fri,  4 Apr 2025 00:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743725062; cv=none; b=Y3Iyz0X7Let5RygOzUCTF2iMC2v0rZZx0k5X553SOcg6zfPUNw4+hCbWNTR7Ih9rg//nS1JGMDGuKBgOqRue0YQMjJK0cJqnkX350301As3r0l0l3KcgNqD4ZhNi50EZ9MhNriExM3bshHlnJGOReoDaaWTlb2Qty3LzrT71z+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743725062; c=relaxed/simple;
	bh=T2lrDZMpW5FzWg6jAjAkGYig6WQSR9D3iLhX1va/tdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zl97B+vSueKlSp+8DtYFfkriI32IvdA3AnE2Cy2Bzu6BWHpVh5qLRs4BsX6kLo0VKtNhABP6yX/hoOp+wssN/spUF36YXrs9VOdljgjzyVOxCG7dihGkp70zKKrPAQl+Uld7MzUEz+Qbs/ODWqFRIZptm403XKlWoLtx+WNRyYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVyXMNSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVyXMNSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2784C4CEE3;
	Fri,  4 Apr 2025 00:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743725061;
	bh=T2lrDZMpW5FzWg6jAjAkGYig6WQSR9D3iLhX1va/tdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVyXMNSv7elUJeDpquGhoJ22kNlNTHHtsfsUi+drifgF9RxLO+epQ5pjraaxxGTQr
	 Cupqu4L+lMCPsKFOfSJua0sqsIDeZGHWd1WNQ03qlpKEQsftdfP7K1fesTv8vckNJL
	 ntekdfqykybFHZID2+T+Pe3kWXCrXSX0TfdaEvO7aJjY/8Wk2KoC+mKgkIuQ87HPHq
	 3qqN1B6a48KXA8udhxnbm2t86Hzmo5CqX56UGWXf+ThqaRF/3/My3zfpQSqwwFdTZr
	 XkPqXdr7Gaf2tR2Irc8qQ+5XRcUG50iGG4OUmakiDrMiL+1Oj/lgKvkTpnwS2qzJ4S
	 LWloL36J9897g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+b3e02953598f447d4d2a@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 08/23] crypto: null - Use spin lock instead of mutex
Date: Thu,  3 Apr 2025 20:03:45 -0400
Message-Id: <20250404000402.2688049-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250404000402.2688049-1-sashal@kernel.org>
References: <20250404000402.2688049-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit dcc47a028c24e793ce6d6efebfef1a1e92f80297 ]

As the null algorithm may be freed in softirq context through
af_alg, use spin locks instead of mutexes to protect the default
null algorithm.

Reported-by: syzbot+b3e02953598f447d4d2a@syzkaller.appspotmail.com
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/crypto_null.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 5b84b0f7cc178..3378670286535 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -17,10 +17,10 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
+#include <linux/spinlock.h>
 #include <linux/string.h>
 
-static DEFINE_MUTEX(crypto_default_null_skcipher_lock);
+static DEFINE_SPINLOCK(crypto_default_null_skcipher_lock);
 static struct crypto_sync_skcipher *crypto_default_null_skcipher;
 static int crypto_default_null_skcipher_refcnt;
 
@@ -152,23 +152,32 @@ MODULE_ALIAS_CRYPTO("cipher_null");
 
 struct crypto_sync_skcipher *crypto_get_default_null_skcipher(void)
 {
+	struct crypto_sync_skcipher *ntfm = NULL;
 	struct crypto_sync_skcipher *tfm;
 
-	mutex_lock(&crypto_default_null_skcipher_lock);
+	spin_lock_bh(&crypto_default_null_skcipher_lock);
 	tfm = crypto_default_null_skcipher;
 
 	if (!tfm) {
-		tfm = crypto_alloc_sync_skcipher("ecb(cipher_null)", 0, 0);
-		if (IS_ERR(tfm))
-			goto unlock;
-
-		crypto_default_null_skcipher = tfm;
+		spin_unlock_bh(&crypto_default_null_skcipher_lock);
+
+		ntfm = crypto_alloc_sync_skcipher("ecb(cipher_null)", 0, 0);
+		if (IS_ERR(ntfm))
+			return ntfm;
+
+		spin_lock_bh(&crypto_default_null_skcipher_lock);
+		tfm = crypto_default_null_skcipher;
+		if (!tfm) {
+			tfm = ntfm;
+			ntfm = NULL;
+			crypto_default_null_skcipher = tfm;
+		}
 	}
 
 	crypto_default_null_skcipher_refcnt++;
+	spin_unlock_bh(&crypto_default_null_skcipher_lock);
 
-unlock:
-	mutex_unlock(&crypto_default_null_skcipher_lock);
+	crypto_free_sync_skcipher(ntfm);
 
 	return tfm;
 }
@@ -176,12 +185,16 @@ EXPORT_SYMBOL_GPL(crypto_get_default_null_skcipher);
 
 void crypto_put_default_null_skcipher(void)
 {
-	mutex_lock(&crypto_default_null_skcipher_lock);
+	struct crypto_sync_skcipher *tfm = NULL;
+
+	spin_lock_bh(&crypto_default_null_skcipher_lock);
 	if (!--crypto_default_null_skcipher_refcnt) {
-		crypto_free_sync_skcipher(crypto_default_null_skcipher);
+		tfm = crypto_default_null_skcipher;
 		crypto_default_null_skcipher = NULL;
 	}
-	mutex_unlock(&crypto_default_null_skcipher_lock);
+	spin_unlock_bh(&crypto_default_null_skcipher_lock);
+
+	crypto_free_sync_skcipher(tfm);
 }
 EXPORT_SYMBOL_GPL(crypto_put_default_null_skcipher);
 
-- 
2.39.5

