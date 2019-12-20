Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE74C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 07:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA8C321D7D
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 07:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfLTHmE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 02:42:04 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33068 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbfLTHmE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 02:42:04 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iiCvA-0000hf-3M; Fri, 20 Dec 2019 15:42:00 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iiCv6-0007xj-B7; Fri, 20 Dec 2019 15:41:56 +0800
Date:   Fri, 20 Dec 2019 15:41:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Haren Myneni <haren@linux.ibm.com>
Cc:     mpe@ellerman.id.au, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, hch@infradead.org,
        npiggin@gmail.com, mikey@neuling.org, sukadev@linux.vnet.ibm.com
Subject: Re: [PATCH 08/10] crypto/NX: Add NX GZIP user space API
Message-ID: <20191220074156.pflm3ydpgaxtthhd@gondor.apana.org.au>
References: <1576414240.16318.4066.camel@hbabu-laptop>
 <1576415119.16318.4094.camel@hbabu-laptop>
 <20191217093334.ihvz3fzzfgjwse32@gondor.apana.org.au>
 <1576745384.12797.37.camel@hbabu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576745384.12797.37.camel@hbabu-laptop>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 19, 2019 at 12:49:44AM -0800, Haren Myneni wrote:
> 
> Virtual Accelerator Switchboard (VAS) can provide support different
> accelerators, Right now only NX is used, but possible to extend to
> others in future. Or different functionalities such as fast thread
> wakeup (VAS feature) with VAS windows. 
> 
> So looking common VAS API for any its accelerators. Need open a window /
> channel - open() and ioctl()) calls, and setup the communications with
> mapping address to NX (mmap()) and close the window. Then user space
> communicates to accelerator directly without kernel involvement.
> Specific drivers should set window attributes such as how many requests
> can be send at same time and etc. All other interfaces should be same
> for any accelerator. 
> 
> Also, since user space sends requests directly, should restrict
> malicious users to prevent overload NX (security issue). Allowing
> sysadmin to restrict /dev/crypto/nx-gzip usage. 

If you are going to place your driver through the Crypto API then
it needs to use the Crypto API interface for user-space access.
That interface is af_alg.

If this is not a good fit then I suggest that you move your API
elsewhere, perhaps to the powerpc tree where the user-space API can
then be properly reviewed.

It is not feasible to review your driver's user-space API through
the crypto tree.

> As you suggested, SW crypto API (af_alg) can be used just for NX
> compression like using API based on the accelerator functionalities. It
> is socket based API with AF_ALG socket family. But is there a way for
> sysadmin to restrict usage from user space? Need just few functions in
> struct proto. 

The af_alg interface does not operate in the manner that you
describe.  It is an interface that maps onto the underlying kernel
Crypto API operations.  We currently don't have an af_alg module
for compression, but if we did we would be closely following the
current kernel compression interface.

One key feature of af_alg is that it normally is agnostic to the
underlying implementation.  That is, even when the hardware is
absent it would seamlessly switch over to a software implementation.

I say normally because there can be exceptions, e.g., with paes
and hardware keys.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
