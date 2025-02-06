Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC77523534B;
	Thu,  6 Feb 2025 16:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738859988; cv=none; b=rmNN9voTsPmBQs6z/hCE5owsLKypjbFrmb/DI7Jw5nIexZncS1eUHlSv+difffbIJ2f93LTgCW4q0w1EU1z/LAfULUbffSXkKV0ku86T1ye7xiqjCjMLogDz+KlTdKnFl1GOrGmgioKR+HnQ/hgxCdk9W6ZYzLYeCdKSMzO5Cfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738859988; c=relaxed/simple;
	bh=xLQnkQf4tIg+jxmHo/0Rgb2os3dqBEC2f3c2XN1W6TQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q+D8KSe8hOsKV/TNC+51l+tLGS168eRPnoR9vWLQsr36HhuA39eDyyG2Ty1eHiqmQEdVmdXc95iQvT2XFLwhTmfwYqK0fzC6X8D2QzvDdVtitFqBwb9N/ZS51pvY+TvjtDuaH+6Ep78wpf3ooee9BTFS4PpPSMr8CNx8Iq7k1Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UE5nVtXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UE5nVtXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27875C4CEDD;
	Thu,  6 Feb 2025 16:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738859988;
	bh=xLQnkQf4tIg+jxmHo/0Rgb2os3dqBEC2f3c2XN1W6TQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UE5nVtXZUhxlnqCJ3cB55p249YgrJTEhsYSDKbwaFrwOsXT1peeaARzawIDby+ga2
	 fB46E+1FJxJDwcV6NlOEcnonT8/jgL8kVkteTT7MC8o3QQZ4+58hAoUqA+TOVOlyn8
	 dZ154pUOInSq8yP2RfDfn1N/z1g7fecvt0u00OEZ4GcgrYWTDOF0bmrt0gBjkJK5G3
	 c/xp2pXR6VnNryfkSZ1GSkREXP9jpEAJYscTs/Go0ubvllQaLURRsU96/w7P60m7Hh
	 x6qj2vCHqpn1MbpbpZ9XXHcn5QbR4EQfLrxvbiSgKvk1OqzCwhL1QmoIb9tdvUSn++
	 H6BnroG3wDDlw==
Date: Thu, 6 Feb 2025 08:39:46 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] lib/crc-t10dif: remove digest and block size constants
Message-ID: <20250206163946.GB4283@sol.localdomain>
References: <20250204201108.48039-1-ebiggers@kernel.org>
 <CAMj1kXGjc6Abm1eHANt7w=D5eVpJXHHNo_7ZcyRMNMNwirZoHg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGjc6Abm1eHANt7w=D5eVpJXHHNo_7ZcyRMNMNwirZoHg@mail.gmail.com>

On Thu, Feb 06, 2025 at 12:09:22PM +0100, Ard Biesheuvel wrote:
> On Tue, 4 Feb 2025 at 21:11, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > These constants are only used in crypto/crct10dif_generic.c, and they
> > are better off just hardcoded there.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >
> > I'm planning to take this via the crc tree.
> >
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> 
> Could you remind me why we are keeping this driver?
> 

I don't know.  I had to keep "crc32" and "crc32c" around for now because they
are still used, and I just defaulted to doing the same for "crct10dif".  It
*looks like* "crct10dif" is different and we could indeed safely remove it like
I ended up doing for "crc64-rocksoft", though.  "crct10dif" has no remaining
references in the kernel; it has no references in cryptsetup, iwd, or libell;
and Debian Code Search doesn't find anything else.  It's over a decade old, so I
was worried there was time for users to have crept in, but that doesn't seem to
have happened.  So yeah, good idea.  I'll send a patch that removes it, with the
device-mapper folks Cc'd in case they know of anything else.

- Eric
