Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BE332863A
	for <linux-crypto@vger.kernel.org>; Thu, 16 Oct 2025 14:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760625262; cv=none; b=L9MLaf9fv5jV6b7vOo3mUTUKCWVzLWV85BJsTPjT/4NTajlhg0Yy64huO9+KEWHILZ8XEG8mOpMNt/G/bhDUP1kQtZvgFDt4yQlYMNwMLyydIPKD2wRb0c76EO3J4Z9s+ip5R/3o3OztS8B+dBaKZ47fQCHe1PPEbyEeCMFirIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760625262; c=relaxed/simple;
	bh=Uw9k3Nn2rAVurZJW//6Yil6Gpc0P5pF/kG2hQ2RNlUo=;
	h=From:In-Reply-To:References:Cc:Subject:MIME-Version:Content-Type:
	 Date:Message-ID; b=owbRIEEf01fj19oNCu9HyD1KEWOAA6shFTpxMNfmUPqV5tJBcAyai8zqSMADWREN8opGFPAceuUmAS1fp7vyQe/mBxdcZZNOiXOGIkHvQcU6i/fl0nTzDnJDfISwlw/0QckAVsA7Bhm/1TeWsfuJgYJYrAO4LjsK4OxivvFq5Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iwaM2wyQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iwaM2wyQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760625259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ACompS8RN1HL21dOAoG+qrfrbuwD8dNCF47B5bieXU=;
	b=iwaM2wyQ9pUKo4W5Hrcu6lix6Pi66n+Vx0f/tOJ3WY/Hgrt3Okt5tXnqCmREGSD73wgNPY
	SrdbAE+/cdwe62IR9bKY/BlzJPindWdOiXZg8f9PHy+AqdJQz5eqtSlqQPmKnX7pHk5C39
	elzm7TWdSfUpbnissUZUvOHExxxyZa8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-d-qVbRfDMYKZyfu0-a4OuQ-1; Thu,
 16 Oct 2025 10:34:18 -0400
X-MC-Unique: d-qVbRfDMYKZyfu0-a4OuQ-1
X-Mimecast-MFC-AGG-ID: d-qVbRfDMYKZyfu0-a4OuQ_1760625255
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6332518002C1;
	Thu, 16 Oct 2025 14:34:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.57])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 760101800579;
	Thu, 16 Oct 2025 14:34:12 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <286100.1760618158@warthog.procyon.org.uk>
References: <286100.1760618158@warthog.procyon.org.uk> <20251002162705.GB1697@sol> <20251001152826.GB1592@sol> <20250926141959.1272455-1-dhowells@redhat.com> <20250926195958.GA2163@sol> <2636609.1759410884@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, Eric Biggers <ebiggers@kernel.org>,
    "Jason A . Donenfeld" <Jason@zx2c4.com>,
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
Content-ID: <363388.1760625251.1@warthog.procyon.org.uk>
Date: Thu, 16 Oct 2025 15:34:11 +0100
Message-ID: <363389.1760625251@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

David Howells <dhowells@redhat.com> wrote:

> I have ML-DSA working as far as being able to load keys and check signatures
> in the kernel - but hit a minor bump of openssl not apparently being able to
> actually generate CMS signatures for it:-/.  It seems the standard is not
> settled quite yet...

Actually, openssl CMS can generate ML-DSA signatures, but only if CMS_NOATTR
is not specified.

David

