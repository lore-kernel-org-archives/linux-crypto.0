Return-Path: <SRS0=GLFy=62=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D505CA90AF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 19:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 360CA23129
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 19:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgELTSP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 May 2020 15:18:15 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:19119 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgELTSP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 May 2020 15:18:15 -0400
Received: from [10.193.177.158] (venkateshellapu.asicdesigners.com [10.193.177.158] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04CJHlot018430;
        Tue, 12 May 2020 12:17:48 -0700
Cc:     ayush.sawal@asicdesigners.com,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Crypto/chcr: drop refcount on error path in
 chcr_aead_op()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Devulapally Shiva Krishna <shiva@chelsio.com>
References: <20200512083723.GB251760@mwanda>
From:   Ayush Sawal <ayush.sawal@chelsio.com>
Message-ID: <20d2f5c2-d9f0-0016-b33a-5c417dfe9558@chelsio.com>
Date:   Wed, 13 May 2020 00:48:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200512083723.GB251760@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 5/12/2020 2:07 PM, Dan Carpenter wrote:
> We need to drop inflight counter before returning on this error path.
>
> Fixes: d91a3159e8d9 ("Crypto/chcr: fix gcm-aes and rfc4106-gcm failed tests")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/crypto/chelsio/chcr_algo.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index 83ddc2b39490e..e05998a1c0148 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -3744,6 +3744,7 @@ static int chcr_aead_op(struct aead_request *req,
>   	    crypto_ipsec_check_assoclen(req->assoclen) != 0) {
>   		pr_err("RFC4106: Invalid value of assoclen %d\n",
>   		       req->assoclen);
> +		chcr_dec_wrcount(cdev);
>   		return -EINVAL;
>   	}
>   


Looks good. Thanks a lot.

