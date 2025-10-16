Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C60930EF69
	for <linux-crypto@vger.kernel.org>; Thu, 16 Oct 2025 12:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760618170; cv=none; b=EDslSrtlpCsj+PWwzVTjGdClM51icMrzyo5Xh7q99NeYZ4GWIGf9lnFooY2G/ZOrjTjTBxupzRFhHeZNwGbLiPlIvrg8wawXKcXAO1vHmaghtOQB0e9G5FpYzrlkgnwrwpPzdE10na1kgJVoWEzKXNCe5hyhwtg4a0Il5F14Ea8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760618170; c=relaxed/simple;
	bh=Z8biBHPmlmysDfd96XVwU0nzpvbppg4DvYIqDkAxaxc=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Lbq9inHpNuVKQ77is9f4O60UnVJZqNJzyEj/y3iNe6f50nPuOucHd3ID8W5tZ4aWjCmoPOUb6RDbuRso8/RaCxkowfuF8X3ebVkmBeGo3l7L+pNl227xKGu/WpFy8pR/I+kf0x5D+Q1F/1QiXrPuPZ+EShySK0AaiCzUrrXdYCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S1A2ECna; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S1A2ECna"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760618164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pEh7UgAiGM06rOoqRMblcIoFqkXOYCXAGLAJctJ27JY=;
	b=S1A2ECnaZNMoysAmj/0v1VHuPJ0DRiHh1QAAwp7pdU23G1PvVmih7L/4cVWhNz3bW1vFVx
	e1PmSEvdsG6PTWn+Gdxv1CsBBQvhfXEW4CFGo/k9wh3gTfzyIzOFzs8HU5ike3kXmiWnIJ
	QvsrtX7yr5/ldVN4v7MIH93EFYJVnp8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-mIrinKW7OSKbiQlZbc_GTQ-1; Thu,
 16 Oct 2025 08:36:03 -0400
X-MC-Unique: mIrinKW7OSKbiQlZbc_GTQ-1
X-Mimecast-MFC-AGG-ID: mIrinKW7OSKbiQlZbc_GTQ_1760618162
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7CC8195607F;
	Thu, 16 Oct 2025 12:36:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.57])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8C0531800452;
	Thu, 16 Oct 2025 12:35:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251002162705.GB1697@sol>
References: <20251002162705.GB1697@sol> <20251001152826.GB1592@sol> <20250926141959.1272455-1-dhowells@redhat.com> <20250926195958.GA2163@sol> <2636609.1759410884@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, "Jason A . Donenfeld" <Jason@zx2c4.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] crypto, lib/crypto: Add SHAKE128/256 support and move SHA3 to lib/crypto
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <286099.1760618158.1@warthog.procyon.org.uk>
Date: Thu, 16 Oct 2025 13:35:58 +0100
Message-ID: <286100.1760618158@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Eric Biggers <ebiggers@kernel.org> wrote:

> If you've now changed your mind and strongly prefer six types, I can
> tolerate that too.

I'll stick with it for the moment.  It does have the aforementioned minor
advantage of having the output buffer sizes encoded in the final functions.
Hopefully, there won't be so many places that actually #include it.

Further, this is something that can probably be changed relatively easily
later.

Since the merge window was still open and much flux happening upstream, I
decided to press ahead with stripping down the ML-DSA stuff and leave
reissuing the patches till after -rc1, so that I could be more sure of what I
actually needed for that.

I have ML-DSA working as far as being able to load keys and check signatures
in the kernel - but hit a minor bump of openssl not apparently being able to
actually generate CMS signatures for it:-/.  It seems the standard is not
settled quite yet...

I have them rebased and will repost them hopefully today with the ML-DSA
patches, such as they are, attached for reference.

David

