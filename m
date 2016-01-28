From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: af_alg - add async support to algif_aead
Date: Thu, 28 Jan 2016 09:30:10 -0800
Message-ID: <56AA5022.6000605@intel.com>
References: <20160127221031.12534.13202.stgit@tstruk-mobl1>
 <76537095.pjn76bZGgL@positron.chronox.de> <56AA3B19.8080604@intel.com>
 <3065480.xA9mO0V5SY@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3065480.xA9mO0V5SY@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/28/2016 09:09 AM, Stephan Mueller wrote:
> Am Donnerstag, 28. Januar 2016, 08:00:25 schrieb Tadeusz Struk:
> 
> Hi Tadeusz,
> 
>> Hi Stephan,
>>
>> On 01/27/2016 10:26 PM, Stephan Mueller wrote:
>>>> +	for (i = 0; i < areq->tsgls; i++)
>>>>
>>>>> +		put_page(sg_page(sg + i));
>>>
>>> Shouldn't here be the same logic as in put_sgl? I.e.
>>>
>>>         for (i = 0; i < sgl->cur; i++) {
>>>         
>>>                 if (!sg_page(sg + i))
>>>                 
>>>                         continue;
>>>                 
>>>                 put_page(sg_page(sg + i));
>>>                 sg_assign_page(sg + i, NULL);
>>>         
>>>         }
>>
>> Thanks for reviewing.
>> I don't think it is possible that there ever will be any gaps in the tsgl.
>> In fact if there is such a possibility then it is a serious problem, because
>> it would mean that we are sending NULL ptrs to the ciphers (see line 640):
>>
>> 	sg_mark_end(sgl->sg + sgl->cur - 1);
>> 	aead_request_set_crypt(&ctx->aead_req, sgl->sg, ctx-
>> first_rsgl.sgl.sg,
>> 			       used, ctx->iv);
>>
>> I don't see any implementation checking for null in sgls. Most of them just
>> do:
>>
>> 	for_each_sg(sgl, sg, nents, i)
>> 		sg_virt(sg)...
>>
>> So it would Oops there. I think this check in put_sgl is redundant.
>> Thanks,
> 
> algif_skcipher does a similar check in skcipher_pull_sgl:
> 
> ...
>                         if (!sg_page(sg + i))
>                                 continue;
> ...
>                         if (put)
>                                 put_page(sg_page(sg + i));
>                         sg_assign_page(sg + i, NULL);
> ...
> 

Yes, that's true, but this is because if you look at the skcipher_recvmsg_async()
function, it invokes crypt operation for each recv segment separately, and after each
iteration advances the tsgl forward and marks the sgs that are already processed with NULL.
This is completely different to the aead use case, which always sends everything
in one go.
Thanks,

-- 
TS
