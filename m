Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E3AC04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 08:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D552127D04
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 08:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfFCIAD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 04:00:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725856AbfFCIAD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 04:00:03 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x537vSKo139405
        for <linux-crypto@vger.kernel.org>; Mon, 3 Jun 2019 04:00:01 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2svvpeec88-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 03 Jun 2019 04:00:01 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Mon, 3 Jun 2019 08:59:59 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 08:59:55 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x537xsA146989420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 07:59:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CEC342045;
        Mon,  3 Jun 2019 07:59:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 870E642042;
        Mon,  3 Jun 2019 07:59:53 +0000 (GMT)
Received: from [10.0.2.15] (unknown [9.152.224.114])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 07:59:53 +0000 (GMT)
Subject: Re: [RFC PATCH 1/2] crypto: Allow working with key references
To:     Richard Weinberger <richard@nod.at>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-imx@nxp.com,
        festevam@gmail.com, kernel <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, shawnguo@kernel.org,
        davem@davemloft.net, david <david@sigma-star.at>
References: <20190529224844.25203-1-richard@nod.at>
 <20190530023357.2mrjtslnka4i6dbl@gondor.apana.org.au>
 <2084969721.73871.1559201016164.JavaMail.zimbra@nod.at>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Mon, 3 Jun 2019 09:59:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <2084969721.73871.1559201016164.JavaMail.zimbra@nod.at>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19060307-0016-0000-0000-000002830744
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060307-0017-0000-0000-000032E00F2A
Message-Id: <14ffcdf2-ed9f-be07-fde5-62dfb1fce4f9@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030059
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 30.05.19 09:23, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
>> Von: "Herbert Xu" <herbert@gondor.apana.org.au>
>> An: "richard" <richard@nod.at>
>> CC: "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, "linux-kernel"
>> <linux-kernel@vger.kernel.org>, linux-imx@nxp.com, festevam@gmail.com, "kernel" <kernel@pengutronix.de>, "Sascha Hauer"
>> <s.hauer@pengutronix.de>, shawnguo@kernel.org, davem@davemloft.net, "david" <david@sigma-star.at>
>> Gesendet: Donnerstag, 30. Mai 2019 04:33:57
>> Betreff: Re: [RFC PATCH 1/2] crypto: Allow working with key references
>> On Thu, May 30, 2019 at 12:48:43AM +0200, Richard Weinberger wrote:
>>> Some crypto accelerators allow working with secure or hidden keys.
>>> This keys are not exposed to Linux nor main memory. To use them
>>> for a crypto operation they are referenced with a device specific id.
>>>
>>> This patch adds a new flag, CRYPTO_TFM_REQ_REF_KEY.
>>> If this flag is set, crypto drivers should tread the key as
>>> specified via setkey as reference and not as regular key.
>>> Since we reuse the key data structure such a reference is limited
>>> by the key size of the chiper and is chip specific.
>>>
>>> TODO: If the cipher implementation or the driver does not
>>> support reference keys, we need a way to detect this an fail
>>> upon setkey.
>>> How should the driver indicate that it supports this feature?
>>>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> We already have existing drivers doing this.  Please have a look
>> at how they're doing it and use the same paradigm.  You can grep
>> for paes under drivers/crypto.
> Thanks for the pointer.
> So the preferred way is defining a new crypto algorithm prefixed with
> "p" and reusing setkey to provide the key reference.
The "p" in paes is because we call it "protected key aes". I think you are not limited
to the "p". What Herbert tries to point out is that you may define your own
cipher with an unique name and there you can handle your secure key references
as you like. You may use the s390 paes implementation as a starting point.

regards Harald Freudenberger <freude@linux.ibm.com>

>
> Thanks,
> //richard
>

