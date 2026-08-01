Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011E8280037;
	Sat,  1 Aug 2026 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785604366; cv=none; b=V/uJocpvz82IK11ib9pCQzxBdjROF7Sz7gAme5BhxBC2bIr2nJcCaFQoRWJTd3t7/l2i+G8OZ9Wt0NYNudk8Msm+f+gu0wyM25dpS4NvoQ4oBaSjtOgn9qW04oSJCvjrGdkIM5KMt8AUzRB9o3huRC6EWJK/Auxq+2Pcla8TrZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785604366; c=relaxed/simple;
	bh=FXyJNUvcREYdJmiVRpyLyPOESIE4bH+IZ1nlrammsxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVQtMi7pZGhzVXmSl2MUiDo/avxFriBuWOt2QOpu5sMuILplTbJKT8vS5w2IoMThhEHax1UwjXMoDZh4F/Xd/9qXVgPrRjPElqZqZQ13WPGwrvX5gt/vgVQYJWi7ElQ4PS3/8e1WDxO1/r9WL8Q8o5uUIaSwO0pY2V6SakVlDTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXLFDEU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXLFDEU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361451F00AC4;
	Sat,  1 Aug 2026 17:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785604364;
	bh=rCPlU7hrQPc6vJ/hKYoczMIsWwECwKwXXqOPWCqBxt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bXLFDEU6nPr4rHtHRjfCv9SehnnYYX4LeSVUi/WEZQRPyn8Azq3JDxvAcFAtjOO7C
	 XHhvyGQzBx3ruIqQm4iElOcrargZrOflp7EDhnLdHjXPkoegTZwsF7qJS7ocDuFqDP
	 AIxgJHo9+5Gn8KHjGHxk25TsKuOugF1h66vPL3qLZ3g+fzqe3rtX2Dqy3sroG276Zh
	 eB7CNnWE/DuiVk5+5fPTpzNPdgFO9ZJFbI5ArU5SR0WSv/R0Et/tqD0jZxIRlLyVFK
	 +S6ThfIUuuqaXYUh3f01UiLr5uowTOD/BWkfcsD3DUUJPef8l15Qkp97EdCoomC14E
	 iqI9FUMLZhd/A==
Date: Sat, 1 Aug 2026 10:12:42 -0700
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
Message-ID: <20260801171242.GA3567@quark>
References: <20260731050838.158825-1-ebiggers@kernel.org>
 <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
 <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com>
 <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark>
 <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>

