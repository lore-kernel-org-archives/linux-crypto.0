Return-Path: <SRS0=VFM7=7E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF868C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 22 May 2020 14:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C715622226
	for <linux-crypto@archiver.kernel.org>; Fri, 22 May 2020 14:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgEVON3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 May 2020 10:13:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39526 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729399AbgEVON3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 May 2020 10:13:29 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jc8QK-0008Fp-S8; Sat, 23 May 2020 00:13:22 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 23 May 2020 00:13:20 +1000
Date:   Sat, 23 May 2020 00:13:20 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shukun Tan <tanshukun1@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH 0/7] crypto: hisilicon - add debugfs for DFX
Message-ID: <20200522141320.GB859@gondor.apana.org.au>
References: <1589534040-50725-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589534040-50725-1-git-send-email-tanshukun1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 15, 2020 at 05:13:53PM +0800, Shukun Tan wrote:
> In order to quickly locate bugs of the accelerator driver, this series
> add some DebugFS files.
> 
> Add counters for accelerator's IO operation path, count all normal IO
> operations and error IO operations. Add dump information of QM state
> and SQC/CQC/EQC/AEQC/SQE/CQE/EQE/AEQE.
> 
> Hui Tang (1):
>   crypto: hisilicon/hpre - add debugfs for Hisilicon HPRE
> 
> Kai Ye (1):
>   crypto: hisilicon/sec2 - add debugfs for Hisilicon SEC
> 
> Longfang Liu (3):
>   crypto: hisilicon/qm - add debugfs for QM
>   crypto: hisilicon/qm - add debugfs to the QM state machine
>   crypto: hisilicon/zip - add debugfs for Hisilicon ZIP
> 
> Shukun Tan (2):
>   crypto: hisilicon/qm - add DebugFS for xQC and xQE dump
>   crypto: hisilicon/qm - change debugfs file name from qm_regs to regs
> 
>  Documentation/ABI/testing/debugfs-hisi-hpre |  89 ++++-
>  Documentation/ABI/testing/debugfs-hisi-sec  |  94 ++++-
>  Documentation/ABI/testing/debugfs-hisi-zip  |  70 +++-
>  drivers/crypto/hisilicon/hpre/hpre.h        |  17 +
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c |  99 ++++-
>  drivers/crypto/hisilicon/hpre/hpre_main.c   |  60 +++
>  drivers/crypto/hisilicon/qm.c               | 598 ++++++++++++++++++++++++++--
>  drivers/crypto/hisilicon/qm.h               |  11 +
>  drivers/crypto/hisilicon/sec2/sec.h         |   4 +
>  drivers/crypto/hisilicon/sec2/sec_crypto.c  |  15 +-
>  drivers/crypto/hisilicon/sec2/sec_main.c    |  49 ++-
>  drivers/crypto/hisilicon/zip/zip.h          |   8 +
>  drivers/crypto/hisilicon/zip/zip_crypto.c   |   9 +-
>  drivers/crypto/hisilicon/zip/zip_main.c     |  58 +++
>  14 files changed, 1097 insertions(+), 84 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
