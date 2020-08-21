Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF16EC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 08:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 994172078D
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 08:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgHUIBk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 04:01:40 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50080 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbgHUIBf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 04:01:35 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k91zP-00049V-NF; Fri, 21 Aug 2020 18:01:32 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Aug 2020 18:01:31 +1000
Date:   Fri, 21 Aug 2020 18:01:31 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v5 00/10] crypto: hisilicon/qm - misc fixes
Message-ID: <20200821080131.GP25143@gondor.apana.org.au>
References: <1597485377-2678-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597485377-2678-1-git-send-email-shenyang39@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 15, 2020 at 05:56:07PM +0800, Yang Shen wrote:
> This patchset fix some qm bugs:
> patch 1: store the string address before pass to 'strsep'
> patch 2: clear 'qp_status->used' when init the 'qp'
> patch 3: use 'dev_info_ratelimited' to avoid printk flooding.
> patch 4: fix the judgement of queue is full
> patch 7: save the vf configuration space to make sure it is available
> 	 after the 'PF' 'FLR'
> patch 8: register callback to 'pci_driver.shutdown'
> patch 9: wait for all working function finishs when remove the device
> patch 10: move the process of register alg to crypto in driver 'hisi_zip'
> 
> v5:
>  - add a error branch instead of return immediately in patch "fix wrong
>    release after using strsep"
> 
> v4:
>  - exchange the patch 'fix the call trace when unbind device' and
>    'fix the process of register algorithms to crypto' to make sure the
>    driver is stable.
> 
> v3:
>  - add the patch 10 which is aimed to fix the call trace when remove a
>    working device
> 
> v2:
>  - fix the wrong email address on patch 1
> 
> Hui Tang (1):
>   crypto: hisilicon/qm - fix judgement of queue is full
> 
> Shukun Tan (3):
>   crypto: hisilicon/qm - clear used reference count when start qp
>   crypto: hisilicon/qm - fix event queue depth to 2048
>   crypto: hisilicon/qm - fix VF not available after PF FLR
> 
> Sihang Chen (1):
>   crypto: hisilicon/qm - fix wrong release after using strsep
> 
> Weili Qian (1):
>   crypto: hisilicon/qm - fix the call trace when unbind device
> 
> Yang Shen (4):
>   crypto: hisilicon/qm - fix print frequence in hisi_qp_send
>   crypto: hisilicon/qm - fix no stop reason when use 'hisi_qm_stop'
>   crypto: hisilicon/qm - register callback function to
>     'pci_driver.shutdown'
>   crypto: hisilicon/qm - fix the process of register algorithms to
>     crypto
> 
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c |  36 ++---
>  drivers/crypto/hisilicon/hpre/hpre_main.c   |  28 ++--
>  drivers/crypto/hisilicon/qm.c               | 224 ++++++++++++++++++++++++----
>  drivers/crypto/hisilicon/qm.h               |  27 ++--
>  drivers/crypto/hisilicon/sec2/sec_crypto.c  |  35 ++---
>  drivers/crypto/hisilicon/sec2/sec_main.c    |  34 ++---
>  drivers/crypto/hisilicon/zip/zip_crypto.c   |   2 +-
>  drivers/crypto/hisilicon/zip/zip_main.c     |  49 +++---
>  8 files changed, 290 insertions(+), 145 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
