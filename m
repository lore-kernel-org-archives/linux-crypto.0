Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6F620F067
	for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 18:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749667527; cv=none; b=QZInJ7UMMp0PZ9FGVElH65HsKlzgHPE8d8l3GtXZiu5g8XhqGSAkngIxpNJ/ut7f0D/0LEfDPZNjUCipE6bWQ39Q77KZWlP4d9K87/auspdpF/gEhqT+NyNXI4nad9fIAJKLSWZiJls+ndHXzqp7NzKL0/G2SZT40AqWNLXKTII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749667527; c=relaxed/simple;
	bh=aDUrDsc2gJpGpvTSC5QyIq7leA7jeiSS/kItt8u3E4k=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=C1BJIJu1FC0j0Tmujq/i+8eQYBxrMnWzlhylPkSWGx/ZyIb5zCyY2k9XSqLpss2e0nDjmU1B35GFtB7gM87pyc2qjMefoEt+yb+Kokov6r/kIpRSy5A/YNNWO9poQgz4JN9VzH+ZVv+7ICoV8w2P2Wc7WT7rV7Yaixu8ZTdKSYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TKVq6NpE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TKVq6NpE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749667525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aDUrDsc2gJpGpvTSC5QyIq7leA7jeiSS/kItt8u3E4k=;
	b=TKVq6NpEmmT3u7gwGEdbCT/hBAIHxYWJJ3c+uO159yL44q0cdGHUQVm7ePKuK7vdsh02Bc
	2lT3Z6rYLdWtJAuL3t1IhZNlbLi4lysVqj/LcihMGcJrnaicmtEBJtAXzR3KG8pLqm1BDH
	EGsv5y1Rr3G6MlUW6h2kcvfG4g8M/9E=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-FSxMpdz1MduW-tiucdZZ4g-1; Wed,
 11 Jun 2025 14:45:21 -0400
X-MC-Unique: FSxMpdz1MduW-tiucdZZ4g-1
X-Mimecast-MFC-AGG-ID: FSxMpdz1MduW-tiucdZZ4g_1749667520
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D81DA19560A2;
	Wed, 11 Jun 2025 18:45:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E6B1419560AF;
	Wed, 11 Jun 2025 18:45:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHk-=wjY7b0gDcXiecsimfmOgs0q+aUp_ZxPHvMfdmAG_Ex_1Q@mail.gmail.com>
References: <CAHk-=wjY7b0gDcXiecsimfmOgs0q+aUp_ZxPHvMfdmAG_Ex_1Q@mail.gmail.com> <301015.1748434697@warthog.procyon.org.uk> <CAHC9VhRn=EGu4+0fYup1bGdgkzWvZYpMPXKoARJf2N+4sy9g2w@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Paul Moore <paul@paul-moore.com>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org,
    linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
    linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Invert FINAL_PUT bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <382105.1749667515.1@warthog.procyon.org.uk>
Date: Wed, 11 Jun 2025 19:45:15 +0100
Message-ID: <382106.1749667515@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I guess I can still take it if people just say "do it".

Do you want a signed tag and git pull for it?

David

