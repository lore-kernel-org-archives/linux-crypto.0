Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45B9345CCE;
	Mon, 27 Jul 2026 23:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785195653; cv=none; b=mmNvYj2m6dz/+6zKqUTf5vKsN0FZa0TPOpOQTWFQ5egzKK/VeZ1Cb0eY86/thMcFuofpUZxC5udVCVg4AJuvgMu0MUiauR4yIj7miABusRnOzQbWLJ/q8wZ1kQOWBzDmSHKTJa/RkvUxHPJfpC3sxYPHrSH57jJf2vuBKHoHzxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785195653; c=relaxed/simple;
	bh=EAeQaVCZoyYBBbBb7GlL9KLXJcDEZbsSwPyFx4TdMZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXqSIe/9pEFc3FX9Bjbgik7565ucQ8pYoYnIv3cCuUkQEAu4noyP4Oow+g8XmbNjktnLBFXrChovMvxtiBxSJOy4zGUIlUy9GHFNZOlIV0t1v52OwSxE4kCJ6nPyl+bVzN1WoAeAgfOYBeWJVGwYFj+JsMZUrXhDQps8P9tjQG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=EEIsbV8Z; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="EEIsbV8Z"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 3332B14C2D6;
	Tue, 28 Jul 2026 01:40:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1785195637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lMlWo5how2yP2LkX157nvL7ML7A/giyuGrY1FbX3qag=;
	b=EEIsbV8Zsc85N25iSg5NAjJ1Pn5rviuilE44H62DMYuVTaydPNt6SrcClH0GjyAWnvskaN
	3MXQMbeOSm4bgfRN4PlXSj23BGYEJk9jfKt7MJfXFzVWe77ung/6s+WsHPL7Hsl9zgheF6
	zDsnJEaqwtbDFPyNo+KsHENIlJ6Qn3j35SshIImCrq1JXbyn/DQbx2z5q7Rhp6VV7ze4eL
	I7ThghcMwaGvXuOb0LAFyX4l3GIqgci4W5YKp7aSg2EdNQfqtgUZR551yUCXuOrgmevUHu
	GM4xlJY2O6Fqq04lTPcTux5jy6cE+0KZk14Pqf8MXgnM5nklK3Q+IS+hxGv3bQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 4565e1af;
	Mon, 27 Jul 2026 23:40:27 +0000 (UTC)
Date: Tue, 28 Jul 2026 08:40:12 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Demi Marie Obenour <demiobenour@gmail.com>,
	Harald Freudenberger <freude@linux.ibm.com>, acme@kernel.org,
	adrian.hunter@intel.com, alexander.shishkin@linux.intel.com,
	ardb@kernel.org, axboe@kernel.dk, corbet@lwn.net,
	davem@davemloft.net, edumazet@google.com,
	herbert@gondor.apana.org.au, horms@kernel.org,
	io-uring@vger.kernel.org, irogers@google.com,
	james.clark@linaro.org, jolsa@kernel.org, kuba@kernel.org,
	kuniyu@google.com, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
	mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, peterz@infradead.org, skhan@linuxfoundation.org,
	willemb@google.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
Message-ID: <amfsXHoeOH71b1Bs@codewreck.org>
References: <0ccda05f-077c-4661-b852-e6bf9bf40be3@gmail.com>
 <20260724180951.GA1572592@google.com>
 <amRntEmCUK-8wXcw@codewreck.org>
 <20260725174903.GA150173@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260725174903.GA150173@quark>

Eric Biggers wrote on Sat, Jul 25, 2026 at 10:49:03AM -0700:
> > "Inline crypto engine" seems to be a qualcomm marketing term, but from
> > looking at their doc the API seems to be PKCS#11 smart card?
> > Having worked on these for some other hardware I can't say I find it
> > easier to use than af alg, but it's definitely something that can be
> > worked out.
> 
> I guess I should have written "inline encryption hardware", which is the
> vendor-independent term we've been using in the kernel, just in case
> anyone thinks "inline crypto engine" means the "Qualcomm Inline Crypto
> Engine" specifically (but really, IMO they are just descriptive phrases
> that mean the same thing).  There are many different hardware vendors
> that have inline encryption hardware for UFS and/or eMMC.
>
> Their interface is quite simple and doesn't use PKCS#11 at all.  I don't
> know where you're seeing anything about PKCS#11.

