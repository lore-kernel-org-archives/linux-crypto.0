Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468A43A7F50
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 07:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086460; cv=none; b=qwoCP+mY0nit8iuS1osfvsGHHcA0jHOGOQmdwVMj3PBWsI7DCKhawiWdys3vjyDiJ3giAOQf+rqrT04CamVR/z24nK5JstElUeFW5rVdHdJ2NvF6qcnyiiFdT90MnR3cAazESCwph7InGnQUctsl0HFk7vgTNSFLWYpSOSg8FWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086460; c=relaxed/simple;
	bh=sgrWOcBFo9Sd2WuA0nVAH1BFjCA3yxoLh5SvhbCkwfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jk2fHujywdXUxRFZjRrZyfJyajAuNFSV3Un41wCgd9NY/is9jqFD9Rv1ESRQ+CADqIfcRGwSacj58Iwq3Qvzb9MWtEtRPIkO/UH974HQU2U9knGvUGXKhKSJto9PaMM//aTTTh01j6fo/g3D8ihjukhOcx4MmRx+mzaEADnZKn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f3RmJRQS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f3RmJRQS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786086458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpzU2gD6nS7CuMmMhQxgVG5WsJfE9oTaObIb5LgkYdE=;
	b=f3RmJRQSLOMAtOyowkETLPMgrDk0z4YUXiiJuXiS9L7lr3I5YqNIM/XUAND+HqOURGBK9E
	svdQ4l5hBu+nfJRZN4Gg3nLTpOocnWy3wVmB1mzoPSqfM18E3Yo97h5g1KQMXoB7G8e4F0
	uWNtaUDOl/UZi4VTUQGc3XqchNAfG2k=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-537-XRSRuJ3XPsakdX1MPplkiQ-1; Fri,
 07 Aug 2026 03:07:34 -0400
X-MC-Unique: XRSRuJ3XPsakdX1MPplkiQ-1
X-Mimecast-MFC-AGG-ID: XRSRuJ3XPsakdX1MPplkiQ_1786086453
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C9451956057;
	Fri,  7 Aug 2026 07:07:33 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C12A21956094;
	Fri,  7 Aug 2026 07:07:30 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH v4 08/10] crypto: qat - zeroize crypto_aes_ctx with __cleanup(aes_zeroize_ctx)
Date: Fri,  7 Aug 2026 09:06:35 +0200
Message-ID: <20260807070651.228713-9-thuth@redhat.com>
In-Reply-To: <20260807070651.228713-1-thuth@redhat.com>
References: <20260807070651.228713-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

A recent patch by Giovanni Cabiddu already added a memzero_explicit()
for the crypto_aes_ctx in the qat_alg_xts_reverse_key() function,
but since we introduced __cleanup(aes_zeroize_ctx) markers in previous
commits in many spots of the code already, let's use it here now, too,
to have the same code pattern everywhere.

Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/intel/qat/qat_common/qat_algs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index 91663805d9e60..cb669fb661625 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -388,7 +388,7 @@ static void qat_alg_skcipher_init_enc(struct qat_alg_skcipher_ctx *ctx,
 static void qat_alg_xts_reverse_key(const u8 *key_forward, unsigned int keylen,
 				    u8 *key_reverse)
 {
-	struct crypto_aes_ctx aes_expanded;
+	struct crypto_aes_ctx aes_expanded __cleanup(aes_zeroize_ctx);
 	int nrounds;
 	u8 *key;
 
@@ -405,7 +405,6 @@ static void qat_alg_xts_reverse_key(const u8 *key_forward, unsigned int keylen,
 		memcpy(key_reverse + AES_BLOCK_SIZE, key - AES_BLOCK_SIZE,
 		       AES_BLOCK_SIZE);
 	}
-	memzero_explicit(&aes_expanded, sizeof(aes_expanded));
 }
 
 static void qat_alg_skcipher_init_dec(struct qat_alg_skcipher_ctx *ctx,
-- 
2.55.0

