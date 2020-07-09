Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C93C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 00:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A930C20708
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 00:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgGIAre (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 20:47:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34418 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgGIAre (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 20:47:34 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jtKin-0001rg-3k; Thu, 09 Jul 2020 10:47:30 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Jul 2020 10:47:29 +1000
Date:   Thu, 9 Jul 2020 10:47:29 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: Re: [PATCH] crypto: caam - Remove broken arc4 support
Message-ID: <20200709004728.GA4492@gondor.apana.org.au>
References: <20200702043648.GA21823@gondor.apana.org.au>
 <31734e86-951a-6063-942a-1d62abeb5490@nxp.com>
 <CAMj1kXGK3v+YWd6E8zNP-tKWgq+aim7X67Ze4Bxrent4hndECw@mail.gmail.com>
 <8e974767-7aa6-c644-8562-445a90206f47@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8e974767-7aa6-c644-8562-445a90206f47@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 08, 2020 at 07:24:08PM +0300, Horia Geantă wrote:
> 
> I think the commit message should be updated to reflect this logic:
> indeed, caam's implementation of ecb(arc4) is broken,
> but instead of fixing it, crypto API-based ecb(arc4)
> is removed completely from the kernel (hence from caam driver)
> due to skcipher limitations in terms of handling the keystream.

Actually that's not quite true.  The reason I create this patch
in the first place is to remove this limitation from skcipher.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
