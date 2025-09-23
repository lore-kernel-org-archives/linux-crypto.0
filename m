Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74AC261574
	for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2025 14:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758637371; cv=none; b=o8UXAZRv/vjwDgv62/Kn/gjAI+b4rDotjwYI5G3YIzy6JPz6iWPblLYkLLoWv02z6Isomti5BT8lTwhusew+IGQZYV7c0C8G9pfZz8yH0DoctDJAlr5ZOYhfSpjXJONPZ6in5uMNoQi+TIX6L2tRwXkeGJD/vduCiW4h7akMmOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758637371; c=relaxed/simple;
	bh=Zho6dmj3WkqGl3iprnGtZvamdz4pXam/K0a9txcY9kA=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=j9EhlvlKcloutEP/Gey8e2WYNw0F3lsfBsUukIrXL+9gfyVP91AvG6daEby1ItUiPEvp09Voxo+kpBcOWeCCfO0w1Q2kfTqgxEWubifmsu1kdVhRHVatGLL8E0qK3ABm3KYzmpjM+uZLJijsqcpRE7/egbH4klMIVpUA/Osr1PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Of0LcO76; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Of0LcO76"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758637368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oZ23MEIRFoVa/o0s4V6+zDe1SflOZr9YN09DGHuSmg4=;
	b=Of0LcO764trly2OVrlnWJjkAtlVEiFBW2h42l1ZI7KdNfOVJXQ0xjV1tERthW/NI6XsM2i
	6a4nhNHJOLOHtbvemu+DqXVxPg/2DIu6RAsWhumsd9daD0eBm4qrO3GwGNslsVLjeN7pi5
	0/AI8Yps+MMuj8PKcK6xcniqHkFSjOY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-539-2x1nXgmPP0avCmUGpuDAqA-1; Tue,
 23 Sep 2025 10:22:43 -0400
X-MC-Unique: 2x1nXgmPP0avCmUGpuDAqA-1
X-Mimecast-MFC-AGG-ID: 2x1nXgmPP0avCmUGpuDAqA_1758637361
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D34FA195608B;
	Tue, 23 Sep 2025 14:22:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.155])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 24C671800451;
	Tue, 23 Sep 2025 14:22:36 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250921192757.GB22468@sol>
References: <20250921192757.GB22468@sol> <3936580.1758299519@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, "Jason A. Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Harald Freudenberger <freude@linux.ibm.com>,
    Holger Dengler <dengler@linux.ibm.com>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Stephan Mueller <smueller@chronox.de>, Simo Sorce <simo@redhat.com>,
    linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
    keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib/crypto: Add SHA3-224, SHA3-256, SHA3-384, SHA-512, SHAKE128, SHAKE256
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <506170.1758637355.1@warthog.procyon.org.uk>
Date: Tue, 23 Sep 2025 15:22:35 +0100
Message-ID: <506171.1758637355@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Eric Biggers <ebiggers@kernel.org> wrote:

> Also, the parameter should be strongly typed: 'struct sha3_state *'
> Likewise in all the other functions that take the raw u64 array.

Those function may be directly substituted by calls to assembly code - so
u64[] is probably more appropriate.

> > +	for (round = 0; round < KECCAK_ROUNDS; round++) {
> > +		keccakf_round(st);
> > +		/* Iota */
> > +		st[0] ^= keccakf_rndc[round];
> > +	}
> 
> In the spec, "Iota" is part of the round.  Having it be separate from
> keccakf_round() in the code is confusing.

I assume that pertains to the comment about inlining in some way.  This is as
is in sha3_generic.c.  I can move it into the round function if you like, but
can you tell me what the effect will be?

> Second, the support for update() + squeeze() + update() + squeeze()
> seems to be trying to achieve something that is not defined in the SHA-3
> spec.  Could you elaborate on what it is meant to be doing, and why it's
> here?  According to the spec, the XOFs SHAKE128 and SHAKE256 actually
> just take a single message as their input.

Turns out I was misunderstanding what I was looking at whilst trying to adapt
Leancrypto's dilithium code.  Whilst it does squeeze a context several times,
it doesn't update it after finalising it without reinitialising it.

David

