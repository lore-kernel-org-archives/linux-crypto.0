Return-Path: <SRS0=zQvQ=7I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8439BC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 12:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 608D7204EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 12:57:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="A5M/b9st"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgEZM5W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 May 2020 08:57:22 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:57358 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgEZM5W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 May 2020 08:57:22 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04QCvE4i082211;
        Tue, 26 May 2020 07:57:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590497834;
        bh=2cx/sAzoAf/dBqXz3OYdVMVhioZ7dZAv2Ao5lKFNVrc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=A5M/b9stiHIhPoul7XNRgVYqJ7IpKb5wgo06G4/i5iff+2e0yPPYgldpnGAjdiGhN
         XRYhEPFK3UGaExVFXuF8iqmSPcaHtRVItVqN9rb+flSmuRGMj/wg8rGxEagKiKEl01
         wiqfK49welc9uffl4DxcJb9ZyHkjTYJZ4OcozDas=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04QCvEqo092267
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 26 May 2020 07:57:14 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 26
 May 2020 07:57:14 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 26 May 2020 07:57:14 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04QCvAwC091638;
        Tue, 26 May 2020 07:57:12 -0500
Subject: Re: [PATCHv2 3/7] crypto: omap-crypto: fix userspace copied buffer
 access
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tejun Heo <tj@kernel.org>
References: <20200511111913.26541-1-t-kristo@ti.com>
 <20200511111913.26541-4-t-kristo@ti.com>
 <20200522131247.GA27255@gondor.apana.org.au>
 <24092385-1348-f55d-a637-6fb2b3129f4e@ti.com>
 <20200526123552.GA10897@gondor.apana.org.au>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <7fece128-ea82-06cb-23d3-d49c9f10c4a0@ti.com>
Date:   Tue, 26 May 2020 15:57:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200526123552.GA10897@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 26/05/2020 15:35, Herbert Xu wrote:
> On Tue, May 26, 2020 at 03:27:38PM +0300, Tero Kristo wrote:
>>
>> I think it would make sense to use that, however as I am just fixing an
>> existing bug here, would it be ok if I just fix your above comment and post
>> v3? I can convert this later to sg_miter and take a shot at moving this to
>> lib/scatterlist.c as that seems slightly bigger effort and I would not want
>> to block this whole series because of that...
> 
> Of course.  A minimal fix would be just fine.

Ok thanks, will post fixed version hopefully already today, just running 
some tests on it now.

Btw, any word on the TI sa2ul series I posted a while back? I see it has 
been marked as deferred in patchwork but I am not quite sure what that 
means... deferred until what? I have also been thinking of creating a 
drivers/crypto/ti subdir at some point, as there are quite a few files 
for TI accelerators already.

-Tero
--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
