From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: wait in atomic context for an i2c crypto device to finish its execution
Date: Thu, 29 Jun 2017 13:12:41 +0300
Message-ID: <CAOtvUMf4Zh2BieEyeq3p+-zgeLmiNx6YPcaQ_WRyXgJPB2aW5w@mail.gmail.com>
References: <b55b7170-786b-3c84-483d-db05e163c14a@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:36811 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbdF2KMn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2017 06:12:43 -0400
Received: by mail-yw0-f178.google.com with SMTP id t127so34917420ywc.3
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jun 2017 03:12:42 -0700 (PDT)
In-Reply-To: <b55b7170-786b-3c84-483d-db05e163c14a@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 29, 2017 at 1:05 PM, Tudor Ambarus
<tudor.ambarus@microchip.com> wrote:
> Hi, Herbert, all,
>
> I need an advice. I'm writing a driver for a crypto device that
> communicates over I2C. Reads and writes from/to the i2c device are
> sequential, I use a lock to synchronize the requests.
>
> There are no interrupts for the i2c client. Each request has to send
> a command, to wait for an estimated time so that the device finishes to
> execute the command and then to read the result.
>
> The crypto requests can be in atomic context. The maximum execution time
> of a command in my crypto device is 115 milliseconds. Using a spinlock
> to synchronize the requests and udelay for waiting the device to finish
> the execution will block the core for at least 115 milliseconds.
> If someone floods me with requests in atomic context, the core will be
> doomed.
>
> As of now I see two possibilities when treating requests in atomic
> context:
> 1. fallback to the software implementation and hope that it's faster
>    than my hw. My device is capable of doing ecc privkey generation,
>    ecdh and ecdsa.
> 2. use spinlock and udelay and block the core.
>

Perhaps I missed something but it sounds like a classic case to use a
work queue:

Have the crypto request API post a work queue item and return with -EINPROGRESS
Run all interaction with the I2C device in a work item that has no
problem sleeping for as long as you need it.
Call the completion callback from the work item.

Unless I've missed something this should work.

Hope it helps,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
