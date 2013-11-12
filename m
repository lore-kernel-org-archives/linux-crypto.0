From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 2/2] crypto: testmgr - make test_aead also test 'dst !=
 src' code paths
Date: Tue, 12 Nov 2013 13:11:53 +0200
Message-ID: <52820CF9.3070406@freescale.com>
References: <20120921072647.11790.19493.stgit@localhost6.localdomain6> <20120921072652.11790.31387.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:36168
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472Ab3KLLMH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Nov 2013 06:12:07 -0500
In-Reply-To: <20120921072652.11790.31387.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/21/2012 10:26 AM, Jussi Kivilinna wrote:
> Currrently test_aead uses same buffer for destination and source. However
> in any places, 'dst != src' take different path than 'dst == src' case.
>
> Therefore make test_aead also run tests with destination buffer being
> different than source buffer.
>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> ---
>   crypto/testmgr.c |  153 +++++++++++++++++++++++++++++++++++++-----------------
>   1 file changed, 105 insertions(+), 48 deletions(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 00f54d5..941d75c 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c

> @@ -442,18 +460,26 @@ static int test_aead(struct crypto_aead *tfm, int enc,
>   			authsize = abs(template[i].rlen - template[i].ilen);
>   			ret = crypto_aead_setauthsize(tfm, authsize);
>   			if (ret) {
> -				printk(KERN_ERR "alg: aead: Failed to set "
> -				       "authsize to %u on test %d for %s\n",
> -				       authsize, j, algo);
> +				pr_err("alg: aead%s: Failed to set authsize to %u on test %d for %s\n",
> +				       d, authsize, j, algo);
>   				goto out;
>   			}
>   
>   			sg_init_one(&sg[0], input,
>   				    template[i].ilen + (enc ? authsize : 0));
>   
> +			if (diff_dst) {
> +				output = xoutbuf[0];
> +				sg_init_one(&sgout[0], output,
> +					    template[i].ilen +
> +						(enc ? authsize : 0));
> +			} else {
> +				output = input;
> +			}

In case of diff_dst (src != dst), is there any assumption / convention 
regarding allocation length of req->src and req->dst - are they supposed 
be equal, even if it's not needed?
For example, in case of diff_dst && encryption, currently both req->src 
and req->dst have then length = template[i].ilen + authsize. Shouldn't 
length of req->src be template[i].ilen, i.e. no space allocated for ICV?

Thanks,
Horia
