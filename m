Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C453410D1B;
	Wed,  3 Jun 2026 08:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780474534; cv=none; b=PORcXZdIZRG1LxM8zO1FuVCKXHYT1Ugg3gQy8PRxv4+55BbU+gRt8Hicw2KLf79HbcR3BSD2vJvaywiTjw9QMDH/RQnGSEKsb8Zf8JvBlvcgmgo7IpiFHp0ywUZtwpdgBGyjbTZSONBfiSP95gc1RWxlcMH6JnWXDkQdL59G2Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780474534; c=relaxed/simple;
	bh=mHb5HAmB5QuGq3DeLSglVkG4VRqKnwuYkrE+myRcHaU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Gl2OyUGl7PNgvT5w+cS2y6reaVNCHc3yCjRZauhQlwOEpKrdnaGo8sGoR4GvjQNmJElMYt8UpUNA7lDYOYJ5bN1oSD2qCAzRJ/kUxYxtx5VeW0P6/kJsQgu8nx06hvJxODdNuRSsvZkhg2GNN5rp54zzwEMk2/ejKT9E8NC+Jr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowABXO+KX4h9qRgB7Ew--.18774S2;
	Wed, 03 Jun 2026 16:15:19 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] crypto: fix refcount leak in crypto_register_alg()
Date: Wed,  3 Jun 2026 08:15:09 +0000
Message-Id: <20260603081509.3716161-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABXO+KX4h9qRgB7Ew--.18774S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww4UZF1ftF4DXFW7Jw1DKFg_yoW8Jw4Dpw
	4Fk3yqkFZ8Gry8KFWkK3WfJryUGrW3ur13Ar40ka1jy3ZxXwsYq3ySy345JF12kFZ5JF1U
	JrWvkF13ZF1qyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjiL05
	UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCREHA2ofveWSBAAAsn

When crypto_check_alg() succeeds it sets the algorithm's refcount
to 1. In crypto_register_alg(), if the algorithm type requires
duplication (CRYPTO_ALG_DUP_FIRST), the code attempts a kmemdup of
the algorithm descriptor. If that allocation fails the function
returns -ENOMEM without calling crypto_alg_put() to release the
reference obtained by crypto_check_alg(), resulting in a refcount
leak.

Fix this by adding the missing crypto_alg_put() before the early
return, matching the handling of the other error paths in the
function.

Cc: stable@vger.kernel.org
Fixes: f1440a90465b ("crypto: api - Add support for duplicating algorithms before registration")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
Changes in v2:
- Clarify the refcount lifecycle.
- Fix code error.
---
 crypto/algapi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index b0e4b13131c3..260d03b328ec 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -446,9 +446,10 @@ int crypto_register_alg(struct crypto_alg *alg)
 		u8 *p = (u8 *)alg - algsize;
 
 		p = kmemdup(p, algsize + sizeof(*alg), GFP_KERNEL);
-		if (!p)
+		if (!p) {
 			crypto_alg_put(alg);
 			return -ENOMEM;
+		}
 
 		alg = (void *)(p + algsize);
 		alg->cra_destroy = crypto_free_alg;
-- 
2.34.1

