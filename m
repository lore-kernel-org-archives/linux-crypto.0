From: Huang Ying <ying.huang@intel.com>
Subject: Re: [BUGFIX 2/3] crypto: Remove CRYPTO_TFM_REQ_MAY_SLEEP flag in
 AES-NI accelerated ecb/cbc mode
Date: Fri, 19 Jun 2009 08:55:20 +0800
Message-ID: <1245372920.22246.15.camel@yhuang-dev.sh.intel.com>
References: <1245056697.5320.350.camel@yhuang-dev.sh.intel.com>
	 <20090618114032.GB6596@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25121 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZFSAzT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2009 20:55:19 -0400
In-Reply-To: <20090618114032.GB6596@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2009-06-18 at 19:40 +0800, Herbert Xu wrote:
> On Mon, Jun 15, 2009 at 05:04:57PM +0800, Huang Ying wrote:
> > Because AES-NI instructions will touch XMM state, corresponding code
> > must be enclosed within kernel_fpu_begin/end, which used
> > preempt_disable/enable. So sleep should be prevented between
> > kernel_fpu_begin/end.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> I'll apply this for now.  But it would be much better to allow
> sleeping in this case.
> 
> Couldn't we simply move the kernel_fpu_begin/end inside the loop?
> It shouldn't be too expensive when it runs the 2nd time since it
> doesn't have to save anything, right?

I will test the performance difference.

Best Regards,
Huang Ying


