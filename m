From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RESEND] lib/mpi: fix build with clang
Date: Thu, 17 Aug 2017 17:00:21 +0800
Message-ID: <20170817090021.GC25646@gondor.apana.org.au>
References: <20170807173120.15463-1-stefan@agner.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stefan Agner <stefan@agner.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:47610 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdHQJAm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2017 05:00:42 -0400
Content-Disposition: inline
In-Reply-To: <20170807173120.15463-1-stefan@agner.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 07, 2017 at 10:31:20AM -0700, Stefan Agner wrote:
> Use just @ to denote comments which works with gcc and clang.
> Otherwise clang reports an escape sequence error:
>   error: invalid % escape in inline assembly string
> 
> Use %0-%3 as operand references, this avoids:
>   error: invalid operand in inline asm: 'umull ${1:r}, ${0:r}, ${2:r}, ${3:r}'
> 
> Also remove superfluous casts on output operands to avoid warnings
> such as:
>   warning: invalid use of a cast in an inline asm context requiring an l-value
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
