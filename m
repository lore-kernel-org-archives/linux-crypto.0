From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: Kernel panic when using ccm(aes) with the Atmel AES HW
 accelerator
Date: Mon, 23 Oct 2017 15:38:59 +0300
Message-ID: <39a43561-e0e6-a3b7-e2c0-bd7e6bf1be47@microchip.com>
References: <CAGkQfmP6Kq4DEBbGU7AW71PjbUJ2acdJF5PVDm6VqZkUaaoEzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
To: Romain Izard <romain.izard.pro@gmail.com>,
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:40510 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932093AbdJWMjA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 08:39:00 -0400
In-Reply-To: <CAGkQfmP6Kq4DEBbGU7AW71PjbUJ2acdJF5PVDm6VqZkUaaoEzA@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Romain,

On 10/18/2017 04:32 PM, Romain Izard wrote:
> my fix also led to a
> systematic oops when running the ccm(aes) test case.

The NULL deference appears because of a memory corruption issue.

atmel-aes does not implement ccm(aes), so the algorithm will be in the
following form: ccm_base(atmel-ctr-aes,cbcmac(aes-generic)).

ccm auth uses the first byte of the IV as length and eventually will
memset memory to zero based on that length (see set_msg_len()). CTR
overwrites the iv with the last ciphertext block and the length will be
wrong.

I will propose a fix, but I'm taking my time to better understand why
CTR requires to overwrite the iv with the last ciphertext block.

Cheers,
ta
