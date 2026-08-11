Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA00C334C05;
	Tue, 11 Aug 2026 22:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786488195; cv=none; b=s2qrQQhR27RPa84bt8XVOxJEEqwJXDL36uncybTg0gqfyeaQylsCF6wSHMtGZ+gQPxkTyqf6pOo509lG4L3C7H5BVGbMwOShNK22TUoDK7pvWoqslXmqrWwfeOjAB96Y15YxNHgxyA1ADDGEojUDSsukP+kaV6VwaQTWvLYtnSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786488195; c=relaxed/simple;
	bh=9yDKoQBSmnF5XXTAYP8ybKXB+z5RX774AaSn3A+iiEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=esVo+2cIxDR1nXSHEPO8VGfjFMCc7FkhmzKlfnP6AFJO+KlXpkp6EnRbgxis7Z7PhWdFRYexUK1sehV5RWhASn6TQceCu3IJiHxcb+IpPvgWef/JzF9ostUsCBN0M02fQmP+jmLzTn4scAFbi2PfVKyM/Ox9Ekq3R4VAsD8gpc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHJlg6/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHJlg6/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C67C1F000E9;
	Tue, 11 Aug 2026 22:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786488194;
	bh=8UjVzdA3ZiJV2WD71DqQ+LTR9g0cXUEs5gtk+/y0MpM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nHJlg6/ZExNylL+Soss19nqRu/AB3XBp1DEb/igjvoDkEyLz1Rh3ZyDFUQ/GovR3B
	 0KjDaRkvhVeW3X/rhxl4A9wYfrHbNSjaB7tyQUQVWQRLBNzvrqW4yVsSOOENsW+f4H
	 GX+lf83pstlgco6v0+9Thjgw2XkRr8VpMJC0OzGEQD7s+OT4Ok4riG5zYAbDU3xJoJ
	 oIz2rK0brROJjOWrwLC5lrVoIrvMHhq3jfqfj/K3r072OCoUmYoikcg2LXwjaju3DU
	 b3unrs1s9O9Vjz71P6fr1TESc0Toy4MHZpzRMBl33fre4TCwLk8AYykYATh/K1uNQP
	 qCqn0LBDEDE+A==
Date: Tue, 11 Aug 2026 15:41:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Demi Marie Obenour <demiobenour@gmail.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
Message-ID: <20260811224110.GC1905@sol>
References: <20260731050838.158825-1-ebiggers@kernel.org>
 <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
 <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com>
 <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark>
 <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark>
 <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>

On Tue, Aug 11, 2026 at 08:42:55AM -0500, Bartosz Golaszewski wrote:
> On Sat, 1 Aug 2026 19:12:42 +0200, Eric Biggers <ebiggers@kernel.org> said:
> 
> > Well, that again brings us back to the core issue which is the actual
> > current functionality of the driver, which is to register crypto_ahash,
> > crypto_skcipher, and crypto_aead algorithms with the crypto API.
> >
> > It isn't useful functionality, but rather just a footgun that allows
> > users to misconfigure their systems, an issue I've seen happen multiple
> > times.  CPU-based implementations of *every one* of those algorithms
> > already exist.  On a typical SoC that has this hardware, the CPU-based
> > implementations are ~50x faster as shown in tests.  Pending patches make
> > the difference even greater at ~100x.  And the CPU-based implementations
> > actually use significantly less CPU time, as well.  There seems to be no
> > path forward for significantly fixing this issue, either.
> >
> 
> You've repeated your point about performance several times. Nobody ever said
> you're wrong. Performance is not the only reason for choosing one provider over
> another.

That isn't a very practical viewpoint for the in-kernel crypto use
cases, where performance tends to be critical and users will do a lot to
get even a few percent improvement, let alone 10000%!  But as Demi and I
have explained, even if the performance aspect is ignored the driver
still isn't worth it, for multiple other reasons.

Also, you did give saving CPU cycles as a reason earlier
(https://lore.kernel.org/linux-crypto/CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com/).
That's one of the reasons I actually tested it and responded to that.
It sounds like you've now walked back your claim.  So great, we seem to
be on the same page regarding that point now.

> > An alternative we could consider is dropping the cra_priority further,
> > to further decrease the chance that these algorithms are used.  But I
> > feel it's hard to justify why they're there at all, if the rationale for
> > keeping them is "we made sure that no one can actually use them, so they
> > can't be causing problems anymore"...
> >
> 
> No, the rationale has never been this. FWIW it can be that it's used for
> testing of the crypto module on a supported platform and that is already
> enough of a reason to keep it upstream.
> 
> As I've said before: we don't just drop maintained drivers from linux.

We definitely do if the drivers are not useful or appropriate for
inclusion in the kernel, though the policy varies by subsystem.  Even
just last month an entire filesystem got dropped despite someone wanting
to maintain it.

- Eric
