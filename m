Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0E1C76196
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Apr 2023 04:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjDCETV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Apr 2023 00:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjDCETV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2023 00:19:21 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A014F65AE;
        Sun,  2 Apr 2023 21:19:18 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pjBej-00BbAq-2b; Mon, 03 Apr 2023 12:18:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 03 Apr 2023 12:18:57 +0800
Date:   Mon, 3 Apr 2023 12:18:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yangfl <mmyangfl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] crypto: hisilicon/trng - add support for HiSTB TRNG
Message-ID: <ZCpTsUf/8glcN1kS@gondor.apana.org.au>
References: <20230331101943.831347-1-mmyangfl@gmail.com>
 <ZCfmCmxobIKaBdT4@gondor.apana.org.au>
 <CAAXyoMN+eVLNeiDtkwSZC2gFUDsBwn8SFST1=Nrw-qNr-u3-5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAXyoMN+eVLNeiDtkwSZC2gFUDsBwn8SFST1=Nrw-qNr-u3-5w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Apr 01, 2023 at 10:05:25PM +0800, Yangfl wrote:
>
> Which meson driver? I didn't find any rng module under amlogic/ dir.

drivers/char/hw_random/meson-rng.c 

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
