From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v2 1/9] crypto: qce: Add core driver implementation
Date: Mon, 28 Apr 2014 16:59:28 +0800
Message-ID: <20140428085928.GA16310@gondor.apana.org.au>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
 <1397479725-20954-2-git-send-email-svarbanov@mm-sol.com>
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
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:39242 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaD1I7o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Apr 2014 04:59:44 -0400
Content-Disposition: inline
In-Reply-To: <1397479725-20954-2-git-send-email-svarbanov@mm-sol.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 14, 2014 at 03:48:37PM +0300, Stanimir Varbanov wrote:
>
> +#define QCE_MAJOR_VERSION5	0x05
> +#define QCE_QUEUE_LENGTH	50

What is the purpose of this software queue? Why can't you directly
feed the requests to the hardware?

If the hardware can't handle more than 50 requests in-flight,
then your software queue has failed to handle this since you're
taking requests off the queue before you touch the hardware so
you're not really limiting it to 50.  That is, for users that
can wait you're potentially dropping their requests instead
of letting them wait through the backlog mechanism.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
