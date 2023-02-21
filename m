Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDAFC61DA3
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Feb 2023 02:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbjBUC7p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Feb 2023 21:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbjBUC7p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2023 21:59:45 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C98D23C72;
        Mon, 20 Feb 2023 18:59:40 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pUIsI-00DlgZ-NP; Tue, 21 Feb 2023 10:59:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Feb 2023 10:59:26 +0800
Date:   Tue, 21 Feb 2023 10:59:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Danny Tsen <dtsen@linux.ibm.com>
Cc:     linux-crypto@vger.kernel.org, leitao@debian.org,
        nayna@linux.ibm.com, appro@cryptogams.org,
        linux-kernel@vger.kernel.org, ltcgcw@linux.vnet.ibm.com,
        dtsen@us.ibm.com
Subject: Re: [PATCH v4 1/6] Update Kconfig and Makefile.
Message-ID: <Y/QzjvCSgmGKPjD8@gondor.apana.org.au>
References: <20230220204224.4907-1-dtsen@linux.ibm.com>
 <20230220204224.4907-2-dtsen@linux.ibm.com>
 <Y/QwUWVhaUZ8fjO7@gondor.apana.org.au>
 <b79673c7-a626-22e0-3e21-fc3e425f153f@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b79673c7-a626-22e0-3e21-fc3e425f153f@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 20, 2023 at 08:57:24PM -0600, Danny Tsen wrote:
> Hi Herbert,
> 
> I am not sure why my patch has to build one-by-one?  I compiled with one
> make.  Here is the output.
> 
>   CALL    scripts/checksyscalls.sh
>   DESCEND objtool
>   CC [M]  arch/powerpc/crypto/aes-gcm-p10-glue.o
>   AS [M]  arch/powerpc/crypto/aes-gcm-p10.o
>   AS [M]  arch/powerpc/crypto/ghashp8-ppc.o
>   AS [M]  arch/powerpc/crypto/aesp8-ppc.o
>   LD [M]  arch/powerpc/crypto/aes-gcm-p10-crypto.o
>   CHK     kernel/kheaders_data.tar.xz
>   MODPOST Module.symvers
>   CC [M]  arch/powerpc/crypto/aes-gcm-p10-crypto.mod.o
>   LD [M]  arch/powerpc/crypto/aes-gcm-p10-crypto.ko
> 
> Can Stephen explain why he is compiling one-by-one?  Any output I can see.

Your patch-series should be bisectable.  That is, if I apply
only the first patch, it should still build in all configurations.

Your first patch only adds the Kconfig option and Makefile rules
without any actual code.  So it will fail to build because the
code is simply not there.

Normally we put the Kconfig/Makefile update at the end of the
series to prevent this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
