From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: algif for compression?
Date: Thu, 3 Apr 2014 14:03:30 -0400
Message-ID: <CALZtONA3xqBG=6n0UERJ=Ve7DEH1P5ZVu5C_dRN0Tt324MjvFw@mail.gmail.com>
References: <CALZtONBFtCqQEfOgjNs_MqLm0xXP+9QK47a1t_HE4DuUBkxpsg@mail.gmail.com>
 <20140403124136.GA32279@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:38526 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaDCSDw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Apr 2014 14:03:52 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so2284695wes.15
        for <linux-crypto@vger.kernel.org>; Thu, 03 Apr 2014 11:03:51 -0700 (PDT)
In-Reply-To: <20140403124136.GA32279@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 3, 2014 at 8:41 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Dan Streetman <ddstreet@ieee.org> wrote:
>> I see the algif_hash and algif_blkcipher implementations to allow
>> userspace AF_ALG socket access to kernel blkcipher and hash
>> algorithms, but has anyone done a algif_compression to allow userspace
>> access to compression algs?  I'm asking specifically wrt the 842
>> crypto module, which uses the hardware compression coprocessors on
>> newer powerpc systems.
>>
>> If not, is there any reason against adding a algif_compression to
>> provide the access?
>
> For a start nx-842 isn't even hooked into the crypto layer so
> there is no chance of exporting it through algif as is.

Wait, isn't it?  The crypto/842.c driver connects right to it.  Well,
it connects to the compression part of it, but that's the only part
I'm looking at exporting to userspace right now.



> There is no reason why you couldn't add it of course but that'd
> be a first step.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
