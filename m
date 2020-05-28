Return-Path: <SRS0=ep2G=7K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919AEC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 16:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B256207D3
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 16:55:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="K075Dd2H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405232AbgE1QzH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 May 2020 12:55:07 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:46286 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405230AbgE1QzF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 May 2020 12:55:05 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04SGsrDZ048177;
        Thu, 28 May 2020 11:54:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590684893;
        bh=unVLwfpdpfsOZpPn3ncbOetWW3k2TEuPArJ3vUQ6OYw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=K075Dd2HjKkm+8V/kGvhPwfqW58Xvi/UBkj/HHDFYV5sRBm5i4w/GFE6l9+R6USMz
         3VlIFfTvE47rzg7SK/Eb8i27MmOLaYClLacKRTGA+E2/yHiabSeanqs28+K4hOcVKL
         RZtN/reSLjzhMS2cNgzQRlHplBA9F1hckAxkYCZg=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04SGsrUn111184
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 28 May 2020 11:54:53 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 28
 May 2020 11:54:52 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 28 May 2020 11:54:53 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04SGspGk130355;
        Thu, 28 May 2020 11:54:51 -0500
Subject: Re: [PATCH 1/1] dt-bindings: rng: Convert OMAP RNG to schema
To:     Rob Herring <robh@kernel.org>
CC:     <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <robh+dt@kernel.org>
References: <20200514131947.28094-1-t-kristo@ti.com>
 <20200528152750.GA108124@bogus>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <537a8759-264c-f366-7fb1-398ff21c9a65@ti.com>
Date:   Thu, 28 May 2020 19:54:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528152750.GA108124@bogus>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 28/05/2020 18:27, Rob Herring wrote:
> On Thu, 14 May 2020 16:19:47 +0300, Tero Kristo wrote:
>> Convert TI OMAP Random number generator bindings to DT schema.
>>
>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>> ---
>>   .../devicetree/bindings/rng/omap_rng.txt      | 38 ---------
>>   .../devicetree/bindings/rng/ti,omap-rng.yaml  | 77 +++++++++++++++++++
>>   2 files changed, 77 insertions(+), 38 deletions(-)
>>   delete mode 100644 Documentation/devicetree/bindings/rng/omap_rng.txt
>>   create mode 100644 Documentation/devicetree/bindings/rng/ti,omap-rng.yaml
>>
> 
> Reviewed-by: Rob Herring <robh@kernel.org>

Thanks Rob. Just a quick question, who is going to merge this seeing it 
is a standalone dt binding conversion to yaml?

-Tero

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
