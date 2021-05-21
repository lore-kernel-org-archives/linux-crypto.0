Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A9AC433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 08:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 075046135C
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 08:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhEUIYW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 04:24:22 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56086 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231168AbhEUIYW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 04:24:22 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lk0Qo-00052Y-Om; Fri, 21 May 2021 16:22:54 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lk0Qo-0007Wj-LW; Fri, 21 May 2021 16:22:54 +0800
Date:   Fri, 21 May 2021 16:22:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] crypto: hisilicon/hpre - fix coding style
Message-ID: <20210521082254.sid6koybsxjeynqv@gondor.apana.org.au>
References: <1620800831-53346-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620800831-53346-1-git-send-email-tanghui20@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 12, 2021 at 02:27:03PM +0800, Hui Tang wrote:
> This patchset fix coding style, as follows:
> 
> Hui Tang (8):
>   crypto: hisilicon/hpre - the macro 'HPRE_ADDR' expands
>   crypto: hisilicon/hpre - init a structure member each line
>   crypto: hisilicon/hpre - replace macro with inline function
>   crypto: hisilicon/hpre - remove the macro of 'HPRE_DEV'
>   crypto: hisilicon/hpre - delete rudundant initialization
>   crypto: hisilicon/hpre - use 'GENMASK' to generate mask value
>   crypto: hisilicon/hpre - delete rudundant macro definition
>   crypto: hisilicon/hpre - add 'default' for switch statement
> 
> v1 -> v2: fix build warnings reported by kernel test robot.
> 
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c |  67 ++++++------
>  drivers/crypto/hisilicon/hpre/hpre_main.c   | 157 +++++++++++++++++-----------
>  2 files changed, 128 insertions(+), 96 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
