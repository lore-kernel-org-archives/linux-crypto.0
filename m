Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E34FC31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 10:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BE83207E0
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 10:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732115AbfFLKac (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 06:30:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732073AbfFLKac (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 06:30:32 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CARIvq017644
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 06:30:30 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t2xncu3g7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 06:30:30 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Wed, 12 Jun 2019 11:30:28 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 11:30:25 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CAUNnp56688640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 10:30:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3AEF4204C;
        Wed, 12 Jun 2019 10:30:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3150A42049;
        Wed, 12 Jun 2019 10:30:23 +0000 (GMT)
Received: from [10.0.2.15] (unknown [9.145.62.239])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jun 2019 10:30:23 +0000 (GMT)
Subject: Re: [PATCH v2 4/4] s390/crypto: sha: Use -ENODEV instead of
 -EOPNOTSUPP
To:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20190612102248.18903-1-david@redhat.com>
 <20190612102248.18903-5-david@redhat.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Wed, 12 Jun 2019 12:30:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190612102248.18903-5-david@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19061210-4275-0000-0000-00000341A1A7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061210-4276-0000-0000-00003851B787
Message-Id: <10b7259b-3c73-1c87-6ccd-914da9c796dd@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120073
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12.06.19 12:22, David Hildenbrand wrote:
> Let's use the error value that is typically used if HW support is not
> available when trying to load a module - this is also what systemd's
> systemd-modules-load.service expects.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/crypto/sha1_s390.c   | 2 +-
>  arch/s390/crypto/sha256_s390.c | 2 +-
>  arch/s390/crypto/sha512_s390.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
> index 009572e8276d..7c15542d3685 100644
> --- a/arch/s390/crypto/sha1_s390.c
> +++ b/arch/s390/crypto/sha1_s390.c
> @@ -86,7 +86,7 @@ static struct shash_alg alg = {
>  static int __init sha1_s390_init(void)
>  {
>  	if (!cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA_1))
> -		return -EOPNOTSUPP;
> +		return -ENODEV;
>  	return crypto_register_shash(&alg);
>  }
>  
> diff --git a/arch/s390/crypto/sha256_s390.c b/arch/s390/crypto/sha256_s390.c
> index 62833a1d8724..af7505148f80 100644
> --- a/arch/s390/crypto/sha256_s390.c
> +++ b/arch/s390/crypto/sha256_s390.c
> @@ -117,7 +117,7 @@ static int __init sha256_s390_init(void)
>  	int ret;
>  
>  	if (!cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA_256))
> -		return -EOPNOTSUPP;
> +		return -ENODEV;
>  	ret = crypto_register_shash(&sha256_alg);
>  	if (ret < 0)
>  		goto out;
> diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
> index be589c340d15..ad29db085a18 100644
> --- a/arch/s390/crypto/sha512_s390.c
> +++ b/arch/s390/crypto/sha512_s390.c
> @@ -127,7 +127,7 @@ static int __init init(void)
>  	int ret;
>  
>  	if (!cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA_512))
> -		return -EOPNOTSUPP;
> +		return -ENODEV;
>  	if ((ret = crypto_register_shash(&sha512_alg)) < 0)
>  		goto out;
>  	if ((ret = crypto_register_shash(&sha384_alg)) < 0)
fine with me
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>

