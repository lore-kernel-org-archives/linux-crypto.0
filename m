Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243493B5F63;
	Thu, 23 Jul 2026 20:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840287; cv=none; b=aEupmTX9HOw4iCf+MtsaVPF0aop5HbpBwL7uTd7ZKzvKwnozIUKTFwj5rQcLtBtwoc96ifAuzvcCt4HduWp/rteL3fvf2yODmX3BfV2zFkrQV/qGppuwM7udKCDbfG+wppgwePJiJWiFaNm6qncOOt3vs8BuLdrXB2dDn1Xw4Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840287; c=relaxed/simple;
	bh=Uc91U2u3MmJKNQxcJJKd8JWS+yp0kk5UXxUN4jjm5E4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCaGU97h1puPlS0ifp+M99vvN7s2nOBtM2X3uecfkmHQ3p9azsuRdyyuOZvQaR9/v1iAyF7jPNzNGI+vbLy4UZsN+z5MixG9JBlLVnfvji6vFlxhoajBf90B+K/OH+neQ2Xfble/wmQH8XjbfkLnHvng+9JafohYdy86pf7FkJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjKsqFiy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WjKsqFiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F4E1F000E9;
	Thu, 23 Jul 2026 20:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840282;
	bh=tZ4UC4VbZCHqoMOFQEdA0u1m0edMr6jn5b+MAr7qLDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WjKsqFiyWyVNVr1u8oQ1Oc3mPQcMgabY7n1PBmGT8va7RchFKB2VQAZDidON0Nlwt
	 jl87ijZbKh+aQuTj0p+HzFkTbT8ZkzZ6aT/F+674z1Nwem7L7xWd7/jvUUxSzLBELI
	 TtgYn5hNmyfIcQ1zrrBvBeKVp5VN15gRypXmZy9jrkdfa0RxByTwfDt1MbxvD5dkve
	 nuL9+cGqwdkHlF0YxXvnltMMMgwm2mmXWeIihkUgTcPhXZumttiP1GnM6Gwbw4DBgs
	 UEBmTaVl/3/qE5fYA04HjeLSvW9PaImHimnPIWDch6vxZyYHF0G+YnWqtYceZF/KAw
	 xuTek7uVUKe0A==
Date: Thu, 23 Jul 2026 13:58:01 -0700
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
Message-ID: <20260723205801.GD110634@quark>
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <alnlaCXmoLRAlr96@gondor.apana.org.au>
 <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>
 <c826b73d-6307-4237-a065-b7a8487350ce@gmail.com>
 <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>
 <20260722162040.GC2794619@google.com>
 <CAMRc=McTUmyCNvW6qECR4rnVQNLAWLnOr8+fdcZEyDfKESifHw@mail.gmail.com>
 <20260723141701.GA1900@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723141701.GA1900@sol>

On Thu, Jul 23, 2026 at 07:17:19AM -0700, Eric Biggers wrote:
> On Thu, Jul 23, 2026 at 02:44:27AM -0700, Bartosz Golaszewski wrote:
> > On Wed, 22 Jul 2026 18:20:40 +0200, Eric Biggers <ebiggers@kernel.org> said:
> > > On Wed, Jul 22, 2026 at 01:33:51AM -0700, Bartosz Golaszewski wrote:
> > >> > Also, what can the current driver do that cannot be done better using
> > >> > software crypto?  I understand that you have future plans to add more
> > >> > features to the driver, but those are not relevant to this discussion.
> > >> >
> > >>
> > >> We can offload crypto operations to the QCE saving CPU cycles but more
> > >> importantly, the QCE provides HW based isolation which some vendors care
> > >> about.
> > >
> > > Do you have any concrete proof of anyone using this with a specific
> > > Linux kernel feature and actually getting a benefit from it?
> > >
> > 
> > I'm not required to produce a proof of Qualcomm's clients using it. That's
> > never been a requirement to keep a driver in mainline. I'm saying that Qualcomm
> > wants to keep it and I've stepped up to fix and maintain it, which is what I'm
> > doing.
> > 
> > But yes, I know about companies that do use this driver as is for whatever
> > reasons. I'm not sure I can mention them so I won't.
> 
> I know that it's enabled in the defconfig and Qualcomm's BSP, so some
> people have the module loaded on their systems.  That doesn't count as
> use, let alone it being useful.
> 
> I'm not asking for a client name or any confidential information.  This
> is a technical discussion, and I'm asking for proof that this driver can
> actually provide a benefit for any specific Linux kernel feature over
> the widely used and well-vetted alternatives (ICE and ARMv8 CE).
> 
> "We want this upstream for reasons that we refuse to disclose" is never
> a reason for adding (or keeping) code in Linux.  There has to be a
> technical justification.
> 
> Meanwhile, the strong technical arguments in favor of removal or marking
> it BROKEN that have been presented remain unaddressed.

FYI, I took some time to take a closer look at this driver, and I found
a bunch more bugs:

- https://lore.kernel.org/linux-crypto/20260723183438.GB93534@quark/
- https://lore.kernel.org/linux-crypto/20260723192514.GA110634@quark/
- https://lore.kernel.org/linux-crypto/20260723202704.GB110634@quark/
- https://lore.kernel.org/linux-crypto/20260723205342.GC110634@quark/

Overall, I think this demotion is extraordinarily well justified.

The pending fixes for some bugs don't change the big picture.  In fact,
the introduction of BAM locking seems likely to exacerbate the
performance issues.

It would not be responsible to defer to the hardware vendor here.  The
community has a responsibility to uphold high technical standards,
especially for cryptography.

- Eric
