From: Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH v7 2/2] crypto: s5p-sss: Add HASH support for Exynos
Date: Wed, 25 Oct 2017 07:32:46 +0300
Message-ID: <12d1674b-c1a0-6a9b-644e-e0a40fbb4457@mleia.com>
References: <20171017112824.10231-1-k.konieczny@partner.samsung.com>
 <CGME20171017112846eucas1p17185d93eb5f837643c880357b3a8053b@eucas1p1.samsung.com>
 <20171017112824.10231-3-k.konieczny@partner.samsung.com>
 <f16aefe9-975b-e380-509e-452ed5333f11@mleia.com>
 <875af8c4-b2d5-2d24-962d-9e4db4652eee@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <875af8c4-b2d5-2d24-962d-9e4db4652eee@partner.samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Kamil,

I'll just answer to your question, all the comments from you are accepted,
please send a new version with the minor fixes, hopefully the change will
be included into v4.15-rc.

On 10/24/2017 02:27 PM, Kamil Konieczny wrote:
> Hi Vladimir,
> 
> Thank you for review, I will apply almost all of your remarks,
> see answers below.
> 
> On 22.10.2017 12:18, Vladimir Zapolskiy wrote:
>> Hi Kamil,
>>
>> thank you for updates, I have just a few more comments.
>>

[snip]

>>> +/**
>>> + * s5p_hash_import - import hash state
>>> + * @req:	AHASH request
>>> + * @in:		buffer with state to be imported from
>>> + */
>>> +static int s5p_hash_import(struct ahash_request *req, const void *in)
>>> +{
>>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
>>> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
>>> +	struct s5p_hash_ctx *tctx = crypto_ahash_ctx(tfm);
>>> +	const struct s5p_hash_reqctx *ctx_in = in;
>>> +
>>> +	memcpy(ctx, in, sizeof(*ctx) + BUFLEN);
>>> +	if (ctx_in->bufcnt < 0 || ctx_in->bufcnt > BUFLEN) {
>>
>> Now "ctx_in->bufcnt < 0" condition can be removed, moreover it
>> will eliminate a warning reproted by the compiler:
>>
>> drivers/crypto/s5p-sss.c:1748:21: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>>   if (ctx_in->bufcnt < 0 || ctx_in->bufcnt > BUFLEN) {
>>                      ^
> 
> You are right, I will drop first condition. BTW what compiler options are you using ?
> This one was not reported by my compilation process.
> 

Regularly I specify 'make C=1 W=1' options to build a kernel with changes,
some of the new reported warnings are false positives, but in general it
makes sense to check the output to catch potential issues like this one.

--
With best wishes,
Vladimir
