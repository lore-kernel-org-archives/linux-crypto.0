From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: KPP questions and confusion
Date: Thu, 21 Sep 2017 15:02:30 +0300
Message-ID: <997c69ae-c17b-1c17-2ca6-69e9a616843b@microchip.com>
References: <CAJU8_nUhapH=nKkL=NEa2uW5f-vdAX3kvi5Ua7b_bA8d=BjRLQ@mail.gmail.com>
 <9580BB6F-45D8-49CD-B859-09C39FD4D7D0@holtmann.org>
 <389a9dcf-05c1-2b59-90d9-ef9de5ff640b@microchip.com>
 <625119CA-F823-4B9B-88F6-EAFFA58D965D@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kyle Rose <krose@krose.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "smueller@chronox.de" <smueller@chronox.de>,
        Nicolas Ferre - M43238 <Nicolas.Ferre@microchip.com>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:6278 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdIUMCb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 08:02:31 -0400
In-Reply-To: <625119CA-F823-4B9B-88F6-EAFFA58D965D@holtmann.org>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Marcel,

On 08/03/2017 11:40 AM, Marcel Holtmann wrote:
> Essentially we do what all other key exchange procedure do. Generate a private/public key pair, give the public key to the other side, run DH with the value from the other side. That Bluetooth SMP knows about the private key is really pointless. Since the detection of debug key usage is actually via the public key portion.

I'm working on letting the bluetooth smp benefit of the ecc private key
generation from the crypto subsystem. I will send some patches soon.

Cheers,
ta
