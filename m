Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83575C3DA7A
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Dec 2022 08:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiL1IuA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Dec 2022 03:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiL1Ito (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2022 03:49:44 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAFE268;
        Wed, 28 Dec 2022 00:49:43 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pAS85-00BU4A-0b; Wed, 28 Dec 2022 16:49:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 28 Dec 2022 16:49:41 +0800
Date:   Wed, 28 Dec 2022 16:49:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Rientjes <rientjes@google.com>
Cc:     Peter Gonda <pgonda@google.com>, Andy Nguyen <theflow@google.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, John Allen <john.allen@amd.com>,
        "Thomas . Lendacky" <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp - Limit memory allocation in SEV_GET_ID2
 ioctl
Message-ID: <Y6wDJd3hfztLoCp1@gondor.apana.org.au>
References: <20221214202046.719598-1-pgonda@google.com>
 <Y5rxd6ZVBqFCBOUT@gondor.apana.org.au>
 <762d33dc-b5fd-d1ef-848c-7de3a6695557@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <762d33dc-b5fd-d1ef-848c-7de3a6695557@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 27, 2022 at 05:42:31PM -0800, David Rientjes wrote:
>
> The goal was to be more explicit about that, but setting __GFP_NOWARN 
> would result in the same functional behavior.  If we're to go that route, 
> it would likely be best to add a comment about the limitation.
> 
> That said, if AMD would prefer this to be an EINVAL instead of a ENOMEM by 
> introducing a more formal limitation on the length that can be used, that 
> would be preferred so that we don't need to rely on the page allocator's 
> max length to enforce this arbitrarily.

Ideally the limit should be set according to the object that
you're trying to allocate.  But if that is truly unlimited,
and you don't want to see a warning, then GFP_NOWARN seems to
fit the bill.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
