From: Szilveszter Ordog <slipszi@gmail.com>
Subject: Re: [PATCH] crypto: ahash - Fix handling of unaligned buffers
Date: Wed, 3 Mar 2010 00:10:19 +0100
Message-ID: <ac67d9131003021510n47414dewf36d359a315115aa@mail.gmail.com>
References: <ac67d9131002230350o9618b9apd111f0da1bba15b1@mail.gmail.com>
	 <20100302143731.GA4120@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51999 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0CBXK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Mar 2010 18:10:26 -0500
Received: by fxm19 with SMTP id 19so935740fxm.21
        for <linux-crypto@vger.kernel.org>; Tue, 02 Mar 2010 15:10:25 -0800 (PST)
In-Reply-To: <20100302143731.GA4120@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> When we get an unaligned buffer, we first process the bit from the
> start to the first aligned address. =A0Once we get to the aligned
> address everything happens as usual.
>
> So where this code is, we're trying to move to the next aligned
> address, and as ALIGN rounds down, we need to add alignmask.
> So the bug is the fact that we're adding alignmask - 1.

No, ALIGN rounds *up* (as it should). See:

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
blob;f=3Dinclude/linux/kernel.h#l40

Best regards,
Szilveszter
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
