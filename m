From: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] let the crypto subsystem generate the ecc privkey
Date: Sun, 24 Sep 2017 21:35:54 +0200
Message-ID: <FF969547-CA3C-4C5A-8628-5EE8D201C165@holtmann.org>
References: <20170921154742.5631-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "bluez mailin list (linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)"
        <linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170921154742.5631-1-tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Tudor,

> That Bluetooth SMP knows about the private key is pointless, since the
> detection of debug key usage is actually via the public key portion.
> With this patch set, the Bluetooth SMP will stop keeping a copy of the
> ecdh private key, except when using debug keys. This way we let the
> crypto subsystem to generate and handle the ecdh private key,
> potentially benefiting of hardware ecc private key generation and
> retention.
> 
> Tested with selftest and with btmon and smp-tester on top of hci_vhci,
> with ecdh done in both software and hardware (through atmel-ecc driver).
> All tests passed.
> 
> Tudor Ambarus (2):
>  Bluetooth: move ecdh allocation outside of ecdh_helper
>  Bluetooth: let the crypto subsystem generate the ecc privkey
> 
> net/bluetooth/ecdh_helper.c | 138 ++++++++++++++++++--------------------------
> net/bluetooth/ecdh_helper.h |   8 ++-
> net/bluetooth/selftest.c    |  29 +++++++---
> net/bluetooth/smp.c         | 120 ++++++++++++++++++++++++--------------
> 4 files changed, 159 insertions(+), 136 deletions(-)

I only saw the cover letter and the patches never made it to the mailing list.

Regards

Marcel
