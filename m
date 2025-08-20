Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE072D9EDF;
	Wed, 20 Aug 2025 08:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755679959; cv=none; b=aHdtQevQ8VzSHI40rnMlCA2GcfuNUDM0Dr/5ec+3b4vdQomo9UrcvhFEMlZmDEJFnAqKpkofh/OQeqb1M1jzi7uWiNc3YSo2ouiYyaoeSCLhmDpeqWlLAV1MD3VFjsGMpu5ijQnX5D6OYKr60QhCouFpQg/DMFhHMzsWlpEnAB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755679959; c=relaxed/simple;
	bh=oM8XNDl1DYReoxHIuDjJ+OnF09W+Wi6J5+8G1LnZyzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=AJjn18ynSC83KsLo/+KxldE2bZGTkx87hnAjJCiqnvDqM0AE2WRWimbwYqH4JNdOOpXwO475IhfNIjPK7Vxrylc07T2AslI6eKv3nYUgC9Bcn+Lzr6wYVnZGTGGxRej6+TBUXJrH+geTY7ibMpxf4IpRS4VbxwxN14fWZ/MVoeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=OWpMC7pk; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="OWpMC7pk"
Received: from fllvem-sh04.itg.ti.com ([10.64.41.54])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTP id 57K8qQvt211140;
	Wed, 20 Aug 2025 03:52:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1755679946;
	bh=KgOH8yGghBrWgKbYJhkgv5ekhcZZGomNG4oipvVRzXw=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=OWpMC7pkP2/NqjVzPpNQ8mnOqigYNbwNsrl4J6KOgw7TCWpA+3hEB9Duyr2qLZfFT
	 hmrJ7uu6D9cP1VrV9toNYGnq9OZtfcXnzT2nFVQ+lAoYq1cbSRbBua0fcWMXczrZOt
	 sFI3m5qn4TotBKNqLROF5+izrDzNaNH3H+jlP9oo=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
	by fllvem-sh04.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 57K8qQuU1929603
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Wed, 20 Aug 2025 03:52:26 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Wed, 20
 Aug 2025 03:52:26 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55 via
 Frontend Transport; Wed, 20 Aug 2025 03:52:25 -0500
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 57K8qLUX4155904;
	Wed, 20 Aug 2025 03:52:22 -0500
Message-ID: <837940eb-7e25-4021-97ec-6b692d7c3ebf@ti.com>
Date: Wed, 20 Aug 2025 14:22:21 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] dt-bindings: crypto: Add binding for TI DTHE V2
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller"
	<davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski
	<krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Manorit
 Chawdhry <m-chawdhry@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth
 Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        Kavitha
 Malarvizhi <k-malarvizhi@ti.com>
References: <20250819065844.3337101-1-t-pratham@ti.com>
 <20250819065844.3337101-2-t-pratham@ti.com>
 <20250820-sexy-squirrel-of-luxury-e804de@kuoka>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <20250820-sexy-squirrel-of-luxury-e804de@kuoka>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

On 20/08/25 13:13, Krzysztof Kozlowski wrote:
> On Tue, Aug 19, 2025 at 11:42:44AM +0530, T Pratham wrote:
>> Add DT binding for Texas Instruments DTHE V2 cryptography engine.
>>
>> DTHE V2 is introduced as a part of TI AM62L SoC and can currently be
>> only found in it.
>>
>> Signed-off-by: T Pratham <t-pratham@ti.com>
>> Reviewed-By: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> Why are you changing the tags?!?
> 
> This is not really acceptable. You must use the tag exactly as given to
> you. Not alter it anyhow!
> 
> Best regards,
> Krzysztof
> 
Apologies! Genuine error from my side adding the tag in v5. Got carried over to v6 as well.
Will correct this in next re-spin.

Regards
T Pratham
