Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8D43112D1
	for <linux-crypto@vger.kernel.org>; Thu,  2 Oct 2025 13:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759410365; cv=none; b=l27EizKZcrqMklQ9NwftoFwqTuTb1O0dldwNY+bxstW3H821Aa1K+jIf10PWOLIKawDOuUWAaMiNDRU5enctH08IFnyAZEbDrJ4gHYCKreBnHKjqA8NgnZ0d2aSNBQcpZpQ4atYWTnuwlD2HltAVzuSDkKN1AQLyZWa4efj5q34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759410365; c=relaxed/simple;
	bh=HeD1PWdAC46yPwrU5aDe9dnE6V7FGimipisoeUrw1tY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=GoofAbebuT3Pgb+deNzJHJ5exdKffEI5N7n4a3nVyEYggXJX0w8QRnKu37cBrMXw0Ea15jOhdqq3fK12bRlKnBzCxqX16y9HVSODAPwZ8yHUe141A4Zb1srTCMsCaj69by/F85Wf3jOl3qCnJOb8zlHxLpMeUpV+gGDqJEsDeR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e8Pire9T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e8Pire9T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759410362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S08ebf+AN/FY3KivP37XFIOOi1h6AD7k44I6LeaZeH4=;
	b=e8Pire9Tl9HgJfeh3S+8hNh4fw56KMjI7GN09RJDx/x98DsFRefQg+9iMLRgWAndVRkT6h
	wDxO6DWPwyIPABK4H+0wi0onDIgzMqNr6RWRfz7OkSg4toIcFIHBYB0eOAvnWxQ3M7Hquz
	DD7e00MqlvApIQaGnaaeacCPzgrB9is=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-eIn7yj2DO9GLDoj4l4AdDQ-1; Thu,
 02 Oct 2025 09:05:55 -0400
X-MC-Unique: eIn7yj2DO9GLDoj4l4AdDQ-1
X-Mimecast-MFC-AGG-ID: eIn7yj2DO9GLDoj4l4AdDQ_1759410351
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32F0319560B2;
	Thu,  2 Oct 2025 13:05:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.24])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B907A1800577;
	Thu,  2 Oct 2025 13:05:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251001160435.GC1592@sol>
References: <20251001160435.GC1592@sol> <20250926141959.1272455-1-dhowells@redhat.com> <20250926141959.1272455-6-dhowells@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, "Jason A . Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/8] lib/crypto: Add SHA3 kunit tests
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2636464.1759410347.1@warthog.procyon.org.uk>
Date: Thu, 02 Oct 2025 14:05:47 +0100
Message-ID: <2636465.1759410347@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Eric Biggers <ebiggers@kernel.org> wrote:

> SHA3-386 => SHA3-384

Hah.  Possibly I'm too practised at writing "386".

> If these expected outputs are from an external source, then that source
> needs to be documented.  If they aren't, then the way in which they were
> generated needs to be easily reproducible and documented, e.g. by adding
> support for generating them to gen-hash-testvecs.py.

I generated them with openssl.  I'll add a note in the code.

> If that's the case, then running "./scripts/crypto/gen-hash-testvecs.py
> sha3-256 > lib/crypto/tests/sha3_testvecs.h" should reproduce this file
> exactly.  But it doesn't, so you must have manually edited this file.
> 
> It should match exactly.  That can be done by tweaking
> gen-hash-testvecs.py to use the correct *_DIGEST_SIZE constant and
> skipping the HMAC test if sha3-256 is requested.

gen-hash-testvecs.py doesn't know how to handle dashes in the algo name and
they end up coming in the output as "SHA3-256_DIGEST_SIZE".

It also generated an HMAC thing despite sha3-256 not having HMAC support, so I
just trimmed that off.

Anyway, I can modify the gen script to deal with both of those.

> >  def hash_final(ctx):
> > +    if ctx.name == "shake_128":
> > +        return ctx.digest(16)
> > +    if ctx.name == "shake_256":
> > +        return ctx.digest(32)
> 
> This addition is unnecessary.

Well, you can't generate SHAKE128 or SHAKE256 without it as the digest()
method has a mandatory parameter for XOF algorithms.  This fixes that.

David

