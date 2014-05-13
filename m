From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v2 1/9] crypto: qce: Add core driver implementation
Date: Tue, 13 May 2014 19:06:07 +0800
Message-ID: <20140513110607.GA21662@gondor.apana.org.au>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
 <1397479725-20954-2-git-send-email-svarbanov@mm-sol.com>
 <20140428085928.GA16310@gondor.apana.org.au>
 <536BFDD3.9090609@mm-sol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Stanimir Vabanov <svarbanov@mm-sol.com>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <536BFDD3.9090609@mm-sol.com>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 09, 2014 at 12:57:39AM +0300, Stanimir Vabanov wrote:
> Hi Herbert,
> 
> On 04/28/2014 11:59 AM, Herbert Xu wrote:
> > On Mon, Apr 14, 2014 at 03:48:37PM +0300, Stanimir Varbanov wrote:
> >>
> >> +#define QCE_MAJOR_VERSION5	0x05
> >> +#define QCE_QUEUE_LENGTH	50
> > 
> > What is the purpose of this software queue? Why can't you directly
> > feed the requests to the hardware?
> > 
> > If the hardware can't handle more than 50 requests in-flight,
> > then your software queue has failed to handle this since you're
> > taking requests off the queue before you touch the hardware so
> > you're not really limiting it to 50.  That is, for users that
> > can wait you're potentially dropping their requests instead
> > of letting them wait through the backlog mechanism.
> 
> My assumption was that crypto_ablkcipher_encrypt/decrypt couldn't sleep
> and I should take the request almost immediately and return the
> appropriate error value - EINPROGRESS if the hardware is idle and EBUSY
> if the hardware working on some previous request. Thus if the returned
> error is EBUSY and the request could be backlogged I should call
> backlog->complete() when this request is taken actually for processing.
> 
> What I've done in practice is another story.
> 
> Is that assumption correct? If so, is crypto_enqueue|dequeue_request()
> are the proper tools to implement this behaviour?

Technically you are allowed to sleep if the MAY_SLEEP bit is set
but it's safe to just not sleep if that makes things easier for
you.

The enqueue/dequeue functions implement a software queue.  Typically
you would have a software queue in addition to whatever requests
you have in flight on the actual hardware.

For example, if your hardware is only able to handle one outstanding
request, then your software queue should only be dequeued once the
outstanding request has completed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
