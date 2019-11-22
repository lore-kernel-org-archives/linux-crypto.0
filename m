Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE2DC432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 09:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF34E20674
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 09:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfKVJLi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 04:11:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28582 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726698AbfKVJLi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 04:11:38 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAM96dbE145852
        for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2019 04:11:37 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wdqn0ggcb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2019 04:11:36 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Fri, 22 Nov 2019 09:11:34 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 22 Nov 2019 09:11:31 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAM9BUMC50004060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 09:11:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E4AA4204B;
        Fri, 22 Nov 2019 09:11:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14D3042042;
        Fri, 22 Nov 2019 09:11:30 +0000 (GMT)
Received: from funtu.home (unknown [9.145.67.101])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Nov 2019 09:11:29 +0000 (GMT)
Subject: Re: [PATCH 3/3] crypto/testmgr: add selftests for paes-s390
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <20191113105523.8007-1-freude@linux.ibm.com>
 <20191113105523.8007-4-freude@linux.ibm.com>
 <20191122081611.vznhvhouim6hnehc@gondor.apana.org.au>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Fri, 22 Nov 2019 10:11:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122081611.vznhvhouim6hnehc@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19112209-0012-0000-0000-0000036AB001
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112209-0013-0000-0000-000021A64777
Message-Id: <88154ccf-84e8-17d1-1917-b8deeff20311@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-22_01:2019-11-21,2019-11-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911220081
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22.11.19 09:16, Herbert Xu wrote:
> On Wed, Nov 13, 2019 at 11:55:23AM +0100, Harald Freudenberger wrote:
>> This patch adds selftests for the s390 specific protected key
>> AES (PAES) cipher implementations:
>>   * cbc-paes-s390
>>   * ctr-paes-s390
>>   * ecb-paes-s390
>>   * xts-paes-s390
>> PAES is an AES cipher but with encrypted ('protected') key
>> material. So here come ordinary AES enciphered data values
>> but with a special key format understood by the PAES
>> implementation.
>>
>> The testdata definitons and testlist entries are surrounded
>> by #if IS_ENABLED(CONFIG_CRYPTO_PAES_S390) because they don't
>> make any sense on non s390 platforms or without the PAES
>> cipher implementation.
>>
>> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
>> ---
>>  crypto/testmgr.c |  36 +++++
>>  crypto/testmgr.h | 334 +++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 370 insertions(+)
> So with your cleartext work, I gather that you can now supply
> arbitrary keys to paes? If so my preferred method of testing it
> would be to add a paes-specific tester function that massaged the
> existing aes vectors into the format required by paes so you
> get exactly the same testing coverage as plain aes.
>
> Is this possible?
>
> Thanks,
Thanks for your feedback.
I thought about this too. But it would require to implement own versions of
alg_test_skcipher() and test_skcipher() and test_skcipher_vs_generic_impl()
and that's a lot of complicated code unique for paes within testmgr.c
I'd like to avoid.

