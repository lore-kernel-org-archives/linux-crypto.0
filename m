From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/2] crypto: skcipher AF_ALG - overhaul memory
 management
Date: Fri, 31 Mar 2017 18:33:53 +0800
Message-ID: <20170331103353.GA12223@gondor.apana.org.au>
References: <2523592.mde6d2a8Lg@positron.chronox.de>
 <1797510.JnIj36BbdJ@tauon.atsec.com>
 <20170316095248.GA11996@gondor.apana.org.au>
 <4808097.uXnqYIEybL@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:53998 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754231AbdCaKeS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2017 06:34:18 -0400
Content-Disposition: inline
In-Reply-To: <4808097.uXnqYIEybL@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 16, 2017 at 11:18:33AM +0100, Stephan Müller wrote:
> Am Donnerstag, 16. März 2017, 10:52:48 CET schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > First of all you're only limiting the amount of memory occupied
> > by the SG list which is not the same thing as the memory pinned
> > down by the actual recvmsg.
> 
> I am fully aware of that. As this was present in the code, I thought I could 
> reuse that approach.
> 
> Are you saying that you want to stop this approach? 

No you're confusing things.  Previously there was an explicit
limit on the number of pages that can be pinned.  Now you're
only indirectly limiting it by limiting the size of the metadata
through sock_kmalloc.

The end result is that you're now allowing a huge amount of user
memory to be pinned down by the system call.  This is *unacceptable*.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
