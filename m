Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30E143DA5F
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392866; cv=none; b=szmIjWpUW7sK+lCG0FgiiTEILwr7vqAfW3WLpvtPJsRQLuXw+XjRyOxWCjsHrVZGsUug/WhzSuCnmGzl+qFJ4o/VCjNxlZgPEasC6GS5BqIIGWnCllxUKjCcyFPNNynaIG3j0XwMt9MvvMl8sWfdQDYG84jEwXeWdQJSPr1/Yac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392866; c=relaxed/simple;
	bh=vtRBxFYDRtCIfbhvjAwrasnDVRUrslKT4nqT86kXZqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mj1qZgRPthBDeeWUYOC0NVrryJD9LPidQvxVhXMoQSzeltRZAIyuX4vDwxR26Jt0L2im4rhoHS5j2A258JsyhjvHSf6/+7sPOVvY1nsczPiG1z7SNzM01yif5TUyWqSjZxfUJLjHMCG7Pqx2Px0STxGrWm36cJHRtyX5ZjbYOA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FSCd6U0W; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FSCd6U0W"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a74962749aso140068e87.3
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 09:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392863; x=1777997663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fMi+2e+Rz5b/ze+8xxh3jzCKZiMtlYsCgR+SOJgoVEM=;
        b=FSCd6U0W+kENNsrsret3jl4eKd9cf6qDz9aTUs+ld+XoAnaL+nOqBjWuhxraI0Insa
         kqXlrUBHE3rdBWT0JH04k3rUudsKlfIeoPWp3c5REcP+Zd7PJJJJBG3/p44ckj/8c5vY
         /oRHSUDQnQZdj5Dw2nqRe6tPj1ff8fsEe7WBtB8q3MGMesuEmM9wUfs2L+to9HKESHsz
         VK3ks/0BRy/2T2vEN+AumCqwWdqKRkppmi5hBPdEz0cEpn5h7xSJML2nbuaqqm+xG5+j
         94qNGAr3v4r2WuGawQSJddoibSofZyvs1gSzNyRk0Hs0Z0xACS9sr/wi5fG8sFsjCPlv
         VS1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392863; x=1777997663;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fMi+2e+Rz5b/ze+8xxh3jzCKZiMtlYsCgR+SOJgoVEM=;
        b=L5MsawwUMV+Gns8KCaqGdkJ3VrGCA3S4G4jjFTg98PuygOSz7qMnGfIl+V9vxxwshh
         T//WH1Urh4/6vQ8D8/ZiIU8c1rhK1FZyVMe2ahCq+A8Yo6YRstQdih69u7XBhPRVm2rk
         Aa4FU0JkiCcq42nw4RiZn6JSwfAIHnIKI1uZ9/DwEnMokfBk6/kbOvPAJ1UGYsqNWHJZ
         Eff1kD7C2f1wbpHYNhRAL9ukgJcq8WKIUF6nAoSuo7W2st4g+8+kt0CxJp7fXVL79rEr
         la9RWseVt0sCNLyK+kvMbXHgYCmdfDkXJcK94bx0zAhs8DcSXfQ904QmLZlixd6pBsWO
         x+zg==
X-Forwarded-Encrypted: i=1; AFNElJ97D8TDHS73iPmFOImXXundaTgco4bKHVu8pNf+rieWpWE7yV+b1Vo6G3jDXbWSdlGp5TQnMHwv8voP62M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfeY5ZDyZic+1uP9zs8IVQKX/qMIYIwIjtjeCwb3nfvWAnyf7F
	11aVA3d3caXEDKLcTApS5RLGKpEj/ods+ICZwHJFycQzkovfwpR7PawY
X-Gm-Gg: AeBDieudIKLMpAsyuPIBvHxoYRuUltqF7ysIXdxPuB/VWPk3mpBtglovl7nRrdKv0Zr
	NmahTAvS6diSqbRVpE/EIVpjTgTaDfAUCV+znD+VKnoGCD6mtXg6c94HaX565B9Dnl6QUV8RBKr
	WUvIhE2l3aRJ7ST8XWyx1pv8y1+l18vu5ZXDpX+T1IkxBemYqF8tvkj4GkG9yTGEl7c8MwtcAP7
	7W1hlazdVxD/bwvdbnuh1iJ+4Un8dKLK6aOytqk5RAOEES0QXtLuRdKLX10GYFgE11JqkFHr99V
	W/jkxaQxnPTHPSk+CmBvjiQPijNYGBnhdqo/Xzld8x4Phhz92v8s/t7W1/f0uvFgH+SOk5qwkTN
	u9R8cIuZHnbB+zIToZPjEYeol7gmeWGJEueZKqL23d4MLiuW7LUKS6d/HOjwtUJC3xF/yNNwWbt
	/jtaN6bCB9FRPS1QNKQWpCKf03pg==
X-Received: by 2002:a05:6512:3c97:b0:5a2:7ab9:e12c with SMTP id 2adb3069b0e04-5a746623476mr1767503e87.24.1777392862547;
        Tue, 28 Apr 2026 09:14:22 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3923f55f156sm8119671fa.32.2026.04.28.09.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:14:22 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH 1/2] mm/slab: Add kvfree_atomic() helper
Date: Tue, 28 Apr 2026 18:14:18 +0200
Message-ID: <20260428161419.94695-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvmalloc() now supports non-sleeping GFP flags, including
the vmalloc fallback path. This means it may return vmalloc
memory even for GFP_ATOMIC and GFP_NOWAIT allocations.

Freeing such memory with kvfree() may then end up calling
vfree(), which is not safe for non-sleeping contexts.

Introduce kvfree_atomic() helper for such cases. It mirrors
kvfree(), but uses vfree_atomic() for vmalloced memory.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/slab.h |  3 +++
 mm/slub.c            | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 15a60b501b95..2b5ab488e96b 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1234,6 +1234,9 @@ void *kvrealloc_node_align_noprof(const void *p, size_t size, unsigned long alig
 extern void kvfree(const void *addr);
 DEFINE_FREE(kvfree, void *, if (!IS_ERR_OR_NULL(_T)) kvfree(_T))
 
+extern void kvfree_atomic(const void *addr);
+DEFINE_FREE(kvfree_atomic, void *, if (!IS_ERR_OR_NULL(_T)) kvfree_atomic(_T))
+
 extern void kvfree_sensitive(const void *addr, size_t len);
 
 unsigned int kmem_cache_size(struct kmem_cache *s);
diff --git a/mm/slub.c b/mm/slub.c
index 2b2d33cc735c..b096677c8152 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6802,6 +6802,22 @@ void kvfree(const void *addr)
 }
 EXPORT_SYMBOL(kvfree);
 
+/**
+ * kvfree_atomic() - Free memory.
+ * @addr: Pointer to allocated memory.
+ *
+ * Same as kvfree(), but uses vfree_atomic() for vmalloc
+ * backed memory. Must not be called from NMI context.
+ */
+void kvfree_atomic(const void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		vfree_atomic(addr);
+	else
+		kfree(addr);
+}
+EXPORT_SYMBOL(kvfree_atomic);
+
 /**
  * kvfree_sensitive - Free a data object containing sensitive information.
  * @addr: address of the data object to be freed.
-- 
2.47.3

