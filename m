Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A551322339;
	Wed, 24 Dec 2025 02:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766544567; cv=none; b=GIOpUoewLrwXxImgZp/Mv9Tne2kXum61TLbbTrFNoYqHVxe5jn2/8LGJwMXmnBIUV7FUtMSJyI/rS0YQ5MvH+VmU0WRV+SOR5OOsvOUXim0NnPIi4nXuvF43lhZOKMg8E4OYkoNMDOtIDmLARs8vqDqLIskb5Pf0TxiFM4Ja6yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766544567; c=relaxed/simple;
	bh=02q1+uBKdMjkGIRcN1383cGcyNZtD/iwOufYI8HlETg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/FReDrPBNkRON0Xjvu304wAE/DshjeGpUGKbeg16K0oTv12fEkFFBlbCk00E4odC5QtY2ynPWx1MFoYUwpNhEdvZYwGIBck72ypTq8NeBaat6BA/qCJ++zasulLqIlnnnUKxW53ChbqywS4bwmfR/6w2x4p/j43Xq2ZVDZW6n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ES2rgB2N; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ES2rgB2N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ugHXHGmGeRkP5W9N7E63cktMzCvfIuaJdFwBSlipcac=; 
	b=ES2rgB2NlZjNgJxfamb6zPdkS8cKa1QNOL7XjnfyI/+AsQr53n1uFb7173m4lgWS9L8RwYtGSrq
	rWt5ooqyB20xFe2JHSFBmInqOXitcTSTWvVVTYkCI117j0TIzTn+2BWrhdKPteMemADiuHK3L4zfb
	WHiN50PBmOeZkY5JXVmw7uv/87I0IINVMrtrd52BKOo7W+qWO6SbWakuizuZ7xct78j1X05+Yy/20
	GPqvde5UfPHtg9dTVvztAbcllRfi8LPuWeEqUYSmHb2gwV+aIIs0pTFFsq897J/IEJ2R0R4PG3MbY
	WNyPwnFti5qhz7/TV+3vvkuqKZ4HU7QUi81A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vYEw4-00CFT2-1W;
	Wed, 24 Dec 2025 10:49:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 24 Dec 2025 10:49:12 +0800
Date: Wed, 24 Dec 2025 10:49:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: huangchenghai <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH 1/2] crypto: hisilicon/trng - use DEFINE_MUTEX() and
 LIST_HEAD()
Message-ID: <aUtUqF7eHUY6Pw76@gondor.apana.org.au>
References: <20251120135812.1814923-1-huangchenghai2@huawei.com>
 <20251120135812.1814923-2-huangchenghai2@huawei.com>
 <aUTAznUr2OrikTH9@gondor.apana.org.au>
 <f1ace3a7-a4ba-4a57-b08f-7d07a5984b20@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1ace3a7-a4ba-4a57-b08f-7d07a5984b20@huawei.com>

On Mon, Dec 22, 2025 at 02:10:32PM +0800, huangchenghai wrote:
>
> I tried to solve this scenario by adding CRYPTO_ALG_DUP_FIRST:

You're right that it's broken.  Either the duplication needs to be
moved to the driver, or the unregistration needs to find the
duplicated algorithm.

Let me fix this up first.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
