From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: virtio:rng: Virtio RNG devices need to be re-registered after suspend/resume
Date: Tue, 7 Nov 2017 08:44:17 +0530
Message-ID: <CANc+2y7JzcobX7wj236SD4FcimWkqBnprY1Ew7FUprOijn8U-w@mail.gmail.com>
References: <1509703041-6281-1-git-send-email-Jim.Quigley@oracle.com> <20171106070928.GF14274@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jim Quigley <Jim.Quigley@oracle.com>,
        Matt Mackall <mpm@selenic.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:51804 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753392AbdKGDOT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 22:14:19 -0500
Received: by mail-it0-f46.google.com with SMTP id o135so695866itb.0
        for <linux-crypto@vger.kernel.org>; Mon, 06 Nov 2017 19:14:18 -0800 (PST)
In-Reply-To: <20171106070928.GF14274@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 6 November 2017 at 12:39, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Nov 03, 2017 at 09:57:21AM +0000, Jim Quigley wrote:
>> moved the call to hwrng_register() out of the probe routine into the scan
>> routine. We need to call hwrng_register() after a suspend/restore cycle
>> to re-register the device, but the scan function is not invoked for the
>> restore. Add the call to hwrng_register() to virtio_restore().
>
> Patch applied.  Thanks.

My rb tag is missing in the commit.

Regards,
PrasannaKumar
