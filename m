Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F191B412B;
	Thu, 24 Apr 2025 15:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745510180; cv=none; b=MsAG0v7dzNWxppwQ54bbvhEUHuIc1sCrGSynCS+oNMTr/zT/m9BJjLVlutuFtGaMLv9S4HBsqgmwMhA8MQmoHFhX17e7gfQK2DZa4D7VYpQsBFKgkDlvhwMIu+wdXvWQH4CDfJ1ezEKUbYo7wG2M61WVDBqXZycvyn6Gk4/LXBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745510180; c=relaxed/simple;
	bh=y2p+z9dUYyluwx+0SRA6fxlC3xgI/3wXzz+2ClZ4pyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PG4ML2E2KRTpxhIyQXfEtL8l8iIw6eEUEOuoPDs9jO/3ckr+sZrRzOx8vE0TsLVjVVuhS6iI2dwnkYnYFGQxWBKXcHALq3wNrRJ8XABxzhC/Ig9FsTtOumeBU+FenYEQuUwGJ5aIgSuHvovBh4iYeuuibx88/J8ERBtYe2feAhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eTIY6pQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eTIY6pQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F379C4CEE3;
	Thu, 24 Apr 2025 15:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745510179;
	bh=y2p+z9dUYyluwx+0SRA6fxlC3xgI/3wXzz+2ClZ4pyI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eTIY6pQOliQE2LbVC0fitqlCaHvvShtOKF+64C66o5TR9UZAfIdBWphy/L3Jqvrgj
	 ZJ67HkRdovXOe80DwbPBgu+v5aSLgV/zLMxSvFCvYyH5Apfovwqe5Tx5BS1GaNH6i5
	 y3IfOwyVMfFMxYtcL8DXvEJYxtAIdOV8ynASjUM7fGzWGwch/1sxq5bc6K9AEPYL53
	 Z3Lzhvq0zjHk5EzTa/Y/fMEmemBcCpy8LwsL9/98c0a4W1HFCZiX99Ly+wRrnYlCrk
	 yCovKQqpJXbQLIPkGT60BPPeB+cVs9Ke+3867DFByk0i2KYZlOQIemcTz0qfisIoIN
	 vZZfSu8wn1sIw==
Date: Thu, 24 Apr 2025 08:56:17 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/9] crypto: testmgr - replace
 CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS
Message-ID: <20250424155617.GD2427@sol.localdomain>
References: <20250422152151.3691-6-ebiggers@kernel.org>
 <aAoKDnfJLyI7n58S@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAoKDnfJLyI7n58S@gondor.apana.org.au>

On Thu, Apr 24, 2025 at 05:53:18PM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > -config CRYPTO_MANAGER_DISABLE_TESTS
> > -       bool "Disable run-time self tests"
> > -       default y
> > +config CRYPTO_SELFTESTS
> > +       bool "Enable crypto self-tests"
> >        help
> 
> Please add a dependency on EXPERT.
> 

If there's going to be a dependency to keep most users from seeing this,
wouldn't DEBUG_KERNEL be more appropriate?

- Eric
