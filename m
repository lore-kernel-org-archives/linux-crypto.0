Return-Path: <SRS0=1tzS=TR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61EC6C04AAF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 01:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 336762082E
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 01:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfEQB3E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 May 2019 21:29:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726839AbfEQB3E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 May 2019 21:29:04 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4H1LVsQ074830;
        Thu, 16 May 2019 21:26:33 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2shje89mp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 May 2019 21:26:32 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x4GJS66H020879;
        Thu, 16 May 2019 19:30:58 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 2sdp157my6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 May 2019 19:30:58 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4H1QTG230147010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 01:26:29 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF08DC6057;
        Fri, 17 May 2019 01:26:29 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1809EC6055;
        Fri, 17 May 2019 01:26:28 +0000 (GMT)
Received: from swastik.ibm.com (unknown [9.85.151.232])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 17 May 2019 01:26:27 +0000 (GMT)
Subject: Re: [PATCH] crypto: vmx - CTR: always increment IV as quadword
To:     Daniel Axtens <dja@axtens.net>, mpe@ellerman.id.au,
        ebiggers@kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org,
        gcwilson@linux.ibm.com, omosnacek@gmail.com
References: <20190515102450.30557-1-dja@axtens.net>
From:   Nayna <nayna@linux.vnet.ibm.com>
Message-ID: <3f45914d-bbc4-0dac-0ce7-ddcb1057d6a4@linux.vnet.ibm.com>
Date:   Thu, 16 May 2019 21:26:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190515102450.30557-1-dja@axtens.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_19:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905170007
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 05/15/2019 06:24 AM, Daniel Axtens wrote:
> The kernel self-tests picked up an issue with CTR mode:
> alg: skcipher: p8_aes_ctr encryption test failed (wrong result) on test vector 3, cfg="uneven misaligned splits, may sleep"
>
> Test vector 3 has an IV of FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD, so
> after 3 increments it should wrap around to 0.
>
> In the aesp8-ppc code from OpenSSL, there are two paths that
> increment IVs: the bulk (8 at a time) path, and the individual
> path which is used when there are fewer than 8 AES blocks to
> process.
>
> In the bulk path, the IV is incremented with vadduqm: "Vector
> Add Unsigned Quadword Modulo", which does 128-bit addition.
>
> In the individual path, however, the IV is incremented with
> vadduwm: "Vector Add Unsigned Word Modulo", which instead
> does 4 32-bit additions. Thus the IV would instead become
> FFFFFFFFFFFFFFFFFFFFFFFF00000000, throwing off the result.
>
> Use vadduqm.
>
> This was probably a typo originally, what with q and w being
> adjacent. It is a pretty narrow edge case: I am really
> impressed by the quality of the kernel self-tests!
>
> Fixes: 5c380d623ed3 ("crypto: vmx - Add support for VMS instructions by ASM")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Axtens <dja@axtens.net>
>
> ---
>
> I'll pass this along internally to get it into OpenSSL as well.
> ---
>   drivers/crypto/vmx/aesp8-ppc.pl | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-ppc.pl
> index de78282b8f44..9c6b5c1d6a1a 100644
> --- a/drivers/crypto/vmx/aesp8-ppc.pl
> +++ b/drivers/crypto/vmx/aesp8-ppc.pl
> @@ -1357,7 +1357,7 @@ Loop_ctr32_enc:
>   	addi		$idx,$idx,16
>   	bdnz		Loop_ctr32_enc
>   
> -	vadduwm		$ivec,$ivec,$one
> +	vadduqm		$ivec,$ivec,$one
>   	 vmr		$dat,$inptail
>   	 lvx		$inptail,0,$inp
>   	 addi		$inp,$inp,16

Acked-by: Nayna Jain <nayna@linux.ibm.com>
Tested-by: Nayna Jain <nayna@linux.ibm.com>

