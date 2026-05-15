Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E013D0922;
	Fri, 15 May 2026 10:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840762; cv=none; b=V9ctg8uEBoybYb802xPsPAuA5KyxB6ZOBHOBAYg7NRXJlcEA1srG04EdJglbsM8Qv3mWOPrZfwvIdYGnsImT5wQ9ypB0alJR//B5SenSKCkUTFyzLOPt0ShN/UKhuCjevH6/RG5BjJ2dtOCe2U/ixHpGFi4aX3ASbRKj4LJDOPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840762; c=relaxed/simple;
	bh=a4t2zbgEs7wMNizoN4MmBSU3c/KM1ikNm7qqhoK8acQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yizrnz65L72OCW8pHk5aHhdUpMDwXYEd3LmIoyZTy8wYCIQXyrghw9Fu1ExYCKr2EbVEmfR52qcgDnv3/UOkHtSEo4I4NXImNm0YYNUam45dR6ipJKjl5dku81wKx+EZqWZOAzd2YfdfxpgJ0xycHRNiSuNe1jfi+a5NGpnYznc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZCfFx8yX; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZCfFx8yX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fHS5nLFEqwme9DhbjhJcBd3DSgo9yk+52kAgrx6WOtk=; 
	b=ZCfFx8yXVNdeRA7RnYf7RJdX0kywe9Zjf7UOkZYB5iYiA0E4iyGmIIowaEUaD5qEHo2k+/97PYI
	DfHdVUvi5igyTcxny3wwLUB1ucidN7BTD48K7waCgb1bCfylP+k2RnkgtdBxyYFBRHBYOU8mpedlh
	/61CfobByOfjE1Tk+w+8lqhcbohDq14yjq1i0oN3ctEXdGSsI8IlSTVGp3cgVG60gMMY8iJ+vbguQ
	BROwIr0YgESBn48VednZIyU4whC3wjg5Qfb0wm2rc3zdRBaFZH+ISmctatrq2O4z2sSQluzVEqvZq
	dYkhI/borpEF5PJ/WakrK5B4JmEPF2k/ErRw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpju-00EOda-0a;
	Fri, 15 May 2026 18:25:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:25:54 +0800
Date: Fri, 15 May 2026 18:25:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] dt-bindings: crypto: qcom,prng: Document TRNG on Nord
 SoC
Message-ID: <agb0skPLcH189txP@gondor.apana.org.au>
References: <20260510021809.1130114-1-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260510021809.1130114-1-shengchao.guo@oss.qualcomm.com>

On Sun, May 10, 2026 at 10:18:09AM +0800, Shawn Guo wrote:
> From: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
> 
> Document True Random Number Generator on Qualcomm Nord SoC.
> 
> Signed-off-by: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
> Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> ---
> Changes in v3:
>  - Improve commit log to drop "compatible with qcom,trng" part
>  - Link to v2 (TRNG): https://lore.kernel.org/all/20260427012308.231350-1-shengchao.guo@oss.qualcomm.com/
> 
> Changes in v2:
>  - Improve commit log to make the compatibility explicit
>  - Add missing SoB
>  - Link to v1: https://lore.kernel.org/all/20260420025732.1240525-1-shengchao.guo@oss.qualcomm.com/
> 
>  Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
