Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F13C41513
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jul 2023 16:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjGXQpr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjGXQpk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2023 12:45:40 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD04210FD;
        Mon, 24 Jul 2023 09:45:36 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 36OGjMDL014257;
        Mon, 24 Jul 2023 11:45:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1690217122;
        bh=J/1A54UrbnLwjoFDugLDlJ2Tk5ZoBNw19JPk+14nDnc=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=p4YnrqcxOJIObrcxUaMUcbN+rp4yajyI1LSykNv8TAI2LYHBp/Z1H4xoIYTiMupa+
         1/XIH3P8d4a+edwwXU1OuPpmwjb1j2UMpV1/zgK6QhEZZl4SaXKIV8bxJYZkTdVrm4
         zRC5V6coW1VE4xrK0ET24wcAdhNDNAxO8WZdFZ+Y=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 36OGjMSq119754
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Jul 2023 11:45:22 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 24
 Jul 2023 11:45:21 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 24 Jul 2023 11:45:21 -0500
Received: from localhost (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 36OGjMwE102315;
        Mon, 24 Jul 2023 11:45:22 -0500
Date:   Mon, 24 Jul 2023 11:45:21 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Kamlesh Gurudasani <kamlesh@ti.com>
CC:     Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Jayesh Choudhary <j-choudhary@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Tero Kristo" <t-kristo@ti.com>, Keerthy <j-keerthy@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, <linux-crypto@vger.kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v5 1/2] dt-bindings: crypto: ti,sa2ul: make power-domains
 conditional
Message-ID: <20230724164521.tkyxpivqtsf222hb@litigator>
References: <20230614-sa3ul-v5-0-29dd2366fba3@ti.com>
 <20230614-sa3ul-v5-1-29dd2366fba3@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230614-sa3ul-v5-1-29dd2366fba3@ti.com>
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 14:42-20230714, Kamlesh Gurudasani wrote:
> Devices specific to compatible ti,am62-sa3ul don't have control over
> power of SA3UL from main domain.
> 
> "power-domains" property in crypto node tries to access
> the SA3UL power, for which it gets NACK and hence, driver doesn't
> probe properly for those particular devices.
> 
> Make "power-domains" property as false for devices with
> compatible ti,am62-sa3ul.
> 
> Fixes: 2ce9a7299bf6 ("dt-bindings: crypto: Add TI SA2UL crypto accelerator documentation")
> 
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
> ---
>  Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)

Herbert, Do you see a problem if I pick this patch via TI SoC Tree?

if you are OK, I'd like to take the series to keep it clean.

> 
> diff --git a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> index 77ec8bc70bf7..f0ef7685550a 100644
> --- a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> +++ b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> @@ -66,10 +66,22 @@ patternProperties:
>  required:
>    - compatible
>    - reg
> -  - power-domains
>    - dmas
>    - dma-names
>  
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: ti,am62-sa3ul
> +    then:
> +      properties:
> +        power-domains: false
> +    else:
> +      required:
> +        - power-domains
> +
>  additionalProperties: false
>  
>  examples:
> 
> -- 
> 2.34.1
> 

-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D
