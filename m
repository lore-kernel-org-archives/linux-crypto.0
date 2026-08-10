Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9577F3AFCEC
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 09:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354255; cv=none; b=TUfBAon8CW76xhDF40Jpbl40UlWv1+DkKqdtAGbvks2uZ2yRAuTeCJrg6j0TetxA5Mu3YrhLUD8qop22IErydF1Nfu0QRHVCjVWIi5bIVKFg2O6rFbf+C1B0Ad1xefJRmPjsWMWJq5XMoW+mzjKxpjpAXr0oTre6KD7MWIeEel4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354255; c=relaxed/simple;
	bh=0OpdUhVbbXBoRIbpB5mfrAmwF4IesghjJtKgHGPvd5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nekmJfsTOtOg4UDUzk2qzAwr056HickVChVKq8eeFhLn/B8JTuKRohs1OI7f6LTGkmKK8nWL+dNC8PKfcmKRrOGbX74SJMZQa32rX9UZsTVd7X951xQIJ1HmK7TuvmEMT2wWV1hoEWiOue34VQ8wvatHF7ndceOVMmzUtFAvHuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BDTtNR8G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BDTtNR8G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786354252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O7XDseE2m1TmA6tZncYGgA9JdA6mmPokf7dLTiKrG+Y=;
	b=BDTtNR8GQVEeRlaGwR4zGOtwPUx54vi5ulFAyF++q8S96i9mzuyXunvyKmvZjf67SfK857
	F8N/eYykWhHLbNRTt5fxQ1y70XYCKtObZpRV1Jau2sZJxAr0h/x6K7AYoL8EKPhCyxF5IP
	LRA4z0aP9NnhEh+GXAkPsz906cYOwss=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-402-htGM6jHWMiObNZ3vmr3_Ww-1; Mon,
 10 Aug 2026 05:30:45 -0400
X-MC-Unique: htGM6jHWMiObNZ3vmr3_Ww-1
X-Mimecast-MFC-AGG-ID: htGM6jHWMiObNZ3vmr3_Ww_1786354244
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E76519560B2;
	Mon, 10 Aug 2026 09:30:44 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 835573001DAF;
	Mon, 10 Aug 2026 09:30:42 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 08/10] crypto: safexcel - Simplify the check for a valid AES key
Date: Mon, 10 Aug 2026 11:30:03 +0200
Message-ID: <20260810093009.608090-9-thuth@redhat.com>
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

safexcel_aead_setkey() currently uses aes_expandkey() to check for a valid
AES key, but then does not use the crypto_aes_ctx afterwards anymore,
i.e. this is just a wasteful way of checking the key length, and thus
aes_check_keylen() should be used instead.
This also fixes a potential leak of sensitive data via the stack, since
this function forgot to zeroize crypto_aes_ctx before returning to the
caller.

Suggested-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index a8349b684693e..f07d043c67d45 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -407,7 +407,6 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct crypto_authenc_keys keys;
-	struct crypto_aes_ctx aes;
 	int err = -EINVAL, i;
 	const char *alg;
 
@@ -438,7 +437,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 			goto badkey;
 		break;
 	case SAFEXCEL_AES:
-		err = aes_expandkey(&aes, keys.enckey, keys.enckeylen);
+		err = aes_check_keylen(keys.enckeylen);
 		if (unlikely(err))
 			goto badkey;
 		break;
-- 
2.55.0

