Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C631E51EE
	for <linux-crypto@vger.kernel.org>; Fri,  7 Nov 2025 10:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762509845; cv=none; b=NawhnE1/5g4yWlqVMFULuu4MnUW7s0m731jqIRNu4/MoMNyKjbY17K6iD/7EL24PsB1ygg1U4AXGJhrWeLr2/ePnKa+1N8zmRkG8IHY0j09L1Jf8tj+3frD5T3nMpfZC2LL3lwyCD24rc233136LE2JiYbgWe5xWBes3Cm/fv4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762509845; c=relaxed/simple;
	bh=s5d2AEg4IeHY1YjK9lRLVW8gfHm84sMMYvSA5Lcy/3M=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=VjcUFUVCbPAciYnbZK/J8Q5E6vchblpodpcxaTFOBiIbh0SC24J8yLdSWNJpMRRJ9VlsG9mC9Jf/0UNDBR//xbsQkR729l7DniUOROWdquLbnBwf0RkwwGxPhdejpTDi0p6AHgGMfLZ6V+NKkVj9w9nZtEkBwQo2wONFw2g3a3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i3YzA584; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i3YzA584"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762509843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rur5orniOJnaYrB7Wxj6MNeN921rhBfpS5Vj838TDC0=;
	b=i3YzA584xpmv88QYADKFRAakFG31BxFzUHOQLZCvJKiuwSryfPrNO42hVCGOFzf+G4EbRa
	rmY7bTjiJeS4GJHgeUXaRxE6Ny2k9sby0xfVi/C1gEZv5P2pPkiXiyDxj72hHmEqBM5OL4
	ftzLMewlbrWIqhgJmczoPfns5wRjeeY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-lBhFBaTQN2qGhTVqgG5T7g-1; Fri,
 07 Nov 2025 05:03:58 -0500
X-MC-Unique: lBhFBaTQN2qGhTVqgG5T7g-1
X-Mimecast-MFC-AGG-ID: lBhFBaTQN2qGhTVqgG5T7g_1762509836
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28EA7193E88C;
	Fri,  7 Nov 2025 10:03:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.6])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 24C83180094C;
	Fri,  7 Nov 2025 10:03:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <53e81761-47e1-400e-933d-0a53018c9cab@linux.ibm.com>
References: <53e81761-47e1-400e-933d-0a53018c9cab@linux.ibm.com> <501216.1749826470@warthog.procyon.org.uk> <CALrw=nGkM9V12y7dB8y84UHKnroregUwiLBrtn5Xyf3k4pREsg@mail.gmail.com> <de070353cc7ef2cd6ad68f899f3244917030c39b.camel@redhat.com> <3081793dc1d846dccef07984520fc544f709ca84.camel@HansenPartnership.com> <7ad6d5f61d6cd602241966476252599800c6a304.camel@redhat.com> <69775877d04b8ee9f072adfd2c595187997e59fb.camel@HansenPartnership.com> <3d650cc9ff07462e5c55cc3d9c0da72a3f2c5df2.camel@redhat.com>
To: Stefan Berger <stefanb@linux.ibm.com>
Cc: dhowells@redhat.com, Simo Sorce <simo@redhat.com>,
    James Bottomley <James.Bottomley@HansenPartnership.com>,
    Ignat Korchagin <ignat@cloudflare.com>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Stephan Mueller <smueller@chronox.de>, torvalds@linux-foundation.org,
    Paul Moore <paul@paul-moore.com>, Lukas Wunner <lukas@wunner.de>,
    Clemens Lang <cllang@redhat.com>,
    David Bohannon <dbohanno@redhat.com>,
    Roberto Sassu <roberto.sassu@huawei.com>, keyrings@vger.kernel.org,
    linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: Module signing and post-quantum crypto public key algorithms
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <61527.1762509829.1@warthog.procyon.org.uk>
Date: Fri, 07 Nov 2025 10:03:49 +0000
Message-ID: <61528.1762509829@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Stefan Berger <stefanb@linux.ibm.com> wrote:

> On 6/16/25 1:27 PM, Simo Sorce wrote:
> > Of course we can decide to hedge *all bets* and move to a composed
> > signature (both a classic and a PQ one), in which case I would suggest
> > looking into signatures that use ML-DSA-87 + Ed448 or ML-DSA-87 + P-521
> > ,ideally disjoint, with a kernel policy that can decide which (or both)
> > needs to be valid/checked so that the policy can be changed quickly via
> > configuration if any of the signature is broken.
> 
> FYI: based on this implementation of ML-DSA-44/65/87
> 
> https://github.com/IBM/mlca/tree/main/qsc/crystals

The problem with that is that the Apache-2 licence is incompatible with GPLv2.
Now, it might be possible to persuade IBM to dual-license their code.

David

