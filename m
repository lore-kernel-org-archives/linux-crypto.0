From: abed mohammad kamaluddin <abedamu@gmail.com>
Subject: Re: [RFC PATCH v1 1/1] crypto: algif_compression - User-space
 interface for compression
Date: Fri, 21 Apr 2017 21:37:48 +0530
Message-ID: <CACVarETBrCPZjEOABBQTKR52Wjv3bHxA_wg66hMDw2fNrtZmsA@mail.gmail.com>
References: <1492108494-10694-1-git-send-email-akamaluddin@cavium.com>
 <1503555.c1mqzxcg8O@positron.chronox.de> <CACVarETMxEzAhDvHkuSVqaqxRN_SLc9pY0mmVeOT1N8PbcTf5g@mail.gmail.com>
 <1869148.qqR7Ib7PBA@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        "akamaluddin@cavium.com" <akamaluddin@cavium.com>,
        pathreya@cavium.com, mchalla@cavium.com
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f182.google.com ([209.85.213.182]:36250 "EHLO
        mail-yb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162233AbdDURGu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 13:06:50 -0400
Received: by mail-yb0-f182.google.com with SMTP id s22so47720170ybe.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Apr 2017 10:06:50 -0700 (PDT)
In-Reply-To: <1869148.qqR7Ib7PBA@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 21, 2017 at 9:20 PM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:
> Am Freitag, 21. April 2017, 17:42:10 CEST schrieb abed mohammad kamaluddi=
n:
>
> Just diff the just RFCed algif_kpp with the proposed patch set for
> algif_skcipher and algif_aead. There you will see that 80% of all code is
> identical (if you disregard the different namespace). And that is the cod=
e I
> am referring to.
>
> Ciao
> Stephan

Thanks, I will use the pointer. Considering all the identical code,
the proposal to consolidate would definitely help!

Thanks,
Abed
