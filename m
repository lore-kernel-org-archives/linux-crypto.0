Return-Path: <SRS0=VaZj=AI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCA4C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Jun 2020 08:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FA3B208C7
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Jun 2020 08:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgF0IcD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Jun 2020 04:32:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54994 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgF0IcD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Jun 2020 04:32:03 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jp6FX-0001CS-9i; Sat, 27 Jun 2020 18:31:48 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 27 Jun 2020 18:31:47 +1000
Date:   Sat, 27 Jun 2020 18:31:47 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        ltp@lists.linux.it,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: af_alg - Fix regression on empty requests
Message-ID: <20200627083147.GA9365@gondor.apana.org.au>
References: <CA+G9fYvHFs5Yx8TnT6VavtfjMN8QLPuXg6us-dXVJqUUt68adA@mail.gmail.com>
 <20200622224920.GA4332@42.do-not-panic.com>
 <CA+G9fYsXDZUspc5OyfqrGZn=k=2uRiGzWY_aPePK2C_kZ+dYGQ@mail.gmail.com>
 <20200623064056.GA8121@gondor.apana.org.au>
 <20200623170217.GB150582@gmail.com>
 <20200626062948.GA25285@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626062948.GA25285@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 26, 2020 at 04:29:48PM +1000, Herbert Xu wrote:
>
> Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reported-by: kernel test robot <rong.a.chen@intel.com>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
