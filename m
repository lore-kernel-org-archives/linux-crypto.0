From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/16] crypto: AF_ALG - consolidation
Date: Tue, 1 Aug 2017 17:18:15 +0800
Message-ID: <20170801091815.GA715@gondor.apana.org.au>
References: <4570630.RBIQc1aA22@positron.chronox.de>
 <88356288.VicKj4yezc@tauon.chronox.de>
 <20170801090833.GA674@gondor.apana.org.au>
 <4246082.jRinN0y4r5@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37362 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbdHAJSV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 05:18:21 -0400
Content-Disposition: inline
In-Reply-To: <4246082.jRinN0y4r5@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 01, 2017 at 11:15:50AM +0200, Stephan Müller wrote:
>
> Shall I only make the change during the merger or add these changes to the 
> modification of algif_skcipher/algif_aead?

Either way is fine.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
