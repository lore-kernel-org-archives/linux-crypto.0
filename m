Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794988621;
	b=O+eIXsklYZRdPi2JQ2pdIqnucuM3YgWxz+UWz31srTnhfUe0l6d7Tjrp/WFaEFXt0Plz
	 PdYO4kXv1DOQljhNYM7szBfH+NfkunAH87gf8Y/VWzpcf/solCUQ1ykjDiRe8m+uKAspn
	 +hixDiMtYDGVw1SvBvjJGt94DzeINoGVm/b+yj8pEvQ1SM86RMIQyVMCQAVSTgJSraAoL
	 r9pOUsInyKIGuGOqZtkBduaSx30HmgcpzF9Zb5Cgb48nznhk7wQODCdZOXuUt+5ly1FH2
	 zcUNl5jpMacEW4edcFTsNlBn+mApiifWtjcGxNZwvVnRe31rE/Hw55Yj4lVMJkvfr0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794988621;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-Originating-IP:X-CM-SenderInfo;
	bh=JK5tQhAchsUvGd3TkaYklyX4XMkYwKlBnGJVxVMlOcs=;
	b=ZKPxY3picFdQOxDOThBTKaVkheJjvFSdyyiSbjoBF0XhvZuxtXKDGEt0tmh9ijjibIOt
	 yglaDOWw9iCHYEElASER6OudS57V7030zXyigfJg1Ev94e+8ol5wb06Y1HpP0y84Iry7L
	 gCMajmP92iie3WPia/fjGv0toGcTG95vOtvWiARol023ElT4y9SA6baDua3OImdaTITuv
	 qR0w+bCNtxFsHHzn/PbJSTqcJXHZ7WkKG4q+v6XGEn8KvyCm8YUBTAB8zltYQPv4m5iGF
	 YbS1O/D98ubiG//JOVW70frFDXx0XnhlVoaaRBu+kYniGD0gmLt8yY3MCGf8DS6PuKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="O3XQgCR/";
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EC1606A325;
	Wed, 18 Nov 2026 07:56:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98EC1606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=O3XQgCR/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=JK
	5tQhAchsUvGd3TkaYklyX4XMkYwKlBnGJVxVMlOcs=; b=O3XQgCR/9zuFpMnYxq
	iwNPiwD7f5x3eBTgOgS3O0nW3nJym5kEvZvmWGSaHHkwioPVJOFK5wO18QCwpB4J
	aqOnIEyj9WRnWb8EpBKdOtzT5qzFUI6fZRWCL5l7dE2d5ojaC61ZAWvjKorC365G
	EoPRdkp0QlctsFVQ2hPZyHeXA=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgD3P6M1Wv1qx8alGg--.56103S4;
	Wed, 18 Nov 2026 15:56:44 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: schalla@marvell.com,
	bbhushan2@marvell.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 2/3] crypto: marvell/cesa - Fix padding cleanup on hash setup errors
Date: Wed, 18 Nov 2026 15:56:35 +0800
Message-Id: <20261118075636.2152451-3-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261118075636.2152451-1-haoxiang_li2024@163.com>
References: <20261118075636.2152451-1-haoxiang_li2024@163.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgD3P6M1Wv1qx8alGg--.56103S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrZrW8tr4Dtr4rWF48ArW7XFb_yoWkZrbEkr
	13Wr92qryFvr4kXr1Fk393Jr43tasaqF98WrW2qryfJa47Jan0gF12gFs8ZF1rurW7tr4D
	GF45tr13J34FvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_2Nt7UUUUU==
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbC7Ry-Lmr9WjzAHAAA3N

The hash DMA initialization error path clears the TDMA chain before
calling mv_cesa_ahash_last_cleanup(). The empty chain makes the request
appear to be a non-DMA request, so padding is not released. This also
happens if the first TDMA descriptor allocation fails after padding has
been allocated.

Call the DMA-specific padding cleanup helper directly, since this is
already known to be the DMA initialization path.

Fixes: 53da740fed30 ("crypto: marvell - Move tdma chain out of mv_cesa_tdma_req and remove it")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 drivers/crypto/marvell/cesa/hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 35f5937b2f8b..f698d3df535b 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -751,7 +751,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	mv_cesa_ahash_dma_cleanup(req);
 
 err:
-	mv_cesa_ahash_last_cleanup(req);
+	mv_cesa_ahash_dma_last_cleanup(req);
 
 	return ret;
 }
-- 
2.25.1

