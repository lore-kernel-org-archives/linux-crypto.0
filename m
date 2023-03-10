Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F76AC64EC4
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Mar 2023 11:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCJLTs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Mar 2023 06:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCJLTr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2023 06:19:47 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0993911566A;
        Fri, 10 Mar 2023 03:19:46 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1paamd-002Xpq-6H; Fri, 10 Mar 2023 19:19:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Mar 2023 19:19:35 +0800
Date:   Fri, 10 Mar 2023 19:19:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Jan =?utf-8?B?RMSFYnJvxZs=?= <jsd@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, Rijo-john.Thomas@amd.com,
        Thomas.Lendacky@amd.com, John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] crypto: ccp: Add support for ringing a platform
 doorbell
Message-ID: <ZAsSR4CeYjh5CTap@gondor.apana.org.au>
References: <20230303165050.2918-1-mario.limonciello@amd.com>
 <20230303165050.2918-8-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303165050.2918-8-mario.limonciello@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 03, 2023 at 10:50:45AM -0600, Mario Limonciello wrote:
> Some platforms support using a doorbell to communicate. Export
> this feature for other drivers to utilize as well.
> 
> Link: https://lore.kernel.org/linux-i2c/20220916131854.687371-3-jsd@semihalf.com/
> Suggested-by: Jan Dabros <jsd@semihalf.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> v2->v3:
>  * Squash register values in
>  * Use command and button registers
>  * Correct register values for incorrect ones previously shared
>  * Use a unique mutex
> v1->v2:
>  * New patch
> ---
>  drivers/crypto/ccp/platform-access.c | 52 ++++++++++++++++++++++++++++
>  drivers/crypto/ccp/platform-access.h |  1 +
>  drivers/crypto/ccp/sp-dev.h          |  3 ++
>  drivers/crypto/ccp/sp-pci.c          |  2 ++
>  include/linux/psp-platform-access.h  | 15 ++++++++
>  include/linux/psp.h                  |  3 ++
>  6 files changed, 76 insertions(+)

With this patch I get:

  CHECK   ../drivers/crypto/ccp/platform-access.c
../drivers/crypto/ccp/platform-access.c:59:27: warning: duplicate [noderef]
../drivers/crypto/ccp/platform-access.c:59:27: error: multiple address spaces given: __iomem & __iomem
../drivers/crypto/ccp/platform-access.c:59:40: error: multiple address spaces given: __iomem & __iomem
../drivers/crypto/ccp/platform-access.c:139:30: error: multiple address spaces given: __iomem & __iomem

Please ensure that your code compiles cleanly with C=1 W=1 before
you submit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
