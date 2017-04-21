From: abed mohammad kamaluddin <abedamu@gmail.com>
Subject: Re: [RFC PATCH v1 1/1] crypto: algif_compression - User-space
 interface for compression
Date: Fri, 21 Apr 2017 21:12:10 +0530
Message-ID: <CACVarETMxEzAhDvHkuSVqaqxRN_SLc9pY0mmVeOT1N8PbcTf5g@mail.gmail.com>
References: <1492108494-10694-1-git-send-email-akamaluddin@cavium.com>
 <1492108494-10694-2-git-send-email-akamaluddin@cavium.com> <1503555.c1mqzxcg8O@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        "akamaluddin@cavium.com" <akamaluddin@cavium.com>,
        pathreya@cavium.com, mchalla@cavium.com
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35248 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425452AbdDUTmZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 15:42:25 -0400
Received: by mail-io0-f174.google.com with SMTP id r16so126615746ioi.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Apr 2017 12:42:25 -0700 (PDT)
In-Reply-To: <1503555.c1mqzxcg8O@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On Tue, Apr 18, 2017 at 3:42 PM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:
> Am Donnerstag, 13. April 2017, 20:34:54 CEST schrieb Abed Kamaluddin:
>
> May I propose that you look into the patches for skcipher and aead regard=
ing
> memory handling updates that are currently discussed. There you will find=
 the
> sendmsg code with two parts:
>
> 1. checking of the input data of cmsg and setting the ctx respectively.
>
> 2. the big while loop for getting all user space data
>
> I guess you have seen that I would like to consolidate the algif
> implementations once the memory handling patch is in and agreed on. My pl=
an
> is: Bullet 1 will be private to the algif implementation, so leave your c=
ode.
> Bullet 2 will be moved into a common service function. Thus, may I propos=
e
> that you simply copy the entire while loop with the same TX data structur=
es
> into your sendmsg code. This way you do not have the mentioned limit.
>
> Also, simply copy the sendpage code from the patch set to support splice/
> vmsplice.
>

Thanks for the suggestions and helpful pointers, I will rework the
patch and incorporate these, hoping that the compression interface
will be exported. These changes would also remain unaffected by any
changes to the acomp interface.

Thanks
Abed (Cavium)
Regards,
