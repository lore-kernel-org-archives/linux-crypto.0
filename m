Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7B5C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 710182070D
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:32:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="fclmMIxv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfF1Fc2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 01:32:28 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37322 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbfF1Fc1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 01:32:27 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5S5WKQt119603;
        Fri, 28 Jun 2019 00:32:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561699940;
        bh=h92I/2p+B5C3Ff3S7snyU0440xu5YdLHz5GbmropL3s=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=fclmMIxvC8aIKPboY9hX+Q5R6I6J94FfDTTd+r5+hzYt/6/mAN08rpsocoG6hI0Ow
         f39I+A3U3ZeYPSpaERX6qUP627HjBycFZTUFeFAoz96oIlYwXFI8aT4USDCtJADilu
         054yE3b7+8pzvw3PVOo+a2jHvNZO61bs0FRhjBOg=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5S5WKx4112638
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Jun 2019 00:32:20 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 28
 Jun 2019 00:32:20 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 28 Jun 2019 00:32:20 -0500
Received: from [172.24.191.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5S5WHUI106748;
        Fri, 28 Jun 2019 00:32:17 -0500
Subject: Re: [RESEND PATCH 07/10] crypto: sa2ul: Add hmac(sha1) HMAC algorithm
 support
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <t-kristo@ti.com>,
        <linux-crypto@vger.kernel.org>, <nm@ti.com>
References: <20190628042745.28455-1-j-keerthy@ti.com>
 <20190628042745.28455-8-j-keerthy@ti.com>
 <20190628051412.GG673@sol.localdomain>
From:   Keerthy <j-keerthy@ti.com>
Message-ID: <2152c811-1fad-004a-01a7-969a1ded36ad@ti.com>
Date:   Fri, 28 Jun 2019 11:02:54 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190628051412.GG673@sol.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 28/06/19 10:44 AM, Eric Biggers wrote:
> On Fri, Jun 28, 2019 at 09:57:42AM +0530, Keerthy wrote:
>> +static int sa_sham_update(struct ahash_request *req)
>> +{
>> +	return -ENOTSUPP;
>> +}
>> +
>> +static int sa_sham_final(struct ahash_request *req)
>> +{
>> +	return sa_sham_digest(req);
>> +}
>> +
>> +static int sa_sham_finup(struct ahash_request *req)
>> +{
>> +	return sa_sham_digest(req);
>> +}
> 
> You can't just not support update().  You need to support update().

Okay. I will add that.

> 
> - Eric
> 
