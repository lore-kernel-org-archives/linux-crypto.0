Return-Path: <SRS0=YLdW=YV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DD4CA9EBC
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 10:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FCD020873
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 10:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388140AbfJ1KIG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Oct 2019 06:08:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40506 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730905AbfJ1KIG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Oct 2019 06:08:06 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9SA7ug5041295
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2019 06:08:05 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vwujn555d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2019 06:08:02 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Mon, 28 Oct 2019 10:07:31 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 28 Oct 2019 10:07:28 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9SA7R4Z22872108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 10:07:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D520842045;
        Mon, 28 Oct 2019 10:07:27 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E43842041;
        Mon, 28 Oct 2019 10:07:27 +0000 (GMT)
Received: from [10.0.2.15] (unknown [9.145.187.76])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Oct 2019 10:07:27 +0000 (GMT)
Subject: Re: [PATCH] s390/crypto: Rework on paes implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-crypto@vger.kernel.org, ifranzki@linux.ibm.com,
        ebiggers@kernel.org
References: <20191028082433.qdaabj2imf34ikam@gondor.apana.org.au>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Mon, 28 Oct 2019 11:07:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028082433.qdaabj2imf34ikam@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19102810-4275-0000-0000-0000037860C5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102810-4276-0000-0000-0000388B92C1
Message-Id: <17eda70d-d1fc-8b9d-ffb3-48b3c8f5799b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-28_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910280102
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 28.10.19 09:24, Herbert Xu wrote:
> Harald Freudenberger <freude@linux.ibm.com> wrote:
>> @@ -165,18 +183,31 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
>>        struct skcipher_walk walk;
>>        unsigned int nbytes, n, k;
>>        int ret;
>> +       struct {
>> +               u8 key[MAXPROTKEYSIZE];
>> +       } param;
>>
>>        ret = skcipher_walk_virt(&walk, req, false);
>> +       if (ret)
>> +               return ret;
>> +
>> +       spin_lock(&ctx->pk_lock);
>> +       memcpy(param.key, ctx->pk.protkey, MAXPROTKEYSIZE);
>> +       spin_unlock(&ctx->pk_lock);
> I think using a plain spin lock is unsafe as you may have callers
> from both kernel thread context and BH context.  So you need to
> have at least a spin_lock_bh here.
>
> Cheers,

Thanks, I'll change this.

