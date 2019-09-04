Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3FAC3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 14:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0E5D22CED
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 14:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbfIDOVZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Sep 2019 10:21:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20820 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729993AbfIDOVZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Sep 2019 10:21:25 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x84EIKl4061190
        for <linux-crypto@vger.kernel.org>; Wed, 4 Sep 2019 10:21:24 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2utecx1jgj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 04 Sep 2019 10:21:24 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Wed, 4 Sep 2019 15:21:22 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 4 Sep 2019 15:21:19 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x84ELFhX31785176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Sep 2019 14:21:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5FB14204B;
        Wed,  4 Sep 2019 14:21:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01A0742041;
        Wed,  4 Sep 2019 14:21:15 +0000 (GMT)
Received: from [10.0.2.15] (unknown [9.152.224.114])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Sep 2019 14:21:14 +0000 (GMT)
Subject: Re: [PATCH cryptodev buildfix] crypto: s390/aes - fix typo in
 XTS_BLOCK_SIZE identifier
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Reinhard Buendgen <buendgen@de.ibm.com>
References: <20190822102454.4549-1-ard.biesheuvel@linaro.org>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Wed, 4 Sep 2019 16:21:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822102454.4549-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19090414-0020-0000-0000-00000367A7E2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090414-0021-0000-0000-000021BD1799
Message-Id: <8e480e5b-14d5-8ff1-0630-5a53b4646a1c@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-04_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909040141
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22.08.19 12:24, Ard Biesheuvel wrote:
> Fix a typo XTS_BLOCKSIZE -> XTS_BLOCK_SIZE, causing the build to
> break.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> Apologies for the sloppiness.
>
> Herbert, could we please merge this before cryptodev hits -next?
>
>  arch/s390/crypto/aes_s390.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
> index a34faadc757e..d4f6fd42a105 100644
> --- a/arch/s390/crypto/aes_s390.c
> +++ b/arch/s390/crypto/aes_s390.c
> @@ -586,7 +586,7 @@ static int xts_aes_encrypt(struct blkcipher_desc *desc,
>  	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
>  	struct blkcipher_walk walk;
>
> -	if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCKSIZE) != 0))
> +	if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCK_SIZE) != 0))
>  		return xts_fallback_encrypt(desc, dst, src, nbytes);
>
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
> @@ -600,7 +600,7 @@ static int xts_aes_decrypt(struct blkcipher_desc *desc,
>  	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
>  	struct blkcipher_walk walk;
>
> -	if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCKSIZE) != 0))
> +	if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCK_SIZE) != 0))
>  		return xts_fallback_decrypt(desc, dst, src, nbytes);
>
>  	blkcipher_walk_init(&walk, dst, src, nbytes);

Applied together with the aes xts common code fix and the testmanager fixes,
build and tested. Works fine, Thanks.
With the 'extra run-time crypto self tests' enabled I see a failure of the s390 xts
implementation when nbytes=0 is used (should return with EINVAL but actually
returns with 0). I'll send a fix for this via the s390 maintainers.
regards
Harald Freudenberger

