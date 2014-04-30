From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC PATCH v2 1/9] crypto: qce: Add core driver implementation
Date: Wed, 30 Apr 2014 19:35:41 +0300
Message-ID: <5361265D.2000706@mm-sol.com>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com> <1397479725-20954-2-git-send-email-svarbanov@mm-sol.com> <20140428085928.GA16310@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140428085928.GA16310@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 04/28/2014 11:59 AM, Herbert Xu wrote:
> On Mon, Apr 14, 2014 at 03:48:37PM +0300, Stanimir Varbanov wrote:
>>
>> +#define QCE_MAJOR_VERSION5	0x05
>> +#define QCE_QUEUE_LENGTH	50
> 
> What is the purpose of this software queue? Why can't you directly
> feed the requests to the hardware?

Good question. This is a leftover from original driver.

The hardware can handle one request at a time. After you raise the
question I think the queue length should be 1 or remove it completely. I
don't know why the original codeaurora's driver use 50.

> 
> If the hardware can't handle more than 50 requests in-flight,
> then your software queue has failed to handle this since you're
> taking requests off the queue before you touch the hardware so
> you're not really limiting it to 50.  That is, for users that
> can wait you're potentially dropping their requests instead
> of letting them wait through the backlog mechanism.

-- 
regards,
Stan
