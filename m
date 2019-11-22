Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB97C432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 14:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A2A620715
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 14:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfKVOpT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 09:45:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726100AbfKVOpT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 09:45:19 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAMEg9x2097797
        for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2019 09:45:18 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wefjwcnh7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2019 09:45:17 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Fri, 22 Nov 2019 14:45:15 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 22 Nov 2019 14:45:13 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAMEjCpf46858498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 14:45:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 671F742047;
        Fri, 22 Nov 2019 14:45:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AAEC4203F;
        Fri, 22 Nov 2019 14:45:12 +0000 (GMT)
Received: from funtu.home (unknown [9.145.67.101])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Nov 2019 14:45:11 +0000 (GMT)
Subject: Re: [PATCH 2/3] s390/crypto: Rework on paes implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <20191113105523.8007-1-freude@linux.ibm.com>
 <20191113105523.8007-3-freude@linux.ibm.com>
 <20191122081338.6bdjevtyttpdzzwl@gondor.apana.org.au>
 <87e9dbee-4024-602c-7717-051df3ac644d@linux.ibm.com>
 <20191122104259.ofodwadrgszdxuto@gondor.apana.org.au>
 <bd21bf85-7bfc-afd6-270b-272bd0fa553a@linux.ibm.com>
 <20191122140757.mbpnasimvnhke3k2@gondor.apana.org.au>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Fri, 22 Nov 2019 15:45:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122140757.mbpnasimvnhke3k2@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19112214-0028-0000-0000-000003BE118F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112214-0029-0000-0000-000024813E7A
Message-Id: <dbd99075-22d3-b41a-57c6-ba85168eab87@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-22_02:2019-11-21,2019-11-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911220132
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22.11.19 15:07, Herbert Xu wrote:
> On Fri, Nov 22, 2019 at 02:38:30PM +0100, Harald Freudenberger wrote:
>> The pkey is in fact a encrypted key + a verification pattern for the
>> encrypted key used. It gets invalid when this encryption key changes.
>> The encryption key changes when the LPAR is re-activated so for
>> example on suspend/resume or an Linux running as kvm guest
>> gets relocated. So this happens very rarely.
> I see.  Is there any way of you finding out that the key has been
> invalidated apart from trying out the crypto and having it fail?
No. By using the pkey for a crypto operation the hardware
checks the verification pattern and if there is a mismatch
it simple rejects the operation. Theoretically such an operation
can only partly complete and then a pkey could get invalid.
I have no way to check if the pkey is still valid before the
cpacf instruction call.
>
> Ideally you'd have a global counter that gets incremented everytime
> an invalidation occurs.  You can then regenerate your key if its
> generation counter differs from the current global counter.
>
> Also when the crypto fails due to an invalid key you're currently
> calling skcipher_walk_done with zero.  This is wrong as the done
> function must be called with a positive value or an error.  In
> some cases this can cause a crash in scatterwalk.
>
> IOW you should just repeat the crypto operation after regenerating
> the key rather than looping around again.
That's right. I'll try to rework the functions this way to
avoid calling skciper_walk_done with 0.

Thanks
>
> Cheers,

