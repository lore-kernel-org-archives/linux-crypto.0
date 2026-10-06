Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0230248E0F0
	for <linux-crypto@vger.kernel.org>; Tue,  6 Oct 2026 16:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791305191; cv=none; b=tSPcZV22nzStMHkgnO5TOoZzMWpaJbUBmCRhg5WyyFPYHaHce2zFwx7El9dXPbwNljwhVg/bPthCkKYRDaXaA5kM2HWp3QR+sehbbkIi8CS/PkPES0ZQvHpnHC0IsLCsqsOGw8zB7i933m3v/uHnahvnlsrhVm6mqQdYbK66+QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791305191; c=relaxed/simple;
	bh=PmY2/2+YeeJVj0sv07/vs1Hu1NyaLYs5j1MFToQCEf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ok3V8tFsrCt5tqxq+48GQrkZCzYtlHfFIr4aY+ApPfDcuqFRgP21lTj0oCv3pM02uZ9pvplKMLS+p2MDd6ZYEO34zyWbQKwM0jyxBf+//0x679khK9adcwhrXoc2kjtSLqvyu8TCa17WyLMXXbTv1m69ebRIoYs3yZgtCnt7USI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1srn5IR; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1srn5IR"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a171b677d2so7032425e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 06 Oct 2026 09:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791305188; x=1791909988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nYsDsdPup8U8QMnz4nrwKqf/8/44Yd6sLmVcGYR6ZYI=;
        b=V1srn5IRbjf9sTfmIZ6zvrdhHliJxZ2bl9oxVWTd39QEEc6kwI3btIbeh0X5R2KSeu
         WsRfORieSgr0um4K6SHd9+odrtI6H229qQYE1uj1DOoxD0waanuCyU/qHKFGPohCdhjF
         BhxlsmV3mAF2yPnUDu6ClkV5aFQg4kNBwimWbNa5lXkZpvZPuh3M8POzJO905sL7Dvd3
         zNQoS1nlhzPMVjS84xyqUqjS91GaQWrGQU2R5n1K9G9YXFml1CF2E3kQ8BdpZLiZMqBT
         gkxWTpB9iiq0Ows3xxrhiqSsvGJRQ0ihckicnwmjEXWRQFFqYv47T9FCSJxFD17FXw2D
         +0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791305188; x=1791909988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nYsDsdPup8U8QMnz4nrwKqf/8/44Yd6sLmVcGYR6ZYI=;
        b=hzz2MYjWztLmB1ypyWK3FJScRFuAG6a+FK7ZtEMAwBw+ZpqwEeIZiVm+ajea7uyj+4
         olfR+GcV1ZhwqvBU8eWG7Jc7iwHfU4K+F72kIpJfN/j9JuZs4uupo4fEI6XWl6MGBIY2
         5WrkVfWY+REz5Cf3njSUGsuUbizqQ7Wx/AglXru7hYrErc+IR/yUOAwIrVUE1ZYemj/t
         q+fgcXwtZujZ6V9H4Ch5avZgba6b6U3h004Ed9ZY5HftwpyP/zytyNf74hLNJZzNg6Hs
         lEaSOG1jPwoJYoes/rKr/usRqGNu6p30W1LMxWHuYC+5JzjsMkgNXi+/AZgg76xtQ2rt
         uNLg==
X-Forwarded-Encrypted: i=1; AKwUvBxAxeueZNCBRrOg5EE28PlIXoEQk4h16nClGuM1YQJPUr6cFO2qfo6Z0HBejC9mr5TouMMmP1ZcqGrDrHQ=@vger.kernel.org
X-Gm-Message-State: AFuF++kLHWRkL8OK5ewyVPErpPRvQIrlXICaFbp+DCTzHFx7aoPEIJ5m
	JeEgeQacpbG+FUYYtl2idB3bdx7c87XcSvCOSe+gUoWHAUu63IiTW68xbACf534ut7IjTrzyKE0
	rqg==
X-Gm-Gg: AYBFou0/jVQN9sq24MzrMdBRGqnfI1hwH6E5DNl1U1LFMDWJg2ot4ScJvHDt0IrOVnd
	5PVnmbdvkHYl9RnJXjMLx3jWE5MfFUl7GAKboQV66trelZ+hBYg+QNRwGn9/280GWB+WzCXQlxX
	5h233RuPxGEAOJKu9OuoS5STHOu7K0NizllRl3KqOmOp71iBQjqZ+L42/oM40bZVnTqKXt8+npG
	16kPdQibkfukQPrJPvb5kjYmkrrr3IX6CpTX/EFimMVZuVgfnPkDU+Rk7UbMlrtSeuEwF1/c+WD
	08Id/PeR6I/8Q4n8oxN1QQxfegBhysOocRAUYcc+FAj32Us71226OeOI0CTSvbZdeDGhhHMJyIN
	vSkIjk9v8uQUYaFTjjDytz41Em7G6eJNdG2mQO7C/nJc0dJDdf9AMkUVcEg9eBSOxMjyBPeLo2C
	74El1+9Pw/L2AZhpLL2en6goSVoaCsaQhPgQVFVZnDFlhiCoNc5m+pzzW06l0GydF1nAGs2/jDh
	RY/fNpa
X-Received: by 2002:a05:600c:3516:b0:4a0:1efa:c74a with SMTP id 5b1f17b1804b1-4a17b53c6e9mr29983675e9.20.1791305188032;
        Tue, 06 Oct 2026 09:46:28 -0700 (PDT)
