Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFBDC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 06:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8418620775
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 06:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgFZGJH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 02:09:07 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51958 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgFZGJG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 02:09:06 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1johXr-0004ZM-16; Fri, 26 Jun 2020 16:09:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Jun 2020 16:09:03 +1000
Date:   Fri, 26 Jun 2020 16:09:03 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ofir Drang <ofir.drang@arm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 0/3] fixes and update to essiv support
Message-ID: <20200626060902.GE20811@gondor.apana.org.au>
References: <20200621112000.31495-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621112000.31495-1-gilad@benyossef.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jun 21, 2020 at 02:19:56PM +0300, Gilad Ben-Yossef wrote:
> Small fixes and adapt essiv support to the new template format
> 
> ---
> Changes from v1:
> - Incorporate coding style fixes suggested by Markus Elfring.
> 
> Gilad Ben-Yossef (3):
>   crypto: ccree: fix resource leak on error path
>   crypto: ccree: adapt ccree essiv support to kcapi
>   crypto: ccree: remove unused field
> 
>  drivers/crypto/ccree/cc_cipher.c | 149 ++++++++++++++++++++++---------
>  1 file changed, 108 insertions(+), 41 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
