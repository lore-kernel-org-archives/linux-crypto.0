Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021B919D06D;
	Thu,  5 Sep 2024 12:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725539236; cv=none; b=UgWnNPZfGhO+hpycVsriLfMUHTcSdKAqLi+/OSii2yYl2NnuZScogylussbMeDN7txiDHaULMjTsrjgWG+7+NiUo2uqdQ/eREcf6meIt0QbN8XOzW4Vl0TdDda+MhTOftiDAULnFphX/sog+S8fRIZ+xeLkvTnED3+0qUO/1WNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725539236; c=relaxed/simple;
	bh=7pI3kD+n9FnYo4RHoeLXuB2a8jfBkevWaqeGhyenAFE=;
	h=Date:Content-Type:MIME-Version:From:To:Cc:In-Reply-To:References:
	 Message-Id:Subject; b=jHkA2YNMaPTozYBIpAfJxk0BoTvbwJ1fIxqP6ZSEylMJaRZa/LUFa76YxP2DzbKAz0L3+uXmw4pDlm4Cd4CEQqRrCVYOIR/S5OIo4Qm0r6LHf+RVz1ZbnB0J61DYUVGcu2rp4Z3c9tTB8OvylsRNMLtk03rN+3CIwFQOOIIUoMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLgjdM60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLgjdM60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71384C4CEC3;
	Thu,  5 Sep 2024 12:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725539235;
	bh=7pI3kD+n9FnYo4RHoeLXuB2a8jfBkevWaqeGhyenAFE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=FLgjdM60RYrieY83wIhT7bLxNZTh6eysaZmch7+OBxDc7JSIqnGsl6xcfH22y+W7H
	 fa//CFsStiqVqOkl1gjtY0rNpvlyDgaPr4jFDAhQYNaMG8zJ2NJ7zF+gcpiQZNL03P
	 Z8jnfuLwdCEPcLbR3QsQnQxtQpwi5oCHJGa6CLeqE/+Ka6aSCMv6xE1AB4WJMSiUbd
	 LQwqO1cns48k+uCYElDVuxRTowV44Fcs9B9E/wlan8pPEQjwgnS8Wn8TjB7iQCmmqK
	 PBbt5tKosYYdr47zw2jo4053St7uzxYJv9/BP1b7ZDbYo/SlDugOdRdggESrmmii0v
	 hny977EoUPz5A==
Date: Thu, 05 Sep 2024 07:27:14 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: bhoomikak@vayavyalabs.com, devicetree@vger.kernel.org, 
 herbert@gondor.apana.org.au, manjunath.hadli@vayavyalabs.com, 
 Ruud.Derwig@synopsys.com, linux-crypto@vger.kernel.org
In-Reply-To: <20240905112622.237681-2-pavitrakumarm@vayavyalabs.com>
References: <20240905112622.237681-1-pavitrakumarm@vayavyalabs.com>
 <20240905112622.237681-2-pavitrakumarm@vayavyalabs.com>
Message-Id: <172553923453.1303716.15154978947551936955.robh@kernel.org>
Subject: Re: [PATCH 1/1] dt-bindings: crypto: Document support for SPAcc


On Thu, 05 Sep 2024 16:56:22 +0530, Pavitrakumar M wrote:
> Add DT bindings related to the SPAcc driver for Documentation.
> DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
> Engine is a crypto IP designed by Synopsys.
> 
> Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> ---
>  .../bindings/crypto/snps,dwc-spacc.yaml       | 79 +++++++++++++++++++
>  1 file changed, 79 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.example.dtb: spacc@40000000: spacc-wdtimer: 10000 is less than the minimum of 102400
	from schema $id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20240905112622.237681-2-pavitrakumarm@vayavyalabs.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

