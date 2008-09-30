From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: CTS (cipher text stealing mode) and short packets
Date: Tue, 30 Sep 2008 22:33:19 +0800
Message-ID: <E1KkgHv-00011M-OJ@gondolin.me.apana.org.au>
References: <f9d2a5e10809292008i48e66474hbde8c7723b848c50@mail.gmail.com>
Cc: kwc@citi.umich.edu, linux-crypto@vger.kernel.org
To: russ.dill@gmail.com (Russ Dill)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55893 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752599AbYI3Od2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Sep 2008 10:33:28 -0400
In-Reply-To: <f9d2a5e10809292008i48e66474hbde8c7723b848c50@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Russ Dill <russ.dill@gmail.com> wrote:
>
> I worked with this a bit, and since the IV has to be modified, it was
> just easier to check for nbytes less than or equal to block size in my
> own code and then back up src/dest pointers by iv_size and increase
> the size by iv_size. (My IV is prepended to my data). On decryption I
> do something similar by adding a buffer for the output of the IV.

I suggest that we fix the CTS algorithm (i.e., give it a block size
of 1 instead of whatever it is now, plus make it work properly for
input equal or less than a block), and then implement RFC3962 on
top of it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
