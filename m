Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A3D3B05BD
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 09:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354234; cv=none; b=Kw/YaEclrWRcooTrKf7uTfCXPMcXvyjZn0i6Lq5sH6M9NoVPVwYvR+gmFlUpBypIqzYeOa82N6P79Aq6dD63BQ6BvgzYB5+GgotwFmcRWgF2VE+VtUZfqmK9O4dBKhW6U2yqdypIfZvH0M1Rm6CKMDP+MGCOaXrrOKB4gbZ+oWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354234; c=relaxed/simple;
	bh=rrHOeIvGuTbxvBxf0sD+S1Wa6q8TEDfmgAXE4+BZst4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sy/fFBjddKv7vEQwcBWvpexqeet6FUPeKOMcdl2IJLbwifpwHTjfGmDxb/FXGq96TOP3eVv4M+mLUsqkm/vpDiZeDCe2F/Oa/lt3WJpl+uSZt/pPD+vT8jjgo6sMM9gHSDmsOyoUAohLrhTGVLdS6FEAYqif/AOhiJTAvwqG8WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uh4kUjVd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uh4kUjVd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786354232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dFIxmKcUsq1WalhKwXv0wsQgLSJrF7IelNY2pEdEa3U=;
	b=Uh4kUjVdJpCZyrg1G/ogEIR4LBaY52AgGAy0DJkL3PIfp2xpqDgROZpWgK+gDfRSTo9gVz
	gHUvqJC5al/SChT2QtbMM4FW2WjZrRY46e3CoVZZdCKwSIPOnm8EyA250EgdfXiYn5ggRj
	Hl2RPXVAEdHidA5IG5QpYdoSJUhcJ/A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-fO72Sv4ONtWyLKSWRw1G6w-1; Mon,
 10 Aug 2026 05:30:27 -0400
X-MC-Unique: fO72Sv4ONtWyLKSWRw1G6w-1
X-Mimecast-MFC-AGG-ID: fO72Sv4ONtWyLKSWRw1G6w_1786354226
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CF51195608F;
	Mon, 10 Aug 2026 09:30:26 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E84EC3001D3A;
	Mon, 10 Aug 2026 09:30:23 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>
Subject: [PATCH v5 03/10] crypto: padlock-aes - clear the crypto_aes_ctx when done
Date: Mon, 10 Aug 2026 11:29:58 +0200
Message-ID: <20260810093009.608090-4-thuth@redhat.com>
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

Clear the crypto_aes_ctx structure via __cleanup(aes_zeroize_ctx)
when we're done with it to avoid that key data could leak on the
stack.

And since __cleanup() (and __free()) should not be mixed with
"gotos" in the same function, turn the goto statement here
into a proper block of the related if-statement.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/padlock-aes.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 1be549a07a219..400a889e924d7 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -109,7 +109,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
 	const __le32 *key = (const __le32 *)in_key;
-	struct crypto_aes_ctx gen_aes;
+	struct crypto_aes_ctx gen_aes __cleanup(aes_zeroize_ctx);
 	int cpu;
 
 	if (key_len % 8)
@@ -137,20 +137,18 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	ctx->cword.decrypt.ksize = ctx->cword.encrypt.ksize;
 
 	/* Don't generate extended keys if the hardware can do it. */
-	if (aes_hw_extkey_available(key_len))
-		goto ok;
+	if (!aes_hw_extkey_available(key_len)) {
+		ctx->D = ctx->d_data;
+		ctx->cword.encrypt.keygen = 1;
+		ctx->cword.decrypt.keygen = 1;
 
-	ctx->D = ctx->d_data;
-	ctx->cword.encrypt.keygen = 1;
-	ctx->cword.decrypt.keygen = 1;
+		if (aes_expandkey(&gen_aes, in_key, key_len))
+			return -EINVAL;
 
-	if (aes_expandkey(&gen_aes, in_key, key_len))
-		return -EINVAL;
-
-	memcpy(ctx->E, gen_aes.key_enc, AES_MAX_KEYLENGTH);
-	memcpy(ctx->D, gen_aes.key_dec, AES_MAX_KEYLENGTH);
+		memcpy(ctx->E, gen_aes.key_enc, AES_MAX_KEYLENGTH);
+		memcpy(ctx->D, gen_aes.key_dec, AES_MAX_KEYLENGTH);
+	}
 
-ok:
 	for_each_online_cpu(cpu)
 		if (&ctx->cword.encrypt == per_cpu(paes_last_cword, cpu) ||
 		    &ctx->cword.decrypt == per_cpu(paes_last_cword, cpu))
-- 
2.55.0

