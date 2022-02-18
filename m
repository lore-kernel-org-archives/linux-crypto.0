Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F163FC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Feb 2022 05:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiBRFiU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Feb 2022 00:38:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiBRFiR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Feb 2022 00:38:17 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AD41A8CEA;
        Thu, 17 Feb 2022 21:38:00 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nKvxf-0005En-3q; Fri, 18 Feb 2022 16:37:44 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Feb 2022 16:37:43 +1100
Date:   Fri, 18 Feb 2022 16:37:43 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] drivers/crypto: Constify static attribute_group
Message-ID: <Yg8wp1I4IRmsXYvZ@gondor.apana.org.au>
References: <20220210202805.7750-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210202805.7750-1-rikard.falkeborn@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 09:28:02PM +0100, Rikard Falkeborn wrote:
> This series constifies a couple of static attribute_group structs that
> are not modified. This allows the compiler to put them in read-only
> memory. The patches are independent and can be applied in any order (and
> go through different trees if needed).
> 
> Rikard Falkeborn (3):
>   crypto: omap-aes - Constify static attribute_group
>   crypto: omap-sham - Constify static attribute_group
>   crypto/nx: Constify static attribute_group structs
> 
>  drivers/crypto/nx/nx-common-pseries.c | 4 ++--
>  drivers/crypto/omap-aes.c             | 2 +-
>  drivers/crypto/omap-sham.c            | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
