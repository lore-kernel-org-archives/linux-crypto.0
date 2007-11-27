From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] [RESEND] crypto test: use print_hex_dump from kernel.h
 instead
Date: Tue, 27 Nov 2007 03:58:57 +0100
Message-ID: <474B87F1.2060109@student.ltu.se>
References: <20071126143939.GB28022@gondor.apana.org.au>	<1196098095-8995-1-git-send-email-crquan@gmail.com>	<1196100104.31590.11.camel@localhost>	<20071127013540.GA793@gondor.apana.org.au> <1196131632-7285-1-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dengxw@163.com, Randy Dunlap <randy.dunlap@oracle.com>,
	Joe Perches <joe@perches.com>
To: Denis Cheng <crquan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:33183 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbXK0DNK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 22:13:10 -0500
In-Reply-To: <1196131632-7285-1-git-send-email-crquan@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Denis Cheng wrote:
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
> this is against the lastest cryptodev tree.
>
>  crypto/tcrypt.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 1e12b86..ae762c2 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -87,12 +87,11 @@ static char *check[] = {
>  	"camellia", "seed", "salsa20", NULL
>  };
>  
> -static void hexdump(unsigned char *buf, unsigned int len)
> +static inline void hexdump(unsigned char *buf, unsigned int len)
>  {
> -	while (len--)
> -		printk("%02x", *buf++);
> -
> -	printk("\n");
> +	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
> +			16, 1,
> +			buf, len, 0);
>   
Not important, but why use '0' instead of 'false'?
>  }
>  
>  static void tcrypt_complete(struct crypto_async_request *req, int err)
>   
cu
Richard Knutsson
