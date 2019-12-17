Return-Path: <SRS0=akto=2H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CE2C43603
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 09:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE2312082E
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 09:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfLQJdn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 04:33:43 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:41860 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfLQJdm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 04:33:42 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ih9EX-0005Te-TL; Tue, 17 Dec 2019 17:33:37 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ih9EU-0007G3-H7; Tue, 17 Dec 2019 17:33:34 +0800
Date:   Tue, 17 Dec 2019 17:33:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Haren Myneni <haren@linux.ibm.com>
Cc:     mpe@ellerman.id.au, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, hch@infradead.org,
        npiggin@gmail.com, mikey@neuling.org, sukadev@linux.vnet.ibm.com
Subject: Re: [PATCH 08/10] crypto/NX: Add NX GZIP user space API
Message-ID: <20191217093334.ihvz3fzzfgjwse32@gondor.apana.org.au>
References: <1576414240.16318.4066.camel@hbabu-laptop>
 <1576415119.16318.4094.camel@hbabu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576415119.16318.4094.camel@hbabu-laptop>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 15, 2019 at 05:05:19AM -0800, Haren Myneni wrote:
> 
> On power9, userspace can send GZIP compression requests directly to NX
> once kernel establishes NX channel / window. This patch provides GZIP
> engine access to user space via /dev/crypto/nx-gzip device node with
> open, VAS_TX_WIN_OPEN ioctl, mmap and close operations.
> 
> Each window corresponds to file descriptor and application can open
> multiple windows. After the window is opened, mmap() system call to map
> the hardware address of engine's request queue into the application's
> virtual address space.
> 
> Then the application can then submit one or more requests to the the
> engine by using the copy/paste instructions and pasting the CRBs to
> the virtual address (aka paste_address) returned by mmap().
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Signed-off-by: Haren Myneni <haren@us.ibm.com>
> ---
>  drivers/crypto/nx/Makefile            |   2 +-
>  drivers/crypto/nx/nx-842-powernv.h    |   2 +
>  drivers/crypto/nx/nx-commom-powernv.c |  21 ++-
>  drivers/crypto/nx/nx-gzip-powernv.c   | 282 ++++++++++++++++++++++++++++++++++
>  4 files changed, 304 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/crypto/nx/nx-gzip-powernv.c

We already have a kernel compress API which could be exposed
to user-space through af_alg.  If every driver created their
own user-space API it would be unmanageable.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
