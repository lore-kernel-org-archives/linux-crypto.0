From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: (none)
Date: Wed, 1 Jun 2016 02:59:21 -0400
Message-ID: <CAH8yC8==HPONkYSoPaa9E0b4+SKnbPEPeQatBUqc_HzJbD8DAA@mail.gmail.com>
References: <20160601045943.GA31881@gondor.apana.org.au>
	<3022334.qkucHDndN1@tauon.atsec.com>
	<20160601061947.GA32424@gondor.apana.org.au>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:32932 "EHLO
	mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbcFAG7W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 02:59:22 -0400
Received: by mail-it0-f49.google.com with SMTP id v125so11154683itc.0
        for <linux-crypto@vger.kernel.org>; Tue, 31 May 2016 23:59:22 -0700 (PDT)
In-Reply-To: <20160601061947.GA32424@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 1, 2016 at 2:19 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Jun 01, 2016 at 07:53:38AM +0200, Stephan Mueller wrote:
>>
>> I thought via-rng.c covers the VIA Padlock RNG?
>
> Indeed, you're quite right.  In that case Jeffrey was the via-rng
> driver loaded?

$ cat /proc/modules | egrep -i '(via|padlock|rng)'
padlock_sha 16384 0 - Live 0x00000000
padlock_aes 16384 0 - Live 0x00000000
via_cputemp 16384 0 - Live 0x00000000
hwmon_vid 16384 1 via_cputemp, Live 0x00000000
via_rng 16384 0 - Live 0x00000000
i2c_viapro 16384 0 - Live 0x00000000
pata_via 16384 0 - Live 0x00000000
sata_via 16384 2 - Live 0x00000000

And:

$ lsmod | egrep -i '(via|padlock|rng)'
padlock_sha            16384  0
padlock_aes            16384  0
via_cputemp            16384  0
hwmon_vid              16384  1 via_cputemp
via_rng                16384  0
i2c_viapro             16384  0
pata_via               16384  0
sata_via               16384  2

And:

$ dmesg | egrep -i '(via|padlock|rng)'
[    0.124003] smpboot: CPU0: Centaur VIA C7-D Processor 1800MHz (fam:
06, model: 0d, stepping: 00)
[    0.263914] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
[    2.290795] agpgart: Detected VIA P4M900 chipset
[    2.296875] agpgart-via 0000:00:00.0: AGP aperture is 128M @ 0xf0000000
[    2.934927] sata_via 0000:00:0f.0: version 2.6
[    2.935155] sata_via 0000:00:0f.0: routed to hard irq line 6
[    2.948457] scsi host0: sata_via
[    2.967744] scsi host1: sata_via
[    2.968167] pata_via 0000:00:0f.1: version 0.3.4
[    2.976090] scsi host2: pata_via
[    2.982777] scsi host3: pata_via
[    4.339291] systemd[1]: Set hostname to <via>.
[   10.415938] VIA RNG detected
[   11.257974] hwmon_vid: Using 6-bit VID table for VIA C7-D CPU
[   12.100845] padlock_aes: Using VIA PadLock ACE for AES algorithm.
[   12.149586] padlock_sha: Using VIA PadLock ACE for SHA1/SHA256 algorithms.
[   12.633495] input: HDA VIA VT82xx Rear Mic as
/devices/pci0000:80/0000:80:01.0/sound/card0/input9
[   12.633720] input: HDA VIA VT82xx Line as
/devices/pci0000:80/0000:80:01.0/sound/card0/input10
[   12.633927] input: HDA VIA VT82xx Headphone Front as
/devices/pci0000:80/0000:80:01.0/sound/card0/input11
