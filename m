Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5339521FF41
	for <linux-crypto@vger.kernel.org>; Sat,  4 Oct 2025 23:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759620294; cv=none; b=METViDekcQKnw5D+aYGQmH5SMYdGQWG4Zt/2akppOHoKFktQHvEsON8lntE5VFcA2eBza2Eb0db3VvFqDNpVLKVjH9IQYc0z9rEzkUdrbD9/6ezC4qhwkzXwLN/+cy/sVxaQ/GHNuGIPsWpZJv8BxhPInYSJZGxBcRyu28aP0P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759620294; c=relaxed/simple;
	bh=dg/Zafx8TdrZdmI7pD+ofYjghX/kiQud4wRncQIb43U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uaugmSVUb0CyoaR8fQEZ1NI08btSUALBk5M/HWtJbTW5Vf8p5bhE3UgWWTQxqpBYKhwaoMB/dhIx8DoGKpNexn1pP5o04/diYaTzKk6/WWQCg07LBCqyFcMa/IM7VACXo0gGMdkeS8OXnyk/2QbzNteSER5tMO0qCxRPM9bAhxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dm2mSE1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dm2mSE1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D9CC4CEF1;
	Sat,  4 Oct 2025 23:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759620293;
	bh=dg/Zafx8TdrZdmI7pD+ofYjghX/kiQud4wRncQIb43U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dm2mSE1fW0KeFMLNXzFPRHX5iGTfR8lczliz0Mp+oFcg6WOUQndkG6uzteBlnGRuW
	 lSyKZrgItMEzgaz8mIyXZmkcFyVOQZH1QTqlq6pi2YCaz8cZamNekYQfHND/7amlwn
	 LAhiLegdbtDsBHfIB9UFZK7x4dVzctXvrJD1Lelm8JfyNkDIrglGzHRmIoI6+sem4K
	 /0nWJ+Wv4m4p99VfYuGnfB3HcNpzbNIlfO0iYvD3iBbfDRjaFQ7cIYg0g0gwRZKWfv
	 LGxfrAcb0z/5TJI020kYcpzWs+3XhP9WDa0YVizF3N7BsXIrhcp1dEZiARr2hJGBPK
	 rOw1piKmeNmEA==
Date: Sat, 4 Oct 2025 16:24:51 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Jon Kohler <jon@nutanix.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>,
	Marcus Meissner <meissner@suse.de>, Jarod Wilson <jarod@redhat.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	John Haxby <john.haxby@oracle.com>
Subject: Re: 6.17 Regression: loading trusted.ko with fips=1 fails due to
 crypto/testmgr.c: desupport SHA-1 for FIPS 140
Message-ID: <20251004232451.GA68695@quark>
References: <20250521125519.2839581-1-vegard.nossum@oracle.com>
 <26F8FCC9-B448-4A89-81DF-6BAADA03E174@nutanix.com>
 <ec2b9439-785e-475f-b335-4f63fc853590@oracle.com>
 <C9119E6C-64C8-47D7-9197-594CC35814CB@nutanix.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C9119E6C-64C8-47D7-9197-594CC35814CB@nutanix.com>

On Sat, Oct 04, 2025 at 02:58:43PM +0000, Jon Kohler wrote:
> 
> 
> > On Oct 4, 2025, at 2:43 AM, Vegard Nossum <vegard.nossum@oracle.com> wrote:
> > 
> > !-------------------------------------------------------------------|
> > CAUTION: External Email
> > 
> > |-------------------------------------------------------------------!
> > 
> > On 04/10/2025 05:00, Jon Kohler wrote:
> >> Hello crypto list,
> >> Working through testing 6.17 on our platform, which uses fips=1, and
> >> noticed that we’re having trouble modprobe dm_crypt, where dmesg barks
> >> with the following entries:
> >> [18993.394808] trusted_key: could not allocate crypto hmac(sha1)
> >> [18993.479942] device-mapper: table: 254:6: crypt: unknown target type
> >> [18993.482967] device-mapper: ioctl: error adding target to table
> >> Looking at modprobe dm_crypt with strace, it looks to be trying to
> >> load trusted.ko first, and indeed when doing 'modprobe trusted', we
> >> see the same log entries from trusted_key over and over again.
> >> The test case on our side that hit this is a trivial sanity case, where
> >> a userspace app tries to do the following on a throw away volume:
> >>   cryptsetup open --type plain --cipher aes-xts-plain64 \
> >>                   --key-file /dev/urandom /dev/sdXXX sdXXX_crypt
> >> This user space cryptsetup call fails, and we then see the dmesg logs
> >> as noted.
> >> We compile CONFIG_TRUSTED_KEYS && CONFIG_TRUSTED_KEYS_TPM, and it looks
> >> like we're hitting trusted_tpm1.c's hmac_alg[] = "hmac(sha1)".
> >> In my tree, I reverted this patch [1] and modprobe dm-crypt is happy
> >> again, and the cryptsetup-based test case passes now.
> >> I'm scratching my head as to the right thing to do here, as on one hand
> >> I agree with the patch notion that we want to start the deprecation
> >> cycle for SHA1, but on the other hand, if CONFIG_TRUSTED_KEYS_TPM is
> >> enabled, we're going to run straight into this all the time as it
> >> doesn't look like theres a way to override this to use some higher algo
> >> Happy to discuss and try out ideas.
> >> Thanks,
> >> Jon
> >> [1] 9d50a25eeb0 ("crypto/testmgr.c: desupport SHA-1 for FIPS 140") and
> > 
> > Hi,
> > 
> > Thanks for the report.
> > 
> > I think this patch addresses the issue you're seeing:
> > 
> > https://lore.kernel.org/all/20250904155216.460962-7-vegard.nossum@oracle.com/
> > (In short, it's not that we really need to use sha1, it just means the
> > hardware isn't available for use with those boot parameters.)
> 
> Thanks for the pointer! I tested this out just now, and with the original desupport
> patch + this one, trusted.ko/dm-crypt work just fine and the cryptsetup test
> case now passes.
> 
> In general, this seems like a good patch. 
> 
> Could we pull this out of the RFC and apply it as a Fixes for this issue perhaps?
> 
> > There was also a more recent discussion around the patch here:
> > 
> > https://lore.kernel.org/all/f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com/
> > I'm guessing the sha1 deprecation commit should be reverted if it wasn't
> > already. Maybe we should just add a big deprecation warning during boot
> > if sha1 is used with fips=1 until 2030?
> 
> You know how deprecation warnings go. Largely ignored, then a 5 alarm fire 
> 10 minutes before they expire :) 
> 
> IMHO, I’d rather keep the commit and use it as a forcing function to knock
> out things like the discussion we’re having right now. Best to do this years in
> advance, so I think the strategy is the right one assuming nothing else goes
> boom.
> 
> I say that all as a backseat driver here, so that’s just my 2 cents! 
> 
> Thanks again,
> Jon

This regression was already fixed upstream by commit 366284cfbc8f
("KEYS: trusted_tpm1: Use SHA-1 library instead of crypto_shash").
It could be backported to 6.17 if needed.

Of course, the reason it fixed the regression is that it implicitly
dropped the broken and untested fips_enabled check.

Which is clearly the correct choice for now.

But for future reference, if the people doing FIPS certifications of the
whole kernel actually determine that a particular kernel feature(s) that
use SHA-1 *must* be disabled when fips_enabled=1, then of course they'll
need to do that properly by submitting a tested and well-justified patch
for each feature that carefully disables the correct functionality.

Submitting a broken, untested, and incomplete patch that makes the
kernel fail to boot and dm-crypt.ko fail to load isn't a great strategy.

- Eric
