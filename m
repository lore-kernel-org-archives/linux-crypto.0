Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2F2287265;
	Fri, 23 Jan 2026 06:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769148077; cv=none; b=UvUWj8g/KMcGOcQbNjr4ceXSujyPnyb0iLhDz/8QgY6Rs9+SAnqIER1XV0EuzYg1O6S947OnKgYRKVgw9u/TR+1Fsb0W82KXO4JK0R3IuhuEMAcVZ4GzLyAVnpNmZQfqJq8vXS/dv9AVTtM5Cv4xfGT7+igI7FIh4PZhlVteUEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769148077; c=relaxed/simple;
	bh=1ZmTguyGuU2K1yWkswMX6ok7pcPQ9eXsOFv86KrFs5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t1XEcc4qZtWeTGQSmt2YEv2rC9TzrVEfkeING3q7JKoY0Ap8OwFwbn79PVRqpNtW/pY+o85jQ6NFhaM9Z1Fi0bsKvP3NLeZojTLknQ0vnuxDiGIY+8NueG5WfAvEdXE1Wobdy1hjqcvxkUvzjlmhDecDpz35gjWJ4tSKd2VcdtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rXlJ4ezk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rXlJ4ezk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Ar2CgNwWujKJFPzeFmqgo8fMu/DGQr4he+lWJ1P78Uo=; 
	b=rXlJ4ezkTuOwTKrvBSJiq2n25He0CoyXM56BUHeMdetJ0xyzeqYC/ONzFj6ylGbdz9Mdp3cv1Oq
	HOQ+rmevzAjtdAKsf/m9H0oCnSjQ7erJ/L5nCi8UkoAOa7CcQLDiSFA6zv5kXL1DjiWh1YKdOBGAM
	BbY03SHiz9ad1txjBkc/qqmA/MkN5edNNTTdhf+poJqaZh/h3gfCAZknXKmfZCqOL8Gf+TIoo3JFP
	g1zXBNaT9ZWc/ybWshn2f/XqCTVGw6kbQ03ZfbQ9bI9UIOIQlKcLwlSEyTJlBnXHEqTOMeo6NO8B9
	LKF0u1E9eebOv/UP4n14dQQ11jqO2tYog/ig==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vjAEC-001VRE-2M;
	Fri, 23 Jan 2026 14:01:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jan 2026 14:01:04 +0800
Date: Fri, 23 Jan 2026 14:01:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>
Subject: Re: [PATCH 1/2] crypto: ccp - Fix a case where SNP_SHUTDOWN is missed
Message-ID: <aXMOoGQElcAVUX-b@gondor.apana.org.au>
References: <20260105172218.39993-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105172218.39993-1-tycho@kernel.org>

On Mon, Jan 05, 2026 at 10:22:17AM -0700, Tycho Andersen wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> If page reclaim fails in sev_ioctl_do_snp_platform_status() and SNP was
> moved from UNINIT to INIT for the function, SNP is not moved back to
> UNINIT state. Additionally, SNP is not required to be initialized in order
> to execute the SNP_PLATFORM_STATUS command, so don't attempt to move to
> INIT state and let SNP_PLATFORM_STATUS report the status as is.
> 
> Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Reviewed-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  drivers/crypto/ccp/sev-dev.c | 46 ++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
