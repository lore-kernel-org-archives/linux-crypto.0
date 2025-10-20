Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCAF2638BF;
	Mon, 20 Oct 2025 16:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760979571; cv=none; b=NZAMJ/vwXTIAn1bZBwQitUUP4I+vXS/Cii680o4alLh0U8c9VbJSEaykErWHp420B3y/8DMk5GMJHNfeS7+Q7aqkWJDStWCdlP8eDkeT+yHXP5stDEW8yFGXnwAaSyDqvPLYI+FCPnMVxwR3HLqQ7f9iWIRrDIMQFKbJRil0pAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760979571; c=relaxed/simple;
	bh=yQAFF8SAbn3GSlPbThC422AeuOlj4n5ubgneq1cvhko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OsTdvZsw0K3RxF+A0FI8nUoxhcJ+4+oUCiEKKve8kPKptUml31xUJTodwNAZPk8gUU93Sl8tooSGWnyI/tqZyllAItABtQFcqHEGXom96ET1+V7IexWHG99wkdSfazxhg2TAiUas8TAsU9W+SMLFk6+XOHFcigvG5FD4HhgPCMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTxUQe0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTxUQe0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024AEC4CEFE;
	Mon, 20 Oct 2025 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760979571;
	bh=yQAFF8SAbn3GSlPbThC422AeuOlj4n5ubgneq1cvhko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dTxUQe0UrDTOR7Uz+a83KiWBXl0m+haPoYKi6a/7jXLIVLcgAS0gZFtgAPIa6s+g6
	 n00tYfJgLDPZYrsZXkZqDmZw4VTL7NwXb2EBidA+r6OjtkcCeNH1FuGiHSFTMM2c8r
	 MuGqmY1KgBAswg43HxvSHPp7k2SxN6iYkEiO8QBU7IUAZSlYHSA3j7EJL5amNqk986
	 dRC2Clc2BO4X1KShQKxxUIK3dRlebfiuriUS6rdAZeU+x3xTMklX1g8GJOHRhn7JbK
	 oJbxblcLRDDbP7Y5XFzQo488RqP2K4KFUulGV2bVcrb09Yuw9DsGxvc+pBbfQvXp5k
	 erXwbmQBB7nZw==
Date: Mon, 20 Oct 2025 09:57:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH 0/8] VAES+AVX2 optimized implementation of AES-GCM
Message-ID: <20251020165758.GA1644@sol>
References: <20251014003123.GA2763@sol>
 <aPH9ZQP0m8Pq5Iy-@gondor.apana.org.au>
 <CAMj1kXGE6-xiUSyKa92=HWeywt=5-F2_G2H7V-UnVhKG65zwCA@mail.gmail.com>
 <20251017160437.GA1566@sol>
 <aPW2_B3utVHNxaEV@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPW2_B3utVHNxaEV@gondor.apana.org.au>

On Mon, Oct 20, 2025 at 12:13:48PM +0800, Herbert Xu wrote:
> On Fri, Oct 17, 2025 at 09:04:37AM -0700, Eric Biggers wrote:
> > 
> > Well, it seems you didn't read the patchset (even the cover letter) or
> > any of the replies to it.  So maybe I should just take it, as I already
> > said I preferred, and later did do since you hadn't said you wanted to
> > take it.  It would have been okay if you had volunteered to take this,
> > but you need to actually read the patches and replies.
> 
> The reason I didn't see your cover-letter is because you didn't send
> it to me.  Your To/CC list was:
> 
> To: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org,
> x86@kernel.org,
> Ard Biesheuvel <ardb@kernel.org>,
> "Jason A . Donenfeld" <Jason@zx2c4.com>,
> Eric Biggers <ebiggers@kernel.org>
> 
> So all I get is the patches without the cover letter.  Of course
> anybody who replies to the cover letter won't be visible to me
> either.
> 
> Please consider adding my email address to the Cc list next time.

Well, one would think you would be subscribed to linux-crypto.
But whatever, I'll Cc you explicitly on future patches.

> I will drop this patch-set.

Thanks,

- Eric
