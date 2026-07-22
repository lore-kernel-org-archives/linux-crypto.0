Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34203546DF;
	Wed, 22 Jul 2026 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784732793; cv=none; b=WDyk4RpP2NUniWESVPANp7hta2c2UEJW0RvpTMUENOg7VN4TKLnaoav6It+CVdrhRy7+zD9YB57vWQWFI6B2sppnJex1MnHfmGGkbf9IBSnjA5YBpm+qK9x9FgJmlUE3KcONCCR8VqO1lkP22cdpsnLc9CFk3mCYwaZeeYQ9lko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784732793; c=relaxed/simple;
	bh=Fc3pEJ9K6f3ibtKiAVhXpW9/j5ViO9I+9F8cnBBr/Ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ntZz1UCAINAvx2BrWwipCNVfzy6Xmdb6ZVXFqbIF5wxPZJKtgRtFo7qLJBC9MrNyvItkql/4fjpflO0LxrliGBVodGMI5x3m59AI8Mmo+kF9coVFP6IK+FuxBQKZnUFDN1tNZ9tS/sgGl13uutYzHLTNwL9MzG/oiipnU8tTEZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=clMkFrzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clMkFrzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1191F000E9;
	Wed, 22 Jul 2026 15:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784732790;
	bh=IzL3po+fJJY/or4tXPwvY7zru9VVolWiiwzZ/KOwj6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=clMkFrzSNcH8aDQVAvq/ezHuG+a0nvv4C0ZCXI6qd7gfnjupsnAcASQV709vD6rir
	 rhPLyAvPzOQagezrNwYk8uJ9bqci8fvc38HAhXMrmlMo1eqs8xZL53SqD7E379JwZm
	 HkXQZeRmK1vuP13Ga85zRm8xlfyGx53KczgcoVT2S+kRSHpNQaLyk8tbdOwqZbDXzS
	 MWkRExDC19ncfDIExdSS6XQ3ydRG+n1r6obVjsPIbYdwmCZINWYRCHGwFXX41PxdFl
	 nk5FLKaF0QlWW4X0PLKbLkrxoV4cja1oqGY+8MYj8g0Lbv1I1fsjvILogdU9sE3oI8
	 n+k2uZ83qe9vw==
Date: Wed, 22 Jul 2026 15:06:29 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 06/13] lib/crypto: aes: Add GCM support
Message-ID: <20260722150629.GA2794619@google.com>
References: <20260715221153.246410-1-ebiggers@kernel.org>
 <20260715221153.246410-7-ebiggers@kernel.org>
 <ccaed4f3-a631-4d67-92ac-de9f1937e65c@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccaed4f3-a631-4d67-92ac-de9f1937e65c@redhat.com>

On Wed, Jul 22, 2026 at 01:02:46PM +0200, Thomas Huth wrote:
> > Initial test coverage is provided by the crypto_aead support added in a
> > later commit.  I'm planning a KUnit test suite as well.
> Sorry for asking ignorant questions, but which later commit is this? I
> couldn't spot it :-/

It's "crypto: aes - Add GCM support using library".  That adds a
"gcm(aes)" crypto_aead algorithm that is implemented on top of these new
AES-GCM library functions.  That makes it be tested by the self-tests in
crypto/testmgr.c when CONFIG_CRYPTO_SELFTESTS_FULL=y.

The KUnit test suite I haven't sent out, but I'm going to try to get out
in the next week or two.  I've just had a lot going on.

> Anyway, the previous AES-GCM code in lib/crypto/aesgcm.c featured some
> self-tests in libaesgcm_init() ... would it maybe make sense to add those
> here, too?

The crypto library uses KUnit tests, instead of ad-hoc tests run in the
initcalls (except for the minimal tests required by FIPS 140-3).  See
https://docs.kernel.org/crypto/libcrypto.html#testing

We could migrate the old libaesgcm_init() tests directly into a KUnit
test suite.  But I'd like to write something more complete that tests
the incremental API and various other aspects of the API too.

- Eric
