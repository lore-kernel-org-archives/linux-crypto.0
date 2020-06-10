Return-Path: <SRS0=fgde=7X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9646C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 01:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7684C206C3
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 01:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgFJBBO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jun 2020 21:01:14 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59176 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgFJBBN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jun 2020 21:01:13 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jip78-0007ig-Iy; Wed, 10 Jun 2020 11:01:11 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Jun 2020 11:01:10 +1000
Date:   Wed, 10 Jun 2020 11:01:10 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net v3 3/3] esp, ah: modernize the crypto algorithm
 selections
Message-ID: <20200610010110.GC6380@gondor.apana.org.au>
References: <20200610005402.152495-1-ebiggers@kernel.org>
 <20200610005402.152495-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610005402.152495-4-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 09, 2020 at 05:54:02PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The crypto algorithms selected by the ESP and AH kconfig options are
> out-of-date with the guidance of RFC 8221, which lists the legacy
> algorithms MD5 and DES as "MUST NOT" be implemented, and some more
> modern algorithms like AES-GCM and HMAC-SHA256 as "MUST" be implemented.
> But the options select the legacy algorithms, not the modern ones.
> 
> Therefore, modify these options to select the MUST algorithms --
> and *only* the MUST algorithms.
> 
> Also improve the help text.
> 
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Suggested-by: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  net/ipv4/Kconfig | 21 +++++++++++++++++++--
>  net/ipv6/Kconfig | 21 +++++++++++++++++++--
>  net/xfrm/Kconfig | 15 +++++++++------
>  3 files changed, 47 insertions(+), 10 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
