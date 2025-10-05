Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DB110FD
	for <linux-crypto@vger.kernel.org>; Sun,  5 Oct 2025 03:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759634245; cv=none; b=B5nyieZZV5dPCLC1OpXHLF14/b0YnauQnRuDdAr10LMKoRbybN/uXjRxdSudcFCK3HOZZnpPSWD8MkPfDpkBGBdlslu3B3pLcCSJu2FoHZ3UlfJdXQ5aRm2knl+J+9Yb8l1nRLUaZJekJi2G7rPA4LSLyXmq3e37s1RkApuY3iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759634245; c=relaxed/simple;
	bh=gewsRF5ybnzMS01DuafVvG3C56lVjhjs5t2coFVlKpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jTNvoRjDGEnvKrq4TuzocaqTT4NXPihC55BdpKbW3d1jZmy9VBGiv4pjQaco7Tj47XbncY3zYRwrVGLshptqu7jDKNi94SWYWq9o7B0NG/O+D0w2OQEHPJgAW8eeh+RbSEUS2AJ9j1kOliMHuJZK9n5O70Eu5enydz7zb7c+HBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=qFo4T//Q; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="qFo4T//Q"
Received: from trampoline.thunk.org (pool-173-48-123-201.bstnma.fios.verizon.net [173.48.123.201])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 5953GDfE020952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 4 Oct 2025 23:16:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1759634178; bh=Nd3hwLZWz6hu8v9RgP/aEKnQfUiHUdu9Dg9Y0Hff0CQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=qFo4T//QR/XA0/AnAP0c5h/FRzlDBhCVJFj7Fa/VZAF18uZuCYerRN6E/ymgplYnt
	 ZeF+ubaD4mQfNMGBl77HdqD5l3u8DtnyI3uIFq+p6dAFMsPl/MWpUjd5NNP9pYusL4
	 OTFbugT+49XjbaUkOt0iOCfUNzuVyOU5OrW7AejAVfR+PNTqCD0tPEs7zak2+qmNx7
	 NhG9Sau6XQoI7lJkU1ekdzeIMoIZghQv+bwdl3dzWQjT2eiVTfLfbVYA8xoLJHaHG9
	 xFsJncSK/e/1ekAR+JjRLpJwtJoJ15TT2FxLcWpBnjQTbq48GfZenjJ8Bac6rPMHTA
	 mM+kSgkK8mGKw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0DD1E2E00D9; Sat, 04 Oct 2025 23:16:13 -0400 (EDT)
Date: Sat, 4 Oct 2025 23:16:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jon Kohler <jon@nutanix.com>, Vegard Nossum <vegard.nossum@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Marcus Meissner <meissner@suse.de>, Jarod Wilson <jarod@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: 6.17 Regression: loading trusted.ko with fips=1 fails due to
 crypto/testmgr.c: desupport SHA-1 for FIPS 140
Message-ID: <20251005031613.GE386127@mit.edu>
References: <20250521125519.2839581-1-vegard.nossum@oracle.com>
 <26F8FCC9-B448-4A89-81DF-6BAADA03E174@nutanix.com>
 <ec2b9439-785e-475f-b335-4f63fc853590@oracle.com>
 <C9119E6C-64C8-47D7-9197-594CC35814CB@nutanix.com>
 <20251004232451.GA68695@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251004232451.GA68695@quark>


On Sat, Oct 04, 2025 at 04:24:51PM -0700, Eric Biggers wrote:
> But for future reference, if the people doing FIPS certifications of the
> whole kernel actually determine that a particular kernel feature(s) that
> use SHA-1 *must* be disabled when fips_enabled=1, then of course they'll
> need to do that properly by submitting a tested and well-justified patch
> for each feature that carefully disables the correct functionality.

There's a hidden philosopical question here, which is whether "FIPS
certification of the whole kernel" is actually a good thing.
Personally, I don't think it is, but if booting with fips=1 neuters a
whole bunch of kernel features, and that is considered "working as
intended", to the extent that it discourages the use of FIPS mode,
maybe it's not such a bad thing.  :-)

But with that said, I suspect one of the things that distributions
might find useful is per-kernel subsystem fips enablement.  (e.g.,
dm_crypt.fips=1 which might make a whole bunch of existing users' file
systems become useless, precepitating a whole bunch of angry inquiries
to the distrobution's help desk, but maybe a particular user only needs
ipsec.fips=1)

						- Ted
