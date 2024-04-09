Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B99D80045
	for <linux-crypto@vger.kernel.org>; Tue,  9 Apr 2024 09:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712656301; cv=none; b=rR98lhK64UxHfAPFiTZE79xtryRbG2YM290t9k0Pr4O4yF31vVR50kszmwzqoO1xsSmq4CKBJIZzguxCbMSXZfuS7hoM9CnGn77mqgvEGfreNYrOtONZb10zNIbQdAoA9720CGFVdjz0CjOIivDvY07m6Tplj/ial2tPrpBzJ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712656301; c=relaxed/simple;
	bh=78/5QJap8vVBs4Gy5QinmJjzWMbaMMInwHU+KCD4GL0=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=T26OKutGFYD2R/Qp7gH7Jqxgp/3QyWV0mMLH5VweWIOgXTB7gu4rSkOVaZtAlXIjfWuQT9u2DV0seK0gFAyrVByvdLDJCLN+W2kFVX+c0PjUfHcwrBsaNMrW1wWUD8RVKqzSF206DpOkJ1cislu5fdg6fzTPXdbagXpXcs90EYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XOTJ3q/b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XOTJ3q/b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712656297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=L5OV7jyoR0JrtQAfkWwBnCoP/OfPB4UxrynwWPMgTtE=;
	b=XOTJ3q/bUidgHcrU7taqGD/FKOxTyPE++kO02VYP2i2R8+0RFTeoh/QuqsucvNFVuyND7o
	qghZf83VdPOZd65J3A7d/MC6T0Eh9cGfpA9qo3gwhfIR/ARHeHIfz3x4ZvZn8uh2O7y8V1
	jhk005L7QXKBTFSQ43ckPnCdjYPriCo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-Nl9yWVIWPSmcyVXL9e2BHQ-1; Tue, 09 Apr 2024 05:51:36 -0400
X-MC-Unique: Nl9yWVIWPSmcyVXL9e2BHQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12EC6104B50A;
	Tue,  9 Apr 2024 09:51:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.146])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E42172166B32;
	Tue,  9 Apr 2024 09:51:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
    linux-crypto@vger.kernel.org
Subject: Incorrect use of CRYPTO_ALG_ASYNC in crypto_alloc_sync_skcipher()?
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1068288.1712656290.1@warthog.procyon.org.uk>
Date: Tue, 09 Apr 2024 10:51:30 +0100
Message-ID: <1068289.1712656290@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Hi Herbert,

Is the following code in crypto_alloc_sync_skcipher() wrong:

	/* Only sync algorithms allowed. */
	mask |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE;

in its specification of CRYPTO_ALG_ASYNC?  Given what the docs say:

    The mask flag restricts the type of cipher. The only allowed flag is
    CRYPTO_ALG_ASYNC to restrict the cipher lookup function to
    asynchronous ciphers. Usually, a caller provides a 0 for the mask flag.
    ^^^^^^^^^^^^

or are the docs wrong?

David

