Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBDDC77B61
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Apr 2023 03:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjDIDdk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Apr 2023 23:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDIDdj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2023 23:33:39 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07E94EC1;
        Sat,  8 Apr 2023 20:33:36 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1plLnn-00E1bO-2H; Sun, 09 Apr 2023 11:33:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Apr 2023 11:33:15 +0800
Date:   Sun, 9 Apr 2023 11:33:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yangfl <mmyangfl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] crypto: hisilicon/trng - add support for HiSTB TRNG
Message-ID: <ZDIx+wJUa8z+WUxD@gondor.apana.org.au>
References: <20230401164448.1393336-1-mmyangfl@gmail.com>
 <ZC6Ibor2aGR8D8fR@gondor.apana.org.au>
 <CAAXyoMMBWnqQGVWVOsEaKviukQJK1iyx+OAez0AQfKPL5b_UvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAXyoMMBWnqQGVWVOsEaKviukQJK1iyx+OAez0AQfKPL5b_UvQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Apr 09, 2023 at 12:06:06AM +0800, Yangfl wrote:
>
> Thanks for merging this patch. But after considering your former reply
> about drivers/char/hw_random , I'm thinking if that is a better place
> for this driver. If that is the case I'd like to post a new version of
> patch.
> 
> Sorry for late reply.

If you need to move it please send an incremental patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
