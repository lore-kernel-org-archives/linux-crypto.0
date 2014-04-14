From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [PATCH 5/9] crypto: qce: Adds sha and hmac transforms
Date: Mon, 14 Apr 2014 11:23:38 +0300
Message-ID: <534B9B0A.2080602@mm-sol.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-6-git-send-email-svarbanov@mm-sol.com> <20140409000931.GN9985@codeaurora.org> <5346AD64.1000409@mm-sol.com> <20140411201227.GA20486@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140411201227.GA20486@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephen,

On 04/11/2014 11:12 PM, Stephen Boyd wrote:
> On 04/10, Stanimir Varbanov wrote:
>> On 04/09/2014 03:09 AM, Stephen Boyd wrote:
>>> On 04/03, Stanimir Varbanov wrote:
>>>
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int qce_ahash_import(struct ahash_request *req, const void *in)
>>>> +{
>>>> +	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
>>>> +	u32 flags = rctx->flags;
>>>> +	bool hmac = IS_SHA_HMAC(flags);
>>>> +	int ret;
>>>> +
>>>> +	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags)) {
>>>> +		struct sha1_state *state = (struct sha1_state *)in;
>>>
>>> Unnecessary cast from void *.
>>
>> Nope, "in" is "const void *". Cast is needed to avoid compiler warnings.
>>
> 
> Ouch. Why are we casting away const? It should be possible to
> make qce_import_common() take const state and buffer arguments?
> 

Sure, that's possible. Thanks!


-- 
regards,
Stan
