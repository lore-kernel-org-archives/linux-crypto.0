From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: geode-rng - Use linux/io.h instead of asm/io.h
Date: Tue, 13 Sep 2016 20:42:57 +0800
Message-ID: <20160913124257.GG31835@gondor.apana.org.au>
References: <1473607466-25929-1-git-send-email-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, linux-geode@lists.infradead.org,
        linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53894 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754558AbcIMMnG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 08:43:06 -0400
Content-Disposition: inline
In-Reply-To: <1473607466-25929-1-git-send-email-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 11, 2016 at 08:54:26PM +0530, PrasannaKumar Muralidharan wrote:
> Fix checkpatch.pl warning by changing from asm/io.h to linux/io.h. In
> the mean time arrange the includes in alphabetical order.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
