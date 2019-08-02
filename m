Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3244EC433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 04:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D9A2206A3
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 04:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbfHBEBy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 00:01:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48452 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbfHBEBy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 00:01:54 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1htOlM-0005C3-8c; Fri, 02 Aug 2019 14:01:52 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1htOlI-000499-W5; Fri, 02 Aug 2019 14:01:48 +1000
Date:   Fri, 2 Aug 2019 14:01:48 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4] crypto: gcm - restrict assoclen for rfc4543
Message-ID: <20190802040148.GA15907@gondor.apana.org.au>
References: <1564504233-26186-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564504233-26186-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 30, 2019 at 07:30:33PM +0300, Iuliana Prodan wrote:
>
> diff --git a/crypto/gcm.c b/crypto/gcm.c
> index 2f3b50f..8adf64f 100644
> --- a/crypto/gcm.c
> +++ b/crypto/gcm.c
> @@ -1034,12 +1034,14 @@ static int crypto_rfc4543_copy_src_to_dst(struct aead_request *req, bool enc)
>  
>  static int crypto_rfc4543_encrypt(struct aead_request *req)
>  {
> -	return crypto_rfc4543_crypt(req, true);
> +	return crypto_ipsec_check_assoclen(req->assoclen) ?:
> +			crypto_rfc4543_crypt(req, true);

Please align it like this:

	return crypto_ipsec_check_assoclen(req->assoclen) ?:
	       crypto_rfc4543_crypt(req, true);

as that's how everything else is aligned in crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
