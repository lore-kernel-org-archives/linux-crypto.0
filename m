Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0FB3B5F63
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 09:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354259; cv=none; b=M1XgoRrAyXTNGqnkbWPF/NgvlYkeHI37Yx7GxrxMr6zu7kYOVvyX3m9C4cdpTF3nDN/fwp+PunwPOJoONS6ZqPVnKwHNrR98p9p/tKLC0cyrfiUpkN7Z66O/Q+J64wEVXB0c9uQ+dARh9TYlrQxmdDSJx2NvQ076MZ0LwsIFd/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354259; c=relaxed/simple;
	bh=AvdIm6Ui0tKhNtJ8JmYLXzg5tYfY6zHY3E/mVVY4STI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qn27eHQalCGegmSf+0qp2fO9n4ZasV/FR56aIj7snoHzDfEaYZjfgCtaVFOxirqJjFQn2rjf5Z/rvVHQRH35fMUVPEDzGDah/C+sHTLK/cqQaqFnyE/kfeHnGbDcn2cNlmYzzAHw2oWhGa+mWUeCyjWRrvIXwvenE95NhxIlQVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NPQnHbnz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPQnHbnz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786354256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fllTULH2rQv7zAqX+LQLL7uPEeBIqqKHUflABxHkaxI=;
	b=NPQnHbnzxCRSHZYLsdXKU7KzmmZZFEgRmr8/CgLSJ1TbR1XKYHNO+6GW/S11/7fOOcrOrV
	1s0ltqPuJ4Fx6MNBb1xaYykXXzWe45XOwfRhEjKEOZqRty0NJiOunSx4YXITBI341AA3zG
	OWY6PnnTqRbKimygukdC9zOReAnYXgc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-264-Xp_sMOMDPSeBETgCHF5euA-1; Mon,
 10 Aug 2026 05:30:52 -0400
X-MC-Unique: Xp_sMOMDPSeBETgCHF5euA-1
X-Mimecast-MFC-AGG-ID: Xp_sMOMDPSeBETgCHF5euA_1786354251
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0095D19560BB;
	Mon, 10 Aug 2026 09:30:51 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 987073001D38;
	Mon, 10 Aug 2026 09:30:48 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 10/10] crypto: eip93 - Simplify the check for a valid AES key
Date: Mon, 10 Aug 2026 11:30:05 +0200
Message-ID: <20260810093009.608090-11-thuth@redhat.com>
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

eip93_aead_setkey() currently uses aes_expandkey() to check for a valid
AES key, but then does not use the crypto_aes_ctx afterwards anymore,
i.e. this is just a wasteful way of checking the key length, and thus
aes_check_keylen() should be used instead.
This also fixes a potential leak of sensitive data via the stack, since
this function forgot to zeroize crypto_aes_ctx before returning to the
caller.

Suggested-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/inside-secure/eip93/eip93-aead.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-aead.c b/drivers/crypto/inside-secure/eip93/eip93-aead.c
index 2bbd0af7b0e0e..0b7a899b14d76 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-aead.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-aead.c
@@ -92,7 +92,6 @@ static int eip93_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
 	struct eip93_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_authenc_keys keys;
-	struct crypto_aes_ctx aes;
 	struct sa_record *sa_record = ctx->sa_record;
 	u32 nonce = 0;
 	int ret;
@@ -126,7 +125,7 @@ static int eip93_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 		break;
 	case EIP93_ALG_AES:
-		ret = aes_expandkey(&aes, keys.enckey, keys.enckeylen);
+		ret = aes_check_keylen(keys.enckeylen);
 		if (ret)
 			return ret;
 
-- 
2.55.0

