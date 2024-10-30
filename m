Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE478C07
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 03:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730260487; cv=none; b=U9C8kWGP2+VZJh0ZNqMbL27jwCPBDc6OpSUYOFX6ydv11gcc7ACsqqhhSgj6AvloMZkyyJE4wA4GnSzSvDjruepe+mVM7HrDEkGWzSvpZfaFJviuBzBt74REzhHO4v8QDiUwu6GTszx6VqGKNzgl11yyxy7xaxkAceXrqV70FYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730260487; c=relaxed/simple;
	bh=m9jRoaIjj0R3IBUXDEbeFOIY1S2xyAMDH0k/CvRVTYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YWRUNQ0kH4+Ut+d5TxVGnX4JYyH3CHeuOQP0NawxPUVMIIYU7xZRs7EX7RJMY6Et5y3rAi5QYcxe+2YDkZSX+WGxa5j3F1isuyCgU6W/bcvkdM1Jl4r8XmKFC3i2QKnNALTjjnesG5CK33dNzdr1YQNRQU2M+/rlDroeFaBk8+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F6VEzGM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F6VEzGM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E18C4CEC7;
	Wed, 30 Oct 2024 03:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730260487;
	bh=m9jRoaIjj0R3IBUXDEbeFOIY1S2xyAMDH0k/CvRVTYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F6VEzGM4OLD0pv9QDVMHcAbG2j6QHoNg45lYOw+iCNGs1NApsMbi+AJA7yOHrP037
	 xcptzsNLK6Q5XeGjMPV2dbxFLJdGI4s1HgnnnLGs/FqVGa+9lqirrhZNi+q3ppYbO9
	 bKb8o4AFxLL4s/T0/G3dCAmh55O/Rbsh7rPB9pZGD3pz9ydp9HbBMrST60vCmamqab
	 WFoMNbiA8DXScTxKS6hiKauokbW0w0cVeGpTuKqSOHH4G+RDB6oXusmNIc0uRrRl0D
	 LhIoOGx6Jk2XaBL56e6qTy4QPIFxkTJe9LfJ+xptpquwzbf6vJy1vbHDaPo8SF4FVq
	 vj6Uyy4+U1SMA==
Date: Tue, 29 Oct 2024 20:54:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	herbert@gondor.apana.org.au, keescook@chromium.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 1/6] crypto: arm64/crct10dif - Remove obsolete chunking
 logic
Message-ID: <20241030035445.GA1489@sol.localdomain>
References: <20241028190207.1394367-8-ardb+git@google.com>
 <20241028190207.1394367-9-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028190207.1394367-9-ardb+git@google.com>

On Mon, Oct 28, 2024 at 08:02:09PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> This is a partial revert of commit fc754c024a343b, which moved the logic
> into C code which ensures that kernel mode NEON code does not hog the
> CPU for too long.
> 
> This is no longer needed now that kernel mode NEON no longer disables
> preemption, so we can drop this.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/crct10dif-ce-glue.c | 30 ++++----------------
>  1 file changed, 6 insertions(+), 24 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
