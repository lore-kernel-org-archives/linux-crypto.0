Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5B832AAD6;
	Thu, 23 Jul 2026 14:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816350; cv=none; b=LJcYF1h+AzJ3X2MGaMO8Co4Nc4eYA20Bi3k6EoSWejV71Bht/KNJMbu4rL7GhtOD6znkmxc2r7UF1kFkHhR4U3aI8J0UljaaBP8pCNhD6+wmdGxgWs0on4DRCg8MoUDOL6iA0yevK4bvrXHT3NSaKSh2Z/KBi7UCsWOPGOGtZ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816350; c=relaxed/simple;
	bh=jSdgsNJJxaaskd+7HZ9QI8UOuyGaABueiVAjfCeVe5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FstaRnWNSlyqYNnzzuMr10onIJWdZTdZ2h6yBIGvTXnjkpHXZjjZgpqtBvQdKBH+dxhIUcyMfqXju8i/IRnuHLYxCjKCxoQhhJK1wOToL0FOry24K5SyuxYk6CCDu6EgULz6KHK/qeQ2VuwlhcNOI5NVZslWbg8b8/D8e3e6+L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1901F000E9;
	Thu, 23 Jul 2026 14:19:07 +0000 (UTC)
Date: Thu, 23 Jul 2026 07:17:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Demi Marie Obenour <demiobenour@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
Message-ID: <20260723141701.GA1900@sol>
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <alnlaCXmoLRAlr96@gondor.apana.org.au>
 <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>
 <c826b73d-6307-4237-a065-b7a8487350ce@gmail.com>
 <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>
 <20260722162040.GC2794619@google.com>
 <CAMRc=McTUmyCNvW6qECR4rnVQNLAWLnOr8+fdcZEyDfKESifHw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=McTUmyCNvW6qECR4rnVQNLAWLnOr8+fdcZEyDfKESifHw@mail.gmail.com>

On Thu, Jul 23, 2026 at 02:44:27AM -0700, Bartosz Golaszewski wrote:
> On Wed, 22 Jul 2026 18:20:40 +0200, Eric Biggers <ebiggers@kernel.org> said:
> > On Wed, Jul 22, 2026 at 01:33:51AM -0700, Bartosz Golaszewski wrote:
> >> > Also, what can the current driver do that cannot be done better using
> >> > software crypto?  I understand that you have future plans to add more
> >> > features to the driver, but those are not relevant to this discussion.
> >> >
> >>
> >> We can offload crypto operations to the QCE saving CPU cycles but more
> >> importantly, the QCE provides HW based isolation which some vendors care
> >> about.
> >
> > Do you have any concrete proof of anyone using this with a specific
> > Linux kernel feature and actually getting a benefit from it?
> >
> 
> I'm not required to produce a proof of Qualcomm's clients using it. That's
> never been a requirement to keep a driver in mainline. I'm saying that Qualcomm
> wants to keep it and I've stepped up to fix and maintain it, which is what I'm
> doing.
> 
> But yes, I know about companies that do use this driver as is for whatever
> reasons. I'm not sure I can mention them so I won't.

I know that it's enabled in the defconfig and Qualcomm's BSP, so some
people have the module loaded on their systems.  That doesn't count as
use, let alone it being useful.

I'm not asking for a client name or any confidential information.  This
is a technical discussion, and I'm asking for proof that this driver can
actually provide a benefit for any specific Linux kernel feature over
the widely used and well-vetted alternatives (ICE and ARMv8 CE).

"We want this upstream for reasons that we refuse to disclose" is never
a reason for adding (or keeping) code in Linux.  There has to be a
technical justification.

Meanwhile, the strong technical arguments in favor of removal or marking
it BROKEN that have been presented remain unaddressed.

- Eric
