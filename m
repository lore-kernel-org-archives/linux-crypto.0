Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7C03B27DE
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 09:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354243; cv=none; b=PIfAh8RxoyPCNjqdUecNM3GvQysCK/gFF744WScvHWjk3VuBrwHM4xllXjIOcPdFQPQ7O/PwB1h0jL6gBKWNqThrUUYxotv8ZT30xc2z82/O8lWNPueayaHrhTUgJq/uRCBeC5/F3nWVXHhaH1ebwarkjTJpMDlDtL4POkZ2kL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354243; c=relaxed/simple;
	bh=b5aZNIDCHkvfoWtjbjEcQ7aD9yQG5oyRD+0JfQ4XMl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J12ANvW5jGRJwZf2yPsSCa6x2IYHmDui+Qe8nVeucDm9yN4w62bZAzStAKYYIMlLEM1nam1VbBQfQHe/QqqZ4Oe718Qc+FqrboBDZNISCCfY7ZdMo+gNfSWd0FB3AOTaUZjbUEL/YLyVot7xJ94otYty62qaGix+StUGE2yFymQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EwCgV+5P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EwCgV+5P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786354240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vqj916x7IWEPwY8/O5oc6WAr80znZJ+nk/7CTdbfDAQ=;
	b=EwCgV+5PY3ZwfQTrsW/KT4lDZOsotozGDsysEDswH0HRxuR6TzAtGx3ppJYqEMDKRcTZHn
	CodS28lBTXSaBiU0P3+n5kMHtBwISzWbCVJtBcQ3zWsOUtYOSzIyvYdoTunu3gExKXyNUr
	74VHydCghH0LRtuvqnEcvk5PmKrlV4Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-357-1bpIgU8CMXGcJ8ZkQtFrtw-1; Mon,
 10 Aug 2026 05:30:35 -0400
X-MC-Unique: 1bpIgU8CMXGcJ8ZkQtFrtw-1
X-Mimecast-MFC-AGG-ID: 1bpIgU8CMXGcJ8ZkQtFrtw_1786354233
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 715B71800115;
	Mon, 10 Aug 2026 09:30:33 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 13DE33001D38;
	Mon, 10 Aug 2026 09:30:29 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@armlinux.org.uk>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 05/10] crypto: arm/aes-neonbs - clear the crypto_aes_ctx when done
Date: Mon, 10 Aug 2026 11:30:00 +0200
Message-ID: <20260810093009.608090-6-thuth@redhat.com>
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

Clear the crypto_aes_ctx structure via __cleanup(aes_zeroize_ctx) when
we're done with it to avoid that key data could leak on the stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/arm/crypto/aes-neonbs-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index c49ddafc54f34..f0c8bfd2ac8fc 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -60,7 +60,7 @@ static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			unsigned int key_len)
 {
 	struct aesbs_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_aes_ctx rk;
+	struct crypto_aes_ctx rk __cleanup(aes_zeroize_ctx);
 	int err;
 
 	err = aes_expandkey(&rk, in_key, key_len);
-- 
2.55.0

