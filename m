Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC661917DE;
	Fri, 18 Oct 2024 23:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729295655; cv=none; b=Z/OwGTDEpMkAKLXWXBa/Asf2DW6v+NXtIJO9lzLHqsAYWaVAajBwiSbZ1S2eIoeaQsGMSIje2sAKUcULXgOY/nk+0lgnbkAtB8rx8CLNSrDe0OrI8R/+uu9WIadcuVhZ3Sz5LWnU4/BlgLpC/0pvnWttT3kEzBTAADxPKHkRI+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729295655; c=relaxed/simple;
	bh=RaR858kqU+mXXHEjaDtN3IxglEfrcLqxICMUmQVAAvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jeap6Kki+y1ayWzNA19eW+YPD3h/aZCd4TsGLkAnfYe+RK08/uy6vOXO8aTiOqCm2EYk+SENLRwNFzURrX2bL19a1tB+CzqYP8aL6W/yIn0UTq/UH8XruXibykRq7ILJueU/iiOGkrEaISfGw2fWfaWnW17Jj+NJmkkaCpc/Lkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOMEAp6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOMEAp6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B996AC4CEC3;
	Fri, 18 Oct 2024 23:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729295655;
	bh=RaR858kqU+mXXHEjaDtN3IxglEfrcLqxICMUmQVAAvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IOMEAp6ZWhseG8Mo9PInNTHDs1g6NylQzmgQwOGHHtF1OKFq+N45GJamoKNUOLnk+
	 /b6TSNhnZEkvTEBVQqjOMnoJRljUpiecuCRts/PvIRdJ1B5+23YvKbIF9TFNIm5uH1
	 TqIaGjkZb6YbFS+mzHprO8Kgmx+ySAlCCN/cRoIvm/5XtxhHmL1/6uWugOR5HtRomq
	 zk1W+CknOt7e++9i5kmildzd2NAgJ8sMvYXmhzwfQjQ2agOxl+rZdlp6gXz1GV1RlD
	 3yRTreqeXPs/XFT2Y1YkxizRW7l5L7n9LSfndOwpzlzmx1x80uJcVSRv4sOEmArfvB
	 YUFKHqTNNArqw==
Date: Fri, 18 Oct 2024 16:54:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	will@kernel.org, catalin.marinas@arm.com,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v4 2/3] arm64/crc32: Reorganize bit/byte ordering macros
Message-ID: <20241018235413.GA2589@sol.localdomain>
References: <20241018075347.2821102-5-ardb+git@google.com>
 <20241018075347.2821102-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018075347.2821102-7-ardb+git@google.com>

On Fri, Oct 18, 2024 at 09:53:50AM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> In preparation for a new user, reorganize the bit/byte ordering macros
> that are used to parameterize the crc32 template code and instantiate
> CRC-32, CRC-32c and 'big endian' CRC-32.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/lib/crc32.S | 91 +++++++++-----------
>  1 file changed, 39 insertions(+), 52 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
