From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RESEND 0/2] crypto: algif - change algif_skcipher to be
 asynchronous
Date: Mon, 09 Mar 2015 15:10:46 +0000
Message-ID: <54FDB7F6.10004@intel.com>
References: <20150227193538.10553.6144.stgit@tstruk-mobl1> <2623212.v9KkTj4KSQ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62482 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355AbbCIPOm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 11:14:42 -0400
In-Reply-To: <2623212.v9KkTj4KSQ@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,
On 03/08/2015 11:20 AM, Stephan Mueller wrote:
> As you may know, I am working on libkcapi [1] to cover the user space AF_ALG 
> interface and provide an easy-to use interface for applications.
> 
> I am now trying to cover your interface proposal there and also measure the 
> speed of it. What bothers me currently is the following: how would I be able 
> to detect whether the implemented support is available in the current kernel?

You don't need to detect that. You can just use the new interface, and in the older
kernels without AIO support in skcipher it will seamlessly fallback to the synchronous interface.

The only problem is that the socket layer didn't like asynch operations before commit
06539d3071067ff146a9bffd1c801fa56d290909.
The way it can be tackled for the older kernels is the distros will need update their kernels
with the mentioned commit. They should do it anyway because it looks like that was a bug.

One other thing to keep in mind is - to be able to see the benefit of AIO you need to use
some encryption offload engine, where you can asynchronously offload multiple operations.
With my dh895xxcc engine I see around 8x throughput improvement.
Regards,
Tadeusz
