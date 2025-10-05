Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00DB26ACB
	for <linux-crypto@vger.kernel.org>; Sun,  5 Oct 2025 22:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759702270; cv=none; b=VqkNEK09bdlL6xJIEM210itQlgs/pvN/wEoRreVFFX73rfEy68gs4OKEnhQzBXeZScUkcC8uVFdC7BUS7pBt3xBiIwzv9oezs9IagzQLwJrZJd9uBX0nf4Th6xwBus+mAz5ZGmooqzfA98Q1bBxf7cwVlVCo3WpMAJ4fO2tgBGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759702270; c=relaxed/simple;
	bh=2AMDcMuSc18etxjoH0BXiAA/nWiIBeVjjeu9p2HQHXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bNgqZCdNLJE/vUBbv7xdKJ7mD4xKCrQ2udtex8w47a4/KfxHiL8e8X22ubZcH6qYXChw4nZJhQvBrWCe4GOgh91iVVzwQ9UCOKmgHgQ5KAeKjuHrAsmJ6liE7WFVenpRyawu1cImi2rqqslPOgdtn0BztTQU8dyX5TrmE6NufDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Ga3NA0EF; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Ga3NA0EF"
Received: from trampoline.thunk.org (pool-173-48-112-229.bstnma.fios.verizon.net [173.48.112.229])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 595MABIr006690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 5 Oct 2025 18:10:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1759702217; bh=vJY6m2wW3YlMxFyl/Ma+XpSf+3Kbdd0VARQTlPf05PI=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Ga3NA0EFxkGfxJyEd5gsNtSzGpvLg0+EcFwqxgneu6MyC57mnnD+3F5lR6dPmX4ir
	 IX8RJ5F+nHsNRYV5PDkNvoW1EmGxHLUJiisTFFzmtFG0h9p9BRsot+taf4ERPAdGi2
	 tUK/vLmJs+wbH1ZlP7goYn2+DGsNHh0TwYa5TL0mSeI3gLYSlnai+phbImL93wbeQZ
	 IeGpk7wlfxMIHaJBMTw8sfio774Kvq4MIBe+Hd7IHscttBOLob1AD0MYGkwi2IzlLc
	 pYSBfdJtxC22ZLhIyv65PzQJoGrvCrpZ95bL9FTDdU9Xk71MmhY/MA6St1xbumpxB8
	 0brUht3yTPNjg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 45BED2E00D9; Sun, 05 Oct 2025 18:10:11 -0400 (EDT)
Date: Sun, 5 Oct 2025 18:10:11 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Jon Kohler <jon@nutanix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Marcus Meissner <meissner@suse.de>, Jarod Wilson <jarod@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: 6.17 Regression: loading trusted.ko with fips=1 fails due to
 crypto/testmgr.c: desupport SHA-1 for FIPS 140
Message-ID: <20251005221011.GF386127@mit.edu>
References: <20250521125519.2839581-1-vegard.nossum@oracle.com>
 <26F8FCC9-B448-4A89-81DF-6BAADA03E174@nutanix.com>
 <ec2b9439-785e-475f-b335-4f63fc853590@oracle.com>
 <C9119E6C-64C8-47D7-9197-594CC35814CB@nutanix.com>
 <20251004232451.GA68695@quark>
 <20251005031613.GE386127@mit.edu>
 <a2496958-1423-43b6-b23d-e4b745af034a@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2496958-1423-43b6-b23d-e4b745af034a@oracle.com>

On Sun, Oct 05, 2025 at 09:29:21AM +0200, Vegard Nossum wrote:
> This sounds like a good idea to me, although I suspect it would be more
> useful as static CONFIG_* options than boot-time options.

I suspect that distributions would have problems with static CONFIG_*
options, because it means they have to chose which FIPS options to
work (and which kerenlk features to neuter, and hence, which customers
to p*ss off).

What's not clear to me is whether some of the interpretions that if
*any* SHA1 implementations are shipped with the product, then ix-nay
on getting FIPS certification.  If that is true, then perhaps static
CONFIG_* options would be needed.  I don't see that in the FIPS
specifications; only in click-baity headlines --- but I might have
missed something, since I don't have to deal with FIPS certification,
for which I am infinitely grateful.  :-)

(And if it is true, then the boot-line fips=1 would be useless for the
purposes of getting that magic piece of fips certification paper, and
people don't seem to beieve that's the case, or it wouldn't exist.)


The other thing to note that for better or worse, FIPS compliance
might be rquired for use cases other than selling into the US
Government market.  For example, PCI requires FIPS compliance when
encrypting credit card data.  But PCI might not care about whether you
are using SHA-1 for dm_crypt, so long as you're not storing critical
card data or other PII on it.  So that might be a situation where
subsystem-specific enablement of FIPS mode might make sense.

Cheers,

						- Ted
