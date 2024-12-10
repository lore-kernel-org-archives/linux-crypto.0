Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231CB3C17;
	Tue, 10 Dec 2024 03:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733801483; cv=none; b=owd9KCP0DFyuiwsIzQfzSocXfT5iQNN1FjAozfTMTGIrW7SVdCft9Xgl1hPNYedi/1sB2PtlfzTeuS3fnCgeY0tC4V0pBHRJ1HkOGcAua3ZIfcGHBi+FbQuB9bYg0mPOUEOUcWIdq75x6RYL9s4nQX49l+YoBo5WkuI/TSbHNB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733801483; c=relaxed/simple;
	bh=/xvEaXqGClLSE99ARv0pGP9OeJYBuAOmZF9ym6pK5dQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQewkkoWlPyvCaU1b+xn+BTxzc9UOrcBU3Oo3o0JhplkBKtJsJJPVmEViFekQ5bJSLT7cOJS6WumhO5cPO2CUHwrDk3dnUA3dL4I66iQcB0QmcpG/FEgJj+biPyKtKYFRMvFNrflvLt8uJ5VnB73wOEL/2KfvM4vguXlOI+lR7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EqmWEt5t; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EqmWEt5t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PdXlbzhXZmgM+/eqQWKKsKXyeZE8Daydu9uXrb9axzY=; b=EqmWEt5txs0xDkJ0tuhuegtQgG
	DbQGwhpodXCGblVK9YG83Esxtx0iPWhlpdL9ON7iDUGZKisUwys5oymBkcf2lzSppUFa3bXkh+v2i
	L9YAJPvrTnWK2diPG78AYov+74/BRf9s5zO2G1r7+WzBrMmUTIW/tlZ/6aOJdvUFtmN88xEn0pHpY
	TVQr295iEmiHe2C5bFsqD4lkKmrCppsnChhF6n9fvbONT9CkunOGuESSCERJRy/UThpw6tecgU0tP
	WRKL0IhxuML/VbQgpkDp8fcQru8EJpRSquKiwwGkkq8rxhI6d3JTL3hQgIBnQyTNMICtp9y9PxPUp
	NDVNes6Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tKqky-000NDB-0X;
	Tue, 10 Dec 2024 11:31:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Dec 2024 11:31:12 +0800
Date: Tue, 10 Dec 2024 11:31:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	qianweili@huawei.com, linwenkai6@hisilicon.com
Subject: Re: [PATCH v4 2/2] crypto: hisilicon/sec2 - fix for aead invalid
 authsize
Message-ID: <Z1e2APBqSnl8ayyu@gondor.apana.org.au>
References: <20241115102139.3793659-1-huangchenghai2@huawei.com>
 <20241115102139.3793659-3-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115102139.3793659-3-huangchenghai2@huawei.com>

On Fri, Nov 15, 2024 at 06:21:39PM +0800, Chenghai Huang wrote:
>
> +	a_ctx->fallback = false;

Is this field still used anywhere? If not please remove it.  It's
confusing to have two fallback fields.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
