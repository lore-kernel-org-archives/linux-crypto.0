Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A213EC432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 13:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74B0F20730
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 13:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfKVNik (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 08:38:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726526AbfKVNij (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 08:38:39 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAMDaYxT065352
        for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2019 08:38:38 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wdkdftbfu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2019 08:38:38 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Fri, 22 Nov 2019 13:38:36 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 22 Nov 2019 13:38:32 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAMDcVoE46334196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 13:38:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E03E34204F;
        Fri, 22 Nov 2019 13:38:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 641EC4204B;
        Fri, 22 Nov 2019 13:38:31 +0000 (GMT)
Received: from funtu.home (unknown [9.145.67.101])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Nov 2019 13:38:31 +0000 (GMT)
Subject: Re: [PATCH 2/3] s390/crypto: Rework on paes implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <20191113105523.8007-1-freude@linux.ibm.com>
 <20191113105523.8007-3-freude@linux.ibm.com>
 <20191122081338.6bdjevtyttpdzzwl@gondor.apana.org.au>
 <87e9dbee-4024-602c-7717-051df3ac644d@linux.ibm.com>
 <20191122104259.ofodwadrgszdxuto@gondor.apana.org.au>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Fri, 22 Nov 2019 14:38:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122104259.ofodwadrgszdxuto@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19112213-0016-0000-0000-000002CAD04D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112213-0017-0000-0000-0000332C9B50
Message-Id: <bd21bf85-7bfc-afd6-270b-272bd0fa553a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-22_02:2019-11-21,2019-11-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 adultscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911220121
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22.11.19 11:42, Herbert Xu wrote:
> On Fri, Nov 22, 2019 at 10:54:50AM +0100, Harald Freudenberger wrote:
>> The setkey() sets the base key material (usually a secure key) to an
>> tfm instance. From this key a 'protected key' (pkey) is derived which
>> may get invalid at any time and may need to get re-derived from the
>> base key material.
>> An tfm instance may be shared, so the context where the pkey is
>> stored into is also shared. So when a pkey gets invalid there is a need
>> to update the pkey value within the context struct. This update needs
>> to be done atomic as another thread may concurrently use this pkey
>> value. That's all what this spinlock does. Make sure read and write
>> operations on the pkey within the context are atomic.
>> It is still possible that two threads copy the pkey, try to use it, find out
>> that it is invalid and needs refresh, re-derive and both update the pkey
>> memory serialized by the spinlock. But this is no issue. The spinlock
>> makes sure the stored pkey is always a consistent pkey (which may
>> be valid or invalid but not corrupted).
> OK.  Can you give me a bit more background info on how often
> this is likely to happen? I mean it happened every time you
> might as well not store the protected key in the tfm at all.
>
> Thanks,
The pkey is in fact a encrypted key + a verification pattern for the
encrypted key used. It gets invalid when this encryption key changes.
The encryption key changes when the LPAR is re-activated so for
example on suspend/resume or an Linux running as kvm guest
gets relocated. So this happens very rarely.

