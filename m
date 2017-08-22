From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: Re: [PATCH 0/6] Add support for ECDSA algorithm
Date: Tue, 22 Aug 2017 13:22:48 -0400
Message-ID: <CACXcFmk5mAfjW=SSQm7SM7oP0orwrFJ6m5UaXVB76VwMyXcyKQ@mail.gmail.com>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
 <20170123142417.GD19957@gondor.apana.org.au> <113d3ef8-ef34-0651-71e7-be09ef55727e@nvidia.com>
 <20170202135721.GA5289@gondor.apana.org.au> <87fcb3cf-b8ae-47de-550e-c76ae47af431@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Nitin Kumbhar <nkumbhar@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35572 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdHVRWu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 13:22:50 -0400
Received: by mail-wr0-f196.google.com with SMTP id p8so20736886wrf.2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Aug 2017 10:22:50 -0700 (PDT)
In-Reply-To: <87fcb3cf-b8ae-47de-550e-c76ae47af431@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 22, 2017 at 12:14 PM, Tudor Ambarus
<tudor.ambarus@microchip.com> wrote:
> Hi, Herbert,
>
> On 02/02/2017 03:57 PM, Herbert Xu wrote:
>>
>> Yes but RSA had an in-kernel user in the form of module signature
>> verification.  We don't add algorithms to the kernel without
>> actual users.  So this patch-set needs to come with an actual
>> in-kernel user of ECDSA.
>
>
> ECDSA can be used by the kernel module signing facility too. Is there
> any interest in using ECDSA by the kernel module signing facility?

I'd say keep it simple wherever possible; adding an algorithm should
need "is required by" not just "can be used by".

Even then, there is room for questions. In particular, whether such a
fragile algorithm should be trusted at all, let alone for signatures
on infrastructure modules that the whole OS will trust.
https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm#Security
