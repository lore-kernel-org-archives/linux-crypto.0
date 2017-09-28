From: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Subject: [v2 PATCH 0/5] Bluetooth: let the crypto subsystem generate the ecc privkey
Date: Thu, 28 Sep 2017 17:14:50 +0300
Message-ID: <20170928141455.15336-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
To: <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, <linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

That Bluetooth SMP knows about the private key is pointless, since the
detection of debug key usage is actually via the public key portion.
With this patch set, the Bluetooth SMP will stop keeping a copy of the
ecdh private key. We let the crypto subsystem to generate and handle
the ecdh private key, potentially benefiting of hardware ecc private key
generation and retention.

Tested with selftest and with btmon and smp-tester on top of hci_vhci,
with ecdh done in both software and hardware (through atmel-ecc driver).
All tests passed.

RFC version can be found at:
https://www.mail-archive.com/linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg28036.html

Changes in v2:
- add patches 2, 3, 4.
- adress Marcel's suggestions:
  - revive the check for accidentally generated debug keys
  - bypass the handling of private key to the crypto subsytem,
    even when using debug keys.


Tudor Ambarus (5):
  Bluetooth: move ecdh allocation outside of ecdh_helper
  Bluetooth: ecdh_helper - reveal error codes
  Bluetooth: selftest - check for errors when computing ZZ
  Bluetooth: ecdh_helper - fix leak of private key
  Bluetooth: let the crypto subsystem generate the ecc privkey

 net/bluetooth/ecdh_helper.c | 228 ++++++++++++++++++++++----------------------
 net/bluetooth/ecdh_helper.h |   9 +-
 net/bluetooth/selftest.c    |  46 +++++++--
 net/bluetooth/smp.c         | 127 +++++++++++++++---------
 4 files changed, 240 insertions(+), 170 deletions(-)

-- 
2.9.4
