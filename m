Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EAE449EDF
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392866; cv=none; b=H4L+b5/UHHNUDUhaCQDtwQpQjc5B5tZghDFQtzRywqCZRC6hU0og1aYllcirt8w8+32By32fCbLNxB+7diZJWbgYioNfVhm0HAx9MEDm6uL5XA5cLdDh9VblpFXkLcZD4LWQDQvFkiaoOgUdlamMwN/2kS/xEwsVltq4zMNpQ6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392866; c=relaxed/simple;
	bh=6kTZH/32p86XVcFzCtM+iCTAIlTdeH5SLSxO6RKsCew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0GgGpu0bz5XbJB11QwslBb+XvcMqnc773K1UNX5dq5qUNESuwShrVACMWTr2P3DysChMnv2k76S62EL0Vgk5AHXt0KZVm25Md0a6gHEl/SiB91P30sMG7LoGh/m80H/7p0lF6AMQl5cvZZ2p+ebLBek49nias82ppR0buTUUvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=shKCUsb9; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="shKCUsb9"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-38ea6a5a0b3so115283961fa.3
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 09:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392863; x=1777997663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lgq6z5Z9dkQxQkYs8MZMof9rIQA2gGJwXIkdAa9GMr0=;
        b=shKCUsb9lYVRVkv1BhyrEai4mumaHbtTbv0ompyo+0oZ7ilTgNRlXzLiS3D3ovJpfm
         7p52sreXTbpO2uTufMvUvC5sH57iVllYBFBIYYHFBKoyvs4QJsAicdAdTGSDr7J8a+R3
         4B2kR1al8tqFrV0PzjKLQhq7YboFjZDbGKEsOYM1MKTcUnnXW3bYWZn2hDM6R8g9t3jk
         +u0J1q6168Zbc0QN3sicHHUCcE6ZC9v0U9nyJ6aD6jogb4/YflbMo3KTbHqgwkI3Bmi0
         D37HDOjvoMWL407cIggQ/Adie88N8Hz3DNu0//bIdNHMuudkN+G2Fs/FMbCMj5Yp8RYY
         C7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392863; x=1777997663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lgq6z5Z9dkQxQkYs8MZMof9rIQA2gGJwXIkdAa9GMr0=;
        b=X9QrtflHPNzIIpGK8pnQ4/75ElF5QpJm2k/90p1LSLUMgqDG/AMnh9rjhqFHvZ+6nF
         UDkMlMslBy+IpLhtnpJPYSHnk84JyjrvmofJLckaM2uPqZZlLcPY/+IwdTqpTMaT48LM
         PRz1Ka9pcA+h4pAQnQ3I5Ze3a2bwwe42QtRroRql92kpqcKTXJTxXqmBCYkbawfODagI
         QS6qke5Un4svRhDhIZroMW9eEbGYcU+BGX9WWeGOS7nQFIzH46zMcKkvVdC2rnuu75HE
         ot4tGaI1aDo3Dmz0EJjLye8QBWUY+BgwGV6uaH1z5USUmsmipK4hgMAMdcLms9Yf/tqT
         Xm7A==
X-Forwarded-Encrypted: i=1; AFNElJ91/tbYn45Zd2F93JQk3W1OBtCIEeHXM/Qb8IvzjjBz8FtM93usvdOUHrHD84nx0mKmcrKR/PdU/XXf5ec=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4fJrzVsSog5oiQhV1va0QEh4oy4ODNRRQ3zduiJWUmZbKczX8
	V+2MnpmdZ99At6oGrjOmj4qbADX1DndXDkgp4NmUhZnbM1XQUjfqsrWP
X-Gm-Gg: AeBDiesG1AsWqnYiwrVat9odGHWKyBJDN3cZneqPF9brE0AukX6Xrmz1XPRVPPCIvBn
	1e8gVUCTmSy31o+Clr5dIrt8bPSHdE8HcwY0Mos0fIWy5ddiNuGWLrFvu8GI0tROjX/qNCZDOY1
	hvQhhsy4aEdb3pWXBbb3BvTSNFbnv/ySQY627w79wtZ1xQ7jDyMeF3BYsJ4LsYw9gIr47vT4jeV
	JF1oASRdcdddp/QGYIvnKFdzvei+SMLolVDfwPC+mt95JxfjSkPEMbNNrDxNPXYaUrNG+k08SC7
	t6eWfHcz8k4+wGakxg5VbJ2p2SZO7MmRCHnerl6fhI06GsnM82eQz8ra69s4CjukqZKwqTL7Vcb
	GRDNN3dek33jdBu0l4umjouIMuX9N8GiSeikpNhvT/sTjoGz7brO5T8Li1K8Ort0+ZJTOg4Zpxi
	iClZr3IS9k1/Gk9pQydWVN2mVcMg==
X-Received: by 2002:a05:651c:4191:b0:38d:f31d:7ebd with SMTP id 38308e7fff4ca-39240cdd576mr12818711fa.7.1777392863295;
        Tue, 28 Apr 2026 09:14:23 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3923f55f156sm8119671fa.32.2026.04.28.09.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:14:22 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH 2/2] rhashtable: Add bucket_table_free_atomic() helper
Date: Tue, 28 Apr 2026 18:14:19 +0200
Message-ID: <20260428161419.94695-2-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428161419.94695-1-urezki@gmail.com>
References: <20260428161419.94695-1-urezki@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rhashtable_insert_rehash() allocates a new bucket table
with GFP_ATOMIC, as it is called from an RCU read-side
critical section.

If rhashtable_rehash_attach() then fails, the new table
is freed via kvfree(). This is unsafe, since kvfree() may
fall back to vfree() for vmalloc-backed allocations, which
can sleep and trigger:

  BUG: sleeping function called from invalid context

Add bucket_table_free_atomic(), which uses kvfree_atomic()
so the table can be freed safely from non-sleeping context.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 lib/rhashtable.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6074ed5f66f3..4111aab8cee4 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -114,6 +114,14 @@ static void bucket_table_free(const struct bucket_table *tbl)
 	kvfree(tbl);
 }
 
+static void bucket_table_free_atomic(const struct bucket_table *tbl)
+{
+	if (tbl->nest)
+		nested_bucket_table_free(tbl);
+
+	kvfree_atomic(tbl);
+}
+
 static void bucket_table_free_rcu(struct rcu_head *head)
 {
 	bucket_table_free(container_of(head, struct bucket_table, rcu));
@@ -473,7 +481,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
 
 	err = rhashtable_rehash_attach(ht, tbl, new_tbl);
 	if (err) {
-		bucket_table_free(new_tbl);
+		bucket_table_free_atomic(new_tbl);
 		if (err == -EEXIST)
 			err = 0;
 	} else
-- 
2.47.3

