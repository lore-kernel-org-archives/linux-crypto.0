Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7CA379C35;
	Sat, 26 Sep 2026 17:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790443597; cv=none; b=haBL0CCmkcSVVq6LRxRoRJko4qjcMDKKqli9W5bOeMwpiMcUHIM+yDkZf4w+jF5xzECN/cGutqk6wlXoGTdHidCpjK6nQcH72gFnOUF70CPVDYIof+Tz3E4WyIs50hkY5KILcZChvc1q9VpWFiDDv5oakrZXzElXHy6GAbhX/rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790443597; c=relaxed/simple;
	bh=vtk/nvYrrT2GwC57yPJZW/gAFXHl4RsJlM0uukAupOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HeJZ/0NNIajl9sAYuCDcH+/NExKX2ZTE3AnylLBsr5d6YoNV14wEehwSv4jf5Dr88x6GwX4MCeKgx31FliRuxPl3SohXIzVuT0BGUrc4Ktu1toQgoHJ2lragGG3qLCfK1KLVrwtFs4KE/HrGAHLsnzzpLqqqBIg5GRDkOrySB3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gi05+yIl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gi05+yIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEB81F000FF;
	Sat, 26 Sep 2026 17:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790443596;
	bh=Cohpmj7mAHCD9IiQ+bXB1zRntENnHnnP556luGBj2pA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gi05+yIln6djm6RKzArCCTowfRqEhZ8NQyie2HX11P1g/gMea25/kUdiQeEx2j3j+
	 yf2xqUzedzjVlbjQvZDBZEUlYq2FKh0aYgUMwitx45aufRtiA2ACezsxWmXS7Ox5vq
	 nu4qQ9AbH3ZmPklm+QI8HCkWUEG3IiagnYDkr9jeRfV2KIPWt+9HZe10/eOTtVy+HG
	 b9rGfA6snrqXiACuyYdm7ipWopqiOWnmRh5X4BjD+DkNKDQtUL4rttkKyiHM4ZmW9W
	 GkZMc1kGqRqeCRWPJvRijb815iT3Psl9IgVgH16s3qwjgxmm6pIBEDumdbr+6sQmWx
	 +LTiOoZZ22QrA==
Date: Sat, 26 Sep 2026 10:26:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	skhan@linuxfoundation.org, me@brighamcampbell.com,
	jkoolstra@xs4all.nl, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: x86/aes-gcm - fix always true check for last
 AAD segment
Message-ID: <20260926172634.GB2460@quark>
References: <20260926145903.6061-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926145903.6061-1-raizudeen.kerneldev@gmail.com>

On Sat, Sep 26, 2026 at 08:29:03PM +0530, Mohamad Raizudeen wrote:
> In gcm_process_assoc(), a segment that is not the last one must have its
> length rounded down to a multiple of 16 bytes, as required by the
> assembly. The check for a non-last segment is `if (unlikely(assoclen))
> /* Not the last segment yet? */` where assoclen is the number of AAD
> bytes remaining after the current segment.
> 
> Since the conversion to the new scatterwalk API, assoclen is decremented
> at the end of the loop body rather than the beginning, so it still
> includes the current segment when the check executes, making the check
> always true.
> 
> As a result the last segment was rounded down as well, causing some
> avoidable extra work: an additional memcpy into the temporary buffer and
> an additional call into the assembly afte the loop. The GCM
> authentication tag is unaffected either way, so the self-tests pass and
> this went unnoticed. It is purely an efficiency issue rather than a
> correctness one.
> 
> Fix this by moving the assoclen decrement back to the beginning of the
> loop body.
> 
> Fixes: e9787deff49ea ("crypto: x86/aes-gcm - use the new scatterwalk functions")
> Cc: stable@vger.kernel.org
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

Thanks!

- Eric
