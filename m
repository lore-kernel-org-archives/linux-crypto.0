From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH V3] crypto/nx842: Add CRC and validation support
Date: Wed, 14 Oct 2015 10:30:13 -0400
Message-ID: <CALZtOND_g3Y6AT4HMVMTS7c0L4hx5AdxZ-bCQKSc7KogVnoQdQ@mail.gmail.com>
References: <1444337151.10131.10.camel@hbabu-laptop> <20151014142718.GD17455@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Haren Myneni <haren@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Haren Myneni <hbabu@us.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:33883 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbbJNOax (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 10:30:53 -0400
In-Reply-To: <20151014142718.GD17455@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 14, 2015 at 10:27 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Thu, Oct 08, 2015 at 01:45:51PM -0700, Haren Myneni wrote:
>>
>> This patch adds CRC generation and validation support for nx-842.
>> Add CRC flag so that nx842 coprocessor includes CRC during compression
>> and validates during decompression.
>>
>> Also changes in 842 SW compression to append CRC value at the end
>> of template and checks during decompression.
>>
>> Signed-off-by: Haren Myneni <haren@us.ibm.com>
>
> Patch applied.  Thanks.

Thanks Herbert, sorry I didn't have a chance to ack it :)

Haren, as I don't have access to the NX PowerPC hardware anymore and
you've taken this over for IBM, can you change the maintainer to
yourself?

> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
