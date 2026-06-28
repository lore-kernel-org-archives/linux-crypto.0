Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDF623D2A4;
	Sun, 28 Jun 2026 18:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782672847; cv=none; b=q8SRp1ekAB1m0BDAYmFEl/kbzN1v6/VvlwviVr1HMYTS/5lF26hFxEAzA8Pz12a47ZEU6Iu2DoTS2ABjO22VzVCOAy/bI0QSX9hLnajravGzvj3isQHU6Ea2LiaSXGNMerP3HWAMPK1oXOIgdiSgkX2Uwn5KaACVidHgrwBTTZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782672847; c=relaxed/simple;
	bh=2mBQgjcxrqblWqv5J8Qk8wJk+A0S9tR+UwxzmB1h0I4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Edp7pQjjaXJCG4LcD1+Dt1H4LcUZrVueXrE0mCT5LziUY9mmCeGXc7bCfbvBATWLxAwim9GbwxPtXNV1hgFVH1zmiZsJoSmJYTdRgP6Z4/O9wUIqKIyf7+doMrSxW56bMXetu2LW3lt6kX/TQYxOQwF2arNDWvqX48krnfTFhoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMVPNL6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMVPNL6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D661F00A3A;
	Sun, 28 Jun 2026 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782672846;
	bh=TcbXPpzfkxQPhdknKxPzE7hKJWojVVYNJ0ZYN7VuqUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oMVPNL6SGcurNCHXmW3JSPOFJI7LH22YpXBxlnznKGMdIsyI5od+fvvZQORfmixi4
	 2L1jV5FAXwl4QGVq+k/k3nIGmT9xw2yO/jDCg1Qsmt6l+tgWabUSdiWGJQmBsp+c0r
	 r/11LXfw6sDRUWlbeMYYEhHISwmY5WhDpWeMtQop3avlDAaKPOJYpwqJULGXyclMcG
	 LEFqaUmhxbdzHb7DALTBvRQSK7p+QiYZEnC505OmTXbQZDDOkaqC2FzkyV2di0yIPq
	 V0cyA4hD6W4Q2dBuocn6AJPu9Bps9oYQ7iPmwW29QmFaf8KawKNEE/30XrqtugZWrk
	 OqfO2HS5hy8pQ==
Date: Sun, 28 Jun 2026 11:54:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev,
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
Message-ID: <20260628185404.GA2292@quark>
References: <20260622234803.6982-1-ebiggers@kernel.org>
 <CALCETrXPj0u=FZ=aFcZAHk3fFZa7rCuPEjx6cOMXmT3sdkC7SA@mail.gmail.com>
 <20260623192715.GE1850517@google.com>
 <c7cb79ce-48f9-4433-ab4f-88b4c4df996c@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c7cb79ce-48f9-4433-ab4f-88b4c4df996c@gmail.com>

On Tue, Jun 23, 2026 at 10:09:27PM -0400, Demi Marie Obenour wrote:
> On 6/23/26 15:27, Eric Biggers wrote:
> > On Tue, Jun 23, 2026 at 12:12:24PM -0700, Andy Lutomirski wrote:
> >> On Mon, Jun 22, 2026 at 4:49 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >>>
> >>> AF_ALG is a frequent source of vulnerabilities and a maintenance
> >>> nightmare.  It exposes far more functionality to userspace than ever
> >>> should have been exposed, especially to unprivileged processes.  Recent
> >>> exploits have targeted kernel internal implementation details like
> >>> "authencesn" that have zero use case for userspace access.
> >>>
> >>> Fortunately, AF_ALG is rarely used in practice, as userspace crypto
> >>> libraries exist.  And when it is used, only some functionality is known
> >>> to be used, and many users are known to hold capabilities already.
> >>> iwd for example requires CAP_NET_ADMIN and has a known algorithm list
> >>> (https://lore.kernel.org/linux-crypto/bcbbef00-5881-421b-8892-7be6c04b832d@gmail.com/).
> >>>
> >>> Thus, let's restrict the set of allowed algorithms by default, depending
> >>> on the capabilities held.
> >>>
> >>> Add a sysctl /proc/sys/crypto/af_alg_restrict with meaning:
> >>>
> >>>     0: unrestricted
> >>>     1: limited functionality
> >>>     2: completely disabled
> >>>
> >>> Set the default value to 1, which enables an algorithm allowlist for
> >>> unprivileged processes and a slightly longer allowlist for privileged
> >>> processes.
> >>
> >> In our brave new world of containers, this is a bit awkward.  The
> >> admin is sort of asking two separate questions:
> >>
> >> 1. Is the actual running distro and its privileged components capable
> >> of working without AF_ALG or with only the parts marked as being
> >> unprivileged?
> >>
> >> 2. Is the system running contains that need the unprivileged parts?
> >> (Which is maybe just sha1 for ip?  I really don't know.)
> >>
> >> Should there maybe be two separate options so that all options are
> >> available?  Or maybe something between 2 and 3 that means "limited
> >> functionality and privileged modes are completely disabled"?
> > 
> > If we want to offer more settings we could.  I could see this getting
> > quite complex pretty quickly once everyone weighs in, though.  There's
> > quite a bit of value in keeping things simple, even if the offered
> > settings won't be optimal for every case.
> > 
> > - Eric
> 
> What about exposing both allowlists to userspace and making them
> configurable?
> 
> I'm mostly concerned about systems running code (possibly
> closed-source) that uses algorithms that nobody here knows about.
> It would be better to allow a single algorithm than to turn off all
> restrictions.
> -- 
> Sincerely,
> Demi Marie Obenour (she/her/hers)

I think the following is what you're asking for:

    sysctl crypto.algif_aead_priv_allowlist='ccm(aes)'
    sysctl crypto.algif_aead_unpriv_allowlist=''
    sysctl crypto.algif_hash_priv_allowlist='cmac(aes),hmac(md5),hmac(sha1),hmac(sha256),hmac(sha384),hmac(sha512),md4,md5,sha224,sha256,sha384,sha512'
    sysctl crypto.algif_hash_unpriv_allowlist='sha1'
    sysctl crypto.algif_skcipher_priv_allowlist='cbc(aes),cbc(des),cbc(des3_ede),ctr(aes),ecb(aes),ecb(des)'
    sysctl crypto.algif_skcipher_unpriv_allowlist='adiantum(xchacha12,aes),adiantum(xchacha20,aes),hctr2(aes),xts(aes)'
    sysctl crypto.algif_rng_priv_allowlist=''
    sysctl crypto.algif_rng_unpriv_allowlist=''

We could do that if it's what people want.  Just keep in mind that it
would be much more complex than the single tristate sysctl.  And in
practice the number of people who are knowledgeable enough to create
these lists is quite small; we've seen similar things with other "Crypto
API" configuration knobs that seem to never be touched in practice.

Any thoughts?

- Eric
