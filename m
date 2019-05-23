Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63837C04AAC
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AE6B20879
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfEWGuv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 02:50:51 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:47762 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfEWGuv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 02:50:51 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hThYs-0001mD-G2; Thu, 23 May 2019 14:50:46 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hThYp-0006AI-QT; Thu, 23 May 2019 14:50:43 +0800
Date:   Thu, 23 May 2019 14:50:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Yann Droneaud <ydroneaud@opteya.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v6] crypto: DRBG - add FIPS 140-2 CTRNG for noise source
Message-ID: <20190523065043.j3pvpevnvr7i3h53@gondor.apana.org.au>
References: <1852500.fyBc0DU23F@positron.chronox.de>
 <1654549.mqJkfNR9fV@positron.chronox.de>
 <74c517ac2c654a7372af731a67e24743c843e157.camel@opteya.com>
 <1778495.GGYfhorZbc@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1778495.GGYfhorZbc@tauon.chronox.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 08, 2019 at 04:19:24PM +0200, Stephan Mueller wrote:
> FIPS 140-2 section 4.9.2 requires a continuous self test of the noise
> source. Up to kernel 4.8 drivers/char/random.c provided this continuous
> self test. Afterwards it was moved to a location that is inconsistent
> with the FIPS 140-2 requirements. The relevant patch was
> e192be9d9a30555aae2ca1dc3aad37cba484cd4a .
> 
> Thus, the FIPS 140-2 CTRNG is added to the DRBG when it obtains the
> seed. This patch resurrects the function drbg_fips_continous_test that
> existed some time ago and applies it to the noise sources. The patch
> that removed the drbg_fips_continous_test was
> b3614763059b82c26bdd02ffcb1c016c1132aad0 .
> 
> The Jitter RNG implements its own FIPS 140-2 self test and thus does not
> need to be subjected to the test in the DRBG.
> 
> The patch contains a tiny fix to ensure proper zeroization in case of an
> error during the Jitter RNG data gathering.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/drbg.c         | 94 +++++++++++++++++++++++++++++++++++++++++--
>  include/crypto/drbg.h |  2 +
>  2 files changed, 93 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
