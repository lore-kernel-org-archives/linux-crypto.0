From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] hwrng: pasemi-rng - Use linux/io.h instead of asm/io.h
Date: Wed, 14 Sep 2016 11:54:31 +1000
Message-ID: <87y42vnt48.fsf@concordia.ellerman.id.au>
References: <1473150519-30931-1-git-send-email-prasannatsmkumar@gmail.com> <20160913123919.GA31835@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: olof@lixom.net, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, mpm@selenic.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:37760 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754811AbcINBye (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 21:54:34 -0400
In-Reply-To: <20160913123919.GA31835@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Tue, Sep 06, 2016 at 01:58:39PM +0530, PrasannaKumar Muralidharan wrote:
>> Checkpatch.pl warns about usage of asm/io.h. Use linux/io.h instead.
>> 
>> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>
> Patch applied.  Thanks.

Oops I merged it too, my bad.

Hopefully git will work out the resolution.

cheers
