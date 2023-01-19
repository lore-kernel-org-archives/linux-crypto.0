Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DF4C38142
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Jan 2023 09:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjASJ7K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Jan 2023 04:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjASJ7J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Jan 2023 04:59:09 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB5D53E41;
        Thu, 19 Jan 2023 01:59:07 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pIRh7-001hfk-5k; Thu, 19 Jan 2023 17:58:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 19 Jan 2023 17:58:53 +0800
Date:   Thu, 19 Jan 2023 17:58:53 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 2/4] crypto/net/tcp: Use crypto_pool for TCP-MD5
Message-ID: <Y8kUXR9BLk9Uzw1i@gondor.apana.org.au>
References: <20230118214111.394416-1-dima@arista.com>
 <20230118214111.394416-3-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118214111.394416-3-dima@arista.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 18, 2023 at 09:41:09PM +0000, Dmitry Safonov wrote:
> Use crypto_pool API that was designed with tcp_md5sig_pool in mind.
> The conversion to use crypto_pool will allow:
> - to reuse ahash_request(s) for different users
> - to allocate only one per-CPU scratch buffer rather than a new one for
>   each user
> - to have a common API for net/ users that need ahash on RX/TX fast path
> 
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>  include/net/tcp.h        |  24 +++------
>  net/ipv4/Kconfig         |   1 +
>  net/ipv4/tcp.c           | 104 ++++++++++-----------------------------
>  net/ipv4/tcp_ipv4.c      | 100 +++++++++++++++++++++----------------
>  net/ipv4/tcp_minisocks.c |  21 +++++---
>  net/ipv6/tcp_ipv6.c      |  61 +++++++++++------------
>  6 files changed, 135 insertions(+), 176 deletions(-)

I think the best option for the legacy tcp md5 code is to move
md5 over to lib/crypto like sha1 and invoke it that way.

Going through the generic Crypto API when you use a single algorithm
in synchronous mode is pointless.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
