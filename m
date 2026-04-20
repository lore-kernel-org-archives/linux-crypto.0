Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD04A37F74B
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 08:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776675062; cv=none; b=kbjS2n89yExrIvj8xDSV7D5jv/GNieQ712+MQxF95dTvon/pak6IIcuVxZ0n4hIuUMDWuuRv3oshGUcWLy/8SfQne6ogmFX2iX6Qh7yvbxQzw5SKCkQV68YnWZyH1ziJ0kYkfBXXFfp5YhUWYYGDmVu5DZCBFrNXFZz171HXxy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776675062; c=relaxed/simple;
	bh=42IUaf8hIpn4U9JA4twndcnXOrbUJG9hb6LbMVcP1k4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTckB0y96vViCuQChLcHX6RISoDZXcrqlha7Dpe/5yQjh4pvHGJcKB1vZMigTgcHlcwFnpsRPxC7oeKoocW4km+2EZQ1D43XuqqsZSiXWurKu6SWTnODCc+JfG3PqSAcpwJz+Hh3KS2GJkOfLdKWLK9AM1lnoytT86Ry6Ohbh20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=X75GV+qK; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="X75GV+qK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=QWDhr6GxDcToH5i4UdOOd6z9bj7FvzEhoFozqUcdURE=; 
	b=X75GV+qKCvQHRHMx11sCk6L+146C47TowmUpQVzgKgTcnNL39q/1xR1uo8vyM0xPcTb4sZEF8lL
	+08MvnMcg1htCamHulwiVmQZgPg7s2W9PfytwShLUhllKKiOXDrlMu/REPLmfZufJhBhg/yYkDDJq
	nZQACOOkwjax6YEc81dW9OUYYes3jtjGXX6qyXfim5ZitZidnBv4mq3mcm4hUa3nzpZr2QObyMI+t
	Aoo5dPkEHCbiyb1IKdqIS5wMYhntOgePX0KK3AKC1FPpHITzE8Gs3DcYK8mhn+A/mG5q97MyC/ExM
	d6pj114wFE34r4fqHPrqIeN4X5SKvVuEI/eg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wEkLH-007M5F-2P;
	Mon, 20 Apr 2026 16:50:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Apr 2026 16:50:55 +0800
Date: Mon, 20 Apr 2026 16:50:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>
Subject: Re: [PATCH v2] crypto: deflate - fix decompression window size
Message-ID: <aeXo79eNiYnJ2ImV@gondor.apana.org.au>
References: <20260326100433.57324-1-giovanni.cabiddu@intel.com>
 <ac8I4mpkdn8uy8TE@gondor.apana.org.au>
 <aeEWf4j+VO0FziNj@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aeEWf4j+VO0FziNj@gcabiddu-mobl.ger.corp.intel.com>

On Thu, Apr 16, 2026 at 06:03:59PM +0100, Giovanni Cabiddu wrote:
>
> I'm reworking the acomp/BTRFS set, and that will be included there.

I'd prefer a standalone parameters patch-set, with the first user
being zram.

> I don't think this should be treated as a parameter. A decompressor must
> be able to handle any valid DEFLATE stream. RFC1951 (section 3.3) [1]
> states that while a compressor may restrict parameters such as window
> size, a compliant decompressor must accept the full range defined by the
> specification.

I thought this is the whole point of parameters.  Different parameters
would generate compression output that may not be decompressed unless
you used the same set of parameters.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
