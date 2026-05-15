Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408F044102D;
	Fri, 15 May 2026 10:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778839858; cv=none; b=gKq8JGndCvXdV5+YYM39M9qgAjt0nAGMuwbizl3D2pA9DKKZDt7xNHhZQP12+UdDKi/XGirtvZYwEStazxEvZPrelu22GES0VHB+Y8L+684wsDM3EewBaQSzchVhBlc2MOXKyt4CS4wyL1qUrxFVhxtTBEdR3sUGb7O9fN9A3lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778839858; c=relaxed/simple;
	bh=Rv/BPwvCCWxXgKgh7kO8KUYntokXQbfbIeW+VrpEnvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mo8ZWjRA+nxT6/etOv007rdDayivT0cgotKw825MH1LWz0ohFB68Bh/0cOA4l7IkJVKRTx+edCEQehEfjooddNVHm/JF7JdcgigT6vTkpr2MlJPIwbhwOP4o10XnrDQ2ACQr479FhUL+qTxnFZMTb69FlT0ZyoBtz7LPrOV7YKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=U1zZsmma; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="U1zZsmma"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=UQFQqUVIKap8MG/Do78U3BfChHfkr0qaaj0pyefbYAQ=; 
	b=U1zZsmmaIHkjZeec3R1pEc7opy1GKVIUXkPI6Yx2/FNuUP1+u2KsOw9qtHyX2Xma+RZZiSNALMz
	ghu9VQ2X0ZVgeZFNgV+qRrDrDvRkEm5aXPbzfy/nyT7MRVHcy3uyEHGCUnGEgnHQ5lbj7PYnd4552
	Q38Hn5eLAleeGdpwguJi7GsbVt8l88IoXUD5vgbVogenMDVlvj0EwMW1VhmErYv36iqmr9+b8Bgs2
	YNhkIyyG6UfDEo3DM3ENNTpyxFmWZh9QiGF6jhAMso1SKkQxZrZz/oWCgYZvStpiJHcPfWpx6fBdA
	VNhV20z61amEhCsQYsUai+6i2DBnis3XsyKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpVH-00EOD3-1z;
	Fri, 15 May 2026 18:10:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:10:47 +0800
Date: Fri, 15 May 2026 18:10:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: qcom-qce: document the Nord crypto
 engine
Message-ID: <agbxJ12oAXZ7h89S@gondor.apana.org.au>
References: <20260429081021.16380-1-bartosz.golaszewski@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429081021.16380-1-bartosz.golaszewski@oss.qualcomm.com>

On Wed, Apr 29, 2026 at 10:10:20AM +0200, Bartosz Golaszewski wrote:
> Document the crypto engine on the Qualcomm Nord Platform.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
