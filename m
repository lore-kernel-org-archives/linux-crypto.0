Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76B21DB124;
	Mon, 19 May 2025 06:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634430; cv=none; b=dEXf94U39tGWNjXaTqxtdAa91dfcLk2q0BGEr1e0+FIzbYImp+U7Hp+TDP5V+PwTOZf80GTfGiqaJ331yS8+nSANWJhYXP8SXdBgNItIkCq+H/dixHpaID6LmVuItmJpUnSUc/vXm4XjXbYcciOVFLvf6EHvsnHHF/d12Z3sVmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634430; c=relaxed/simple;
	bh=kgBObOU0QEWFCvH9HE0z6Qenp2aFs/1chqQKcpffaZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FnclcmeXyc1ddBwUWh5kBFLBqCbJ17c4oGC/6qnwtkG4iQYKAjuZQo6VYMgntSakjWZQs8B3hfUVkGNsyyHyyia5hHRWHCuZjcoZDtnZsSePBO5l1uHkYfPDk5fRDTgY1yTRDcPzvHO2NudIBZID4f+VQxY3jzfE+kflUSjobCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XB7JJsCH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XB7JJsCH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zmYEzmY7zniKdLeHpZ92TRxM6yC+t06mMZulo7RohG8=; b=XB7JJsCHefpfhJizxSbXff55Ie
	SWXMyD1OWHTUUVFGs87RD8CYSGWU/LeUg49NfrKekGyoUmZfEsTRbluJS0LJ2R0GAp7hC+mHKV9Hz
	UUTX0R9A3Wd11nhmdKysON2m1Am1EHZvwob4mSqU+ED6JIpR1bDVZML3zbTxcToSIrhbqgeXleVQW
	S3bfaM0+YQWARjAqUg95UO7giSiTKbmKahXR0nFhpjgmjPPkXpWOG7Q/XYEVzObEl5QaenwwKmidS
	Vtoaf9Bj9MccaVPjvQvNx7R58U9ozSg8MYzzIxT/VB9CaV/Btgz/jVZpgXZwcLh+Quq7/UbbPRRff
	Ju3YaBog==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtXx-00785i-20;
	Mon, 19 May 2025 14:00:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 14:00:21 +0800
Date: Mon, 19 May 2025 14:00:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: Convert hisilicon,hip0{6,7}-sec to
 DT schema
Message-ID: <aCrI9fxmrUaQ89ze@gondor.apana.org.au>
References: <20250513184111.3052281-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513184111.3052281-1-robh@kernel.org>

On Tue, May 13, 2025 at 01:41:10PM -0500, Rob Herring (Arm) wrote:
> Convert the HiSilicon HIP06/7 Security Accelerator binding to DT schema
> format. It's a straight forward conversion.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../bindings/crypto/hisilicon,hip06-sec.yaml  | 134 ++++++++++++++++++
>  .../bindings/crypto/hisilicon,hip07-sec.txt   |  67 ---------
>  2 files changed, 134 insertions(+), 67 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
>  delete mode 100644 Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
