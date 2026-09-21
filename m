Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43DE45D918;
	Mon, 21 Sep 2026 09:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981539; cv=none; b=CdkGsQjyKEVGe+A6JTDaJTMFMsmfTM1icoebRCm0SYfXTCPDZTpjzglDFrNQ488A07NuW22ziZ/YFNlQgbl1aBMTUTFfzymGJWDEpaezf8OIh1SLq/GV5cn0uI5OXcqDfKJCzentyYcgjA3HR1BT6eJ5q0MGJ8tKyESfAJSC0QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981539; c=relaxed/simple;
	bh=k/d8zfORAcwCBsAuMJFy4ksKNlX/UKiarPeAOYJr5mk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i5Y/PwqMGHkZPO8NuhBd6fWoTwFYcKZMvN1jmMcT96SVrOX0vc7SGuZK72nUkbrMW7PkyjX5TO2hafLHAE20NOsJqZrzULd4kvWvGkn3mmjvXbPDZTEDCKaNl84Hkpc2WzxvIIhArT1AFNCnybYbpTj+f77KU0anNd469RBdjbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=dlJX1tZJ; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dlJX1tZJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=tQ
	Ovg2zFYuOQQTjxwP84PyEIL0ExBuK9P0HjskQpJZA=; b=dlJX1tZJHeYUQkmsxa
	LaHZOuTfLOJaHI3wXqoVgEf9mvP/FYnBfQwLP65jhloF6TLSHrmTWGFKb7ZAxWPx
	/YjTsJHQPB8l5P+ILgwe5r5Bg0XvjWyO9t1/UxbKNSfyH+3jDFEWs2RtC6AElTaQ
	Wyz9qWl4UP0dC6EN2jgEKzlQk=
Received: from pc.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDXMcQ787BqwjgtAg--.3469S2;
	Mon, 21 Sep 2026 17:05:00 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Mike Snitzer <snitzer@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] crypto: essiv: avoid request access after subrequest
Date: Mon, 21 Sep 2026 17:04:57 +0800
Message-Id: <20260921090458.3364976-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDXMcQ787BqwjgtAg--.3469S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr45KFy5GF1UJF45Ary3XFb_yoW8XFyfpr
	ZYkF4vvrWkJFyqkan5XFs5Jw18Kr48Cr43ua95Zw4UZFn5Xr10vrW2vF1Yvr1UWFWkK3Wj
	9r4qv398Za12yrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0p__-BDUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BzSDWqw8zxsWQAA3T

essiv_aead_crypt() reads rctx->assoc after submitting the child AEAD
request. An asynchronous completion can run essiv_aead_done(), free the
association buffer, and complete the outer request before the submission
call returns. The later request-context access can therefore use freed
memory and trigger a second free.

Snapshot the association buffer pointer before submitting the child
request and use the local value for synchronous cleanup.

Fixes: be1eb7f78aa8 ("crypto: essiv - create wrapper template for ESSIV generation")

Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 crypto/essiv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index a47a3eab6935..5aea4584d5cb 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -189,6 +189,7 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 	int ivsize = crypto_aead_ivsize(tfm);
 	int ssize = req->assoclen - ivsize;
 	struct scatterlist *src = req->src;
+	void *assoc;
 	int err;
 
 	if (ssize < 0)
@@ -247,11 +248,12 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 				  essiv_aead_done, req);
 	aead_request_set_crypt(subreq, src, req->dst, req->cryptlen, req->iv);
 
+	assoc = rctx->assoc;
 	err = enc ? crypto_aead_encrypt(subreq) :
 		    crypto_aead_decrypt(subreq);
 
-	if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
-		kfree(rctx->assoc);
+	if (assoc && err != -EINPROGRESS && err != -EBUSY)
+		kfree(assoc);
 	return err;
 }
 
-- 
2.34.1

