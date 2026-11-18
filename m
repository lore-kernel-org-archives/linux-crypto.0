Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794984937;
	b=tDYdPTppIsVojdgJk1HXpg3s9xRGCMuCTfa04yKn5sC/E4cgvF5mO3l5Wxr0gWVLpWfd
	 I4Gb65SNSXTNWDUw5bZ4HyfK61vMbgxbo00zmNRnv1waNIBFhpcV0rNGnMQkAo2AM1Axj
	 VHT2ieYVV+3F+6yjXX7Yycr519o2yfJ4ELQUMYJy7pZ8fi72xJgelOBYWT+bv/H52/Ifl
	 Lf5LcI4kHl/M96oBPL6SqkxqQEel1+OFLFCSxMER8RhxyrAb+gKCEvkcl0ZUEp5U1hw5L
	 Fae3ugSdMJyNQa8kZr5p7Lk41oGhvWqLGQfAASo9uc6I/3E5QfmnX5NxyOL4/3wcBBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794984937;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=EkC1xmrdSe6SpKujfgj0oObZ2qflBpi9gZOvT2StZUw=;
	b=b8jRAGJ3XzYlIBWqMjS1ZAJFJGWhd5ZpcJaFX6KxvLAXb5pgCosZTzYS6lISbOs5Ndq2
	 JJO8GWyBy8TnHYxCUFCSibI7EulPlTPwphgkXYgmK1vh6ub2ykxKXJcqNEZxj/OqkO0Qw
	 pnZkcvvS7AegmTdJzSdQOQ/gL4je+eeb9V72JSv0wiO2jjuwsHo/5dRIBMVxI0YiEeCyr
	 5KghGg0QSHhd5jzxXqWYonQJRdJ0KeFz1+S7IYW+LsqIJUMs0Czjy/VwIWGf5NU7YlZtk
	 8FvX7KdkM74bHosHW78S0LExL3+jISx2HQCHPHGMmWuxBgnnhpCcxyRx8RDBLJ2cngw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aoxRek8t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149E4606A31C;
	Wed, 18 Nov 2026 06:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aoxRek8t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756831F000C4;
	Wed, 18 Nov 2026 06:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794984936;
	bh=EkC1xmrdSe6SpKujfgj0oObZ2qflBpi9gZOvT2StZUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aoxRek8t34JeWDlPj7r2Vw8s9aUb0anTaZc7dUbjJ6Y8l8vcIZG4VcnOAX28psqMf
	 XuBs+W511jZdXZKbLe6zFPALqlmaMWtaCLYE+FU6sQv0ViwzSuO473Ws62egFoeVFS
	 WYZRm6yvvSo2XW9YNucjs5q3jHQyNfysFIsEMBRYQA9nYUTHsJk/GN6mwY1hV/auzt
	 TOXNqZ5Rrpezy+6ygDW+3tqQQMLHWWm9yMVoje8WYDezeI0jOarZN5PTT5cI+acpm6
	 w1mdX8IfRj0rdSP1zkaRxQtrwBlqoYlclpqZzoH8Ysss1cOOET6Bnh+T03c0ISYYNK
	 08+710fsc5Fbw==
Date: Tue, 17 Nov 2026 22:55:35 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Haoxiang Li <haoxiang_li2024@163.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, johnpol@2ka.mipt.ru,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hifn_795x - Free walk pages on session setup
 failure
Message-ID: <20261118065535.GA95982@sol>
References: <20261118061917.2093148-1-haoxiang_li2024@163.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118061917.2093148-1-haoxiang_li2024@163.com>

On Wed, Nov 18, 2026 at 02:19:17PM +0800, Haoxiang Li wrote:
> hifn_setup_session() allocates temporary pages for misaligned destination
> buffers. If the scatterlist walk fails or the hardware queue has
> insufficient capacity, these pages are not released. Retrying a queued
> request reinitializes the walk cache, losing the previous page pointers.
> Add a separate cleanup path to release the pages for misaligned requests.
> 
> Fixes: f7d0561ea1da ("[CRYPTO] hifn_795x: HIFN 795x driver")
> Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
> ---
>  drivers/crypto/hifn_795x.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

We should just delete this driver.  It is heavily broken, 32-bit only,
and no one seems to have used it since 2008.

- Eric
