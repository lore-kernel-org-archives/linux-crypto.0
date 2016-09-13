From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: pasemi-rng - Use linux/io.h instead of asm/io.h
Date: Tue, 13 Sep 2016 20:39:20 +0800
Message-ID: <20160913123919.GA31835@gondor.apana.org.au>
References: <1473150519-30931-1-git-send-email-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: olof@lixom.net, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, mpm@selenic.com
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36923 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751420AbcIMMjm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 08:39:42 -0400
Content-Disposition: inline
In-Reply-To: <1473150519-30931-1-git-send-email-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 06, 2016 at 01:58:39PM +0530, PrasannaKumar Muralidharan wrote:
> Checkpatch.pl warns about usage of asm/io.h. Use linux/io.h instead.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
