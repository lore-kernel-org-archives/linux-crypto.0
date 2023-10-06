Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67CAE92FD4
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Oct 2023 02:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjJFCdW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Oct 2023 22:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjJFCdV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Oct 2023 22:33:21 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52373D8;
        Thu,  5 Oct 2023 19:33:20 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qoaeL-0044GQ-OJ; Fri, 06 Oct 2023 10:33:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Oct 2023 10:33:14 +0800
Date:   Fri, 6 Oct 2023 10:33:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mike Snitzer <snitzer@kernel.org>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Tatu =?iso-8859-1?Q?Heikkil=E4?= <tatu.heikkila@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Device Mapper <dm-devel@redhat.com>,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: dm crypt: Fix reqsize in crypt_iv_eboiv_gen
Message-ID: <ZR9x6ifhd6axh5Ki@gondor.apana.org.au>
References: <f1b8d8f5-2079-537e-9d0f-d58da166fe50@gmail.com>
 <ZR9dEiXhQv-wBVA2@debian.me>
 <ZR9l446ndB4n1Xl4@gondor.apana.org.au>
 <ZR9wRq7Rkz+LocDX@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZR9wRq7Rkz+LocDX@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 05, 2023 at 10:26:14PM -0400, Mike Snitzer wrote:
>
> Sure, please do.  Shouldn't your header Cc: stable given that the
> Fixes commit implies v6.5 needs this fix?

Sure I'll add it although it will be picked up automatically due
to the Fixes header.  I'll also fix the reporter's name.

> Reviewed-by: Mike Mike Snitzer <snitzer@kernel.org>

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
