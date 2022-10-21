Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D31C43219
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Oct 2022 11:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiJULey (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Oct 2022 07:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiJULet (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2022 07:34:49 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221FF2A27A;
        Fri, 21 Oct 2022 04:34:29 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1olqHa-004dkC-S1; Fri, 21 Oct 2022 19:34:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Oct 2022 19:34:23 +0800
Date:   Fri, 21 Oct 2022 19:34:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>, stable@vger.kernel.org,
        Rijo-john Thomas <Rijo-john.Thomas@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: Add support for TEE for PCI ID 0x14CA
Message-ID: <Y1KDvwO3UoF0A5xS@gondor.apana.org.au>
References: <20220928184506.13981-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928184506.13981-1-mario.limonciello@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 28, 2022 at 01:45:05PM -0500, Mario Limonciello wrote:
> SoCs containing 0x14CA are present both in datacenter parts that
> support SEV as well as client parts that support TEE.
> 
> Cc: stable@vger.kernel.org # 5.15+
> Tested-by: Rijo-john Thomas <Rijo-john.Thomas@amd.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/crypto/ccp/sp-pci.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
