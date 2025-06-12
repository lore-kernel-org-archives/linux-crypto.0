Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8D8279357;
	Thu, 12 Jun 2025 17:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749748832; cv=none; b=X/Sxj41yoGF4gRnZuqu4gsTIp+4UQPdlYdqkqtNov/2eOORKB44iF86tkK4PRFMme/9Zd+Md65uJGQDYOTec6YoTDL31TzZ8oXjqIzPl9umTP8LzYyXJuan+T0mLaUOoAZfIX7naTfA6u7fCd1L/hXeedwlGoTRrTjlxS1zowjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749748832; c=relaxed/simple;
	bh=Z35ja8EBivcrasZKeNZ2/xVs1hAiP7Al8xQLy8d6+lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9mIgR6wmZ/7ETFmyv5yEgCKVR26RGm1xsQ4uU1pO6AfVIr5oZ4lrfiVcx+DkLBKd/K7E/7nHpaBUJ0LzYks6RTBB2D+FpAgTHYPpqSFNnQTEYpb1RDgGsFdrjxsh0Zc/LEZxxr/8Opv/kAWnJ4t/7xLkY0n/+UrIrnk0VZHmbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MEVj6Uz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MEVj6Uz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB80EC4CEEA;
	Thu, 12 Jun 2025 17:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749748832;
	bh=Z35ja8EBivcrasZKeNZ2/xVs1hAiP7Al8xQLy8d6+lg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MEVj6Uz0MSwK2Anvuu/X9iu4ZWvOuJEQ/SrdgsUsuHn8ktNzNy7MnOFaryxvKg74w
	 srMyfrsdXWHfMsdW9oCiJn0KUS74wBjJ04oPBMMJDiG3rUEu4q26GNQplKlLIhGdYD
	 92ORO6igMUQcW2A5kT7X7sDhjAnF2DTyjU5mB83Lsch9ejiUMM9ACjhd0021VrKtf5
	 ZcVuM+BCWScPOVNNXgX4ZVZY+KeljCf0BNj/N1bxiJefEJrw/OeLKW2kvvx7DmSVXS
	 qkCuCm008PsdUKEfC0PrmFROZQj3lf89ZmCzor9Wj2Tg8S026Yc6KBSgBoYYTsBF5O
	 9Gyr7SKOMcizw==
Date: Thu, 12 Jun 2025 10:20:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Diederik de Haas <didi.debian@cknow.org>,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: testmgr - reinstate kconfig support for fast
 tests only
Message-ID: <20250612172005.GA1283@sol>
References: <20250611175525.42516-1-ebiggers@kernel.org>
 <aEpryXbiFJ5mmsvj@gondor.apana.org.au>
 <20250612060931.GA200686@sol>
 <aEqX53xTnGX2b9Gc@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEqX53xTnGX2b9Gc@gondor.apana.org.au>

On Thu, Jun 12, 2025 at 05:03:35PM +0800, Herbert Xu wrote:
> On Wed, Jun 11, 2025 at 11:09:31PM -0700, Eric Biggers wrote:
> >
> > It used to be:
> > 
> >     config CRYPTO_MANAGER_DISABLE_TESTS
> >             bool "Disable run-time self tests"
> >             default y
> >             help
> >               Disable run-time self tests that normally take place at
> >               algorithm registration.
> > 
> > So the CONFIG_EXPERT dependency for the prompt would be new.  Are you sure?
> 
> When this was inverted I specifically asked for a dependency
> on EXPERT so that normal users won't be bothered by a question
> that had no relevance to them.
> 
> You then suggested a dependency on DEBUG_KERNEL which I accepted
> because EXPERT happens to select that so they're practically
> equivalent.
> 
> So make it depend on either DEBUG_KERNEL or EXPERT because normal
> users should never see this question.  IOW we as developers should
> select a sane default, whatever that may be.
> 
> > If you insist.  I hoped to get the people working on drivers to actually run the
> > tests that they are supposed to.  The default y is appropriate for anyone
> > actually doing development and/or testing, which is what the tests are supposed
> > to be for.
> > 
> > But I guess that doesn't really happen, and distros are expected to run the
> > reduced set of tests in production because upstream doesn't test the drivers.
> > And they will want n here.
> 
> I share your concern.  One idea is to calculate a hash based on the
> current time and print it out if and only if SELFTESTS_FULL is enabled.
> 
> Then we could require all driver submissions to include this message
> as proof that they enabled this option.
> 

Crypto drivers need to be regularly tested and maintained, not just tested at
submission time.  Crypto drivers that don't achieve that should not be part of
the kernel.

- Eric
