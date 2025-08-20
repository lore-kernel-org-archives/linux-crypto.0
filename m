Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D147F2D838A;
	Wed, 20 Aug 2025 07:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755675822; cv=none; b=e9eGdvLAUVAnxa22rpG9a1QC9tn6wq0UHBEOL3r3NvZKRxao8G6IOJjo+Nyg+2FfbKOACRTygE0/ZF6e3YzN9RB5uhhp+R1RMDdi5RtnmcXGbZZkmgXbqSTQYBjCZllooFtzH3TCD+kcoHUiOOq8TgQqY7kYDld2K4oCOYMhlDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755675822; c=relaxed/simple;
	bh=UjZfaipluX1s7VutU1TGz8040yUluQPNILqD6jFLiBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wt+7BFknB75aBZ393fey+D0wXaqOzatUOQiY6JYyQYjRV/oWlkVMHR2C3GP2xsQfPzyt1L64YJTXIbDmVuTVdq6EqE0bJsTQCRWih+AHPu9QqG5XZ8VJPSC5Q9XLm8dtsOuwRrCQp0pSGpOJYH5nZSAyvsBHATezhPDT4tZLBMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20ABC4CEEB;
	Wed, 20 Aug 2025 07:43:41 +0000 (UTC)
Date: Wed, 20 Aug 2025 09:43:39 +0200
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: T Pratham <t-pratham@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kamlesh Gurudasani <kamlesh@ti.com>, Manorit Chawdhry <m-chawdhry@ti.com>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Praneeth Bajjuri <praneeth@ti.com>, 
	Vishal Mahaveer <vishalm@ti.com>, Kavitha Malarvizhi <k-malarvizhi@ti.com>
Subject: Re: [PATCH v6 1/2] dt-bindings: crypto: Add binding for TI DTHE V2
Message-ID: <20250820-sexy-squirrel-of-luxury-e804de@kuoka>
References: <20250819065844.3337101-1-t-pratham@ti.com>
 <20250819065844.3337101-2-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250819065844.3337101-2-t-pratham@ti.com>

On Tue, Aug 19, 2025 at 11:42:44AM +0530, T Pratham wrote:
> Add DT binding for Texas Instruments DTHE V2 cryptography engine.
> 
> DTHE V2 is introduced as a part of TI AM62L SoC and can currently be
> only found in it.
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> Reviewed-By: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Why are you changing the tags?!?

This is not really acceptable. You must use the tag exactly as given to
you. Not alter it anyhow!

Best regards,
Krzysztof

