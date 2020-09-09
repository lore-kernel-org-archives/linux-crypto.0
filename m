Return-Path: <SRS0=sZ2L=CS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52303C43461
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 07:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC66F21973
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 07:27:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="bEs2+N5/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgIIH1X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Sep 2020 03:27:23 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:41980 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbgIIH1V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Sep 2020 03:27:21 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0897RBah103472;
        Wed, 9 Sep 2020 02:27:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599636431;
        bh=CP77hOSCh/XJSIWu/JAdp6XYqnTek2ZtYkKUqWwTEpQ=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=bEs2+N5/opqv/F26O50NMeIDlmQfsG4IRDMZUOCuNz6oSki8Lv6iIBev7IWXndJ5D
         mb3VX4f846dapOpTG8REJVamX3aNnzYj8xCH854AlYik+hK+WQ5EH1pHnboyqrpIYx
         THxuQ80rfqisZL7cBjkkENXm0E4EiJH22N++EBXo=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0897RBG1064784;
        Wed, 9 Sep 2020 02:27:11 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 9 Sep
 2020 02:27:10 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 9 Sep 2020 02:27:11 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0897R8E9067872;
        Wed, 9 Sep 2020 02:27:09 -0500
Subject: Re: [PATCH 1/1] dt-bindings: rng: Convert OMAP RNG to schema
From:   Tero Kristo <t-kristo@ti.com>
To:     Rob Herring <robh@kernel.org>
CC:     <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <robh+dt@kernel.org>
References: <20200514131947.28094-1-t-kristo@ti.com>
 <20200528152750.GA108124@bogus> <537a8759-264c-f366-7fb1-398ff21c9a65@ti.com>
Message-ID: <e7182d47-3bec-3c51-9fde-faa5a150d5bf@ti.com>
Date:   Wed, 9 Sep 2020 10:27:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <537a8759-264c-f366-7fb1-398ff21c9a65@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 28/05/2020 19:54, Tero Kristo wrote:
> On 28/05/2020 18:27, Rob Herring wrote:
>> On Thu, 14 May 2020 16:19:47 +0300, Tero Kristo wrote:
>>> Convert TI OMAP Random number generator bindings to DT schema.
>>>
>>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>>> ---
>>>   .../devicetree/bindings/rng/omap_rng.txt      | 38 ---------
>>>   .../devicetree/bindings/rng/ti,omap-rng.yaml  | 77 +++++++++++++++++++
>>>   2 files changed, 77 insertions(+), 38 deletions(-)
>>>   delete mode 100644 Documentation/devicetree/bindings/rng/omap_rng.txt
>>>   create mode 100644 
>>> Documentation/devicetree/bindings/rng/ti,omap-rng.yaml
>>>
>>
>> Reviewed-by: Rob Herring <robh@kernel.org>
> 
> Thanks Rob. Just a quick question, who is going to merge this seeing it 
> is a standalone dt binding conversion to yaml?

Ping on this, it appears to have gone stale.

Who is going to pick this up?

-Tero
--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
