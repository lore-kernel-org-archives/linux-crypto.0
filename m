Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A691E19D082;
	Mon,  9 Dec 2024 22:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733783065; cv=none; b=kbGjII/jw0LZn8LuU9/D+ucRec+ZCzQawxRfOvjdt/rvO/LTizE29jG8wVKu4E+YFlg5tPX3q+PBYypbNOoG2hZcX0+GHpTMerPdBmyAuAZVeHQ8v/rmMmEW1D6uV6u1gesJ1tJaOpAvtM9eaqEVeeWeWWwQbwzXENbUTf1rnAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733783065; c=relaxed/simple;
	bh=Bk/2N0FY+XurB3JIopKaZZSojcJTJwXmDVC2W5AtV+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ai3EJXHcM2EPAvXNHQB53GQTlZujOs2o3OoykP90w61fEXijRQ05zmFbCWPI77bX5kBasiVSvBIhK7GjfwS+Ta+UMsKU82pq3txCjij52zPgWJZtqiJtPzLhBjJb1JMzmG8re6p5vsBesY2yj5XdiR3Z1TSq4pYeWrvP9pqvUds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JMSttuLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JMSttuLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8031FC4CED1;
	Mon,  9 Dec 2024 22:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733783065;
	bh=Bk/2N0FY+XurB3JIopKaZZSojcJTJwXmDVC2W5AtV+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JMSttuLJIy6FMyIATxVEk3z1I5vI0pS35ZErRLIPJPvL1EoKFm146deghe+jywG1M
	 KCqT8qVzQ/HtmflDxFS3wmpZg9V8Wk11LmYqEw1ByPUjCXfArt4C+Xu1TT0dpj1C8D
	 cHCgwgDxucFS0e6JfqPLEmRtvi4/jLoosNKp95F/GUiLT0uJ+dQblKz5TT9IgVGlX1
	 pi+wQusJTEdg+iMboNVXSOZyjQ+WZR+9SUuxOJwfNx9aivuNbCtMK6sgNbw2hKr5Dd
	 SJLHDkeqX2intKBob8aOlFO9txRhGDZg0s9PIFoSEzCEHSsr46Vfci7kUw2LOER08h
	 fgkHviPSNof0A==
Date: Mon, 9 Dec 2024 15:24:20 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Yury Norov <yury.norov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-kernel@vger.kernel.org,
	briannorris@chromium.org, kees@kernel.org, gustavoars@kernel.org,
	steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	gjoyce@ibm.com, linux-crypto@vger.kernel.org, linux@weissschuh.net
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
Message-ID: <20241209222420.GA3596039@ax162>
References: <20241208161315.730138-1-nilay@linux.ibm.com>
 <2024120938-kilogram-granite-9a53@gregkh>
 <20241209200300.GB1597021@ax162>
 <Z1dWinzDPuC8iEXk@yury-ThinkPad>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1dWinzDPuC8iEXk@yury-ThinkPad>

On Mon, Dec 09, 2024 at 12:43:54PM -0800, Yury Norov wrote:
> On Mon, Dec 09, 2024 at 01:03:00PM -0700, Nathan Chancellor wrote:
> > Maybe people are not using CONFIG_WERROR=y and W=e when hitting this so
> > they do not notice? It also only became visible in 6.12 because of the
> > 'inline' -> '__always_inline' changes in bitmap.h and cpumask.h, since
> > prior to that, the size of the objects being passed to memcpy() were not
> > known, so FORTIFY could not catch them (another +1 for that change).
> 
> Thanks, but I'm actually not happy with that series (ab6b1010dab68f6d4).
> The original motivation was that one part of compiler decided to outline
> the pure wrappers or lightweight inline implementation for small bitmaps,
> like those fitting inside a machine word. 
> 
> After that, another part of compiler started complaining that outlined
> helpers mismatch the sections - .text and .init.data.

Not another part of the compiler but modpost, a kernel tool, started
complaining. If modpost could perform control flow analysis, it could
avoid false positives such as the one from ab6b1010dab68 by seeing more
of the callchain rather than just the outlined function being called
with a potentially discarded variable.

> (Not mentioning that the helpers were not designed to be real outlined
> functions, and doing that adds ~3k to kernel image.)

Isn't the point of '__always_inline' to convey this to the compiler? As
far as I understand it, the C standard permits the compiler is
completely free to ignore 'inline', which could happen for any number of
reasons, especially with code generation options such as the sanitizers
or other instrumentation. If you know that these functions need to be
inlined to generate better code but the compiler doesn't, why not tell
it?

> I don't like forcing compiler to do this or that, but in this case I
> just don't know how to teach it to outline the function twice, if it
> wants to do that. This should be done automatically, I guess...

I do not think that I understand what you are getting at or asking for
here, sorry. Are you saying you would expect the compiler to split
bitmap_and() into basically bitmap_and_small_const_nbits() and
__bitmap_and() then decide which to call in cpumask_and() based on the
condition of small_const_nbits(nbits) at a particular site? Isn't that
basically what we are allowing the compiler to figure out by always
inlining these functions into their call sites?

> Similarly, I don't know how to teach it to keep the functions inlined,
> other than forcing it to do so.

That's pretty much what '__always_inline' is, right? It's you as the
programmer saying "I know that this needs to be inlined for xyz reason
so I really need you to do it". Otherwise, you are just asking to tweak
a heuristic.

Cheers,
Nathan
