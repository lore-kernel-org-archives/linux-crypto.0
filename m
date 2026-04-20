Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.175.55.52])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48F0385524
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 08:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.175.55.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776675259; cv=none; b=d/nbyz0GoQfZEsvW6+zC9Vo/X15kjm9DAnZuhFaLUyscJIAtDRvnNVRWGgRNWcnHHU0DpTFsPla/ox9OifYGJ+D9+Hat984g98+ORD7kGkhXz6ozkHbh8J8wcdU4zlGL73fv1BjwSg/Y670d7xnD+5yvLJSQTuEFiFG/yk21lT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776675259; c=relaxed/simple;
	bh=Swgw4q88qDcxf3DIoAK8gIhu97tKwfOCxSwyCaMzaV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBmXbkDOIpXAoPFqu+wjzZxSJjRflZUgajEJi61sNWrW20nCBr1ukA2ZIV8JtUjRobxco4Odn6+SLfudO/OiqpSsEETf3M8/9l17v95VMfM2qD4vAJjG+GXS32QKg9GpERJxTgffcQAMpMF+ZodtAmKFHQ8fCNhvwEy1c1tHziE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=52.175.55.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowADXTv+l6eVp6jXWAA--.15504S3;
	Mon, 20 Apr 2026 16:53:59 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	ardb@kernel.org,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	z1652074432@gmail.com,
	kanolyc@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH 1/1] crypto: authencesn: reject short ahash digests during instance creation
Date: Mon, 20 Apr 2026 16:48:25 +0800
Message-ID: <cb1188757edab9b056961d4d2441be009ac73ce8.1775217403.git.kanolyc@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1775217403.git.kanolyc@gmail.com>
References: <cover.1775217403.git.kanolyc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowADXTv+l6eVp6jXWAA--.15504S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KF43ZF13GrWxXFyDJF17trb_yoW8uF47pa
	y3GFZrtrykJrW7CF1kJr4IqrW7Zr48JFy3JFZYkw1Yyr13uF1rtr12yFW2vF4UZrs5GFWq
	yFWqvryUZw1DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6c
	x26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEDCWnl6GEAMgAAs9

From: Yucheng Lu <kanolyc@gmail.com>

authencesn requires either a zero authsize or an authsize of at least
4 bytes because the ESN encrypt/decrypt paths always move 4 bytes of
high-order sequence number data at the end of the authenticated data.

While crypto_authenc_esn_setauthsize() already rejects explicit
non-zero authsizes in the range 1..3, crypto_authenc_esn_create()
still copied auth->digestsize into inst->alg.maxauthsize without
validating it.  The AEAD core then initialized the tfm's default
authsize from that value.

As a result, selecting an ahash with digest size 1..3, such as
cbcmac(cipher_null), exposed authencesn instances whose default
authsize was invalid even though setauthsize() would have rejected the
same value.  AF_ALG could then trigger the ESN tail handling with a
too-short tag and hit an out-of-bounds access.

Reject authencesn instances whose ahash digest size is in the invalid
non-zero range 1..3 so that no tfm can inherit an unsupported default
authsize.

Fixes: f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Yuhang Zheng <z1652074432@gmail.com>
Signed-off-by: Yucheng Lu <kanolyc@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 crypto/authencesn.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 542a978663b9..bf44f035f7f8 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -384,6 +384,11 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 		goto err_free_inst;
 	enc = crypto_spawn_skcipher_alg_common(&ctx->enc);
 
+	if (auth->digestsize > 0 && auth->digestsize < 4) {
+		err = -EINVAL;
+		goto err_free_inst;
+	}
+
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "authencesn(%s,%s)", auth_base->cra_name,
-- 
2.47.3

