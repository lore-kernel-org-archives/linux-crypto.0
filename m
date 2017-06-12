From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: [PATCH 1/1] crypto:drbg- Fixes panic in wait_for_completion call.
Date: Mon, 12 Jun 2017 12:00:49 +0530
Message-ID: <CAFXBA=kWYZuVFDqKrrBEhDZa6n6SCTwM6g9ovx-_8B=RuqHjeA@mail.gmail.com>
References: <ea78b839-5717-2edb-c073-82fa82a0b403@gmail.com>
 <12466881.1IDO9Q7xg5@positron.chronox.de> <20170610041727.GG14719@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:35362 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752086AbdFLGav (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jun 2017 02:30:51 -0400
Received: by mail-wr0-f180.google.com with SMTP id q97so84434413wrb.2
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jun 2017 23:30:50 -0700 (PDT)
In-Reply-To: <20170610041727.GG14719@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Since It's a panic BUG.  Can we push this fix to stable kernel releases?

Regards
Harsh Jain

On Sat, Jun 10, 2017 at 9:47 AM, Herbert Xu <herbert@gondor.apana.org.au> w=
rote:
> On Fri, May 26, 2017 at 12:12:51PM +0200, Stephan M=C3=BCller wrote:
>> Am Donnerstag, 25. Mai 2017, 17:23:47 CEST schrieb Harsh Jain:
>>
>> Hi Harsh,
>>
>> > Initialise ctr_completion variable before use.
>>
>> Thank you very much for catching this.
>>
>> But I think the chosen function is wrong. When we have an HMAC or Hash D=
RBG, this completion function does not need to be initialized.
>>
>> May I ask you to check this patch?
>
> Patch applied.  Thanks.
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
