Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8333CAA3F;
	Fri, 31 Jul 2026 10:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785492157; cv=none; b=a5+t3Vooh+68YN+Y4lYGwdRxT2AOe9jq2bYHpsKrXWNcRuYxPUMIDMd/el89JRu4v9/pyzelnluK47Tb1E5bf6C6l292YyeoWqQk/twdJfcVRqpYG9XEWnX0+wW8mLLHVmLJvP3VH/KHPmf4DFzbhKuh7s9bCDeee0npeSslNFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785492157; c=relaxed/simple;
	bh=FUduY7tWLASZrcSw8TtVHt0V8RXPZq296XCDQjwFtv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AHQXPm3LOnXQ98zZVmKt7FvHFssurCBRnVAsdOD7Z/pE6c8G3FIq7qTOdJ7f1jtU5I/e8t68Wk5d6nyoAAJKdPNbf1j6NsQWZk81ZUmyyUIp6kb1j+ojvis97ZOwqdJ35es8lOGFmG1O0WzMuOmtgKOpV6PsZA6Z1mbzN2w92mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5M2BKEK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5M2BKEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA4F1F000E9;
	Fri, 31 Jul 2026 10:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785492136;
	bh=77G49YQpBUvEnOvrM605Fie9t3iRyjf5tMxXuwe9XDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R5M2BKEKtAdUQ+F6ksjbzVhCWpjCShK2W+WbD8gJpxGMQpF9JdWJH1s96jIY8dJ5f
	 yaD+cKvQlw4K0J9uyig7Qk/lZNm1d9SNAe2Bb+tcKbdpF0Xf0Wg3tyGmABvoP6C3Sb
	 +7oVh2sF6e554RrUp576TR/33hEXP1rQiaX0r1f0RJj5z9c1wIuwx3cydI4P8VXRU/
	 Er/V8H48fjzOMRsHqqjQpud71PieY7rcCk2nS6KsHB8kK8MDFahjabhyaaz6+ZqF1D
	 7bvk2myLEzb/Xz7yp4hGwzQBcyIrVdvlRROAONbokRX8AfaFRefyuxc2OfKQtYHb/o
	 /MYl3CC0VChYA==
Date: Fri, 31 Jul 2026 03:02:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
Message-ID: <20260731100214.GA1927@quark>
References: <20260731050838.158825-1-ebiggers@kernel.org>
 <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>

On Fri, Jul 31, 2026 at 11:06:28AM +0200, Krzysztof Kozlowski wrote:
> On 31/07/2026 07:08, Eric Biggers wrote:
> > None of the algorithms the QCE driver registers with the crypto API are
> > even close to being useful.  They're massively outperformed by the
> 
> The amount of patches you send towards removal of QCE is really
> stunning. Or rather worrying. This is like third approach or so.

Note that the crypto maintainer has already accepted a patch from
another developer to mark this driver as BROKEN.

> This is beyond comprehension and very unpleasant, because you actively
> work against the community with this approach.

"The community" is more than the hardware vendor.

I think the results of independent testing of this driver are incredibly
clear.  The pending fixes do not fix the performance either, but
actually make it worse.

I have been asking for the inclusion of this driver to be justified for
many years.  As far as I've ever been able to tell it's just a "checkbox
feature", which isn't something that really belongs upstream.

I care about the technical merit of the kernel's cryptographic algorithm
implementations.

- Eric
