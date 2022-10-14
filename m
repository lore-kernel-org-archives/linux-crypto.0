Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11595C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Oct 2022 08:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiJNIXT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Oct 2022 04:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiJNIXS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Oct 2022 04:23:18 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF5FB1DEE;
        Fri, 14 Oct 2022 01:23:13 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ojFy7-00EdJV-NW; Fri, 14 Oct 2022 19:23:00 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Oct 2022 16:22:59 +0800
Date:   Fri, 14 Oct 2022 16:22:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 19/19] crypto: x86/sha - register only the best
 function
Message-ID: <Y0kcY46Z9XGx07M9@gondor.apana.org.au>
References: <20221006223151.22159-1-elliott@hpe.com>
 <20221012215931.3896-1-elliott@hpe.com>
 <20221012215931.3896-20-elliott@hpe.com>
 <Y0erL2k1PGVN4qme@sol.localdomain>
 <Y0fDo/VaEB8Gx4Ee@gondor.apana.org.au>
 <MW5PR84MB184271D5A2BAE2F2DFBA7463AB259@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR84MB184271D5A2BAE2F2DFBA7463AB259@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 13, 2022 at 10:59:08PM +0000, Elliott, Robert (Servers) wrote:
>
> I have done some testing with extra patches that do that for
> that very reason. Is there much overhead from having a module
> loaded and registered in the crypto system, but not being
> chosen for use?

I don't think it's a big deal.  The system is designed to cope
with multiple implementations and picking the best option.

IOW if the overhead is an issue then that's something we'd need to
address in the core API code rather than trying to paper over it
by reducing the number of registered algorithms.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
