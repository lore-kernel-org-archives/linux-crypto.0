Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC17BC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Apr 2022 09:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387854AbiDUJyH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Apr 2022 05:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239338AbiDUJyG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Apr 2022 05:54:06 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7C21261B;
        Thu, 21 Apr 2022 02:51:15 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nhTSj-005CrB-4r; Thu, 21 Apr 2022 19:50:58 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 21 Apr 2022 17:50:57 +0800
Date:   Thu, 21 Apr 2022 17:50:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     arno@natisbad.org, bbrezillon@kernel.org, schalla@marvell.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: marvell: cesa: Add fallback for handling
 empty length case
Message-ID: <YmEpAXymRIqoC6ur@gondor.apana.org.au>
References: <20220413191155.1429137-1-clabbe@baylibre.com>
 <20220413191155.1429137-2-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413191155.1429137-2-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 13, 2022 at 07:11:55PM +0000, Corentin Labbe wrote:
> The driver does not handle case where cryptlen is zero and fail crypto selftests.
> So let's add a fallback for this case.

Wouldn't it be easier to just handle this in the software? After
all, a zero encryption/decryption is just a no-op, right?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
