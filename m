Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D49C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Sep 2022 02:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiI3CuJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Sep 2022 22:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiI3CuI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Sep 2022 22:50:08 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFF271996;
        Thu, 29 Sep 2022 19:50:03 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oe662-00A2aU-6G; Fri, 30 Sep 2022 12:49:51 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Sep 2022 10:49:50 +0800
Date:   Fri, 30 Sep 2022 10:49:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Longfang Liu <liulongfang@huawei.com>
Cc:     wangzhou1@hisilicon.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto/hisilicon: Add null judgment to the callback
 interface
Message-ID: <YzZZTsIHLSkuufeb@gondor.apana.org.au>
References: <20220930024320.29922-1-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930024320.29922-1-liulongfang@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 30, 2022 at 10:43:20AM +0800, Longfang Liu wrote:
> The algorithm acceleration function interface provided by the
> current crypto subsystem is in asynchronous mode, but some users
> will call it in synchronous mode, thus not providing a callback
> interface for the "base.complete" of the request.

Please give more details.  Who is calling the callback functions
in synchronous mode?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
