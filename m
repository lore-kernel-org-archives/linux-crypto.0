Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF7A288C14
	for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 19:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758137312; cv=none; b=rBSINCw8Bce1CMNiyBJzhbN1Ax4Kh/cQVwsthUHifxl6ShLkffWFDtpesp3YsR2wLqCLe11j+S3sduDUp8NTrnlCCbXcV1oEGXQ7tvbNyWsjUVHrO/mp52HsInKoq+IoAuQ+kWrN4PmGRyb29e2KQiQ7RrQfQrP/e5raDEDJqFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758137312; c=relaxed/simple;
	bh=dzpO88qRdg3kzqzTfgdJdLtXQ9C8qKybAcx6MthfQ6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EgkO8KzoBwPxEqlNT+/GueYMcAic0U7PAmUp/sP1JbetXmfQKAEzRLuIhe4ARmQIUqiL19XaPSes5J+jFp39+pRE8rp+sQgT+MKWHWyvvkGGTVgeKHLCVVdGL72BIXOhKT6j8qfivmSJX1s9Lp+a9oowittKNZx6Gj2f5nllqb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYtnz2Ez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYtnz2Ez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB55C4CEE7;
	Wed, 17 Sep 2025 19:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758137312;
	bh=dzpO88qRdg3kzqzTfgdJdLtXQ9C8qKybAcx6MthfQ6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jYtnz2EzXsYLJ/R74JxALetg8U4bbZg2+C8OlOfIy0benrqsZaiJHBB0XwqqcCC6U
	 +ZiyMsMQE+ix25JcscLgSqCWuN3g/Zo7H4zgM7qqthQfO76i9gExEY/Ipwr2KQFNdB
	 FeeoaLJpnKvO4UFp/25QQa7ocv4JYu9aTaDZZJr+Qd3eTfnYCsBRHKA+9PbIedUZIZ
	 DkMtOYhthr1CZgXAHggUi6Ka+IW4aMxpQBmWE5UtwTr5mmbKdd3uUK9YH1iUpG3iSk
	 tt2BUpxLjv18kXAXbMHuNKEnoVBC7ElHmqYKj2oqPLqtolkdVtAIz+l/zWIjAEEzxv
	 32nIikVppYBZA==
Date: Wed, 17 Sep 2025 14:28:29 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: SHAKE256 support
Message-ID: <20250917192829.GA8743@quark>
References: <20250917184856.GA2560@quark>
 <20250915220727.GA286751@quark>
 <2767539.1757969506@warthog.procyon.org.uk>
 <2768235.1757970013@warthog.procyon.org.uk>
 <3226361.1758126043@warthog.procyon.org.uk>
 <3230006.1758136267@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3230006.1758136267@warthog.procyon.org.uk>

On Wed, Sep 17, 2025 at 08:11:07PM +0100, David Howells wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > On Wed, Sep 17, 2025 at 05:20:43PM +0100, David Howells wrote:
> > > Okay, I have lib/crypto/sha3 working.  One question though: why are the hash
> > > tests built as separate kunit modules rather than being built into the
> > > algorithm module init function and marked __init/__initdata?
> > 
> > KUnit is the standard way to do unit testing in the kernel these days.
> > The kernel community has been working on migrating legacy ad-hoc tests
> > over to KUnit.  This is not specific to lib/crypto/.
> 
> How do you test hashes with variable length digests (e.g. SHAKE128/256) using
> the hash testing infrastructure in lib/crypto/tests/?

Same as BLAKE2s
(https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/tree/lib/crypto/tests/blake2s_kunit.c?h=libcrypto-next).
Just choose a fixed output length to use with hash-test-template.h, and
instantiate those test cases.  Then also add additional test cases to
your *_kunit.c file that cover other output lengths.

If you'd like to refactor things so that some of the variable-length
output test logic can be shared between the BLAKE2s and SHAKE tests,
that is a possibility.  But I expect it wouldn't be worthwhile yet.

- Eric
