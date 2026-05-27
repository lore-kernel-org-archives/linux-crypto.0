Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AFE270540;
	Wed, 27 May 2026 01:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779847156; cv=none; b=c30bvUVSJQExogr8oi10n1oAq8p665nYu8S17s0k5Vt+1/mt7SZugRwAq1gksZRIMS9ykXOeGteZ+jCds7YBgUx7NsKIOz9BYRxDcl6BxtCagQUJw/XJ2SIJmYjt/VJ5eA0bP8xex5jRisqQ5Nq9TyQo0uXvSmQ7zlVhMOrupEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779847156; c=relaxed/simple;
	bh=eWllbFtAbmZGiQ/zezYa16cTuTfKOwWk41taOwaxAoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWj0jSuGz4eyr+tbC8hmS4KxkxuIGolrl0uqlGRm2k1+53dMPKh75ojFKM2Za+kKyNq3eqoec7rBXnhUNUFNebTa2Zgaq6Fqzk4diaNaMI6srfcDYWHtakh/Naf3axoFmlS81eFYHAXeOCG2FD+et91Kgqutejb8/+2eb13boZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I44m3Yab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I44m3Yab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8273C1F000E9;
	Wed, 27 May 2026 01:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779847154;
	bh=HrrofRYL2z0dvHXeTssozkcKWCmca/7LdFgTt3bUbuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I44m3YabNCaRf9MGC3FNPgMBeFtRbN4RwifF5NdF7BB/kM6Wno628WXkP2BeocYmI
	 cn+efU01XGmaac1UWKDib1aBDzh3ItfnN3arln/LccUjG6A/t5TSYPA+IwOuQ3Kq3I
	 AQxR4OpCLVY3zdiA93tGhrXkhJ5Tt/vXsWw1mBUnX133HIyMDxl2XWYh4s3xTc4CRA
	 Vl0nWMg3Y5dtUTxjLuXMtSjHqnSLAb2dJUIpqnW6ZQIh5CHN0DwNLnJ/P+nWgdYi/e
	 fhRbEMjv17cRCIsAKyDzpwg5rRF8GxHTzfAffy/D0Pp0OjjaOEdfj3A+z+aI8Ly/RS
	 aa39Pu+XClZKQ==
Date: Tue, 26 May 2026 18:57:54 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Ard Biesheuvel <ardb@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-raid@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 7/8] lib/raid6: Include asm/neon-intrinsics.h rather than
 arm_neon.h
Message-ID: <20260527015754.GA13078@sol>
References: <20260422171655.3437334-10-ardb+git@google.com>
 <20260422171655.3437334-17-ardb+git@google.com>
 <20260423074712.GC31018@lst.de>
 <20260509202354.GD11883@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260509202354.GD11883@quark>

On Sat, May 09, 2026 at 01:23:54PM -0700, Eric Biggers wrote:
> On Thu, Apr 23, 2026 at 09:47:12AM +0200, Christoph Hellwig wrote:
> > On Wed, Apr 22, 2026 at 07:17:03PM +0200, Ard Biesheuvel wrote:
> > > From: Ard Biesheuvel <ardb@kernel.org>
> > > 
> > > arm_neon.h is a compiler header which needs some scaffolding to work
> > > correctly in the linux context, and so it is better not to include it
> > > directly. Both ARM and arm64 now provide asm/neon-intrinsics.h which
> > > takes care of this.
> > 
> > 
> > This could potentially clash with the raid6 library rework I'm doing
> > for 7.2. Although git has become pretty good about renamed files, so
> > maybe it won't be so bad.
> > 
> 
> I think this patch also breaks the userspace build of lib/raid6/.  Which
> is going away in Christoph's series anyway, but maybe it would make
> sense to drop this patch (and patch 8 which depends on this, I think)
> from this series for now?  That would make it a bit easier to take the
> rest through crc-next.

Ard, are you okay with me applying just patches 1-6 to crc-next?

- Eric
