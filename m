Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE7023D297
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 10:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779790321; cv=none; b=BkqK6CTyH95SXMaSlczBNZ76e/35Sy7uGRBlNyIKL9BYk8+eOgtvAYQ2j7l+2eRxKItWRgTqP1Tl2jZc7yWFI1nLKrs9Le9iKweYM1sKQU2LruyY3IKRV14WuBLO8dJ/8V0KW9y6DY23ZQpVTowGJ9sO2xXECGrNbcOP+Jhldtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779790321; c=relaxed/simple;
	bh=5xjkngdWqDw1Hk6b7GUGO7seQD9FcSDoK7FryHpqYLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqAP0FOU0rdrgNcfhWQO4ginyyHMNQ3Sd2Katk/cU2977oIaB33HDmjcMAEWqnEYpTTcVvnb+itK/84L6mQ1883jBVWfomcOWlbd/CBqov8d2SWaGllQ0mTG4qBpC6crhResKdj8+SY/fOoaUpFymjTt/niu49v7bqF0VWoFlek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowABXdb_kcRVq5s8vAA--.21165S3;
	Tue, 26 May 2026 18:11:50 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	yuantan098@gmail.com,
	zcliangcn@gmail.com,
	bird@lzu.edu.cn,
	tr0jan@lzu.edu.cn,
	ngochuongbui67@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH crypto 1/1] crypto: chacha20poly1305: validate poly1305 template argument
Date: Tue, 26 May 2026 18:11:43 +0800
Message-ID: <e7a116d3474cd00e421393e0512ad11b151ca2f1.1779777598.git.ngochuongbui67@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1779777598.git.ngochuongbui67@gmail.com>
References: <cover.1779777598.git.ngochuongbui67@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowABXdb_kcRVq5s8vAA--.21165S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw15Xw1fJry5uFykAr15twb_yoW8KFyDpa
	y3C3sFqryfJrnakrWkK3yrZa4kJr4v9ay3GrWktw1xAr10qr1IqrWIkFyYvF15Ca48C3y5
	ZFZ0v3yq9w13GFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r43MxkIecxEwVCm
	-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQETCWoVV84EXwAAsn

From: Xiaonan Zhao <ngochuongbui67@gmail.com>

chachapoly_create() still accepts the compatibility poly1305 parameter
in the template name, but it assumes the second template argument is
always present and immediately passes it to strcmp().

When the argument is missing, crypto_attr_alg_name() returns an error
pointer. Check for that before comparing the name so malformed template
instantiations fail with an error instead of dereferencing the error
pointer in strcmp().

This matches the surrounding Crypto API template pattern where
crypto_attr_alg_name() results are validated before string-specific use.

Fixes: a298765e28ad ("crypto: chacha20poly1305 - Use lib/crypto poly1305")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Co-developed-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Xiaonan Zhao <ngochuongbui67@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 crypto/chacha20poly1305.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index b4b5a7198d84..27df9e1eb058 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -375,6 +375,7 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	struct aead_instance *inst;
 	struct chachapoly_instance_ctx *ctx;
 	struct skcipher_alg_common *chacha;
+	const char *poly_name;
 	int err;
 
 	if (ivsize > CHACHAPOLY_IV_SIZE)
@@ -396,9 +397,15 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 		goto err_free_inst;
 	chacha = crypto_spawn_skcipher_alg_common(&ctx->chacha);
 
+	poly_name = crypto_attr_alg_name(tb[2]);
+	if (IS_ERR(poly_name)) {
+		err = PTR_ERR(poly_name);
+		goto err_free_inst;
+	}
+
 	err = -EINVAL;
-	if (strcmp(crypto_attr_alg_name(tb[2]), "poly1305") &&
-	    strcmp(crypto_attr_alg_name(tb[2]), "poly1305-generic"))
+	if (strcmp(poly_name, "poly1305") &&
+	    strcmp(poly_name, "poly1305-generic"))
 		goto err_free_inst;
 	/* Need 16-byte IV size, including Initial Block Counter value */
 	if (chacha->ivsize != CHACHA_IV_SIZE)
-- 
2.47.3

