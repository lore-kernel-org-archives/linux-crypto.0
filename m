Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA0F10F2
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 00:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758240375; cv=none; b=Bzma8HHMFF24H4A/43yVA9SiP9CVKU9lkgh1ZA7k3Jidnb4j7CKW9jwJe1H1vjRVZxjWc5zG+S1gs7lRNbd+4PM2/49Pw62aU6sMFTlOTmJSvJHXabm3f69D5RwaMWQFq7KwNVeDoVEA9qh35RteobRxBfJfbYMdQu7xCGS4pHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758240375; c=relaxed/simple;
	bh=b5U5dJen7vB5oJAhsZKPq/U6/05KOvjH1qN8gQXhnd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+4J05yFQfr+l0Jn1rAEFG7xwTsMClKUtd5yycOkdblC3ZydYdYcZFeV26nMK0qY8U8ElZthdrhHHRSy3mxbqIJVBXdQGRbTP3bxU/Ak3RRZIObzalMIVw0IWvRoILnZyCED9VJd5L8AaXxsTM9nQStdlIyNQhBZ+BLuGbNXJI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Tr0Gs7Xx; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Tr0Gs7Xx"
Received: from trampoline.thunk.org (pool-173-48-102-243.bstnma.fios.verizon.net [173.48.102.243])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 58J05thn025872
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 20:05:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1758240357; bh=Hvoq5NHn+1w9nBmQ/XhW4MxfI0m9pkCuGXZSSvVA/is=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Tr0Gs7XxsHFiVzpb18CvXDASzHQuooRU1F4yRj95P6tnhWLSxsjgnITOqsw/TBoJh
	 kt1YtljXPSBoj607sQcKGNA6+dozxBzEiu5fU6Pz063Z62cy8GczLRIZAe/k7Ip4os
	 Uc1rX5Gw25zJiAuoVpXT98t9p/3POEShO6yQk5GZuJF95i4yChIOCEWFVYr6nPLUxU
	 hjZNSEcp3kYeXm3QpgdpjqhBCmUc9EpUtB8yTm/20T71X4EMQmJZdIjODliwwa4J6T
	 9E5lU/Js8rXzvQmmSY5wrKr1abmmF7vDor65FHf9q2R5uIgtXaFbiwcJNxPq8TBsKm
	 UnfAEL4LU7YbA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4A4642E00D9; Thu, 18 Sep 2025 20:05:55 -0400 (EDT)
Date: Thu, 18 Sep 2025 20:05:55 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: Eric Biggers <ebiggers@kernel.org>, dhowells@redhat.com,
        linux-crypto@vger.kernel.org
Subject: Re: SHAKE256 support
Message-ID: <20250919000555.GD416742@mit.edu>
References: <20250915220727.GA286751@quark>
 <2767539.1757969506@warthog.procyon.org.uk>
 <2768235.1757970013@warthog.procyon.org.uk>
 <3226361.1758126043@warthog.procyon.org.uk>
 <20250917184856.GA2560@quark>
 <783702f5-4128-4299-996b-fe95efb49a4b@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <783702f5-4128-4299-996b-fe95efb49a4b@jvdsn.com>

On Wed, Sep 17, 2025 at 10:53:12PM -0500, Joachim Vandersmissen wrote:
> I'm not too familiar with the history of lib/crypto/, but I have noticed
> over the past months that there has been a noticeable shift to moving
> in-kernel users from the kernel crypto API to the library APIs. While this
> seems to be an overall improvement, it does make FIPS compliance more
> challenging. If the kernel crypto API is the only user of lib/crypto/, it is
> possible to make an argument that the testmgr.c self-tests cover the
> lib/crypto/ implementations (since those would be called at some point).
> However since other code is now calling lib/crypto/ directly, that
> assumption may no longer hold.

In general, customers who lookng for FIPS compliance need it for some
specific application --- for example, encrypting medical records, or
credit card numbers, or while establishing TLS connections, etc.  In
my experience, customers do *not* require that all use of encryption
in the kernel, or in various userspce applications, must be FIPS
compliance.

So while some in-kernel users are switching to library API's, it might
not matter.  Heck, in some cases the only thing that might matter is
the OpenSSL userspace library.

I'll also note that if you need formal FIPS certification, what the
FIPS labs certify is a specific binary artifact.  If the binary needs
to change --- say, to fix a critcial high-severity CVE security
vulnerability, fixing the security vulnerability might end up breaking
the FIPS certification, requiring payment of more $$$ to the FIPS
certification lab.  Which is a rather unfortunate incentive about
whether or not security vulnerabilities should be fixed.

So I personally consider FIPS certification to be over-priced security
theater.  If it's needed because the customer needs it, and hopefully,
is willing to pay $$$ for it, my advice is to do the minimal needed so
you can get the magic checkbox so you can sell into the government
market or whaever.  FIPS compliance for its own sake is a waste of
time and effort, and in my opinion, the tax should be paid only by the
customers who want the silly thing.

Cheers,

					- Ted
