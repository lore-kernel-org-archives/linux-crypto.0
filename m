Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A481F8676;
	Mon, 16 Jun 2025 16:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750092916; cv=none; b=S5YzzAy6CD2yYOuPP97sO1WwiV7gxyUIHaREHebQq8oK0S1dSR8YsfCDEsfLkWTNeOiU25aDRHcZxOzGjTJBG3Ga1OcTVhBPadufizZmQQNTz8+ZCCr3r/ooCoLNcOtWn0meP4n32MtjUMMEt2+PCikfCuMwo5u735m+2z6HGcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750092916; c=relaxed/simple;
	bh=lt6J6tqXO8u375Qb7hEC9V7ZScy7Q1qWWJWpOH2NVnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=otPYUHzxaFXayhbjaKwF4+glfPGH4jayLoNJIvi+4J6KGr2LEYxMH1ZJ83HrZn6OdXbTBm9aQ6ocfbD9GnPMl8+0WWVW1Z8IBbBtqpBf030Ev9MQ4zsOj0zUuJSPtRdTl0h5pHxkbmH91+X0D7NDIOApbPGR7lQ5+6P6CYDS58U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRdNCVgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRdNCVgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B24C4CEEA;
	Mon, 16 Jun 2025 16:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750092915;
	bh=lt6J6tqXO8u375Qb7hEC9V7ZScy7Q1qWWJWpOH2NVnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TRdNCVgZlBIi5SVuXpvY3G0ctYiaD7thwbicW+ywFz8DFVBXP9mDt+pNwecNBr1Sg
	 li/JG+SYNg8mrSrTngvT56xyMuGQwe/082XVs3i1eqFjTaF8bgkj/EMrdE2T3QImfc
	 vNzfK+3fI449KGLrD77Ifzlm6lhLrPczphJCF+kTkglXDLYM6oPD9gjdKZPMCsy6DM
	 v7mY6aV97hRl/zLnbwgQLji+CNXeiCxmYnVANhtEcR9PL51zTB7l+aroI6uPoQBoD9
	 IB9Coe7Tw/PQtQh5yErAjEuNPt6ISjh8xQguzbiSwWoFNASFkjF+IWP6j8f6VhZD5f
	 ejAS+hSh+ynIw==
Date: Mon, 16 Jun 2025 09:54:46 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - lower priority for skcipher and aead
 algorithms
Message-ID: <20250616165446.GC1373@sol>
References: <20250613103309.22440-1-giovanni.cabiddu@intel.com>
 <aE-a-q_wQ5qNFcF_@gondor.apana.org.au>
 <aFAyBgwCUN2NLXOE@gcabiddu-mobl.ger.corp.intel.com>
 <20250616164752.GB1373@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616164752.GB1373@sol>

On Mon, Jun 16, 2025 at 09:47:52AM -0700, Eric Biggers wrote:
> Emerald Rapids processors have 6 to 60 cores per socket.  Even assuming that a
> second thread in each core provides no benefit due to competing for the same
> core's resources, that would be an AES-128-XTS throughput of 110 to 1100 GB/s.

Small correction: Emerald Rapids is 8-64 cores per socket, not 6-60.  (I was
accidentally looking at Sapphire Rapids info.)  That just makes the VAES
throughput even higher.

- Eric
