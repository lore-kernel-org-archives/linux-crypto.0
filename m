Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49831EEE9;
	Tue, 11 Mar 2025 03:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741662846; cv=none; b=i0k2bFwNUeadVV/bpaelygs82R2EszEzIKXVAUUiJFtHL01tcy1yUj/Qo+lJE4iVZs7yM+ptMa4PV34ICHO7VmTShiVSxoLzTPVeN4/nj1Ki423eNsUoRhFt+P47ZtTu0Apq82wCzIR3xPtB3rrRvGUxPRicYESCpEPKzbtL5Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741662846; c=relaxed/simple;
	bh=A3dl8TbM+7V0uUAWMPYSgH6TFClyBGIWRy0nk1p3EoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T3LOx4w1Q6B6J5pkWR2D7XlfnaHyNB9ZdWhXWxuexh7Su0nRfO/ejwoeh6YWoP101W05Vq6T9DhjYZbeV4UjRC2sOfbHapEtuqFE7OQpBtd5zRGRj07rCLTZ1W5ILp5Wlj4MZUbBEE43QypXo6XCK3WFNNEnDTovN2JdRtoyOTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ibj9x/bm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ibj9x/bm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xAheGL4dA8pSA51QLwCh3t3r0eg7T6m+5koMy1K8VvU=; b=ibj9x/bmsCWfqE+vywO+3azRGC
	ugVJQXeGs1pZHdSpmNg87U/CpZsfhNuvJF4d3w7/a/qmGN5NfbJWbDCsoSyehKghxz3sWL55bKpdH
	rNgIZklwsu2TVuX0FrmiDJyFOfS6WHxs+qODEf5qvVCdbhgQlLfR58cz42AXfegt+0Dqw+s63zUgz
	aWnEIajdp02kXOL6vK8XUKO13oKK1U3RMdELNeR6nIsCqFbOslGSNC2NzstRJZ/lf1LxJMADMqKg1
	LmvKodr4qX9cJmKrP80kWZ0WoTK8A7CJ94jeoMLEpUFkTKxfy0Sdl4i/C/PqWdXD1cG9HUIHLC/eM
	uYot24lw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1trq40-005TVP-0s;
	Tue, 11 Mar 2025 11:13:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Mar 2025 11:13:52 +0800
Date: Tue, 11 Mar 2025 11:13:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 7/8] crypto: scomp - Remove support for most
 non-trivial destination SG lists
Message-ID: <Z8-qcLGAIaZXo5fc@gondor.apana.org.au>
References: <205f05023b5ff0d8cf7deb6e0a5fbb4643f02e00.1741488107.git.herbert@gondor.apana.org.au>
 <914f6ea6-bb6c-4feb-a4ac-23508a8ff335@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <914f6ea6-bb6c-4feb-a4ac-23508a8ff335@stanley.mountain>

On Mon, Mar 10, 2025 at 10:31:06PM +0300, Dan Carpenter wrote:
>
> New smatch warnings:
> crypto/scompress.c:180 scomp_acomp_comp_decomp() error: we previously assumed 'req->dst' could be null (see line 174)

I think this is a false positive.

> 5b855462cc7e3f3 Herbert Xu                2025-03-09 @174  	if (req->dst && !dlen)
>                                                                     ^^^^^^^^
> Is this check necessary?

This is not trying to catch a null req->dst, but it's trying to
detect an combination of a non-null req->dst with a zero dlen.

A zero dlen is used to allocate req->dst on demand, which would
conflict with a non-null req->dst.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
