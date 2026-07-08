Received: from cyan.elm.relay.mailchannels.net (cyan.elm.relay.mailchannels.net [23.83.212.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4913EB7FB
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 07:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.83.212.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783495471; cv=none; b=MExmK3KoueA9tn9+0MT75uLetJIw1kbTIRcrHJcVRncGqK7RJuqe0aBPCL1VH1m0Dj8zo8NfZ5Jxf1cGiptpLisb/9M7nTqOZjcubgh8N+U3KL7WCYUXsBJUuInlJQxDJnHxDMumesNniLRrmUH/qGZwYmM7ldul1y093awcbFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783495471; c=relaxed/simple;
	bh=S4XWIfKff1hniR8Hh+JkjY1cmMqYsrdCWVctmmjwwLc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FQsGyqNpy8ThnQGe9lOrTVs6fkuAeDWXY6CfKGB4RfQeypJwAIJHc0Su8ppzQmHYN0QGFxxJEKdwt2F7hxH5ADyTJisfJZD6jyyvIj44P1xSNEPehJfHSdsXDoox1ZsuIc6Z9vN7onnX/iWpVHqsQt6x0w/sDPJP2AkOKvY9Tqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=none smtp.client-ip=23.83.212.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id BD0274E1580;
	Wed, 08 Jul 2026 02:14:08 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-99-175-78.trex-nlb.outbound.svc.cluster.local [100.99.175.78])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id A60BD4E1756;
	Wed, 08 Jul 2026 02:14:07 +0000 (UTC)
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Towering-Hysterical: 1abbe8d73161fa88_1783476848668_1443487694
X-MC-Loop-Signature: 1783476848668:3127782482
X-MC-Ingress-Time: 1783476848668
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.99.175.78 (trex/8.0.2);
	Wed, 08 Jul 2026 02:14:08 +0000
Received: from p5b0ed87c.dip0.t-ipconnect.de ([91.14.216.124]:62194 helo=heisenberg.fritz.box)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.4)
	(envelope-from <calestyo@scientia.org>)
	id 1whHna-0000000F1yd-2Ylk;
	Wed, 08 Jul 2026 02:14:06 +0000
Message-ID: <04fbbc8611699e469f44edbccdf3cf1ac65075d3.camel@scientia.org>
Subject: Re: AF_ALG deprecation fallout
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
 Milan Broz <gmazyland@gmail.com>
Date: Wed, 08 Jul 2026 04:14:04 +0200
In-Reply-To: <20260708011112.GA3890@sol>
References: <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org>
	 <20260708011112.GA3890@sol>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-10 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

Hey Eric.

Thanks for your fast reply :-)

On Tue, 2026-07-07 at 18:11 -0700, Eric Biggers wrote:
> In 7.3 we'll indeed be introducing an algorithm allowlist for AF_ALG.
> But I already proposed including "xts(serpent)", "xts(twofish)", and
> "xts(camellia)" on it
> (
> https://lore.kernel.org/linux-crypto/20260705184419.40762-1-ebiggers@k
> ernel.org/)
> based on their mention in various online documentation for
> cryptsetup,
> which suggests they indeed likely have some (rare) real-world use.

Good :-)



> I'm interested in allowing any other algorithms that still have
> real-world use via AF_ALG, if any exist.=C2=A0 If you're aware of any,
> please
> speak up.

[X]Chacha, IIRC, would anyway be used without XTS...

Well, I personally don't use any others, but of course other might.
What about all these legacy modes that were used for years in examples,
like cast5-cbc-essiv, aes-cbc-essiv, etc.?

Does your list have any effects on things like chained algos (which I
think cryptsetup allows to use for tcrypt).


> =C2=A0 In particular, if you could confirm that the "xts(serpent)"
> and "xts(twofish)" allowlist entries are necessary and sufficient for
> you, that would be helpful.

For me they are. Actually I would want to replace my use of twofish by
something xchacha based (see * below), but I would want to keep xts-
serpent in the long term.


> Note that cryptsetup 2.8.7 will further reduce the cases in which it
> even needs AF_ALG at all.=C2=A0 So just because you are using a particula=
r
> algorithm doesn't necessarily mean you need it in AF_ALG.

I see. Well at least 2.8.6 still needed it for opening a dm-crypt
device that used serpent-xts-plain64.


> No algorithms have been proposed to be dropped from dm-crypt (which
> is
> *not* the same thing as AF_ALG), by the way.=C2=A0 Given that dm-crypt
> allows
> some "interesting" algorithms like RC4, DES-ECB, and even the null
> cipher, I do think we can expect an allowlist for it at some point as
> well.=C2=A0 But that would be separate.

While these cases won't affect me, legacy users should be kept in mind.

Perhaps waiting a few years where opening such dm-crypt mapping merely
gives a warning that this is about to go away, then - if possible - for
a few years allowing read-only mappings.


> I'd indeed like to remove AF_ALG entirely eventually.=C2=A0 But that's a
> long
> term thing that would be many years from now and would occur only
> after
> iwd, bluez, cryptsetup etc. have all fully migrated to userspace
> crypto.

Good to hear that you guys have it already on your radar, that some
people may use these non-AES algos and may want to continue doing so
even in the long term.
So please keep this in mind. :-)


Thanks,
Chris.


* A bit off topic, but since some of the relevant people are already in
CC:

I've wrote just before on the cryptsetup mailing list, that we have the
nice integrity support in cryptsetup for quite some years now, but I
guess only few people actually use it because all the available
algorithms/modes were kinda recommended against[0].

I think XChacha20+Poly1305 might be in reach (but still not actually
usable?), having finally a large enough nonce (192bits?).

Now I'm not a crypt export, so don't really know which of [X]Chacha20
vs. AES256 is considered stronger.
At least AES has probably received far more scrutiny than any other
crypto algo ever.

So any chances that the kernel provides a usable AEAD mode for AES (or
maybe even Serpent ;-P)?=C2=A0

Like with GCM but a larger nonce?
Or what about EAX, OCB? I blindly assume, that the patents have all
expired, given that OpenPGP now uses them since RFC 9580.


[0] https://gitlab.com/cryptsetup/cryptsetup/-/blob/5723601af5e5c14ccdf3cda=
0b13756e3ea1b511b/docs/v2.0.0-ReleaseNotes#L259-274
