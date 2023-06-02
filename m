Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7025FC7EE2E
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jun 2023 10:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbjFBKZR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 06:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbjFBKYG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 06:24:06 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3081110FD;
        Fri,  2 Jun 2023 03:23:29 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q51wG-00G2y7-S4; Fri, 02 Jun 2023 18:23:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Jun 2023 18:23:20 +0800
Date:   Fri, 2 Jun 2023 18:23:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Allen <john.allen@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] New hardware support
Message-ID: <ZHnDGAD72iZwX3G4@gondor.apana.org.au>
References: <20230519032414.94247-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519032414.94247-1-mario.limonciello@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 18, 2023 at 10:24:11PM -0500, Mario Limonciello wrote:
> Add support for some new CCP hardware.
> 
> Patch 1 also adds protections to prevent problems with
> psp_send_platform_access_msg() when utilized with this hardware
> as it only supports platform doorbell interface.
> 
> John Allen (1):
>   crypto: ccp - Add support for PCI device 0x156E
> 
> Mario Limonciello (2):
>   crypto: ccp - Validate that platform access mailbox registers are
>     declared
>   crypto: ccp - Add support for PCI device 0x17E0
> 
>  drivers/crypto/ccp/platform-access.c |  5 ++++
>  drivers/crypto/ccp/sp-pci.c          | 43 ++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
> 
> 
> base-commit: f573db7aa528f11820dcc811bc7791b231d22b1c
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
