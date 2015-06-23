From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto-jitterentropy: Delete unnecessary checks before the function call "kzfree"
Date: Tue, 23 Jun 2015 23:44:40 +0200
Message-ID: <3056833.hq1kqBmzGz@myon.chronox.de>
References: <5307CAA2.8060406@users.sourceforge.net> <5317A59D.4@users.sourceforge.net> <5589CD95.9080508@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47835 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbbFWVon (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2015 17:44:43 -0400
In-Reply-To: <5589CD95.9080508@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 23. Juni 2015, 23:20:21 schrieb SF Markus Elfring:

Hi Markus,

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 23 Jun 2015 22:30:21 +0200
> 
> The kzfree() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.

Ack: the patch is correct and I was overzealous.

Nack: I just proposed a patch earlier today to avoid compiler warnings [1]. 
That patch clashes with yours. May I ask you to wait briefly to see whether 
that patch will be accepted? If yes, it would be great if you could repost the 
patch that applies to the changed code.

PS: when you are at it, maybe even the last line in the function can be 
removed: setting the entropy_collector to NULL at that the end of the function 
is moot as well.

Thanks.

[1] http://lkml.iu.edu/hypermail/linux/kernel/1506.2/05196.html
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  crypto/jitterentropy.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
> index d3c3045..22ded3e 100644
> --- a/crypto/jitterentropy.c
> +++ b/crypto/jitterentropy.c
> @@ -698,11 +698,9 @@ static struct rand_data
> *jent_entropy_collector_alloc(unsigned int osr,
> 
>  static void jent_entropy_collector_free(struct rand_data
> *entropy_collector) {
> -	if (entropy_collector->mem)
> -		kzfree(entropy_collector->mem);
> +	kzfree(entropy_collector->mem);
>  	entropy_collector->mem = NULL;
> -	if (entropy_collector)
> -		kzfree(entropy_collector);
> +	kzfree(entropy_collector);
>  	entropy_collector = NULL;
>  }


-- 
Ciao
Stephan
