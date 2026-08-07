Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3783D3914E4
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 07:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086456; cv=none; b=Uz+70R8lUmjHAGY2nxrkzUpvZnfTZOO5uJKQqbzUpIbRetkcTUg/dWlNhnBTe1o5YEfzFEoy50K5++YDl1xGtqoVhd60Rc01kAVkm4bGYsKT7iH+0ldybMg7LTakABj3i65Etwn9kuBIse5I+4peBRLl3vATNqnVpCqOmilqohk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086456; c=relaxed/simple;
	bh=H51eEndb83vlMBdSKdQPCJs4a0NhTn4ra/iT1GUYwIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/y8HTv+lOqYUkzgV1V2QUuGoLH5/sY/LV+vP9ZcBv0EdcKYHhqpEDl/my+6RXtOueAfWC159ouj6tMchw8HNg55JJHjFxbrWp94URKdcBSKLGDyuYeeouh2Ly/uuLtc5JpuPyoRTQNTfepdgqA6wAc02YL6iHRH2rsc6uCFCh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M1pTg1Pu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M1pTg1Pu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786086454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UgOea8COfMWPGkNwdk17UcXroZGUrewDpcR0b9Y5VNk=;
	b=M1pTg1PuZaPUxeNmnO43jmTt3QAYugYGF4S+TIzcZv2fz8V4qILe1AvkNh7+7x0aj19td9
	UU08wyBrJnlzZiTPSy/jk2mEYF+prGCWr15vIou+Hcq+m/tnO4CoN31eclasC43ccsfGW5
	IXr6U8ENcCKDzDw/6ardp+a982GswPk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321-UEauz07_N9eY3qABqt7ZmQ-1; Fri,
 07 Aug 2026 03:07:20 -0400
X-MC-Unique: UEauz07_N9eY3qABqt7ZmQ-1
X-Mimecast-MFC-AGG-ID: UEauz07_N9eY3qABqt7ZmQ_1786086439
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 995C51800646;
	Fri,  7 Aug 2026 07:07:19 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D7ED1956094;
	Fri,  7 Aug 2026 07:07:17 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 05/10] crypto: sa2ul - clear the crypto_aes_ctx when done
Date: Fri,  7 Aug 2026 09:06:32 +0200
Message-ID: <20260807070651.228713-6-thuth@redhat.com>
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

Clear the crypto_aes_ctx structure via __cleanup(aes_zeroize_ctx) when
we're done with it to avoid that key data could leak on the stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/sa2ul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index d865fd4a098cb..f1a7c2cc7a1af 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -465,7 +465,7 @@ static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
 /* Derive the inverse key used in AES-CBC decryption operation */
 static inline int sa_aes_inv_key(u8 *inv_key, const u8 *key, u16 key_sz)
 {
-	struct crypto_aes_ctx ctx;
+	struct crypto_aes_ctx ctx __cleanup(aes_zeroize_ctx);
 	int key_pos;
 
 	if (aes_expandkey(&ctx, key, key_sz)) {
-- 
2.55.0

