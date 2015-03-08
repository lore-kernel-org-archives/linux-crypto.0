From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH RESEND 0/2] crypto: algif - change algif_skcipher to be asynchronous
Date: Sun, 08 Mar 2015 12:20:47 +0100
Message-ID: <2623212.v9KkTj4KSQ@tachyon.chronox.de>
References: <20150227193538.10553.6144.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:45957 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbbCHLVE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Mar 2015 07:21:04 -0400
In-Reply-To: <20150227193538.10553.6144.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 27. Februar 2015, 11:35:38 schrieb Tadeusz Struk:

Hi Tadeusz,

> The way the algif_skcipher works currently is that on sendmsg/sendpage it
> builds an sgl for the input data and then on read/recvmsg it sends the job
> for encryption putting the user to sleep till the data is processed.
> This way it can only handle one job at a given time.
> To be able to fuly utilize the potential of existing crypto hardware
> accelerators it is required to submit multiple jobs in asynchronously.
> This series adds support for asynchronous operations for algif_skcipher.
> First patch enables af_alg sgl to be linked.
> Second patch implement asynch read for skcipher.
> 
> Resend with updates for 4.0

As you may know, I am working on libkcapi [1] to cover the user space AF_ALG 
interface and provide an easy-to use interface for applications.

I am now trying to cover your interface proposal there and also measure the 
speed of it. What bothers me currently is the following: how would I be able 
to detect whether the implemented support is available in the current kernel?

For the different AF_ALG interfaces (like the recently added AEAD), I can 
detect missing support at the time I call the socket() syscall. Thus, the 
application knows right from the start whether we have the requested support.

But for the AIO interface, how can I detect that at runtime at a time an 
application can reasonably catch a missing support?

[1] http://www.chronox.de/libkcapi.html
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
> Tadeusz Struk (2):
>       crypto: af_alg - Allow to link sgl
>       crypto: algif - change algif_skcipher to be asynchronous
> 
> 
>  crypto/af_alg.c         |   18 ++-
>  crypto/algif_skcipher.c |  308
> ++++++++++++++++++++++++++++++++++++++++++++++- include/crypto/if_alg.h |  
>  4 -
>  3 files changed, 317 insertions(+), 13 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ciao
Stephan
