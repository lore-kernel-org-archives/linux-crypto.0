Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E58C2101AF;
	Mon, 19 May 2025 06:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634652; cv=none; b=XRvE5yVWW5VE+SLSvmxo5LTKGXjwGdifCvcd821xBA5iFqZjNkYrnGirOjYuug89/vhdHamqaeFZ4U60kzGe6i1t5fu89zJlLsBKYmGOu9InJaBgpHA1wq/1fASWs6VE0rSAppHSKXSmPRFMd5WiGgVA6EkwpKOT8ZWL2+MkLNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634652; c=relaxed/simple;
	bh=c67OhAOc8J3VhZF6DPen0vV8GkBlRBeOAOaJhHacWN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kcBtACVGXH4H8t0+Z5RFnq7GmTPz/vO8mLfTKMMfLRGoBVshKeo4IMOpBgD8zPa4qD1hdd2jW4cF8HtMXLUgP0M9TUedv5hpJQAn4b+Wx6WeMLN7DY5MVz3NLgCXYsZqGzUodNzhMNHjGdrvbm+iIq4UK+aCFN2wI0Ubjhw5quM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Rg2HV7rg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Rg2HV7rg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=a4es1adbgsTfV2DUx8enR57coZhhiEISCawk8Z9Z3as=; b=Rg2HV7rg1XhwiPpuOCZDSn9zLM
	t1p/M4UYiOMYe2DN5tWWoQtIMudVpfzYeuTSg6OEq8Lgk6M3HROi5eaOoUpuc9PG37e55MqRY09F+
	7X/T35uKmz8GNmvmZk5sb6qdOW2qZyP+avZHPGURGZF5iZTydy4nT7T4cYRA/STaaVkV+2ddlkjN1
	ScoyaLy7LY1Hw69av3dldQUljnZGY1K+rarxopGlaqxFjVGSmcKQqT5oaWdwAgM8YrSFVxe0gPwYD
	Pw9wJvwvsGaG8GSdfO3v9vw1jXqdfLBotiiL8dle9VCIAWKUEvbYaB64hbESmGDDN/UhwgjcwHa6p
	1VEbOlyA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtbL-0078CS-1t;
	Mon, 19 May 2025 14:03:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 14:03:51 +0800
Date: Mon, 19 May 2025 14:03:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Chen Ridong <chenridong@huawei.com>,
	"open list:PADATA PARALLEL EXECUTION MECHANISM" <linux-crypto@vger.kernel.org>,
	"open list:PADATA PARALLEL EXECUTION MECHANISM" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] padata: do not leak refcount in reorder_work
Message-ID: <aCrJxx4ftNuWYOby@gondor.apana.org.au>
References: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>

On Sun, May 18, 2025 at 07:45:31PM +0200, Dominik Grzegorzek wrote:
> A recent patch that addressed a UAF introduced a reference count leak:
> the parallel_data refcount is incremented unconditionally, regardless
> of the return value of queue_work(). If the work item is already queued,
> the incremented refcount is never decremented.
> 
> Fix this by checking the return value of queue_work() and decrementing
> the refcount when necessary.
> 
> Resolves:
> 
> Unreferenced object 0xffff9d9f421e3d80 (size 192):
>   comm "cryptomgr_probe", pid 157, jiffies 4294694003
>   hex dump (first 32 bytes):
>     80 8b cf 41 9f 9d ff ff b8 97 e0 89 ff ff ff ff  ...A............
>     d0 97 e0 89 ff ff ff ff 19 00 00 00 1f 88 23 00  ..............#.
>   backtrace (crc 838fb36):
>     __kmalloc_cache_noprof+0x284/0x320
>     padata_alloc_pd+0x20/0x1e0
>     padata_alloc_shell+0x3b/0xa0
>     0xffffffffc040a54d
>     cryptomgr_probe+0x43/0xc0
>     kthread+0xf6/0x1f0
>     ret_from_fork+0x2f/0x50
>     ret_from_fork_asm+0x1a/0x30
> 
> Fixes: dd7d37ccf6b1 ("padata: avoid UAF for reorder_work")
> Signed-off-by: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>
> ---
>  kernel/padata.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
