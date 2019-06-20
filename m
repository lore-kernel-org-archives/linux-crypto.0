Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA14C43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 01:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E703208CB
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 01:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbfFTBOC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 21:14:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50312 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730815AbfFTBOC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 21:14:02 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hdleI-0005Sl-Mh; Thu, 20 Jun 2019 09:13:58 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hdldl-0006f1-NM; Thu, 20 Jun 2019 09:13:25 +0800
Date:   Thu, 20 Jun 2019 09:13:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v3 1/6] crypto: essiv - create wrapper template for ESSIV
 generation
Message-ID: <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org>
 <20190620010417.GA722@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620010417.GA722@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 19, 2019 at 06:04:17PM -0700, Eric Biggers wrote:
>
> > +#define ESSIV_IV_SIZE		sizeof(u64)	// IV size of the outer algo
> > +#define MAX_INNER_IV_SIZE	16		// max IV size of inner algo
> 
> Why does the outer algorithm declare a smaller IV size?  Shouldn't it just be
> the same as the inner algorithm's?

In general we allow outer algorithms to have distinct IV sizes
compared to the inner algorithm.  For example, rfc4106 has a
different IV size compared to gcm.

In this case, the outer IV size is the block number so that's
presumably why 64 bits is sufficient.  Do you forsee a case where
we need 128-bit block numbers?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
