Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3105C28EB
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 04:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730262556; cv=none; b=nEQJMYn3iR/Ce0AtrPuKNEkbRiDoBImwrcuXiTcba1t5SwN0JjDm/H8+qvyVbQXDZitzHEvpPuZI9TeGvMAjvQgvCKq1zG2PDIeoWpz1fBbgYLl5wTl8UFa3fcNOYidZGuEN0/MxozgQl8AkNkeBsLFN8i9SbQfNC9r965tfvj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730262556; c=relaxed/simple;
	bh=I5QSLHyldsBrSOgK2QeLUkpFngdmQHYOQ/3tNOCCEdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YhFGk8iHQA7tKrHg9buLH6E3OxBePf9Wn3cUA3XhXR76OIFvZCeap6pKxd2m3kMUZ81YvU7UohAqb2ga3eEhhKAWlOrzzl+pSJqCCMTBDpS67EyrRt+7pHBdz2iDjY/l8uSmAOPYtq3Z6AkBIVp4rs3WsAve50uykPI1COsZjTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BW66w1du; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BW66w1du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDE5C4CEE4;
	Wed, 30 Oct 2024 04:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730262553;
	bh=I5QSLHyldsBrSOgK2QeLUkpFngdmQHYOQ/3tNOCCEdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BW66w1duAm8oxkGdkhZpeNU+ZyojHVFYlN8GfVwTBksZtjDeYKErxw75+UqfdQmfK
	 Ge2HAgPzVpQFtJJb23p/Dto/krsNrDPl1Ynp0wCA5t92GaoifQ3HbPFJk3VxZawdbh
	 mrSXU35bGOqA3/uImI5xCVB5bBRQ2TNzUxp4x3ycu8CGDk8O7+4G9yRVuZfwKreOei
	 7jnhxqrwvOkLPWPmblySSjmZYdHZEGJBF3Wt+TlknV5nXFYqah9OScRMgSWEzeRPOV
	 4ovvIFlts9F/lJj3hdL/EgtKi4UIPC7eP73yCvowpPpwOTHs0BQ18OmPSYpLACOG0l
	 bwVk37jhyKVsw==
Date: Tue, 29 Oct 2024 21:29:11 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	herbert@gondor.apana.org.au, keescook@chromium.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 4/6] crypto: arm/crct10dif - Use existing mov_l macro
 instead of __adrl
Message-ID: <20241030042911.GD1489@sol.localdomain>
References: <20241028190207.1394367-8-ardb+git@google.com>
 <20241028190207.1394367-12-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028190207.1394367-12-ardb+git@google.com>

On Mon, Oct 28, 2024 at 08:02:12PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm/crypto/crct10dif-ce-core.S | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
