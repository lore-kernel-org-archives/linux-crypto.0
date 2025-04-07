Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D791938FA3;
	Mon,  7 Apr 2025 05:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744002307; cv=none; b=TtOBONmLDvAyh4f3ZZQs4eCy7ihkre25KNnBLuVomSFSC1YI1Gqe/4z72YJI5e6HUzZC0TEOaYm3WlOWbM+vXHNp127xUwm9rBjUBZtomm/A0+7FNUkiqGIsLL4QfRLVqzmLA0LQni86vSDUY9Q4MiRi5lXtcFLnnva71aD4t/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744002307; c=relaxed/simple;
	bh=3RlbR2XuJsv6PPLY9Jiu+JdacViJXQTWrxhlQzUEjb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AcQG7UOw/6h5JyLIQuz4SVLug0m9ELYRHTgV6OTnMWPYTkcJc9E+HmowWHzabnFyRQOB8pPYGeY/4CZKoOTo79ijyP1QO464rhVjg97cdIGzqdUZruKFrUwog9Rs+RqBpdgPa66Go7Ww95H+uWqfbzj07UlfYxmbaVhMimbkiNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Z0Wn13sP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Z0Wn13sP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4UiTwlP4t/xW5NGvvkumJqkirVU2BhoXZx2+6zulc8w=; b=Z0Wn13sPJS328uueenHJus6O9W
	DC8gW2avavlR9J2hnC6rX2dVzkC9p6FHg/yJUHIAdTq2xCeYaunbytrAwr4wM6yES7H3Uaztekh4a
	x0CnhwCExjKf5YIk+XIUIqaYmQRnBB7YFfBYVA3VreiBCIMKUh1P4F2sxjvv5kpuwiac6TO7I3rVi
	nzL6S0zKQp0xm4dxvjxdJhMaeEdodTgLKWGy8TMz1l04qNodMpvAzYbWjhSTq4TEDZ5iw+mDAj1j7
	1Zt3zE6EwPxFBQx/dI5fgEJI0aath/9N/8laXG0lc4OF7oNuj8o2/Kr/vefbBHPDMxUy4PtXJ0lbe
	5bzp9fag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1efD-00DN7z-0O;
	Mon, 07 Apr 2025 13:04:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 13:04:51 +0800
Date: Mon, 7 Apr 2025 13:04:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Abhinaba Rakshit <quic_arakshit@quicinc.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: qcom-qce: document QCS615
 crypto engine
Message-ID: <Z_Nc83JRS7YuZ8S4@gondor.apana.org.au>
References: <20250318-enable-qce-for-qcs615-v2-0-c5e05fe22572@quicinc.com>
 <20250318-enable-qce-for-qcs615-v2-1-c5e05fe22572@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318-enable-qce-for-qcs615-v2-1-c5e05fe22572@quicinc.com>

On Tue, Mar 18, 2025 at 03:13:23PM +0530, Abhinaba Rakshit wrote:
> Document the crypto engine on the QCS615 platform.
> 
> Acked-by: Rob Herring (Arm) <robh@kernel.org>
> Signed-off-by: Abhinaba Rakshit <quic_arakshit@quicinc.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
