Return-Path: <SRS0=/HXT=5R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BFCC43331
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 22:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7DDA2071A
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 22:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389588AbgDAWy1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Apr 2020 18:54:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42432 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389578AbgDAWy0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Apr 2020 18:54:26 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jJmFM-0004QW-J5; Thu, 02 Apr 2020 09:54:09 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Apr 2020 09:54:08 +1100
Date:   Thu, 2 Apr 2020 09:54:08 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: chtls - Fix build error without IPV6
Message-ID: <20200401225408.GB16019@gondor.apana.org.au>
References: <20200401120909.8960-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200401120909.8960-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 01, 2020 at 08:09:09PM +0800, YueHaibing wrote:
> If IPV6 is not set, build fails:
> 
> drivers/crypto/chelsio/chcr_ktls.c: In function ‘chcr_ktls_act_open_req6’:
> ./include/net/sock.h:380:37: error: ‘struct sock_common’ has no member named ‘skc_v6_rcv_saddr’; did you mean ‘skc_rcv_saddr’?
>  #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
>                                      ^
> drivers/crypto/chelsio/chcr_ktls.c:258:37: note: in expansion of macro ‘sk_v6_rcv_saddr’
>   cpl->local_ip_hi = *(__be64 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8[0];
>                                      ^~~~~~~~~~~~~~~
> 
> Add IPV6 dependency to fix this.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 62370a4f346d ("cxgb4/chcr: Add ipv6 support and statistics")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/chelsio/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Please send these patches via netdev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
