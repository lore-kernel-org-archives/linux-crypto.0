From: "Dey, Megha" <megha.dey@intel.com>
Subject: RE: sha1_mb broken
Date: Tue, 4 Oct 2016 00:25:07 +0000
Message-ID: <C440BA31B54DCD4AAC682D2365C8FEE703CEF891@ORSMSX111.amr.corp.intel.com>
References: <1939675.7gNnqUbNs6@positron.chronox.de>
 <2200246.hBmZe7vJh4@positron.chronox.de>
 <C440BA31B54DCD4AAC682D2365C8FEE703CEF203@ORSMSX111.amr.corp.intel.com>
 <9643256.KgnRM79R5B@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:21304 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751636AbcJDAZN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Oct 2016 20:25:13 -0400
In-Reply-To: <9643256.KgnRM79R5B@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



-----Original Message-----
From: Stephan Mueller [mailto:smueller@chronox.de] 
Sent: Wednesday, September 28, 2016 10:31 PM
To: Dey, Megha <megha.dey@intel.com>
Cc: linux-crypto@vger.kernel.org; tim.c.chen@linux.intel.com
Subject: Re: sha1_mb broken

Am Mittwoch, 28. September 2016, 22:52:46 CEST schrieb Dey, Megha:

Hi Megha,

see a self contained example code attached.
 
> Hi Stephan,
>
> Your test code initialized the completion structure incorrectly, that led to the missing completion from being received. The init_completion call should be made before the crypto_ahash_digest call. The following change to your test code fixes things. ( I have also fixed what I believe is a typo aead->ahash)

> @@ -74,6 +74,8 @@ static unsigned int kccavs_ahash_op(struct kccavs_ahash_def *ahash)
> {
>        int rc = 0;
>
> +       init_completion(&ahash->result.completion);
> +
>        rc = crypto_ahash_digest(ahash->req);
>
>        switch (rc) {
>@@ -84,7 +86,7 @@ static unsigned int kccavs_ahash_op(struct kccavs_ahash_def *ahash)
>                rc = wait_for_completion_interruptible(&ahash->result.completion);
>                if (!rc && !ahash->result.err) {
> #ifdef OLDASYNC
> -                       INIT_COMPLETION(aead->result.completion);
> +                       INIT_COMPLETION(&ahash->result.completion);
> #else
>                       reinit_completion(&ahash->result.completion);
> #endif
> @@ -95,7 +97,6 @@ static unsigned int kccavs_ahash_op(struct kccavs_ahash_def *ahash)
>                    " %d\n",rc, ahash->result.err);
>                break;
>       }
> -       init_completion(&ahash->result.completion);
>
>     return rc;
>}
> This initialization of the completion structure happens correctly in the tcrypt test module used by the kernel, hence I did not come across this issue earlier.
> Thanks,
> Megha
Ciao
Stephan
