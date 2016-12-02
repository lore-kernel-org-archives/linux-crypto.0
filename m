From: Harsh Jain <Harsh@chelsio.com>
Subject: Re: [patch] crypto: chcr - checking for IS_ERR() instead of NULL
Date: Fri, 2 Dec 2016 11:42:15 +0530
Message-ID: <8a8750bc-5bdf-d90f-9414-a7d1b1279a34@chelsio.com>
References: <20161201204937.GA10701@mwanda>
 <d2933f1a-e15e-8c33-2905-3f8161b0db7d@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Jitendra Lulla <JLULLA@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Hariprasad Shenai <hariprasad@chelsio.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:55814 "EHLO l.chelsio.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753332AbcLBGMm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2016 01:12:42 -0500
In-Reply-To: <d2933f1a-e15e-8c33-2905-3f8161b0db7d@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 02-12-2016 11:29, Harsh Jain wrote:
>
> On 02-12-2016 02:19, Dan Carpenter wrote:
>> The create_hash_wr() function never returns error pointers.  It returns
>> NULL on error.
> Will fix the same, Thanks
It's a patch mail not bug reporting!  Sorry for confusion. You have already fixed it. Thanks.
>> Fixes: 358961d1cd1e ("crypto: chcr - Added new structure chcr_wr")
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
>> index 32361dd..2ed1e24 100644
>> --- a/drivers/crypto/chelsio/chcr_algo.c
>> +++ b/drivers/crypto/chelsio/chcr_algo.c
>> @@ -958,9 +958,8 @@ static int chcr_ahash_update(struct ahash_request *req)
>>  	req_ctx->result = 0;
>>  	req_ctx->data_len += params.sg_len + params.bfr_len;
>>  	skb = create_hash_wr(req, &params);
>> -
>> -	if (IS_ERR(skb))
>> -		return PTR_ERR(skb);
>> +	if (!skb)
>> +		return -ENOMEM;
>>  
>>  	if (remainder) {
>>  		u8 *temp;
>> @@ -1023,8 +1022,8 @@ static int chcr_ahash_final(struct ahash_request *req)
>>  		params.more = 0;
>>  	}
>>  	skb = create_hash_wr(req, &params);
>> -	if (IS_ERR(skb))
>> -		return PTR_ERR(skb);
>> +	if (!skb)
>> +		return -ENOMEM;
>>  
>>  	skb->dev = u_ctx->lldi.ports[0];
>>  	set_wr_txq(skb, CPL_PRIORITY_DATA, ctx->tx_channel_id);
>> @@ -1074,8 +1073,8 @@ static int chcr_ahash_finup(struct ahash_request *req)
>>  	}
>>  
>>  	skb = create_hash_wr(req, &params);
>> -	if (IS_ERR(skb))
>> -		return PTR_ERR(skb);
>> +	if (!skb)
>> +		return -ENOMEM;
>>  
>>  	skb->dev = u_ctx->lldi.ports[0];
>>  	set_wr_txq(skb, CPL_PRIORITY_DATA, ctx->tx_channel_id);
>> @@ -1125,8 +1124,8 @@ static int chcr_ahash_digest(struct ahash_request *req)
>>  	}
>>  
>>  	skb = create_hash_wr(req, &params);
>> -	if (IS_ERR(skb))
>> -		return PTR_ERR(skb);
>> +	if (!skb)
>> +		return -ENOMEM;
>>  
>>  	skb->dev = u_ctx->lldi.ports[0];
>>  	set_wr_txq(skb, CPL_PRIORITY_DATA, ctx->tx_channel_id);
