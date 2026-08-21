Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86653451AA;
	Fri, 21 Aug 2026 09:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787306174; cv=none; b=EwEYNYxBs5WnjbhNxVOaxZLNm74AwN9QgmGdtk+ZlSITfEsIY1/LtHUaZIs1M2PTYEqwuirg40FOM2sX5tQt0HSP+V4RqFhnz58myrCTS/CiatG3eFzNJb679XdiSXlyDP++t796K2gtoTR6WAGDdllgbAeKzgAeZQUflt1KnIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787306174; c=relaxed/simple;
	bh=w8LA04LoIYEUcjE0gkBUX0d9RqKBEXPQzDdhkjqNxuM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ofep4/FlPNg0csxYKnaEfkeGSixQwXWnEgEIgHvSHPSoVi05HPwjL0EX4qxtq35miKqAXIhnxXj196xotiL69nRu8B8ytodHWeEQ/PKQLkf8qa+wBKKmns7RdVrcfO7zzYz+WwOiBaRNK10INy98HXxjvG2CbtbPms72nbO1JJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=FSQUVPcD; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="FSQUVPcD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MjJRCTzIuwOUuiLlMedmVuVLrxNVUmFbX7AcZgorUdg=; b=FSQUVPcDso9O6gJPcScetEBgCL
	aCqKwJDLAjpir2XsFmOZMVOsZuAgppYUZFaM/mQdSCtd9hrBSn3OcjR4X+r6qc9sNscC7gm+SbPa8
	+VYNqAk7+G+mSUKjrvHsQ1aQ2aPHN4E2MwGb/8FfNF2qn2VO4rnIMjvwDcjv+aAId5yEerD0rsMj0
	kw8oA2Su86DF/2b9YinNg+HFgS2MmLxCvGPmu28Y5y3T705v/p1A99EBYVDWU07oazULQhChpxsd1
	Xv686aTCEC2Viu4xzdlCtMPI9qHYl0NDUjydDXSRzPfDGuZWK//VV7IeiiCEiOR5KXB7J/Rl0yA61
	VdmGiE4Q==;
Received: from [151.115.150.205] (port=40286 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wxLyo-00000004Lg0-074k;
	Fri, 21 Aug 2026 11:56:05 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: arei.gonglei@huawei.com,
	herbert@gondor.apana.org.au,
	mst@redhat.com
Cc: davem@davemloft.net,
	jasowangio@gmail.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] crypto: virtio: validate akcipher completion length
Date: Fri, 21 Aug 2026 09:55:12 +0000
Message-ID: <20260821095511.3600564-2-Jeremy.Jean@oss.cyber.gouv.fr>
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

The device controls the used length returned for an akcipher request.
Subtracting the status byte without validating that length can underflow
dst_len, while accepting a payload larger than the submitted destination
can make sg_copy_from_buffer() read past the response buffer.

Reject malformed completion lengths before updating dst_len or copying the
response.

Fixes: a36bd0ad9fbf ("virtio-crypto: adjust dst_len at ops callback")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index d8d452cac391..886032abae80 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -69,6 +69,7 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
 	struct akcipher_request *akcipher_req =
 		container_of((void *)vc_akcipher_req, struct akcipher_request,
 			     __ctx);
+	unsigned int dst_len;
 	int error;
 
 	switch (vc_req->status) {
@@ -88,9 +89,19 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
 	}
 
 	/* actual length may be less than dst buffer */
-	akcipher_req->dst_len = len - sizeof(vc_req->status);
+	if (len < (int)sizeof(vc_req->status)) {
+		error = -EIO;
+		goto out;
+	}
+	dst_len = len - sizeof(vc_req->status);
+	if (dst_len > akcipher_req->dst_len) {
+		error = -EIO;
+		goto out;
+	}
+	akcipher_req->dst_len = dst_len;
 	sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
 			    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
+out:
 	virtio_crypto_akcipher_finalize_req(vc_akcipher_req, akcipher_req, error);
 }
 
-- 
2.47.3

