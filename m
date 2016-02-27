From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] lib/mpi: avoid assembler warning
Date: Sat, 27 Feb 2016 20:35:32 +0100
Message-ID: <20160227193532.GF9123@gondor.apana.org.au>
References: <1456490794-1034544-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44815 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992545AbcB0Tfu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2016 14:35:50 -0500
Content-Disposition: inline
In-Reply-To: <1456490794-1034544-1-git-send-email-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 26, 2016 at 01:46:26PM +0100, Arnd Bergmann wrote:
> A wrapper around the umull assembly instruction might reuse
> the input register as an output, which is undefined on
> some ARM machines, as pointed out by this assembler warning:
> 
>   CC      lib/mpi/generic_mpih-mul1.o
> /tmp/ccxJuxIy.s: Assembler messages:
> /tmp/ccxJuxIy.s:53: rdhi, rdlo and rm must all be different
>   CC      lib/mpi/generic_mpih-mul2.o
> /tmp/ccI0scAD.s: Assembler messages:
> /tmp/ccI0scAD.s:53: rdhi, rdlo and rm must all be different
>   CC      lib/mpi/generic_mpih-mul3.o
> /tmp/ccMvVQcp.s: Assembler messages:
> /tmp/ccMvVQcp.s:53: rdhi, rdlo and rm must all be different
> 
> This changes the constraints to force different registers to
> be used as output.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Both applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
