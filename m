From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] lib/mpi: Fix umul_ppmm() for MIPS64r6
Date: Fri, 22 Dec 2017 08:59:21 +0100
Message-ID: <20171222075921.GJ28538@linux-mips.org>
References: <20171205233135.1763-1-james.hogan@mips.com>
 <20171222070808.GB27149@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Hogan <james.hogan@mips.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org,
        linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:50548 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752626AbdLVH7e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 02:59:34 -0500
Received: from localhost.localdomain ([127.0.0.1]:58482 "EHLO linux-mips.org"
        rhost-flags-OK-OK-OK-FAIL) by eddie.linux-mips.org with ESMTP
        id S23990589AbdLVH7cuKWOt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 08:59:32 +0100
Content-Disposition: inline
In-Reply-To: <20171222070808.GB27149@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 22, 2017 at 06:08:08PM +1100, Herbert Xu wrote:

> I can take this but I'd like to see an ack from someone on the
> MIPS side.

Sure:

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
