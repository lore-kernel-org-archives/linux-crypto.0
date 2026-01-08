Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45D726159E
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767886185; cv=none; b=jGtj6P2PUzubmkG4u5k8yFTA8F1J/2gnCrdEZwcBWy53qqhFv8QURwNG1dXII1WCDQJkIQHINd2HKe5utuxHCDmBjB8TiqPEbwTRyepkY6GCT7gh+hdL5UEFhDPG0IMu2Il//3RFncSCpQectrS8EDaT3wmlCenBQiciX6hkgkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767886185; c=relaxed/simple;
	bh=PZM7IniYMAo5kXWH+f83z5lk9V7whTGc+Zav90N+FIk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sieXtR/REq6ZUR9MiyNJiizFXMaomlWNNy/avu9FVqXA8PuX1U+p0fualj8yMQnslU1tSI0VqYoHARfOu4k3QaziIpcPgZsVtRdhjBpXdvGPbncp5RWwl+992SkUEKdWZPm8f1c+eO01uQdD9Atna/mq9sSTFq1/MLSmnPPJH/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OqkeDQS8; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OqkeDQS8"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-431048c4068so1238288f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Jan 2026 07:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767886182; x=1768490982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U5ChSEmLnLNsNK8tqFRJB97uYY8DzSAS4oYXQU5f5qU=;
        b=OqkeDQS87IrDcLH/x5BrJhwLxsoFwr2yVkUSZUfhJ6Lf6kc7C7EChORkbaWuyQXAIA
         jhiuRtfMdIGK13mVrJ1vqkyixeOe2nk30/orUPT4x19da6YWfJaFHNQVAu/eGaoJ0q7T
         pzWW/oe42fO/jGfq8Kdexjx+WhpMq+xfzejWB+6wm0nWz8fmHEaPTHEdNzNurNtmpCW8
         YD9cNLlnSCL9BZDaJi8dp+iGV177061GYXZPBIP5/xppT59089LsVieY73LX1g+6kf3Q
         viPG0lLH7gtxcGuEBnqICkgYEYBGMvk1HYkREmcuPuys3V/tM+UFWdw6+Cx+Wci1R3c9
         97NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767886182; x=1768490982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U5ChSEmLnLNsNK8tqFRJB97uYY8DzSAS4oYXQU5f5qU=;
        b=j31aFGZrszlyCkIP91eVYj4NQ5FYVFufV+KMMleBNPcbwNc+mBB97vPFJyR0YRBCAR
         LRsVE1cOIh3aCgdY36TnxmhAsY/NwT++dS5MMHIf6vJMrUR+vXpmxK70BcPA80De6YDw
         IPiCBIVPv/FhViqgnxBXtdghDB4FFlth+IpZ1qh0flPg3bpzs2YXthI4WhLPBLimfQj/
         sI4ZVywlyLwdjy50Ow/K9oKa9T9SzuZuwm395yheMRVDiE74kYqgBPJQR7wseaBtW9Hx
         milsJsBqUuiFbR4EmuiCKk/O/Zdw+m9TlEkgPPnMc8JkNbZy7CKy9uM4xoanYOK0fU8Q
         OJMA==
X-Gm-Message-State: AOJu0Yx+z6W9LFfUjxx70mcVs7CsVQNVla3o1CSWYgqIjgx5cWLiC36n
	oJEwXg71L3y3sRWQHB0eDdvQg+pnOwluvYue72jf+9tN8KXPLvyeXqhS
X-Gm-Gg: AY/fxX7vmQUhKD7p9+M4jKoVijr224JAI/to6MPsKRM7zJ/kRny+cx27gj55ekj+eF2
	HD+QpmBe+5NyixkGfIIe4rcCmTLlT1xkuiVw34nFuQY7l4BjAOMIbu4QkLSonshq/kWeDXs1u2S
	GwSW7SA/6x5auUWFaOPjKeC2hkpXBkRCK5mCFOqkKblbmVM3eDSYBhmAdl9ylhwvzSDZMaM4r29
	5Qe9/CjgMOg8nCLK8GpogQ4ygGTSuSUakbmFIZca3ohNd20fL7wrnCwkI+QyDuXgTgsQnTgi9/p
	DLxvhGPDcCu8rSlK9IRstcOyNGNTxf//CBgxitK077trQZ6TdPHrx/6HOeOjSHAx79e7kd6V5ba
	oSETV8rVfAc/j+nrzQchPXnUWkXrq0YdQBlLzYV2LT+/RcMwY467sBRFGF3NS5Ej9UWjBlqwwyk
	fbC6NXwsNKRjoM22KY8nbcTRCS4KA74BJCRAgk8rVVqjZ5sTWq64n/jS1DHG6AnJR4i6c=
X-Google-Smtp-Source: AGHT+IFsZpezcOX9qDzdQ9ZZpGTmZa+ip1VSoIaoagCftHX6xs0soMPXnQ33AN6ogpLNs/5iLLlIeA==
X-Received: by 2002:a05:6000:4012:b0:430:f736:7cc with SMTP id ffacd0b85a97d-432c362bf8emr7304857f8f.1.1767886181933;
        Thu, 08 Jan 2026 07:29:41 -0800 (PST)
Received: from ptb-02009389.paris.inria.fr (wifi-pro-82-106.paris.inria.fr. [128.93.82.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5fe67csm16730909f8f.40.2026.01.08.07.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 07:29:41 -0800 (PST)
From: Ella Ma <alansnape3058@gmail.com>
To: thomas.lendacky@amd.com,
	john.allen@amd.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	arnd@arndb.de
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	julia.lawall@inria.fr,
	Ella Ma <alansnape3058@gmail.com>
Subject: [PATCH] drivers/crypto/ccp/ccp-ops.c: Fix a crash due to incorrect cleanup usage of kfree
Date: Thu,  8 Jan 2026 16:29:06 +0100
Message-Id: <20260108152906.56497-1-alansnape3058@gmail.com>
X-Mailer: git-send-email 2.34.1
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
---

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

