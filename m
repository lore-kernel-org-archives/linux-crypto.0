Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B82C8F58
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730262708; cv=none; b=L10TOY6bgQUH7mEyhqsLnwMGVVCHzQkFZMIHXHJQk5nCi7soWHZtGGzwb/utUWTiJOAoj/O40ul51lhv/NSLc0xDmV0JKj20mMIKa1+2wkGi3gCIiWrZpM9bvV8i+6/AIQYRdJSVc4HCPanXvAygCqJ7kQGKKF46jWcZdI2x2fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730262708; c=relaxed/simple;
	bh=36OA5GmB8F/k+0bQ7m27Dl7eZE0oZCVspueUWP6QG2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXmCmkytah4oYfWfv2ANJSKWmbxl8wo41O+M3DDTWRQQMPCdCjB6Cy+JFzOISaLwWZwcwcsOzKy7wvecFzOkyFZJ3hO2a4PyGbjz1/PcR+e0+hgxZHJyqogu2poyRJG5bKYydC1aNXar3NU+gJASKb2yuMcqd2CmQfHDwJYBEKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WNdsR/K4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WNdsR/K4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7BCC4CEE4;
	Wed, 30 Oct 2024 04:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730262707;
	bh=36OA5GmB8F/k+0bQ7m27Dl7eZE0oZCVspueUWP6QG2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WNdsR/K4U7mt9oDNuH/6biL7Gpa0DlpEw2h0eNlWDChA5NDvGXSP4OzEflxy3m4h2
	 uTPhelDc+HtsTMZBP/B/vK8GN6xuyCpOeDm5Ti6z5189dE1bF3xmpt6mKMiQMLFm+7
	 fnk9e7hrxAQyOPal7AbR4zsJnGZAGyDdBc5wcaw3tECEZPGeD/5X7oEiO+DsO3/H8u
	 0yEvRol7IgUxeGkkJfNkbVDgAg/5AiZmrYZxiY/8VA9BuLVDbTd+aZy1C3uq8bkx9P
	 rPCmyVcybfM+CBDTyxKXv3HCMGezi4xUKh5E42MKV9zppBZhbdhrT3zVu2uTHVnrK8
	 21dep+cQcZNYw==
Date: Tue, 29 Oct 2024 21:31:46 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	herbert@gondor.apana.org.au, keescook@chromium.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 5/6] crypto: arm/crct10dif - Macroify PMULL asm code
Message-ID: <20241030043146.GE1489@sol.localdomain>
References: <20241028190207.1394367-8-ardb+git@google.com>
 <20241028190207.1394367-13-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028190207.1394367-13-ardb+git@google.com>

On Mon, Oct 28, 2024 at 08:02:13PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> To allow an alternative version to be created of the PMULL based
> CRC-T10DIF algorithm, turn the bulk of it into a macro, except for the
> final reduction, which will only be used by the existing version.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm/crypto/crct10dif-ce-core.S | 154 ++++++++++----------
>  arch/arm/crypto/crct10dif-ce-glue.c |  10 +-
>  2 files changed, 83 insertions(+), 81 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
