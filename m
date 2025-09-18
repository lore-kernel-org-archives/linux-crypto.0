Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FA91E8324
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 15:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758210811; cv=none; b=qH+nqR1dQLLd+BKg7kYnT30sY6kwSJv7z1EAH8cDvOtWRBI3QBtSNUuj5/BR0vJPtriytCQqsqlCoLyEUrwRT4ccPsPDmVasL+cH+2axycmeokCVJnroIamQx2Ia5Ciz5GK1xZxHNupFwIeVn4EKDHMBkLS/S/FzJ91Ghr9YWg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758210811; c=relaxed/simple;
	bh=bAWaP6BJQ6C68FCGqYEsxWNJUsx6q7XlO1a5+T9MKso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7ZKwL67LLxJtzbUccC/e3QFxICQNSEY5XzSZDJmkdEVsCNBajwYaOKi1EZFMBwIaINO/gvbqEpOBl3N1n/2KHJJHSSY4PNL/5W3J362Wr55Gp8nLntkqqRmd11nY+MmUh78+yn0EDVGtlJwiw06fsMx0BK8UCM2R7PT6iDL5/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C7Xg3yuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C7Xg3yuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421A0C4CEE7;
	Thu, 18 Sep 2025 15:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758210811;
	bh=bAWaP6BJQ6C68FCGqYEsxWNJUsx6q7XlO1a5+T9MKso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C7Xg3yuG37zOpeLXJwaQkBwYrWnxop/zhk/YwHLCxZO9eFLW2YHDphdm0cZHuWPnk
	 9MSQrQzGemu7S62atWdlihKFnW1/4O2yXS4npG0euAlKgt3Cv2C9zsDzQjy/X9abRa
	 Ve54Hd0jm9goU4xfuRhII3ByrjnXhyBBhF3blsZ0Jw2qi4zY98d9zLFtdsEQAs0DcN
	 93p48aCKIGodfVPJUsBnrCqpkJ8HEa1/sqx+sku+7JMSVcAKLse6cj4xi4qyn+OLNL
	 bUil9fkWeq+LjZXcK/zmPCqdA4ns0twrsnQBNr0hMnvaTFg2cb/JDBEr4PbRuYfpTM
	 HpJ0pZzR76RBw==
Date: Thu, 18 Sep 2025 10:53:27 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Simo Sorce <simo@redhat.com>
Cc: Joachim Vandersmissen <git@jvdsn.com>, dhowells@redhat.com,
	linux-crypto@vger.kernel.org
Subject: Re: SHAKE256 support
Message-ID: <20250918155327.GA1422@quark>
References: <20250915220727.GA286751@quark>
 <2767539.1757969506@warthog.procyon.org.uk>
 <2768235.1757970013@warthog.procyon.org.uk>
 <3226361.1758126043@warthog.procyon.org.uk>
 <20250917184856.GA2560@quark>
 <783702f5-4128-4299-996b-fe95efb49a4b@jvdsn.com>
 <20250918041702.GA12019@quark>
 <635d76553b73a2b004a447dcc7d680e0658689c9.camel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <635d76553b73a2b004a447dcc7d680e0658689c9.camel@redhat.com>

On Thu, Sep 18, 2025 at 09:37:45AM -0400, Simo Sorce wrote:
> On Wed, 2025-09-17 at 23:17 -0500, Eric Biggers wrote:
> > On Wed, Sep 17, 2025 at 10:53:12PM -0500, Joachim Vandersmissen wrote:
> > > Hi Eric, David,
> > > 
> > > On 9/17/25 1:48 PM, Eric Biggers wrote:
> > > > On Wed, Sep 17, 2025 at 05:20:43PM +0100, David Howells wrote:
> > > > 
> > > > > For FIPS compliance, IIRC, you *have* to run tests on the algorithms,
> > > > > so wouldn't using kunit just be a waste of resources?
> > > > The lib/crypto/ KUnit tests are real tests, which thoroughly test each
> > > > algorithm.  This includes computing thousands of hashes for each hash
> > > > algorithm, for example.
> > > > 
> > > > FIPS pre-operational self-testing, if and when it is required, would be
> > > > a completely different thing.  For example, FIPS often requires only a
> > > > single test (with a single call to the algorithm) per algorithm.  Refer
> > > > to section 10.3.A of "Implementation Guidance for FIPS 140-3 and the
> > > > Cryptographic Module Validation Program"
> > > > (https://csrc.nist.gov/csrc/media/Projects/cryptographic-module-validation-program/documents/fips%20140-3/FIPS%20140-3%20IG.pdf)
> > > > 
> > > > Of course, so far the people doing FIPS certification of the whole
> > > > kernel haven't actually cared about FIPS pre-operational self-tests for
> > > > the library functions.  lib/ has had SHA-1 support since 2005, for
> > > > example, and it's never had a FIPS pre-operational self-test.
> > > I'm not too familiar with the history of lib/crypto/, but I have noticed
> > > over the past months that there has been a noticeable shift to moving
> > > in-kernel users from the kernel crypto API to the library APIs. While this
> > > seems to be an overall improvement, it does make FIPS compliance more
> > > challenging. If the kernel crypto API is the only user of lib/crypto/, it is
> > > possible to make an argument that the testmgr.c self-tests cover the
> > > lib/crypto/ implementations (since those would be called at some point).
> > > However since other code is now calling lib/crypto/ directly, that
> > > assumption may no longer hold.
> > > > 
> > > > *If* that's changing and the people doing FIPS certifications of the
> > > > whole kernel have decided that the library functions actually need FIPS
> > > > pre-operational self-tests after all, that's fine.
> > > 
> > > Currently I don't see how direct users of the lib/crypto/ APIs can be FIPS
> > > compliant; self-tests are only one of the requirements that are not
> > > implemented. It would be one of the more straightforward requirements to
> > > implement though, if this is something the kernel project would accept at
> > > that (lib/crypto/) layer.
> > 
> > If you find that something specific you need is missing, then send a
> > patch, with a real justification.  Vague concerns about unspecified
> > "requirements" aren't very helpful.
> 
> Eric,
> as you well know writing patches does not come for free.
> 
> The questions here are:
> - Are you open to accept patches that enforce some behavior that is
> only useful for FIPS compliance?

As I said already: small patches that add pre-operational self-tests
would generally be fine, if they are shown to actually be needed and are
narrowly scoped to what is actually needed.  Is that what you're asking
about?  If not, please be specific about what you're asking about.

> Fundamentally people are asking in advance for guidance of what would
> be acceptable so that a patch submission wouldn't waste the submitter
> time writing it and your maintainer time reviewing it, if there is
> guidance that can be taken in account early on.
> 
> As you have seen recently in Oracle's submission some changes could be
> quite invasive, would you allow similar changes to what you've seen to
> that patchset to land directly in lib/crypto functions ?

That submission is an entirely different topic.  Obviously, a 100+ patch
series that re-architects the kernel is going to be more controversial
in the community than a patch that just adds a bit of logic, such as a
self-test, under 'if (fips_enabled)'.  But that is a different topic,
and it's unrelated to the current approach to FIPS that is (sort of)
supported by the upstream kernel.  If you would like to comment on that
patch series, perhaps you should respond to that thread and not some
unrelated thread?  This thread is supposed to be about SHAKE256 support.

- Eric
