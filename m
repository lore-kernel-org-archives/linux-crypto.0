Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8863C38A02
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Oct 2022 03:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbiJ1D5p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Oct 2022 23:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbiJ1D5p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2022 23:57:45 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A919F76F;
        Thu, 27 Oct 2022 20:57:44 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ooGUK-007Tiz-FE; Fri, 28 Oct 2022 11:57:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Oct 2022 11:57:32 +0800
Date:   Fri, 28 Oct 2022 11:57:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     liulongfang <liulongfang@huawei.com>
Cc:     wangzhou1@hisilicon.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto/hisilicon: Add null judgment to the callback
 interface
Message-ID: <Y1tTLAEi7ukUCCmB@gondor.apana.org.au>
References: <20220930024320.29922-1-liulongfang@huawei.com>
 <YzZZTsIHLSkuufeb@gondor.apana.org.au>
 <717adf23-3080-5041-14ed-6ab5dcaddbf9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <717adf23-3080-5041-14ed-6ab5dcaddbf9@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 30, 2022 at 11:48:02AM +0800, liulongfang wrote:
>
> Even if the task is sent in synchronous mode, when using the hardware
> driver, the hardware still informs the driver software through an
> interrupt after completing the task, and the workqueue in the driver
> software will call this callback function.
> 
> And I found that the device drivers of other manufacturers under the
> crypto subsystem are also in this asynchronous mode, and this problem
> is also encountered when using the synchronous mode.

This still makes no sense to me.

Who is making an async request with no callback?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
