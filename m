Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040CFC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Apr 2022 08:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351501AbiDOIno (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Apr 2022 04:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351502AbiDOInH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Apr 2022 04:43:07 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023DF2FFDF;
        Fri, 15 Apr 2022 01:40:38 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nfHVK-003EZS-7x; Fri, 15 Apr 2022 18:40:36 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Apr 2022 16:40:34 +0800
Date:   Fri, 15 Apr 2022 16:40:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     conor.dooley@microchip.com
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 1/1] hwrng: mpfs - add polarfire soc hwrng support
Message-ID: <Ylkvgo8Lcpmi09x1@gondor.apana.org.au>
References: <20220408100911.1638478-1-conor.dooley@microchip.com>
 <20220408100911.1638478-2-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408100911.1638478-2-conor.dooley@microchip.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 08, 2022 at 10:09:12AM +0000, conor.dooley@microchip.com wrote:
> From: Conor Dooley <conor.dooley@microchip.com>
> 
> Add a driver to access the hardware random number generator on the
> Polarfire SoC. The hwrng can only be accessed via the system controller,
> so use the mailbox interface the system controller exposes to access the
> hwrng.
> 
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> ---
>  drivers/char/hw_random/Kconfig    |  13 ++++
>  drivers/char/hw_random/Makefile   |   1 +
>  drivers/char/hw_random/mpfs-rng.c | 104 ++++++++++++++++++++++++++++++
>  3 files changed, 118 insertions(+)
>  create mode 100644 drivers/char/hw_random/mpfs-rng.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
