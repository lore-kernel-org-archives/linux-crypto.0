Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E092E42A792
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786626120; cv=none; b=a+po63SZkPnTrOqKzmwDEkFahsKoUuI1f+CVxBrh0LAzO2jqk5q025iAPmU09ecg6by8cXLXwwZhkkbapZJz+n5nUg5BD16JvCpqmYkAzpX/U3IPtXyp7m7KwEglL15GzCYy+Pr1obLfBgBqP3s/xWodxBIBON1LmcGltDK2N7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786626120; c=relaxed/simple;
	bh=4+cWVReVXGiHiLnk3dkc962n1/SG3Gij7+isWSIx/18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H9uX17FVkdgV9cO8oCCsxxa1Fhb+Ea5USgb6Md8r1/cwhWxx/3chF+xsWO1T5zJ31rpq6lerWVzlhDPKXnePpGeWnlfvbDyMbTyLiswM9Ke/9NKwIEHoax5SeK7iJSId8s9E0KVFt/TDNjaw3G9dzU2imilu1dkfBtRGk9I0y4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NjRYrIQ5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NjRYrIQ5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786626117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gbjZbcmCfVZxXgLjlXAB0S0r2rU9IjLQWnE0bbtG2rg=;
	b=NjRYrIQ5rffK90ACy7ZsqyUnT7V+GUAS72n19+EizqcPNGI0N2G9jyBxEDHoLCQzXS3g9g
	yf2d8F+eWjZv3EO6F+dJe66N05YYKtvUm3g5qhliMJ/OMtKfjKIoyex8mjd44ZVA+R4z3j
	Oc/X0BBrU36Nbtty3p4fK5Wm35vq2wg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-bnINn-E4MLmUp90PWaFjeA-1; Thu,
 13 Aug 2026 09:01:53 -0400
X-MC-Unique: bnINn-E4MLmUp90PWaFjeA-1
X-Mimecast-MFC-AGG-ID: bnINn-E4MLmUp90PWaFjeA_1786626111
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BC761800652;
	Thu, 13 Aug 2026 13:01:51 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 230E41800577;
	Thu, 13 Aug 2026 13:01:48 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] lib/crypto: chacha20poly1305: Clear chacha_state in xchacha20poly1305_decrypt()
Date: Thu, 13 Aug 2026 15:01:47 +0200
Message-ID: <20260813130147.949545-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

The chacha20poly1305_decrypt() already clears it chacha_state at the
end, so xchacha20poly1305_decrypt() should do the same, too, to avoid
leaking sensitive information on the stack. Use a __cleanup() marker
to avoid that we have to do it manually here. For symmetry, use the
__cleanup() marker in chacha20poly1305_decrypt(), too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/crypto/chacha20poly1305.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index ea42a28f4ff7d..b40377dca8e02 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -172,7 +172,7 @@ bool chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 			      const u64 nonce,
 			      const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
 {
-	struct chacha_state chacha_state;
+	struct chacha_state chacha_state __cleanup(chacha_zeroize_state);
 	u32 k[CHACHA_KEY_WORDS];
 	__le64 iv[2];
 	bool ret;
@@ -186,7 +186,6 @@ bool chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 	ret = __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
 					 &chacha_state);
 
-	chacha_zeroize_state(&chacha_state);
 	memzero_explicit(iv, sizeof(iv));
 	memzero_explicit(k, sizeof(k));
 	return ret;
@@ -198,7 +197,7 @@ bool xchacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 			       const u8 nonce[at_least XCHACHA20POLY1305_NONCE_SIZE],
 			       const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
 {
-	struct chacha_state chacha_state;
+	struct chacha_state chacha_state __cleanup(chacha_zeroize_state);
 
 	xchacha_init(&chacha_state, key, nonce);
 	return __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
-- 
2.55.0

