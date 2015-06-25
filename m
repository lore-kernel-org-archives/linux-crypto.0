From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] crypto: mv_cesa - fix up for of_get_named_gen_pool() rename
Date: Thu, 25 Jun 2015 11:41:26 -0400
Message-ID: <CAP=VYLrgVjuymafdBZXAzPmBFEdGn71cfJA29n6=nd2ie0mPyw@mail.gmail.com>
References: <CABxcv=m4juAMHaMYSB+8O8cEX+YZCJ0cArS2wN-YGpTBgWe-CA@mail.gmail.com>
 <1435221470-5382-1-git-send-email-simon.guinot@sequanux.org> <20150625153006.GA11513@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Simon Guinot <simon.guinot@sequanux.org>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
	Nadav Haklai <nadavh@marvell.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Arnaud Ebalard <arno@natisbad.org>,
	Rob Herring <robh+dt@kernel.org>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Thomas P
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36514 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbbFYPl5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2015 11:41:57 -0400
In-Reply-To: <20150625153006.GA11513@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 25, 2015 at 11:30 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Thu, Jun 25, 2015 at 10:37:50AM +0200, Simon Guinot wrote:
>> This patch fixes the following build error:
>>
>> drivers/crypto/mv_cesa.c: In function 'mv_cesa_get_sram':
>> drivers/crypto/mv_cesa.c:1037: error: implicit declaration of function 'of_get_named_gen_pool'
>> drivers/crypto/mv_cesa.c:1038: warning: assignment makes pointer from integer without a cast
>> scripts/Makefile.build:258: recipe for target 'drivers/crypto/mv_cesa.o' failed
>>
>> Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
>
> This patch doesn't compile.

As sfr pointed out, this is an interaction with a rename patch in
the akpm tree; sfr added a fixup patch here last night:

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?h=akpm

"crypto: marvell/cesa - another fix up for of_get_named_gen_pool() rename"

Paul.
--

> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
