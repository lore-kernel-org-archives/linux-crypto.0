Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCD6204944;
	Wed,  6 Nov 2024 20:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730924276; cv=none; b=XdDUBZeYCU6gtChShyk570aAWVo6ZIWL+7RN+u5RXuBeziMdvT0mHfuDYrYpiqxt6dvx62IF5+Ntlpjmf0EEGlMqRvSPIKy9iK6J0DyThdWUoC+d37L8873mjpjbjCMnnNtQ5FSLVGvuifAzb1dy/2GZbZh+Cv3V+ZRGWrV4UTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730924276; c=relaxed/simple;
	bh=WwTbFmFx1P5sUSsJ6hCKDOYwNpexIk7UJAsHBsokrdg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=kQOwK4MaOhlmUVKJNTPszrZBrbQiUZaaEHmHJXoqjIkTktua44+q9bmDtYLW4J9ihY3cdSUSiM1BXxgf1s9Bha33Ysci566dx9o5kUbxZwXSalLxNFTA5DPvh4ju4wB8PCMF08lmHdW17MYzrcvtn0z0xJvHo35Ug8OKBmlsc6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UEEEZG5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UEEEZG5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E915C4CEC6;
	Wed,  6 Nov 2024 20:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730924276;
	bh=WwTbFmFx1P5sUSsJ6hCKDOYwNpexIk7UJAsHBsokrdg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UEEEZG5pndg/EOyEjAyK7t8vb4dIDrTcpK1dd05wHxYVFVMl+8hxjU1c1OaOuj5lE
	 THQu6/35mNaHTejGY+7FlPHigfFPwdLARBPnNaNWx4w3P3MdRcWjuOzCAM31Y1Q+sP
	 O6zQ005Nmd4huqj5qC2WARKtMuEAJp7g6rmXkAk0=
Date: Wed, 6 Nov 2024 12:17:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
 yosryahmed@google.com, nphamcs@gmail.com, chengming.zhou@linux.dev,
 usamaarif642@gmail.com, ryan.roberts@arm.com, ying.huang@intel.com,
 21cnbao@gmail.com, linux-crypto@vger.kernel.org,
 herbert@gondor.apana.org.au, davem@davemloft.net, clabbe@baylibre.com,
 ardb@kernel.org, ebiggers@google.com, surenb@google.com,
 kristen.c.accardi@intel.com, zanussi@kernel.org, wajdi.k.feghali@intel.com,
 vinodh.gopal@intel.com
Subject: Re: [PATCH v3 12/13] mm: Add sysctl vm.compress-batching switch for
 compress batching during swapout.
Message-Id: <20241106121754.644440c6d8d1edf60f6163d7@linux-foundation.org>
In-Reply-To: <20241106192105.6731-13-kanchana.p.sridhar@intel.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
	<20241106192105.6731-13-kanchana.p.sridhar@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  6 Nov 2024 11:21:04 -0800 Kanchana P Sridhar <kanchana.p.sridhar@intel.com> wrote:

>  extern int sysctl_legacy_va_layout;
> +extern unsigned int compress_batching;

nit: I suggest calling this "sysctl_compress_batching".  See how we
treated sysctl_legacy_va_layout.

> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -47,6 +47,9 @@
>  int page_cluster;
>  const int page_cluster_max = 31;
>  
> +/* Enable/disable compress batching during swapout. */
> +unsigned int compress_batching;
> +
>  struct cpu_fbatches {
>  	/*
>  	 * The following folio batches are grouped together because they are protected
> @@ -1074,4 +1077,7 @@ void __init swap_setup(void)
>  	 * Right now other parts of the system means that we
>  	 * _really_ don't want to cluster much more
>  	 */
> +
> +	/* Disable compress batching during swapout by default. */
> +	compress_batching = 0;

Not really needed?  The compiler already did that.

>  }

