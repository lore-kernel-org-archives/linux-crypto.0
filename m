Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF163AFB06
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 09:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354251; cv=none; b=lAXcyXWchS0Y5PKy8OYtWaRFgrgHa/IVWpVEm3S4yR9cBp6RRtXPZvlOpzhS4c4mnFS8Q2NI+s0QzUBvpTmNcTKeBrmnpY5bLjZxJDaZc4dRnof85kgsG4zuJQQiKk2WSOpnNlTzcQCCChy8+Hx81Xt9y5nJjUPJQR/5sqDdHmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354251; c=relaxed/simple;
	bh=H51eEndb83vlMBdSKdQPCJs4a0NhTn4ra/iT1GUYwIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnaqDRa7T+UfE9uwRzhATv7gI0hx2APJC53AnybGJdkTYb2cy/HOxEOD6s9O3zhaPltc0su5PKqhc1U/mTGCw6LOZGenmXRz6nuB2jR3IyLdQLNW6/6KhIabDwb1XNeT33znE1mhc7/88g7HNaguFNjbn6UnraCmz/UmvmV7EFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g+y59ubq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g+y59ubq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786354248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UgOea8COfMWPGkNwdk17UcXroZGUrewDpcR0b9Y5VNk=;
	b=g+y59ubqy+jaWooId3o2tVm4Mex7COronMYTGXmQtX2h0BnzlSVqCJhlJYQfPBzKW/CskX
	JHQhUOKSPOizXw3arUMu9NDFzLlj3s4O5YyRIxO2EyWI7j6d7ar8cN9Yfvxe+rNzmQtOAM
	1WombknwsPDFYAGZMrsJaaaAC8Vjxqs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-520-WhMXaSr1MJ-7amixPsaTGA-1; Mon,
 10 Aug 2026 05:30:30 -0400
X-MC-Unique: WhMXaSr1MJ-7amixPsaTGA-1
X-Mimecast-MFC-AGG-ID: WhMXaSr1MJ-7amixPsaTGA_1786354229
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5035D180075E;
	Mon, 10 Aug 2026 09:30:29 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 306B93001D38;
	Mon, 10 Aug 2026 09:30:26 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>
Subject: [PATCH v5 04/10] crypto: sa2ul - clear the crypto_aes_ctx when done
Date: Mon, 10 Aug 2026 11:29:59 +0200
Message-ID: <20260810093009.608090-5-thuth@redhat.com>
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

