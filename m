Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5E33A75A8;
	Sat, 15 Aug 2026 10:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786788613; cv=none; b=OH4Pn96jWDJVcSoRiqFWWqbo4Xi0hHrrMjrPGuqu/k5rsY4kC3ZwTOy9YnwSpuL7HnnZVFOJ6Efz2ljjhUGragzXidpEH85mV8PDAoxzogr1YSalzPgcdFIwWbd7X9CanvddGxql4a+1rqBfKAxwgVqNss6xB2rR0xLX1ZNvmls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786788613; c=relaxed/simple;
	bh=jhBWx1Q+I0qpSPLwHw7iL0BOzOFVKp3M8DWaSp5EXGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pCAAk2/QaAXz1Rx4Hn7m31+hNDJqywynm4vYC0NwUVJoHGTTK55BKVPxDk3srAoHeu0vrfHQ1hxEmilotByACdei71TVpnYTA+Yzugn2guhTfbv0jgGaVjROXBMGkQAM9lpFLhYfjWB9xQkNJsi/avMfV8jxN7hg+dknoXF/G9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=NfpBeG51; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="NfpBeG51"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=WxR4zmk0T8m4XwxC8juzMpTbBVpYMpstNsQnAwgEmNg=; b=NfpBeG51wWZXIiHsZfmlinGHQr
	LU0jE5YgLqqaCRlQkBgaOC9raVP0o0eoNaDq+IV0D/VF8ZDNfkiF0CXkU6e78bKTV8yaaVXBNyiHP
	IDCW8abYzP0bqE4X++5SwYnEsC7xgpbLyaLK4oFvPZBxZCdpAaXHtIu9UwQYkX/mXLfFIIakLNR8A
	JY20FpLx7ix+muzKY/dcOZsipYStyYo1EyzsbySwNALBoS2uoLaknp3rUOp//Txld2J/6Eot6JQ/C
	LngXJlkO2AqcRCvG0SP7QrAH9yH41fWx9V/fdpAoWk9RDgxlnSg0Q6+I98Zgy7JDuCmw09GOsedlq
	3WsEpMeQ==;
Received: from [151.115.150.205] (port=44718 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wvBL9-0000000EEdR-1Kw6;
	Sat, 15 Aug 2026 12:10:07 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] crypto: acomp: allocate async request context when cloning
Date: Sat, 15 Aug 2026 10:09:18 +0000
Message-ID: <20260815100918.4064616-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

ACOMP_REQUEST_ON_STACK() reserves only enough storage for the
synchronous fallback. When an async implementation is selected, callers
clone that stack request before retrying, but acomp_request_clone()
currently copies only the stack-sized object. The clone therefore has no
storage for the async provider request context, and providers such as QAT
write past the allocation through acomp_request_ctx(). KASAN does report
a slab OOB write.

Allocate a zeroed clone large enough for the runtime acomp request size,
copy only the bytes present in the source object, and preserve the
existing fallback-on-allocation-failure behavior. Use the runtime reqsize
because an implementation may adjust it during tfm initialization.

Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 crypto/acompress.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 032de704eb2c..4de1a2ad577f 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -559,12 +559,22 @@ EXPORT_SYMBOL_GPL(acomp_walk_virt);
 struct acomp_req *acomp_request_clone(struct acomp_req *req,
 				      size_t total, gfp_t gfp)
 {
+	struct crypto_tfm *tfm = req->base.tfm;
 	struct acomp_req *nreq;
+	size_t len;
 
-	nreq = container_of(crypto_request_clone(&req->base, total, gfp),
-			    struct acomp_req, base);
-	if (nreq == req)
+	len = sizeof(*req) +
+	      crypto_acomp_reqsize(crypto_acomp_reqtfm(req));
+	len = ALIGN(len, CRYPTO_MINALIGN);
+
+	nreq = kzalloc(len, gfp);
+	if (!nreq) {
+		req->base.tfm = tfm->fb;
 		return req;
+	}
+
+	memcpy(nreq, req, sizeof(*req));
+	nreq->base.flags &= ~CRYPTO_TFM_REQ_ON_STACK;
 
 	if (req->src == &req->chain.ssg)
 		nreq->src = &nreq->chain.ssg;
-- 
2.47.3
