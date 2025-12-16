Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FA53A5C33
	for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 13:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765892134; cv=none; b=PG5Ikfm/dDSJkV9Lw9fJSm2eON+wtsxyyM132YyUTcc0KRgNCCl/sWT6JrSN+RcaRfS8ZeW924VOdVE0SvZ/iSw+0TvxVM3E7VOpDIG7EixPGJ+H7NzVOGBaNV622Nzr8Kj2VaTFtrgWgyb1gl/qJnDRt4CF4GPptWzwiWzjWg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765892134; c=relaxed/simple;
	bh=/TuWZWEx2NVTRuAmxDx8HYYOZ46lSxPe2TJd6EEAnOc=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=c9ovRjues1xTkpM3vMCfAsBeEVjMUpsfsg2IbhUgdsImqtrl5ysV+MF7mUaFz3KxzHIat5OAR54BJeRA+JfqHF4WNqIxbWJogfROc++FLQwfBet6IaaEVK/jS7QCmrDB9vsU1P9g1Sp1dl6GO0lc5xKvU7ntTaNh7O4tLAWvbjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YAXDRk0x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YAXDRk0x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765892130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AlcoVrlydJTRV/EngxREOLZt/nB4VLHNk7n+wP1IBUA=;
	b=YAXDRk0xo5JrHZba6wo9rC153+FlaG11k+uN96zB2qTid1LEVVjUylnXH9VCe6eTqT5g9e
	1+6qJLLlPzekSh+Olefuu6tYOMPRI0QTAFDmW4ErNnVJTWgzwVP3nWA2os3/Z+OgJ8ALQh
	ckF/5I6KrLzcA6SZ2OwUoBogC5kVRxA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-8-rZZXE-xtNWe8xTSQgYnzDw-1; Tue,
 16 Dec 2025 08:35:26 -0500
X-MC-Unique: rZZXE-xtNWe8xTSQgYnzDw-1
X-Mimecast-MFC-AGG-ID: rZZXE-xtNWe8xTSQgYnzDw_1765892124
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C175195608F;
	Tue, 16 Dec 2025 13:35:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1E92B19560B2;
	Tue, 16 Dec 2025 13:35:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aUC6u-9r7w1uZH3G@gondor.apana.org.au>
References: <aUC6u-9r7w1uZH3G@gondor.apana.org.au> <20250919195132.1088515-1-xiangrongl@nvidia.com> <20250919195132.1088515-3-xiangrongl@nvidia.com> <fab52b36-496b-41c3-9adc-cb4e26e91e53@kernel.org> <BYAPR12MB3015BB37C50E4B9647C268ADA9ADA@BYAPR12MB3015.namprd12.prod.outlook.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dhowells@redhat.com, Ron Li <xiangrongl@nvidia.com>,
    Lukas Wunner <lukas@wunner.de>,
    Ignat Korchagin <ignat@cloudflare.com>,
    "David S. Miller" <davem@davemloft.net>,
    David Thompson <davthompson@nvidia.com>,
    Khalil Blaiech <kblaiech@nvidia.com>,
    John Hubbard <jhubbard@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
    "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
    Vadim Pasternak <vadimp@nvidia.com>,
    "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
    Hans de Goede <hansg@kernel.org>,
    "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Nvidia PKA driver upstream needs permission from linux-crypto team
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <953778.1765892118.1@warthog.procyon.org.uk>
Date: Tue, 16 Dec 2025 13:35:18 +0000
Message-ID: <953779.1765892118@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Note that there is a keyrings-based UAPI for doing public key cryptography, if
it's of use:

	keyctl_pkey_query()
	keyctl_pkey_encrypt()
	keyctl_pkey_decrypt()
	keyctl_pkey_sign()
	keyctl_pkey_verify()

using the keyctl() syscall through libkeyutils.

To use it, you need a kernel key (ie. created by add_key() or request_key())
to represent the key material and potentially the mechanism by which it can be
accessed (if the material is, say, stored in a TPM and can only be made use of
by talking the device).

Keys can be loaded by X.509 or PKCS#8, but other ways could be added.

I've also contemplated making this accessible via io_uring.

David

