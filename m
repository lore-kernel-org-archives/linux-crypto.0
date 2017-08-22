From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: only call put_page on referenced and used
 pages
Date: Tue, 22 Aug 2017 14:39:27 +0800
Message-ID: <20170822063927.GA5748@gondor.apana.org.au>
References: <2922624.oQubu9mOmR@positron.chronox.de>
 <3178607.Y0F1IYYMXo@tauon.chronox.de>
 <20170816093731.GA21573@gondor.apana.org.au>
 <3026257.T9F4K2f5sf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37496 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbdHVGjj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 02:39:39 -0400
Content-Disposition: inline
In-Reply-To: <3026257.T9F4K2f5sf@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 16, 2017 at 11:56:24AM +0200, Stephan Müller wrote:
> Hi Herbert,
> 
> This patch was created against the current Linus development tree.
> 
> The functional test was conducted at the time v3 was aired. The patch
> v4 is compile-tested.

Thanks!

Cc: <stable@vger.kernel.org>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
