Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28361C77B73
	for <linux-crypto@archiver.kernel.org>; Wed, 24 May 2023 10:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbjEXKSL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 May 2023 06:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbjEXKRc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2023 06:17:32 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF6019A8;
        Wed, 24 May 2023 03:16:07 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q1lWz-00Cl4t-Qx; Wed, 24 May 2023 18:15:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 24 May 2023 18:15:45 +0800
Date:   Wed, 24 May 2023 18:15:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yangfl <mmyangfl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] crypto: hisilicon/advca - Add SHA support
Message-ID: <ZG3j0XZLSuW79e8Q@gondor.apana.org.au>
References: <20230513074339.266879-1-mmyangfl@gmail.com>
 <20230513074339.266879-3-mmyangfl@gmail.com>
 <ZGc2m5dJh79y3pxO@gondor.apana.org.au>
 <CAAXyoMM7WisnMKTHrfx0WdMY9Xa492caaeCNrjKOdMsS0QBXhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAXyoMM7WisnMKTHrfx0WdMY9Xa492caaeCNrjKOdMsS0QBXhA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 20, 2023 at 03:03:27AM +0800, Yangfl wrote:
> Herbert Xu <herbert@gondor.apana.org.au> 于2023年5月19日周五 16:43写道：
> >
> > If it's exporting the intermediate state, why aren't you implementing
> > an import function?
>
> The intermediate state. Importing is done by hica_sha_init, since if I
> got it right, crypto hash api are required to handle multiple requests
> simultaneously, thus there will be no sense to set ctrl and state
> separately.

So can you please implement a proper import function without a
fallback?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
