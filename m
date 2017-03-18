From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH] crypto: zip - Memory corruption in zip_clear_stats()
Date: Sat, 18 Mar 2017 11:24:34 +0100
Message-ID: <58CD0AE2.3070006@bfs.de>
References: <20170317204621.GD16505@mwanda>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jan Glauber <jglauber@cavium.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx02-sz.bfs.de ([194.94.69.103]:3007 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751107AbdCRKZ1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Mar 2017 06:25:27 -0400
In-Reply-To: <20170317204621.GD16505@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



Am 17.03.2017 21:46, schrieb Dan Carpenter:
> There is a typo here.  It should be "stats" instead of "state".  The
> impact is that we clear 224 bytes instead of 80 and we zero out memory
> that we shouldn't.
> 
> Fixes: 09ae5d37e093 ("crypto: zip - Add Compression/Decompression statistics")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
> index 0951e20b395b..6ff13d80d82e 100644
> --- a/drivers/crypto/cavium/zip/zip_main.c
> +++ b/drivers/crypto/cavium/zip/zip_main.c
> @@ -530,7 +530,7 @@ static int zip_clear_stats(struct seq_file *s, void *unused)
>  	for (index = 0; index < MAX_ZIP_DEVICES; index++) {
>  		if (zip_dev[index]) {
>  			memset(&zip_dev[index]->stats, 0,
> -			       sizeof(struct zip_state));
> +			       sizeof(struct zip_stats));


as future FIXME some show find a name that differ in more than just the last char.
NTL maybe
 sizeof(zip_dev[index]->stats)
can be used here ?

re,
 wh

>  			seq_printf(s, "Cleared stats for zip %d\n", index);
>  		}
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
