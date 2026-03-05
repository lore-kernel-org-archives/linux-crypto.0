Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1055E34D917
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 21:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772746820; cv=none; b=SSm1YxSp3E1mo1DSA0Yc+e6a7ZxrCeSc0gXODRWEmgASlFQK+bqmruv3hRrM7cnBkYUTL9E+gJ7xsjl/uc/Bv4BIziK4+xBzN/9gKDJYnRPmwhYZXecrqtwvkoSZJuVdCf3LiY0Tr3fZfMldKas0bRNtlN5jmumE4cwfu6uXy2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772746820; c=relaxed/simple;
	bh=78yC4UBP/i7ufA5zvLR9pcK6k+3a/SwCmKzs6gE0gTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+TjSzDqRQ+AURxUeb0I9jGzX51fLcG75rVI/a/JhCrmvNzbrgjXSxl4Los7KAr2CqDW7nTg4EFFVkuE0+f/neGW/BZL+MrGcwviIUyCv1BMiuY5SUhrc2Ktf7S8Gul6Al6mCRH+SrpheaFItYahgzixmgjI5K7ccFXxKIn1DX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPTNu80R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPTNu80R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F3DC116C6;
	Thu,  5 Mar 2026 21:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772746819;
	bh=78yC4UBP/i7ufA5zvLR9pcK6k+3a/SwCmKzs6gE0gTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JPTNu80R70wuMK6fQtGsEM7BGNoPIFxEfGgkInwVr/lv5gpf0fYB2npaCrndGPKNV
	 eZpDWRIyCLH4ZlQwvNK9c4nu7zZCBmggU5m9BxEL2StVUkK6C9a1aYjx1wTqrkVoKi
	 0dFxWUAYIhti5fzMJ/BsilKzG+tvtYa8RhA2ubIwsm+Wh30RSMPuggnnMMJFaSZA05
	 avMw8LGXHir873Dp16Gu0CwgX/wVc3Q+Fzehla9qhOqnVr2uGTHJFvr2DnzgHl+WFb
	 5qte9ZsBB6VDy1ZYS0FThwLypEaQph4lmwbiJRHSCpmBL/0Lsf9veXjfuFDjBiuMEq
	 tx+15eYBReMog==
Date: Thu, 5 Mar 2026 13:40:14 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: Re: [PATCH v3 0/5] pkcs7: better handling of signed attributes
Message-ID: <20260305214014.GB64054@quark>
References: <20260225211907.7368-1-James.Bottomley@HansenPartnership.com>
 <20260226021331.GA55502@quark>
 <3900433c727c1e7ab6e131003de7ca53bb0d23d1.camel@HansenPartnership.com>
 <20260305075511.GA155793@sol>
 <ba545f3db317ba3410b8fb9f5bab9e72be1854b6.camel@HansenPartnership.com>
 <20260305185156.GD2796@quark>
 <124016e6aa10434b73391cdccd95c69242f8e4de.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <124016e6aa10434b73391cdccd95c69242f8e4de.camel@HansenPartnership.com>

On Thu, Mar 05, 2026 at 03:18:09PM -0500, James Bottomley wrote:
> On Thu, 2026-03-05 at 10:51 -0800, Eric Biggers wrote:
> > On Thu, Mar 05, 2026 at 09:46:42AM -0500, James Bottomley wrote:
> > > On Wed, 2026-03-04 at 23:55 -0800, Eric Biggers wrote:
> > > > On Thu, Feb 26, 2026 at 07:43:54AM -0500, James Bottomley wrote:
> > > > > > If this is for some out-of-tree module, we don't do that.
> > > > > > 
> > > > > > I'll also note that we should generally be aiming to simplify
> > > > > > the PKCS#7 signature verification code, not making it even
> > > > > > more complex.
> > > > > 
> > > > > I'm fine with the general goal, but since the current code
> > > > > verifies the signature, pulls out the message hash and other
> > > > > attributes, compares the message against the MessageDigest one
> > > > > and then frees the whole structure it's a bit hard to see how
> > > > > the current goal can be achieved without extracting at least
> > > > > the first part of that
> > > > > ...
> > > > > but if you have   suggestion, I'm happy to implement.
> > > > 
> > > > Sure, just incorporate your auxiliary data into the actual
> > > > message being signed and verified.  Something like:
> > > >     
> > > >     program_len || program || hash*
> > > 
> > > We can't do that because the second hash is for the LSM.  If
> > > there's no LSM then we need the signature to pass the current eBPF
> > > signature check because the second hash will be verified by the
> > > loader, which means the program hash and nothing else must be in
> > > the messageDigest attr.
> > > 
> > 
> > Why does the loader need to verify the signature if the kernel has to
> > do it anyway, and why does the loader need to skip verifying the
> > maps?
> 
> Well, I didn't say kernel, I said LSM.  The problem is that the last
> hook in the LSM chain for eBPF loading occurs before the loader has
> actually run.  This means that either the LSM needs to be assured
> verification will complete (by running it itself), which is what the
> patch set I pointed to does; or that we need an additional verification
> hook in eBPF somewhere in the verifier after the loader has run, which
> the eBPF people are looking at but haven't actually found anything yet.
> 
> The OID helps the LSM do the additional verification without changing
> any of the eBPF loading flow.

LSMs are part of the kernel.

Not sure I follow.  How can the kernel verify something before it's been
loaded into the kernel?

- Eric
