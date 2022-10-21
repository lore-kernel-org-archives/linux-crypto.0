Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CF6C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Oct 2022 11:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiJULdg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Oct 2022 07:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiJULdN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2022 07:33:13 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CAD262DC5;
        Fri, 21 Oct 2022 04:33:05 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1olqGG-004dhJ-2J; Fri, 21 Oct 2022 19:33:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Oct 2022 19:33:00 +0800
Date:   Fri, 21 Oct 2022 19:33:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: scatterwalk - remove duplicate function
 declarations
Message-ID: <Y1KDbGPTmRqHoQZq@gondor.apana.org.au>
References: <20220926091440.98804-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926091440.98804-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 26, 2022 at 05:14:40PM +0800, Tianjia Zhang wrote:
> scatterwalk_map() is an inline function already defined in the
> header file, it is necessary to delete the re-declaration at the
> same location, which was left out in the header file by an
> earlier modification.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  include/crypto/scatterwalk.h | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
