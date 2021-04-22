Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E752C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 07:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 395C761452
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 07:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbhDVHqE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:46:04 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48690 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhDVHqE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Apr 2021 03:46:04 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lZU1c-0002yA-DZ; Thu, 22 Apr 2021 17:45:25 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 Apr 2021 17:45:24 +1000
Date:   Thu, 22 Apr 2021 17:45:24 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com, liulongfang@huawei.com
Subject: Re: [PATCH 0/4] crypto: hisilicon - adapt hardware error type
Message-ID: <20210422074524.GB14354@gondor.apana.org.au>
References: <1618230695-22775-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618230695-22775-1-git-send-email-qianweili@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 12, 2021 at 08:31:31PM +0800, Weili Qian wrote:
> This patchset changes 'err_info' to dynamic configuration and enables
> new hardware error types for Kunpeng930.
> 
> Weili Qian (4):
>   crypto: hisilicon - dynamic configuration 'err_info'
>   crypto: hisilicon - support new error types for ZIP
>   crypto: hisilicon - add new error type for SEC
>   crypto: hisilicon - enable new error types for QM
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 26 ++++++++++------
>  drivers/crypto/hisilicon/qm.c             | 28 ++++++++---------
>  drivers/crypto/hisilicon/qm.h             |  8 +++--
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 52 +++++++++++++++++++++++--------
>  drivers/crypto/hisilicon/zip/zip_main.c   | 34 +++++++++++++-------
>  5 files changed, 97 insertions(+), 51 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
