Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50582425CC0
	for <linux-crypto@vger.kernel.org>; Thu,  5 Feb 2026 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770306444; cv=none; b=XPYTHRwjWtO8bg/Xb2Fhe5tbRo08d1nJTcDl8PvCyYQ8zVkGqHJLxikj6jTdsOpOuaLRlxLV10+86kDDCEF+3okzPU0bN8l2warx2CL9pZLrLkOSqrrE00brW/ZSQxf5lAvfGxsKr+fg1S5TMTPAi443qDmtjdDWzEzUxvLrHmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770306444; c=relaxed/simple;
	bh=vCCaliERwSlZzc+XuIrS0lhzH4nb9gNqe9iZEp/4ro4=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=hAPWgz8sWviImcxxTs2UY3uThB5t+nHb9W6zFhTxdlFq0pEEMmikf/11+b9LzQljR/bAo4VftIH0G8wqP2pnwycmyUdrkh4PLl+jmz6LUBczJPtcKvjAj2miBnMMWf4bam0Km5SV+wynhg8Y51bcb0cVzjpd31a9puhrccQFh8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XjHuJpFz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XjHuJpFz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770306443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9AalDAqCSrPHzl6PRLengujOgGlQKMz7q2XgNk6zAZU=;
	b=XjHuJpFzVWk1iMJOVNOPbznMhg7x3WdFvDeacZ/DyiHO4joo+jGbZGLPhxhQqK4iIIj63b
	q2QPaXG6dYjzj3RPN3oZqGHoFD0dnIHlnzHCbpn4DZI+L8cXsbmxSd3ZnCEGQxazFGB34w
	7oOb3H7/jXDO3Hu5eOMr0MK3j2wLo0w=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-I5yeje16OEuihBXewHv6rw-1; Thu,
 05 Feb 2026 10:47:20 -0500
X-MC-Unique: I5yeje16OEuihBXewHv6rw-1
X-Mimecast-MFC-AGG-ID: I5yeje16OEuihBXewHv6rw_1770306434
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 125D81955F20;
	Thu,  5 Feb 2026 15:47:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.164])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4C90A192C7C3;
	Thu,  5 Feb 2026 15:47:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260202170216.2467036-1-dhowells@redhat.com>
References: <20260202170216.2467036-1-dhowells@redhat.com>
To: Lukas Wunner <lukas@wunner.de>,
    Ignat Korchagin <ignat@cloudflare.com>
Cc: dhowells@redhat.com, Jarkko Sakkinen <jarkko@kernel.org>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Eric Biggers <ebiggers@kernel.org>,
    Luis Chamberlain <mcgrof@kernel.org>,
    Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>,
    Sami Tolvanen <samitolvanen@google.com>,
    "Jason A . Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
    keyrings@vger.kernel.org, linux-modules@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: [PATCH v16 8/7] pkcs7: Change a pr_warn() to pr_warn_once()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2892235.1770306426.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Feb 2026 15:47:06 +0000
Message-ID: <2892236.1770306426@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Only display the "PKCS7: Waived invalid module sig (has authattrs)" once.

Suggested-by: Lenny Szubowicz <lszubowi@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Lenny Szubowicz <lszubowi@redhat.com>
cc: Lukas Wunner <lukas@wunner.de>
cc: Ignat Korchagin <ignat@cloudflare.com>
cc: Jarkko Sakkinen <jarkko@kernel.org>
cc: Stephan Mueller <smueller@chronox.de>
cc: Eric Biggers <ebiggers@kernel.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: keyrings@vger.kernel.org
cc: linux-crypto@vger.kernel.org
---
 crypto/asymmetric_keys/pkcs7_verify.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_key=
s/pkcs7_verify.c
index 519eecfe6778..474e2c1ae21b 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -427,7 +427,7 @@ int pkcs7_verify(struct pkcs7_message *pkcs7,
 		if (pkcs7->have_authattrs) {
 #ifdef CONFIG_PKCS7_WAIVE_AUTHATTRS_REJECTION_FOR_MLDSA
 			if (pkcs7->authattrs_rej_waivable) {
-				pr_warn("Waived invalid module sig (has authattrs)\n");
+				pr_warn_once("Waived invalid module sig (has authattrs)\n");
 				break;
 			}
 #endif

