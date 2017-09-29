From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [v2 PATCH 0/5] Bluetooth: let the crypto subsystem generate the
 ecc privkey
Date: Fri, 29 Sep 2017 13:55:33 +0200
Message-ID: <04AFC87C-6B77-43D4-90DD-B76DE304073F@holtmann.org>
References: <20170928141455.15336-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0 (Mac OS X Mail 11.0 \(3445.1.6\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-bluetooth@vger.kernel.org, linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:57935 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbdI2Lzg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2017 07:55:36 -0400
In-Reply-To: <20170928141455.15336-1-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tudor,

> That Bluetooth SMP knows about the private key is pointless, since the
> detection of debug key usage is actually via the public key portion.
> With this patch set, the Bluetooth SMP will stop keeping a copy of the
> ecdh private key. We let the crypto subsystem to generate and handle
> the ecdh private key, potentially benefiting of hardware ecc private key
> generation and retention.
> 
> Tested with selftest and with btmon and smp-tester on top of hci_vhci,
> with ecdh done in both software and hardware (through atmel-ecc driver).
> All tests passed.
> 
> RFC version can be found at:
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg28036.html
> 
> Changes in v2:
> - add patches 2, 3, 4.
> - adress Marcel's suggestions:
>  - revive the check for accidentally generated debug keys
>  - bypass the handling of private key to the crypto subsytem,
>    even when using debug keys.
> 
> 
> Tudor Ambarus (5):
>  Bluetooth: move ecdh allocation outside of ecdh_helper
>  Bluetooth: ecdh_helper - reveal error codes
>  Bluetooth: selftest - check for errors when computing ZZ
>  Bluetooth: ecdh_helper - fix leak of private key
>  Bluetooth: let the crypto subsystem generate the ecc privkey
> 
> net/bluetooth/ecdh_helper.c | 228 ++++++++++++++++++++++----------------------
> net/bluetooth/ecdh_helper.h |   9 +-
> net/bluetooth/selftest.c    |  46 +++++++--
> net/bluetooth/smp.c         | 127 +++++++++++++++---------
> 4 files changed, 240 insertions(+), 170 deletions(-)

all 5 patches have been applied to bluetooth-next tree.

Regards

Marcel
