Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE5B3DCD8A;
	Wed,  3 Jun 2026 02:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780454495; cv=none; b=RehEga8nyBdANP2fodSSeCuLjw0l0y5KmJar2G20J68XnfetJfMgaZmieDCRHx6GyOVbOxvwjC0f0bK4Lp2H/d4MpEAJDZmHSSo7x1YT/iqeTvzk03ncTLxgy9IhL8dyb+YEe2NuPxJTkPL0OA2c3iUQ0SlTubDLZd7UVi+geRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780454495; c=relaxed/simple;
	bh=PCySkr/C6paeckSidOEUtgSJXiOQrJPsD+7dN5WQFpQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q/oXo6EGb7dtfFhS9YMiMEEJ2E2f1BzeZQkh2nZhaUJAtLCjV2L/3Yk8td73P4rJ4xCBsBGFlOSX2iJcjtKlTjQKjRQCJlneQ4+ip1mMnXG++LCJVvWMFSX6OSR27tJR1OWjKrBn1huU4bIIcMy4CRofNVOfsechEVwNh/DAQIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowACXOdJZlB9q+Mt8AA--.10894S2;
	Wed, 03 Jun 2026 10:41:29 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto/algapi: fix refcount leak in crypto_register_alg()
Date: Wed,  3 Jun 2026 02:41:19 +0000
Message-Id: <20260603024119.3693829-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACXOdJZlB9q+Mt8AA--.10894S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr4UtFyDJw1Uuw18tFWfuFg_yoWDGrg_GF
	Z2grykuFy8ZFs3ur4kCFWUur17WFW7Jry3Gr4Iyr9Fya45JFZ8WanIqw1DZFn7A3y7Zw1U
	WwsrAry7JwnF9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4AFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJV
	W0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjiL05
	UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQ4HA2ofeUpT+AABsv

In crypto_register_alg(), if the algorithm registration fails after
a successful crypto_alg_get() on the template algorithm, the acquired
reference is never released. This can occur when the new algorithm is
not allowed to be registered due to a constraint check failure.

Fix the leak by adding a corresponding crypto_alg_put() call in the
error path before returning.

Cc: stable@vger.kernel.org
Fixes: f1440a90465b ("crypto: api - Add support for duplicating algorithms before registration")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 crypto/algapi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 37de377719ae..b0e4b13131c3 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -447,6 +447,7 @@ int crypto_register_alg(struct crypto_alg *alg)
 
 		p = kmemdup(p, algsize + sizeof(*alg), GFP_KERNEL);
 		if (!p)
+			crypto_alg_put(alg);
 			return -ENOMEM;
 
 		alg = (void *)(p + algsize);
-- 
2.34.1

