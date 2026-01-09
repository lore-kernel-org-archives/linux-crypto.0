Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C300835E555
	for <linux-crypto@vger.kernel.org>; Fri,  9 Jan 2026 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971934; cv=none; b=oroM1g5fa/qzCEsy9rYdCDN+pJbFpbLZa89VJGPiJbgQhj110MkeKtBzba4JGsxBLn4im8QHDhKgjM2D7HhO4SQoBruPddkbBv5wjB3Nxf2tEHi8knQr5N+wwIL55yrekKiaxU1dBdHbMoDpKIdHbwJpML2C7HZyF86dI9/SyLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971934; c=relaxed/simple;
	bh=EDBlLfUmf+gpPRSl4DiQrR4TnX2VZj4pRowglGYuvCY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qWc+5s5D3ZkVdDV4SANVJDVKqHNGFZs7C4bLxMQjvMSYDh1m+/qp1r9B1seljVbgJt0h65P+QPgQK72sc/H/z20bjn89q4bbRjnIF9+t1ogQVfuT8iXwIuJsmH3zwa9a9hoLXjA7FcIqsl3LsnbKE6xMtAagzbfQfXb8Xe+QNTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hnIa5N+V; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hnIa5N+V"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47795f6f5c0so27310555e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 09 Jan 2026 07:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767971931; x=1768576731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pcEd7Bt+Tpd912jOjcyYBByq481ws1oPjcYFggTtCj4=;
        b=hnIa5N+VsMtJWuyeqN0KWwOcVlJWAml4pSLvTwGJTYkwAqAXeouOY9z7o8AxFeJTRH
         DRcRnBQL05TNVfGUk/qk/PguWbZtQzan9e8ttf9DKS44yLnEefxSGUAelXxaMmjoY/yP
         BrY/oiOhoyh20s1lPksYV9NRjELaUd2p7v02rm15QL54QlHBcTuLLPD4MlnX9HHkOAwF
         nC5LX/116fPjHkrRy9pFfq15jNLaMxbiSyUxSTkWPe2CpgH6sF0iSt/+6Z0fWYS6QxEB
         NulhheXfMiY1X4CcjbWlvui/hIRzPm6fDmG0vQK+cnNs8K25/jI8JeJd8NfhfEkEnLpU
         qMMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767971931; x=1768576731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pcEd7Bt+Tpd912jOjcyYBByq481ws1oPjcYFggTtCj4=;
        b=uSJ0ARAdX9i0T3HhETV1aujHj/NsWVSoW3lFNwH0UUNmIDdOOg4BXpoUTA2jZKCRtP
         qdLdjmmoAv4QvfIfJLU1qwHCJ4sULHLK+ZWhCHrc78HrO3tvCcoIv5sqAfwkXwF+PTA6
         OHC51kHT/mSDu5p7Abb+l07EMsQKWfmHGbR9lFjl9YLSFvPH2BwD4e2C3kLcQ4doFGQH
         IeSuhTx3x+4CdLn394Aohy8O3Bpv0TRv3t7nOtzyGNNetKL7gUNgOMhck2S8/0C48xbp
         rq+xtQ51PrzeRdRU0X6YscQF/AMaxhPuEPaBr9LoIj7nnJHH9Zr0MZOfJ+ZY3cc1+x7N
         /sQg==
X-Gm-Message-State: AOJu0YzQvuaBH98rlhxdxkbnrQT8BfYCokqhJZMXDxVT6JQZp60peUFu
	Aj4CPsltuPIjZCjU0sOMgGxwdHnrKta0mj9Dtq7YG+OnZFbbeVx5Q6bp
