Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808A1C61DB3
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Jan 2023 11:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjA0LAi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Jan 2023 06:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjA0LAc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Jan 2023 06:00:32 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAC622A1D;
        Fri, 27 Jan 2023 03:00:29 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pLMT3-004hGN-Sj; Fri, 27 Jan 2023 19:00:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Jan 2023 19:00:25 +0800
Date:   Fri, 27 Jan 2023 19:00:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        John Allen <john.allen@amd.com>
Subject: Re: [PATCH] crypto: ccp - Provide MMIO register naming for
 documenation
Message-ID: <Y9OuydD3Cx/cODsR@gondor.apana.org.au>
References: <f345e88d664a6d6bb112eaae0e1d74d96d2e132b.1673899406.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f345e88d664a6d6bb112eaae0e1d74d96d2e132b.1673899406.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 16, 2023 at 02:03:26PM -0600, Tom Lendacky wrote:
> Add comments next to the version data MMIO register values to identify
> the register name being used.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  drivers/crypto/ccp/sp-pci.c | 46 ++++++++++++++++++-------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
