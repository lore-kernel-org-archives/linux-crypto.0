From: Michael Ellerman <patch-notifications@ellerman.id.au>
Subject: Re: hwrng: pasemi-rng - Use linux/io.h instead of asm/io.h
Date: Tue, 13 Sep 2016 22:16:37 +1000 (AEST)
Message-ID: <3sYNvT6H6Yz9t1T@ozlabs.org>
References: <1473150519-30931-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        olof@lixom.net, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        mpm@selenic.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:39035 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754762AbcIMMQj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 08:16:39 -0400
In-Reply-To: <1473150519-30931-1-git-send-email-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2016-06-09 at 08:28:39 UTC, PrasannaKumar Muralidharan wrote:
> Checkpatch.pl warns about usage of asm/io.h. Use linux/io.h instead.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/63019f3cab99c7acd27df5a5b8

cheers
