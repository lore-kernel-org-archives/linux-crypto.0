Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4EAC4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Oct 2022 06:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiJMGH5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Oct 2022 02:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiJMGHz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2022 02:07:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB4612D831;
        Wed, 12 Oct 2022 23:07:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60BE2B81CAA;
        Thu, 13 Oct 2022 06:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A81C433C1;
        Thu, 13 Oct 2022 06:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665641266;
        bh=Ymnia1WPOGeu1Ff6synlWOcYTJSKP3sMwC6ULsVsBPc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dlehKBZSBL1mlIXmtQcegbAMYXgWheW/aUdCPkt+xblP9aog3CLMPgFlVPnOxLgY2
         7yOI0f/02Wsn8S38RNhDRABy3605+rhQQ7nxr6rXEfOtQ5yssF2j/uL2Y4wefEbMOc
         ueRbPU2Vo3IeEwrAqRztTDJ02I70sv9GW0RhpTJUQzHuYlK7c5scdngv9TrWYvv4Lr
         j4M6rmzMplm/fInTc6vA4lanb9iQoBXfkq+b1eUHIqp4OVUh1rvCDIk7CYTjU+NDek
         AVm+FGCQbZeBq4bjqOL0BRgNf0aI6eoepeQqRIgzXLBrzoQEwLL0kSrqneuLQE37Mm
         hCmv5SAFrvjXw==
Date:   Wed, 12 Oct 2022 23:07:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Robert Elliott <elliott@hpe.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tim.c.chen@linux.intel.com, ap420073@gmail.com, ardb@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 19/19] crypto: x86/sha - register only the best
 function
Message-ID: <Y0erL2k1PGVN4qme@sol.localdomain>
References: <20221006223151.22159-1-elliott@hpe.com>
 <20221012215931.3896-1-elliott@hpe.com>
 <20221012215931.3896-20-elliott@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012215931.3896-20-elliott@hpe.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 12, 2022 at 04:59:31PM -0500, Robert Elliott wrote:
> Don't register and unregister each of the functions from least-
> to most-optimized (SSSE3 then AVX then AVX2); determine the
> most-optimized function and load only that version.
> 
> Suggested-by: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Robert Elliott <elliott@hpe.com>

I thought that it's done the way it is so that it's easy to run the self-tests
for all the different variants.

- Eric
