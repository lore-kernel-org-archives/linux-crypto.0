Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56447364057
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 09:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750304; cv=none; b=P1BTPz7KrRBfV7ODNb3XzbyHAsSqRMfPUK+HqBkbs7kf4JRzy43l/HhADtgwSEer+AeT7WSPoUNqnh+HMYEFUukPKgUCVj1NXHttQJvl2kPWBmEEDtRS6EWuaEXd3wBiB5pEMWPzD+5/lV4J6SXloTTI3/XAOYwhri+2BpMHP/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750304; c=relaxed/simple;
	bh=tET0bmPovu6LMHmhPlWZdTJH8biWVE0DzpomZulNAYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKWNuNh/yv5uAxaaUY4BGwLVnaIcdlJXP6VACev+RqJU/4L6K8GkofzNAF3QefleJS9R0WV/4+Hdv/CXU4n/xmV0FDe23azOqPuPmHuZOUvRf7m+28duSj89GBC/8LxyrZYMn7hxcuANQutwBcDzaNuKb9zqV809u3Agt60mTmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BDBeREgl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BDBeREgl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785750302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r7jhgAlap1RRZguFS9J+8193uRModx2Kfk65XzDNpnY=;
	b=BDBeREglV9PRkNA5rwAGpJA8B6IDKY1PNcGYWlcI89RzzIFy46W0UKhGJYLEazyASOTfni
	EPJPKbXtTEPhzE/19qVssPflG221TOn6WYCqIVl/s2pCKBDd/Cf2wfx0e0sQJnTUsGCVaW
	eKsVqJaCKGf+XOCF9NAOBYTn9iYhbHY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-aHCCS2MAPjOvDzSdGnbn7g-1; Mon,
 03 Aug 2026 05:45:00 -0400
X-MC-Unique: aHCCS2MAPjOvDzSdGnbn7g-1
X-Mimecast-MFC-AGG-ID: aHCCS2MAPjOvDzSdGnbn7g_1785750300
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9F1B1800370;
	Mon,  3 Aug 2026 09:44:59 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.213])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 760E41956087;
	Mon,  3 Aug 2026 09:44:56 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Simo Sorce <simo@redhat.com>
Subject: [PATCH v2 4/9] crypto: padlock-aes - clear the crypto_aes_ctx when done
Date: Mon,  3 Aug 2026 11:44:23 +0200
Message-ID: <20260803094432.70505-5-thuth@redhat.com>
In-Reply-To: <20260803094432.70505-1-thuth@redhat.com>
References: <20260803094432.70505-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

Clear the crypto_aes_ctx structure via __cleanup(aes_clear_ctx)
when we're done with it to avoid that key data could leak on the
stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/padlock-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 1be549a07a219..ac0aace62b299 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -109,7 +109,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
 	const __le32 *key = (const __le32 *)in_key;
-	struct crypto_aes_ctx gen_aes;
+	struct crypto_aes_ctx gen_aes __cleanup(aes_clear_ctx);
 	int cpu;
 
 	if (key_len % 8)
-- 
2.55.0