X-Gm-Gg: AY/fxX7lRduKb0a4UeVSbbtJTEynjfFEuNCQjPzBT/DHDP3RNMn3JPbsqBdQxX/GDy0
	8zUTVK0qUfUgddUo23A3gmlDFm6ssffX6mABaGcpZLK+eNKVlL1kX3RV62WOibBmfbMtbH0gyv3
	sOfD4KTj+rNkBuKRJgl4rpja5+XIHZF0Dg0mHvYmJNQ+VFOwC6M4miLaxVIN/WfESdTVi9/44Nm
	lEP7h29Zffh4/VIqRuWN2Bw8ZJqcdjuYpT6CzvhFQT1AvJhnKBi92lYMa1KB75Z44+6LjA+8osv
	C2F/MnNL94w8mKO73LFZR1yjFmFt7XfOazVt0RRaEQg3aMn0Jgdx2KOipwrcB4terYjwGZ8qltu
	xsyVZK7Rz8z+U7JHdUynzdteFa3ukR4Pws4o42IJIuKyXpe8T1/YAVyUuweEoNwOCJBvQuhxfao
	8UbZr4FkwCJ8cKz0v/t5vPZ9UJXCohWlI7RQ==
X-Google-Smtp-Source: AGHT+IG6z5wZqpL0qga9y9TylesRtaoQtNI3Vllh0FmZqnb7OF1nL7cYBYV9qpEf4BZX8DBsJuwCUQ==
X-Received: by 2002:a05:600c:8b2c:b0:477:8ba7:fe0a with SMTP id 5b1f17b1804b1-47d84b54c3cmr106561595e9.24.1767971930694;
        Fri, 09 Jan 2026 07:18:50 -0800 (PST)
Received: from ptb-02009389.paris.inria.fr ([193.52.24.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f4184e1sm207442975e9.4.2026.01.09.07.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 07:18:49 -0800 (PST)
From: Ella Ma <alansnape3058@gmail.com>
To: thomas.lendacky@amd.com,
	john.allen@amd.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	arnd@arndb.de
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	julia.lawall@inria.fr,
	Markus.Elfring@web.de,
	Ella Ma <alansnape3058@gmail.com>,
	Tom Lendacky <thomas.lendacky@gmail.com>
Subject: [PATCH v2] crypto: ccp - Fix a crash due to incorrect cleanup usage of kfree
Date: Fri,  9 Jan 2026 16:17:24 +0100
Message-Id: <20260109151724.58799-1-alansnape3058@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260108152906.56497-1-alansnape3058@gmail.com>
References: <20260108152906.56497-1-alansnape3058@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Annotating a local pointer variable, which will be assigned with the
kmalloc-family functions, with the `__cleanup(kfree)` attribute will
make the address of the local variable, rather than the address returned
by kmalloc, passed to kfree directly and lead to a crash due to invalid
deallocation of stack address. According to other places in the repo,
the correct usage should be `__free(kfree)`. The code coincidentally
compiled because the parameter type `void *` of kfree is compatible with
the desired type `struct { ... } **`.

Fixes: a71475582ada ("crypto: ccp - reduce stack usage in ccp_run_aes_gcm_cmd")
Signed-off-by: Ella Ma <alansnape3058@gmail.com>
Acked-by: Tom Lendacky <thomas.lendacky@gmail.com>
---

Changes in v2:
- Update the subject prefix as suggested by Markus


I don't have the machine to actually test the changed place. So I tried
locally with a simple test module. The crash happens right when the
module is being loaded.

```C
#include <linux/init.h>
#include <linux/module.h>
MODULE_LICENSE("GPL");
static int __init custom_init(void) {
  printk(KERN_INFO "Crash reproduce for drivers/crypto/ccp/ccp-ops.c");
  int *p __cleanup(kfree) = kzalloc(sizeof(int), GFP_KERNEL);
  *p = 42;
  return 0;
}
static void __exit custom_exit(void) {}
module_init(custom_init);
module_exit(custom_exit);
```

BESIDES, scripts/checkpatch.pl reports a coding style issue originally
existing in the code, `sizeof *wa`, I fixed this together in this patch.

 drivers/crypto/ccp/ccp-ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index d78865d9d5f0..f80a92006666 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -642,7 +642,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		struct ccp_data dst;
 		struct ccp_data aad;
 		struct ccp_op op;
-	} *wa __cleanup(kfree) = kzalloc(sizeof *wa, GFP_KERNEL);
+	} *wa __free(kfree) = kzalloc(sizeof(*wa), GFP_KERNEL);
 	unsigned int dm_offset;
 	unsigned int authsize;
 	unsigned int jobid;
-- 
2.34.1

