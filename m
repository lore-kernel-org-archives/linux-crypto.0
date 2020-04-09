Return-Path: <SRS0=VxYc=5Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3B2C2BA2B
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Apr 2020 02:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 256522074F
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Apr 2020 02:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgDICbf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Apr 2020 22:31:35 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38492 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgDICbf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Apr 2020 22:31:35 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jMMxf-0003kw-TV; Thu, 09 Apr 2020 12:30:37 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Apr 2020 12:30:35 +1000
Date:   Thu, 9 Apr 2020 12:30:35 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb4/chcr: fix building without IPv6
Message-ID: <20200409023035.GA27525@gondor.apana.org.au>
References: <20200408185330.190658-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408185330.190658-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 08, 2020 at 08:53:06PM +0200, Arnd Bergmann wrote:
> When IPv6 support is completely disabled, the chelsio driver fails
> to build with
> 
> drivers/crypto/chelsio/chcr_ktls.c: In function 'chcr_ktls_act_open_req6':
> include/net/sock.h:380:37: error: 'struct sock_common' has no member named 'skc_v6_rcv_saddr'; did you mean 'skc_rcv_saddr'?
>   380 | #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
>       |                                     ^~~~~~~~~~~~~~~~
> drivers/crypto/chelsio/chcr_ktls.c:258:37: note: in expansion of macro 'sk_v6_rcv_saddr'
>   258 |  cpl->local_ip_hi = *(__be64 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8[0];
>       |                                     ^~~~~~~~~~~~~~~
> drivers/crypto/chelsio/chcr_ktls.c:260:36: note: in expansion of macro 'sk_v6_daddr'
>   260 |  cpl->peer_ip_hi = *(__be64 *)&sk->sk_v6_daddr.in6_u.u6_addr8[0];
>       |                                    ^~~~~~~~~~~
> drivers/crypto/chelsio/chcr_ktls.c:261:36: note: in expansion of macro 'sk_v6_daddr'
>   261 |  cpl->peer_ip_lo = *(__be64 *)&sk->sk_v6_daddr.in6_u.u6_addr8[8];
>       |                                    ^~~~~~~~~~~
> drivers/crypto/chelsio/chcr_ktls.c:296:27: note: in expansion of macro 'sk_v6_daddr'
>   296 |       ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
>       |                           ^~~~~~~~~~~
> drivers/crypto/chelsio/chcr_ktls.c:303:29: note: in expansion of macro 'sk_v6_rcv_saddr'
>   303 |           (const u32 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8,
>       |                             ^~~~~~~~~~~~~~~
> drivers/crypto/chelsio/chcr_ktls.c: In function 'chcr_ktls_dev_del':
> drivers/crypto/chelsio/chcr_ktls.c:401:26: note: in expansion of macro 'sk_v6_daddr'
>   401 |        (const u32 *)&sk->sk_v6_daddr.in6_u.u6_addr8,
>       |                          ^~~~~~~~~~~
> drivers/crypto/chelsio/chcr_ktls.c: In function 'chcr_ktls_dev_add':
> drivers/crypto/chelsio/chcr_ktls.c:495:27: note: in expansion of macro 'sk_v6_daddr'
>   495 |       ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
>       |                           ^~~~~~~~~~~
> drivers/crypto/chelsio/chcr_ktls.c:498:22: note: in expansion of macro 'sk_v6_daddr'
>   498 |   memcpy(daaddr, sk->sk_v6_daddr.in6_u.u6_addr8, 16);
>       |                      ^~~~~~~~~~~
> 
> There is probably a good way to fix it, but this patch just adds a
> bunch of #if checks to get it to build again, which gets a bit
> ugly.
> 
> Fixes: 62370a4f346d ("cxgb4/chcr: Add ipv6 support and statistics")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> If you have a better idea to fix it, please send a different patch
> instead and treat this as a bug report. ;-)
> ---
>  drivers/crypto/chelsio/chcr_ktls.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)

Please send all chelsio patches via netdev.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
