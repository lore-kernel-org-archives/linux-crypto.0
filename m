Return-Path: <SRS0=waMk=NM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:47956 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbeKARnT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Nov 2018 13:43:19 -0400
Date: Thu, 1 Nov 2018 16:41:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, ard.biesheuvel@linaro.org,
        linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: fix cfb mode decryption
Message-ID: <20181101084109.lme4cd2x5wfsj2fg@gondor.apana.org.au>
References: <20181019230153.28201-1-dbaryshkov@gmail.com>
 <CAKv+Gu8eiFXoC2MWjGUG_AgDNq5rduWQN0CC4Q4BM0pjWW3B-w@mail.gmail.com>
 <1540109262.3023.6.camel@HansenPartnership.com>
 <CALT56yNN6N8J040Ce7B-FgGSyO0WngUoePp+3TsVn3PpvEQORw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALT56yNN6N8J040Ce7B-FgGSyO0WngUoePp+3TsVn3PpvEQORw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 01, 2018 at 11:32:37AM +0300, Dmitry Eremin-Solenikov wrote:
>
> Since 4.20 pull went into Linus'es tree, any change of getting these two patches
> in crypto tree?

These aren't critical enough for the current mainline so they will
go in at the next merge window.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
