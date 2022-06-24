Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7C7C43334
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jun 2022 09:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiFXJOs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jun 2022 05:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiFXJOs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jun 2022 05:14:48 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9111B50B18;
        Fri, 24 Jun 2022 02:14:47 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o4fOm-00Ai3p-57; Fri, 24 Jun 2022 19:14:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Jun 2022 17:14:44 +0800
Date:   Fri, 24 Jun 2022 17:14:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        John Allen <john.allen@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH] crypto: ccp - During shutdown, check SEV data pointer
 before using
Message-ID: <YrWAhEnXg5rpamhR@gondor.apana.org.au>
References: <7be057567582b480fd10a8d3d8d6574af4a73f2a.1655393178.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7be057567582b480fd10a8d3d8d6574af4a73f2a.1655393178.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 16, 2022 at 10:26:18AM -0500, Tom Lendacky wrote:
> On shutdown, each CCP device instance performs shutdown processing.
> However, __sev_platform_shutdown_locked() uses the controlling psp
> structure to obtain the pointer to the sev_device structure. However,
> during driver initialization, it is possible that an error can be received
> from the firmware that results in the sev_data pointer being cleared from
> the controlling psp structure. The __sev_platform_shutdown_locked()
> function does not check for this situation and will segfault.
> 
> While not common, this scenario should be accounted for. Add a check for a
> NULL sev_device structure before attempting to use it.
> 
> Fixes: 5441a07a127f ("crypto: ccp - shutdown SEV firmware on kexec")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
