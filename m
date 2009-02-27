From: Christian Hohnstaedt <chohnstaedt@innominate.com>
Subject: Re: [PATCH] ixp4xx_crypto panic with fragmented packets in
	scatterlist
Date: Fri, 27 Feb 2009 11:26:10 +0100
Message-ID: <20090227102609.GD6283@elara.bln.innominate.local>
References: <20090226121043.GA13749@gondor.apana.org.au> <49A6FB1D.2030807@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	chohnstaedt@innominate.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
To: Karl Hiramoto <karl@hiramoto.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:33681 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbZB0K0P (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2009 05:26:15 -0500
Content-Disposition: inline
In-Reply-To: <49A6FB1D.2030807@hiramoto.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 26, 2009 at 09:27:09PM +0100, Karl Hiramoto wrote:
> Herbert Xu wrote:
>> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>>  =20
>>> We can't merge this until _all_ of ARM has been fixed for walking
>>> scatterlist chains.
>>>    =20
>>
>> Right, this is definitely not the way to fix this bug.  Because
>> even if ARM completely supported chaining, you still have to fix
>> all the other architectures as well.
>>
>> So please just fix the driver to remove the chaining before doing
>> DMA.
>>
>>  =20
> Is there an example of how to do this somewhere?=20
>

Not needed.

Now that I know the details about the different ways of chaining
and their scope, I know how to fix my driver properly.

Patch follows, soon...

best regards
Christian

--=20
The iMac is just evidence of how dangerous vi is. Obviously Steve came =
up with
the name by accident after forgetting he was *already* in insert mode.
 =E2=80=94 dagbrown on #emacs
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
