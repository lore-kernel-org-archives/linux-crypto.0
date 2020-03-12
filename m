Return-Path: <SRS0=Vvbd=45=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31CBC10DCE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 12:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 856C0206E7
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 12:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgCLMjV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Mar 2020 08:39:21 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59978 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgCLMjU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Mar 2020 08:39:20 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jCN7J-00022A-HS; Thu, 12 Mar 2020 23:39:14 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Mar 2020 23:39:13 +1100
Date:   Thu, 12 Mar 2020 23:39:13 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zaibo Xu <xuzaibo@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linuxarm@huawei.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com, tanghui20@huawei.com, yekai13@huawei.com,
        liulongfang@huawei.com, qianweili@huawei.com,
        zhangwei375@huawei.com, fanghao11@huawei.com,
        forest.zhouchang@huawei.com
Subject: Re: [PATCH v3 0/5] crypto: hisilicon - Improve SEC performance
Message-ID: <20200312123913.GD28885@gondor.apana.org.au>
References: <1583373985-718-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583373985-718-1-git-send-email-xuzaibo@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 05, 2020 at 10:06:20AM +0800, Zaibo Xu wrote:
> From: Longfang Liu <liulongfang@huawei.com>
> 
> Improve SEC throughput by allocating a workqueue for each device
> instead of one workqueue for all SEC devices. What's more,
> when IOMMU translation is turned on, the plat buffer (pbuffer)
> will be reserved for small packets (<512Bytes) to
> which small packets are copied. This can avoid DMA mapping on
> user small packets and improve performance.
> 
> This series is based on:
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
> 
> Changes v2 -> v3:
> 	- Updated some comments and commit messages from Jonathan Cameron.
> 	- Removed CPU intensive workqueue flag WQ_CPU_INTENSIVE
> 	- Some small misc fixes.
> 
> Changes v1 -> v2:
> 	- Split pbuf patch into two patches.
> 	- Move 'use_pbuf' from 'qp_ctx' to TFM request.
> 	- Misc fixes on coding style.
> 
> Longfang Liu (3):
>   crypto: hisilicon/sec2 - Add iommu status check
>   crypto: hisilicon/sec2 - Update IV and MAC operation
>   crypto: hisilicon/sec2 - Add pbuffer mode for SEC driver
> 
> Shukun Tan (1):
>   crypto: hisilicon - Use one workqueue per qm instead of per qp
> 
> Ye Kai (1):
>   crypto: hisilicon/sec2 - Add workqueue for SEC driver.
> 
>  drivers/crypto/hisilicon/qm.c              |  39 ++---
>  drivers/crypto/hisilicon/qm.h              |   5 +-
>  drivers/crypto/hisilicon/sec2/sec.h        |   7 +
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 242 ++++++++++++++++++++++++-----
>  drivers/crypto/hisilicon/sec2/sec_main.c   |  51 +++++-
>  5 files changed, 281 insertions(+), 63 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
