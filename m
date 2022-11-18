Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D14C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241865AbiKRJSb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241893AbiKRJRu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:17:50 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F1D8B13B;
        Fri, 18 Nov 2022 01:17:37 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ovxV8-00FYZc-MJ; Fri, 18 Nov 2022 17:17:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Nov 2022 17:17:34 +0800
Date:   Fri, 18 Nov 2022 17:17:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] crypto: hisilicon/qm - reconstruct and optimize
 the debugfs code
Message-ID: <Y3dNrlQKTweq2kJk@gondor.apana.org.au>
References: <20221112021253.34862-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112021253.34862-1-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 12, 2022 at 02:12:49AM +0000, Kai Ye wrote:
> Split a debugfs.c from qm to reduce the qm code complexity. And optimize the
> process of the command dumping. Some optimizations on command dumping in
> debugfs.c file code.
> 
> changes v1->v2:
> 	- delete a redundant line.
> changes v2->v3:
> 	- adjusting the patch sequence. modify a comment.
> 
> Kai Ye (4):
>   crypto: hisilicon/qm - delete redundant null assignment operations
>   crypto: hisilicon/qm - modify the process of regs dfx
>   crypto: hisilicon/qm - split a debugfs.c from qm
>   crypto: hisilicon/qm - the command dump process is modified
> 
>  drivers/crypto/hisilicon/Makefile         |    2 +-
>  drivers/crypto/hisilicon/debugfs.c        | 1147 +++++++++++++++++
>  drivers/crypto/hisilicon/hpre/hpre_main.c |    7 +-
>  drivers/crypto/hisilicon/qm.c             | 1360 ++-------------------
>  drivers/crypto/hisilicon/qm_common.h      |   87 ++
>  drivers/crypto/hisilicon/sec2/sec_main.c  |    7 +-
>  drivers/crypto/hisilicon/zip/zip_main.c   |    7 +-
>  include/linux/hisi_acc_qm.h               |    8 +-
>  8 files changed, 1356 insertions(+), 1269 deletions(-)
>  create mode 100644 drivers/crypto/hisilicon/debugfs.c
>  create mode 100644 drivers/crypto/hisilicon/qm_common.h
> 
> -- 
> 2.17.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
