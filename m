Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA02C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B0B2077D
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgGIM4K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 08:56:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36200 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbgGIM4K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 08:56:10 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jtW5g-0003zp-Am; Thu, 09 Jul 2020 22:55:53 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Jul 2020 22:55:52 +1000
Date:   Thu, 9 Jul 2020 22:55:52 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Barry Song <song.bao.hua@hisilicon.com>
Cc:     davem@davemloft.net, wangzhou1@hisilicon.com,
        jonathan.cameron@huawei.com, akpm@linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH v3 0/3] crypto: allow users to specify acomp hardware
 from a desired NUMA node
Message-ID: <20200709125552.GG31057@gondor.apana.org.au>
References: <20200705091900.29232-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705091900.29232-1-song.bao.hua@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jul 05, 2020 at 09:18:57PM +1200, Barry Song wrote:
> For a typical Linux server, probably there are multiple ZIP modules.
> For example, numa node0 has a compressor, numa node2 has a same module.
> Some drivers are automatically using the module near the CPU calling
> acomp_alloc.
> But it isn't necessarily correct. Just like memory allocation API like
> kmalloc and kmalloc_node. Similar optimization may be done for crypto.
> 
> -v3:
>   move to use kzalloc_node according to Herbert's comment
> -v2:
>   cleanup according to Jonathan Cameron's comment
> 
> Barry Song (3):
>   crypto: permit users to specify numa node of acomp hardware
>   crypto: hisilicon/zip - permit users to specify NUMA node
>   mm/zswap: allocate acomp on the numa node committing acomp_req[1]
> 
> [1] This patch is againest a zswap patch which has not been merged yet:
>  "[PATCH v3] mm/zswap: move to use crypto_acomp API for hardware
>  acceleration"
>  https://lkml.org/lkml/2020/6/26/95
> 
>  crypto/acompress.c                        |  8 ++++++++
>  crypto/api.c                              | 24 ++++++++++++++---------
>  crypto/internal.h                         | 23 ++++++++++++++++++----
>  drivers/crypto/hisilicon/zip/zip.h        |  2 +-
>  drivers/crypto/hisilicon/zip/zip_crypto.c |  6 +++---
>  drivers/crypto/hisilicon/zip/zip_main.c   |  5 +++--
>  include/crypto/acompress.h                | 18 +++++++++++++++++
>  include/linux/crypto.h                    |  2 ++
>  mm/zswap.c                                |  2 +-
>  9 files changed, 70 insertions(+), 20 deletions(-)

Patches 1-2 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
