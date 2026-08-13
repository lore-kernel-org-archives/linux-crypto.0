Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75C0480950
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629036; cv=none; b=KuMK9vTWanjYnvwlIPEAtRkrHNmsQdX3e32LcEV38AutP/5/M24GS9gMyFq9AYYIvHMDHieUWE3lwJ2Gev4J8uqdvyNEf23LyfwXS3rnmAnO0I43iwaQuJcMX5zsaeqm1dkva0viCH1GKWPFC0+Ccj3go3yGH52F0rJB4mA9e/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629036; c=relaxed/simple;
	bh=+2zRxSvjAmqwYOE+tKwr1WSnbMWmNOH7W2evqTcz3wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3blyzPYlHhTpyeg97ZKLfw4pdXQDgOyCYzS9jhadYt9uNYsY8kQcCgdEc94na4+1srl1y7Q7Nmvb0QtvJUwFUs4YKe7dsicoF4n5qVdlhse3OGNO6PJxyBPyX/4/P8WmB+hICJkj+JQeKXNxhAlxp9seeVEo92Ts7d2r/ivC5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ntxllesd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ntxllesd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786629033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpTxCCo1JlTQTpMq2MklUewzzbiQjhVKEixoMx1SLYE=;
	b=Ntxllesde8Tk806LPES6+olsj6M43RWq9TNJjyT9kmNhv+mVDouljwQdUnRGyUHrw9u9cS
	MO7o5oAW6+XCQqVFF/zg6VG1rSIOhwigu8ojIMiluOGHXexejTkCEiruIup36CKcveEM7U
	PLi3lnk1xxd2oADcF9CvCsEHx2GroKI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-ok_ga5V1OjWuAl6pclbzXw-1; Thu,
 13 Aug 2026 09:50:32 -0400
X-MC-Unique: ok_ga5V1OjWuAl6pclbzXw-1
X-Mimecast-MFC-AGG-ID: ok_ga5V1OjWuAl6pclbzXw_1786629030
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6E1B1800846;
	Thu, 13 Aug 2026 13:50:30 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4D1851800348;
	Thu, 13 Aug 2026 13:50:28 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: x86@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] lib/crypto: sha1: Use hmac_sha1_zeroize_ctx() instead of memzero_explicit()
Date: Thu, 13 Aug 2026 15:49:47 +0200
Message-ID: <20260813134953.979481-10-thuth@redhat.com>
In-Reply-To: <20260813134953.979481-1-thuth@redhat.com>
References: <20260813134953.979481-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

It's only cosmetics, but since we have the new hmac_sha1_zeroize_ctx()
function anyway, we can also use it here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/crypto/sha1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
index b687b89d97cb4..c4361ef77166e 100644
--- a/lib/crypto/sha1.c
+++ b/lib/crypto/sha1.c
@@ -275,7 +275,7 @@ void hmac_sha1_final(struct hmac_sha1_ctx *ctx, u8 out[SHA1_DIGEST_SIZE])
 	for (size_t i = 0; i < SHA1_DIGEST_SIZE; i += 4)
 		put_unaligned_be32(ctx->ostate.h[i / 4], out + i);
 
-	memzero_explicit(ctx, sizeof(*ctx));
+	hmac_sha1_zeroize_ctx(ctx);
 }
 EXPORT_SYMBOL_GPL(hmac_sha1_final);
 
-- 
2.55.0

