From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 4/4] crypto: Documentation: fix none signal safe sample
Date: Tue, 16 May 2017 15:41:07 -0700
Message-ID: <20170516224107.GD113464@gmail.com>
References: <1494503626-15877-1-git-send-email-gilad@benyossef.com>
 <1494503626-15877-5-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34589 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbdEPWlK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 May 2017 18:41:10 -0400
Content-Disposition: inline
In-Reply-To: <1494503626-15877-5-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 11, 2017 at 02:53:45PM +0300, Gilad Ben-Yossef wrote:
> The sample code was showing use of wait_for_completion_interruptible()
> for waiting for an async. crypto op to finish. However, if a signal
> arrived it would free the buffers used even while crypto HW might
> still DMA from/into the buffers.
> 
> Resolve this by using wait_for_completion() instead.
> 
> Reported-by: Eric Biggers <ebiggers3@gmail.com>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  Documentation/crypto/api-samples.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/crypto/api-samples.rst b/Documentation/crypto/api-samples.rst
> index d021fd9..944f08b 100644
> --- a/Documentation/crypto/api-samples.rst
> +++ b/Documentation/crypto/api-samples.rst
> @@ -48,7 +48,7 @@ Code Example For Symmetric Key Cipher Operation
>              break;
>          case -EINPROGRESS:
>          case -EBUSY:
> -            rc = wait_for_completion_interruptible(
> +            rc = wait_for_completion(
>                  &sk->result.completion);
>              if (!rc && !sk->result.err) {
>                  reinit_completion(&sk->result.completion);
> -- 
> 2.1.4
> 

Same issue here: wait_for_completion() doesn't return a value.

Eric
