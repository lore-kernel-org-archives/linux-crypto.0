Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F94EC49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 09:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33F5E208C2
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 09:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbfIMJRt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 05:17:49 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33530 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387424AbfIMJRt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 05:17:49 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i8hhm-0007jT-F3; Fri, 13 Sep 2019 19:17:27 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Sep 2019 19:17:18 +1000
Date:   Fri, 13 Sep 2019 19:17:18 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Zhou Wang <wangzhou1@hisilicon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Hao Fang <fanghao11@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: hisilicon - avoid unused function warning
Message-ID: <20190913091718.GA6382@gondor.apana.org.au>
References: <20190906152250.1450649-1-arnd@arndb.de>
 <20190906152250.1450649-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906152250.1450649-2-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 06, 2019 at 05:22:30PM +0200, Arnd Bergmann wrote:
> The only caller of hisi_zip_vf_q_assign() is hidden in an #ifdef,
> so the function causes a warning when CONFIG_PCI_IOV is disabled:
> 
> drivers/crypto/hisilicon/zip/zip_main.c:740:12: error: unused function 'hisi_zip_vf_q_assign' [-Werror,-Wunused-function]
> 
> Move it into the same #ifdef.
> 
> Fixes: 79e09f30eeba ("crypto: hisilicon - add SRIOV support for ZIP")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/hisilicon/zip/zip_main.c | 2 ++
>  1 file changed, 2 insertions(+)

Please find a way to fix this warning without reducing compiler
coverage.  I prefer to see any compile issues immediately rather
than through automated build testing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
