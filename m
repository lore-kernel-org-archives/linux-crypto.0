Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CC6C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 09:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiKYJrx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 04:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiKYJrA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 04:47:00 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14613E0BE;
        Fri, 25 Nov 2022 01:45:48 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oyVHC-000hy0-VO; Fri, 25 Nov 2022 17:45:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Nov 2022 17:45:42 +0800
Date:   Fri, 25 Nov 2022 17:45:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Fix list iterator in padata_do_serial()
Message-ID: <Y4COxhOZk1wcEbzy@gondor.apana.org.au>
References: <20221117012804.62514-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117012804.62514-1-daniel.m.jordan@oracle.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 16, 2022 at 08:28:04PM -0500, Daniel Jordan wrote:
> list_for_each_entry_reverse() assumes that the iterated list is nonempty
> and that every list_head is embedded in the same type, but its use in
> padata_do_serial() breaks both rules.
> 
> This doesn't cause any issues now because padata_priv and padata_list
> happen to have their list fields at the same offset, but we really
> shouldn't be relying on that.
> 
> Fixes: bfde23ce200e ("padata: unbind parallel jobs from specific CPUs")
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
>  kernel/padata.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
