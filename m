Return-Path: <SRS0=XejO=AL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47171C433E3
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 08:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E29F20768
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 08:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="QWp9ecbb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgF3IRp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jun 2020 04:17:45 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37408 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730670AbgF3IRo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jun 2020 04:17:44 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05U8HXRo026612;
        Tue, 30 Jun 2020 03:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593505053;
        bh=Spv34iQAAk9h2dQw9IPu8D4gjaGC8Jo5AskMOaNSqGU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=QWp9ecbbeUL6hLsLtWiOIVVagRGWsTQK1xl/kZ6doNCP2tjy/dMDdNt+jYwC/w/pB
         lT0GTDsSZ1vhSNtj8WWN0S5R63t3dQWyQj2K43smv60D+4gYSd1FzpK5s/PbRETu7U
         0mgHcD6bOjD7wHNKqjY0klXQq3AqMf7LHzx8gaF4=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05U8HXX3032106;
        Tue, 30 Jun 2020 03:17:33 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 30
 Jun 2020 03:17:33 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 30 Jun 2020 03:17:33 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05U8HUIb007295;
        Tue, 30 Jun 2020 03:17:31 -0500
Subject: Re: [PATCHv4 3/7] crypto: sa2ul: add sha1/sha256/sha512 support
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <j-keerthy@ti.com>
References: <20200615071452.25141-1-t-kristo@ti.com>
 <20200615071452.25141-4-t-kristo@ti.com>
 <20200626043155.GA2683@gondor.apana.org.au>
 <2a89ea86-3b9e-06b5-fa8e-9dc6e5ad9aeb@ti.com>
 <20200630044936.GA22565@gondor.apana.org.au>
 <b8c209cd-2b5d-54e4-9b64-94e5d1f0e60c@ti.com>
 <20200630074645.GA2449@gondor.apana.org.au>
 <ea76dad4-a29d-d211-edee-52f3699c8ab7@ti.com>
 <20200630075435.GA3885@gondor.apana.org.au>
 <0a07585c-af4a-f08b-af5a-232cb4c351d4@ti.com>
 <20200630075951.GA3977@gondor.apana.org.au>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <17db9cc3-26a0-bb90-4b35-f675fecb640f@ti.com>
Date:   Tue, 30 Jun 2020 11:17:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200630075951.GA3977@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 30/06/2020 10:59, Herbert Xu wrote:
> On Tue, Jun 30, 2020 at 10:58:28AM +0300, Tero Kristo wrote:
>>
>> Openssl uses init->update->final sequencing, and it would be nice to have
>> this use crypto accelerator. Otherwise we basically support cipher
>> acceleration from openssl, but not hashing.
> 
> You're referring to algif_hash, right? If so it'd be much easier
> to implement the buffering in user-space.

algif_hash / cryptodev can both be used via openssl, but I think both of 
them have the same limitation, yeah.

Anyways, sounds like you prefer dropping any hacks towards this from the 
kernel driver, so I'll just do that and consider patching the upper 
layers for openssl maybe...

-Tero
--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
