Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD6BC636D6
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Feb 2023 02:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbjBUCpz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Feb 2023 21:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbjBUCpy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2023 21:45:54 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA0D2387D;
        Mon, 20 Feb 2023 18:45:53 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pUIev-00DlJB-3A; Tue, 21 Feb 2023 10:45:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Feb 2023 10:45:37 +0800
Date:   Tue, 21 Feb 2023 10:45:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Danny Tsen <dtsen@linux.ibm.com>
Cc:     linux-crypto@vger.kernel.org, leitao@debian.org,
        nayna@linux.ibm.com, appro@cryptogams.org,
        linux-kernel@vger.kernel.org, ltcgcw@linux.vnet.ibm.com,
        dtsen@us.ibm.com
Subject: Re: [PATCH v4 1/6] Update Kconfig and Makefile.
Message-ID: <Y/QwUWVhaUZ8fjO7@gondor.apana.org.au>
References: <20230220204224.4907-1-dtsen@linux.ibm.com>
 <20230220204224.4907-2-dtsen@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220204224.4907-2-dtsen@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 20, 2023 at 03:42:19PM -0500, Danny Tsen wrote:
> Defined CRYPTO_AES_GCM_P10 in Kconfig to support AES/GCM
> stitched implementation for Power10 or later CPU.
> 
> Added a new module driver aes-gcm-p10-crypto.
> 
> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
> ---
>  arch/powerpc/crypto/Kconfig  | 17 +++++++++++++++++
>  arch/powerpc/crypto/Makefile | 13 +++++++++++++
>  2 files changed, 30 insertions(+)

Stephen mentioned this before, your patches must compile one-by-one.
This patch doesn't build by itself so you should fix it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
