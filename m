Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83878176ADE
	for <linux-crypto@vger.kernel.org>; Thu, 22 May 2025 09:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747904835; cv=none; b=MAaUPBCF9o2heKNGfRwM2uSqASRuqIfHrYHHzKxm+40j1kW2FpVEZQQEehAu/CAb3m5DABjiFETq7fqiytUvWXLUa9TbMBaCjoA4ECFJn7bVKhcLad6ZeQMRX3bcr1xh6k8xXOS8z+L2Ow9IG8kHTzZCqE6WdCmIf0znV6/2pLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747904835; c=relaxed/simple;
	bh=H5K6nVQlirXQRLb5kPsChrI74akCedDveoJC0EbYxuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/dCeNjqc4iEBObtkpHxuf7bvAPPubThR5VAdfcV0scFAoaQA2VEwoy02dIPxRjWUdQcGbDMkHvSLnHwTN08nNDXquSmlRVKDL7kBGL+uruYI8F4kWd1HtinlxHeKEeQ4B5z/OrvYlFy0yPocoWPuN5aNhi643JtltjTIHbth1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HPjHJ3xA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HPjHJ3xA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mvW36t4UhqGbvCLl4RUS+3L1Xv4vR+Bzqn+8Kh93vC0=; b=HPjHJ3xAC6yozGNEOe+reIsomn
	pDYaRt2zcWRjJphCkVMcn5gTMvaM4xa8yNTarGZbLwh0hzDuSOMbYsN8a8Hv1Sswi8H7DPYN9LDK/
	kvLYoUGY0wpyYJU5cSWSbHI818EB8HsSu9g00eCKRCqoyYNkhdbViaTCgUF1eyEIdcXJzjPZI3rFa
	RSFqstIlTqdDsKBjzzxu02XH6hbbWm9Yz5s3+ZatGowLyvkRzx9J1V75PsjEKRKICEs2wiWQpyVV7
	ZUK0W64VqCd/QUXjuV2Y7CYjiiDaXsa/DbG1HrjNZSlD3DwdtzlqEs+R2DonvggoEdupOk6bhDRU5
	P2sRSkUw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uI1tK-0082qb-34;
	Thu, 22 May 2025 17:07:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 May 2025 17:07:06 +0800
Date: Thu, 22 May 2025 17:07:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	linux-crypto@vger.kernel.org, qat-linux@intel.com, dsterba@suse.com,
	terrelln@fb.com, clabbe.montjoie@gmail.com
Subject: Re: [v2] crypto: zstd - convert to acomp
Message-ID: <aC7pOu_dKhRPN4LD@gondor.apana.org.au>
References: <20250521064111.3339510-1-suman.kumar.chakraborty@intel.com>
 <aC2I0_F2BJbexte4@gondor.apana.org.au>
 <aC7owoGDFl5YVVxP@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC7owoGDFl5YVVxP@gcabiddu-mobl.ger.corp.intel.com>

On Thu, May 22, 2025 at 10:05:06AM +0100, Cabiddu, Giovanni wrote:
>
> Without this optimization the performance drop is significant, compared
> to the original implementation based on scomp. About -40% using
> compressible data and 4KB flat buffers.

Fair enough.  In that case we should add this optimisation through
the walker itself because the walker is meant to deal with whether
the input is linear or not.

I'll look into it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
