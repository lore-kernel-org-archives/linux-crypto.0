Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A1C2DF68;
	Mon, 13 Jul 2026 03:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783914394; cv=none; b=Imz3uLExjZWEbPFi7ODi121o/SQ5DOZ1S8zmoBvMgMHVrnrgSkkXt9Cg3fFJvi9Zw9zbZfyL0IlP0iIYpVXnnlnDFkOLybFWtzm9FZNVm37bflRtqK3kOxO7VKMxQAtPBonlHpkRajcdqSBPM+/3zrNQzksBeAZORyTtqltb7cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783914394; c=relaxed/simple;
	bh=qtEoogvxKGJ76i4M6IiQnJGcbXNjG5+fh4/1XzPPeS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4nVDIfl7lnfcKWNm2miDaP3vZcZVMXFZUo+INBRv8m3mye2KDCUeypLFb81e3BKQHppjBx/9fIXlHjLN8NBXFNqkUHlHVuwGaYI9GbQcgEbucnhEDieplozm4tokeENpnMaG3WjXuqqE5viCnPprw8IzTOU6r+MTZ69El31lu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=K9dMVVF+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="K9dMVVF+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7mSwWawINr+yQ3GlhEeqmNy45YB9kP71mUDFm0s9/Xg=; 
	b=K9dMVVF+QxMdhpzGsbpa2/ZjEntH68QJxbXRSnkVvZlLr8qkWv6V49Y6j4Wupf0VlFGIVVBfowK
	3cFRKqJvQMqVrn24EB7NP72skkhG/7ZFOHbHXaD7gNKuB+sOKhDTvJV4ammNaRmRuBsrPYQK2EYmP
	Iyn2xWVjUvY8/1dxiD2se/6Om+cfza1c1s/mfM0bPjw0e8w4Qv8iL8Ifby2qZBIZGu7ed0cnCWXDR
	SZOkC3zPzGav6ECS0Sp3PD3gv5oQM5FtidLunl3Ehuu5LcAA3KtjBvXbUOQ3W1C9VvL0QGILvWgK0
	0TMPKMannKPDOgrUyldb1GpkC1RDVvk6xvsQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj7cY-0000000CyI2-3jM8;
	Mon, 13 Jul 2026 11:46:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 13:46:18 +1000
Date: Mon, 13 Jul 2026 13:46:18 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Linus Walleij <linusw@kernel.org>, Imre Kaloz <kaloz@openwrt.org>,
	Corentin Labbe <clabbe@baylibre.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ixp4xx: add missing MODULE_DEVICE_TABLE()
Message-ID: <alRfim2lYMuJhlni@gondor.apana.org.au>
References: <20260704121524.42229-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704121524.42229-1-pengpeng@iscas.ac.cn>

On Sat, Jul 04, 2026 at 08:15:24PM +0800, Pengpeng Hou wrote:
> The driver has an OF match table wired to .of_match_table, but does
> not export the table with MODULE_DEVICE_TABLE().
> 
> Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
> information is generated for OF based module autoloading.
> 
> This is a source-level fix.  It does not claim dynamic hardware
> reproduction; the evidence is the driver-owned match table, its use by
> the platform driver, and the missing module alias publication.
> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
