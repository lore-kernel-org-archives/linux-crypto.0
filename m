Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66BE9C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Dec 2021 04:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239746AbhLHEoM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Dec 2021 23:44:12 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57552 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235223AbhLHEoM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Dec 2021 23:44:12 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1muokv-0001BJ-C6; Wed, 08 Dec 2021 15:40:38 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 Dec 2021 15:40:37 +1100
Date:   Wed, 8 Dec 2021 15:40:37 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: x86 AES crypto alignment
Message-ID: <20211208044037.GA11399@gondor.apana.org.au>
References: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 07, 2021 at 11:32:52AM -0800, Jakub Kicinski wrote:
> Hi!
> 
> The x86 AES crypto (gcm(aes)) requires 16B alignment which is hard to
> achieve in networking. Is there any reason for this? On any moderately 
> recent Intel platform aligned and unaligned vmovdq should have the same
> performance (reportedly).

There is no such thing as an alignment requirement.  If an algorithm
specifies an alignment and you pass it a request which is unaligned,
the Crypto API will automatically align the data for you.

So what is the actual problem here?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
