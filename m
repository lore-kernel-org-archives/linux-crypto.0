From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AF_ALG - consolidation of duplicate code
Date: Wed, 16 Aug 2017 17:37:31 +0800
Message-ID: <20170816093731.GA21573@gondor.apana.org.au>
References: <2922624.oQubu9mOmR@positron.chronox.de>
 <2012469.Yss5hQnVpr@tauon.chronox.de>
 <20170816082917.GA21246@gondor.apana.org.au>
 <3178607.Y0F1IYYMXo@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58662 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbdHPJhm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2017 05:37:42 -0400
Content-Disposition: inline
In-Reply-To: <3178607.Y0F1IYYMXo@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 16, 2017 at 10:39:43AM +0200, Stephan Mueller wrote:
>
> Are you feeding that patch to the Linus 4.13-rc tree via your crypto-2.6 tree?

Good point.  Why don't you repost that patch and I'll push it
to 4.13 along with stable.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
