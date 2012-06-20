From: "cloudy.linux" <cloudy.linux@gmail.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Wed, 20 Jun 2012 21:31:10 +0800
Message-ID: <4FE1D09E.4040104@gmail.com>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com> <1339806021-14271-1-git-send-email-gmbnomis@gmail.com> <20120618134718.GL9122@philter.vipri.net> <20120618201235.GA20755@schnuecks.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, andrew@lunn.ch,
	Simon Baatz <gmbnomis@gmail.com>
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2FTNbZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Jun 2012 09:31:25 -0400
Received: by pbbrp8 with SMTP id rp8so614178pbb.19
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jun 2012 06:31:25 -0700 (PDT)
In-Reply-To: <20120618201235.GA20755@schnuecks.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Phil

On 2012-6-19 4:12, Simon Baatz wrote:
> I see one effect that I don't fully understand.
> Similar to the previous implementation, the system is mostly in
> kernel space when accessing an encrypted dm-crypt device:

Today I also compiled the patched 3.5.0-rc3 for another NAS box with 
MV88F6282-Rev-A0 (LS-WVL), I noticed one thing that when the CESA engine 
was used, the interrupt number of mv_crypto kept rising, but the 
interrupt number of mv_tdma was always zero.

$ cat /proc/interrupts
            CPU0
   1:      31296  orion_irq  orion_tick
   5:          2  orion_irq  mv_xor.0
   6:          2  orion_irq  mv_xor.1
   7:          2  orion_irq  mv_xor.2
   8:          2  orion_irq  mv_xor.3
  11:      23763  orion_irq  eth0
  19:          0  orion_irq  ehci_hcd:usb1
  21:       4696  orion_irq  sata_mv
  22:      64907  orion_irq  mv_crypto
  33:        432  orion_irq  serial
  46:         51  orion_irq  mv643xx_eth
  49:          0  orion_irq  mv_tdma
  53:          0  orion_irq  rtc-mv
107:          0         -  GPIO fan alarm
109:          0         -  function
110:          0         -  power-on
111:          0         -  power-auto
Err:          0

Is this normal?

Regards
Cloudy
