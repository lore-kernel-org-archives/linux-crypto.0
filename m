Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E87C33343E;
	Mon, 20 Oct 2025 21:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760995261; cv=none; b=XuzIzrKWFlq4R5i+KS7JqnMfWhFB3vff8Ou1oHFMd+zLVUvp9craCMxsy+Tp+7iuEd5YsQUkiQ0s3FU42jwpAi33arBq2auIJaQApStVOFrcu2WYfPqefB83AIfqxZotomJJT2RM2F5wtZrzrSlHcmZQpCsgEB2jdk8yxlO5bKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760995261; c=relaxed/simple;
	bh=3iQtO3/kT4dQdze6I2jUqdxwmT21PUB21GiN34k5zuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b3irWKV4POzBmGaGeWyEwyycuC35tIj1yjOB1LBzH9zve7fUtUz8uizE9D0KmAwahZgnT+dAWWmxuJw7eG6JM6X2Uoq38nNevsS/L33OfvTQuUZX87IHoYmSwm6qVEP84wuSduxgTFSqXaucCX55hizeZZqjjLE8ugbiBiz/uGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJfb7Wcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJfb7Wcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A057C113D0;
	Mon, 20 Oct 2025 21:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760995260;
	bh=3iQtO3/kT4dQdze6I2jUqdxwmT21PUB21GiN34k5zuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LJfb7WcbHlUO2BEDHBsJR6EKLKqG8NPDzL40eClZQ5mz8tqWZx5RcwwnI1n3IcyP0
	 WPRp4LqWfpBNFglRnrGKQTS4c4yPJR04wJ4Tn8DRV69i+ZkbsNZBQm7euYWIuROI0C
	 4o6qHZev+N4/UEzpExWxC0g3XE3h8qjBi47xgpPW0O/lCPUHzY23ViHODapCdaxS6G
	 iBp+AKOEmDAIgL2tPols+oykkzqt7n9mCZWPJG+g/fy6DWsE404wLDETrKAckzb17T
	 aSZt6uA6cxVlKI8FzNqBBOisFSE45rydlnsxwzHudMQnmD+qJ1TjQLKqKV1jzty35J
	 gI2DZtm1pIZ8Q==
Date: Mon, 20 Oct 2025 21:20:57 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH 16/17] crypto: jitterentropy - use default sha3
 implementation
Message-ID: <20251020212057.GA83624@google.com>
References: <20251020005038.661542-17-ebiggers@kernel.org>
 <20251020005038.661542-1-ebiggers@kernel.org>
 <1062228.1760956530@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1062228.1760956530@warthog.procyon.org.uk>

On Mon, Oct 20, 2025 at 11:35:30AM +0100, David Howells wrote:
> Why don't you take my approach and just call lib/crypto/sha3 directly rather
> than using a crypto/ object as an intermediary if that crypto/ object is just
> going to wrap lib/crypto?

We'll do that, and thanks for writing the patch already!  But that's
something to do in a later patch after adding the library API.  Your
patch description kind of raised a red flag:

    Make the jitterentropy RNG use lib/crypto/sha3 rather than
    crypto/sha3.

    For some reason it goes absolutely wild if crypto/sha3 is
    reimplemented to use lib/crypto/sha3, but it's fine if it uses lib
    directly.

That implies that your changes broke crypto_shash, so you *had* to
convert to the library right away as a workaround for that.

That shouldn't be necessary.  We should generally keep crypto_shash
working for now.  In which case, all jitterentropy should need for now
is a simple substitution s/sha3-256-generic/sha3-256/.

We'll convert jitterentropy to use the library API too.  It's better,
after all.  But it should be done later and because the library API is
better -- not as some sort of workaround.

- Eric