On Sat, Aug 01, 2026 at 06:35:56PM +0200, Krzysztof Kozlowski wrote:
> On 01/08/2026 18:29, Eric Biggers wrote:
> > On Sat, Aug 01, 2026 at 11:18:46AM +0200, Krzysztof Kozlowski wrote:
> >> On 31/07/2026 20:31, Demi Marie Obenour wrote:
> >>> On 7/31/26 05:06, Krzysztof Kozlowski wrote:
> >>>> On 31/07/2026 07:08, Eric Biggers wrote:
> >>>>> None of the algorithms the QCE driver registers with the crypto API are
> >>>>> even close to being useful.  They're massively outperformed by the
> >>>>
> >>>> The amount of patches you send towards removal of QCE is really
> >>>> stunning. Or rather worrying. This is like third approach or so.
> >>>>
> >>>> Your previous approaches received valid feedback, including even fixes
> >>>> and committment of new maintainer.
> >>>>
> >>>> But you even complained that it does receive fixes! [1]
> >>>>
> >>>> We removed the driver temporarily from typical configurations, so no one
> >>>> will be affected, by whatever is found now and not yet fixed. Still not
> >>>> enough! For you this was reason to remove the driver (AGAIN!) [2]
> >>>
> >>> A stub driver needs to be added for power management reasons.  It turns
> >>> out that if there is no driver, power consumption is very high.
> >>>
> >>>> This is beyond comprehension and very unpleasant, because you actively
> >>>> work against the community with this approach.
> >>>
> >>> I trust that Bartosz can fix the driver with enough work.  However,
> >>> even if the QCE driver had never had a single bug, it would still not
> >>> be worth using.  Its performance is so poor that one should always
> >>> use CPU-based crypto instead.  In the default configuration, that is
> >>> in fact what happens.
> >>>
> >>> The QCE's algorithm implementations only provide a way people can
> >>> misconfigure their systems and ruin their performance.  There are
> >>> debug options that also severely harm performance, but they have
> >>> legitimate uses during development.  The current QCE driver doesn't.
> >>>
> >>> I have no problem with a driver for the QCE that does something actually
> >>> useful.  While there are disagreements about whether restricted media
> >>> processing is a feature or an anti-feature, my view is that it is
> >>> better for it to be implemented upstream than in an out-of-tree driver.
> >>> However, the driver as it currently exists does not implement this.
> >>>
> >>> I expect that such a driver would not use the crypto API at all.
> >>> Instead, I suspect it would use dmabufs for source and destination
> >>> buffers and integrate with the secure world firmware in some way.
> >>> That means that the driver doesn't belong under drivers/crypto.
> >>>
> >>> These are the reasons I submitted a patch to mark the driver as BROKEN,
> >>> which Herbert Xu has since accepted.
> >>
> >> And Bartosz and other people committed to work on this by improving,
> >> fixing and in the long term providing you with the actual important user
> >> of this. All this was already said.
> >>
> >> And then after having all these discussions Eric sends AGAIN patch to
> >> remove the driver. How many times this will have to be discussed the
> >> same way? If we now reach agreement the driver stays, next month again
> >> there will be a patch to remove it? And then one more month again?
> >>
> >> The driver is marked as BROKEN, thus absolutely NO ONE is affected by
> >> any issues the driver has.
> >>
> >> It's some personal vendetta to keep coming after that - unimportant now
> >> - driver.
> > 
> > Well, there was also feedback that BROKEN drivers should not stay in the
> > tree and instead just be removed.  So I was considering that feedback
> > too, as well as the results of additional testing and review of this
> > driver, including evidence that the driver performs even worse than
> > thought and is actually getting even worse; the performance seems
> > irredeemable.  As for proposing the stub driver, that is addressing the
> > power management issue that was mentioned on the other thread.
> > 
> > Anyway, it sounds like you support it being BROKEN.  Okay, but again, as
> > Greg mentioned
> > (https://lore.kernel.org/linux-crypto/2026071312-uncover-refining-8cac@gregkh/)
> > it is awkward to have BROKEN stuff in the tree since it cannot even be
> > built.  I'm not sure we can have it both ways!
> 
> Which was I think pointed already a few times that it will not stay
> BROKEN but will get fixed and get proper useful use cases.

Well, that again brings us back to the core issue which is the actual
current functionality of the driver, which is to register crypto_ahash,
crypto_skcipher, and crypto_aead algorithms with the crypto API.

It isn't useful functionality, but rather just a footgun that allows
users to misconfigure their systems, an issue I've seen happen multiple
times.  CPU-based implementations of *every one* of those algorithms
already exist.  On a typical SoC that has this hardware, the CPU-based
implementations are ~50x faster as shown in tests.  Pending patches make
the difference even greater at ~100x.  And the CPU-based implementations
actually use significantly less CPU time, as well.  There seems to be no
path forward for significantly fixing this issue, either.

Then, if these algorithms are removed, the rest of the code in the
driver (besides setting the interconnect bandwidth) becomes unused.  The
policy in the kernel for dead code is that it should be removed.  So
that is why it makes sense to drop that code as well, but really the
core issue is the crypto algorithm registrations, not the supporting
code per se.

An alternative we could consider is dropping the cra_priority further,
to further decrease the chance that these algorithms are used.  But I
feel it's hard to justify why they're there at all, if the rationale for
keeping them is "we made sure that no one can actually use them, so they
can't be causing problems anymore"...

- Eric