PKCS#11 is something I (wrongly) picked up from Qualcomm doc here:
https://docs.qualcomm.com/doc/80-70018-11/topic/key-management.html#key-management

But honestly I hadn't read up all that much, and I had been confused as
the previous page talked about their inline crypto engine but this seems
to be more general.
It's been a busy weekend/week/month/year...

> See also the documentation in Documentation/block/inline-encryption.rst

Thanks for this pointer as well; this is much more clear to me, and also
seems to cover keys generated directly on hardware that are not
accessible so it pretty much covers what we're doing manually as well
(once I finally realized that this sits on the SoC side, not the
UFS/eMMC side, as key generation didn't make sense there)

> > I was just curious about the double-take approach taken with these two patches:
> >  crypto: af_alg - Drop support for off-CPU cryptography (this)
> >  crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1 ([4])
> > [4] https://lore.kernel.org/linux-crypto/20260622234803.6982-1-ebiggers@kernel.org/T/#u
> > 
> > I assume part of it was just that the whitelist wasn't ready yet when
> > this patch was merged, but as far as I understand if the whitelist
> > sysctl is implemented this is basically noop?
> > (Well, I guess it'll allow code simplification over time, but these
> > hopefully won't be backported to stable kernels too aggressively.. While
> > I fully expect to see this "Drop support for off-CPU crypto" patch to
> > show up in a couple of weeks in older stable trees; and for practical
> > purposes I don't see much way around just reverting it for now)
> 
> Neither of these patches is tagged with 'Cc stable', and I don't expect
> them to be backported to stable kernels soon.  That being said, it seems
> the people using LLMs to find vulnerabilities haven't focused much on
> drivers/crypto/ yet.  Once they do, well, they will of course find
> vulnerabilities everywhere (accessible from unprivileged userspace via
> AF_ALG), and when that happens there may be little choice.

From my 9p maintainer hat I see plenty of patches without 'Cc stable'
get backported every merge window, but this is a potential breakage so
I guess it might not have made it (my patches merged in v7.2-rc1 (same
time as this) were backported last week)

I generally agree with your assessement of vulnerabilities everywhere so
would have expected it to make the cut, time will tell.

> The addition of the af_alg_restrict sysctl (and the possibility of
> userspace explicitly choosing to disable restrictions by setting
> af_alg_restrict=0) doesn't necessarily mean that problematic
> functionality should be, or should have been, moved under
> af_alg_restrict=0 rather than removed outright.  It's just an option
> that can be used if needed for compatibility reasons, if actual user
> reports come in.  If something is not needed at all it can just be
> dropped right away.  This actually happens way more often than people
> might think, due to the immense amount of unnecessary functionality that
> AF_ALG has: *many* crypto algorithms have been removed from AF_ALG over
> the years without any complaints, since they were never used.

Right, I can definitely relate to this, and it's hard to know who
actually uses what especially when vendors add their own sauce on top of
it and don't seem to bother about updating much...

> I'll also note that hardware crypto "decelerator" driver authors are
> actually now *depending* on the drivers no longer being usable from
> AF_ALG in mainline in order to argue for more relaxed driver inclusion
> criteria.  I don't think they can have it both ways!

FWIW I'm not affiliated with NXP or any SoC vendor (we're making
embedded boards and providing an OS for it); I'm just bouncing around
between a rock and a hard place trying to ensure my users can keep
updating their kernel without losing access to their data :)

The discussion has been enlightening anyway, and thanks to Richard I've
seen a way forward if we get a backport (or even possibly even move
forward with it ahead of stable), it's appreciated.

Thanks again,
-- 
Dominique Martinet
