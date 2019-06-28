Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BE3C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8109C2133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:27:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="QaDAF8j7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfF1F1N (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 01:27:13 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36852 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfF1F1N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 01:27:13 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5S5R6oB118599;
        Fri, 28 Jun 2019 00:27:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561699626;
        bh=v0WcvKhwBQFtUMJMsq4+vIFQxzwxel+wYQa/dpCCq90=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=QaDAF8j7OAbedgraNDWGF6dM0JqP56fk7lYR949dQfK1vL/2LtSwWXoRor7BuYW2F
         EkEnQU3PkVENZ05YhKmtg7k500BDqiAx1tNgaXq4yHCBk9p4V7BQHT0VyL7leg1wt7
         Pjc6x9zSYU4FqWuxk1jKWXoQJpCSbDZS3ophT2aY=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5S5R6gp017910
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Jun 2019 00:27:06 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 28
 Jun 2019 00:27:05 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 28 Jun 2019 00:27:05 -0500
Received: from [172.24.191.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5S5R2XE031643;
        Fri, 28 Jun 2019 00:27:03 -0500
Subject: Re: [RESEND PATCH 05/10] crypto: sha256_generic: Export the Transform
 function
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <t-kristo@ti.com>,
        <linux-crypto@vger.kernel.org>, <nm@ti.com>
References: <20190628042745.28455-1-j-keerthy@ti.com>
 <20190628042745.28455-6-j-keerthy@ti.com>
 <20190628050944.GE673@sol.localdomain>
From:   Keerthy <j-keerthy@ti.com>
Message-ID: <7ddfdddc-38ba-a435-f688-4d0e29c0513c@ti.com>
Date:   Fri, 28 Jun 2019 10:57:39 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190628050944.GE673@sol.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 28/06/19 10:39 AM, Eric Biggers wrote:
> On Fri, Jun 28, 2019 at 09:57:40AM +0530, Keerthy wrote:
>> The transform function can be used as is by other crypto
>> drivers that need to transform the 256 bit key using cpu.
>> Hence export it.
> 
> What is this supposed to mean?  SHA-256 is an unkeyed hash function.

HMAC-SHA256 my bad.

> 
> Also, you need to actually explain why this is needed.  If your hardware
> supports SHA-256, why do you need to use the C sha256_transform()?

Hardware supports only HMAC from pre-computed inner and outer digests is 
supported, i.e. the host must carry out initial preparation stage to
generate intermediate hash state for both inner pad and outer pad.

Hence the need to export the transform function. I will add it in the 
commit message.

> 
> - Eric
> 
