Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795BE78F3A
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 01:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178198; cv=none; b=ZbxnCGOEoRVlxZAqFXGoodOTVZXvZE/Egx1mFZGQjPFq0Pwt80RakiPQyR/HO9V3N8jaXpPzo0r997qHNAjhoo58eZX7hnlJBm5GzSJf/q7ZK0RAlU29AvSe8RXwfqkCj0RBWOO87a6CZ3n8V/esl4mlOQrQhrZNqBEWr1vNwcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178198; c=relaxed/simple;
	bh=/lMlPCpLGMO7b9kQmAijgcydxInwa5GA1SxvKRgouww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JItB5SXKGg4TpRX3DuxFGWb5m4eK0T1Ew4txEgHhDyIBJ3LtjT6GAXd8QaZVqfwLOTkyotmJXQVOjJbkkLbz77BwFOffhjMwC0bp5zzMiIyaWYP0MK529+BLPbYruRQUXMb+dCcaJ67YeAqCWR3Mc760CF1rPAB8zgURLJvuDKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=QUjXaz6Q; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="QUjXaz6Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=alDfLKhE6HZXHRAf5YBR+J0hFP3fEMuTuPvk4Z8uZBc=; 
	b=QUjXaz6QsPT7ZpM3x7Jq3UjLPrHJ12TU8U+fDTZTUCoCK9MzrAVDSPQuDW+SOIXwIXJ3SqwBdAq
	y04O36RkFwcjlduohULcHnF0ck4hVTXHkrgXcT85BOGP1yrOttdd6/8y7uMUFzkuDsVoP4DiAS7jN
	KywNl/Vx/qyVVqDA8H2+1L3Y4M9ktKG3lECoVRHAHVdnV+hWVfdRPCFdeBw3OFmE2O26pxMRgg3DC
	9QQsNaa0Jm0fU8kNqC1SSqECufE0EGJ0iJHDJUyxUmr5d06Ku5mr6xXUDhALBOTMMvv6Qs6K7QXhC
	gQDleG5bH0aCOWIYX7qLqoi5pHpTguicWYyA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8SWq-003Qwp-30;
	Fri, 03 Apr 2026 09:03:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 09:03:11 +0800
Date: Fri, 3 Apr 2026 09:03:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - disable 4xxx AE cluster when lead engine
 is fused off
Message-ID: <ac8Rz666yGXpU9N2@gondor.apana.org.au>
References: <20260324111112.227158-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324111112.227158-1-ahsan.atta@intel.com>

On Tue, Mar 24, 2026 at 11:11:12AM +0000, Ahsan Atta wrote:
> The get_ae_mask() function only disables individual engines based on
> the fuse register, but engines are organized in clusters of 4. If the
> lead engine of a cluster is fused off, the entire cluster must be
> disabled.
> 
> Replace the single bitmask inversion with explicit test_bit() checks
> on the lead engine of each group, disabling the full ADF_AE_GROUP
> when the lead bit is set.
> 
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Fixes: 8c8268166e834 ("crypto: qat - add qat_4xxx driver")
> ---
>  .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
