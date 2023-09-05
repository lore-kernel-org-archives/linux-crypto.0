Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101D8C83F2C
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Sep 2023 16:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245705AbjIEQUq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245719AbjIEC1o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Sep 2023 22:27:44 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818D3CC7;
        Mon,  4 Sep 2023 19:27:39 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qdLmg-00ArED-E7; Tue, 05 Sep 2023 10:27:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 Sep 2023 10:27:20 +0800
Date:   Tue, 5 Sep 2023 10:27:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Longfang Liu <liulongfang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/hpre - Fix a erroneous check after
 snprintf()
Message-ID: <ZPaSCOX1F9b36rxV@gondor.apana.org.au>
References: <73534cb1713f58228d54ea53a8a137f4ef939bad.1693858632.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73534cb1713f58228d54ea53a8a137f4ef939bad.1693858632.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 04, 2023 at 10:17:29PM +0200, Christophe JAILLET wrote:
> This error handling looks really strange.
> Check if the string has been truncated instead.
> 
> Fixes: 02ab994635eb ("crypto: hisilicon - Fixed some tiny bugs of HPRE")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
> index 39297ce70f44..db44d889438a 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
> @@ -1033,7 +1033,7 @@ static int hpre_cluster_debugfs_init(struct hisi_qm *qm)
>  
>  	for (i = 0; i < clusters_num; i++) {
>  		ret = snprintf(buf, HPRE_DBGFS_VAL_MAX_LEN, "cluster%d", i);
> -		if (ret < 0)
> +		if (ret >= HPRE_DBGFS_VAL_MAX_LEN)
>  			return -EINVAL;
>  		tmp_d = debugfs_create_dir(buf, qm->debug.debug_root);

Who is going to free the allocated memory in case of error?

The other snprintf in the same file also looks suspect.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
