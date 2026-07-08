Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CC93ABD99
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 01:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783473184; cv=none; b=QqBg1rz60JnQIin3w5ffGgs7QOAmR3piGyIpGEPwSk19dPkafBWbB+QhF+deVK7RBySXIFw6WNiD4dEl6U225vXCOcHATKcncdPDknq/jTQrrZpboqB3TozQlgoeXXC8tWfGLDxpATY5MSWGy5pf+yWp9THjLiSu3uZ+fhKLvgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783473184; c=relaxed/simple;
	bh=OrIGq2m+ekZbMm13G4N2X//3wA6ZQNyElCEqPPMelpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p4EecDJWDBIlLUpLnw64lc3rkybXlzQWnSftsMJJF+b4Gd6CqAALC6zsoo+1HNY13/drlA+fXg+JtMkw9lMhN0SPSNgx36sTlgBRKn26OGy8qKNWo6AGYaiLDuqGjFwObPW9yjh6BhrZrDBs2XkXLHdyyZpjARtCaC0SxxnC/AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J2zveSpj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J2zveSpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBB01F000E9;
	Wed,  8 Jul 2026 01:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783473183;
	bh=LZnPvyRKSjpb/31E911FKJ4G6IIA3SoWbuKkS4LCeDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J2zveSpjvmaTD7DljF74pbw5eHTeiL0jSKRZbZb5zT5LuogmCmIad+b+XrlPB+3/t
	 tDVHN6CaAeDm0XFkRHz8GW9VDGWdal5YfEhTr8t38DTOZXk80l0KvHrcmK+FG7PI3m
	 O96HkNaZTd81d5TFSaG9Sk61LL/EBl7s+gZtFFw2v9Rv+L3CRqB2FjeM9ZEEqV1n/r
	 OdSYLsgh8N0qy87WDyn7It6wVX2qn3c31NC5LK7Tg7BmVgd6I3uW1jleTP3oo06aUQ
	 Hqy+QmRjzmpz6vVqCc0OTqti8oPklZ7MCaV9+gJ2ZdyajZ7ZIUNiSFbA0/pq70kf4+
	 KMjZTyuw7+TNQ==
Date: Tue, 7 Jul 2026 18:11:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Milan Broz <gmazyland@gmail.com>
Subject: Re: AF_ALG deprecation fallout
Message-ID: <20260708011112.GA3890@sol>
References: <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org>

[+Cc Milan Broz]

On Wed, Jul 08, 2026 at 02:31:05AM +0200, Christoph Anton Mitterer wrote:
> Hey folks.
> 
> 
> While I've had read already earlier about AF_ALG's deprecation plans,
> only when the recent cryptsetup 2.8.7-rc1 came out, it occurred to me
> that I'm actually be affected by it.
> 
> In particular, the release notes mention[0] that along with AF_ALG's
> looming removal, support for some ciphers will probably also disappear,
> mentioning Serpent and Twofish as examples.
> 
> Now these two, I do use for long term backups... so it would really be
> quite unfortunate, if sooner or later I couldn't use them with dm-crypt
> anymore.
> In particular, I use them stacked with AES, it's not really just a
> matter of switching to that. And yes I do know that this is most likely
> crypto-overkill. O:-)
> 
> 
> Also, I can imagine that others may use these or other possibly
> disappearing as well, even though admittedly a majority will simply use
> AES.
> 
> It's not that I'd oppose clean-ups respectively phasing out unused
> stuff (I mean things like i486 or ancient graphics card), but at least
> sometimes one gets the impression that when such deprecation is
> started, devs ask around at the developer mailing lists whether anyone
> still uses that, and when no one raises his hands they go on.
> 
> But the majority of users most likely never saw that inquiry, only
> noticing that some feature they're using is gone, when such kernel
> actually lands in their system - which may be only many years after if
> has even been removed in the main tree.
> Then of course, it's typically far too late to bring anything back.
> 
> Now for drivers for ancient hardware, I kinda agree, one cannot keep
> them forever, especially when most likely no one uses them anymore
> (with current kernels).
> But things like these algos are IMO a bit different, neither of them is
> broken yet, and even if they were people might still have some old data
> which they eventually might want to read.
> 
> 
> So, here I am, raising my hand, asking whether perhaps anything's
> already done (cryptsetup's maintainer indicated something) to keep
> Serpent and Twofish usable for dm-crypt... and, if so, how sure I can
> be that this will actually be done.
> 
> And if not, I'd kindly ask whether it could be considered to have
> something done, so that dm-crypt can still use them.
> 
> 
> Thanks,
> Chris.
> 
> 
> [0] https://gitlab.com/cryptsetup/cryptsetup/-/blob/5723601af5e5c14ccdf3cda0b13756e3ea1b511b/docs/v2.8.7-rc1-ReleaseNotes#L10-29

I think the cryptsetup release notes may have given you a slightly wrong
impression.  So far the only things that have been removed from AF_ALG
are zero-copy and async execution support, which have zero impact on
cryptsetup.  There are indeed more people turning off AF_ALG in their
kernels now; however, general-purpose distros aren't doing that.

In 7.3 we'll indeed be introducing an algorithm allowlist for AF_ALG.
But I already proposed including "xts(serpent)", "xts(twofish)", and
"xts(camellia)" on it
(https://lore.kernel.org/linux-crypto/20260705184419.40762-1-ebiggers@kernel.org/)
based on their mention in various online documentation for cryptsetup,
which suggests they indeed likely have some (rare) real-world use.

I'm interested in allowing any other algorithms that still have
real-world use via AF_ALG, if any exist.  If you're aware of any, please
speak up.  In particular, if you could confirm that the "xts(serpent)"
and "xts(twofish)" allowlist entries are necessary and sufficient for
you, that would be helpful.

Note that cryptsetup 2.8.7 will further reduce the cases in which it
even needs AF_ALG at all.  So just because you are using a particular
algorithm doesn't necessarily mean you need it in AF_ALG.

No algorithms have been proposed to be dropped from dm-crypt (which is
*not* the same thing as AF_ALG), by the way.  Given that dm-crypt allows
some "interesting" algorithms like RC4, DES-ECB, and even the null
cipher, I do think we can expect an allowlist for it at some point as
well.  But that would be separate.

I'd indeed like to remove AF_ALG entirely eventually.  But that's a long
term thing that would be many years from now and would occur only after
iwd, bluez, cryptsetup etc. have all fully migrated to userspace crypto.

- Eric
