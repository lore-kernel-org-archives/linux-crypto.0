Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495D7C001DB
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Aug 2023 08:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbjHDI0i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Aug 2023 04:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234561AbjHDI01 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Aug 2023 04:26:27 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2B04687;
        Fri,  4 Aug 2023 01:26:26 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qRq8b-003ZsF-94; Fri, 04 Aug 2023 16:26:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Aug 2023 16:26:21 +0800
Date:   Fri, 4 Aug 2023 16:26:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        liulongfang@huawei.com
Subject: Re: [PATCH 1/7] crypto: hisilicon/qm - obtain the mailbox
 configuration at one time
Message-ID: <ZMy2LQckr/OtS1ZG@gondor.apana.org.au>
References: <20230729125239.25337-1-qianweili@huawei.com>
 <20230729125239.25337-2-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230729125239.25337-2-qianweili@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jul 29, 2023 at 08:52:33PM +0800, Weili Qian wrote:
> The mailbox configuration(128 bits) needs to be obtained from the
> hardware at one time. If the mailbox configuration is obtained for
> multiple times, the read value may be incorrect. Use the instruction
> to read mailbox data instead of readl().
> 
> Signed-off-by: Weili Qian <qianweili@huawei.com>

Your patch description makes no sense to me.  Please explain more
clearly why you're replacing generic IO primitives with hand-rolled
assembly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
