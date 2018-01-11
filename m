From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH 5/6] crypto: stm32-hash: convert to the new crypto engine
 API
Date: Thu, 11 Jan 2018 07:44:56 +0000
Message-ID: <1a40ba6d-f66d-9471-742c-53351f7554e9@st.com>
References: <20180103201109.16077-1-clabbe.montjoie@gmail.com>
 <20180103201109.16077-6-clabbe.montjoie@gmail.com>
 <17d0497d-5c13-f93e-4249-8adff5e71b19@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Lionel DEBIEVE <lionel.debieve@st.com>,
 Benjamin GAIGNARD <benjamin.gaignard@st.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Corentin Labbe <clabbe.montjoie@gmail.com>, Alexandre TORGUE
 <alexandre.torgue@st.com>, "arei.gonglei@huawei.com"
 <arei.gonglei@huawei.com>, "corbet@lwn.net" <corbet@lwn.net>,
 "davem@davemloft.net" <davem@davemloft.net>, "herbert@gondor.apana.org.au"
 <herbert@gondor.apana.org.au>, "jasowang@redhat.com" <jasowang@redhat.com>,
 "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>, "mst@redhat.com"
 <mst@redhat.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <17d0497d-5c13-f93e-4249-8adff5e71b19@st.com>
Content-Language: en-US
Content-ID: <4A9A05B77473CD4C96F54A54C28D3CA5@st.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

(adding my tested my)


On 10/01/18 15:24, Fabien DESSENNE wrote:
>
> On 03/01/18 21:11, Corentin Labbe wrote:
>> This patch convert the stm32-hash driver to the new crypto engine API.
>>
>> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Tested-by: Fabien Dessenne <fabien.dessenne@st.com>

>> ---
>>    drivers/crypto/stm32/stm32-hash.c | 18 +++++++++++++-----
>>    1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
>> index 4ca4a264a833..9790c2c936c7 100644
>> --- a/drivers/crypto/stm32/stm32-hash.c
>> +++ b/drivers/crypto/stm32/stm32-hash.c
>> @@ -122,6 +122,7 @@ enum stm32_hash_data_format {
>>    #define HASH_DMA_THRESHOLD		50
>>    
>>    struct stm32_hash_ctx {
>> +	struct crypto_engine_reqctx enginectx;
>>    	struct stm32_hash_dev	*hdev;
>>    	unsigned long		flags;
>>    
>> @@ -828,6 +829,11 @@ static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
>>    	return 0;
>>    }
>>    
>> +static int stm32_hash_one_request(struct crypto_engine *engine,
>> +				  void *areq);
> merge these two lines in a single one
>
>> +static int stm32_hash_prepare_req(struct crypto_engine *engine,
>> +				  void *areq);
> merge these two lines in a single one
>
>> +
>>    static int stm32_hash_handle_queue(struct stm32_hash_dev *hdev,
>>    				   struct ahash_request *req)
>>    {
>> @@ -835,8 +841,9 @@ static int stm32_hash_handle_queue(struct stm32_hash_dev *hdev,
>>    }
>>    
>>    static int stm32_hash_prepare_req(struct crypto_engine *engine,
>> -				  struct ahash_request *req)
>> +				  void *areq)
> merge these two lines in a single one
>
>>    {
>> +	struct ahash_request *req = container_of(areq, struct ahash_request, base);
>   > 80 characters (CHECKPATCH)
>
>>    	struct stm32_hash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
>>    	struct stm32_hash_dev *hdev = stm32_hash_find_dev(ctx);
>>    	struct stm32_hash_request_ctx *rctx;
>> @@ -855,8 +862,9 @@ static int stm32_hash_prepare_req(struct crypto_engine *engine,
>>    }
>>    
>>    static int stm32_hash_one_request(struct crypto_engine *engine,
>> -				  struct ahash_request *req)
>> +				  void *areq)
> merge these two lines in a single one
>
>>    {
>> +	struct ahash_request *req = container_of(areq, struct ahash_request, base);
>   > 80 characters (CHECKPATCH)
>
>>    	struct stm32_hash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
>>    	struct stm32_hash_dev *hdev = stm32_hash_find_dev(ctx);
>>    	struct stm32_hash_request_ctx *rctx;
>> @@ -1033,6 +1041,9 @@ static int stm32_hash_cra_init_algs(struct crypto_tfm *tfm,
>>    	if (algs_hmac_name)
>>    		ctx->flags |= HASH_FLAGS_HMAC;
>>    
>> +	ctx->enginectx.op.do_one_request = stm32_hash_one_request;
>> +	ctx->enginectx.op.prepare_request = stm32_hash_prepare_req;
>> +	ctx->enginectx.op.unprepare_request = NULL;
>>    	return 0;
>>    }
>>    
>> @@ -1493,9 +1504,6 @@ static int stm32_hash_probe(struct platform_device *pdev)
>>    		goto err_engine;
>>    	}
>>    
>> -	hdev->engine->prepare_hash_request = stm32_hash_prepare_req;
>> -	hdev->engine->hash_one_request = stm32_hash_one_request;
>> -
>>    	ret = crypto_engine_start(hdev->engine);
>>    	if (ret)
>>    		goto err_engine_start;
