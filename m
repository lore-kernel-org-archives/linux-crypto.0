Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3D3C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBC6E208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405550AbfHIGSx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 02:18:53 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37414 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405560AbfHIGSx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 02:18:53 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hvyEk-0007Iw-IT; Fri, 09 Aug 2019 16:18:50 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hvyEk-0002ok-52; Fri, 09 Aug 2019 16:18:50 +1000
Date:   Fri, 9 Aug 2019 16:18:50 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3 0/2] crypto: validate inputs for gcm and aes
Message-ID: <20190809061850.GK10392@gondor.apana.org.au>
References: <1564578355-9639-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564578355-9639-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 31, 2019 at 04:05:53PM +0300, Iuliana Prodan wrote:
> Added inline helper functions to check authsize and assoclen for
> gcm, rfc4106 and rfc4543.  
> Added, also, inline helper function to check key length for AES algorithms.
> These are used in the generic implementation of gcm/rfc4106/rfc4543
> and aes.
> 
> Changes since v2:
> - rename aes helper functions without crypto_ prefix;
> - change include for gcm.h.
> 
> Iuliana Prodan (2):
>   crypto: gcm - helper functions for assoclen/authsize check
>   crypto: aes - helper function to validate key length for AES
>     algorithms
> 
>  crypto/gcm.c         | 41 ++++++++++++++-------------------------
>  include/crypto/aes.h | 17 ++++++++++++++++
>  include/crypto/gcm.h | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/crypto/aes.c     |  8 ++++----
>  4 files changed, 91 insertions(+), 30 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
