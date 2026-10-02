Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2340036EA88;
	Fri,  2 Oct 2026 10:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790935799; cv=none; b=DdxCCcbJZxLkwkCXdP7HC6pT0tJe9bLroPWwzKSz7t6OQZSvKF/9m3nM1Jzh/Hh9LiKPG1NM81dEc0av/jPf2mG7R5xinZjwmV5JrrRwhyGVwEKbboOPhTcpMB6HFz8WOQMKfEd0bzvJmTA6fVALXadOj8NxD2jlIkoaxwNFa/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790935799; c=relaxed/simple;
	bh=YSXF9AuZY+RC8HOcvfiMdURm1IGVH5EQGINdSsEEg5U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=oG18XXtvKkk6Mj0/nu2MSteaafl1D1gsl++oyAH5Hp4rCOO5hqonVkDbhqzHJ98N/IUpRXeDoF3uFdUY2c9emex94f1bpuytBMKwQCpTwT0l2LnnJWGH12OEb2bkfnPTEn/iEIdQRAuorOnqfkOfRgdv+ySD21i3Qui0/GwyH+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cLFKLf7z; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cLFKLf7z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=edSjetkKC0ODMKuUiIyEO84jYuqLvA3RUyniVREtQMc=; b=cLFKLf7zr/l6CeIGYK91L5k/mB
	LJj/kYLNgMJieESS3eSxisdEEKNRpEikyl9waF1TqHndqbUoa2/SBTq6zXjkukTQC965GF1sDIfNI
	ny6auS7N1yD/ZUEodclJ7CWEswsyzAgmE05h3NeOpXu5N8kUPKlVmhWatRMGESykF5yajTjGjkxWa
	tDQGkMago1BO/61uuLg5c3za8NlqrWQ92i0Ls81yuOc/J1qMxCNqfBKDYJX0aEboEdi9nPkLSZrgq
	CXubAnVyp57lsnMp/GW7al8DbAF9yF63FtRWzvQbWYObSSzCG8jxoVSKYmYijVgygeqXHaYM0vdOi
	EbUg1W8w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCaD7-000000001ga-2r4H;
	Fri, 02 Oct 2026 18:09:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 20:09:49 +1000
Date: Fri, 2 Oct 2026 20:09:49 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bill Wendling <morbo@google.com>
Cc: qianweili@huawei.com, wangzhou1@hisilicon.com, kees@kernel.org,
	gustavoars@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	morbo@google.com, codemender-patching+linux@google.com
Subject: Re: [PATCH] crypto: hisilicon/qm - add __counted_by_ptr to
 dfx_diff_registers
Message-ID: <ar-C7Z3Q0wRKTrLq@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923061027.2650324-1-morbo@google.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Bill Wendling <morbo@google.com> wrote:
> Annotate the pointer field 'regs' in 'struct dfx_diff_registers' with
> the '__counted_by_ptr' attribute, referencing the 'reg_len' member
> which holds the element count of the allocated memory.
> 
> In 'drivers/crypto/hisilicon/debugfs.c', the 'dfx_regs_init' function
> allocates the 'diff_regs' array and initializes each element's 'regs'
> pointer after setting its 'reg_len'.
> 
> Since 'reg_len' is set before 'regs' is assigned, the compiler's bounds
> sanitizer can correctly associate the pointer with its allocated size.
> 
> Cc: codemender-patching+linux@google.com
> Assisted-by: LLM
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
> include/linux/hisi_acc_qm.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
