Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B7F34BA4C
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 04:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758169025; cv=none; b=laWOjJEmwlFSGATga+VMp4gHwwGxUjtwvOopDZ2EiqDq+uE8D0WSjq3CZFalYxvc3P8mmGdlg3WmQEE06QsXIQ+K8RqRp9eFo8PLSvBE7Bp2bdPebK3rhEHIPCViC14DA7EBOyCskH5CsFMMKm+tkSwRYqZxs/ZP9CJVzEniqVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758169025; c=relaxed/simple;
	bh=un0eryUDfdE+vtNzeo+A6VVuUep6IhG+gpDfMEq0++A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A30zgT97s5n6+4Ede6JskVIIBsQL9iNsd7BuIBiUgKNYhfQUwHWmPTF7nmlSKuA0dTHN/CB3E9KR/VwomfBREMbEctD6zbQsY6HJjZhiRaDVXBsSosZUvCVR1fi454MnO2lGoSdYdKx6ZUWciNm1LT3DMYOYHBMBv8zNy3G9qAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTGXBKVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTGXBKVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2925C4CEE7;
	Thu, 18 Sep 2025 04:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758169025;
	bh=un0eryUDfdE+vtNzeo+A6VVuUep6IhG+gpDfMEq0++A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hTGXBKVxAX6ji0IAgiIXxLUfZt482wBmWdxx05pXPmHtT93NTx/hZcYlzFLASdfjN
	 BCDXa0dx2J9V0NCvKaPRCBKTjRW8LqrWaClO7ScrfUnV77cdlAt+J7tnx8+PTbj8AS
	 c6rRAXuw+OqQ0dbQDFSTPnqUkBxTpE7Zzci8jiH28Fv4l6LqDsJikcww9PbBFyxU7X
	 +GF517yIugianwjjMBAN53WzS+xtnPHfPAepA2x2VRv7lGwjvWLI+2GoqyhYVbYZ+4
	 UYpnWZi5mq/5soHOpiUPHKZFu34PgJ1jJdxlVYWoxxtiGrpA9Mp+Wj9HGMmArQa09t
	 vNsCrAZLzUyXw==
Date: Wed, 17 Sep 2025 23:17:02 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org
Subject: Re: SHAKE256 support
Message-ID: <20250918041702.GA12019@quark>
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
> Hi Eric, David,
> 
> On 9/17/25 1:48 PM, Eric Biggers wrote:
> > On Wed, Sep 17, 2025 at 05:20:43PM +0100, David Howells wrote:
> > 
> > > For FIPS compliance, IIRC, you *have* to run tests on the algorithms,
> > > so wouldn't using kunit just be a waste of resources?
> > The lib/crypto/ KUnit tests are real tests, which thoroughly test each
> > algorithm.  This includes computing thousands of hashes for each hash
> > algorithm, for example.
> > 
> > FIPS pre-operational self-testing, if and when it is required, would be
> > a completely different thing.  For example, FIPS often requires only a
> > single test (with a single call to the algorithm) per algorithm.  Refer
> > to section 10.3.A of "Implementation Guidance for FIPS 140-3 and the
> > Cryptographic Module Validation Program"
> > (https://csrc.nist.gov/csrc/media/Projects/cryptographic-module-validation-program/documents/fips%20140-3/FIPS%20140-3%20IG.pdf)
> > 
> > Of course, so far the people doing FIPS certification of the whole
> > kernel haven't actually cared about FIPS pre-operational self-tests for
> > the library functions.  lib/ has had SHA-1 support since 2005, for
> > example, and it's never had a FIPS pre-operational self-test.
> I'm not too familiar with the history of lib/crypto/, but I have noticed
> over the past months that there has been a noticeable shift to moving
> in-kernel users from the kernel crypto API to the library APIs. While this
> seems to be an overall improvement, it does make FIPS compliance more
> challenging. If the kernel crypto API is the only user of lib/crypto/, it is
> possible to make an argument that the testmgr.c self-tests cover the
> lib/crypto/ implementations (since those would be called at some point).
> However since other code is now calling lib/crypto/ directly, that
> assumption may no longer hold.
> > 
> > *If* that's changing and the people doing FIPS certifications of the
> > whole kernel have decided that the library functions actually need FIPS
> > pre-operational self-tests after all, that's fine.
> 
> Currently I don't see how direct users of the lib/crypto/ APIs can be FIPS
> compliant; self-tests are only one of the requirements that are not
> implemented. It would be one of the more straightforward requirements to
> implement though, if this is something the kernel project would accept at
> that (lib/crypto/) layer.

If you find that something specific you need is missing, then send a
patch, with a real justification.  Vague concerns about unspecified
"requirements" aren't very helpful.

- Eric
