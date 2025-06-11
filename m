Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFD620127D;
	Wed, 11 Jun 2025 19:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749668700; cv=none; b=Rm6+FPnVfy8Cd/1HZvgHOcq7z8Gaagw8K53o3zM7YCq005qfO1Ae48E4XPxEAH4TwrO9K/SVQ9w7POce+RtfudduFzToHCqIHXG0qQPWppGVoLjNXUBzGUw4sWcnCdw9ivAECcfFXjGUI+zrrBZtKCxL2+7M0JEdPF3GX1F5LQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749668700; c=relaxed/simple;
	bh=icZWZbeICgE88YiKrti132QlDFdl7tW9WpDg51w0jtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l//ya4T4ph4LsK6r8IzyECEk7/MZEX3VveQFZh1cYxFD8HTg4Xm/HRR1JWQNY21ckMOVCqLJdYqtsgTbRFgNbwTt/SmWwsJTO4+WaznWjJDMUuPFWtTLez61qemY1Z68elZHkbKH/C1X3ZWBz5p+A3B8bripTWqTzV0BHgrm3uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dRo93oQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dRo93oQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AABC4CEE3;
	Wed, 11 Jun 2025 19:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749668700;
	bh=icZWZbeICgE88YiKrti132QlDFdl7tW9WpDg51w0jtM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dRo93oQwuzbVL+tUCDJOLtfcv2lLvUKFV1Cjf4ohjdd4T2CT2xZSiLLZWmg8KNg9M
	 KRnhx3MAKKIXMpWjzpO9S5BWSZF7F//HmHCm3r2nLZaK39ry7+aa4jvybsg5YJTXke
	 eiSWPOdtumLRkmJopSE9/GXdUxab1y8m0yr2yBA8sVvoYhem61hYlbEUXqQnybEC0B
	 dasPxxQqQEFqCapIYsc1XgT3xukW0GS1qorgV0jS8fYbV6Yn1M1S4GztndYBdXk0EF
	 JiqM5QpS82kzZv30MWc1/YLi7Tn/UpByjABvP/2jU/qPT1VYlehJM8EhNDwUCs4hzI
	 EpjuvMes8i5Og==
Date: Wed, 11 Jun 2025 19:04:58 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Diederik de Haas <didi.debian@cknow.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: testmgr - reinstate kconfig support for fast
 tests only
Message-ID: <20250611190458.GA4097002@google.com>
References: <20250611175525.42516-1-ebiggers@kernel.org>
 <DAJXJHLY2ITB.3IBN23DX0RO4Z@cknow.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DAJXJHLY2ITB.3IBN23DX0RO4Z@cknow.org>

On Wed, Jun 11, 2025 at 08:53:17PM +0200, Diederik de Haas wrote:
> I was about to respond to your reply, but I guess this may be a better
> fit for it. The TL;DR: version is this:
> 
> If you think distros shouldn't enable it, as you initially clearly
> described and it seems to me you still think so, the right thing for
> distros to do, is to disable those test. Which in turn means the fast
> tests should not be reinstated (?).
> 
> On Wed Jun 11, 2025 at 7:55 PM CEST, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Commit 698de822780f ("crypto: testmgr - make it easier to enable the
> > full set of tests") removed support for building kernels that run only
> > the "fast" set of crypto self-tests by default.  This assumed that
> > nearly everyone actually wanted the full set of tests, *if* they had
> > already chosen to enable the tests at all.
> >
> > Unfortunately, it turns out that both Debian and Fedora have the crypto
> > self-tests enabled in their production kernels, and they seem to want to
> 
> I explicitly referenced https://bugs.debian.org/599441 as that was the
> only justification I found for enabling it.
> In it, on 2010-10-07 "Mario 'BitKoenig' Holbe" said:
> 
>   I personally think (re)enabling these tests would be a way safer
>   default for a distribution kernel which runs on lots of different
>   hardware setups
> 
> Before I looked up that bug, I had not heard of that person, so I don't
> know if they're a crypto expert or just a random person on the internet.
> It also doesn't say *why* they thought it would be a good idea to enable
> those tests.
> I have no idea what Fedora's reasoning was for enabling it. Maybe their
> reasons were sound; I think Debian's are rather thin (that I could
> find). And from ~ 15 years ago.
> 
> > keep them enabled.  The full set of tests isn't great for that, since
> 
> I think the 'new' description is(/was) great. A subject matter expert
> says/said "don't enable this on production kernels". I wish all Kconfig
> help texts were this clear :-)
> So based on the previous description, it seems wise that Debian (and
> Fedora) would update their kernel config and disable those test.
> 
> In *my* update to 6.16-rc1, I only 'converted' to new names.
> A change to my kernel config (ie disable the tests) would be in a
> separate commit (with an appropriate commit msg).
> I hadn't done that yet as I was curious what the results would be.
> 
> So "they seem to want to keep them enabled" seems a premature
> conclusion; at least wrt Debian and AFAICT.
> It's also possible that if/when people see the kernel warning, they'd
> file a new Debian bug to have it disabled.
> 
> (I've made some contributions in the past, but) I am not part of
> Debian's kernel team, so I don't know what they will decide.
>  
> I'll gladly leave it up to you if you still think reinstating the fast
> tests is worth it, but I felt a bit more context was warranted.
> 
> Cheers,
>   Diederik

I mean, not enabling the tests in production is how it should be.

But Fedora already enabled CRYPTO_SELFTESTS, apparently because of FIPS
(https://gitlab.com/cki-project/kernel-ark/-/merge_requests/3886).

You're right there doesn't seem to be an up-to-date bug for Debian
(https://bugs.debian.org/599441 is old), so maybe my conclusion is premature.

However, besides FIPS I think the problem is that the crypto/ philosophy is to
throw untested and broken hardware drivers over the wall at users.  As long as
that's the case, the self-tests do actually have some value in protecting users
from those drivers, even though that's not how it should be.

- Eric
