From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crc32-pclmul: remove useless relative addressing
Date: Sat, 7 Oct 2017 12:18:47 +0800
Message-ID: <20171007041847.GD29803@gondor.apana.org.au>
References: <alpine.LRH.2.02.1709062236370.22191@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Boyko <alexander_boyko@xyratex.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57380 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdJGETM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Oct 2017 00:19:12 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1709062236370.22191@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 06, 2017 at 10:41:21PM -0400, Mikulas Patocka wrote:
> In 32-bit mode, the x86 architecture can hold full 32-bit pointers.
> Therefore, the code that copies the current address to the %ecx register
> and uses %ecx-relative addressing is useless, we could just use absolute
> addressing.
> 
> The processors have a stack of return addresses for branch prediction. If 
> we use a call instruction and pop the return address, it desynchronizes 
> the return stack and causes branch prediction misses.
> 
> This patch also moves the data to the .rodata section.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
