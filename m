Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B79E145B11;
	Fri,  6 Sep 2024 07:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725606644; cv=none; b=DNgeoqDZAzo8P1krnlUJtOEtX9pYnY9DTNkIG5YfV1E+iQtSdz7O9gHDIzLvBNxnDJFSpH4elnJcfUSj1XmlASXyoYfSrHfiBK7gDH1S5/o9MqUMnuu/kqKJouMwGoSL3Y7PQ/AHHPFwvmbjh0KIvs3cluZYwRRr4dbEAIW8+4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725606644; c=relaxed/simple;
	bh=Ds7RT2fVT/UbrmuVwfHzcEs0c0ik9tAfLKssDNBJXZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLmdJnNFmTeScMcg0dR8MWMkM1lC5hWlivTczZ05/6wVJBN+TCmfftMhQRfd4GWHGjhUiT98EY53UwmCcAdv4FiPqj7y6Ru2IgvjlGoHRAE4lhL2FhsWS/E8XbFcuT1PdUktxoTc1R5I4xSEKEGg5v5yweBkJt9xEbIXtu8yubI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EfUTrArE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EfUTrArE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ToMMlBX7EEWJ20/agcgqyPHaIBkdoV0RP+7ViTCkwws=; b=EfUTrArEUtkQp+PmyqsOPvY7oX
	MJ3FKI79nUaykR74o7QpSliRvFFeLoHRAOfLXXuWn1cRC4G5PTS0BVXYNQA5KEicRlwYMS1reJaN7
	MsaAU/t4Jf3VXnMiJlRmGiUXa3uSeLq0IJY7v7SldRMQbC1hWJJZKJ1ZNcCeP4M8g674vXE8oeXlh
	gnJePzvfkidao7NTisLuQ7cnKtNvPmLKEbW28RvuayKggx31mOD5j0mCSwbC3+ujy06uQ+mGt7lXY
	ecoAUvsJmZQGBnE/X1woX+ASszCde2fFfOtmfnCY40glWYp49R/FNy4+jtvL+fQHKLWntdXI+Iw6A
	9SYwJAFg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1smSxB-000WbE-2l;
	Fri, 06 Sep 2024 15:10:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Sep 2024 15:10:35 +0800
Date: Fri, 6 Sep 2024 15:10:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S . Miller" <davem@davemloft.net>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] crypto: qat - Remove trailing space after \n
 newline
Message-ID: <Ztqq68WWG13hoPce@gondor.apana.org.au>
References: <20240901160717.143334-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240901160717.143334-1-colin.i.king@gmail.com>

On Sun, Sep 01, 2024 at 05:07:17PM +0100, Colin Ian King wrote:
> There is a extraneous space after a newline in a pr_err message.
> Remove it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_uclo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
