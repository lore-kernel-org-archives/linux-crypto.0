Return-Path: <SRS0=Vvbd=45=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D093EC10DCE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 12:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B07CD206BE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 12:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCLMlS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Mar 2020 08:41:18 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60028 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgCLMlR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Mar 2020 08:41:17 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jCN98-00026I-Tg; Thu, 12 Mar 2020 23:41:08 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Mar 2020 23:41:06 +1100
Date:   Thu, 12 Mar 2020 23:41:06 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] crypto: ccree - cleanups
Message-ID: <20200312124106.GH28885@gondor.apana.org.au>
References: <20200308155710.14546-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200308155710.14546-1-gilad@benyossef.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 08, 2020 at 05:57:03PM +0200, Gilad Ben-Yossef wrote:
> A bunch of code cleanups.
> No fixes or new features here.
> 
> Gilad Ben-Yossef (4):
>   crypto: ccree - remove ancient TODO remarks
>   crypto: ccree - only check condition if needed
>   crypto: ccree - use crypto_ipsec_check_assoclen()
>   crypto: ccree - refactor AEAD IV in AAD handling
> 
> Hadar Gat (2):
>   crypto: ccree - update register handling macros
>   crypto: ccree - remove pointless comment
> 
>  drivers/crypto/ccree/cc_aead.c          | 113 +++++++-----------------
>  drivers/crypto/ccree/cc_aead.h          |   3 +-
>  drivers/crypto/ccree/cc_buffer_mgr.c    |  91 +++----------------
>  drivers/crypto/ccree/cc_cipher.c        |   1 -
>  drivers/crypto/ccree/cc_driver.h        |   5 +-
>  drivers/crypto/ccree/cc_hash.c          |   3 -
>  drivers/crypto/ccree/cc_hw_queue_defs.h |  77 ++++++++--------
>  drivers/crypto/ccree/cc_request_mgr.c   |   1 -
>  8 files changed, 80 insertions(+), 214 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
