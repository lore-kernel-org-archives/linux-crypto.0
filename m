Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8232064D
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 03:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742095903; cv=none; b=bGqe8hufIKh+D1WRYEIL4x86hSlmhFH4oXmoxxb2ZAcIlJDAPEBOOrvfyK0K4chWcp16ScXB9fhonpOWxjXtVXFIYNsKBLGJqycxrEwbM9plc1V8Wz5NzQpinODUeWs9/P5wambN3VKJYhCndEH1WdPMgB+IZBTtjKbJ2YMnb50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742095903; c=relaxed/simple;
	bh=fn0u+HLlCBGyPtTY+NVPDi+aIxQ4EUqRtAR7k+Q288k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sZzfz0rk1fFEglSmGBds8oFbvM/uJDCJGPU6TUxzo2PEnYhKmz3CVLMmZX2wT8AZD0rIxFxpfvx5uhghMc2kBFyamlviQ+oPozczNkzKo65lpWJOCEkGcyfxFJT2wPmBpins3hJnB8Rh77IdwdvB7ZBmSFDJ9h77WaRrSotjqY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctnB2xFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctnB2xFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A61C4CEEC;
	Sun, 16 Mar 2025 03:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742095903;
	bh=fn0u+HLlCBGyPtTY+NVPDi+aIxQ4EUqRtAR7k+Q288k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ctnB2xFXK2+xm1SpK8gHYYB4UlDCiigzOZc+S+Crq/Vxynr/FKP34JegiPdndj7+U
	 sSDEfoZBnrLxa44QbUxf18728PQlSPXsOKUCMJ9rkxrmCf0KHCdTWkvpP2rjEJ2wQk
	 qs7MX1UiixyvVzysXmA0zvjHJDLjFeonHDhF4cWUAql2TegTMyJWOrQKSt34VGMrqV
	 fsfRB5/pIQWiGOvqSN9UWjQ2TTerR5UitDOJJo9IinIYJFIE0PVU+vlXpxaMp4HhQW
	 ex4u1zQ7GUhtFxcWhTboA6rc4CjA7FxsS+l+fxEqI7yaS7+lXsR6lyqvcWIlKphH83
	 RjGiLKSMFWDVA==
Date: Sat, 15 Mar 2025 20:31:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 1/2] crypto: scatterwalk - Use nth_page instead of
 doing it by hand
Message-ID: <20250316033141.GA117195@sol.localdomain>
References: <cover.1741922689.git.herbert@gondor.apana.org.au>
 <96553040a4b37d8b54b9959e859fc057889dfdac.1741922689.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96553040a4b37d8b54b9959e859fc057889dfdac.1741922689.git.herbert@gondor.apana.org.au>

On Fri, Mar 14, 2025 at 11:27:20AM +0800, Herbert Xu wrote:
> Curiously, the Crypto API scatterwalk incremented pages by hand
> rather than using nth_page.  Possibly because scatterwalk predates
> nth_page (the following commit is from the history tree):
> 
> 	commit 3957f2b34960d85b63e814262a8be7d5ad91444d
> 	Author: James Morris <jmorris@intercode.com.au>
> 	Date:   Sun Feb 2 07:35:32 2003 -0800
> 
> 	    [CRYPTO]: in/out scatterlist support for ciphers.
> 
> Fix this by using nth_page.

As I said on v2, this needs an explanation of what it's actually fixing.

> @@ -189,14 +195,18 @@ static inline void scatterwalk_done_dst(struct scatter_walk *walk,
>  	 * reliably optimized out or not.
>  	 */
>  	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE) {
> -		struct page *base_page, *start_page, *end_page, *page;
> +		struct page *base_page;
> +		unsigned int offset;
> +		int start, end, i;
>  
>  		base_page = sg_page(walk->sg);
> -		start_page = base_page + (walk->offset >> PAGE_SHIFT);
> -		end_page = base_page + ((walk->offset + nbytes +
> -					 PAGE_SIZE - 1) >> PAGE_SHIFT);
> -		for (page = start_page; page < end_page; page++)
> -			flush_dcache_page(page);
> +		offset = walk->offset;
> +		start = offset >> PAGE_SHIFT;
> +		end = start + (nbytes >> PAGE_SHIFT);
> +		end += (offset_in_page(offset) + offset_in_page(nbytes) +
> +			PAGE_SIZE - 1) >> PAGE_SHIFT;

The change to how the end page index is calculated is unrelated to the nth_page
fix, and it makes the code slower and harder to understand.  My original code
just rounded the new offset up to a page boundary to get the end page index.

- Eric
