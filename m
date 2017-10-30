From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] hw_random: core: Reset user selected rng by writing "" to rng_current
Date: Mon, 30 Oct 2017 18:29:44 +0530
Message-ID: <CANc+2y68HXQX4CTC8kNzEi97Z3xtthWc=nP0bAEmkpPibLTWJg@mail.gmail.com>
References: <20171027170404.21262-1-prasannatsmkumar@gmail.com> <6442aa0b-6416-35fa-4f8b-e601403029fb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:49398 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdJ3M7p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2017 08:59:45 -0400
Received: by mail-io0-f178.google.com with SMTP id n137so26938077iod.6
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2017 05:59:45 -0700 (PDT)
In-Reply-To: <6442aa0b-6416-35fa-4f8b-e601403029fb@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Harald,

On 30 October 2017 at 13:40, Harald Freudenberger
<freude@linux.vnet.ibm.com> wrote:
> That's a really good idea. I also thought about something like that.

Do you mind reviewing the code?

Thanks,
PrasannaKumar
