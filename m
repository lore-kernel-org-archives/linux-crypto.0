From: "Torsten Wildschek" <wildsche@googlemail.com>
Subject: Re: Async Linux NETKEY (IPSec Stack)
Date: Tue, 5 Feb 2008 22:46:47 +0000
Message-ID: <2e688f4c0802051446s212508d7n4562acb3c28e20ac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:62942 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760659AbYBEWqs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Feb 2008 17:46:48 -0500
Received: by rn-out-0910.google.com with SMTP id i24so3158997rng.19
        for <linux-crypto@vger.kernel.org>; Tue, 05 Feb 2008 14:46:47 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

how about Loc's question regarding "Linux NETKEY change to support
asynchronous Linux CryptoAPI"? I know that there are quite a few
people interested
in that.

Cheers,
           Torsten
On Tue, 5 Feb 2008, Herbert Xu wrote:

> On Mon, Feb 04, 2008 at 10:56:27AM -0800, Loc Ho wrote:
>>
>> I just want to check on the status of Linux NETKEY change to support
>> asynchronous Linux CryptoAPI interface. Have ESP, AH, and AEAD changes to
>> make use of async API?
>>
>> In addition, I submitted async HASH and DIGEST patch over a week ago. Any
>> comments and whether it will be accepted?
>
> Sorry but I'm currently travelling so I can't give your patches the
> proper attention.  I'll look at them as soon as things quiten down
> in a couple of weeks.
>
> Thanks,
> --
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
