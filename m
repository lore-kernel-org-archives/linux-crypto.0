Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BAB1CA98
	for <linux-crypto@vger.kernel.org>; Thu, 21 Mar 2024 12:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711024569; cv=none; b=Lt27XJ0nnzFao5Rj7Q6LHY2eOQQfyORBMUQrRM5MHvRSx8Rw2r0h/GFpjWpbLjrxFbJxqIN0zyGWYi6KKzoMtNImql++CIjir6D3PWXsy5hvnYRYGvJpLFwQM/d3RYzGIQSQZWnc9dNWUay2N77R4mUAO8MIeHOsDapQ+DlQU00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711024569; c=relaxed/simple;
	bh=HkFGJqDS/d8bV5SUCLpt6uNhTsS8UzdKXxqDY2XYM00=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SMRmD2VVRIn7MhfGCIy92dSPPBs0mG6go3D6emhak+IYNGksUtQi9P1qxJhvK8mrahgEkmSTBas04ukRq8nYLUqXNsBqYNEp7UWohlna6aNKR7yxhmMbzCwEGrVCZy8kyG52avjFa++rCgRxIX+T7b1kEXKMgJ047rIGgoyQIVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4V0lHP3q8Vz1h3M3;
	Thu, 21 Mar 2024 20:33:21 +0800 (CST)
Received: from dggpemm500024.china.huawei.com (unknown [7.185.36.203])
	by mail.maildlp.com (Postfix) with ESMTPS id B11451A0172;
	Thu, 21 Mar 2024 20:35:55 +0800 (CST)
Received: from huawei.com (10.67.174.60) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Thu, 21 Mar
 2024 20:35:55 +0800
From: GUO Zihua <guozihua@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: algif: Fix typing of arguments of af_alg_wait_for_data
Date: Thu, 21 Mar 2024 12:32:17 +0000
Message-ID: <20240321123217.2578417-1-guozihua@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500024.china.huawei.com (7.185.36.203)

For af_alg_wait_for_data, the following checkpatch warning is triggered:

WARNING:UNSPECIFIED_INT: Prefer 'unsigned int' to bare use of 'unsigned'

Fix this by chaning unsigned to unsigned int. For argument flags, all
the callers are passing in an int, so make it int as well.

Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when ctx->more is zero")
Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 crypto/af_alg.c         | 2 +-
 include/crypto/if_alg.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 68cc9290cabe..4da990160fe9 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -860,7 +860,7 @@ EXPORT_SYMBOL_GPL(af_alg_wmem_wakeup);
  * @min: Set to minimum request size if partial requests are allowed.
  * Return: 0 when writable memory is available, < 0 upon error
  */
-int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min)
+int af_alg_wait_for_data(struct sock *sk, int flags, unsigned int min)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct alg_sock *ask = alg_sk(sk);
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 78ecaf5db04c..63b1c2852237 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -231,7 +231,7 @@ unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset);
 void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 		      size_t dst_offset);
 void af_alg_wmem_wakeup(struct sock *sk);
-int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min);
+int af_alg_wait_for_data(struct sock *sk, int flags, unsigned int min);
 int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		   unsigned int ivsize);
 void af_alg_free_resources(struct af_alg_async_req *areq);
-- 
2.34.1

