Received: from purple.birch.relay.mailchannels.net (purple.birch.relay.mailchannels.net [23.83.209.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA894D8CE
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 00:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.83.209.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783470678; cv=none; b=d/+kOIacQ9wSJ6RrzIjplZpfkb/nsWNhcloYZDWHVMXLOK+oy6lY1J7fRBMrF0AWekuaei5zvyd9BbCSkMYf2sIKmP9/lyNOhHWbZtoHQzYzBzpbsviqRjMC/hmbjy7aVNaJacyXNsa7nXDpzVfKUdif8eLymjp8XOUJFR3nMhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783470678; c=relaxed/simple;
	bh=DMQ6LZMRQJOGYIH6EWl87k+ntv0Oxim9tnrgFFrAxZ8=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=ULbA8Tw6Xcb9po7euEqAPk/LF2o73HAL+b0bSQeDa3+db17efKcisBYv3dr2BtMRVSeuJ+8RTdXeIR/V5qt89wzGKg4/yAHC0kLOf0TE9KQiEh4ndDeyur+Ly9dn//oEEkJ9n82fiAjMPyljkppJurmtuENwQzIivygFKyj7M+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=none smtp.client-ip=23.83.209.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 2A7C87A0FAD;
	Wed, 08 Jul 2026 00:31:10 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-99-1-218.trex-nlb.outbound.svc.cluster.local [100.99.1.218])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id ECF647A0D12;
	Wed, 08 Jul 2026 00:31:08 +0000 (UTC)
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Sponge-Oafish: 361a91b3564783ea_1783470669980_552771499
X-MC-Loop-Signature: 1783470669980:3771042588
X-MC-Ingress-Time: 1783470669980
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.99.1.218 (trex/8.0.2);
	Wed, 08 Jul 2026 00:31:09 +0000
Received: from p5b0ed87c.dip0.t-ipconnect.de ([91.14.216.124]:62287 helo=heisenberg.fritz.box)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.4)
	(envelope-from <calestyo@scientia.org>)
	id 1whGBv-0000000EJzq-3SIp;
	Wed, 08 Jul 2026 00:31:07 +0000
Message-ID: <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org>
Subject: AF_ALG deprecation fallout
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: linux-crypto@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>
Date: Wed, 08 Jul 2026 02:31:05 +0200
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

Hey folks.


While I've had read already earlier about AF_ALG's deprecation plans,
only when the recent cryptsetup 2.8.7-rc1 came out, it occurred to me
that I'm actually be affected by it.

In particular, the release notes mention[0] that along with AF_ALG's
looming removal, support for some ciphers will probably also disappear,
mentioning Serpent and Twofish as examples.

Now these two, I do use for long term backups... so it would really be
quite unfortunate, if sooner or later I couldn't use them with dm-crypt
anymore.
In particular, I use them stacked with AES, it's not really just a
matter of switching to that. And yes I do know that this is most likely
crypto-overkill. O:-)


Also, I can imagine that others may use these or other possibly
disappearing as well, even though admittedly a majority will simply use
AES.

It's not that I'd oppose clean-ups respectively phasing out unused
stuff (I mean things like i486 or ancient graphics card), but at least
sometimes one gets the impression that when such deprecation is
started, devs ask around at the developer mailing lists whether anyone
still uses that, and when no one raises his hands they go on.

But the majority of users most likely never saw that inquiry, only
noticing that some feature they're using is gone, when such kernel
actually lands in their system - which may be only many years after if
has even been removed in the main tree.
Then of course, it's typically far too late to bring anything back.

Now for drivers for ancient hardware, I kinda agree, one cannot keep
them forever, especially when most likely no one uses them anymore
(with current kernels).
But things like these algos are IMO a bit different, neither of them is
broken yet, and even if they were people might still have some old data
which they eventually might want to read.


So, here I am, raising my hand, asking whether perhaps anything's
already done (cryptsetup's maintainer indicated something) to keep
Serpent and Twofish usable for dm-crypt... and, if so, how sure I can
be that this will actually be done.

And if not, I'd kindly ask whether it could be considered to have
something done, so that dm-crypt can still use them.


Thanks,
Chris.


[0] https://gitlab.com/cryptsetup/cryptsetup/-/blob/5723601af5e5c14ccdf3cda=
0b13756e3ea1b511b/docs/v2.8.7-rc1-ReleaseNotes#L10-29
