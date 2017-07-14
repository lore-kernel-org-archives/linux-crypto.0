From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] Crypto_user: Make crypto user API available for all net
 ns
Date: Fri, 14 Jul 2017 06:51:23 +0200
Message-ID: <20170714045123.GO2631@secunet.com>
References: <692d6ab1-d737-2683-5e55-b5f838f99b01@secunet.com>
 <2290757.F5Nm8BLmaV@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: Christian Langrock <christian.langrock@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:53786 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751008AbdGNEvd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2017 00:51:33 -0400
Content-Disposition: inline
In-Reply-To: <2290757.F5Nm8BLmaV@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 13, 2017 at 04:51:10PM +0200, Stephan Müller wrote:
> Am Donnerstag, 13. Juli 2017, 16:22:32 CEST schrieb Christian Langrock:
> 
> Hi Christian,
> 
> > With this patch it's possible to use crypto user API form all
> > network namespaces, not only form the initial net ns.
> 
> Is this wise?
> 
> The crypto_user interface allows root users to change settings in the kernel 
> with a global scope. For example, you can deregister ciphers, change the prio 
> of ciphers and so on. All of that is visible on a global scale and thus should 
> not be possible from namespaces, IMHO.

It is possible to use crypto from all namespaces, so would be nice if
it would be possible to choose which algorithm to use. The problem is that
you can change the global crypto configuration from within a namespace
with this. Maybe crypto_alg_list etc. should be namespace aware first,
then each namespace can have its own configuration.
