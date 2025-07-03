Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F254230D14;
	Thu,  3 Jul 2025 21:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751579825; cv=none; b=iL7cl76U0CVslNUqrRAqG2463V9R0gscKYnEDNo173UPjl1BYYz5RsbXx4MCVWL2oWyGoWzw5KyfWhHivcwWuXqroJ/SwCY3wku6PMbsFOg/knDTUGTEeJpNvyyT+XDFFmvobJiPK7AlrtxqeUkMqwNpouKpTbCi5T40LUwOhho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751579825; c=relaxed/simple;
	bh=F1kd85XvbU8QnYJXR1ZMhaX6ypNcPAllX5PBqQkj0gI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZUmHjEs134l3+qUwnGEld6/7FzkPM0MCG/AjQkpxCckwLPQsuFvdzLMIXn+TZtXYlnyYjE/Pm1djbBuG6kfUAwraDiQHCc+opcjwpjZ8/nduZPQQVanhIfBuoAdfrGCNZ2cpRT8usbwoqK/6UrIo4mvDtRwPhZfADRW6kTkJ82E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U28/K6/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U28/K6/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE31C4CEE3;
	Thu,  3 Jul 2025 21:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751579825;
	bh=F1kd85XvbU8QnYJXR1ZMhaX6ypNcPAllX5PBqQkj0gI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U28/K6/JfF56Rc+NVoYoPLT8SKPqnqwsagT17avDyskR/ynownshy4LFLdhKRnlRP
	 iilMUUHz4bw5FS6V8uj+mpC0qnBJnyklKkOEsNZHvynwU13LsgDNTsJxuCaYc0dYuB
	 WNqI6EJaxGEqQnE4K/u04PjgXmu/dTUXnGMf1xu3DIK0ZUvQ2DI5Oc4CfdVX7hBh9b
	 bRAe2BYkyWYperkwd3i0Stt7nfNIOn1gnUIIPFPrbMC39Ng3ssjfiJHLJMjpVpPnq6
	 3LyfesIzKM0WFbPJESM24wymGY5rcRWSqPMG7crxlN+h0jNHBSz3ToSK6r4OQaYFVS
	 0huPc8uzI1BCw==
Date: Thu, 3 Jul 2025 14:57:04 -0700
From: Kees Cook <kees@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
	linux-hardening@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: zstd - replace zero-length array with flexible
 array member
Message-ID: <202507031448.C3DAD52@keescook>
References: <20250703171933.253654-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703171933.253654-2-thorsten.blum@linux.dev>

On Thu, Jul 03, 2025 at 07:19:34PM +0200, Thorsten Blum wrote:
> Replace the deprecated zero-length array with a modern flexible array
> member in the struct zstd_ctx.

Oh, weird. This is a very recent change. This should include:

Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")

> 
> No functional changes intended.
> 
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/zstd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/zstd.c b/crypto/zstd.c
> index 657e0cf7b952..c489976c3e8b 100644
> --- a/crypto/zstd.c
> +++ b/crypto/zstd.c
> @@ -25,7 +25,7 @@ struct zstd_ctx {
>  	zstd_dctx *dctx;
>  	size_t wksp_size;
>  	zstd_parameters params;
> -	u8 wksp[0] __aligned(8);
> +	u8 wksp[] __aligned(8);

And likely, to use __counted_by(wksp_size)

I'm surprised checkpatch.pl didn't warn, but I guess the __aligned
confused the script?

Reviewed-by: Kees Cook <kees@kernel.org>

-Kees

>  };
>  
>  static DEFINE_MUTEX(zstd_stream_lock);
> -- 
> 2.50.0
> 
> 

-- 
Kees Cook
