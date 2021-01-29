Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7D0C433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 02:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 665AE64DFF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 02:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhA2CvA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jan 2021 21:51:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229757AbhA2Cu4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jan 2021 21:50:56 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10T2VjZ3120063;
        Thu, 28 Jan 2021 21:49:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=69jgmI456LMad55ViwPn+Ce+GYZyX9L+dnAT6tgjjYs=;
 b=pGdpp/rv+jvqN/brFha1WXDOArJpYS2ro0WxMx9fsQJnQH9TRbGfiI9T4zZg64cPU4b+
 1ia6RaHpF/moIDyZ4++JBI+tzXmUWwCpO4ezWsQCFCV/7Si2I8655+jUSDkY5kA/3GxZ
 EmB8uU0Lyvl+OoZ6bcs9a8UZ8fH2lBl1SddnYXif9ewk9PDr7eRw2tX9OX6VSTQpDd1c
 W7LpEg0+KWqFL2pFnyvnqLLKzpIEBpStLyR/nymuJR9zSpcA0Lo/ZfmK5985DTr2Csbn
 bT5VywmHKl6nvxGpWRElb6nOLePXuQ4bRVQmH92Gvz8F7O8vjbjrXkEhAsN6Wp2bDMLR Ng== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36c6kbcaf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 21:49:43 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10T2gtcZ010132;
        Fri, 29 Jan 2021 02:49:42 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 36a3qc95gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jan 2021 02:49:42 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10T2nglA22413626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 02:49:42 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C156AC060;
        Fri, 29 Jan 2021 02:49:42 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBD20AC05F;
        Fri, 29 Jan 2021 02:49:41 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 29 Jan 2021 02:49:41 +0000 (GMT)
Subject: Re: [PATCH v7 4/7] crypto: add ecc curve and expose them
To:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Meng Yu <yumeng18@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Zaibo Xu <xuzaibo@huawei.com>, wangzhou1@hisilicon.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        Patrick Uiterwijk <patrick@puiterwijk.org>
References: <1611299395-675-1-git-send-email-yumeng18@huawei.com>
 <1611299395-675-5-git-send-email-yumeng18@huawei.com>
 <20210128050354.GA30874@gondor.apana.org.au>
 <CAMj1kXHvY9JveFyhtETALCH=AFGMGVbGGFMNDGc6ZVngEKbyDQ@mail.gmail.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
Message-ID: <ff63fffd-2d65-337f-d802-adcf4352fdc3@linux.ibm.com>
Date:   Thu, 28 Jan 2021 21:49:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXHvY9JveFyhtETALCH=AFGMGVbGGFMNDGc6ZVngEKbyDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_12:2021-01-28,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 clxscore=1011
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101290008
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/28/21 5:30 AM, Ard Biesheuvel wrote:
> On Thu, 28 Jan 2021 at 06:04, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Fri, Jan 22, 2021 at 03:09:52PM +0800, Meng Yu wrote:
>>> 1. Add ecc curves(P224, P384, P521) for ECDH;
>> OK I think this is getting unwieldy.
>>
>> In light of the fact that we already have hardware that supports
>> a specific subset of curves, I think perhaps it would be better
>> to move the curve ID from the key into the algorithm name instead.
>>
>> IOW, instead of allocating ecdh, you would allocate ecdh-nist-pXXX.
>>
>> Any comments?
>>
> Agreed. Bluetooth appears to be the only in-kernel user at the moment,
> and it is hard coded to use p256, so it can be easily updated.
>
> But this also begs the question which ecdh-nist-pXXX implementations
> we actually need? Why are we exposing these curves in the first place?

In the patch series that I just submitted I would like to expose at 
least NIST p256 to users. Fedora 34 is working to add signatures for 
files to rpms for the Integrity Measurment Architecture (IMA) to be able 
to enforce signatures on executables, libraries etc. The signatures are 
written out into security.ima extended attribute upon rpm installation. 
IMA accesses keys on a keyring to verify these file signatures. RSA 
signatures are much larger, so elliptic curve signatures are much better 
in terms of storage size needed for storing them in rpms. They add like 
1% of size. Fedora is using a NIST P256 key.

Besides that Fedora and RHEL support only these curves here in openssl 
(Ubuntu supports a lot more):

$ openssl ecparam -list_curves
   secp224r1 : NIST/SECG curve over a 224 bit prime field
   secp256k1 : SECG curve over a 256 bit prime field
   secp384r1 : NIST/SECG curve over a 384 bit prime field
   secp521r1 : NIST/SECG curve over a 521 bit prime field
   prime256v1: X9.62/SECG curve over a 256 bit prime field

So from that perspective it makes a lot of sense to support some of 
these and allow users to load them into the kernel.


In my patch series I initially had registered the akciphers under the 
names ecc-nist-p192 and ecc-nist-p256 but now, in V4, joined them 
together as 'ecdsa'. This may be too generic for a name. Maybe it should 
be called ecsda-nist for the NIST family.

    Stefan

