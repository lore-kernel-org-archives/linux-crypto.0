Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29483C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 11:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB28E21841
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 11:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfCULTb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:19:31 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:36196 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfCULTb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 07:19:31 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h6vjG-0005yU-SL; Thu, 21 Mar 2019 19:19:22 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h6vjC-0003EC-Lc; Thu, 21 Mar 2019 19:19:18 +0800
Date:   Thu, 21 Mar 2019 19:19:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 02/11] crypto: akcipher - check the presence of
 callback before the call
Message-ID: <20190321111918.4kr7vdgz23xzjwed@gondor.apana.org.au>
References: <20190301175918.29694-1-vt@altlinux.org>
 <20190301175918.29694-3-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301175918.29694-3-vt@altlinux.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 01, 2019 at 08:59:09PM +0300, Vitaly Chikunov wrote:
> Because with introduction of EC-RDSA and change in workings of RSA in
> regard to sign/verify, akcipher could have not all callbacks defined,
> check the presence of callbacks before calling them to increase
> robustness.
> 
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>  include/crypto/akcipher.h | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
> index 2d690494568c..f537fad1989f 100644
> --- a/include/crypto/akcipher.h
> +++ b/include/crypto/akcipher.h
> @@ -268,7 +268,10 @@ static inline unsigned int crypto_akcipher_maxsize(struct crypto_akcipher *tfm)
>  {
>  	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
>  
> -	return alg->max_size(tfm);
> +	if (alg->max_size)
> +		return alg->max_size(tfm);
> +	else
> +		return 0;
>  }

Please do these checks at registration time instead and provide
default implementations as needed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
