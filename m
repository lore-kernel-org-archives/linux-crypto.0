Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DCB2F657F;
	Mon, 24 Nov 2025 09:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763977910; cv=none; b=dB8lnUo4ZcHizL7nlkYDN/1C9Nzv9rdwLW7STvmNQcL+H4XXmPfHtwCyNg8Nghrjg5VN7oCAviUWA9IFwGDJI9d6QatQmKIo4/LX8GT46Ugr7gvUhZWc9Qv0IfTD9AAfWlQ4Ht9YbCn2L1k3dHy2FYflCVTZhBmryS1dG2a4gkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763977910; c=relaxed/simple;
	bh=OGzTKu3RaZeeTGEWvF4tKdcUIcFU07ZsNy6xTODec/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtYU+BEXCdwf6xDob3MFCDLxiz8tTck+fEI4nkm0skK0zP/oC7ntSDk6nCMSv+Kv8+PxIikFTN5EEcoZG/eN8R7c8pp8CC4Iu4danBGvgPUc023WGLPX2zNwoptI5c5+PuAl1yd80ImVFWbABEQOD8F/4iJjRleYxDcUjXcTHjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=pXwSPfTR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="pXwSPfTR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=c7fgjhnceewX9WTWgDcP3o+c+gym320PIXC+PmkRQmA=; 
	b=pXwSPfTRUQddVnMEepT8vWwygw8SsPTms8qX3o3U/1pzrAPtjcsteAJo4tddMzGVd+C147hOqwY
	Mg36ouK0aYcilU7sOEStIo/yKGBj1mJvfrTGmVZzun5p5HL7WjpMWqfMM2zm2qNsGhYVWs9NMJPx+
	qYWCnqzaoRVR4H9W8LH++5j7ZqLw0hy4qRFDhAl+OYGMC6GAIL4XedXcyBCUuWWJi6ur0GIF66wBT
	fyEdkdSHd+otFOc0npyv6KwngLfkuIk9gE/OPbNnEa+DbGtYTLMOEeguZC9aLpS7U9h3pQJY49ikt
	t9L8zsaMddJGFJynbO1T5ZdnKTnzaD9ZQh+w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vNTEV-005XP3-2v;
	Mon, 24 Nov 2025 17:51:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Nov 2025 17:51:43 +0800
Date: Mon, 24 Nov 2025 17:51:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Subject: Re: [PATCH] crypto: zstd - fix double-free in per-CPU stream cleanup
Message-ID: <aSQqr9wKzfNP_As8@gondor.apana.org.au>
References: <20251120162619.28686-2-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120162619.28686-2-giovanni.cabiddu@intel.com>

On Thu, Nov 20, 2025 at 04:26:09PM +0000, Giovanni Cabiddu wrote:
> The crypto/zstd module has a double-free bug that occurs when multiple
> tfms are allocated and freed.
> 
> The issue happens because zstd_streams (per-CPU contexts) are freed in
> zstd_exit() during every tfm destruction, rather than being managed at
> the module level.  When multiple tfms exist, each tfm exit attempts to
> free the same shared per-CPU streams, resulting in a double-free.
> 
> This leads to a stack trace similar to:
> 
>   BUG: Bad page state in process kworker/u16:1  pfn:106fd93
>   page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x106fd93
>   flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
>   page_type: 0xffffffff()
>   raw: 0017ffffc0000000 dead000000000100 dead000000000122 0000000000000000
>   raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
>   page dumped because: nonzero entire_mapcount
>   Modules linked in: ...
>   CPU: 3 UID: 0 PID: 2506 Comm: kworker/u16:1 Kdump: loaded Tainted: G    B
>   Hardware name: ...
>   Workqueue: btrfs-delalloc btrfs_work_helper
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x5d/0x80
>    bad_page+0x71/0xd0
>    free_unref_page_prepare+0x24e/0x490
>    free_unref_page+0x60/0x170
>    crypto_acomp_free_streams+0x5d/0xc0
>    crypto_acomp_exit_tfm+0x23/0x50
>    crypto_destroy_tfm+0x60/0xc0
>    ...
> 
> Change the lifecycle management of zstd_streams to free the streams only
> once during module cleanup.
> 
> Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> Cc: stable@vger.kernel.org
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> ---
>  crypto/zstd.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