Received: from fedora.domain.name ([217.218.153.210])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a178db8c6dsm134197405e9.14.2026.10.06.09.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 09:46:27 -0700 (PDT)
From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
To: tgraf@suug.ch
Cc: herbert@gondor.apana.org.au,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Subject: [PATCH] rhashtable: move init kernel-doc to header
Date: Tue,  6 Oct 2026 20:16:19 +0330
Message-ID: <20261006164619.342010-1-ampr.mhd@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
---
 include/linux/rhashtable-types.h | 51 ++++++++++++++++++++++++++++++++
 lib/rhashtable.c                 | 51 --------------------------------
 2 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-types.h
index 57c11ec9d..b35ad6ff1 100644
--- a/include/linux/rhashtable-types.h
+++ b/include/linux/rhashtable-types.h
@@ -145,6 +145,48 @@ int __rhashtable_init_noprof(struct rhashtable *ht,
 									\
 	__rhashtable_init_noprof(ht, params, &__key);			\
 })
+/**
+ * rhashtable_init - initialize a new hash table
+ * @ht:		hash table to be initialized
+ * @params:	configuration parameters
+ *
+ * Initializes a new hash table based on the provided configuration
+ * parameters. A table can be configured either with a variable or
+ * fixed length key:
+ *
+ * Configuration Example 1: Fixed length keys
+ * struct test_obj {
+ *	int			key;
+ *	void *			my_member;
+ *	struct rhash_head	node;
+ * };
+ *
+ * struct rhashtable_params params = {
+ *	.head_offset = offsetof(struct test_obj, node),
+ *	.key_offset = offsetof(struct test_obj, key),
+ *	.key_len = sizeof(int),
+ *	.hashfn = jhash,
+ * };
+ *
+ * Configuration Example 2: Variable length keys
+ * struct test_obj {
+ *	[...]
+ *	struct rhash_head	node;
+ * };
+ *
+ * u32 my_hash_fn(const void *data, u32 len, u32 seed)
+ * {
+ *	struct test_obj *obj = data;
+ *
+ *	return [... hash ...];
+ * }
+ *
+ * struct rhashtable_params params = {
+ *	.head_offset = offsetof(struct test_obj, node),
+ *	.hashfn = jhash,
+ *	.obj_hashfn = my_hash_fn,
+ * };
+ */
 #define rhashtable_init(...)	alloc_hooks(rhashtable_init_noprof(__VA_ARGS__))
 
 int __rhltable_init_noprof(struct rhltable *hlt,
@@ -156,6 +198,15 @@ int __rhltable_init_noprof(struct rhltable *hlt,
 									\
 	__rhltable_init_noprof(hlt, params, &__key);			\
 })
+/**
+ * rhltable_init - initialize a new hash list table
+ * @hlt:	hash list table to be initialized
+ * @params:	configuration parameters
+ *
+ * Initializes a new hash list table.
+ *
+ * See documentation for rhashtable_init.
+ */
 #define rhltable_init(...)	alloc_hooks(rhltable_init_noprof(__VA_ARGS__))
 
 #endif /* _LINUX_RHASHTABLE_TYPES_H */
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6362896e4..5f53b4c71 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -1120,48 +1120,6 @@ static u32 rhashtable_jhash2(const void *key, u32 length, u32 seed)
 	return jhash2(key, length, seed);
 }
 
-/**
- * rhashtable_init - initialize a new hash table
- * @ht:		hash table to be initialized
- * @params:	configuration parameters
- *
- * Initializes a new hash table based on the provided configuration
- * parameters. A table can be configured either with a variable or
- * fixed length key:
- *
- * Configuration Example 1: Fixed length keys
- * struct test_obj {
- *	int			key;
- *	void *			my_member;
- *	struct rhash_head	node;
- * };
- *
- * struct rhashtable_params params = {
- *	.head_offset = offsetof(struct test_obj, node),
- *	.key_offset = offsetof(struct test_obj, key),
- *	.key_len = sizeof(int),
- *	.hashfn = jhash,
- * };
- *
- * Configuration Example 2: Variable length keys
- * struct test_obj {
- *	[...]
- *	struct rhash_head	node;
- * };
- *
- * u32 my_hash_fn(const void *data, u32 len, u32 seed)
- * {
- *	struct test_obj *obj = data;
- *
- *	return [... hash ...];
- * }
- *
- * struct rhashtable_params params = {
- *	.head_offset = offsetof(struct test_obj, node),
- *	.hashfn = jhash,
- *	.obj_hashfn = my_hash_fn,
- * };
- */
 int __rhashtable_init_noprof(struct rhashtable *ht,
 		    const struct rhashtable_params *params,
 		    struct lock_class_key *key)
@@ -1228,15 +1186,6 @@ int __rhashtable_init_noprof(struct rhashtable *ht,
 }
 EXPORT_SYMBOL_GPL(__rhashtable_init_noprof);
 
-/**
- * rhltable_init - initialize a new hash list table
- * @hlt:	hash list table to be initialized
- * @params:	configuration parameters
- *
- * Initializes a new hash list table.
- *
- * See documentation for rhashtable_init.
- */
 int __rhltable_init_noprof(struct rhltable *hlt,
 			   const struct rhashtable_params *params,
 			   struct lock_class_key *key)
-- 
2.55.0

