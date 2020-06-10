Return-Path: <SRS0=fgde=7X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9027C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 01:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 968DD206C3
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 01:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgFJBBB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jun 2020 21:01:01 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59160 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgFJBBA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jun 2020 21:01:00 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jip6r-0007gf-LZ; Wed, 10 Jun 2020 11:00:54 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Jun 2020 11:00:53 +1000
Date:   Wed, 10 Jun 2020 11:00:53 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net v3 1/3] esp, ah: consolidate the crypto algorithm
 selections
Message-ID: <20200610010053.GA6380@gondor.apana.org.au>
References: <20200610005402.152495-1-ebiggers@kernel.org>
 <20200610005402.152495-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610005402.152495-2-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 09, 2020 at 05:54:00PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Instead of duplicating the algorithm selections between INET_AH and
> INET6_AH and between INET_ESP and INET6_ESP, create new tristates
> XFRM_AH and XFRM_ESP that do the algorithm selections, and make these be
> selected by the corresponding INET* options.
> 
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  net/ipv4/Kconfig | 16 ++--------------
>  net/ipv6/Kconfig | 16 ++--------------
>  net/xfrm/Kconfig | 20 ++++++++++++++++++++
>  3 files changed, 24 insertions(+), 28 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
