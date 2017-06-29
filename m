From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: wait in atomic context for an i2c crypto device to finish its
 execution
Date: Thu, 29 Jun 2017 13:05:10 +0300
Message-ID: <b55b7170-786b-3c84-483d-db05e163c14a@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:34789 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbdF2KFN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2017 06:05:13 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Herbert, all,

I need an advice. I'm writing a driver for a crypto device that
communicates over I2C. Reads and writes from/to the i2c device are
sequential, I use a lock to synchronize the requests.

There are no interrupts for the i2c client. Each request has to send
a command, to wait for an estimated time so that the device finishes to
execute the command and then to read the result.

The crypto requests can be in atomic context. The maximum execution time
of a command in my crypto device is 115 milliseconds. Using a spinlock
to synchronize the requests and udelay for waiting the device to finish
the execution will block the core for at least 115 milliseconds.
If someone floods me with requests in atomic context, the core will be
doomed.

As of now I see two possibilities when treating requests in atomic
context:
1. fallback to the software implementation and hope that it's faster
    than my hw. My device is capable of doing ecc privkey generation,
    ecdh and ecdsa.
2. use spinlock and udelay and block the core.

What would you advise me, how should I treat requests in atomic context?

Thanks,
ta
