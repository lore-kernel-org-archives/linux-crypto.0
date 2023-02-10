Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFBBC05027
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 09:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjBJJmp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Feb 2023 04:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjBJJmo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2023 04:42:44 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8762DE4A;
        Fri, 10 Feb 2023 01:42:43 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pQPvR-009bwA-Cu; Fri, 10 Feb 2023 17:42:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Feb 2023 17:42:37 +0800
Date:   Fri, 10 Feb 2023 17:42:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Meadhbh <meadhbh.fitzpatrick@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, wojciech.ziemba@intel.com,
        tomaszx.kowalik@intel.com, bagasdotme@gmail.com,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] Documentation: qat: change kernel version
Message-ID: <Y+YRjdV2oAOZ+ycK@gondor.apana.org.au>
References: <20230119080508.24235-1-meadhbh.fitzpatrick@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119080508.24235-1-meadhbh.fitzpatrick@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 19, 2023 at 09:05:08AM +0100, Meadhbh wrote:
> Change kernel version from 5.20 to 6.0, as 5.20 is not a release.
> 
> Signed-off-by: Meadhbh Fitzpatrick <meadhbh.fitzpatrick@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-qat | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
