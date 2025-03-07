Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A9D18DB39
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 03:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741318584; cv=none; b=c8FYPV+mlRbEamu5WJewZXM/kStubLEeQkCxCTnw4Guvl+Zs3JLckLsRdZA0AZYx4v0RZ1K09BvvwoOFOqWDEfNEk+/Sa4Fi3SmhaCGrsTIXJe58bHG8GK3TmlACrvjOA6Q9kzF9Gcka/D2gEfEwPt1Gt3IP8KGWAGHcAXWAu/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741318584; c=relaxed/simple;
	bh=gdL2ArBVevCXmGMqiO5APEwhZ/abTfhpBGJYi+BlKJo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=aFsLcpLlESlLme6+6XGeE/ZW99BPkb/RvG/WmplUSxAqqoOdjqOP8vnBQ4YmQppzFL1C+/dpu9ZXrOZxaq/m32DKjvFNJCKuNRcofMrnNlLWhvhzmmZfr/RIexHbeOT7tYZF+yhXVvSigdvo8BZCZ2CTc2H8+DvVwGXWmS34M+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cpoWMNgA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cpoWMNgA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xns+PWxbnEhDBmwZlhIQgXB6vopXZPX1yTZkP08OoDQ=; b=cpoWMNgAMQGCPE6ON5zfTI94iC
	oTxHdXJjLu36+xnfcIBPMmCPGNRONLiF7fIgrgE6ylgTfuveHlQOrWlr4kmvtV41F7QLhVMUUytKj
	fyiQsI3hwoOxzt37WN2L2fdqrKTkQNBJIlyhZEtPFFV8ABGjTztFWktuwQ5mUhve2GWaOJt1Zix2f
	Q+UXu6UGaLTCydWppMJ2qxZNu44Cc2HV4AaA5BoC1PNsEPh9dJk7cUhteoQyliYNCqWYSj3U9q7kO
	gdsGNjFfpZBqMg3J+tY4uxc6N9cnIJLg+m2g+eAcMTahzLBBV+jAUNHdQNl9mRLj4FQf7+Bt/pj2A
	T3r8p+8Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqOVX-004UaU-0J;
	Fri, 07 Mar 2025 11:36:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Mar 2025 11:36:19 +0800
Date: Fri, 07 Mar 2025 11:36:19 +0800
Message-Id: <18a6df64615a10be64c3c902f8b1f36e472548d7.1741318360.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741318360.git.herbert@gondor.apana.org.au>
References: <cover.1741318360.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 2/3] crypto: scatterwalk - Add memcpy_sglist
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add memcpy_sglist which copies one SG list to another.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scatterwalk.c         | 27 +++++++++++++++++++++++++++
 include/crypto/scatterwalk.h |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 20a28c6d94da..8225801488d5 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -86,6 +86,33 @@ void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
 }
 EXPORT_SYMBOL_GPL(memcpy_to_sglist);
 
+void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
+		   unsigned int nbytes)
+{
+	struct scatter_walk swalk;
+	struct scatter_walk dwalk;
+
+	if (unlikely(nbytes == 0)) /* in case sg == NULL */
+		return;
+
+	scatterwalk_start(&swalk, src);
+	scatterwalk_start(&dwalk, dst);
+
+	do {
+		unsigned int slen, dlen;
+		unsigned int len;
+
+		slen = scatterwalk_next(&swalk, nbytes);
+		dlen = scatterwalk_next(&dwalk, nbytes);
+		len = min(slen, dlen);
+		memcpy(dwalk.addr, swalk.addr, len);
+		scatterwalk_done_dst(&dwalk, len);
+		scatterwalk_done_src(&swalk, len);
+		nbytes -= len;
+	} while (nbytes);
+}
+EXPORT_SYMBOL_GPL(memcpy_sglist);
+
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 				     struct scatterlist *src,
 				     unsigned int len)
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 791100054f7c..533e52dd7e0f 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -210,6 +210,9 @@ void memcpy_from_sglist(void *buf, struct scatterlist *sg,
 void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
 		      const void *buf, unsigned int nbytes);
 
+void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
+		   unsigned int nbytes);
+
 /* In new code, please use memcpy_{from,to}_sglist() directly instead. */
 static inline void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 					    unsigned int start,
-- 
2.39.5

