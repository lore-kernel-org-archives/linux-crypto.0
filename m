Received: from cyan.elm.relay.mailchannels.net (cyan.elm.relay.mailchannels.net [23.83.212.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8223637757F
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 14:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.83.212.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783607539; cv=none; b=l0pHBmPxfsUodmRPHZplj0BSVk+YT1ZmDX9RcCfHbMz3Eqv3RLD25fzhPu13z+1ypURGkwJomzvkCzBCT/nXLEr0kgnLcxiGrfBGkROnkkCMoI2ZU48/ktX3XV3wZSAYpyUgo4ALOUVNrEQU02IxwRcpNfjm++WPW1OmUxcsO5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783607539; c=relaxed/simple;
	bh=V0a2ILp/tCsE6dw0LWeROasiy4crFA3UOludhXO5JsE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=G1optxYpcSlZZP6cjuQ9oOc+H1IMC1uQyRQMBT3C4sZRDd15jjsAsh4bXpbGKM/nLxHa8H1FpWe44sqok3Sau6uW2WdCCfOI5T4SHVrVYZQOrHbc5P3Jx/0aq2dIKafOga8/FKpgOOu5WHJEn0aeTkGGDSAHeEGLmb1APk5ARNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=none smtp.client-ip=23.83.212.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 6D764722AE1;
	Thu, 09 Jul 2026 12:38:55 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-6.trex.outbound.svc.cluster.local [100.99.18.246])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 1CFF7722D10;
	Thu, 09 Jul 2026 12:38:53 +0000 (UTC)
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Hook-Left: 6173d548431ec6da_1783600735271_2102916553
X-MC-Loop-Signature: 1783600735271:136814838
X-MC-Ingress-Time: 1783600735271
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.99.18.246 (trex/8.0.2);
	Thu, 09 Jul 2026 12:38:55 +0000
Received: from tmo-083-158.customers.d1-online.com ([80.187.83.158]:12616 helo=ehlo.thunderbird.net)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.4)
	(envelope-from <calestyo@scientia.org>)
	id 1who1k-00000009w7H-1m7G;
	Thu, 09 Jul 2026 12:38:52 +0000
Date: Thu, 09 Jul 2026 14:38:50 +0200
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Milan Broz <gmazyland@gmail.com>, Eric Biggers <ebiggers@kernel.org>
CC: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AF_ALG deprecation fallout
In-Reply-To: <aac82bdd-6a28-4e65-97f4-3d5942d2a6af@gmail.com>
References: <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org> <20260708011112.GA3890@sol> <04fbbc8611699e469f44edbccdf3cf1ac65075d3.camel@scientia.org> <20260708030153.GA14700@sol> <aac82bdd-6a28-4e65-97f4-3d5942d2a6af@gmail.com>
Message-ID: <5B8D2771-3FBD-4FF0-A2A0-A57120A53F5A@scientia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-AuthUser: calestyo@scientia.org

Hey=2E

Am 9=2E Juli 2026 12:47:06 MESZ schrieb Milan Broz <gmazyland@gmail=2Ecom>=
:
>On 7/8/26 5:01 AM, Eric Biggers wrote:
>See my explanation here
>https://gitlab=2Ecom/cryptsetup/cryptsetup/-/merge_requests/420#note_2520=
172869

Do you strictly need an RFC?

Nevertheless, I've mailed to the author of draft-irtf-cfrg-xchacha whether=
 he has still any plans with it=2E
At least then we'd know if it's worth waiting=2E


>> We probably should add XAES-256-GCM support at some point, which takes
>> 192-bit nonces=2E  Historically it hasn't been feasible to do anything
>> that uses per-request AES keys in the kernel, since the kernel's crypto
>> API wasn't designed for that=2E  But we're now moving to a simpler API
>> where the algorithms including AES-GCM are implemented using regular
>> functions=2E  We can build XAES-256-GCM support on top of that=2E
>
>That would be nice=2E

Indeed=2E Would be great if that could come in the foreseeable future=2E=
=2E=2E in particular with the uncertain future of XChaha=2E

Also, blindly assuming that so far people mostly used integrity support in=
 dm-crypt for testing and not production (due to the algos), it might take =
a while until enough trust[0] has built up for seeing broad use=2E


I guess it might also help end users if cryptsetup might give recommendati=
ons on which algo to use for what (like most secure vs=2E secure enough but=
 better performance, or so)=2E

With non AEAD, this had been rather easy, and aes-xts-plain64 with 256 bit=
 keys was simply like the gold standard=2E


Cheers,
Chris=2E


[0] Not that I'd think the contributing developers weren't capable,=2E=2E=
=2E but you know=2E=2E=2E if one puts all precious data in it (including fo=
r backups), one doesn't want any surprises=2E
