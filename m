Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E93ECAAD4
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Aug 2022 09:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiH3JJD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Aug 2022 05:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiH3JJC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Aug 2022 05:09:02 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6A3A8965
        for <linux-crypto@vger.kernel.org>; Tue, 30 Aug 2022 02:09:01 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oSxEt-00GeeE-Os; Tue, 30 Aug 2022 19:08:56 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 30 Aug 2022 17:08:55 +0800
Date:   Tue, 30 Aug 2022 17:08:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: Re: [PATCH 8/9] crypto: qat - expose deflate through acomp api for
 QAT GEN2
Message-ID: <Yw3TpwuF7a46SZDI@gondor.apana.org.au>
References: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
 <20220818180120.63452-9-giovanni.cabiddu@intel.com>
 <YwigYBNM7O/J6gO1@gondor.apana.org.au>
 <YwjW2x/uT9ST8+8i@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwjW2x/uT9ST8+8i@gcabiddu-mobl1.ger.corp.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 26, 2022 at 03:21:15PM +0100, Giovanni Cabiddu wrote:
>
> It would be nice if the user of the api could provide a hint for the
> size of the destination buffer in acomp_req.dlen.

The whole point of this is that the user has no idea how big
the result will be.  If anyone would have a clue, it would be
whoever is doing the decompression.

Ideally the hardware would take an SG list, dump whatever result
that fits into it, and then stop the decompression, dump the
interim state somewhere so that it can be resumed, ask for memory
from the driver, and then resume the decompression.

I understand that hardware already exists that cannot perform
such an incremental process.  In that case we should hide this
inadequacy in the driver.

Here's a suggestion.  Start with whatever value you want (e.g.,
src * 2), attempt the decompression, if it fails because the
space is to small, then double it and retry the operation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
