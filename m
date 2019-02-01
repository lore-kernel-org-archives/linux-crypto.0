Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07231C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4FF120863
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfBAGtB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 01:49:01 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:56930 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfBAGtB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 01:49:01 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpSdF-00006o-Fq; Fri, 01 Feb 2019 14:48:57 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpSdE-0005kw-Bu; Fri, 01 Feb 2019 14:48:56 +0800
Date:   Fri, 1 Feb 2019 14:48:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/7] crypto: cleanup debugfs usage
Message-ID: <20190201064856.vslf3o2pymqxue5n@gondor.apana.org.au>
References: <20190122151422.14204-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190122151422.14204-1-gregkh@linuxfoundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 22, 2019 at 04:14:15PM +0100, Greg Kroah-Hartman wrote:
> When calling debugfs code, there is no need to ever check the return
> value of the call, as no logic should ever change if a call works
> properly or not.  Fix up a bunch of crypto-specific code to not care
> about the results of debugfs.
> 
> Greg Kroah-Hartman (7):
>   crypto: qat: no need to check return value of debugfs_create functions
>   crypto: ccrree: no need to check return value of debugfs_create
>     functions
>   crypto: axis: no need to check return value of debugfs_create
>     functions
>   crypto: cavium: zip: no need to check return value of debugfs_create
>     functions
>   crypto: cavium: nitrox: no need to check return value of
>     debugfs_create functions
>   crypto: ccp: no need to check return value of debugfs_create functions
>   crypto: caam: no need to check return value of debugfs_create
>     functions
> 
>  drivers/crypto/axis/artpec6_crypto.c          |  9 ----
>  drivers/crypto/caam/ctrl.c                    | 21 +++-----
>  drivers/crypto/caam/intern.h                  |  1 -
>  drivers/crypto/cavium/nitrox/nitrox_debugfs.c | 27 ++--------
>  drivers/crypto/cavium/nitrox/nitrox_debugfs.h |  5 +-
>  drivers/crypto/cavium/nitrox/nitrox_main.c    |  4 +-
>  drivers/crypto/cavium/zip/zip_main.c          | 52 ++++---------------
>  drivers/crypto/ccp/ccp-debugfs.c              | 36 +++----------
>  drivers/crypto/ccree/cc_debugfs.c             | 22 ++------
>  drivers/crypto/ccree/cc_debugfs.h             |  8 +--
>  drivers/crypto/ccree/cc_driver.c              |  7 +--
>  drivers/crypto/qat/qat_c3xxx/adf_drv.c        |  5 --
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      |  5 --
>  drivers/crypto/qat/qat_c62x/adf_drv.c         |  5 --
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c       |  5 --
>  drivers/crypto/qat/qat_common/adf_cfg.c       |  7 ---
>  drivers/crypto/qat/qat_common/adf_transport.c |  6 ---
>  .../qat/qat_common/adf_transport_debug.c      | 15 ------
>  drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |  5 --
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   |  5 --
>  20 files changed, 38 insertions(+), 212 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
