Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBD62F83BA
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 15:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758295347; cv=none; b=pJmFaBKBpRbh+buxDAszj9OGnGX7LlUop3aDeq2hE03zAAVQAXkanZMvaNduPPG3lK8NKdVMeOMFSxV5vwB2ww1WFtV7/IH63FQtrMmRfs+HS9kHwxQVObiruUq0WPjzOP7PxRzEZjyAjzMfdcGUIHoho6Skunvas/i81U9Zv6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758295347; c=relaxed/simple;
	bh=FKMF9DSD47nX7o/weW+pUO3ESETPx+jjgfVIjD9nctM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b14TV/7MF8czfvBKqlH4Jh1tfpn3Sn1iT8GL2FizKoUP2HgwtOQpXhIa4Q2gbkzlxlrCpB7LiMm2qowZa2tMDHKDzYnbR99uMO/q9XvdTqlmk0+Us13n52ctHvYfvAXqZhKcByBlM8fIihPsG84wbZS4YsvEJTY9tybqn3UofOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=N4RwEQzl; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="N4RwEQzl"
Received: from trampoline.thunk.org (pool-173-48-111-47.bstnma.fios.verizon.net [173.48.111.47])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 58JFMGSi013229
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Sep 2025 11:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1758295338; bh=GCbvWgomfUoMx5WRPim3dczNlmL7tE3plpvrnLAlly4=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=N4RwEQzlysutZlmhWDi7qU5BrDvQ1ougmSYSlzw+vZA1pm7NKfFDJENnZUO4e2gqo
	 T8zxvqoTAq/VqruEKKZjuCOnFHgOSNoxUhwevCgn6DQWU3NYog0wLHmqIkIWSSofHZ
	 fg51EXllCEtW31Uhx5DfSNwu/R38wLnzGM2g7dGgHATMBMf6puESd/sjzXPqSntq0y
	 OCg1CG837rcE13mjavR9dayiUm/rrPVKAIU2ji31wC5Z6QYV2cgH/7Idi0rU+xlDf4
	 ISez0vTUCRxxBttfkhjNhz+eV6EY7pcQlkEz8sWCDqeEXSUBdzMWbzSl5cvRF2nbOe
	 h6a2pSYcllTBw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 120742E00D9; Fri, 19 Sep 2025 11:22:16 -0400 (EDT)
Date: Fri, 19 Sep 2025 11:22:16 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Joachim Vandersmissen <joachim@jvdsn.com>, linux-crypto@vger.kernel.org,
        simo@redhat.com
Subject: Re: FIPS requirements in lib/crypto/ APIs
Message-ID: <20250919152216.GH416742@mit.edu>
References: <0b7ce82a-1a2f-4be9-bfa7-eaf6a5ef9b40@jvdsn.com>
 <20250918163347.GB1422@quark>
 <3e06f746-775e-4b9e-93c9-d1f51f77148f@jvdsn.com>
 <20250918180647.GC1422@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250918180647.GC1422@quark>

On Thu, Sep 18, 2025 at 01:06:47PM -0500, Eric Biggers wrote:
> > I'm more trying to figure out a general approach to address these kinds of
> > requirements. What I usually see in FIPS modules, is that the FIPS module
> > API is as conservative as possible, rather than relying on the callers to
> > perform the FIPS requirement checks.
> 
> Aren't these distros including the modules within their FIPS module
> boundary too?  It seems they would need to.
> 
> Either way, they've been getting their FIPS certificates despite lib/
> including non-FIPS-approved stuff for many years.  So it can't be that
> much of an issue in practice.

What I would recommend for those people who need FIPS certification
(which is a vanishingly small percentage of Linux kernel users, BTW),
that the FIPS module use their own copy of the crypto algorithms, and
*not* depend on kernel lib/crypto interfaces.

Why?  Because FIPS certification is on the binary artifact, and if
there is a high-severity vulnerability. if you are selling into the US
Government market, FEDRAMP requires that you mitigate that
vulnerability within 30 days and that will likely require that you
deploy a new kernel binary.

So it would be useful if the FIPS module doesn't need to change when
your FEDRAMP certification officer requires that you update the
kernel, and if the FIPS module is "the whole kernel", addressing the
high-severity CVE would break the FIPS certification.  So it really is
much better if you can decouple the FIPS module from the rest of the
kernel, since otherwise the FIPS certification mandate and the FEDRAMP
certification mandate could put you in a very uncomfortable place.

It's also why historically many companies who need to provide FIPS
certification will carefully architect their solution so it is only
dependent on userspace crypto.  A number of years ago, I was involved
in a project at a former employer where we separated the crypto core
of the OpenSSL library from the rest of OpenSSL, so that when there
was a buffer overrun in the ASN.1 DER decoding of a certificate (for
example), we could fix it without breaking the FIPS certification of
the crypto core.  And we didn't even *consider* trying add a kernel
crypto dependency.

One of the important things to remember is that as far as FIPS
certification is concerned, the existence of remote privilege attacks
don't matter, so long as you meet all of the FIPS certification
security theatre.  But in the real world, you really want to fix high
severity CVE's....

Cheers,

					- Ted
