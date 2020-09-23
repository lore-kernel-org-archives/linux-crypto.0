Return-Path: <SRS0=nWKA=DA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940E5C4363D
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Sep 2020 07:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5839021924
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Sep 2020 07:48:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="R3WgXrzt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgIWHsq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:48:46 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:41566 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWHsq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Sep 2020 03:48:46 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08N7mSsg026360;
        Wed, 23 Sep 2020 02:48:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600847308;
        bh=afG1zb8/qo7zi+dRFTM5g5y8HdIti04MRIPZVdV66zY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=R3WgXrztIVv8HrOVC1at0IvGcTE9vAI/ypuYpsPzjGMAmSDTbYed3Sw7sI/reg3so
         vALbjfHiHtGAzWeBTDt8yfkkJDenVJmBpHSywckGqADHMEVBu1qnNKbgPMgl5s3gnx
         rcxfv2KaE5Ysuy2zLXaLawFRXt6LSoBgXVS/2Vro=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08N7mR5r112799
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 02:48:27 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 23
 Sep 2020 02:48:27 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 23 Sep 2020 02:48:27 -0500
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08N7mPUG089691;
        Wed, 23 Sep 2020 02:48:26 -0500
Subject: Re: [PATCH] crypto: sa2ul: Fix DMA mapping API usage
To:     Christoph Hellwig <hch@infradead.org>
CC:     <herbert@gondor.apana.org.au>, <t-kristo@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <j-keerthy@ti.com>
References: <20200921113846.6973-1-peter.ujfalusi@ti.com>
 <20200923060246.GA11550@infradead.org>
From:   Peter Ujfalusi <peter.ujfalusi@ti.com>
X-Pep-Version: 2.0
Message-ID: <593d5f9d-0629-f01d-4c67-112fc088bb4b@ti.com>
Date:   Wed, 23 Sep 2020 10:48:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200923060246.GA11550@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 23/09/2020 9.02, Christoph Hellwig wrote:
> On Mon, Sep 21, 2020 at 02:38:46PM +0300, Peter Ujfalusi wrote:
>> Make sure that we call the dma_unmap_sg on the correct scatterlist on
>> completion with the correct sg_nents.
>>
>> We also should be calling dma_sync_sg_for_device() on the tx buffer be=
fore
>> giving it to the DMA and the dma_sync_sg_for_cpu() should be called on=
 the
>> scatterlist we received the data back.
>=20
> You might want to look into using struct sg_table and the DMA mapping
> helpers using it to simplify this a bit.

It would have simplified it a bit further if the dma_map_sgtable() would
have saved the dir we used when mapping (and then dma_unmap_sgtable()
would use the stored dir) and had a bool to tell that the mapping was
successful.

I'll send v2 with the use of sg_table in a bit after running some tests
to make sure it is working as expected. It is passing the extended boot
time tests on j721e.

- P=C3=A9ter

Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

