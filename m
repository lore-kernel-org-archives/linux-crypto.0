Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175F73E023D;
	Fri, 15 May 2026 07:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778828595; cv=none; b=AxoHDAmoCIa4bi7fiA9AdDA3CfXr+lrIp122rlPPln17XB8YmescZh5HnKV0Glg1o9CuioPL6D2wqyWL67lClTVUVqty0aseV06fypAUanWZiekL5AWSWm9KB8kyuHP02qj/S8J9aGwSyioLXDaBiyDdrCa4dTmlF8nNx1IsIWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778828595; c=relaxed/simple;
	bh=UFt1H7tojIcyi2oC15rpkmT6R6HC5/FNUsSIF/Zi1J4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2g5+8l4beP0A00uWWiPqUDzlsb3XS90rHt+VuwbofdswkPegoqPvxKH6BnZDVNmb8Y4KPz4z2gY/7RW/78D6d2qh52w6/seT9HSg8mHQpP+tmX41bhaR6iqqDGHfEau37e4/mUXSf8IJg6KKOQNOXoLQBnXiEowhkzBDZd3JJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RoYIE3d1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RoYIE3d1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E6CC2BCB0;
	Fri, 15 May 2026 07:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778828594;
	bh=UFt1H7tojIcyi2oC15rpkmT6R6HC5/FNUsSIF/Zi1J4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RoYIE3d18NM5bJCnRjqcHMyUcICYz9g4b2qzfHDjKjsLG2NaqBdm/6uE1oD/XZgoF
	 14+tsjB/Wia9FkSFusxW0lRQEkXa5m8Cc7NNtU1sDtBEn7QaDGgMbgEYAVB0NEeSwj
	 rwQj1NbvIeDv5yiovPNvJd/b2xK1/hq54Zb8rz5GXsX7phXFqwEcAQtYirqBaUn1Ro
	 pl64DRyaRU+W+hn0U3tZQn5Z+znD+zKwBkAy5mNILA1PWsrzK8PIDLIGOqvbddTmz4
	 LLY0kz6yf3SuHK7B6+rFr0/dFkNdPnr7LbfZ5nQXSTMTcISlVmW6+9uf3LwrWPXYuC
	 FOYqihvAmu8Uw==
Date: Fri, 15 May 2026 09:03:12 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
Cc: andersson@kernel.org, konradybcio@kernel.org, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	davem@davemloft.net, neil.armstrong@linaro.org, maarten.lankhorst@linux.intel.com, 
	mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, 
	jikos@kernel.org, bentiss@kernel.org, luzmaximilian@gmail.com, hansg@kernel.org, 
	ilpo.jarvinen@linux.intel.com, Douglas Anderson <dianders@chromium.org>, 
	Jessica Zhang <jesszhan0024@gmail.com>, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v2 1/7] dt-bindings: arm: qcom: Add Microsoft Surface Pro
 12in
Message-ID: <20260515-fabulous-married-pogona-ebccd9@quoll>
References: <cover.1778822464.git.harrison.vanderbyl@gmail.com>
 <e54aa6c1e190b0e26d58504c5ea1b05fd09d64d3.1778822464.git.harrison.vanderbyl@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e54aa6c1e190b0e26d58504c5ea1b05fd09d64d3.1778822464.git.harrison.vanderbyl@gmail.com>

On Fri, May 15, 2026 at 03:41:46PM +1000, Harrison Vanderbyl wrote:
> Document the compatible string for the Microsoft Surface Pro
> 12-inch, 1st Edition with Snapdragon, based on the Qualcomm X1P42100
> SoC.
> 
> Signed-off-by: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
> ---
>  Documentation/devicetree/bindings/arm/qcom.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
> index b4943123d2e4..aaa9a129908a 100644
> --- a/Documentation/devicetree/bindings/arm/qcom.yaml
> +++ b/Documentation/devicetree/bindings/arm/qcom.yaml
> @@ -1168,6 +1168,10 @@ properties:
>            - const: microsoft,denali
>            - const: qcom,x1e80100
>  
> +      - items:
> +          - const: microsoft,surface-pro-12in

Why isn't this part of the other enum with all devices?

Best regards,
Krzysztof

