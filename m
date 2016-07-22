From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: Max data limit for AEAD operation
Date: Fri, 22 Jul 2016 10:15:41 +0530
Message-ID: <CAFXBA=mGmKYULfSVgxfiep+_6B0H692En0ajmEdvtqYwxmMq2w@mail.gmail.com>
References: <CAFXBA==j+6fGuWrjNroGWnnBc13ev+6EB2Ae7SnwAVVxjTWBrw@mail.gmail.com>
 <20160722044019.GA17416@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36412 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbcGVEpm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jul 2016 00:45:42 -0400
Received: by mail-oi0-f50.google.com with SMTP id w18so147691564oiw.3
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2016 21:45:42 -0700 (PDT)
In-Reply-To: <20160722044019.GA17416@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Thank for reply. As such I don't have any use case. But the use case I
can think of is AEAD operation on large file using AF_ALG interface.
If user tried this he/she will get invalid TAG value.


Regards
Harsh Jain

On Fri, Jul 22, 2016 at 10:10 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> Harsh Jain <harshjain.prof@gmail.com> wrote:
>>
>> There is maximum limit of data which crypto user can send(in encrypt)
>> to get TAG in AEAD operations. We do not have update/final like
>> implementation for AEAD algo's. why is this so?
>
> Because our users haven't needed it so far.  Also algorithms like CCM
> cannot support such an operation.
>
> If you have a valid use case for it then I'll consider it.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
