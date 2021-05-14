Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B685C43461
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 04:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D71161454
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 04:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhENExp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 00:53:45 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:51986 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231967AbhENExp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 00:53:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UYoDsTm_1620967950;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UYoDsTm_1620967950)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 May 2021 12:52:31 +0800
Subject: Re: [PATCH 1/7] crypto: fix a memory leak in sm2
To:     Hongbo Li <herbert.tencent@gmail.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        dhowells@redhat.com, jarkko@kernel.org, herberthbli@tencent.com,
        stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <1620828254-25545-1-git-send-email-herbert.tencent@gmail.com>
 <1620828254-25545-2-git-send-email-herbert.tencent@gmail.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <246ad441-76c9-0934-d132-42d263d63195@linux.alibaba.com>
Date:   Fri, 14 May 2021 12:52:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1620828254-25545-2-git-send-email-herbert.tencent@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Hongbo,

On 5/12/21 10:04 PM, Hongbo Li wrote:
> From: Hongbo Li <herberthbli@tencent.com>
> 
> SM2 module alloc ec->Q in sm2_set_pub_key(), when doing alg test in
> test_akcipher_one(), it will set public key for every test vector,
> and don't free ec->Q. This will cause a memory leak.
> 
> This patch alloc ec->Q in sm2_ec_ctx_init().
> 
> Signed-off-by: Hongbo Li <herberthbli@tencent.com>
> ---
>   crypto/sm2.c | 24 ++++++++++--------------
>   1 file changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/crypto/sm2.c b/crypto/sm2.c
> index b21addc..db8a4a2 100644
> --- a/crypto/sm2.c
> +++ b/crypto/sm2.c
> @@ -79,10 +79,17 @@ static int sm2_ec_ctx_init(struct mpi_ec_ctx *ec)
>   		goto free;
>   
>   	rc = -ENOMEM;
> +
> +	ec->Q = mpi_point_new(0);
> +	if (!ec->Q)
> +		goto free;
> +
>   	/* mpi_ec_setup_elliptic_curve */
>   	ec->G = mpi_point_new(0);
> -	if (!ec->G)
> +	if (!ec->G) {
> +		mpi_point_release(ec->Q);
>   		goto free;
> +	}
>   
>   	mpi_set(ec->G->x, x);
>   	mpi_set(ec->G->y, y);
> @@ -91,6 +98,7 @@ static int sm2_ec_ctx_init(struct mpi_ec_ctx *ec)
>   	rc = -EINVAL;
>   	ec->n = mpi_scanval(ecp->n);
>   	if (!ec->n) {
> +		mpi_point_release(ec->Q);
>   		mpi_point_release(ec->G);
>   		goto free;
>   	}
> @@ -386,27 +394,15 @@ static int sm2_set_pub_key(struct crypto_akcipher *tfm,
>   	MPI a;
>   	int rc;
>   
> -	ec->Q = mpi_point_new(0);
> -	if (!ec->Q)
> -		return -ENOMEM;
> -
>   	/* include the uncompressed flag '0x04' */
> -	rc = -ENOMEM;
>   	a = mpi_read_raw_data(key, keylen);
>   	if (!a)
> -		goto error;
> +		return -ENOMEM;
>   
>   	mpi_normalize(a);
>   	rc = sm2_ecc_os2ec(ec->Q, a);
>   	mpi_free(a);
> -	if (rc)
> -		goto error;
> -
> -	return 0;
>   
> -error:
> -	mpi_point_release(ec->Q);
> -	ec->Q = NULL;
>   	return rc;
>   }
>   
> 

Thanks a lot for fixing this issue.

Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Also added:

Cc: stable@vger.kernel.org # v5.10+

Best regards,
Tianjia
