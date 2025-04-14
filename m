Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BBB29C344
	for <linux-crypto@vger.kernel.org>; Mon, 14 Apr 2025 13:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744636289; cv=none; b=WROtRMAUjUPqjd3KzfGko1tBUSsP0SflE9hyeKFUV4rJQVxWzmZd8WD710EE2YUAF4eIE0iIT11DFbMJfCBwHiE2nM9vwPGVDYVMvRlyzMIw5+lyOvwTnmhk9sZ8o+JadvMACL3eazB4KIlAV10XT4k1EJQZwe/HLbXK7LwLsMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744636289; c=relaxed/simple;
	bh=ugjTPwfnZiTxvU5XDmHEqgvVpMxJkEGAdzBBkm6oucw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KipgtgEX3hUgjRBP7Ol8t351CYyohA40OaQ4NdgkR3Hw4Ni7cRFw0a5qffpASBVn2flw0Mj6hzTOIaflmZBFj9hzs5wez9UtnG1WjA4frLfhHZU5JHypwTXw333o+9A76SJc26bbBeWkDztnWs1RMv+YYtJXIIRixBnIROPddNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EUHb5KyE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EUHb5KyE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744636286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yTYD0p7q6zDX4qmZBLzT+oeD/x56CzbjoeZMk7u5XVY=;
	b=EUHb5KyEN9UCYM+hnircsg1gG6J8TKN9yK/4djyCTh2jwU4W6NODtmVgan5h0OlenTe55x
	ovTiXqDiYUHCIqH08w1syIYyPQZI3aUvUiVyKTd85haxU5xX3Fh1xWepzDiJSTaef74iKk
	VVw+TvKSxzUlnMhPcbpnX7XkzqMUHe4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-_LW-k8WlN5i_0LtmKdHhWw-1; Mon,
 14 Apr 2025 09:11:23 -0400
X-MC-Unique: _LW-k8WlN5i_0LtmKdHhWw-1
X-Mimecast-MFC-AGG-ID: _LW-k8WlN5i_0LtmKdHhWw_1744636282
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7D291800260;
	Mon, 14 Apr 2025 13:11:21 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.44.22.17])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8F6FC19560AD;
	Mon, 14 Apr 2025 13:11:17 +0000 (UTC)
From: Vladis Dronov <vdronov@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH] crypto: ecdsa - explicitly zeroize pub_key
Date: Mon, 14 Apr 2025 15:10:53 +0200
Message-ID: <20250414131053.18499-1-vdronov@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

The FIPS standard, as a part of the Sensitive Security Parameter area,
requires the FIPS module to provide methods to zeroise all the unprotected
SSP (Security Sensitive Parameters), i.e. both the CSP (Critical Security
Parameters), and the PSP (Public Security Parameters):

    A module shall provide methods to zeroise all unprotected SSPs and key
    components within the module.

This requirement is mentioned in the section AS09.28 "Sensitive security
parameter zeroisation – Levels 1, 2, 3, and 4" of FIPS 140-3 / ISO 19790.
This is required for the FIPS certification. Thus, add a public key
zeroization to ecdsa_ecc_ctx_deinit().

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 crypto/ecdsa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index 117526d15dde..e7f58ad5ac76 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -96,10 +96,12 @@ static int ecdsa_ecc_ctx_init(struct ecc_ctx *ctx, unsigned int curve_id)
 	return 0;
 }
 
-
 static void ecdsa_ecc_ctx_deinit(struct ecc_ctx *ctx)
 {
 	ctx->pub_key_set = false;
+
+	memzero_explicit(ctx->x, sizeof(ctx->x));
+	memzero_explicit(ctx->y, sizeof(ctx->y));
 }
 
 static int ecdsa_ecc_ctx_reset(struct ecc_ctx *ctx)
-- 
2.49.0

