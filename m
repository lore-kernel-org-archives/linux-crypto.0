Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E122D26FDBF
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 01:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178289; cv=none; b=ZyrzouStpEpXQUaUnl9N9QHskAFyafqXqOyvMOBs/+TVYSXeFk8Ln4MmA0yovYFDMqonbm6lEIfnn/ygiUh7YSjz66IXV8+QRYSafR+0RYNfUGMEOaEeFsbcZV2vURdhcO4EXs2b0C/sSTIL48M/9mI5DSI0dDtGTe8whohTah0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178289; c=relaxed/simple;
	bh=8xzskzEyLKFRRmsCfd64SrL0nF0SmKV6nvPT7IdSE2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZS8sUvHPgc0Wm9kWEXpcWj+TnbQTn435eAiOUm0A4GCGLoRDdPyxRjcHpaaVIdTlKe6EMLxFwY82wSY3n+jblaubFe5NkS5tg49HNahUxA6sJdIn7ys+pG7t+UyxYHn4Qmwik5Oz+wtmALFEvC3vWHYE1b1tJRGNR/eUTsxCQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=JMhcqWr5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="JMhcqWr5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1nvKb4NsscxdRQ3jKQV1zbzCzAQRkeiVe0nEMeo3ddk=; 
	b=JMhcqWr5T12pVZMcKOuS0f92wrMXLAm/m8hRE7cNcX/EIB84ciHbLkoe9brnq3QalEfyCOgniiq
	BHmh4RJEELLPHONgJO3w4gGvjqBxxlsLRZ7AXFik4M8snhuGZe63V4NEzAybDR26y5+hzRZdTMzE8
	8Ei91wuSg0eOLKW8YOIOJKyNNp/nXNREahTDXnJgyDN2yin8mqufhBgtXw1hQWHuaYUIbaH/S4ESA
	J5Uo7r0s6AFvt9AjweTlqvjwE/3UzU3UG9+u0bPR4BmNbs5JUWF3kgrZoXLS8V0SndImi8JsVU8cg
	J0BjNXAOUnIq7u8Nco+Izk5IMMNTjfNfUWhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8SYL-003Qyb-0c;
	Fri, 03 Apr 2026 09:04:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 09:04:44 +0800
Date: Fri, 3 Apr 2026 09:04:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Wojciech Drewek <wojciech.drewek@linux.intel.com>
Subject: Re: [PATCH] crypto: qat - fix compression instance leak
Message-ID: <ac8SLEHYsKl9oD4q@gondor.apana.org.au>
References: <20260324180012.119237-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324180012.119237-1-giovanni.cabiddu@intel.com>

On Tue, Mar 24, 2026 at 05:59:40PM +0000, Giovanni Cabiddu wrote:
> qat_comp_alg_init_tfm() acquires a compression instance via
> qat_compression_get_instance_node() before calling qat_comp_build_ctx()
> to initialize the compression context. If qat_comp_build_ctx() fails, the
> function returns an error without releasing the compression instance,
> causing a resource leak.
> 
> When qat_comp_build_ctx() fails, release the compression instance with
> qat_compression_put_instance() and clear the context to avoid leaving a
> stale reference to the released instance.
> 
> The issue was introduced when build_deflate_ctx() (which always returned
> void) was replaced by qat_comp_build_ctx() (which can return an error)
> without adding error handling for the failure path.
> 
> Fixes: cd0e7160f80f ("crypto: qat - refactor compression template logic")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Wojciech Drewek <wojciech.drewek@linux.intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_comp_algs.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
