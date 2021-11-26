Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75F0C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 05:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358647AbhKZFhb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 00:37:31 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57156 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242823AbhKZFfb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 00:35:31 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mqTqM-0008RY-7r; Fri, 26 Nov 2021 13:32:18 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mqTqK-0004Zq-KG; Fri, 26 Nov 2021 13:32:16 +0800
Date:   Fri, 26 Nov 2021 13:32:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH 0/4] crypto: hisilicon/qm - misc clean up and fixes
Message-ID: <20211126053216.GE17477@gondor.apana.org.au>
References: <20211120044739.5667-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120044739.5667-1-yekai13@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 20, 2021 at 12:47:35PM +0800, Kai Ye wrote:
> 1. Modify the value of qos initialization in resetting.
> 2. Some optimizations.
> 
> Kai Ye (4):
>   crypto: hisilicon - modify the value of engine type rate
>   crypto: hisilicon/qm - modify the value of qos initialization
>   crypto: hisilicon/qm - some optimizations of ths qos write process
>   crypto: hisilicon/qm - simplified the calculation of qos shaper
>     parameters
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c |   2 +-
>  drivers/crypto/hisilicon/qm.c             | 183 +++++++++++++---------
>  drivers/crypto/hisilicon/sec2/sec_main.c  |   2 +-
>  drivers/crypto/hisilicon/zip/zip_main.c   |   4 +-
>  4 files changed, 112 insertions(+), 79 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
