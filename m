Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3340BC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 013AB218A2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfAYKAp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:00:45 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:44266 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfAYKAp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 05:00:45 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gmyHi-0004lp-GK; Fri, 25 Jan 2019 18:00:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gmyHR-0007Vp-TN; Fri, 25 Jan 2019 18:00:09 +0800
Date:   Fri, 25 Jan 2019 18:00:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, qat-linux@intel.com
Subject: Re: [RFC PATCH v2] akcipher: Introduce verify_rsa/verify for public
 key algorithms
Message-ID: <20190125100009.i2ggpc7k7qvzayvj@gondor.apana.org.au>
References: <20190116164703.9267-1-vt@altlinux.org>
 <24887.1547658740@warthog.procyon.org.uk>
 <20190116182719.j6ii6nmn4ciiurqr@altlinux.org>
 <20190118204100.6o3ovctanb62nvd2@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190118204100.6o3ovctanb62nvd2@altlinux.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 18, 2019 at 11:41:00PM +0300, Vitaly Chikunov wrote:
>
> a) RSA verify works differently (is it just disguised encrypt),
> b) We have separate wrapper module for it (pkcs1pad). Thus:
> 
> Old API can not be removed. In other words, we can not replace
> .verify_rsa with .verify in these drivers or PKCS1 will not work.
> 
> We can replace .verify_rsa with .verify in pkcs1pad, but there is no
> need for that if we stay with two API calls, which we can't avoid.

I think having two API calls during a transition period is fine.
But it must not be the long-term outcome.

In order to keep existing drivers working, I think we should make
the API wrap the legacy verify_rsa and implement verify directly
on top of it.  IOW the driver remains unchanged for now but the
crypto API code should provide a verify API that is implemented
on top of the driver's verify_rsa call.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
