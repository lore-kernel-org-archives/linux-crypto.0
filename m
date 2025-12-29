Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94071C3C1F
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 00:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766969485; cv=none; b=oWyBXLZ/4wMI8WZVJFS2s6csnNEEn3rcct+9uAYRkadoDngk0UJOhGlrjgTQ8EcOhQfe+p9eWoQpbxanmlPAycswWh2f/5RmGwjzw4ZhKOeDH4ID6QD6/+W3fXBqp1zz4NM/mBuhnrQzz/SseL+1X8IBIRj9Euh5B+h/fBN7gNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766969485; c=relaxed/simple;
	bh=p4O8ISQM31ErcjrKzTUEbgzDBh8W0IYYwiVuwojfDlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HkuYEO8EYo1LqVe45ibIsLKmkdEALb2hh2SjVNH2PyUGET/6LYyfUmT2s8hH/k9YFpAUVMjBllPJpI1/6tN7UPtN9K1PpQ760rl5VgrPRrnMqU5dZAGFPubwmZw6uqzOPuhAns9+4GINo7LovlVMtogkv3ovtT5J21bFjGrSwD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=jRNNAlie; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="jRNNAlie"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=VW7unnbNNxEA1OSbvuw5N82Fi2nwKDNKUSAlwWP66lg=; 
	b=jRNNAlie2DoR/x96w8Hv4B8+e7Ox/u08kGGBrCn1128xj/YeMjjbug9yIL+1Sa0FjAugSUTYf/I
	HXi54sW+dShS3Bual4KhSBuyNXmPjGCFmwt8FQUCOG8M7t3FkA8+I3s4e6r/N/FEezUq7yqnchYGt
	QaOviwVmKYUte3BAngxCzO7TwLseuXI1B1SzDM28IzYTrofaRzTBe+07V34p8vla23tLsNUjVRNrW
	IrKTv35/ZKL4DgVSHRoQVP563HLjq5ee2CdM2a9ZOyolfPhogH/aQErAGZMEFFlFgSTuQ91x41F20
	bgwwB6F/ETbv3vLvbSZ0BWIcIZ7psJvPByuQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1va1Th-00D0Fq-13;
	Mon, 29 Dec 2025 08:51:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 29 Dec 2025 08:51:17 +0800
Date: Mon, 29 Dec 2025 08:51:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harshita Bhilwaria <harshita.bhilwaria@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH] crypto: qat - fix duplicate restarting msg during AER
 error
Message-ID: <aVHQhcnyMp_nBstl@gondor.apana.org.au>
References: <20251217054606.430300-1-harshita.bhilwaria@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217054606.430300-1-harshita.bhilwaria@intel.com>

On Wed, Dec 17, 2025 at 11:16:06AM +0530, Harshita Bhilwaria wrote:
> The restarting message from PF to VF is sent twice during AER error
> handling: once from adf_error_detected() and again from
> adf_disable_sriov().
> This causes userspace subservices to shutdown unexpectedly when they
> receive a duplicate restarting message after already being restarted.
> 
> Avoid calling adf_pf2vf_notify_restarting() and
> adf_pf2vf_wait_for_restarting_complete() from adf_error_detected() so
> that the restarting msg is sent only once from PF to VF.
> 
> Fixes: 9567d3dc760931 ("crypto: qat - improve aer error reset handling")
> Signed-off-by: Harshita Bhilwaria <harshita.bhilwaria@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Ravikumar PM <ravikumar.pm@intel.com>
> Reviewed-by: Srikanth Thokala <srikanth.thokala@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_aer.c | 2 --
>  1 file changed, 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
