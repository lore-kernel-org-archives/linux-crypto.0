Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46604C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Dec 2021 11:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhLaLfI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Dec 2021 06:35:08 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58794 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229727AbhLaLfH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Dec 2021 06:35:07 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n3GBd-0004vM-2r; Fri, 31 Dec 2021 22:35:06 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Dec 2021 22:35:04 +1100
Date:   Fri, 31 Dec 2021 22:35:04 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com
Subject: Re: [PATCH] crypto: KDF - select SHA-256 required for self-test
Message-ID: <Yc7q6NHG339T9bn5@gondor.apana.org.au>
References: <2576506.vuYhMxLoTh@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2576506.vuYhMxLoTh@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 21, 2021 at 08:31:42PM +0100, Stephan Müller wrote:
> The self test of the KDF is based on SHA-256. Thus, this algorithm must
> be present as otherwise a warning is issued.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
