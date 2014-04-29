From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC PATCH v2 1/9] crypto: qce: Add core driver implementation
Date: Tue, 29 Apr 2014 17:38:14 +0300
Message-ID: <535FB956.5020600@mm-sol.com>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com> <1397479725-20954-2-git-send-email-svarbanov@mm-sol.com> <20140428085016.GA16275@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	Mona Hossain <mhossain@codeaurora.org>,
	Hariprasad Dhalinarasimha <hnamgund@codeaurora.org>,
	Zhen Kong <zkong@codeaurora.org>,
	Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
	Rohit Vaswani <rvaswani@codeaurora.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20140428085016.GA16275@gondor.apana.org.au>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Thanks for the review!

On 04/28/2014 11:50 AM, Herbert Xu wrote:
> On Mon, Apr 14, 2014 at 03:48:37PM +0300, Stanimir Varbanov wrote:
>>
>> +	if (backlog)
>> +		backlog->complete(backlog, -EINPROGRESS);
> 
> The completion function needs to be called with BH disabled.
> 
> Cheers,
> 

This is new for me because I saw similar code in cryptd.c where in
cryptd_queue_worker() (workqueue context) the backlog->complete() is
called outside of local_bh_disable().

-- 
regards,
Stan
