Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C87C77B73
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Jun 2023 04:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjFFEOU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jun 2023 00:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjFFEOT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2023 00:14:19 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC04319C
        for <linux-crypto@vger.kernel.org>; Mon,  5 Jun 2023 21:14:15 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q6O5A-00HCJ2-2A; Tue, 06 Jun 2023 12:14:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Jun 2023 12:14:08 +0800
Date:   Tue, 6 Jun 2023 12:14:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        damian.muszynski@intel.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] crypto: qat - add missing function declaration in
 adf_dbgfs.h
Message-ID: <ZH6ykJEQo/vWAyPg@gondor.apana.org.au>
References: <20230603082853.44631-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230603082853.44631-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 03, 2023 at 09:28:53AM +0100, Giovanni Cabiddu wrote:
> The function adf_dbgfs_exit() was improperly named causing the build to
> fail when CONFIG_DEBUG_FS=n.
> 
> Rename adf_dbgfs_cleanup() as adf_dbgfs_exit().
> 
> This fixes the following build error:
>       CC [M]  drivers/crypto/intel/qat/qat_c62x/adf_drv.o
>     drivers/crypto/intel/qat/qat_c62x/adf_drv.c: In function ‘adf_cleanup_accel’:
>     drivers/crypto/intel/qat/qat_c62x/adf_drv.c:69:9: error: implicit declaration of function ‘adf_dbgfs_exit’; did you mean ‘adf_dbgfs_init’? [-Werror=implicit-function-declaration]
>        69 |         adf_dbgfs_exit(accel_dev);
>           |         ^~~~~~~~~~~~~~
>           |         adf_dbgfs_init
>     cc1: all warnings being treated as errors
>     make[2]: *** [scripts/Makefile.build:252: drivers/crypto/intel/qat/qat_c62x/adf_drv.o] Error 1
>     make[1]: *** [scripts/Makefile.build:494: drivers/crypto/intel/qat/qat_c62x] Error 2
>     make: *** [Makefile:2026: drivers/crypto/intel/qat] Error 2
> 
> Fixes: 9260db6640a6 ("crypto: qat - move dbgfs init to separate file")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202306030654.5t4qkyN1-lkp@intel.com/
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_dbgfs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
