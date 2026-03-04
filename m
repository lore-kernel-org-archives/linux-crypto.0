Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E051DFF7;
	Wed,  4 Mar 2026 00:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772584211; cv=none; b=fOt2PXhXeDMhKJLCytzvOClHujIvAr+WMAkWamEesK3fpYVOcGheWfBtkTi9JzuhO0YYnzHRtghnkRigo5daFSUdAV5yrDPwDHPwrrnxa9jX4K/b0r37bkWA8N00WR3KvU5VXCak4BbA/N9Qm2u+T4mcu+e3Nm84EHvB+V0r7d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772584211; c=relaxed/simple;
	bh=lNL1r64FGykHBx8grKvpUHjXyS8CCN+gZT8S1auxfQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mxDEV8dOc0Y/+EKB5QSmS/ZA7DoP9NIFGBl4jfhWNA5eg87f83o1us+hkp85b2khHT2Ut0xqOQtSGHxx89ZS46zcVGdjHyR8M6fawSo+lzTR64PVwfrSVqhzPmj2NLLc18furuSlg2KJMSUDmWYu+c4FyqyypbbnkNrb/XqrbE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IxzQ4oXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxzQ4oXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E8AC116C6;
	Wed,  4 Mar 2026 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772584211;
	bh=lNL1r64FGykHBx8grKvpUHjXyS8CCN+gZT8S1auxfQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IxzQ4oXvdSg25kw31LYCLMdPw578Gk2qfBVTBAY9F219aZ0+nheKdJXAPz7SLxJfw
	 WkoJQWSZWHrRbbC1S1N9lyBGpAqkRA9+gm0taHtzVVbhZ2TpuFA8XUxJA2hLhFuuOJ
	 lzJw80wkhbPbCeyXfyp+N3lkIUA7Y3XBvZxeGaP2RHs6YSx2jDRHtPaXrDJKd5GKfe
	 n30OY2J65sEoaJ/BMpNanJeVJuPRMcn45eLWGeeyH8w5wi+sdlp/Kt06wjfqLYCFNA
	 9ay/zYCBQqx7Gs9wYAfisa7H0QVrOy08kmFLlaXTBNs+Zc+FmUthgMvzwHtBw7a0Je
	 vE93ZIxOoICXw==
Date: Tue, 3 Mar 2026 16:30:04 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Chris Leech <cleech@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 04/21] nvme-auth: common: add KUnit tests for TLS key
 derivation
Message-ID: <20260304003004.GB57956@quark>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-5-ebiggers@kernel.org>
 <1de7ef59-4236-4372-81f6-60d5a4f1e253@suse.de>
 <20260303002649.GE20209@quark>
 <20260303-slush-hydrated-8b1929ec6a30@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303-slush-hydrated-8b1929ec6a30@redhat.com>

On Tue, Mar 03, 2026 at 02:47:56PM -0800, Chris Leech wrote:
> On Mon, Mar 02, 2026 at 04:26:49PM -0800, Eric Biggers wrote:
> > On Mon, Mar 02, 2026 at 11:04:43AM +0100, Hannes Reinecke wrote:
> > > Which discrepancies do you see between the specified algorithm
> > > and the implementation?
> > 
> > I'm looking at the latest NVM Express Base Specification, v2.3.
> > 
> > First, there's the following:
> > 
> >     The host computes KS as the hash of the ephemeral DH key resulting
> >     from the combination of the random value y selected by the host with
> >     the DH exponential (i.e., gx mod p) received from the controller
> >     (i.e., KS = H((gx mod p)y mod p) = H(gxy mod p)).
> > 
> > The actual code skips that step when deriving the PSK, and just
> > considers the DH value directly to be "KS" and uses it directly as an
> > HMAC key.  That is something that should never be done.  DH values are
> > not uniformly distributed and must not be used directly as keys.
> 
> I'm doing some testing with a patch to immediatly hash the DH value
> after the kpp request is complete, fixing nvme_auth_generate_psk(),
> while removing the hashing step from nvme_auth_augmented_challenge().
> That only allows the use of KS as the raw DH output is not saved.

Yes, that's the right way to do it.

> But, I think things are saved by DH values always being larger than the
> HMAC block size and therefor hashed within hmac_shaXXX_preparekey().
> Maybe more lucky than correct, but the same result.

Interesting.  Yes, that might work, but only by accident.

- Eric
