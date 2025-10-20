Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD8B2FB99F
	for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 10:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956779; cv=none; b=r4amaPjHqHqMaC/k7yfIV6fteohE4F9FeDkrJXTbbsm3IJetoPFj3OKlotYb5t682ZfqPtnidgRcpRcR0vyvzp1oTiao7HHHLsKpK9jhTNTy7lBcXfv805ZBmBCJjZItvMeh+Se16ykxAAuw+JaWxS9kBhKrQSt8CO/lkSccbv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956779; c=relaxed/simple;
	bh=o06m2Hf5UOiIyCqy5/tbbq/q4Q+Pk/aECUU71C46ncU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=uA0OivBgKuLTctQMHZ355cMeBqYFqCRGlJkYN2zfwkBMZ/lpFkOPYDDFzkgVj2Cp/55QXooBl+wufurEtB2258qdwo5dILCuG8C5HrFiqfU4GPpA8fC2tA62vGs0c+0lEcpV5KTxNJ9Dhw6Y0YApO3MXEwBxuuhLxdE7QuPFEcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fsqPeKoR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fsqPeKoR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760956776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o06m2Hf5UOiIyCqy5/tbbq/q4Q+Pk/aECUU71C46ncU=;
	b=fsqPeKoR7uHfLPa76lI+iDq/UY4Kjw9ELXTwtvSEeKA1JeQdHEMFRI5MrLHgFo30LUxSEh
	3i5qfJoQXoWkKWKAXXlCSgkFha4MNYzCZVVhKeNChQziwtPuOPQBNgAA5c6L1yEa1iQIst
	dbNL3vUVP/i+vgcK7g8HT9wzxLkqA50=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-e6ZhlrVvPHugF73JmB980A-1; Mon,
 20 Oct 2025 06:39:31 -0400
X-MC-Unique: e6ZhlrVvPHugF73JmB980A-1
X-Mimecast-MFC-AGG-ID: e6ZhlrVvPHugF73JmB980A_1760956770
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5900B195609D;
	Mon, 20 Oct 2025 10:39:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.57])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 458EB19560A2;
	Mon, 20 Oct 2025 10:39:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aPXfzd0KBNg-MjXi@archie.me>
References: <aPXfzd0KBNg-MjXi@archie.me> <20251020005038.661542-1-ebiggers@kernel.org> <20251020005038.661542-4-ebiggers@kernel.org>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: dhowells@redhat.com, Eric Biggers <ebiggers@kernel.org>,
    linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
    "Jason A . Donenfeld" <Jason@zx2c4.com>,
    linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
    linux-s390@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
    Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 03/17] lib/crypto: Add SHA3-224, SHA3-256, SHA3-384, SHA3-512, SHAKE128, SHAKE256
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1062375.1760956765.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Oct 2025 11:39:25 +0100
Message-ID: <1062376.1760956765@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Bagas Sanjaya <bagasdotme@gmail.com> wrote:

> > +If selectable algorithms are required then the crypto_hash API may be=
 used
> > +instead as this binds each algorithm to a specific C type.
> =

> What is crypto_hash API then? I can't find any of its documentation besi=
de
> being mentioned here.

crypto_shash, then.

David

