Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BA722E3E9
	for <linux-crypto@vger.kernel.org>; Sat, 30 Aug 2025 08:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756543170; cv=none; b=NjegjI3YjrgjzZ4/btIAYKqZXoFLboMEGU2ZeLywoal5pv/vVCNf01lhpOb2UVGJRN1LCwMZ6Fu/CypJhpNawYNOYWOZunx8RcAdAO4168WWWJWFATIgHjo+/PXqXGBAmlZvUA3soP4oaZ3Z01mvmuGVy/aLOTaO/eF9VfzAN1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756543170; c=relaxed/simple;
	bh=SSOMF6ycTaL97hAUJ7u9wEFowsTzywT1RUh3lbK9P60=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SVG7LhVt9QbqrIHOdqn6Xewzt3wZLZ35iiBA58+ZxNA/Kcq5M+ygROx2/7nr8OIKfTdq0SBAaJLt+e6Aiem9+R9qV8OUbfpfzbDaDM72kjEczeLJ3lyC1OEhJ7XBIdV47iwu/vLLFgRF4yaX1fpVlRGsgekaQ/q0V+4dDPTAdzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=eI3VbMOe; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="eI3VbMOe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VlGmKJCetyCs8gMrnICrlu1bBuO5VYcvqRyK1QyksvY=; b=eI3VbMOe3NnzBKvJCtVaqg8Cq+
	vDAkZou67Pb9a/Q3LgMLinpghh3TCRXPLxykvHSRYY2/E6RwYvNPZBOV2kAIAl/KJzWIoqYaQiXDu
	Wrd5LviLo6wq9o49dbfJ5ebMJE2TFAYTHL0XpjEVNGGHtg3rNEMOD9Xh12NhqEIWGIp/u3UGI+ev8
	9urxMoEFjUotVm25pD8ewSsUepAgl632ou4dSFGH6XDHY7QvcoJuFq17fgWKmlulHxr4DtbSzqpY5
	gp4DQingnvat+jWVlYt5gG8t1Jyg/OT/A20dumPHi4uMu2Ve/z793MZuBMcXUoCh4Okw9Ul0MA8fY
	poTZC3yw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usGrn-00173Q-1X;
	Sat, 30 Aug 2025 16:39:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:39:15 +0800
Date: Sat, 30 Aug 2025 16:39:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Longfang Liu <liulongfang@huawei.com>
Subject: [PATCH] crypto: hisilicon/sec2 - Fix false-positive warning of
 uninitialised qp_ctx
Message-ID: <aLK4s1jSG1ulgKvF@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Fix the false-positive warning of qp_ctx being unitialised in
sec_request_init.  The value of ctx_q_num defaults to 2 and is
guaranteed to be non-zero.

Thus qp_ctx is always initialised.  However, the compiler is
not aware of this constraint on ctx_q_num.  Restructure the loop
so that it is obvious to the compiler that ctx_q_num cannot be
zero.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index d044ded0f290..31590d01139a 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1944,14 +1944,12 @@ static void sec_request_uninit(struct sec_req *req)
 static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
 {
 	struct sec_qp_ctx *qp_ctx;
-	int i;
+	int i = 0;
 
-	for (i = 0; i < ctx->sec->ctx_q_num; i++) {
+	do {
 		qp_ctx = &ctx->qp_ctx[i];
 		req->req_id = sec_alloc_req_id(req, qp_ctx);
-		if (req->req_id >= 0)
-			break;
-	}
+	} while (req->req_id < 0 && ++i < ctx->sec->ctx_q_num);
 
 	req->qp_ctx = qp_ctx;
 	req->backlog = &qp_ctx->backlog;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
