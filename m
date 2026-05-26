Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16123AEF53;
	Tue, 26 May 2026 16:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779811641; cv=none; b=op6dkVk+r3+FcS5XxhgQM8C9ihnLk0IVUUyqQKh3hwOnY370+coFawgJbO4jWGoaCsyPpgh0tb5a4a1Yl5AglZpuXOYelaviZKO+Mrlzn0ALrGkhpz5YHEeUi9do0sEslNN3Q/MopaGY2OuW7CgGXAMUguO5LGTfB7uclP4Qb2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779811641; c=relaxed/simple;
	bh=N6lJqeX8CDrEKidtY57QoTX7ewnPGVO8jWwgHJQvsv4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mubFKNBosF+ZLmVdfPydlPztp0U1rjSBfG9QJFfG/AUfQ/YUc2cj8FEwUVQ44un9uhbnKA1UU1KT0FKtktnPzc+k5OoTlcNzDa1dyqhcsHrR6S3s0FGgZj3uZ+BzPGhRfQtNWDqaVkiD7dpQkBBa6tFr1ad1RnmeH3R9tXR9yJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowABHk8YvxRVquRJ8EQ--.8084S2;
	Wed, 27 May 2026 00:07:11 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Ayush Sawal <ayush.sawal@chelsio.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: chelsio: fix inflight counter leak in chcr_aead_op()
Date: Tue, 26 May 2026 16:06:55 +0000
Message-Id: <20260526160655.2298525-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABHk8YvxRVquRJ8EQ--.8084S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw18Gry5ZF17Kry5GFWUtwb_yoWkZwb_G3
	47XrZ2q3yUtFW0y3yqy3yxZF9I9asxuF97GrnrKr15ta48Zr43Ww4fArnxJrWUJr48WFn8
	KwsxZaySyr18ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbcAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
	1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUr2-eDUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwkTA2oVtusgVAAAsI

chcr_aead_op() increments cdev->inflight via atomic_inc() before
submitting the AEAD operation. If the operation fails after the
increment (e.g., chcr_start_aead() returns an error), the function
returns without decrementing cdev->inflight. This leaks a reference
on the inflight counter, preventing proper teardown sequencing.

Add atomic_dec(&cdev->inflight) on the error path to balance the
counter.

Fixes: d91a3159e8d9 ("Crypto/chcr: fix gcm-aes and rfc4106-gcm failed tests")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/chelsio/chcr_algo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index eece1ac1085a..14a708defcd4 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -3636,6 +3636,7 @@ static int chcr_aead_op(struct aead_request *req,
 	    crypto_ipsec_check_assoclen(req->assoclen) != 0) {
 		pr_err("RFC4106: Invalid value of assoclen %d\n",
 		       req->assoclen);
+		chcr_dec_wrcount(cdev);
 		return -EINVAL;
 	}
 
-- 
2.34.1

