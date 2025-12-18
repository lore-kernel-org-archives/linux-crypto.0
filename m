Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAD720458A;
	Thu, 18 Dec 2025 18:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766082926; cv=none; b=e1nxhfJ/01+iG0E+mWf59ghdEFzDd9/q8oAoG+EdgCN+buVd8eYu+NJ1VhWITMREtavuo54DDJ4mKDFoGeGdviS3SvkJiPsGmN5p8HNV1qckFLpeg0g2W2FC7EQJm4K/H72+AgAPqZkCdPheMcy/Zvx3jG59wxF8bzeCQVsYEQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766082926; c=relaxed/simple;
	bh=+zRaw1AUWyIegAMLzOtLn7Fxx8SbjYg+i1vGUfRXJbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lIaXc50KpqWGjXTu/35NuIDqSJz8ziRjJsbyua2woS7aa4U+KW1SbuivDZFjm62Ah13gBAtfc7cJzweYw96EHU07cSqYbD0ukL3Xq1nhCFTmaEAhxzVb7KABwSeoVwarOdDIO7IXQDKj0QJHJPfSL6q98JPcHVH7NXIWRFW22o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X17OoMLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X17OoMLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8277C4CEFB;
	Thu, 18 Dec 2025 18:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766082926;
	bh=+zRaw1AUWyIegAMLzOtLn7Fxx8SbjYg+i1vGUfRXJbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X17OoMLE67oaxIJ2j+X23lseVil0i6FazyIsa2WyTNmsqxt295tIu1+iF8UPD6R0p
	 B8dqiQ6+Ukk6BkCVJohHsq6JmhT3jDaLx3mJeTwfYXnwD0hzaF0dDOU3lRydsUMKmj
	 HRmes3cqeJpyLxBUNyrqOBuMU88Hdk3/ZAoJ33ORpYLrF4v+W/d6sY+Q585BJMHO5Y
	 WlcpDnefuQDLboTJO8Huio6Pwkg+Z0MzpoWpDt6CXQloBwFKIpB19OlTaewULVtpHQ
	 wRToxvsi1w7Y+83Hxhd2L0VtJTpndjyK+ZKCuaqnsxJcYy7NbIS8PvwcfPt5ZuP03C
	 mf9vEGM1geNfQ==
Date: Thu, 18 Dec 2025 10:35:17 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: ross.philipson@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Jason@zx2c4.com, ardb@kernel.org, dpsmith@apertussolutions.com,
	kanth.ghatraju@oracle.com, andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: Re: [PATCH] crypto: lib/sha1 - use __DISABLE_EXPORTS for SHA1 library
Message-ID: <20251218183517.GA21380@sol>
References: <20251217233826.1761939-1-ross.philipson@oracle.com>
 <20251217235745.GB89113@google.com>
 <e69b2b27-af03-41aa-a7ae-c4e9c6fe5e02@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e69b2b27-af03-41aa-a7ae-c4e9c6fe5e02@oracle.com>

On Thu, Dec 18, 2025 at 10:25:50AM -0800, ross.philipson@oracle.com wrote:
> On 12/17/25 3:57 PM, 'Eric Biggers' via trenchboot-devel wrote:
> > On Wed, Dec 17, 2025 at 03:38:26PM -0800, Ross Philipson wrote:
> > > Allow the SHA1 library code in lib/crypto/sha1.c to be used in a pre-boot
> > > environments. Use the __DISABLE_EXPORTS macro to disable function exports and
> > > define the proper values for that environment as was done earlier for SHA256.
> > > 
> > > This issue was brought up during the review of the Secure Launch v15 patches
> > > that use SHA1 in a pre-boot environment (link in tags below). This is being
> > > sent as a standalone patch to address this.
> > > 
> > > Link: https://urldefense.com/v3/__https://lore.kernel.org/r/20251216002150.GA11579@quark__;!!ACWV5N9M2RV99hQ!NYVuWrBT2adow7b4eijfE5vI_FKAu7wblBsmNDxouC58woEhQhR4m9sOXOpa9xBoUtLLinpXb3T_AUGlTF-nUG5IjA9SszJw7g8$
> > > Cc: Eric Biggers <ebiggers@kernel.org>
> > > Signed-off-by: Ross Philipson <ross.philipson@oracle.com>
> > > ---
> > >   lib/crypto/sha1.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
> > > index 52788278cd17..e5a9e1361058 100644
> > > --- a/lib/crypto/sha1.c
> > > +++ b/lib/crypto/sha1.c
> > > @@ -154,7 +154,7 @@ static void __maybe_unused sha1_blocks_generic(struct sha1_block_state *state,
> > >   	memzero_explicit(workspace, sizeof(workspace));
> > >   }
> > > -#ifdef CONFIG_CRYPTO_LIB_SHA1_ARCH
> > > +#if defined(CONFIG_CRYPTO_LIB_SHA1_ARCH) && !defined(__DISABLE_EXPORTS)
> > >   #include "sha1.h" /* $(SRCARCH)/sha1.h */
> > >   #else
> > >   #define sha1_blocks sha1_blocks_generic
> > 
> > Shouldn't this be part of the patchset that needs this?
> 
> The way we read your comments on the TrenchBoot SHA1 patch, it sounded like
> you were saying to fix the issue directly in the crypto lib first. We
> assumed this meant a standalone patch but if we misunderstood, we can
> certainly pull this in our patch set.

I can take it through libcrypto-next *if* the code that needs this is
coming soon, i.e. within the next cycle or two.

There have been many cases in the past where maintainers (including me)
have taken something planned to be used elsewhere in the kernel, but
then the code that used it never arrived.  That's just wasted effort,
both in making the change and then reverting the unused change later.

The Secure Launch patches have been going on for over 6 years.  Given
that, I think I'd prefer that you just add this to that series with my
ack, so they go in together.

- Eric
