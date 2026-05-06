Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61C072627;
	Wed,  6 May 2026 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778080993; cv=none; b=IxdPBhO6LCPmfGRsAruGi5rLitl88J+qBqkTtuNsafAStGFHbCSoMp7nVFY5FUC8RCNsCqFKir/fDylb33s3NZ5S0jpuye9m1mdEWu9ygrDU6Fwoks2O7bOMuNJ7iZAYEK80KS9kVk7yy1eYJGp82TvsMZaoN6+vgNqnRfI4x0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778080993; c=relaxed/simple;
	bh=V+9LRE9DDhuKr6ZZ/HALlvqwy8cp4ENj3/Lz0I/d0fI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aQtip+CuZ5ArMCFTpl+nyQwdMFkqrz8vD8PZhWkqR4gDngcIT17WlaJuasVizHeqpudX7uyoP6tLSWcL95Pibl2LcjSyjfELSWE213NoYEO3kjS17cm5sh7icanQDw4PWvERSt3nX+bP+wkvy8NmWNThYTHSUfbtFx6GaK4tV4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvWixOoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvWixOoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A16FC2BCB0;
	Wed,  6 May 2026 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778080991;
	bh=V+9LRE9DDhuKr6ZZ/HALlvqwy8cp4ENj3/Lz0I/d0fI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hvWixOoQp94LAWXlAMSe65AuGtNjJPIwjei2ZvZfrTLEw6RkbRs402J/0FRU1jJGS
	 IVcUwPVSmDSVYaBQL/PWgF7YxP+wUxJBfB2tKyjqzmop7PnH4JVk25+Ofiv5fhaIX2
	 EIYIl3z8rsuc2pdu19NAzIAxlalzRLsAsF8j04JjrwjhdomahQpRE5pumyPWdjECAp
	 BAvT7dQR7TBYAC8Fhi2RvKFSNUIFbMnj1ueeNb5rE8JURggEfMcS+vvQJU8UUDVTqy
	 U//LnHbz2B+Jh7Sn6XWjKMsGFDnWaPgjEW79BL9WrDi8di9khPccGSZ8U7t5On2rlt
	 qDN1NCizghgsA==
Date: Wed, 6 May 2026 10:23:09 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Konrad Dybcio <konradybcio@kernel.org>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Bjorn Andersson <andersson@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Conor Dooley <conor+dt@kernel.org>
Subject: Re: [PATCH] dt-bindings: crypto: qcom-qce: document the Nord crypto
 engine
Message-ID: <177808098870.2152824.11717885412954046946.robh@kernel.org>
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


On Wed, 29 Apr 2026 10:10:20 +0200, Bartosz Golaszewski wrote:
> Document the crypto engine on the Qualcomm Nord Platform.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>

