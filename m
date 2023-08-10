Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8ABC04A94
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Aug 2023 20:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjHJUWf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Aug 2023 16:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjHJUWe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2023 16:22:34 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABD110F5;
        Thu, 10 Aug 2023 13:22:34 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 37AKLmkd026494;
        Thu, 10 Aug 2023 15:21:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1691698908;
        bh=j1aDevVbccNYpcdFHjgIPkEX2CjbS6rxvkxWOg9hKF8=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=A7QpFeL43WW9ooMRiJiYV5cmKnUZM+60d4yzCSW/TCgVPiK4yZr8A5FA9hga4tVur
         xD8BJQMLBj9Zv64thcpM1LLqPVWKf1LBN+mCAwwStG+cj1pQriLs1rF2yUdk7Ld0t3
         +bqNBQtDkDYPy0FP12pRf9EBT1lKv3NgWv+Sasqk=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 37AKLm13028698
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Aug 2023 15:21:48 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 10
 Aug 2023 15:21:47 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 10 Aug 2023 15:21:47 -0500
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 37AKLlLx018218;
        Thu, 10 Aug 2023 15:21:47 -0500
Date:   Thu, 10 Aug 2023 15:21:47 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Kamlesh Gurudasani <kamlesh@ti.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: Re: [PATCH v2 5/6] arm64: dts: ti: k3-am62: Add dt node, cbass_main
 ranges for MCRC64
Message-ID: <20230810202147.lh5m66t5ttfhsqr4@gloomily>
References: <20230719-mcrc-upstream-v2-0-4152b987e4c2@ti.com>
 <20230719-mcrc-upstream-v2-5-4152b987e4c2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230719-mcrc-upstream-v2-5-4152b987e4c2@ti.com>
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 00:58-20230811, Kamlesh Gurudasani wrote:
> Add the address space for MCRC64 to the ranges property of the
> cbass_main node and add dt node for MCRC64 engine
> 
> Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
> ---

Please mark device tree changes in the same series (if you are posting) as
"DONOTMERGE" to help driver maintainers understand that the dts come in
via SoC tree (most maintainers do not need this, but it keeps things
sane and adjust your expectation that this will hit the next window from
where the driver gets in).

-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D
