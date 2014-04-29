From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC PATCH v2 4/9] crypto: qce: Add ablkcipher algorithms
Date: Tue, 29 Apr 2014 17:31:36 +0300
Message-ID: <535FB7C8.3090302@mm-sol.com>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com> <1397479725-20954-5-git-send-email-svarbanov@mm-sol.com> <20140428081805.GA15980@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-arm-msm@vger.kernel.org,
	Mona Hossain <mhossain@codeaurora.org>,
	Hariprasad Dhalinarasimha <hnamgund@codeaurora.org>,
	Zhen Kong <zkong@codeaurora.org>,
	Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
	Rohit Vaswani <rvaswani@codeaurora.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20140428081805.GA15980@gondor.apana.org.au>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Thanks for the review!

On 04/28/2014 11:18 AM, Herbert Xu wrote:
> On Mon, Apr 14, 2014 at 03:48:40PM +0300, Stanimir Varbanov wrote:
>>
>> +	} else if (IS_DES(flags)) {
>> +		u32 tmp[DES_EXPKEY_WORDS];
>> +
>> +		if (keylen != QCE_DES_KEY_SIZE)
>> +			goto badkey;
> 
> No need to check here since you've already set min_keysize and
> max_keysize correctly.
> 
>> +	} else if (IS_3DES(flags)) {
>> +		if (keylen != DES3_EDE_KEY_SIZE)
>> +			goto badkey;
> 
> Ditto.

OK, I will delete those needless keylen checks.


-- 
regards,
Stan
