Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED943AFCF3
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 09:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354251; cv=none; b=QZHL8UNzBMEFjZz4386+ITyZCHjsbRginFfXt57tp8oku+xaCyINQ/PVFTLYHh0duJLFocUA75hWOCNtCHH/+ZpZZx/4FPsrBPsK4hC1gtlVQ+taEArRBKzGuBOvmQihtaHMpHyX3bcZSgs5x44UPvBwOHBzIWrzAv6W/dca000=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354251; c=relaxed/simple;
	bh=ll7c2R5VX3v6+Fl2r+qzo4RuiBEEIU3wp8x51vbCOds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyhFVWiu7y29Lg7XAPW1VBlHUuRtlBXCNH1bNxOL/HTD7CulprkCsfEPkyUQ59g59wr1UUMRBlhiB9osOt5/9gX+lLUpqKmOD2X22JBLmc3kQ375dP7A766PyzcGqip/6t3x4e/6BW9p19Fo6haGhswXuOPQvIR+znZdi64bOfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JwszL6pq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JwszL6pq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786354248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+uzNBxCm8TygHEsuvoTt/jMmagg8F1gKPzJZMx41fv8=;
	b=JwszL6pqTtJif6M3QKJnF+nwgFpT8cbCqPES4i/9Mwnmp/OWd0iq4WwL1jPUjd5QydRCDx
	FJlRWomhY6HPV8XCAaRDJL3Mg4BIYWy5de/fcJiRaz7KJ2tCmzIIfNdhYg6y/Dwh4yHlv9
	clfIqjF87cexpntMB8/peguFIKBtnvs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-aLkbJ_1bMdePKXMMNg6SYw-1; Mon,
 10 Aug 2026 05:30:42 -0400
X-MC-Unique: aLkbJ_1bMdePKXMMNg6SYw-1
X-Mimecast-MFC-AGG-ID: aLkbJ_1bMdePKXMMNg6SYw_1786354241
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68E1B19560B3;
	Mon, 10 Aug 2026 09:30:41 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7779A3001DAF;
	Mon, 10 Aug 2026 09:30:38 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>,
	qat-linux@intel.com
Subject: [PATCH v5 07/10] crypto: qat - zeroize crypto_aes_ctx with __cleanup(aes_zeroize_ctx)
Date: Mon, 10 Aug 2026 11:30:02 +0200
Message-ID: <20260810093009.608090-8-thuth@redhat.com>
In-Reply-To: <20260810093009.608090-1-thuth@redhat.com>
References: <20260810093009.608090-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

A recent patch by Giovanni Cabiddu already added a memzero_explicit()
for the crypto_aes_ctx in the qat_alg_xts_reverse_key() function,
but since we introduced __cleanup(aes_zeroize_ctx) markers in previous
commits in many spots of the code already, let's use it here now, too,
to have the same code pattern everywhere.

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

