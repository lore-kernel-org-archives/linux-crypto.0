Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C625C282E1
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 07:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32FC2217D7
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 07:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbfDYHvG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:51:06 -0400
Received: from [5.180.42.13] ([5.180.42.13]:52390 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbfDYHvG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 03:51:06 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hJZ9o-0002JW-Lv; Thu, 25 Apr 2019 15:51:00 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hJZ9l-00026b-Hq; Thu, 25 Apr 2019 15:50:57 +0800
Date:   Thu, 25 Apr 2019 15:50:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/35] crypto: ccree: features and bug fixes for 5.2
Message-ID: <20190425075057.mc7tazhzgebkvbeq@gondor.apana.org.au>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 18, 2019 at 04:38:35PM +0300, Gilad Ben-Yossef wrote:
> A set of new features, mostly support for CryptoCell 713 
> features including protected keys, security disable mode and
> new HW revision indetification interface alongside many bug fixes.
> 
> Gilad Ben-Yossef (30):
>   crypto: testmgr: add missing self test entries for protected keys
>   crypto: ccree: move key load desc. before flow desc.
>   crypto: ccree: move MLLI desc. before key load
>   crypto: ccree: add support for sec disabled mode
>   crypto: ccree: add CPP completion handling
>   crypto: ccree: add remaining logic for CPP
>   crypto: ccree: add SM4 protected keys support
>   crypto: ccree: adapt CPP descriptor to new HW
>   crypto: ccree: read next IV from HW
>   crypto: ccree: add CID and PID support
>   crypto: ccree: fix backlog notifications
>   crypto: ccree: use proper callback completion api
>   crypto: ccree: remove special handling of chained sg
>   crypto: ccree: fix typo in debugfs error path
>   crypto: ccree: fix mem leak on error path
>   crypto: ccree: use devm_kzalloc for device data
>   crypto: ccree: use std api when possible
>   crypto: ccree: copyright header update
>   crypto: ccree: zero out internal struct before use
>   crypto: ccree: do not copy zero size MLLI table
>   crypto: ccree: remove unused defines
>   crypto: ccree: simplify fragment ICV detection
>   crypto: ccree: simplify AEAD ICV addr calculation
>   crypto: ccree: don't mangle the request assoclen
>   crypto: ccree: make AEAD sgl iterator well behaved
>   crypto: ccree: zap entire sg on aead request unmap
>   crypto: ccree: use correct internal state sizes for export
>   crypto: ccree: allow more AEAD assoc data fragments
>   crypto: ccree: don't map MAC key on stack
>   crypto: ccree: don't map AEAD key and IV on stack
> 
> Ofir Drang (5):
>   crypto: ccree: pm resume first enable the source clk
>   crypto: ccree: remove cc7x3 obsoleted AXIM configs
>   crypto: ccree: HOST_POWER_DOWN_EN should be the last CC access during
>     suspend
>   crypto: ccree: add function to handle cryptocell tee fips error
>   crypto: ccree: handle tee fips error during power management resume
> 
>  crypto/testmgr.c                        |  20 +
>  drivers/crypto/ccree/Makefile           |   1 +
>  drivers/crypto/ccree/cc_aead.c          |  81 +++-
>  drivers/crypto/ccree/cc_aead.h          |   3 +-
>  drivers/crypto/ccree/cc_buffer_mgr.c    | 341 ++++----------
>  drivers/crypto/ccree/cc_buffer_mgr.h    |   2 +-
>  drivers/crypto/ccree/cc_cipher.c        | 591 +++++++++++++++---------
>  drivers/crypto/ccree/cc_cipher.h        |   3 +-
>  drivers/crypto/ccree/cc_crypto_ctx.h    |  10 +-
>  drivers/crypto/ccree/cc_debugfs.c       |  44 +-
>  drivers/crypto/ccree/cc_debugfs.h       |   2 +-
>  drivers/crypto/ccree/cc_driver.c        | 120 ++++-
>  drivers/crypto/ccree/cc_driver.h        |  36 +-
>  drivers/crypto/ccree/cc_fips.c          |  29 +-
>  drivers/crypto/ccree/cc_fips.h          |   4 +-
>  drivers/crypto/ccree/cc_hash.c          |  64 ++-
>  drivers/crypto/ccree/cc_hash.h          |   2 +-
>  drivers/crypto/ccree/cc_host_regs.h     | 123 ++++-
>  drivers/crypto/ccree/cc_hw_queue_defs.h |  35 +-
>  drivers/crypto/ccree/cc_ivgen.c         |  11 +-
>  drivers/crypto/ccree/cc_ivgen.h         |   2 +-
>  drivers/crypto/ccree/cc_kernel_regs.h   |   2 +-
>  drivers/crypto/ccree/cc_lli_defs.h      |   4 +-
>  drivers/crypto/ccree/cc_pm.c            |  11 +-
>  drivers/crypto/ccree/cc_pm.h            |   2 +-
>  drivers/crypto/ccree/cc_request_mgr.c   | 116 +++--
>  drivers/crypto/ccree/cc_request_mgr.h   |   2 +-
>  drivers/crypto/ccree/cc_sram_mgr.c      |   7 +-
>  drivers/crypto/ccree/cc_sram_mgr.h      |   2 +-
>  29 files changed, 1068 insertions(+), 602 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
