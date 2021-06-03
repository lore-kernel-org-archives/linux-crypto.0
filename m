Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D23C47082
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 12:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB1376135D
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 12:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhFCMdl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:33:41 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60974 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhFCMdl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 08:33:41 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lomVv-00027y-Mm; Thu, 03 Jun 2021 20:31:55 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lomVv-0001gt-HR; Thu, 03 Jun 2021 20:31:55 +0800
Date:   Thu, 3 Jun 2021 20:31:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, wangzhou1@hisilicon.com,
        liulongfang@huawei.com
Subject: Re: [PATCH 0/4] crypto: hisilicon/qm - support the communication
 between PF and VF
Message-ID: <20210603123155.GL6161@gondor.apana.org.au>
References: <1622297737-46604-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622297737-46604-1-git-send-email-qianweili@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 29, 2021 at 10:15:33PM +0800, Weili Qian wrote:
> This patch adds support for PF and VF communications in accelerator driver,
> and updates the reset flow based on VF/PF communications.
> 
> Weili Qian (4):
>   crypto: hisilicon/qm - adjust reset interface
>   crypto: hisilicon/qm - enable PF and VFs communication
>   crypto: hisilicon/qm - add callback to support communication
>   crypto: hisilicon/qm - update reset flow
> 
>  drivers/crypto/hisilicon/qm.c | 713 +++++++++++++++++++++++++++++++++++++-----
>  drivers/crypto/hisilicon/qm.h |   1 +
>  2 files changed, 629 insertions(+), 85 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
