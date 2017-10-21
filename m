From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto-testmgr: Use common error handling code in drbg_cavs_test()
Date: Sat, 21 Oct 2017 21:07:28 +0200
Message-ID: <6795494.nv2bFMflat@tauon.chronox.de>
References: <7c2b4df8-a04b-cacd-13ba-4d9afb346263@users.sourceforge.net> <7aa0ec0b-c00e-44c0-1c07-6bd87e2b6c47@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <7aa0ec0b-c00e-44c0-1c07-6bd87e2b6c47@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Samstag, 21. Oktober 2017, 19:53:54 CEST schrieb SF Markus Elfring:

Hi Markus,

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 21 Oct 2017 19:29:11 +0200
> 
> Adjust jump targets so that a bit of exception handling can be better
> reused at the end of this function.
> 
> This issue was detected by using the Coccinelle software.

Thank you for this patch.

> -outbuf:
> +	ret = memcmp(test->expected, buf, test->expectedlen);
> +free_rng:
>  	crypto_free_rng(drng);
> +free_buffer:
>  	kzfree(buf);
>  	return ret;
> +
> +report_failure:
> +	pr_err("alg: drbg: could not obtain random data for driver %s\n",
> +	       driver);
> +	goto free_rng;

Though, jumping back and forth like this with goto directives is something 
that looks a bit strange. At least to my taste, may I suggest to have gotos 
pointing only downwards and not up again? (Note, the same applies to the 
ansi_cprng patch set).

What about something like following:

...
    memcmp
    goto free_rng;

report_failure:
    <failure report>

free_rng:
    <the deallocation code>

Ciao
Stephan
