Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC3B3932C4;
	Sat,  1 Aug 2026 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785601745; cv=none; b=bIQZvRjAt6/jSnHPrbIlO7SrmmevrSLYp/3xVnvNZE3Q6vFhrznpdPRuzXe5Su7Bly9VEnuMMbEpt1+wMwV2SC3QOQzGzYsJ1OV5i29n16IG8rJiVJC/R4LNcvmDZPJI8G3NIab7Zq0gH/1FkHlK3wyQoSqpZ5xBdyGP0dp8hJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785601745; c=relaxed/simple;
	bh=7kSZxEmkYHNTCOVtfv5v8u3ujLRksfb1Nn6o5MVNzqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T3h6V3KYhreJ0fCeHXEPD8XQDdDLXb6ywQDMWWBzZnJu0nZkU7AC92mI3Mrkow7h6QehHbgTG1WLekuZgh6I6yQrg1lDowbw+49d81L0e1nbJRgsKN13NTYwqlCJ+YO1DKqQDwZhYQ0fY5cR0DdAkHa6KiVggh1ZfrYHVzo0yuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDmr00/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDmr00/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC54E1F00AC4;
	Sat,  1 Aug 2026 16:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785601742;
	bh=cIxQo1lwuRObPNtRG3pl2vqbuRxkzNAJrAeSuo6abuo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fDmr00/Z6DZO1Gucn7BdNU9xHWsTUnxAds/CIc9rPQ7jV6+qXyp9p0ZgJDDYXfqui
	 3EeYsG6/9pZz3MngkjJ6ZXiNwFnptKQ637gPc0Hjgtvd9nySeTWEirxdOoKf0iqdwe
	 C8jlzCiiJ4LNc5imE/ZOjoPcPAchgVuGcYI/btpVooLnbolHCQLh+xL2leRm0QW3Ih
	 jACJnwd0PU5buXbHKlx5wdTa280vBY/LEsLWWJGzr7gpmB9IcvoIBuIF5opwim8Pde
	 1gmFZK/m1AwMuRCGUJQ23qY/kr5Z3LB1nYgOLgV7beVAvKy10aMW56AiUZIs7Eg73Q
	 gHCHgajqvFNvg==
Date: Sat, 1 Aug 2026 09:29:00 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Demi Marie Obenour <demiobenour@gmail.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Bartosz Golaszewski <brgl@kernel.org>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
Message-ID: <20260801162900.GA2021@quark>
References: <20260731050838.158825-1-ebiggers@kernel.org>
 <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
 <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com>
 <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>

On Sat, Aug 01, 2026 at 11:18:46AM +0200, Krzysztof Kozlowski wrote:
> On 31/07/2026 20:31, Demi Marie Obenour wrote:
> > On 7/31/26 05:06, Krzysztof Kozlowski wrote:
> >> On 31/07/2026 07:08, Eric Biggers wrote:
> >>> None of the algorithms the QCE driver registers with the crypto API are
> >>> even close to being useful.  They're massively outperformed by the
> >>
> >> The amount of patches you send towards removal of QCE is really
> >> stunning. Or rather worrying. This is like third approach or so.
> >>
> >> Your previous approaches received valid feedback, including even fixes
> >> and committment of new maintainer.
> >>
> >> But you even complained that it does receive fixes! [1]
> >>
> >> We removed the driver temporarily from typical configurations, so no one
> >> will be affected, by whatever is found now and not yet fixed. Still not
> >> enough! For you this was reason to remove the driver (AGAIN!) [2]
> > 
> > A stub driver needs to be added for power management reasons.  It turns
> > out that if there is no driver, power consumption is very high.
> > 
> >> This is beyond comprehension and very unpleasant, because you actively
> >> work against the community with this approach.
> > 
> > I trust that Bartosz can fix the driver with enough work.  However,
> > even if the QCE driver had never had a single bug, it would still not
> > be worth using.  Its performance is so poor that one should always
> > use CPU-based crypto instead.  In the default configuration, that is
> > in fact what happens.
> > 
> > The QCE's algorithm implementations only provide a way people can
> > misconfigure their systems and ruin their performance.  There are
> > debug options that also severely harm performance, but they have
> > legitimate uses during development.  The current QCE driver doesn't.
> > 
> > I have no problem with a driver for the QCE that does something actually
> > useful.  While there are disagreements about whether restricted media
> > processing is a feature or an anti-feature, my view is that it is
> > better for it to be implemented upstream than in an out-of-tree driver.
> > However, the driver as it currently exists does not implement this.
> > 
> > I expect that such a driver would not use the crypto API at all.
> > Instead, I suspect it would use dmabufs for source and destination
> > buffers and integrate with the secure world firmware in some way.
> > That means that the driver doesn't belong under drivers/crypto.
> > 
> > These are the reasons I submitted a patch to mark the driver as BROKEN,
> > which Herbert Xu has since accepted.
> 
> And Bartosz and other people committed to work on this by improving,
> fixing and in the long term providing you with the actual important user
> of this. All this was already said.
> 
> And then after having all these discussions Eric sends AGAIN patch to
> remove the driver. How many times this will have to be discussed the
> same way? If we now reach agreement the driver stays, next month again
> there will be a patch to remove it? And then one more month again?
> 
> The driver is marked as BROKEN, thus absolutely NO ONE is affected by
> any issues the driver has.
> 
> It's some personal vendetta to keep coming after that - unimportant now
> - driver.

Well, there was also feedback that BROKEN drivers should not stay in the
tree and instead just be removed.  So I was considering that feedback
too, as well as the results of additional testing and review of this
driver, including evidence that the driver performs even worse than
thought and is actually getting even worse; the performance seems
irredeemable.  As for proposing the stub driver, that is addressing the
power management issue that was mentioned on the other thread.

Anyway, it sounds like you support it being BROKEN.  Okay, but again, as
Greg mentioned
(https://lore.kernel.org/linux-crypto/2026071312-uncover-refining-8cac@gregkh/)
it is awkward to have BROKEN stuff in the tree since it cannot even be
built.  I'm not sure we can have it both ways!

- Eric
