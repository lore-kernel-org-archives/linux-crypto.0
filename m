Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFA74A04
	for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 19:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758136275; cv=none; b=Qlk1NlLNVKQ/UifBZfr11PvjYom+R9Utk7MwMCTQ7qAAyswT/vq7kGJUysvLm57YsxULcsGlz1Vur452jw30wPtU/k5IdHiLUMmepZDNvkMSq85MC14M4BZwGr8vEPD6H4qyGAvqKjZkkbLilBLivm1yz3oUm7udtAwsMMItwno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758136275; c=relaxed/simple;
	bh=LceR4ffsUhbkpIVSbt6F+6G7sJ1a9BPpbn9jRwEA+8I=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=npVDa7pFDNwhSZNSpEOqkKGunFkqllQEgtvnKfJ071Y3+8sBV/ihLoEx/AGwgImXHg18zHjaYsuLL0GVVrTS0TyWLag60xU4+f/hk+bOodhQzbk2jvfwchrUJLUxdPSY8pNnn9PDwjocc/NNZV5W2QkLOzRqxgdz66HTfMJOOqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=amQn1m2R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="amQn1m2R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758136272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J5KSzDM14dMkn5zCeFDzk5Itc2Sy4L3H8+/teZXOEr4=;
	b=amQn1m2Rv70eshGOM7FhaRgpKMDfDI6HSnGWhPgQjcgwgANrF2k5x/Hbu1/96paDWNWdXf
	wP3rT4sE0wtg8pEoGgCPeBnn2yhQu3U8yUxc5OaqmTIKtiZcUPYr+/6sgmrYMGvtrdwOXT
	veppsUJXNXo6xBUlrKBJoBw0wkgAVls=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-SUVsFn50NWy1wQ8VY6LrkQ-1; Wed,
 17 Sep 2025 15:11:11 -0400
X-MC-Unique: SUVsFn50NWy1wQ8VY6LrkQ-1
X-Mimecast-MFC-AGG-ID: SUVsFn50NWy1wQ8VY6LrkQ_1758136270
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 296AD1800372;
	Wed, 17 Sep 2025 19:11:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.155])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 42BA21800451;
	Wed, 17 Sep 2025 19:11:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250917184856.GA2560@quark>
References: <20250917184856.GA2560@quark> <20250915220727.GA286751@quark> <2767539.1757969506@warthog.procyon.org.uk> <2768235.1757970013@warthog.procyon.org.uk> <3226361.1758126043@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org
Subject: Re: SHAKE256 support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3230005.1758136267.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Sep 2025 20:11:07 +0100
Message-ID: <3230006.1758136267@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Eric Biggers <ebiggers@kernel.org> wrote:

> On Wed, Sep 17, 2025 at 05:20:43PM +0100, David Howells wrote:
> > Okay, I have lib/crypto/sha3 working.  One question though: why are th=
e hash
> > tests built as separate kunit modules rather than being built into the
> > algorithm module init function and marked __init/__initdata?
> =

> KUnit is the standard way to do unit testing in the kernel these days.
> The kernel community has been working on migrating legacy ad-hoc tests
> over to KUnit.  This is not specific to lib/crypto/.

How do you test hashes with variable length digests (e.g. SHAKE128/256) us=
ing
the hash testing infrastructure in lib/crypto/tests/?

David

