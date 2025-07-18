Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD932BD03B;
	Fri, 18 Jul 2025 10:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836190; cv=none; b=tctPjpX0nKDDkn1xC2at6mr8lZid7lbKktdn5tcqxzJoDAhqLEKMjSJOZRzT9cXDc7fYoaMvfTd52mD56Aro5jyY8O9QFJa6xM14TByV8Sa4NuRdRh0v8dwNMZQgCZT0p6jeqTtKgqVvw/oico4GWZ4ryTahnhmPEMagdtc2UyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836190; c=relaxed/simple;
	bh=ysjns1mxHpU9vqHo/uOHB5+qmDPMYepChszLzDIB5sE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NnktPz9lH0hbQlLW0FtjP4qEmXkCYXeJ4i/tUeurksGJVvS402649gf4j/M4rLAf0q8hrm32m/JDrucmSQTRESXz3AwCzJkKgYOzvmPTSpvQKDp6RlnW/A5JTrK/1OqQI2kKv4EFnkv+NbOHAPQYJtX3OBlyoEmAOx2t2tadff0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ltHBaCcs; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ltHBaCcs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vS1QQtIUTEAvC+pBZp0mR0WPc3bzPI0i+MxVydVaLek=; b=ltHBaCcsmciIIlFRZ8g5J3H6X8
	m5aIG0hGxSsAy7A6EUasdb9K2rB3SQweL9C7m4+jkgKhBaLVqXdhZiOIHGPZ8q7LfGYoea/gD180T
	dfBQh9Rtahcav+N7hTRMGMgbN9MglnbwGbQdsNeJ2phUwHnSwRJu9WHB8oP1CnzstcYvivIJOrpQa
	2zh1HL1o75Nlix1p1OvM2QEZooz/x5tLiVRB7+3pGSceMzt2frQLfYUY6fbIAkXK5J7vft+BTxDKy
	uwLlHrw+wdoFk1jEaugs4AbIjkcIcEL9nEMydJ5b64t1kCvKY6LzfZaovJmBY8RRstXgxY1qb+vSe
	/bDlQixg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciVn-007yWM-1p;
	Fri, 18 Jul 2025 18:56:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 20:56:15 +1000
Date: Fri, 18 Jul 2025 20:56:15 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: sean.wang@mediatek.com, olivia@selenic.com, matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] hwrng: mtk - handle devm_pm_runtime_enable errors
Message-ID: <aHooT8GLsVdupNO7@gondor.apana.org.au>
References: <20250629173141.2423728-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250629173141.2423728-1-ovidiu.panait.oss@gmail.com>

On Sun, Jun 29, 2025 at 08:31:41PM +0300, Ovidiu Panait wrote:
> Although unlikely, devm_pm_runtime_enable() call might fail, so handle
> the return value.
> 
> Fixes: 78cb66caa6ab ("hwrng: mtk - Use devm_pm_runtime_enable")
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  drivers/char/hw_random/mtk-rng.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
