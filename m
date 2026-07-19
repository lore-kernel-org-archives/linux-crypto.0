Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9969935975
	for <linux-crypto@vger.kernel.org>; Sun, 19 Jul 2026 17:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784481227; cv=none; b=smPTc6LXR1PG6/rKL6brQtQtfqZVdkQbT3yyGKR31ytvnx9z7SVNk8W5+WzeOBHN57l4ZYis44uTOJtKP/dOhqVk9WCdKRI7p+lR1vObt8dZbtPh3XsciPoGIA3vX8nWEOw32tJXcIETkTP8yZEPAa9ZKf//UXfi/nmFhaL3W+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784481227; c=relaxed/simple;
	bh=M7JEcQc0lGY4ddQ+dXg23PH5fLWai6Fcr0TXCqS40jg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=l0Scwug7ki9TwKgf76kN8VOrewPkacD2JWfX6ChXLvraRqkPZCy/7n7pqwhZOm/aupyEW0l3WSCRzdgNY3UF3WuAX1ceAB72TZOedqZTPwdWn6A4G6gOJyhutnDsZhACl4wBQ2Oax+dLfEGO70zIrz5pz8ePbzz08WGG6TFKptI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WYOWLB6c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WYOWLB6c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784481224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yu0dQOLvZl9IuAMVGAh5tBcgwfM8NHvFBjW1GLNlV7o=;
	b=WYOWLB6cxRRQU0Kmpdd3O1G/TTmC/MwHileT3fJlI+VyfAYZc8OzPky9iRa0tMO/siGH6a
	pOrcOTe1urATWIKqmLPYLcdjkkEPpQTeAdTYVQoB5ui2tAXrXzsg+UY2LGX1HJJ7r2gbVy
	kDuY+05QeFBqAmtTH10UJDd9fFwuwJ4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-UveSTTLAPnWtl7DmNh2v3Q-1; Sun,
 19 Jul 2026 13:13:40 -0400
X-MC-Unique: UveSTTLAPnWtl7DmNh2v3Q-1
X-Mimecast-MFC-AGG-ID: UveSTTLAPnWtl7DmNh2v3Q_1784481219
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA8D4180123E;
	Sun, 19 Jul 2026 17:13:38 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.44.24.2])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 24159195608C;
	Sun, 19 Jul 2026 17:13:34 +0000 (UTC)
From: Vladislav Dronov <vdronov@redhat.com>
To: Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>
Cc: linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	vdronov@redhat.com
Subject: [PATCH] crypto: tegra - fix rctx->cryptlen in tegra_gcm_do_one_req()
Date: Sun, 19 Jul 2026 19:13:02 +0200
Message-ID: <20260719171302.15078-1-vdronov@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Perform rctx->cryptlen calculation in tegra_gcm_do_one_req() the same way
it is done in tegra_ccm_crypt_init(). The current formulae may lead to a
crash if a caller does not call tegra_gcm_setauthsize() and so ctx->authsize
remains zero. Then a decrypt operation with incorrect rctx->cryptlen will
lead to a write beyound rctx->dst_sg buffer.

Signed-off-by: Vladislav Dronov <vdronov@redhat.com>
---
 drivers/crypto/tegra/tegra-se-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 9094c03e991f..920864751ac7 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1290,7 +1290,7 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	if (rctx->encrypt)
 		rctx->cryptlen = req->cryptlen;
 	else
-		rctx->cryptlen = req->cryptlen - ctx->authsize;
+		rctx->cryptlen = req->cryptlen - rctx->authsize;
 
 	memcpy(rctx->iv, req->iv, GCM_AES_IV_SIZE);
 	rctx->iv[3] = (1 << 24);
-- 
2.55.0

