Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A97748F;
	Tue,  3 Jun 2025 10:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748947949; cv=none; b=vFAN/e8CfeyG7rV/mmHyYL5rtbzp6yzLtXa2QxC0TJSi3NGy5oAywNwU+pY8fTnEJeGyRC5MYRVfuuotDZulRppgGaq1WPfkvzMX8IZiQCb6/56f1D+6fk1G5E8Pr/JXmpOC+ngDA71/n6zmus8lAl/vw3VcWW0VarnbVFpBibs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748947949; c=relaxed/simple;
	bh=PxJrGD3bfCZUl3tbUsnqF1XYCv8j9URqWAX6zCtDvkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HhLX7P9WboLVJrF0t5j2u6vNicf6R0sjLAAMxpAqqZCNu6wnOB68GuRJ8TgP4cJAKkRbAqsnHeup8X9X5UtFsHHfvE7PJIeKKIE3uLVQhAauCdv9Y9xRHNh+3G3DDfaSRXjNpn5T1Q3f3jMuU4sGCLMwYCCtpZN+5q1RPMuXUss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=KJnKuBku; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="KJnKuBku"
Received: from lelvem-sh02.itg.ti.com ([10.180.78.226])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTP id 553AqHD3501826;
	Tue, 3 Jun 2025 05:52:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1748947937;
	bh=CBsdQNtfQgpNjDFn/Xo4/d4ZPaIWBmLTlsA4vozo2Ko=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=KJnKuBku+RkKxmNGbeDnXeSZAPG8wWGMQMgwxQZJXUrrMgOeiEZZneQ1imm3REz0m
	 IYLZHqCIksfxEnxhRBBaEGZW5LNEmc95oUrnmfeR3mxOKsrVde8KHbTwjC4J0U1Dod
	 bCMajdKjOWrK37avttk+V/Pr/UrIzjev4RMMZvg0=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
	by lelvem-sh02.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 553AqH1n1267465
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Tue, 3 Jun 2025 05:52:17 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 3
 Jun 2025 05:52:16 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 3 Jun 2025 05:52:16 -0500
Received: from [172.24.227.40] (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 553AqC1R318886;
	Tue, 3 Jun 2025 05:52:13 -0500
Message-ID: <b254325e-32c6-4b5d-a20c-abe2888fea27@ti.com>
Date: Tue, 3 Jun 2025 16:22:12 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] dt-bindings: crypto: Add binding for TI DTHE V2
To: "Rob Herring (Arm)" <robh@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Manorit Chawdhry <m-chawdhry@ti.com>, <devicetree@vger.kernel.org>,
        Vignesh
 Raghavendra <vigneshr@ti.com>,
        Conor Dooley <conor+dt@kernel.org>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>, <linux-crypto@vger.kernel.org>,
        "David S.
 Miller" <davem@davemloft.net>
References: <20250508101723.846210-2-t-pratham@ti.com>
 <20250508101723.846210-3-t-pratham@ti.com>
 <174670267292.3889463.9488828665934209667.robh@kernel.org>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <174670267292.3889463.9488828665934209667.robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

On 08/05/25 16:41, Rob Herring (Arm) wrote:
> 
> On Thu, 08 May 2025 15:37:40 +0530, T Pratham wrote:
>> Add DT binding for Texas Instruments DTHE V2 crypto accelerator.
>>
>> DTHE V2 is introduced as a part of TI AM62L SoC and can currently be
>> only found in it.
>>
>> Signed-off-by: T Pratham <t-pratham@ti.com>
>> ---
>>  .../bindings/crypto/ti,am62l-dthev2.yaml      | 50 +++++++++++++++++++
>>  MAINTAINERS                                   |  6 +++
>>  2 files changed, 56 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml
>>
> 
> My bot found errors running 'make dt_binding_check' on your patch:
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> 
> 
> doc reference errors (make refcheckdocs):
> 
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250508101723.846210-3-t-pratham@ti.com
> 
Hi, the error logs here are empty. What does this mean (error, no error)?

Also, I ran `make dt_binding_check` locally and did not see any errors. Below dependencies are installed and up to date. 
> The base for the series is generally the latest rc1. A different dependency
> should be noted in *this* patch.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your schema.
> 

Regards
T Pratham <t-pratham@ti.com>
