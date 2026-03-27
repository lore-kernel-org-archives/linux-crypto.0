Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419DF3FA5D7;
	Fri, 27 Mar 2026 17:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632751; cv=none; b=b2CE3RppXor3Xnn44a/P0uEztu4Ptg4zLb44WS/T9kbAnmEX2hgVuekRp7L/pTW7wlZZWEV/1z41SaTduJ9roIpAL8RHAtBO8C6hVa6unTakb6Vk+DwDjV6dZLfayw+YJkb2tfu53ejW2iNDz2cAO78qkafUd6YVZQYoao3QUaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632751; c=relaxed/simple;
	bh=ydMb4+IQ+hhK/QaHD2SxsMw+W+OpnZiZISpWVGow/Qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=caYjlXEp1LNkujMiXFK+sL60LsofeJvq4QzC3qm8VljRWd32+5wUm65bxZjup6UB5C/ug+VhfI3uDj0APbbiquZMvbJiRCIaSQSa5syS1DDFfZMAC88SID0AQExsPsZyxgNurhzsSqnSZZLJJ3MNre8ZD1ceBShLdciAE6VqKUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cqOgLT4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cqOgLT4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8B8C19423;
	Fri, 27 Mar 2026 17:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774632751;
	bh=ydMb4+IQ+hhK/QaHD2SxsMw+W+OpnZiZISpWVGow/Qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cqOgLT4Vd1Gdqag5ixeksQVO/HJulYRVJ3W0IVg4L1TbEY4KqbnkipZ+repoMpY8V
	 SKlbB8yPMxVl6i2HbkNP3fACiJQVSZttDas0zigtaC7frMGoDH4FxIqICrgEbEmYc3
	 A7hnf6+3CPIR8Rir5nK/6JuBm09gvbENZ0WF76Tyz2SxwUm2jw/jelfznshH4b2Mak
	 8F+ZAAJnEc1pMVvtRB3wwYBXx2Qfb4n0KiLyPXNxO42F/aGbXeVEcRUQSIrDbt3/iK
	 Rzlrl3FRQxnPjsTsjAm1TQ5/7RZlXWILBGSOE364btN+nS6At371AlJqRm2zbXOrz5
	 iEth5MVwj9HLw==
Date: Fri, 27 Mar 2026 17:32:29 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>
Subject: Re: [PATCH 1/3] crypto: s390 - Remove des and des3_ede code
Message-ID: <20260327173229.GB3407398@google.com>
References: <20260326201246.57544-1-ebiggers@kernel.org>
 <20260326201246.57544-2-ebiggers@kernel.org>
 <65c3d229-57ee-4980-a13f-bc9661b4dda1@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65c3d229-57ee-4980-a13f-bc9661b4dda1@linux.ibm.com>

On Fri, Mar 27, 2026 at 09:52:31AM +0100, Holger Dengler wrote:
> Hi Eric,
> 
> On 26/03/2026 21:12, Eric Biggers wrote:
> > Since DES and Triple DES are obsolete, there is very little point in
> > maintining architecture-optimized code for them.  Remove it.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> 
> Are there plans to completely remove des/3des in-kernel crypto support from
> the kernel or is it just the arch-specific code, that is removed?

Just the arch-specific code for now.  It will just make these like RC4
and MD4 which are still implemented for compatibility reasons but only
with generic C code.  Someday (years from now) we should remove all of
these entirely, but for now the best we can hope for is simplifying the
implementations to just the generic C code.

- Eric
