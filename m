From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: af_alg: fix backlog handling
Date: Mon, 22 Dec 2014 22:55:29 +1100
Message-ID: <20141222115529.GC19532@gondor.apana.org.au>
References: <1418992568-1275-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Rabin Vincent <rabinv@axis.com>
To: Rabin Vincent <rabin.vincent@axis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:44923 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaLVLzg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Dec 2014 06:55:36 -0500
Content-Disposition: inline
In-Reply-To: <1418992568-1275-1-git-send-email-rabin.vincent@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 19, 2014 at 01:36:08PM +0100, Rabin Vincent wrote:
> If a request is backlogged, it's complete() handler will get called
> twice: once with -EINPROGRESS, and once with the final error code.
> 
> af_alg's complete handler, unlike other users, does not handle the
> -EINPROGRESS but instead always completes the completion that recvmsg()
> is waiting on.  This can lead to a return to user space while the
> request is still pending in the driver.  If userspace closes the sockets
> before the requests are handled by the driver, this will lead to
> use-after-frees (and potential crashes) in the kernel due to the tfm
> having been freed.
> 
> The crashes can be easily reproduced (for example) by reducing the max
> queue length in cryptod.c and running the following (from
> http://www.chronox.de/libkcapi.html) on AES-NI capable hardware:
> 
>  $ while true; do kcapi -x 1 -e -c '__ecb-aes-aesni' \
>     -k 00000000000000000000000000000000 \
>     -p 00000000000000000000000000000000 >/dev/null & done
> 
> Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>

Patch applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
