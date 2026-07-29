Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448F82BEFF6;
	Wed, 29 Jul 2026 17:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785345534; cv=none; b=G3hDgJ3SqbUO0JYd9tCGNwefcp6Q204zEc8WJCliNYH84iZtaXxRLDfM4RQD0WPhSxXV66ZFBnUS8c/G29al0wZ/54uJGeTlse4fj3CONhmdThr2AYCb4nDPCVcF3hQ1YcwWzLp9wVSEQ9VOgjSCQaA7Ebd2QppxQWenf0Qs2gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785345534; c=relaxed/simple;
	bh=YE2LdluA4GvGR6IM7unXihvs9bwrb8WIgmcEUbn3Bsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pMhAI4dW3NNtvrkQTDiohZXQ6DaWaq58vLpjTNW7fSuy4XIP/ATiC0MvAcBPh76YPCyyxJlk7YOjthK+SCeWDDJ30C9yQPusnjAct7Ozs9AOw6Fd2gOFdiM8MAtLjT+HjvewcFzV5tLn78ZS2tsWhUq/0GV6PU1Yp6DGdAg5yBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ViK0zRp4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ViK0zRp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6928B1F000E9;
	Wed, 29 Jul 2026 17:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785345532;
	bh=XRQ2w9SEWqa3KGSO4eP0kr7mEec58GfHOL/Fav5sanw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ViK0zRp4UdqVs45klAkMoXtTi2CTs467E9pwdsgs5r3Yg1VjidQf4bd1p68yPtKjt
	 hcKexf22HQhcHXxAIA6AqTsbWdNseueG46m+kwOehTQshWaOyKKe/geb6koJWLni8t
	 yb64ORX73U4d82W4TottqTSKBOvgf3aXPR9Ic/s3zXWZiF7o2eKDOtWD5CPburWfGN
	 PKvcervMzSyfEQTVtxqeGxnngIrYvm6aryLb7z0jxvveVH3G5zhH5Lawrz+6GIa0we
	 JlzaYfNRUbZ9019emFTgEP5Xv2F7dPUZOZ/uBHurURXDFnvNPRkggNqCsCH+Bq16gc
	 sHdpkZ0B5CcHw==
Date: Wed, 29 Jul 2026 10:18:50 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Konrad Dybcio <konradybcio@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: [PATCH] crypto: qce - Remove driver
Message-ID: <20260729171850.GA4454@quark>
References: <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh>
 <20260724150932.GA6763@sol>
 <2026072428-ungodly-outsource-b20c@gregkh>
 <20260724155144.GA2032@sol>
 <20260728152241.GA4281@quark>
 <15904301-fd03-45e5-b909-dfce52449726@kernel.org>
 <20260729145520.GA1702@sol>
 <50d9d0e4-28c9-42b6-8b71-e75682b4959c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50d9d0e4-28c9-42b6-8b71-e75682b4959c@oss.qualcomm.com>

On Wed, Jul 29, 2026 at 06:55:20PM +0200, Konrad Dybcio wrote:
> >> Unfortunately removing it drains way more battery, because the buses
> >> never hit sync_state and are kept at their maximum frequencies:
> >>
> >> [   18.021823] qnoc-glymur interconnect-1: sync_state() pending due to 1dfa000.crypto
> >> [   18.029605] qnoc-glymur 16e0000.interconnect: sync_state() pending due to 1dfa000.crypto
> >>
> >> (it transiently also pins DRAM and friends to max-freq which absolutely
> >> kills battery life)
> > 
> > Isn't that easily fixable by marking the node as "disabled" in the
> > device tree, or even just deleting it entirely?
> 
> Avoided? Yes. Fixed? No. The DT is valid but Linux can't deal with it
> [since the driver is gone]

If needed we can keep a stub driver that just disables power and doesn't
register anything with the crypto API.  I can send a patch that does
that.

This is an interesting twist though, because it means the claim that
people can just disable this driver in their kconfig to avoid the
problems in it (which is being used as justification for keeping it) is
actually false as well.  As well as the claim that adding the node to
the DT file is "just describing the hardware" and has no impact.

This would also imply that no driver using this sync_state mechanism can
ever be completely removed from Linux, ever, which seems odd.

- Eric
