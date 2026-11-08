Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794139880;
	b=uhfIFvwzuQlLIxxpHKboOQ7ebA/tf/oIJMWIhH5G+AIGiqIQguQ7JB2kGoKBhUZg3358
	 ofmU2+79tsfoI2b6TmR3uhF8CuMhj2VAznvr5LTvcFEc8av8Thi6a+kGGlXctaCYvtuKk
	 JgBPabHgwC141hwZorzUZVHM2DHJrTXS+lvxDs4zXMo1LW5TncE+XzXnWww/Ccn1jVr9a
	 aH+hZlqAP5OK0wjn1IGkx/2/Na7kmqE5/5fPYF3oafw0UJvnpAVREVPsai6WCA08EwVo6
	 cBS87puxBJkRvR4togoP+VRZL1LVTLmp9+wZNW/BiwixacL0/PEdHoI7l+Q83uE8jvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794139880;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=QVI8sd699n7zElT6QIRsFdi0yYPm7wfLMGKXZlF23is=;
	b=oqDZlS2ew5Rp9nIg+fUv3yBvqMiRrYd4gI4ZoDDgB/FUbh75wQn7G97npIt4H+vPQkNa
	 j9dwvccoQrCZ1BLnfSZtref1C7sZpD/FpavcYHWmE8uY1s993L23ZuqpByxZ4jGyFD0OL
	 c8AZbj/F99FDM1gxwy2wcr9RiAsht4+jSWu/EMPMOyyvEOVVQ5CUotFnsm8bYMFnRF9fN
	 +z50au0rr3sNXYMryvt8tt+1v98Oix9QFtiwBk58WD17j8WYnuEu2/MvfDKbCvlJOS84y
	 LFa3al51TC1wnr6TtBqLwmMAE9iKo5xuFyWgBTdC6P/+VmbjB/AvH01ngrQujP91YZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GOmBv2b6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F53A606A323;
	Sun,  8 Nov 2026 12:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GOmBv2b6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD491F008A2;
	Sun,  8 Nov 2026 12:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794139880;
	bh=QVI8sd699n7zElT6QIRsFdi0yYPm7wfLMGKXZlF23is=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GOmBv2b6mDfrmIW245A8RprJGp1WFAiN1Si/80n/CY3MRC93DXThe3GXj5YREGne7
	 ZtcI3oE/ELxrK2wVEfJWDLnZ2yDJiDvxvxlbgav8bVBr78sLzOTXTZ/eyib6kvNNUO
	 RLxMSjKJgLH6X/H+RwNPedyGKFQAtFFJ6SPhWZy+bXKxHmVLJDz0/W+/Qg6GJUDPHs
	 PnKNlK5CcV4+kpukNZNcVXKLrOL7pt84E0EfGImVFCJKSnLIasV4RqZtLEnD0mly+F
	 TnTXzJebKZDMnEh8rCrVTYrtbpUlOTHQEE5XdZ+3MauwpcaJIeUfxf0e5l4VMjLLuP
	 k6+y6bK968pPg==
Date: Sun, 8 Nov 2026 13:11:06 +0100
From: Joshua Crofts <crofts@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: omap-sham: remove redundant
 pm_runtime_dont_use_autosuspend() calls
Message-ID: <20261108131106.0fde6459@systembl0wer>
In-Reply-To: <20261107-crypto-dont-use-autosuspend-removal-v1-1-62696ad3ff0e@kernel.org>
References: <20261107-crypto-dont-use-autosuspend-removal-v1-1-62696ad3ff0e@kernel.org>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 07 Nov 2026 13:39:43 +0100
Joshua Crofts <crofts@kernel.org> wrote:

> Since commit d1706f9da9f4 ("PM: runtime: call pm_runtime_dont_use_autosuspend() on reinit()"),
> driver core is now responsible for undoing any
> pm_runtime_use_autosuspend() calls on driver exit.
> 
> Remove the redundant function calls.
> 
> Signed-off-by: Joshua Crofts <crofts@kernel.org>
> ---
>  drivers/crypto/omap-sham.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 5e739415a010..72182f190084 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -2109,7 +2109,6 @@ static int omap_sham_probe(struct platform_device *pdev)
>  	list_del(&dd->list);
>  	spin_unlock_bh(&sham.lock);
>  err_pm:
> -	pm_runtime_dont_use_autosuspend(dev);
>  	pm_runtime_disable(dev);
>  	if (!dd->polling_mode)
>  		dma_release_channel(dd->dma_lch);
> @@ -2131,7 +2130,6 @@ static void omap_sham_remove(struct platform_device *pdev)
>  	omap_sham_unregister_algs(dd->pdata);
>  	crypto_engine_exit(dd->engine);
>  	cancel_work_sync(&dd->done_task);
> -	pm_runtime_dont_use_autosuspend(&pdev->dev);

Okay, drop this patch for the time being - the dont_use_autosuspend() ensures
that the .runtime_suspend callback is executed.

Thanks.

--
Kind regards,
Joshua Crofts
