Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3107E28A708;
	Wed,  7 May 2025 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746631671; cv=none; b=nPd/0VkYmPY+LmUTQw5/Ud/+LsV6d6q5S2xz4IxA/BymM2XI/mFp0kKbTqPgR93XmJUoPZnwVoJi0HasU0sgQsprtd1oH56iCJnrdP2zo/bF5K/xkP2MLenJ6I+GnnhXPyv6rf4cUxhx3kvZ46fuphH1FyooNEEuFh1fkMVuoVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746631671; c=relaxed/simple;
	bh=lyteN3mT+gHGRfUPu0ey95R8VeNYgyyRoI4wt7YKNA8=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:CC:
	 References:From:In-Reply-To; b=b/4BP0Box+0wJCggOTvEsbHfXSITjEny6i9FYIt8uU5wpBbz3jAAzEq9UhB+8t1E2izjR04SUIVCAB07GfBe3dNOCmDVI2TZMQdTysxNY4rkpwswWOmgX6ZY/Fi7xYwwjYpXAam0dGZgYV7a2Q184Y0Q0wiLEr45rHHo//RR2Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=kLRWxp/Z; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="kLRWxp/Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1746631665; x=1778167665;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=lyteN3mT+gHGRfUPu0ey95R8VeNYgyyRoI4wt7YKNA8=;
  b=kLRWxp/Zwe3PI8UkZhI4JVO3zMfethKvvspZJg/w0JqxW0u3/X8sstel
   LrbQ7vaYi+A5MBHkh9bsOpdf6vs9C4X4cvrY1UGgGyYLpj0+/p/ez0p0j
   NDGnfdhhv5MUnAM8wJmYvJwFCa9KpEWQJ9jByqAzHwq7o8DWVL+IU3j3n
   Cdfbe3UwZb4NCPuz+U2tBjKMnbmrJKJIoY5csDzIOHjIdV9SD7SGpoFiu
   SKmeDaLsvcscwzi1guSQtTvmmF8W6UD235rftsM4m6GX05rdgPzD37hyY
   yAG00shWw04VFLQgSoX6Hx/hatPFBtwwHHlXFbVugDghta9bzV0JNLrxn
   w==;
X-CSE-ConnectionGUID: DnHl/QgLSzyXAf9ZoO9Ttw==
X-CSE-MsgGUID: VF5ZcOcsSkqTyDjDAX5uOA==
X-IronPort-AV: E=Sophos;i="6.15,269,1739862000"; 
   d="txt'?scan'208";a="41335205"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 May 2025 08:27:42 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 7 May 2025 08:27:20 -0700
Received: from [10.10.179.162] (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.44 via Frontend
 Transport; Wed, 7 May 2025 08:27:20 -0700
Content-Type: multipart/mixed;
	boundary="------------IiVGqNEXBdR9oytAp3x20l1x"
Message-ID: <9a725b81-9fed-4713-b56f-5b182f95e97a@microchip.com>
Date: Wed, 7 May 2025 08:27:18 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: crypto self-test errors kernel 6.12.4
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <468a8e17-d564-441d-9893-72b0ed48d8bb@microchip.com>
 <aBqvJJdXMcBpp9mC@gondor.apana.org.au>
From: Ryan Wanner <ryan.wanner@microchip.com>
Content-Language: en-US
In-Reply-To: <aBqvJJdXMcBpp9mC@gondor.apana.org.au>

--------------IiVGqNEXBdR9oytAp3x20l1x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On 5/6/25 17:53, Herbert Xu wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, May 06, 2025 at 01:12:31PM -0700, Ryan Wanner wrote:
>> Hello,
>>
>> I upgraded my ARM kernel from v6.6.9 to v6.12.4 and I am seeing some
>> crypto self test errors that I did not see before. Shown below. These
>> errors are different every boot and I did not see them on 6.6.9 kernel.
>> I did notice that when I compile the crypto HW acceleration drivers as
>> modules like this:
>> CONFIG_CRYPTO_DEV_ATMEL_AES [=m]
>> CONFIG_CRYPTO_DEV_ATMEL_TDES [=m]
>> CONFIG_CRYPTO_DEV_ATMEL_SHA [=m]
>>
>> and have them loaded by systemd at boot I do not get errors and all the
>> self tests pass.
>>
>> Is there a race condition I am not aware of? Or is the new asynchronous
>> crypto tests creating bugs in the HW acceleration drivers.
> 
> Yes that's entirely possible as I think it was around that time
> when the self-tests became concurrent.
> 
>> DRBG: could not allocate digest TFM handle: hmac(sha512)
>> alg: drbg: Failed to reset rng
>> alg: drbg: Test 0 failed for drbg_nopr_hmac_sha512
>> alg: self-tests for stdrng using drbg_nopr_hmac_sha512 failed (rc=-22)
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 90 at crypto/testmgr.c:5928 0xc0397fd0
>> alg: self-tests for stdrng using drbg_nopr_hmac_sha512 failed (rc=-22)
>>
>> alg: hash: error allocating hmac(sha512-generic) (generic impl of
>> hmac(sha512)): -17
>> alg: self-tests for hmac(sha512) using atmel-hmac-sha512 failed (rc=-17)
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 53 at crypto/testmgr.c:5928 0xc0397fd0
>> alg: self-tests for hmac(sha512) using atmel-hmac-sha512 failed (rc=-17)
> 
> 17 is EEXIST, that may actually point to a bug in the Crypto API
> itself.
> 
> Could you please test the current mainline kernel and send me the
> complete bootup messages and kconfig file?
Yes the config file is attached and here is the boot log, looks like it
is fixed on v6.15-rc5 and I do not see the error. Is there multiple
commits that fix this or where the async tests have been disabled?

[    0.031506] VFP support v0.3: implementor 41 architecture 2 part 30
variant 5 rev 1
[    0.032147] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.032204] posixtimers hash table entries: 512 (order: -1, 2048
bytes, linear)
[    0.032241] futex hash table entries: 256 (order: -1, 3072 bytes, linear)
[    0.032533] pinctrl core: initialized pinctrl subsystem
[    0.036040] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.037840] DMA: preallocated 256 KiB pool for atomic coherent
allocations
[    0.079843] AT91: PM: standby: standby, suspend: ulp1
[    0.090557] at_xdmac f0010000.dma-controller: 16 channels, mapped at
0x(ptrval)
[    0.094459] at_xdmac f0004000.dma-controller: 16 channels, mapped at
0x(ptrval)
[    0.096591] AT91: Detected SoC family: sama5d2
[    0.096620] AT91: Detected SoC: sama5d27c 128MiB SiP, revision 2
[    0.098172] SCSI subsystem initialized
[    0.098831] usbcore: registered new interface driver usbfs
[    0.098981] usbcore: registered new interface driver hub
[    0.099136] usbcore: registered new device driver usb
[    0.100549] mc: Linux media interface: v0.10
[    0.100732] videodev: Linux video capture interface: v2.00
[    0.100885] pps_core: LinuxPPS API ver. 1 registered
[    0.100901] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
[    0.100958] PTP clock support registered
[    0.101721] Advanced Linux Sound Architecture Driver Initialized.
[    0.108737] clocksource: Switched to clocksource timer@f800c000
[    0.144332] NET: Registered PF_INET protocol family
[    0.144895] IP idents hash table entries: 2048 (order: 2, 16384
bytes, linear)
[    0.146341] tcp_listen_portaddr_hash hash table entries: 1024 (order:
0, 4096 bytes, linear)
[    0.146430] Table-perturb hash table entries: 65536 (order: 6, 262144
bytes, linear)
[    0.146465] TCP established hash table entries: 1024 (order: 0, 4096
bytes, linear)
[    0.146512] TCP bind hash table entries: 1024 (order: 1, 8192 bytes,
linear)
[    0.146586] TCP: Hash tables configured (established 1024 bind 1024)
[    0.146873] UDP hash table entries: 256 (order: 1, 8192 bytes, linear)
[    0.146966] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes,
linear)
[    0.147424] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.149199] RPC: Registered named UNIX socket transport module.
[    0.149242] RPC: Registered udp transport module.
[    0.149253] RPC: Registered tcp transport module.
[    0.149262] RPC: Registered tcp-with-tls transport module.
[    0.149271] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.154450] Initialise system trusted keyrings
[    0.155880] workingset: timestamp_bits=30 max_order=15 bucket_order=0
[    0.158372] Key type asymmetric registered
[    0.158416] Asymmetric key parser 'x509' registered
[    0.158555] io scheduler mq-deadline registered
[    0.158576] io scheduler kyber registered
[    0.158641] io scheduler bfq registered
[    0.187923] gpio gpiochip0: Static allocation of GPIO base is
deprecated, use dynamic allocation.
[    0.190718] pinctrl-at91-pio4 fc038000.pinctrl: atmel pinctrl initialized
[    0.214761] random: crng init done
[    0.222400] brd: module loaded
[    0.239383] loop: module loaded
[    0.242092] atmel_usart_serial.0.auto: ttyS0 at MMIO 0xf8020000 (irq
= 151, base_baud = 5125000) is a ATMEL_SERIAL
[    0.242218] printk: legacy console [ttyS0] enabled
[    0.687597] atmel_usart_serial.1.auto: ttyS2 at MMIO 0xf8024000 (irq
= 152, base_baud = 5125000) is a ATMEL_SERIAL
[    0.700150] atmel_usart_serial.2.auto: ttyS1 at MMIO 0xfc00c000 (irq
= 153, base_baud = 5125000) is a ATMEL_SERIAL
[    0.712898] at91_i2c f8038600.i2c: can't get DMA channel, continue
without DMA support
[    0.719611] at91_i2c f8038600.i2c: Using FIFO (16 data)
[    0.723887] i2c i2c-2: using pinctrl states for GPIO recovery
[    0.728377] i2c i2c-2: using generic GPIOs for recovery
[    0.732425] at91_i2c f8038600.i2c: AT91 i2c bus driver (hw version:
0x704).
[    0.747571] atmel_spi f8000000.spi: Using dma0chan0 (tx) and
dma0chan1 (rx) for DMA transfers
[    0.754933] atmel_spi f8000000.spi: Using FIFO (16 data)
[    0.759909] atmel_spi f8000000.spi: Atmel SPI Controller version
0x311 at 0xf8000000 (irq 155)
[    0.768335] atmel_spi fc018400.spi: Atmel SPI Controller using PIO only
[    0.773811] atmel_spi fc018400.spi: Using FIFO (16 data)
[    0.778822] atmel_spi fc018400.spi: Atmel SPI Controller version
0x311 at 0xfc018400 (irq 156)
[    0.789489] spi-nor spi2.0: supply vcc not found, using dummy regulator
[    0.795347] spi-nor spi2.0: unrecognized JEDEC id bytes: ff ff ff ff
ff ff
[    0.804591] CAN device driver interface
[    0.810025] m_can_platform fc050000.can: m_can device registered
(irq=158, version=31)
[    0.825259] macb f8008000.ethernet eth0: Cadence GEM rev 0x00020203
at 0xf8008000 irq 159 (54:10:ec:2e:bc:36)
[    0.839339] atmel-ehci 500000.usb: EHCI Host Controller
[    0.843259] atmel-ehci 500000.usb: new USB bus registered, assigned
bus number 1
[    0.849607] atmel-ehci 500000.usb: irq 162, io mem 0x00500000
[    0.868840] atmel-ehci 500000.usb: USB 2.0 started, EHCI 1.00
[    0.873765] usb usb1: New USB device found, idVendor=1d6b,
idProduct=0002, bcdDevice= 6.15
[    0.880681] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    0.886487] usb usb1: Product: EHCI Host Controller
[    0.890051] usb usb1: Manufacturer: Linux 6.15.0-rc5+ ehci_hcd
[    0.894480] usb usb1: SerialNumber: 500000.usb
[    0.899558] hub 1-0:1.0: USB hub found
[    0.902077] hub 1-0:1.0: 3 ports detected
[    0.908309] at91_ohci 400000.usb: USB Host Controller
[    0.912179] at91_ohci 400000.usb: new USB bus registered, assigned
bus number 2
[    0.918338] at91_ohci 400000.usb: irq 162, io mem 0x00400000
[    0.983346] usb usb2: New USB device found, idVendor=1d6b,
idProduct=0001, bcdDevice= 6.15
[    0.990283] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    0.996097] usb usb2: Product: USB Host Controller
[    0.999565] usb usb2: Manufacturer: Linux 6.15.0-rc5+ ohci_hcd
[    1.003995] usb usb2: SerialNumber: at91
[    1.008217] hub 2-0:1.0: USB hub found
[    1.010848] hub 2-0:1.0: 3 ports detected
[    1.016157] usbcore: registered new interface driver cdc_acm
[    1.020536] cdc_acm: USB Abstract Control Model driver for USB modems
and ISDN adapters
[    1.027342] usbcore: registered new interface driver usb-storage
[    1.032393] usbcore: registered new interface driver usbserial_generic
[    1.037599] usbserial: USB Serial support registered for generic
[    1.042387] usbcore: registered new interface driver ftdi_sio
[    1.046799] usbserial: USB Serial support registered for FTDI USB
Serial Device
[    1.053087] usbcore: registered new interface driver pl2303
[    1.057336] usbserial: USB Serial support registered for pl2303
[    1.062811] atmel_usba_udc 300000.gadget: MMIO registers at [mem
0xfc02c000-0xfc02c3ff] mapped at ee15e529
[    1.071301] atmel_usba_udc 300000.gadget: FIFO at [mem
0x00300000-0x003fffff] mapped at 9669f7ea
[    1.082632] g_serial gadget.0: Gadget Serial v2.4
[    1.085981] g_serial gadget.0: g_serial ready
[    1.092454] at91_rtc f80480b0.rtc: registered as rtc0
[    1.096226] at91_rtc f80480b0.rtc: setting system clock to
2012-01-01T00:00:06 UTC (1325376006)
[    1.103667] at91_rtc f80480b0.rtc: AT91 Real Time Clock driver.
[    1.108597] i2c_dev: i2c /dev entries driver
[    1.113722] at91-reset f8048000.reset-controller: Starting after
regular power-up
[    1.123041] sama5d4_wdt f8048040.watchdog: initialized (timeout = 16
sec, nowayout = 0)
[    1.130765] sdhci: Secure Digital Host Controller Interface driver
[    1.135544] sdhci: Copyright(c) Pierre Ossman
[    1.138907] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.144154] atmel_aes f002c000.crypto: version: 0x500
[    1.158056] atmel_sha f0028000.crypto: version: 0x510
[    1.162186] atmel_sha f0028000.crypto: using dma0chan2 for DMA transfers
[    1.167707] atmel_sha f0028000.crypto: Atmel
SHA1/SHA256/SHA224/SHA384/SHA512
[    1.174659] atmel_tdes fc044000.crypto: version: 0x703
[    1.179082] atmel_tdes fc044000.crypto: using dma0chan3, dma0chan4
for DMA transfers
[    1.185520] atmel_tdes fc044000.crypto: Atmel DES/TDES
[    1.190059] usbcore: registered new interface driver usbhid
[    1.194235] usbhid: USB HID core driver
[    1.204308] at91-sama5d2_adc fc030000.adc: setting up trigger as
external_rising
[    1.210433] at91-sama5d2_adc fc030000.adc: version: 800
[    1.217979] NET: Registered PF_INET6 protocol family
[    1.225262] Segment Routing with IPv6
[    1.227667] In-situ OAM (IOAM) with IPv6
[    1.230535] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    1.236773] NET: Registered PF_PACKET protocol family
[    1.240556] can: controller area network core
[    1.243688] NET: Registered PF_CAN protocol family
[    1.247092] can: raw protocol
[    1.248837] can: broadcast manager protocol
[    1.251664] can: netlink gateway - max_hops=1
[    1.266988] Loading compiled-in X.509 certificates
[    1.284032] mmc0: SDHCI controller on a0000000.sdio-host
[a0000000.sdio-host] using ADMA
[    1.291764] mmc1: SDHCI controller on b0000000.sdio-host
[b0000000.sdio-host] using ADMA
[    1.300028] alg: extra crypto tests enabled.  This is intended for
developer use only.
[    1.429094] mmc0: new UHS-I speed DDR50 SDHC card at address aaaa
[    1.461653] mmcblk0: mmc0:aaaa SS08G 7.40 GiB
[    1.704472] at91_i2c f8028000.i2c: can't get DMA channel, continue
without DMA support
[    1.711159] at91_i2c f8028000.i2c: Using FIFO (16 data)
[    1.816319]  mmcblk0: p1 p2
[    1.969404] i2c i2c-0: using pinctrl states for GPIO recovery
[    1.973946] i2c i2c-0: using generic GPIOs for recovery
[    1.978599] at24 0-0050: supply vcc not found, using dummy regulator
[    2.288634] at24 0-0050: 256 byte 24c02 EEPROM, writable, 8 bytes/write
[    2.294188] at91_i2c f8028000.i2c: AT91 i2c bus driver (hw version:
0x704).
[    2.301058] at91_i2c fc028000.i2c: can't get DMA channel, continue
without DMA support
[    2.307588] at91_i2c fc028000.i2c: Using FIFO (16 data)
[    2.751622] i2c i2c-1: using pinctrl states for GPIO recovery
[    2.756163] i2c i2c-1: using generic GPIOs for recovery
[    2.760236] at91_i2c fc028000.i2c: AT91 i2c bus driver (hw version:
0x704).
[    2.766955] atmel_aes f002c000.crypto: version: 0x500
[    3.300037] alg: No test for authenc(hmac(sha224),cbc(aes))
(atmel-authenc-hmac-sha224-cbc-aes)
[    3.390806] alg: No test for authenc(hmac(sha384),cbc(aes))
(atmel-authenc-hmac-sha384-cbc-aes)
[    3.403220] atmel_aes f002c000.crypto: Atmel AES - Using dma0chan5,
dma0chan6 for DMA transfers
[    3.603869] input: gpio-keys as /devices/platform/gpio-keys/input/input0
[    3.721661] cfg80211: Loading compiled-in X.509 certificates for
regulatory database
[   19.265485] Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   19.283255] Loaded X.509 cert 'wens:
61c038651aabdcf94bd0ac7ff06c7248db18c600'
[   19.289233] clk: Disabling unused clocks
[   19.292079] ALSA device list:
[   19.293674]   No soundcards found.
[   19.296309] platform regulatory.0: Direct firmware load for
regulatory.db failed with error -2
[   19.303617] cfg80211: failed to load regulatory.db
[   19.311497] atmel_usart_serial atmel_usart_serial.0.auto: using
dma0chan7 for rx DMA transfers
[   19.319039] atmel_usart_serial atmel_usart_serial.0.auto: using
dma0chan8 for tx DMA transfers
[   19.457448] EXT4-fs (mmcblk0p2): mounted filesystem
5df2fad9-8036-4769-97fa-b516397d778d r/w with ordered data mode. Quota
mode: disabled.
[   19.468755] VFS: Mounted root (ext4 filesystem) on device 179:2.
[   19.478947] devtmpfs: mounted
[   19.484235] Freeing unused kernel image (initmem) memory: 1024K
[   19.489031] Run /sbin/init as init process
[   19.491742]   with arguments:
[   19.491757]     /sbin/init
[   19.491772]   with environment:
[   19.491785]     HOME=/
[   19.491800]     TERM=linux
[   19.898247] systemd[1]: System time before build time, advancing clock.
[   19.960333] systemd[1]: Inserted module 'autofs4'
[   20.009317] systemd[1]: systemd 256.7 running in system mode (-PAM
-AUDIT -SELINUX -APPARMOR -IMA -SMACK +SECCOMP +GCRYPT -GNUTLS +OPENSSL
+ACL +BLKID -CURL -ELFUTILS -FIDO2 -IDN2 -IDN +IPTC +KMOD -LIBCRYPTSETUP
-LIBCRYPTSETUP_PLUGINS +LIBFDISK +PCRE2 -PWQUALITY +P11KIT -QRENCODE
-TPM2 -BZIP2 -LZ4 -XZ +ZLIB -ZSTD -BPF_FRAMEWORK -XKBCOMMON -UTMP
-SYSVINIT -LIBARCHIVE)
[   20.040431] systemd[1]: Detected architecture arm.
[   20.086534] systemd[1]: Hostname set to <sama5>.
[   20.734422] systemd-ssh-generator[231]: Binding SSH to AF_UNIX socket
/run/ssh-unix-local/socket.
[   20.748622] systemd-ssh-generator[231]: \xe2\x86\x92 connect via 'ssh
.host' locally
[   22.262610] systemd[1]: Queued start job for default target
Multi-User System.
[   22.324413] systemd[1]: Created slice Slice /system/modprobe.
[   22.353431] systemd[1]: Created slice Slice /system/serial-getty.
[   22.380399] systemd[1]: Started Dispatch Password Requests to Console
Directory Watch.
[   22.410241] systemd[1]: Started Forward Password Requests to Wall
Directory Watch.
[   22.439663] systemd[1]: Expecting device /dev/ttyS0...
[   22.460081] systemd[1]: Reached target NFS client services.
[   22.489982] systemd[1]: Reached target Path Units.
[   22.519619] systemd[1]: Reached target Preparation for Remote File
Systems.
[   22.549537] systemd[1]: Reached target Remote File Systems.
[   22.579525] systemd[1]: Reached target Slice Units.
[   22.609801] systemd[1]: Reached target Swaps.
[   22.713530] systemd[1]: Listening on Credential Encryption/Decryption.
[   22.763716] systemd[1]: Journal Audit Socket was skipped because of
an unmet condition check (ConditionSecurity=audit).
[   22.775403] systemd[1]: Listening on Journal Socket (/dev/log).
[   22.801220] systemd[1]: Listening on Journal Sockets.
[   22.831682] systemd[1]: Listening on Network Service Netlink Socket.
[   22.861217] systemd[1]: Listening on udev Control Socket.
[   22.890753] systemd[1]: Listening on udev Kernel Socket.
[   22.921087] systemd[1]: Huge Pages File System was skipped because of
an unmet condition check (ConditionPathExists=/sys/kernel/mm/hugepages).
[   22.934598] systemd[1]: POSIX Message Queue File System was skipped
because of an unmet condition check
(ConditionPathExists=/proc/sys/fs/mqueue).
[   23.015204] systemd[1]: Mounting Kernel Debug File System...
[   23.050831] systemd[1]: Kernel Trace File System was skipped because
of an unmet condition check (ConditionPathExists=/sys/kernel/tracing).
[   23.170019] systemd[1]: Mounting Temporary Directory /tmp...
[   23.220713] systemd[1]: Starting Create List of Static Device Nodes...
[   23.294964] systemd[1]: Starting Load Kernel Module configfs...
[   23.390674] systemd[1]: Starting Load Kernel Module efi_pstore...
[   23.480741] systemd[1]: Starting Load Kernel Module fuse...
[   23.540826] systemd[1]: File System Check on Root Device was skipped
because of an unmet condition check (ConditionPathIsReadWrite=!/).
[   23.602242] systemd[1]: systemd-journald.service: unit configures an
IP firewall, but the local system does not support BPF/cgroup firewalling.
[   23.669083] systemd[1]: systemd-journald.service: (This warning is
only shown for the first unit using IP firewalling.)
[   23.750775] systemd[1]: Starting Journal Service...
[   23.798457] systemd[1]: Load Kernel Modules was skipped because no
trigger condition checks were met.
[   23.850908] systemd[1]: Starting Generate network units from Kernel
command line...
[   23.900845] systemd[1]: Starting Remount Root and Kernel File Systems...
[   23.990680] systemd[1]: Starting Apply Kernel Variables...
[   24.070729] systemd[1]: Starting Load udev Rules from Credentials...
[   24.209922] systemd[1]: Starting Coldplug All udev Devices...
[   24.598383] systemd[1]: Mounted Kernel Debug File System.
[   24.713420] systemd[1]: Mounted Temporary Directory /tmp.
[   24.789187] systemd[1]: Finished Create List of Static Device Nodes.
[   24.843604] systemd[1]: modprobe@configfs.service: Deactivated
successfully.
[   24.859018] EXT4-fs (mmcblk0p2): re-mounted
5df2fad9-8036-4769-97fa-b516397d778d.
[   24.899320] systemd[1]: Finished Load Kernel Module configfs.
[   24.988086] systemd[1]: modprobe@efi_pstore.service: Deactivated
successfully.
[   25.019401] systemd[1]: Finished Load Kernel Module efi_pstore.
[   25.055160] systemd[1]: modprobe@fuse.service: Deactivated successfully.
[   25.081434] systemd[1]: Finished Load Kernel Module fuse.
[   25.140570] systemd[1]: Finished Generate network units from Kernel
command line.
[   25.183321] systemd[1]: Finished Remount Root and Kernel File Systems.
[   25.239163] systemd[1]: Finished Apply Kernel Variables.
[   25.259192] systemd[1]: Finished Load udev Rules from Credentials.
[   25.293061] systemd[1]: Reached target Preparation for Network.
[   25.311373] systemd[1]: FUSE Control File System was skipped because
of an unmet condition check (ConditionPathExists=/sys/fs/fuse/connections).
[   25.332906] systemd-journald[243]: Collecting audit messages is disabled.
[   25.389989] systemd[1]: Mounting Kernel Configuration File System...
[   25.419954] systemd[1]: Platform Persistent Storage Archival was
skipped because of an unmet condition check
(ConditionDirectoryNotEmpty=/sys/fs/pstore).
[   25.520662] systemd[1]: Starting Create Static Device Nodes in /dev
gracefully...
[   25.773080] systemd[1]: Mounted Kernel Configuration File System.
[   26.590013] systemd[1]: Started Journal Service.
[   27.260839] systemd-journald[243]: Received client request to flush
runtime journal.
[   27.337593] systemd-journald[243]:
/var/log/journal/0a50ee270f31407485fd48f832e4b18c/system.journal:
Realtime clock jumped backwards relative to last journal entry, rotating.
[   27.389171] systemd-journald[243]: Rotating system journal.
[   39.299015] macb f8008000.ethernet eth0: PHY
[f8008000.ethernet-ffffffff:07] driver [Micrel KSZ8081 or KSZ8091] (irq=150)
[   39.468997] macb f8008000.ethernet eth0: configuring for phy/rmii
link mode

> 
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
Thank you,
Ryan

--------------IiVGqNEXBdR9oytAp3x20l1x
Content-Type: text/plain; charset="UTF-8"; name="config.txt"
Content-Disposition: attachment; filename="config.txt"
Content-Transfer-Encoding: base64

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIGZpbGU7IERPIE5PVCBFRElULgojIExpbnV4
L2FybSA2LjE1LjAtcmM1IEtlcm5lbCBDb25maWd1cmF0aW9uCiMKQ09ORklHX0NDX1ZFUlNJ
T05fVEVYVD0iYXJtLWxpbnV4LWdudWVhYmloZi1nY2MgKFVidW50dSAxMy4zLjAtNnVidW50
dTJ+MjQuMDQpIDEzLjMuMCIKQ09ORklHX0NDX0lTX0dDQz15CkNPTkZJR19HQ0NfVkVSU0lP
Tj0xMzAzMDAKQ09ORklHX0NMQU5HX1ZFUlNJT049MApDT05GSUdfQVNfSVNfR05VPXkKQ09O
RklHX0FTX1ZFUlNJT049MjQyMDAKQ09ORklHX0xEX0lTX0JGRD15CkNPTkZJR19MRF9WRVJT
SU9OPTI0MjAwCkNPTkZJR19MTERfVkVSU0lPTj0wCkNPTkZJR19SVVNUQ19WRVJTSU9OPTAK
Q09ORklHX1JVU1RDX0xMVk1fVkVSU0lPTj0wCkNPTkZJR19DQ19DQU5fTElOSz15CkNPTkZJ
R19DQ19DQU5fTElOS19TVEFUSUM9eQpDT05GSUdfQ0NfSEFTX0FTTV9HT1RPX09VVFBVVD15
CkNPTkZJR19DQ19IQVNfQVNNX0dPVE9fVElFRF9PVVRQVVQ9eQpDT05GSUdfQ0NfSEFTX0FT
TV9JTkxJTkU9eQpDT05GSUdfQ0NfSEFTX05PX1BST0ZJTEVfRk5fQVRUUj15CkNPTkZJR19M
RF9DQU5fVVNFX0tFRVBfSU5fT1ZFUkxBWT15CkNPTkZJR19QQUhPTEVfVkVSU0lPTj0wCkNP
TkZJR19JUlFfV09SSz15CkNPTkZJR19CVUlMRFRJTUVfVEFCTEVfU09SVD15CkNPTkZJR19U
SFJFQURfSU5GT19JTl9UQVNLPXkKCiMKIyBHZW5lcmFsIHNldHVwCiMKQ09ORklHX0JST0tF
Tl9PTl9TTVA9eQpDT05GSUdfSU5JVF9FTlZfQVJHX0xJTUlUPTMyCiMgQ09ORklHX0NPTVBJ
TEVfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1dFUlJPUiBpcyBub3Qgc2V0CkNPTkZJR19M
T0NBTFZFUlNJT049IiIKIyBDT05GSUdfTE9DQUxWRVJTSU9OX0FVVE8gaXMgbm90IHNldApD
T05GSUdfQlVJTERfU0FMVD0iIgpDT05GSUdfSEFWRV9LRVJORUxfR1pJUD15CkNPTkZJR19I
QVZFX0tFUk5FTF9MWk1BPXkKQ09ORklHX0hBVkVfS0VSTkVMX1haPXkKQ09ORklHX0hBVkVf
S0VSTkVMX0xaTz15CkNPTkZJR19IQVZFX0tFUk5FTF9MWjQ9eQpDT05GSUdfS0VSTkVMX0da
SVA9eQojIENPTkZJR19LRVJORUxfTFpNQSBpcyBub3Qgc2V0CiMgQ09ORklHX0tFUk5FTF9Y
WiBpcyBub3Qgc2V0CiMgQ09ORklHX0tFUk5FTF9MWk8gaXMgbm90IHNldAojIENPTkZJR19L
RVJORUxfTFo0IGlzIG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfSU5JVD0iIgpDT05GSUdfREVG
QVVMVF9IT1NUTkFNRT0iKG5vbmUpIgpDT05GSUdfU1lTVklQQz15CkNPTkZJR19TWVNWSVBD
X1NZU0NUTD15CiMgQ09ORklHX1BPU0lYX01RVUVVRSBpcyBub3Qgc2V0CiMgQ09ORklHX1dB
VENIX1FVRVVFIGlzIG5vdCBzZXQKQ09ORklHX0NST1NTX01FTU9SWV9BVFRBQ0g9eQojIENP
TkZJR19VU0VMSUIgaXMgbm90IHNldAojIENPTkZJR19BVURJVCBpcyBub3Qgc2V0CkNPTkZJ
R19IQVZFX0FSQ0hfQVVESVRTWVNDQUxMPXkKCiMKIyBJUlEgc3Vic3lzdGVtCiMKQ09ORklH
X0dFTkVSSUNfSVJRX1BST0JFPXkKQ09ORklHX0dFTkVSSUNfSVJRX1NIT1c9eQpDT05GSUdf
R0VORVJJQ19JUlFfU0hPV19MRVZFTD15CkNPTkZJR19IQVJESVJRU19TV19SRVNFTkQ9eQpD
T05GSUdfR0VORVJJQ19JUlFfQ0hJUD15CkNPTkZJR19JUlFfRE9NQUlOPXkKQ09ORklHX0lS
UV9GT1JDRURfVEhSRUFESU5HPXkKQ09ORklHX1NQQVJTRV9JUlE9eQojIENPTkZJR19HRU5F
UklDX0lSUV9ERUJVR0ZTIGlzIG5vdCBzZXQKIyBlbmQgb2YgSVJRIHN1YnN5c3RlbQoKQ09O
RklHX0dFTkVSSUNfSVJRX01VTFRJX0hBTkRMRVI9eQpDT05GSUdfR0VORVJJQ19DTE9DS0VW
RU5UUz15CgojCiMgVGltZXJzIHN1YnN5c3RlbQojCkNPTkZJR19USUNLX09ORVNIT1Q9eQpD
T05GSUdfTk9fSFpfQ09NTU9OPXkKIyBDT05GSUdfSFpfUEVSSU9ESUMgaXMgbm90IHNldApD
T05GSUdfTk9fSFpfSURMRT15CiMgQ09ORklHX05PX0haIGlzIG5vdCBzZXQKQ09ORklHX0hJ
R0hfUkVTX1RJTUVSUz15CiMgZW5kIG9mIFRpbWVycyBzdWJzeXN0ZW0KCkNPTkZJR19CUEY9
eQpDT05GSUdfSEFWRV9FQlBGX0pJVD15CgojCiMgQlBGIHN1YnN5c3RlbQojCiMgQ09ORklH
X0JQRl9TWVNDQUxMIGlzIG5vdCBzZXQKIyBDT05GSUdfQlBGX0pJVCBpcyBub3Qgc2V0CiMg
ZW5kIG9mIEJQRiBzdWJzeXN0ZW0KCkNPTkZJR19QUkVFTVBUX05PTkVfQlVJTEQ9eQpDT05G
SUdfUFJFRU1QVF9OT05FPXkKIyBDT05GSUdfUFJFRU1QVF9WT0xVTlRBUlkgaXMgbm90IHNl
dAojIENPTkZJR19QUkVFTVBUIGlzIG5vdCBzZXQKCiMKIyBDUFUvVGFzayB0aW1lIGFuZCBz
dGF0cyBhY2NvdW50aW5nCiMKQ09ORklHX1RJQ0tfQ1BVX0FDQ09VTlRJTkc9eQojIENPTkZJ
R19WSVJUX0NQVV9BQ0NPVU5USU5HX0dFTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSUV9USU1F
X0FDQ09VTlRJTkcgaXMgbm90IHNldAojIENPTkZJR19CU0RfUFJPQ0VTU19BQ0NUIGlzIG5v
dCBzZXQKIyBDT05GSUdfVEFTS1NUQVRTIGlzIG5vdCBzZXQKIyBDT05GSUdfUFNJIGlzIG5v
dCBzZXQKIyBlbmQgb2YgQ1BVL1Rhc2sgdGltZSBhbmQgc3RhdHMgYWNjb3VudGluZwoKIwoj
IFJDVSBTdWJzeXN0ZW0KIwpDT05GSUdfVElOWV9SQ1U9eQojIENPTkZJR19SQ1VfRVhQRVJU
IGlzIG5vdCBzZXQKQ09ORklHX1RJTllfU1JDVT15CiMgZW5kIG9mIFJDVSBTdWJzeXN0ZW0K
CiMgQ09ORklHX0lLQ09ORklHIGlzIG5vdCBzZXQKIyBDT05GSUdfSUtIRUFERVJTIGlzIG5v
dCBzZXQKQ09ORklHX0xPR19CVUZfU0hJRlQ9MTQKIyBDT05GSUdfUFJJTlRLX0lOREVYIGlz
IG5vdCBzZXQKQ09ORklHX0dFTkVSSUNfU0NIRURfQ0xPQ0s9eQoKIwojIFNjaGVkdWxlciBm
ZWF0dXJlcwojCiMgZW5kIG9mIFNjaGVkdWxlciBmZWF0dXJlcwoKQ09ORklHX0NDX0lNUExJ
Q0lUX0ZBTExUSFJPVUdIPSItV2ltcGxpY2l0LWZhbGx0aHJvdWdoPTUiCkNPTkZJR19HQ0Mx
MF9OT19BUlJBWV9CT1VORFM9eQpDT05GSUdfQ0NfTk9fQVJSQVlfQk9VTkRTPXkKQ09ORklH
X0dDQ19OT19TVFJJTkdPUF9PVkVSRkxPVz15CkNPTkZJR19DQ19OT19TVFJJTkdPUF9PVkVS
RkxPVz15CkNPTkZJR19DR1JPVVBTPXkKIyBDT05GSUdfQ0dST1VQX0ZBVk9SX0RZTk1PRFMg
aXMgbm90IHNldAojIENPTkZJR19NRU1DRyBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19DR1JP
VVAgaXMgbm90IHNldAojIENPTkZJR19DR1JPVVBfU0NIRUQgaXMgbm90IHNldAojIENPTkZJ
R19DR1JPVVBfUElEUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NHUk9VUF9SRE1BIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ0dST1VQX0RNRU0gaXMgbm90IHNldAojIENPTkZJR19DR1JPVVBfRlJF
RVpFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0NHUk9VUF9ERVZJQ0UgaXMgbm90IHNldAojIENP
TkZJR19DR1JPVVBfQ1BVQUNDVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NHUk9VUF9NSVNDIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ0dST1VQX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfTkFN
RVNQQUNFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NIRUNLUE9JTlRfUkVTVE9SRSBpcyBub3Qg
c2V0CiMgQ09ORklHX1NDSEVEX0FVVE9HUk9VUCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFTEFZ
IGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfSU5JVFJEPXkKQ09ORklHX0lOSVRSQU1GU19T
T1VSQ0U9IiIKQ09ORklHX1JEX0daSVA9eQpDT05GSUdfUkRfQlpJUDI9eQpDT05GSUdfUkRf
TFpNQT15CkNPTkZJR19SRF9YWj15CkNPTkZJR19SRF9MWk89eQpDT05GSUdfUkRfTFo0PXkK
Q09ORklHX1JEX1pTVEQ9eQojIENPTkZJR19CT09UX0NPTkZJRyBpcyBub3Qgc2V0CkNPTkZJ
R19JTklUUkFNRlNfUFJFU0VSVkVfTVRJTUU9eQpDT05GSUdfQ0NfT1BUSU1JWkVfRk9SX1BF
UkZPUk1BTkNFPXkKIyBDT05GSUdfQ0NfT1BUSU1JWkVfRk9SX1NJWkUgaXMgbm90IHNldApD
T05GSUdfSEFWRV9MRF9ERUFEX0NPREVfREFUQV9FTElNSU5BVElPTj15CiMgQ09ORklHX0xE
X0RFQURfQ09ERV9EQVRBX0VMSU1JTkFUSU9OIGlzIG5vdCBzZXQKQ09ORklHX0xEX09SUEhB
Tl9XQVJOPXkKQ09ORklHX0xEX09SUEhBTl9XQVJOX0xFVkVMPSJ3YXJuIgpDT05GSUdfU1lT
Q1RMPXkKQ09ORklHX0hBVkVfVUlEMTY9eQojIENPTkZJR19TWVNGU19TWVNDQUxMIGlzIG5v
dCBzZXQKQ09ORklHX0VYUEVSVD15CkNPTkZJR19VSUQxNj15CkNPTkZJR19NVUxUSVVTRVI9
eQojIENPTkZJR19TR0VUTUFTS19TWVNDQUxMIGlzIG5vdCBzZXQKQ09ORklHX0ZIQU5ETEU9
eQpDT05GSUdfUE9TSVhfVElNRVJTPXkKQ09ORklHX1BSSU5USz15CkNPTkZJR19CVUc9eQpD
T05GSUdfRUxGX0NPUkU9eQojIENPTkZJR19CQVNFX1NNQUxMIGlzIG5vdCBzZXQKQ09ORklH
X0ZVVEVYPXkKQ09ORklHX0ZVVEVYX1BJPXkKQ09ORklHX0VQT0xMPXkKQ09ORklHX1NJR05B
TEZEPXkKQ09ORklHX1RJTUVSRkQ9eQpDT05GSUdfRVZFTlRGRD15CkNPTkZJR19TSE1FTT15
CkNPTkZJR19BSU89eQpDT05GSUdfSU9fVVJJTkc9eQpDT05GSUdfQURWSVNFX1NZU0NBTExT
PXkKQ09ORklHX01FTUJBUlJJRVI9eQpDT05GSUdfS0NNUD15CkNPTkZJR19SU0VRPXkKIyBD
T05GSUdfREVCVUdfUlNFUSBpcyBub3Qgc2V0CkNPTkZJR19DQUNIRVNUQVRfU1lTQ0FMTD15
CiMgQ09ORklHX1BDMTA0IGlzIG5vdCBzZXQKQ09ORklHX0tBTExTWU1TPXkKIyBDT05GSUdf
S0FMTFNZTVNfU0VMRlRFU1QgaXMgbm90IHNldAojIENPTkZJR19LQUxMU1lNU19BTEwgaXMg
bm90IHNldApDT05GSUdfQVJDSF9IQVNfTUVNQkFSUklFUl9TWU5DX0NPUkU9eQpDT05GSUdf
SEFWRV9QRVJGX0VWRU5UUz15CkNPTkZJR19QRVJGX1VTRV9WTUFMTE9DPXkKCiMKIyBLZXJu
ZWwgUGVyZm9ybWFuY2UgRXZlbnRzIEFuZCBDb3VudGVycwojCiMgQ09ORklHX1BFUkZfRVZF
TlRTIGlzIG5vdCBzZXQKIyBlbmQgb2YgS2VybmVsIFBlcmZvcm1hbmNlIEV2ZW50cyBBbmQg
Q291bnRlcnMKCkNPTkZJR19TWVNURU1fREFUQV9WRVJJRklDQVRJT049eQojIENPTkZJR19Q
Uk9GSUxJTkcgaXMgbm90IHNldAoKIwojIEtleGVjIGFuZCBjcmFzaCBmZWF0dXJlcwojCkNP
TkZJR19DUkFTSF9SRVNFUlZFPXkKQ09ORklHX1ZNQ09SRV9JTkZPPXkKQ09ORklHX0tFWEVD
X0NPUkU9eQpDT05GSUdfS0VYRUM9eQpDT05GSUdfQ1JBU0hfRFVNUD15CiMgZW5kIG9mIEtl
eGVjIGFuZCBjcmFzaCBmZWF0dXJlcwojIGVuZCBvZiBHZW5lcmFsIHNldHVwCgpDT05GSUdf
QVJNPXkKQ09ORklHX0FSTV9IQVNfR1JPVVBfUkVMT0NTPXkKQ09ORklHX1NZU19TVVBQT1JU
U19BUE1fRU1VTEFUSU9OPXkKQ09ORklHX0hBVkVfUFJPQ19DUFU9eQpDT05GSUdfU1RBQ0tU
UkFDRV9TVVBQT1JUPXkKQ09ORklHX0xPQ0tERVBfU1VQUE9SVD15CkNPTkZJR19GSVhfRUFS
TFlDT05fTUVNPXkKQ09ORklHX0dFTkVSSUNfSFdFSUdIVD15CkNPTkZJR19HRU5FUklDX0NB
TElCUkFURV9ERUxBWT15CkNPTkZJR19BUkNIX1NVUFBPUlRTX1VQUk9CRVM9eQpDT05GSUdf
QVJNX1BBVENIX1BIWVNfVklSVD15CkNPTkZJR19HRU5FUklDX0JVRz15CkNPTkZJR19QR1RB
QkxFX0xFVkVMUz0yCgojCiMgU3lzdGVtIFR5cGUKIwpDT05GSUdfTU1VPXkKQ09ORklHX0FS
Q0hfTU1BUF9STkRfQklUU19NSU49OApDT05GSUdfQVJDSF9NTUFQX1JORF9CSVRTX01BWD0x
NgpDT05GSUdfQVJDSF9NVUxUSVBMQVRGT1JNPXkKCiMKIyBQbGF0Zm9ybSBzZWxlY3Rpb24K
IwoKIwojIENQVSBDb3JlIGZhbWlseSBzZWxlY3Rpb24KIwojIENPTkZJR19BUkNIX01VTFRJ
X1Y2IGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfTVVMVElfVjc9eQpDT05GSUdfQVJDSF9NVUxU
SV9WNl9WNz15CiMgZW5kIG9mIFBsYXRmb3JtIHNlbGVjdGlvbgoKIyBDT05GSUdfQVJDSF9W
SVJUIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9BSVJPSEEgaXMgbm90IHNldAojIENPTkZJ
R19BUkNIX1JEQSBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfU1VOUExVUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0FSQ0hfVU5JUEhJRVIgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0FDVElP
TlMgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0FMUElORSBpcyBub3Qgc2V0CiMgQ09ORklH
X0FSQ0hfQVJUUEVDIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9BU1BFRUQgaXMgbm90IHNl
dApDT05GSUdfQVJDSF9BVDkxPXkKQ09ORklHX1NPQ19TQU1BNUQyPXkKQ09ORklHX1NPQ19T
QU1BNUQzPXkKQ09ORklHX1NPQ19TQU1BNUQ0PXkKIyBDT05GSUdfU09DX1NBTUE3RDY1IGlz
IG5vdCBzZXQKIyBDT05GSUdfU09DX1NBTUE3RzUgaXMgbm90IHNldAojIENPTkZJR19TT0Nf
TEFOOTY2IGlzIG5vdCBzZXQKCiMKIyBDbG9ja3NvdXJjZSBkcml2ZXIgc2VsZWN0aW9uCiMK
IyBDT05GSUdfQVRNRUxfQ0xPQ0tTT1VSQ0VfUElUIGlzIG5vdCBzZXQKQ09ORklHX0FUTUVM
X0NMT0NLU09VUkNFX1RDQj15CiMgQ09ORklHX01JQ1JPQ0hJUF9DTE9DS1NPVVJDRV9QSVQ2
NEIgaXMgbm90IHNldApDT05GSUdfSEFWRV9BVDkxX1VUTUk9eQpDT05GSUdfSEFWRV9BVDkx
X1VTQl9DTEs9eQpDT05GSUdfQ09NTU9OX0NMS19BVDkxPXkKQ09ORklHX0hBVkVfQVQ5MV9T
TUQ9eQpDT05GSUdfSEFWRV9BVDkxX0gzMk1YPXkKQ09ORklHX0hBVkVfQVQ5MV9HRU5FUkFU
RURfQ0xLPXkKQ09ORklHX0hBVkVfQVQ5MV9BVURJT19QTEw9eQpDT05GSUdfSEFWRV9BVDkx
X0kyU19NVVhfQ0xLPXkKQ09ORklHX1NPQ19TQU1fVjc9eQpDT05GSUdfU09DX1NBTUE1PXkK
Q09ORklHX0FUTUVMX1BNPXkKIyBDT05GSUdfQVRNRUxfU0VDVVJFX1BNIGlzIG5vdCBzZXQK
IyBDT05GSUdfQVJDSF9CQ00gaXMgbm90IHNldAojIENPTkZJR19BUkNIX0JFUkxJTiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FSQ0hfRElHSUNPTE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJD
SF9FWFlOT1MgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0hJR0hCQU5LIGlzIG5vdCBzZXQK
IyBDT05GSUdfQVJDSF9ISVNJIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9IUEUgaXMgbm90
IHNldAojIENPTkZJR19BUkNIX01YQyBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfS0VZU1RP
TkUgaXMgbm90IHNldAojIENPTkZJR19BUkNIX01FRElBVEVLIGlzIG5vdCBzZXQKIyBDT05G
SUdfQVJDSF9NRVNPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfTUlMQkVBVVQgaXMgbm90
IHNldAojIENPTkZJR19BUkNIX01NUCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfTVNUQVJW
NyBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfTVZFQlUgaXMgbm90IHNldAojIENPTkZJR19B
UkNIX05QQ00gaXMgbm90IHNldAoKIwojIFRJIE9NQVAvQU0vRE0vRFJBIEZhbWlseQojCiMg
Q09ORklHX0FSQ0hfT01BUDMgaXMgbm90IHNldAojIENPTkZJR19BUkNIX09NQVA0IGlzIG5v
dCBzZXQKIyBDT05GSUdfU09DX09NQVA1IGlzIG5vdCBzZXQKIyBDT05GSUdfU09DX0FNMzNY
WCBpcyBub3Qgc2V0CiMgQ09ORklHX1NPQ19BTTQzWFggaXMgbm90IHNldAojIENPTkZJR19T
T0NfRFJBN1hYIGlzIG5vdCBzZXQKIyBlbmQgb2YgVEkgT01BUC9BTS9ETS9EUkEgRmFtaWx5
CgojIENPTkZJR19BUkNIX1FDT00gaXMgbm90IHNldAojIENPTkZJR19BUkNIX1JFQUxURUsg
aXMgbm90IHNldAojIENPTkZJR19BUkNIX1JPQ0tDSElQIGlzIG5vdCBzZXQKIyBDT05GSUdf
QVJDSF9TNVBWMjEwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9SRU5FU0FTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVJDSF9JTlRFTF9TT0NGUEdBIGlzIG5vdCBzZXQKIyBDT05GSUdfUExB
VF9TUEVBUiBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfU1RJIGlzIG5vdCBzZXQKIyBDT05G
SUdfQVJDSF9TVE0zMiBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfU1VOWEkgaXMgbm90IHNl
dAojIENPTkZJR19BUkNIX1RFR1JBIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9VODUwMCBp
cyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUkVBTFZJRVcgaXMgbm90IHNldAojIENPTkZJR19B
UkNIX1ZFWFBSRVNTIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9XTTg4NTAgaXMgbm90IHNl
dAojIENPTkZJR19BUkNIX1pZTlEgaXMgbm90IHNldAoKIwojIFByb2Nlc3NvciBUeXBlCiMK
Q09ORklHX0NQVV9WNz15CkNPTkZJR19DUFVfVEhVTUJfQ0FQQUJMRT15CkNPTkZJR19DUFVf
MzJ2Nks9eQpDT05GSUdfQ1BVXzMydjc9eQpDT05GSUdfQ1BVX0FCUlRfRVY3PXkKQ09ORklH
X0NQVV9QQUJSVF9WNz15CkNPTkZJR19DUFVfQ0FDSEVfVjc9eQpDT05GSUdfQ1BVX0NBQ0hF
X1ZJUFQ9eQpDT05GSUdfQ1BVX0NPUFlfVjY9eQpDT05GSUdfQ1BVX1RMQl9WNz15CkNPTkZJ
R19DUFVfSEFTX0FTSUQ9eQpDT05GSUdfQ1BVX0NQMTU9eQpDT05GSUdfQ1BVX0NQMTVfTU1V
PXkKCiMKIyBQcm9jZXNzb3IgRmVhdHVyZXMKIwojIENPTkZJR19BUk1fTFBBRSBpcyBub3Qg
c2V0CkNPTkZJR19BUk1fVEhVTUI9eQojIENPTkZJR19BUk1fVEhVTUJFRSBpcyBub3Qgc2V0
CkNPTkZJR19BUk1fVklSVF9FWFQ9eQojIENPTkZJR19TV1BfRU1VTEFURSBpcyBub3Qgc2V0
CkNPTkZJR19DUFVfTElUVExFX0VORElBTj15CiMgQ09ORklHX0NQVV9CSUdfRU5ESUFOIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ1BVX0lDQUNIRV9ESVNBQkxFIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ1BVX0RDQUNIRV9ESVNBQkxFIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1BVX0JQUkVESUNU
X0RJU0FCTEUgaXMgbm90IHNldApDT05GSUdfQ1BVX1NQRUNUUkU9eQpDT05GSUdfSEFSREVO
X0JSQU5DSF9QUkVESUNUT1I9eQpDT05GSUdfSEFSREVOX0JSQU5DSF9ISVNUT1JZPXkKQ09O
RklHX0tVU0VSX0hFTFBFUlM9eQojIENPTkZJR19WRFNPIGlzIG5vdCBzZXQKQ09ORklHX09V
VEVSX0NBQ0hFPXkKQ09ORklHX09VVEVSX0NBQ0hFX1NZTkM9eQpDT05GSUdfTUlHSFRfSEFW
RV9DQUNIRV9MMlgwPXkKQ09ORklHX0NBQ0hFX0wyWDA9eQojIENPTkZJR19QTDMxMF9FUlJB
VEFfNTg4MzY5IGlzIG5vdCBzZXQKIyBDT05GSUdfUEwzMTBfRVJSQVRBXzcyNzkxNSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BMMzEwX0VSUkFUQV83NTM5NzAgaXMgbm90IHNldAojIENPTkZJ
R19QTDMxMF9FUlJBVEFfNzY5NDE5IGlzIG5vdCBzZXQKQ09ORklHX0FSTV9MMV9DQUNIRV9T
SElGVF82PXkKQ09ORklHX0FSTV9MMV9DQUNIRV9TSElGVD02CkNPTkZJR19BUk1fRE1BX01F
TV9CVUZGRVJBQkxFPXkKQ09ORklHX0FSTV9IRUFWWV9NQj15CkNPTkZJR19ERUJVR19BTElH
Tl9ST0RBVEE9eQojIENPTkZJR19BUk1fRVJSQVRBXzQzMDk3MyBpcyBub3Qgc2V0CiMgQ09O
RklHX0FSTV9FUlJBVEFfNzIwNzg5IGlzIG5vdCBzZXQKIyBDT05GSUdfQVJNX0VSUkFUQV83
NTQzMjIgaXMgbm90IHNldAojIENPTkZJR19BUk1fRVJSQVRBXzc2NDMxOSBpcyBub3Qgc2V0
CiMgQ09ORklHX0FSTV9FUlJBVEFfNzc1NDIwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJNX0VS
UkFUQV83NzMwMjIgaXMgbm90IHNldAojIENPTkZJR19BUk1fRVJSQVRBXzgxODMyNV84NTI0
MjIgaXMgbm90IHNldAojIENPTkZJR19BUk1fRVJSQVRBXzgyMTQyMCBpcyBub3Qgc2V0CiMg
Q09ORklHX0FSTV9FUlJBVEFfODI1NjE5IGlzIG5vdCBzZXQKIyBDT05GSUdfQVJNX0VSUkFU
QV84NTcyNzEgaXMgbm90IHNldAojIENPTkZJR19BUk1fRVJSQVRBXzg1MjQyMSBpcyBub3Qg
c2V0CiMgQ09ORklHX0FSTV9FUlJBVEFfODUyNDIzIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJN
X0VSUkFUQV84NTcyNzIgaXMgbm90IHNldAojIGVuZCBvZiBTeXN0ZW0gVHlwZQoKIwojIEJ1
cyBzdXBwb3J0CiMKIyBDT05GSUdfQVJNX0VSUkFUQV84MTQyMjAgaXMgbm90IHNldAojIGVu
ZCBvZiBCdXMgc3VwcG9ydAoKIwojIEtlcm5lbCBGZWF0dXJlcwojCkNPTkZJR19IQVZFX1NN
UD15CiMgQ09ORklHX1NNUCBpcyBub3Qgc2V0CkNPTkZJR19DVVJSRU5UX1BPSU5URVJfSU5f
VFBJRFJVUk89eQpDT05GSUdfSVJRU1RBQ0tTPXkKIyBDT05GSUdfSEFWRV9BUk1fQVJDSF9U
SU1FUiBpcyBub3Qgc2V0CkNPTkZJR19WTVNQTElUXzNHPXkKIyBDT05GSUdfVk1TUExJVF8z
R19PUFQgaXMgbm90IHNldAojIENPTkZJR19WTVNQTElUXzJHIGlzIG5vdCBzZXQKIyBDT05G
SUdfVk1TUExJVF8xRyBpcyBub3Qgc2V0CkNPTkZJR19QQUdFX09GRlNFVD0weEMwMDAwMDAw
CiMgQ09ORklHX0FSTV9QU0NJIGlzIG5vdCBzZXQKQ09ORklHX0haX0ZJWEVEPTAKQ09ORklH
X0haXzEwMD15CiMgQ09ORklHX0haXzIwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0haXzI1MCBp
cyBub3Qgc2V0CiMgQ09ORklHX0haXzMwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0haXzUwMCBp
cyBub3Qgc2V0CiMgQ09ORklHX0haXzEwMDAgaXMgbm90IHNldApDT05GSUdfSFo9MTAwCkNP
TkZJR19TQ0hFRF9IUlRJQ0s9eQojIENPTkZJR19USFVNQjJfS0VSTkVMIGlzIG5vdCBzZXQK
Q09ORklHX0FSTV9QQVRDSF9JRElWPXkKQ09ORklHX0FFQUJJPXkKIyBDT05GSUdfT0FCSV9D
T01QQVQgaXMgbm90IHNldApDT05GSUdfQVJDSF9TRUxFQ1RfTUVNT1JZX01PREVMPXkKQ09O
RklHX0FSQ0hfRkxBVE1FTV9FTkFCTEU9eQpDT05GSUdfQVJDSF9TUEFSU0VNRU1fRU5BQkxF
PXkKIyBDT05GSUdfSElHSE1FTSBpcyBub3Qgc2V0CkNPTkZJR19BUk1fUEFOPXkKQ09ORklH
X0NQVV9TV19ET01BSU5fUEFOPXkKQ09ORklHX0FSTV9NT0RVTEVfUExUUz15CkNPTkZJR19B
UkNIX0ZPUkNFX01BWF9PUkRFUj0xMApDT05GSUdfQUxJR05NRU5UX1RSQVA9eQpDT05GSUdf
VUFDQ0VTU19XSVRIX01FTUNQWT15CiMgQ09ORklHX1BBUkFWSVJUIGlzIG5vdCBzZXQKIyBD
T05GSUdfUEFSQVZJUlRfVElNRV9BQ0NPVU5USU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfWEVO
IGlzIG5vdCBzZXQKQ09ORklHX0NDX0hBVkVfU1RBQ0tQUk9URUNUT1JfVExTPXkKQ09ORklH
X1NUQUNLUFJPVEVDVE9SX1BFUl9UQVNLPXkKIyBlbmQgb2YgS2VybmVsIEZlYXR1cmVzCgoj
CiMgQm9vdCBvcHRpb25zCiMKQ09ORklHX1VTRV9PRj15CkNPTkZJR19BUkNIX1dBTlRfRkxB
VF9EVEJfSU5TVEFMTD15CiMgQ09ORklHX0FUQUdTIGlzIG5vdCBzZXQKQ09ORklHX1pCT09U
X1JPTV9URVhUPTB4MApDT05GSUdfWkJPT1RfUk9NX0JTUz0weDAKIyBDT05GSUdfQVJNX0FQ
UEVOREVEX0RUQiBpcyBub3Qgc2V0CkNPTkZJR19DTURMSU5FPSJjb25zb2xlPXR0eVMwLDEx
NTIwMCBpbml0cmQ9MHgyMTEwMDAwMCwyNTE2NTgyNCByb290PS9kZXYvcmFtMCBydyIKQ09O
RklHX0NNRExJTkVfRlJPTV9CT09UTE9BREVSPXkKIyBDT05GSUdfQ01ETElORV9FWFRFTkQg
aXMgbm90IHNldAojIENPTkZJR19DTURMSU5FX0ZPUkNFIGlzIG5vdCBzZXQKQ09ORklHX0FS
Q0hfU1VQUE9SVFNfS0VYRUM9eQpDT05GSUdfQVJDSF9TVVBQT1JUU19DUkFTSF9EVU1QPXkK
Q09ORklHX0FSQ0hfREVGQVVMVF9DUkFTSF9EVU1QPXkKQ09ORklHX0FVVE9fWlJFTEFERFI9
eQojIENPTkZJR19FRkkgaXMgbm90IHNldAojIGVuZCBvZiBCb290IG9wdGlvbnMKCiMKIyBD
UFUgUG93ZXIgTWFuYWdlbWVudAojCgojCiMgQ1BVIEZyZXF1ZW5jeSBzY2FsaW5nCiMKIyBD
T05GSUdfQ1BVX0ZSRVEgaXMgbm90IHNldAojIGVuZCBvZiBDUFUgRnJlcXVlbmN5IHNjYWxp
bmcKCiMKIyBDUFUgSWRsZQojCiMgQ09ORklHX0NQVV9JRExFIGlzIG5vdCBzZXQKIyBlbmQg
b2YgQ1BVIElkbGUKIyBlbmQgb2YgQ1BVIFBvd2VyIE1hbmFnZW1lbnQKCiMKIyBGbG9hdGlu
ZyBwb2ludCBlbXVsYXRpb24KIwoKIwojIEF0IGxlYXN0IG9uZSBlbXVsYXRpb24gbXVzdCBi
ZSBzZWxlY3RlZAojCkNPTkZJR19WRlA9eQpDT05GSUdfVkZQdjM9eQpDT05GSUdfTkVPTj15
CkNPTkZJR19LRVJORUxfTU9ERV9ORU9OPXkKIyBlbmQgb2YgRmxvYXRpbmcgcG9pbnQgZW11
bGF0aW9uCgojCiMgUG93ZXIgbWFuYWdlbWVudCBvcHRpb25zCiMKQ09ORklHX1NVU1BFTkQ9
eQpDT05GSUdfU1VTUEVORF9GUkVFWkVSPXkKIyBDT05GSUdfU1VTUEVORF9TS0lQX1NZTkMg
aXMgbm90IHNldApDT05GSUdfUE1fU0xFRVA9eQojIENPTkZJR19QTV9BVVRPU0xFRVAgaXMg
bm90IHNldAojIENPTkZJR19QTV9VU0VSU1BBQ0VfQVVUT1NMRUVQIGlzIG5vdCBzZXQKIyBD
T05GSUdfUE1fV0FLRUxPQ0tTIGlzIG5vdCBzZXQKQ09ORklHX1BNPXkKQ09ORklHX1BNX0RF
QlVHPXkKQ09ORklHX1BNX0FEVkFOQ0VEX0RFQlVHPXkKIyBDT05GSUdfUE1fVEVTVF9TVVNQ
RU5EIGlzIG5vdCBzZXQKQ09ORklHX1BNX1NMRUVQX0RFQlVHPXkKIyBDT05GSUdfQVBNX0VN
VUxBVElPTiBpcyBub3Qgc2V0CkNPTkZJR19QTV9DTEs9eQojIENPTkZJR19XUV9QT1dFUl9F
RkZJQ0lFTlRfREVGQVVMVCBpcyBub3Qgc2V0CkNPTkZJR19DUFVfUE09eQpDT05GSUdfQVJD
SF9TVVNQRU5EX1BPU1NJQkxFPXkKQ09ORklHX0FSTV9DUFVfU1VTUEVORD15CkNPTkZJR19B
UkNIX0hJQkVSTkFUSU9OX1BPU1NJQkxFPXkKIyBlbmQgb2YgUG93ZXIgbWFuYWdlbWVudCBv
cHRpb25zCgpDT05GSUdfQ1BVX01JVElHQVRJT05TPXkKQ09ORklHX0FSQ0hfSEFTX0RNQV9P
UFM9eQoKIwojIEdlbmVyYWwgYXJjaGl0ZWN0dXJlLWRlcGVuZGVudCBvcHRpb25zCiMKIyBD
T05GSUdfS1BST0JFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0pVTVBfTEFCRUwgaXMgbm90IHNl
dApDT05GSUdfSEFWRV9FRkZJQ0lFTlRfVU5BTElHTkVEX0FDQ0VTUz15CkNPTkZJR19BUkNI
X1VTRV9CVUlMVElOX0JTV0FQPXkKQ09ORklHX0hBVkVfS1BST0JFUz15CkNPTkZJR19IQVZF
X0tSRVRQUk9CRVM9eQpDT05GSUdfSEFWRV9PUFRQUk9CRVM9eQpDT05GSUdfSEFWRV9GVU5D
VElPTl9FUlJPUl9JTkpFQ1RJT049eQpDT05GSUdfSEFWRV9OTUk9eQpDT05GSUdfVFJBQ0Vf
SVJRRkxBR1NfU1VQUE9SVD15CkNPTkZJR19IQVZFX0FSQ0hfVFJBQ0VIT09LPXkKQ09ORklH
X0hBVkVfRE1BX0NPTlRJR1VPVVM9eQpDT05GSUdfR0VORVJJQ19TTVBfSURMRV9USFJFQUQ9
eQpDT05GSUdfR0VORVJJQ19JRExFX1BPTExfU0VUVVA9eQpDT05GSUdfQVJDSF9IQVNfRk9S
VElGWV9TT1VSQ0U9eQpDT05GSUdfQVJDSF9IQVNfS0VFUElOSVRSRD15CkNPTkZJR19BUkNI
X0hBU19TRVRfTUVNT1JZPXkKQ09ORklHX0FSQ0hfSEFTX0NQVV9GSU5BTElaRV9JTklUPXkK
Q09ORklHX0hBVkVfQVJDSF9USFJFQURfU1RSVUNUX1dISVRFTElTVD15CkNPTkZJR19BUkNI
XzMyQklUX09GRl9UPXkKQ09ORklHX0hBVkVfUkVHU19BTkRfU1RBQ0tfQUNDRVNTX0FQST15
CkNPTkZJR19IQVZFX1JTRVE9eQpDT05GSUdfSEFWRV9SVVNUPXkKQ09ORklHX0hBVkVfUEVS
Rl9SRUdTPXkKQ09ORklHX0hBVkVfUEVSRl9VU0VSX1NUQUNLX0RVTVA9eQpDT05GSUdfSEFW
RV9BUkNIX0pVTVBfTEFCRUw9eQpDT05GSUdfTU1VX0xBWllfVExCX1JFRkNPVU5UPXkKQ09O
RklHX0FSQ0hfSEFWRV9OTUlfU0FGRV9DTVBYQ0hHPXkKQ09ORklHX0FSQ0hfV0FOVF9JUENf
UEFSU0VfVkVSU0lPTj15CkNPTkZJR19IQVZFX0FSQ0hfU0VDQ09NUD15CkNPTkZJR19IQVZF
X0FSQ0hfU0VDQ09NUF9GSUxURVI9eQpDT05GSUdfU0VDQ09NUD15CkNPTkZJR19TRUNDT01Q
X0ZJTFRFUj15CiMgQ09ORklHX1NFQ0NPTVBfQ0FDSEVfREVCVUcgaXMgbm90IHNldApDT05G
SUdfSEFWRV9BUkNIX1NUQUNLTEVBSz15CkNPTkZJR19IQVZFX1NUQUNLUFJPVEVDVE9SPXkK
Q09ORklHX1NUQUNLUFJPVEVDVE9SPXkKQ09ORklHX1NUQUNLUFJPVEVDVE9SX1NUUk9ORz15
CkNPTkZJR19MVE9fTk9ORT15CkNPTkZJR19BUkNIX1NVUFBPUlRTX0NGSV9DTEFORz15CkNP
TkZJR19IQVZFX0NPTlRFWFRfVFJBQ0tJTkdfVVNFUj15CkNPTkZJR19IQVZFX1ZJUlRfQ1BV
X0FDQ09VTlRJTkdfR0VOPXkKQ09ORklHX0hBVkVfSVJRX1RJTUVfQUNDT1VOVElORz15CkNP
TkZJR19IQVZFX01PRF9BUkNIX1NQRUNJRklDPXkKQ09ORklHX01PRFVMRVNfVVNFX0VMRl9S
RUw9eQpDT05GSUdfSEFWRV9JUlFfRVhJVF9PTl9JUlFfU1RBQ0s9eQpDT05GSUdfSEFWRV9T
T0ZUSVJRX09OX09XTl9TVEFDSz15CkNPTkZJR19TT0ZUSVJRX09OX09XTl9TVEFDSz15CkNP
TkZJR19BUkNIX0hBU19FTEZfUkFORE9NSVpFPXkKQ09ORklHX0hBVkVfQVJDSF9NTUFQX1JO
RF9CSVRTPXkKQ09ORklHX0hBVkVfRVhJVF9USFJFQUQ9eQpDT05GSUdfQVJDSF9NTUFQX1JO
RF9CSVRTPTgKQ09ORklHX0hBVkVfUEFHRV9TSVpFXzRLQj15CkNPTkZJR19QQUdFX1NJWkVf
NEtCPXkKQ09ORklHX1BBR0VfU0laRV9MRVNTX1RIQU5fNjRLQj15CkNPTkZJR19QQUdFX1NJ
WkVfTEVTU19USEFOXzI1NktCPXkKQ09ORklHX1BBR0VfU0hJRlQ9MTIKQ09ORklHX0FSQ0hf
V0FOVF9ERUZBVUxUX1RPUERPV05fTU1BUF9MQVlPVVQ9eQpDT05GSUdfQ0xPTkVfQkFDS1dB
UkRTPXkKQ09ORklHX09MRF9TSUdTVVNQRU5EMz15CkNPTkZJR19PTERfU0lHQUNUSU9OPXkK
Q09ORklHX0NPTVBBVF8zMkJJVF9USU1FPXkKQ09ORklHX0hBVkVfQVJDSF9WTUFQX1NUQUNL
PXkKQ09ORklHX1ZNQVBfU1RBQ0s9eQpDT05GSUdfQVJDSF9PUFRJT05BTF9LRVJORUxfUldY
PXkKQ09ORklHX0FSQ0hfT1BUSU9OQUxfS0VSTkVMX1JXWF9ERUZBVUxUPXkKQ09ORklHX0FS
Q0hfSEFTX1NUUklDVF9LRVJORUxfUldYPXkKQ09ORklHX1NUUklDVF9LRVJORUxfUldYPXkK
Q09ORklHX0FSQ0hfSEFTX1NUUklDVF9NT0RVTEVfUldYPXkKQ09ORklHX1NUUklDVF9NT0RV
TEVfUldYPXkKIyBDT05GSUdfTE9DS19FVkVOVF9DT1VOVFMgaXMgbm90IHNldApDT05GSUdf
QVJDSF9XQU5UX0xEX09SUEhBTl9XQVJOPXkKQ09ORklHX0hBVkVfQVJDSF9QRk5fVkFMSUQ9
eQoKIwojIEdDT1YtYmFzZWQga2VybmVsIHByb2ZpbGluZwojCiMgQ09ORklHX0dDT1ZfS0VS
TkVMIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfSEFTX0dDT1ZfUFJPRklMRV9BTEw9eQojIGVu
ZCBvZiBHQ09WLWJhc2VkIGtlcm5lbCBwcm9maWxpbmcKCkNPTkZJR19IQVZFX0dDQ19QTFVH
SU5TPXkKQ09ORklHX0ZVTkNUSU9OX0FMSUdOTUVOVD0wCiMgZW5kIG9mIEdlbmVyYWwgYXJj
aGl0ZWN0dXJlLWRlcGVuZGVudCBvcHRpb25zCgpDT05GSUdfUlRfTVVURVhFUz15CkNPTkZJ
R19NT0RVTEVTPXkKIyBDT05GSUdfTU9EVUxFX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX01P
RFVMRV9GT1JDRV9MT0FEPXkKQ09ORklHX01PRFVMRV9VTkxPQUQ9eQpDT05GSUdfTU9EVUxF
X0ZPUkNFX1VOTE9BRD15CiMgQ09ORklHX01PRFVMRV9VTkxPQURfVEFJTlRfVFJBQ0tJTkcg
aXMgbm90IHNldAojIENPTkZJR19NT0RWRVJTSU9OUyBpcyBub3Qgc2V0CiMgQ09ORklHX01P
RFVMRV9TUkNWRVJTSU9OX0FMTCBpcyBub3Qgc2V0CiMgQ09ORklHX01PRFVMRV9TSUcgaXMg
bm90IHNldAojIENPTkZJR19NT0RVTEVfQ09NUFJFU1MgaXMgbm90IHNldAojIENPTkZJR19N
T0RVTEVfQUxMT1dfTUlTU0lOR19OQU1FU1BBQ0VfSU1QT1JUUyBpcyBub3Qgc2V0CkNPTkZJ
R19NT0RQUk9CRV9QQVRIPSIvc2Jpbi9tb2Rwcm9iZSIKIyBDT05GSUdfVFJJTV9VTlVTRURf
S1NZTVMgaXMgbm90IHNldApDT05GSUdfQkxPQ0s9eQpDT05GSUdfQkxPQ0tfTEVHQUNZX0FV
VE9MT0FEPXkKQ09ORklHX0JMS19JQ1E9eQojIENPTkZJR19CTEtfREVWX0JTR0xJQiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfSU5URUdSSVRZIGlzIG5vdCBzZXQKQ09ORklHX0JM
S19ERVZfV1JJVEVfTU9VTlRFRD15CiMgQ09ORklHX0JMS19ERVZfWk9ORUQgaXMgbm90IHNl
dAojIENPTkZJR19CTEtfV0JUIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERUJVR19GUz15CiMg
Q09ORklHX0JMS19TRURfT1BBTCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19JTkxJTkVfRU5D
UllQVElPTiBpcyBub3Qgc2V0CgojCiMgUGFydGl0aW9uIFR5cGVzCiMKIyBDT05GSUdfUEFS
VElUSU9OX0FEVkFOQ0VEIGlzIG5vdCBzZXQKQ09ORklHX01TRE9TX1BBUlRJVElPTj15CkNP
TkZJR19FRklfUEFSVElUSU9OPXkKIyBlbmQgb2YgUGFydGl0aW9uIFR5cGVzCgpDT05GSUdf
QkxLX1BNPXkKCiMKIyBJTyBTY2hlZHVsZXJzCiMKQ09ORklHX01RX0lPU0NIRURfREVBRExJ
TkU9eQpDT05GSUdfTVFfSU9TQ0hFRF9LWUJFUj15CkNPTkZJR19JT1NDSEVEX0JGUT15CiMg
ZW5kIG9mIElPIFNjaGVkdWxlcnMKCkNPTkZJR19BU04xPXkKQ09ORklHX0lOTElORV9TUElO
X1VOTE9DS19JUlE9eQpDT05GSUdfSU5MSU5FX1JFQURfVU5MT0NLPXkKQ09ORklHX0lOTElO
RV9SRUFEX1VOTE9DS19JUlE9eQpDT05GSUdfSU5MSU5FX1dSSVRFX1VOTE9DSz15CkNPTkZJ
R19JTkxJTkVfV1JJVEVfVU5MT0NLX0lSUT15CkNPTkZJR19BUkNIX1NVUFBPUlRTX0FUT01J
Q19STVc9eQpDT05GSUdfQVJDSF9IQVNfTk9OX09WRVJMQVBQSU5HX0FERFJFU1NfU1BBQ0U9
eQpDT05GSUdfRlJFRVpFUj15CgojCiMgRXhlY3V0YWJsZSBmaWxlIGZvcm1hdHMKIwpDT05G
SUdfQklORk1UX0VMRj15CiMgQ09ORklHX0JJTkZNVF9FTEZfRkRQSUMgaXMgbm90IHNldApD
T05GSUdfRUxGQ09SRT15CiMgQ09ORklHX0NPUkVfRFVNUF9ERUZBVUxUX0VMRl9IRUFERVJT
IGlzIG5vdCBzZXQKQ09ORklHX0JJTkZNVF9TQ1JJUFQ9eQpDT05GSUdfQVJDSF9IQVNfQklO
Rk1UX0ZMQVQ9eQojIENPTkZJR19CSU5GTVRfRkxBVCBpcyBub3Qgc2V0CkNPTkZJR19CSU5G
TVRfRkxBVF9BUkdWUF9FTlZQX09OX1NUQUNLPXkKIyBDT05GSUdfQklORk1UX01JU0MgaXMg
bm90IHNldApDT05GSUdfQ09SRURVTVA9eQojIGVuZCBvZiBFeGVjdXRhYmxlIGZpbGUgZm9y
bWF0cwoKIwojIE1lbW9yeSBNYW5hZ2VtZW50IG9wdGlvbnMKIwojIENPTkZJR19TV0FQIGlz
IG5vdCBzZXQKCiMKIyBTbGFiIGFsbG9jYXRvciBvcHRpb25zCiMKQ09ORklHX1NMVUI9eQoj
IENPTkZJR19TTFVCX1RJTlkgaXMgbm90IHNldApDT05GSUdfU0xBQl9NRVJHRV9ERUZBVUxU
PXkKIyBDT05GSUdfU0xBQl9GUkVFTElTVF9SQU5ET00gaXMgbm90IHNldAojIENPTkZJR19T
TEFCX0ZSRUVMSVNUX0hBUkRFTkVEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0xBQl9CVUNLRVRT
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0xVQl9TVEFUUyBpcyBub3Qgc2V0CiMgQ09ORklHX1JB
TkRPTV9LTUFMTE9DX0NBQ0hFUyBpcyBub3Qgc2V0CiMgZW5kIG9mIFNsYWIgYWxsb2NhdG9y
IG9wdGlvbnMKCiMgQ09ORklHX1NIVUZGTEVfUEFHRV9BTExPQ0FUT1IgaXMgbm90IHNldApD
T05GSUdfQ09NUEFUX0JSSz15CkNPTkZJR19TRUxFQ1RfTUVNT1JZX01PREVMPXkKQ09ORklH
X0ZMQVRNRU1fTUFOVUFMPXkKIyBDT05GSUdfU1BBUlNFTUVNX01BTlVBTCBpcyBub3Qgc2V0
CkNPTkZJR19GTEFUTUVNPXkKQ09ORklHX0FSQ0hfS0VFUF9NRU1CTE9DSz15CkNPTkZJR19D
T01QQUNUSU9OPXkKQ09ORklHX0NPTVBBQ1RfVU5FVklDVEFCTEVfREVGQVVMVD0xCiMgQ09O
RklHX1BBR0VfUkVQT1JUSU5HIGlzIG5vdCBzZXQKQ09ORklHX01JR1JBVElPTj15CkNPTkZJ
R19QQ1BfQkFUQ0hfU0NBTEVfTUFYPTUKIyBDT05GSUdfS1NNIGlzIG5vdCBzZXQKQ09ORklH
X0RFRkFVTFRfTU1BUF9NSU5fQUREUj00MDk2CkNPTkZJR19BUkNIX1dBTlRfR0VORVJBTF9I
VUdFVExCPXkKQ09ORklHX1BBR0VfTUFQQ09VTlQ9eQpDT05GSUdfTkVFRF9QRVJfQ1BVX0tN
PXkKIyBDT05GSUdfQ01BIGlzIG5vdCBzZXQKQ09ORklHX0dFTkVSSUNfRUFSTFlfSU9SRU1B
UD15CiMgQ09ORklHX0lETEVfUEFHRV9UUkFDS0lORyBpcyBub3Qgc2V0CkNPTkZJR19BUkNI
X0hBU19DUFVfQ0FDSEVfQUxJQVNJTkc9eQpDT05GSUdfQVJDSF9IQVNfQ0FDSEVfTElORV9T
SVpFPXkKQ09ORklHX0FSQ0hfSEFTX0NVUlJFTlRfU1RBQ0tfUE9JTlRFUj15CkNPTkZJR19W
TV9FVkVOVF9DT1VOVEVSUz15CiMgQ09ORklHX1BFUkNQVV9TVEFUUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0dVUF9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1BUE9PTF9URVNUIGlzIG5v
dCBzZXQKQ09ORklHX01FTUZEX0NSRUFURT15CiMgQ09ORklHX0FOT05fVk1BX05BTUUgaXMg
bm90IHNldAojIENPTkZJR19VU0VSRkFVTFRGRCBpcyBub3Qgc2V0CiMgQ09ORklHX0xSVV9H
RU4gaXMgbm90IHNldApDT05GSUdfQVJDSF9TVVBQT1JUU19QRVJfVk1BX0xPQ0s9eQpDT05G
SUdfTE9DS19NTV9BTkRfRklORF9WTUE9eQpDT05GSUdfRVhFQ01FTT15CgojCiMgRGF0YSBB
Y2Nlc3MgTW9uaXRvcmluZwojCiMgQ09ORklHX0RBTU9OIGlzIG5vdCBzZXQKIyBlbmQgb2Yg
RGF0YSBBY2Nlc3MgTW9uaXRvcmluZwojIGVuZCBvZiBNZW1vcnkgTWFuYWdlbWVudCBvcHRp
b25zCgpDT05GSUdfTkVUPXkKCiMKIyBOZXR3b3JraW5nIG9wdGlvbnMKIwpDT05GSUdfUEFD
S0VUPXkKIyBDT05GSUdfUEFDS0VUX0RJQUcgaXMgbm90IHNldApDT05GSUdfVU5JWD15CkNP
TkZJR19BRl9VTklYX09PQj15CiMgQ09ORklHX1VOSVhfRElBRyBpcyBub3Qgc2V0CiMgQ09O
RklHX1RMUyBpcyBub3Qgc2V0CiMgQ09ORklHX1hGUk1fVVNFUiBpcyBub3Qgc2V0CiMgQ09O
RklHX05FVF9LRVkgaXMgbm90IHNldApDT05GSUdfTkVUX0hBTkRTSEFLRT15CkNPTkZJR19J
TkVUPXkKQ09ORklHX0lQX01VTFRJQ0FTVD15CiMgQ09ORklHX0lQX0FEVkFOQ0VEX1JPVVRF
UiBpcyBub3Qgc2V0CkNPTkZJR19JUF9QTlA9eQpDT05GSUdfSVBfUE5QX0RIQ1A9eQpDT05G
SUdfSVBfUE5QX0JPT1RQPXkKQ09ORklHX0lQX1BOUF9SQVJQPXkKIyBDT05GSUdfTkVUX0lQ
SVAgaXMgbm90IHNldAojIENPTkZJR19ORVRfSVBHUkVfREVNVVggaXMgbm90IHNldApDT05G
SUdfTkVUX0lQX1RVTk5FTD15CiMgQ09ORklHX0lQX01ST1VURSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NZTl9DT09LSUVTIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0lQVlRJIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkVUX0ZPVSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9GT1VfSVBfVFVO
TkVMUyBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfQUggaXMgbm90IHNldAojIENPTkZJR19J
TkVUX0VTUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfSVBDT01QIGlzIG5vdCBzZXQKQ09O
RklHX0lORVRfVEFCTEVfUEVSVFVSQl9PUkRFUj0xNgpDT05GSUdfSU5FVF9UVU5ORUw9eQoj
IENPTkZJR19JTkVUX0RJQUcgaXMgbm90IHNldAojIENPTkZJR19UQ1BfQ09OR19BRFZBTkNF
RCBpcyBub3Qgc2V0CkNPTkZJR19UQ1BfQ09OR19DVUJJQz15CkNPTkZJR19ERUZBVUxUX1RD
UF9DT05HPSJjdWJpYyIKIyBDT05GSUdfVENQX01ENVNJRyBpcyBub3Qgc2V0CkNPTkZJR19J
UFY2PXkKIyBDT05GSUdfSVBWNl9ST1VURVJfUFJFRiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQ
VjZfT1BUSU1JU1RJQ19EQUQgaXMgbm90IHNldAojIENPTkZJR19JTkVUNl9BSCBpcyBub3Qg
c2V0CiMgQ09ORklHX0lORVQ2X0VTUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVQ2X0lQQ09N
UCBpcyBub3Qgc2V0CiMgQ09ORklHX0lQVjZfTUlQNiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQ
VjZfVlRJIGlzIG5vdCBzZXQKQ09ORklHX0lQVjZfU0lUPXkKQ09ORklHX0lQVjZfU0lUXzZS
RD15CkNPTkZJR19JUFY2X05ESVNDX05PREVUWVBFPXkKIyBDT05GSUdfSVBWNl9UVU5ORUwg
aXMgbm90IHNldAojIENPTkZJR19JUFY2X01VTFRJUExFX1RBQkxFUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0lQVjZfTVJPVVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNl9TRUc2X0xXVFVO
TkVMIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNl9TRUc2X0hNQUMgaXMgbm90IHNldAojIENP
TkZJR19JUFY2X1JQTF9MV1RVTk5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lQVjZfSU9BTTZf
TFdUVU5ORUwgaXMgbm90IHNldAojIENPTkZJR19NUFRDUCBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVFdPUktfU0VDTUFSSyBpcyBub3Qgc2V0CkNPTkZJR19ORVRfUFRQX0NMQVNTSUZZPXkK
IyBDT05GSUdfTkVUV09SS19QSFlfVElNRVNUQU1QSU5HIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkVURklMVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfRENDUCBpcyBub3Qgc2V0CiMgQ09O
RklHX0lQX1NDVFAgaXMgbm90IHNldAojIENPTkZJR19SRFMgaXMgbm90IHNldAojIENPTkZJ
R19USVBDIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNIGlzIG5vdCBzZXQKIyBDT05GSUdfTDJU
UCBpcyBub3Qgc2V0CkNPTkZJR19TVFA9bQpDT05GSUdfQlJJREdFPW0KQ09ORklHX0JSSURH
RV9JR01QX1NOT09QSU5HPXkKQ09ORklHX0JSSURHRV9WTEFOX0ZJTFRFUklORz15CiMgQ09O
RklHX0JSSURHRV9NUlAgaXMgbm90IHNldAojIENPTkZJR19CUklER0VfQ0ZNIGlzIG5vdCBz
ZXQKQ09ORklHX05FVF9EU0E9bQojIENPTkZJR19ORVRfRFNBX1RBR19OT05FIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkVUX0RTQV9UQUdfQVI5MzMxIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVU
X0RTQV9UQUdfQlJDTSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9EU0FfVEFHX0JSQ01fTEVH
QUNZIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RTQV9UQUdfQlJDTV9QUkVQRU5EIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVUX0RTQV9UQUdfSEVMTENSRUVLIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkVUX0RTQV9UQUdfR1NXSVAgaXMgbm90IHNldAojIENPTkZJR19ORVRfRFNBX1RBR19E
U0EgaXMgbm90IHNldAojIENPTkZJR19ORVRfRFNBX1RBR19FRFNBIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVUX0RTQV9UQUdfTVRLIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RTQV9UQUdf
S1NaIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RTQV9UQUdfT0NFTE9UIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkVUX0RTQV9UQUdfT0NFTE9UXzgwMjFRIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkVUX0RTQV9UQUdfUUNBIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RTQV9UQUdfUlRMNF9B
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RTQV9UQUdfUlRMOF80IGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVUX0RTQV9UQUdfUlpOMV9BNVBTVyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9E
U0FfVEFHX0xBTjkzMDMgaXMgbm90IHNldAojIENPTkZJR19ORVRfRFNBX1RBR19TSkExMTA1
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RTQV9UQUdfVFJBSUxFUiBpcyBub3Qgc2V0CiMg
Q09ORklHX05FVF9EU0FfVEFHX1ZTQzczWFhfODAyMVEgaXMgbm90IHNldAojIENPTkZJR19O
RVRfRFNBX1RBR19YUlM3MDBYIGlzIG5vdCBzZXQKQ09ORklHX1ZMQU5fODAyMVE9bQojIENP
TkZJR19WTEFOXzgwMjFRX0dWUlAgaXMgbm90IHNldAojIENPTkZJR19WTEFOXzgwMjFRX01W
UlAgaXMgbm90IHNldApDT05GSUdfTExDPW0KIyBDT05GSUdfTExDMiBpcyBub3Qgc2V0CiMg
Q09ORklHX0FUQUxLIGlzIG5vdCBzZXQKIyBDT05GSUdfWDI1IGlzIG5vdCBzZXQKIyBDT05G
SUdfTEFQQiBpcyBub3Qgc2V0CiMgQ09ORklHX1BIT05FVCBpcyBub3Qgc2V0CiMgQ09ORklH
XzZMT1dQQU4gaXMgbm90IHNldAojIENPTkZJR19JRUVFODAyMTU0IGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVUX1NDSEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfRENCIGlzIG5vdCBzZXQKIyBD
T05GSUdfRE5TX1JFU09MVkVSIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUTUFOX0FEViBpcyBu
b3Qgc2V0CiMgQ09ORklHX09QRU5WU1dJVENIIGlzIG5vdCBzZXQKIyBDT05GSUdfVlNPQ0tF
VFMgaXMgbm90IHNldAojIENPTkZJR19ORVRMSU5LX0RJQUcgaXMgbm90IHNldAojIENPTkZJ
R19NUExTIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX05TSCBpcyBub3Qgc2V0CiMgQ09ORklH
X0hTUiBpcyBub3Qgc2V0CkNPTkZJR19ORVRfU1dJVENIREVWPXkKIyBDT05GSUdfTkVUX0wz
X01BU1RFUl9ERVYgaXMgbm90IHNldAojIENPTkZJR19RUlRSIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkVUX05DU0kgaXMgbm90IHNldApDT05GSUdfTUFYX1NLQl9GUkFHUz0xNwojIENPTkZJ
R19DR1JPVVBfTkVUX1BSSU8gaXMgbm90IHNldAojIENPTkZJR19DR1JPVVBfTkVUX0NMQVNT
SUQgaXMgbm90IHNldApDT05GSUdfTkVUX1JYX0JVU1lfUE9MTD15CkNPTkZJR19CUUw9eQoK
IwojIE5ldHdvcmsgdGVzdGluZwojCiMgQ09ORklHX05FVF9QS1RHRU4gaXMgbm90IHNldAoj
IGVuZCBvZiBOZXR3b3JrIHRlc3RpbmcKIyBlbmQgb2YgTmV0d29ya2luZyBvcHRpb25zCgoj
IENPTkZJR19IQU1SQURJTyBpcyBub3Qgc2V0CkNPTkZJR19DQU49eQpDT05GSUdfQ0FOX1JB
Vz15CkNPTkZJR19DQU5fQkNNPXkKQ09ORklHX0NBTl9HVz15CiMgQ09ORklHX0NBTl9KMTkz
OSBpcyBub3Qgc2V0CiMgQ09ORklHX0NBTl9JU09UUCBpcyBub3Qgc2V0CiMgQ09ORklHX0JU
IGlzIG5vdCBzZXQKIyBDT05GSUdfQUZfUlhSUEMgaXMgbm90IHNldAojIENPTkZJR19BRl9L
Q00gaXMgbm90IHNldAojIENPTkZJR19NQ1RQIGlzIG5vdCBzZXQKQ09ORklHX1dJUkVMRVNT
PXkKQ09ORklHX0NGRzgwMjExPXkKIyBDT05GSUdfTkw4MDIxMV9URVNUTU9ERSBpcyBub3Qg
c2V0CiMgQ09ORklHX0NGRzgwMjExX0RFVkVMT1BFUl9XQVJOSU5HUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0NGRzgwMjExX0NFUlRJRklDQVRJT05fT05VUyBpcyBub3Qgc2V0CkNPTkZJR19D
Rkc4MDIxMV9SRVFVSVJFX1NJR05FRF9SRUdEQj15CkNPTkZJR19DRkc4MDIxMV9VU0VfS0VS
TkVMX1JFR0RCX0tFWVM9eQpDT05GSUdfQ0ZHODAyMTFfREVGQVVMVF9QUz15CiMgQ09ORklH
X0NGRzgwMjExX0RFQlVHRlMgaXMgbm90IHNldApDT05GSUdfQ0ZHODAyMTFfQ1JEQV9TVVBQ
T1JUPXkKIyBDT05GSUdfQ0ZHODAyMTFfV0VYVCBpcyBub3Qgc2V0CkNPTkZJR19NQUM4MDIx
MT15CkNPTkZJR19NQUM4MDIxMV9IQVNfUkM9eQpDT05GSUdfTUFDODAyMTFfUkNfTUlOU1RS
RUw9eQpDT05GSUdfTUFDODAyMTFfUkNfREVGQVVMVF9NSU5TVFJFTD15CkNPTkZJR19NQUM4
MDIxMV9SQ19ERUZBVUxUPSJtaW5zdHJlbF9odCIKIyBDT05GSUdfTUFDODAyMTFfTUVTSCBp
cyBub3Qgc2V0CkNPTkZJR19NQUM4MDIxMV9MRURTPXkKIyBDT05GSUdfTUFDODAyMTFfREVC
VUdfTUVOVSBpcyBub3Qgc2V0CkNPTkZJR19NQUM4MDIxMV9TVEFfSEFTSF9NQVhfU0laRT0w
CiMgQ09ORklHX1JGS0lMTCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF85UCBpcyBub3Qgc2V0
CiMgQ09ORklHX0NBSUYgaXMgbm90IHNldAojIENPTkZJR19DRVBIX0xJQiBpcyBub3Qgc2V0
CiMgQ09ORklHX05GQyBpcyBub3Qgc2V0CiMgQ09ORklHX1BTQU1QTEUgaXMgbm90IHNldAoj
IENPTkZJR19ORVRfSUZFIGlzIG5vdCBzZXQKIyBDT05GSUdfTFdUVU5ORUwgaXMgbm90IHNl
dApDT05GSUdfRFNUX0NBQ0hFPXkKQ09ORklHX0dST19DRUxMUz15CkNPTkZJR19ORVRfU0VM
RlRFU1RTPXkKQ09ORklHX05FVF9ERVZMSU5LPXkKIyBDT05GSUdfRkFJTE9WRVIgaXMgbm90
IHNldApDT05GSUdfRVRIVE9PTF9ORVRMSU5LPXkKCiMKIyBEZXZpY2UgRHJpdmVycwojCkNP
TkZJR19IQVZFX1BDST15CkNPTkZJR19HRU5FUklDX1BDSV9JT01BUD15CiMgQ09ORklHX1BD
SSBpcyBub3Qgc2V0CiMgQ09ORklHX1BDQ0FSRCBpcyBub3Qgc2V0CgojCiMgR2VuZXJpYyBE
cml2ZXIgT3B0aW9ucwojCiMgQ09ORklHX1VFVkVOVF9IRUxQRVIgaXMgbm90IHNldApDT05G
SUdfREVWVE1QRlM9eQpDT05GSUdfREVWVE1QRlNfTU9VTlQ9eQojIENPTkZJR19ERVZUTVBG
U19TQUZFIGlzIG5vdCBzZXQKIyBDT05GSUdfU1RBTkRBTE9ORSBpcyBub3Qgc2V0CiMgQ09O
RklHX1BSRVZFTlRfRklSTVdBUkVfQlVJTEQgaXMgbm90IHNldAoKIwojIEZpcm13YXJlIGxv
YWRlcgojCkNPTkZJR19GV19MT0FERVI9eQpDT05GSUdfRVhUUkFfRklSTVdBUkU9IiIKIyBD
T05GSUdfRldfTE9BREVSX1VTRVJfSEVMUEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfRldfTE9B
REVSX0NPTVBSRVNTIGlzIG5vdCBzZXQKQ09ORklHX0ZXX0NBQ0hFPXkKIyBDT05GSUdfRldf
VVBMT0FEIGlzIG5vdCBzZXQKIyBlbmQgb2YgRmlybXdhcmUgbG9hZGVyCgpDT05GSUdfV0FO
VF9ERVZfQ09SRURVTVA9eQpDT05GSUdfQUxMT1dfREVWX0NPUkVEVU1QPXkKQ09ORklHX0RF
Vl9DT1JFRFVNUD15CiMgQ09ORklHX0RFQlVHX0RSSVZFUiBpcyBub3Qgc2V0CiMgQ09ORklH
X0RFQlVHX0RFVlJFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1RFU1RfRFJJVkVSX1JF
TU9WRSBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfQVNZTkNfRFJJVkVSX1BST0JFIGlzIG5v
dCBzZXQKQ09ORklHX0dFTkVSSUNfQ1BVX0RFVklDRVM9eQpDT05GSUdfR0VORVJJQ19DUFVf
QVVUT1BST0JFPXkKQ09ORklHX0dFTkVSSUNfQ1BVX1ZVTE5FUkFCSUxJVElFUz15CkNPTkZJ
R19TT0NfQlVTPXkKQ09ORklHX1JFR01BUD15CkNPTkZJR19SRUdNQVBfSTJDPXkKQ09ORklH
X1JFR01BUF9TUEk9eQpDT05GSUdfUkVHTUFQX01NSU89eQpDT05GSUdfUkVHTUFQX1NDQ0I9
bQpDT05GSUdfRE1BX1NIQVJFRF9CVUZGRVI9eQojIENPTkZJR19ETUFfRkVOQ0VfVFJBQ0Ug
aXMgbm90IHNldAojIENPTkZJR19GV19ERVZMSU5LX1NZTkNfU1RBVEVfVElNRU9VVCBpcyBu
b3Qgc2V0CiMgZW5kIG9mIEdlbmVyaWMgRHJpdmVyIE9wdGlvbnMKCiMKIyBCdXMgZGV2aWNl
cwojCiMgQ09ORklHX01PWFRFVCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZFWFBSRVNTX0NPTkZJ
RyBpcyBub3Qgc2V0CiMgQ09ORklHX01ISV9CVVMgaXMgbm90IHNldAojIENPTkZJR19NSElf
QlVTX0VQIGlzIG5vdCBzZXQKIyBlbmQgb2YgQnVzIGRldmljZXMKCiMKIyBDYWNoZSBEcml2
ZXJzCiMKIyBlbmQgb2YgQ2FjaGUgRHJpdmVycwoKIyBDT05GSUdfQ09OTkVDVE9SIGlzIG5v
dCBzZXQKCiMKIyBGaXJtd2FyZSBEcml2ZXJzCiMKCiMKIyBBUk0gU3lzdGVtIENvbnRyb2wg
YW5kIE1hbmFnZW1lbnQgSW50ZXJmYWNlIFByb3RvY29sCiMKIyBDT05GSUdfQVJNX1NDTUlf
UFJPVE9DT0wgaXMgbm90IHNldAojIGVuZCBvZiBBUk0gU3lzdGVtIENvbnRyb2wgYW5kIE1h
bmFnZW1lbnQgSW50ZXJmYWNlIFByb3RvY29sCgojIENPTkZJR19GSVJNV0FSRV9NRU1NQVAg
aXMgbm90IHNldAojIENPTkZJR19GV19DRkdfU1lTRlMgaXMgbm90IHNldAojIENPTkZJR19U
UlVTVEVEX0ZPVU5EQVRJT05TIGlzIG5vdCBzZXQKIyBDT05GSUdfR09PR0xFX0ZJUk1XQVJF
IGlzIG5vdCBzZXQKCiMKIyBRdWFsY29tbSBmaXJtd2FyZSBkcml2ZXJzCiMKIyBlbmQgb2Yg
UXVhbGNvbW0gZmlybXdhcmUgZHJpdmVycwoKQ09ORklHX0hBVkVfQVJNX1NNQ0NDPXkKCiMK
IyBUZWdyYSBmaXJtd2FyZSBkcml2ZXIKIwojIGVuZCBvZiBUZWdyYSBmaXJtd2FyZSBkcml2
ZXIKIyBlbmQgb2YgRmlybXdhcmUgRHJpdmVycwoKIyBDT05GSUdfRldDVEwgaXMgbm90IHNl
dAojIENPTkZJR19HTlNTIGlzIG5vdCBzZXQKQ09ORklHX01URD15CkNPTkZJR19NVERfVEVT
VFM9bQoKIwojIFBhcnRpdGlvbiBwYXJzZXJzCiMKQ09ORklHX01URF9DTURMSU5FX1BBUlRT
PXkKQ09ORklHX01URF9PRl9QQVJUUz15CiMgQ09ORklHX01URF9BRlNfUEFSVFMgaXMgbm90
IHNldAojIENPTkZJR19NVERfUkVEQk9PVF9QQVJUUyBpcyBub3Qgc2V0CiMgZW5kIG9mIFBh
cnRpdGlvbiBwYXJzZXJzCgojCiMgVXNlciBNb2R1bGVzIEFuZCBUcmFuc2xhdGlvbiBMYXll
cnMKIwojIENPTkZJR19NVERfQkxPQ0sgaXMgbm90IHNldAojIENPTkZJR19NVERfQkxPQ0tf
Uk8gaXMgbm90IHNldAojIENPTkZJR19GVEwgaXMgbm90IHNldAojIENPTkZJR19ORlRMIGlz
IG5vdCBzZXQKIyBDT05GSUdfSU5GVEwgaXMgbm90IHNldAojIENPTkZJR19SRkRfRlRMIGlz
IG5vdCBzZXQKIyBDT05GSUdfU1NGREMgaXMgbm90IHNldAojIENPTkZJR19TTV9GVEwgaXMg
bm90IHNldAojIENPTkZJR19NVERfT09QUyBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9QQVJU
SVRJT05FRF9NQVNURVIgaXMgbm90IHNldAoKIwojIFJBTS9ST00vRmxhc2ggY2hpcCBkcml2
ZXJzCiMKQ09ORklHX01URF9DRkk9eQojIENPTkZJR19NVERfSkVERUNQUk9CRSBpcyBub3Qg
c2V0CkNPTkZJR19NVERfR0VOX1BST0JFPXkKIyBDT05GSUdfTVREX0NGSV9BRFZfT1BUSU9O
UyBpcyBub3Qgc2V0CkNPTkZJR19NVERfTUFQX0JBTktfV0lEVEhfMT15CkNPTkZJR19NVERf
TUFQX0JBTktfV0lEVEhfMj15CkNPTkZJR19NVERfTUFQX0JBTktfV0lEVEhfND15CkNPTkZJ
R19NVERfQ0ZJX0kxPXkKQ09ORklHX01URF9DRklfSTI9eQojIENPTkZJR19NVERfQ0ZJX0lO
VEVMRVhUIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX0NGSV9BTURTVEQgaXMgbm90IHNldAoj
IENPTkZJR19NVERfQ0ZJX1NUQUEgaXMgbm90IHNldApDT05GSUdfTVREX0NGSV9VVElMPXkK
IyBDT05GSUdfTVREX1JBTSBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9ST00gaXMgbm90IHNl
dAojIENPTkZJR19NVERfQUJTRU5UIGlzIG5vdCBzZXQKIyBlbmQgb2YgUkFNL1JPTS9GbGFz
aCBjaGlwIGRyaXZlcnMKCiMKIyBNYXBwaW5nIGRyaXZlcnMgZm9yIGNoaXAgYWNjZXNzCiMK
IyBDT05GSUdfTVREX0NPTVBMRVhfTUFQUElOR1MgaXMgbm90IHNldAojIENPTkZJR19NVERf
UEhZU01BUCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9QTEFUUkFNIGlzIG5vdCBzZXQKIyBl
bmQgb2YgTWFwcGluZyBkcml2ZXJzIGZvciBjaGlwIGFjY2VzcwoKIwojIFNlbGYtY29udGFp
bmVkIE1URCBkZXZpY2UgZHJpdmVycwojCiMgQ09ORklHX01URF9EQVRBRkxBU0ggaXMgbm90
IHNldAojIENPTkZJR19NVERfTUNIUDIzSzI1NiBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9N
Q0hQNDhMNjQwIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX1NTVDI1TCBpcyBub3Qgc2V0CiMg
Q09ORklHX01URF9TTFJBTSBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9QSFJBTSBpcyBub3Qg
c2V0CiMgQ09ORklHX01URF9NVERSQU0gaXMgbm90IHNldAojIENPTkZJR19NVERfQkxPQ0sy
TVREIGlzIG5vdCBzZXQKCiMKIyBEaXNrLU9uLUNoaXAgRGV2aWNlIERyaXZlcnMKIwojIENP
TkZJR19NVERfRE9DRzMgaXMgbm90IHNldAojIGVuZCBvZiBTZWxmLWNvbnRhaW5lZCBNVEQg
ZGV2aWNlIGRyaXZlcnMKCiMKIyBOQU5ECiMKQ09ORklHX01URF9OQU5EX0NPUkU9eQojIENP
TkZJR19NVERfT05FTkFORCBpcyBub3Qgc2V0CkNPTkZJR19NVERfUkFXX05BTkQ9eQoKIwoj
IFJhdy9wYXJhbGxlbCBOQU5EIGZsYXNoIGNvbnRyb2xsZXJzCiMKIyBDT05GSUdfTVREX05B
TkRfREVOQUxJX0RUIGlzIG5vdCBzZXQKQ09ORklHX01URF9OQU5EX0FUTUVMPXkKIyBDT05G
SUdfTVREX05BTkRfQlJDTU5BTkQgaXMgbm90IHNldAojIENPTkZJR19NVERfTkFORF9NWElD
IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX05BTkRfR1BJTyBpcyBub3Qgc2V0CiMgQ09ORklH
X01URF9OQU5EX1BMQVRGT1JNIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX05BTkRfQ0FERU5D
RSBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9OQU5EX0FSQVNBTiBpcyBub3Qgc2V0CiMgQ09O
RklHX01URF9OQU5EX0lOVEVMX0xHTSBpcyBub3Qgc2V0CgojCiMgTWlzYwojCiMgQ09ORklH
X01URF9OQU5EX05BTkRTSU0gaXMgbm90IHNldAojIENPTkZJR19NVERfTkFORF9ESVNLT05D
SElQIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX1NQSV9OQU5EIGlzIG5vdCBzZXQKCiMKIyBF
Q0MgZW5naW5lIHN1cHBvcnQKIwpDT05GSUdfTVREX05BTkRfRUNDPXkKQ09ORklHX01URF9O
QU5EX0VDQ19TV19IQU1NSU5HPXkKIyBDT05GSUdfTVREX05BTkRfRUNDX1NXX0hBTU1JTkdf
U01DIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX05BTkRfRUNDX1NXX0JDSCBpcyBub3Qgc2V0
CiMgQ09ORklHX01URF9OQU5EX0VDQ19NWElDIGlzIG5vdCBzZXQKIyBlbmQgb2YgRUNDIGVu
Z2luZSBzdXBwb3J0CiMgZW5kIG9mIE5BTkQKCiMKIyBMUEREUiAmIExQRERSMiBQQ00gbWVt
b3J5IGRyaXZlcnMKIwojIENPTkZJR19NVERfTFBERFIgaXMgbm90IHNldAojIENPTkZJR19N
VERfTFBERFIyX05WTSBpcyBub3Qgc2V0CiMgZW5kIG9mIExQRERSICYgTFBERFIyIFBDTSBt
ZW1vcnkgZHJpdmVycwoKQ09ORklHX01URF9TUElfTk9SPXkKQ09ORklHX01URF9TUElfTk9S
X1VTRV80S19TRUNUT1JTPXkKIyBDT05GSUdfTVREX1NQSV9OT1JfU1dQX0RJU0FCTEUgaXMg
bm90IHNldApDT05GSUdfTVREX1NQSV9OT1JfU1dQX0RJU0FCTEVfT05fVk9MQVRJTEU9eQoj
IENPTkZJR19NVERfU1BJX05PUl9TV1BfS0VFUCBpcyBub3Qgc2V0CkNPTkZJR19NVERfVUJJ
PXkKQ09ORklHX01URF9VQklfV0xfVEhSRVNIT0xEPTQwOTYKQ09ORklHX01URF9VQklfQkVC
X0xJTUlUPTIwCkNPTkZJR19NVERfVUJJX0ZBU1RNQVA9eQojIENPTkZJR19NVERfVUJJX0dM
VUVCSSBpcyBub3Qgc2V0CkNPTkZJR19NVERfVUJJX0JMT0NLPXkKIyBDT05GSUdfTVREX1VC
SV9OVk1FTSBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9IWVBFUkJVUyBpcyBub3Qgc2V0CkNP
TkZJR19EVEM9eQpDT05GSUdfT0Y9eQojIENPTkZJR19PRl9VTklUVEVTVCBpcyBub3Qgc2V0
CkNPTkZJR19PRl9GTEFUVFJFRT15CkNPTkZJR19PRl9FQVJMWV9GTEFUVFJFRT15CkNPTkZJ
R19PRl9LT0JKPXkKQ09ORklHX09GX0FERFJFU1M9eQpDT05GSUdfT0ZfSVJRPXkKQ09ORklH
X09GX1JFU0VSVkVEX01FTT15CiMgQ09ORklHX09GX09WRVJMQVkgaXMgbm90IHNldApDT05G
SUdfQVJDSF9NSUdIVF9IQVZFX1BDX1BBUlBPUlQ9eQojIENPTkZJR19QQVJQT1JUIGlzIG5v
dCBzZXQKQ09ORklHX0JMS19ERVY9eQojIENPTkZJR19CTEtfREVWX05VTExfQkxLIGlzIG5v
dCBzZXQKIyBDT05GSUdfWlJBTSBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX0xPT1A9eQpD
T05GSUdfQkxLX0RFVl9MT09QX01JTl9DT1VOVD04CiMgQ09ORklHX0JMS19ERVZfRFJCRCBp
cyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfTkJEIGlzIG5vdCBzZXQKQ09ORklHX0JMS19E
RVZfUkFNPXkKQ09ORklHX0JMS19ERVZfUkFNX0NPVU5UPTQKQ09ORklHX0JMS19ERVZfUkFN
X1NJWkU9ODE5MgojIENPTkZJR19DRFJPTV9QS1RDRFZEIGlzIG5vdCBzZXQKIyBDT05GSUdf
QVRBX09WRVJfRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9SQkQgaXMgbm90IHNl
dAojIENPTkZJR19CTEtfREVWX1VCTEsgaXMgbm90IHNldAoKIwojIE5WTUUgU3VwcG9ydAoj
CiMgQ09ORklHX05WTUVfRkMgaXMgbm90IHNldAojIENPTkZJR19OVk1FX1RDUCBpcyBub3Qg
c2V0CiMgQ09ORklHX05WTUVfVEFSR0VUIGlzIG5vdCBzZXQKIyBlbmQgb2YgTlZNRSBTdXBw
b3J0CgojCiMgTWlzYyBkZXZpY2VzCiMKIyBDT05GSUdfQUQ1MjVYX0RQT1QgaXMgbm90IHNl
dAojIENPTkZJR19EVU1NWV9JUlEgaXMgbm90IHNldAojIENPTkZJR19SUE1CIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSUNTOTMyUzQwMSBpcyBub3Qgc2V0CkNPTkZJR19BVE1FTF9TU0M9eQoj
IENPTkZJR19FTkNMT1NVUkVfU0VSVklDRVMgaXMgbm90IHNldAojIENPTkZJR19BUERTOTgw
MkFMUyBpcyBub3Qgc2V0CiMgQ09ORklHX0lTTDI5MDAzIGlzIG5vdCBzZXQKIyBDT05GSUdf
SVNMMjkwMjAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1RTTDI1NTAgaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX0JIMTc3MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
QVBEUzk5MFggaXMgbm90IHNldAojIENPTkZJR19ITUM2MzUyIGlzIG5vdCBzZXQKIyBDT05G
SUdfRFMxNjgyIGlzIG5vdCBzZXQKIyBDT05GSUdfTEFUVElDRV9FQ1AzX0NPTkZJRyBpcyBu
b3Qgc2V0CkNPTkZJR19TUkFNPXkKQ09ORklHX1NSQU1fRVhFQz15CiMgQ09ORklHX1hJTElO
WF9TREZFQyBpcyBub3Qgc2V0CiMgQ09ORklHX09QRU5fRElDRSBpcyBub3Qgc2V0CiMgQ09O
RklHX05UU1lOQyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZDUFVfU1RBTExfREVURUNUT1IgaXMg
bm90IHNldAojIENPTkZJR19DMlBPUlQgaXMgbm90IHNldAoKIwojIEVFUFJPTSBzdXBwb3J0
CiMKQ09ORklHX0VFUFJPTV9BVDI0PXkKIyBDT05GSUdfRUVQUk9NX0FUMjUgaXMgbm90IHNl
dAojIENPTkZJR19FRVBST01fTUFYNjg3NSBpcyBub3Qgc2V0CkNPTkZJR19FRVBST01fOTND
WDY9bQojIENPTkZJR19FRVBST01fOTNYWDQ2IGlzIG5vdCBzZXQKIyBDT05GSUdfRUVQUk9N
X0lEVF84OUhQRVNYIGlzIG5vdCBzZXQKIyBDT05GSUdfRUVQUk9NX0VFMTAwNCBpcyBub3Qg
c2V0CiMgZW5kIG9mIEVFUFJPTSBzdXBwb3J0CgojIENPTkZJR19TRU5TT1JTX0xJUzNfU1BJ
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MSVMzX0kyQyBpcyBub3Qgc2V0CiMgQ09O
RklHX0FMVEVSQV9TVEFQTCBpcyBub3Qgc2V0CiMgQ09ORklHX0VDSE8gaXMgbm90IHNldAoj
IENPTkZJR19NSVNDX1JUU1hfVVNCIGlzIG5vdCBzZXQKIyBDT05GSUdfUFZQQU5JQyBpcyBu
b3Qgc2V0CiMgZW5kIG9mIE1pc2MgZGV2aWNlcwoKIwojIFNDU0kgZGV2aWNlIHN1cHBvcnQK
IwpDT05GSUdfU0NTSV9NT0Q9eQojIENPTkZJR19SQUlEX0FUVFJTIGlzIG5vdCBzZXQKQ09O
RklHX1NDU0lfQ09NTU9OPXkKQ09ORklHX1NDU0k9eQpDT05GSUdfU0NTSV9ETUE9eQpDT05G
SUdfU0NTSV9QUk9DX0ZTPXkKCiMKIyBTQ1NJIHN1cHBvcnQgdHlwZSAoZGlzaywgdGFwZSwg
Q0QtUk9NKQojCkNPTkZJR19CTEtfREVWX1NEPXkKIyBDT05GSUdfQ0hSX0RFVl9TVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfU1IgaXMgbm90IHNldAojIENPTkZJR19DSFJfREVW
X1NHIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9CU0cgaXMgbm90IHNldAojIENPTkZJ
R19DSFJfREVWX1NDSCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfQ09OU1RBTlRTIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0NTSV9MT0dHSU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9T
Q0FOX0FTWU5DIGlzIG5vdCBzZXQKCiMKIyBTQ1NJIFRyYW5zcG9ydHMKIwojIENPTkZJR19T
Q1NJX1NQSV9BVFRSUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfRkNfQVRUUlMgaXMgbm90
IHNldAojIENPTkZJR19TQ1NJX0lTQ1NJX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NT
SV9TQVNfQVRUUlMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1NBU19MSUJTQVMgaXMgbm90
IHNldAojIENPTkZJR19TQ1NJX1NSUF9BVFRSUyBpcyBub3Qgc2V0CiMgZW5kIG9mIFNDU0kg
VHJhbnNwb3J0cwoKIyBDT05GSUdfU0NTSV9MT1dMRVZFTCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NDU0lfREggaXMgbm90IHNldAojIGVuZCBvZiBTQ1NJIGRldmljZSBzdXBwb3J0CgojIENP
TkZJR19BVEEgaXMgbm90IHNldAojIENPTkZJR19NRCBpcyBub3Qgc2V0CiMgQ09ORklHX1RB
UkdFVF9DT1JFIGlzIG5vdCBzZXQKQ09ORklHX05FVERFVklDRVM9eQpDT05GSUdfTUlJPW0K
Q09ORklHX05FVF9DT1JFPXkKIyBDT05GSUdfQk9ORElORyBpcyBub3Qgc2V0CiMgQ09ORklH
X0RVTU1ZIGlzIG5vdCBzZXQKIyBDT05GSUdfV0lSRUdVQVJEIGlzIG5vdCBzZXQKIyBDT05G
SUdfRVFVQUxJWkVSIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1RFQU0gaXMgbm90IHNldAoj
IENPTkZJR19NQUNWTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWTEFOIGlzIG5vdCBzZXQK
IyBDT05GSUdfVlhMQU4gaXMgbm90IHNldAojIENPTkZJR19HRU5FVkUgaXMgbm90IHNldAoj
IENPTkZJR19CQVJFVURQIGlzIG5vdCBzZXQKIyBDT05GSUdfR1RQIGlzIG5vdCBzZXQKIyBD
T05GSUdfUEZDUCBpcyBub3Qgc2V0CiMgQ09ORklHX0FNVCBpcyBub3Qgc2V0CiMgQ09ORklH
X01BQ1NFQyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVENPTlNPTEUgaXMgbm90IHNldAojIENP
TkZJR19UVU4gaXMgbm90IHNldAojIENPTkZJR19UVU5fVk5FVF9DUk9TU19MRSBpcyBub3Qg
c2V0CiMgQ09ORklHX1ZFVEggaXMgbm90IHNldAojIENPTkZJR19OTE1PTiBpcyBub3Qgc2V0
CgojCiMgRGlzdHJpYnV0ZWQgU3dpdGNoIEFyY2hpdGVjdHVyZSBkcml2ZXJzCiMKIyBDT05G
SUdfQjUzIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RTQV9CQ01fU0YyIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkVUX0RTQV9MT09QIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RTQV9MQU5U
SVFfR1NXSVAgaXMgbm90IHNldAojIENPTkZJR19ORVRfRFNBX01UNzUzMCBpcyBub3Qgc2V0
CiMgQ09ORklHX05FVF9EU0FfTVY4OEU2MDYwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RT
QV9NSUNST0NISVBfS1NaX0NPTU1PTiBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9EU0FfTVY4
OEU2WFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RTQV9NU0NDX09DRUxPVF9FWFQgaXMg
bm90IHNldAojIENPTkZJR19ORVRfRFNBX01TQ0NfU0VWSUxMRSBpcyBub3Qgc2V0CiMgQ09O
RklHX05FVF9EU0FfQVI5MzMxIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RTQV9RQ0E4SyBp
cyBub3Qgc2V0CiMgQ09ORklHX05FVF9EU0FfU0pBMTEwNSBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVF9EU0FfWFJTNzAwWF9JMkMgaXMgbm90IHNldAojIENPTkZJR19ORVRfRFNBX1hSUzcw
MFhfTURJTyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9EU0FfUkVBTFRFSyBpcyBub3Qgc2V0
CiMgQ09ORklHX05FVF9EU0FfU01TQ19MQU45MzAzX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVF9EU0FfU01TQ19MQU45MzAzX01ESU8gaXMgbm90IHNldAojIENPTkZJR19ORVRfRFNB
X1ZJVEVTU0VfVlNDNzNYWF9TUEkgaXMgbm90IHNldAojIENPTkZJR19ORVRfRFNBX1ZJVEVT
U0VfVlNDNzNYWF9QTEFURk9STSBpcyBub3Qgc2V0CiMgZW5kIG9mIERpc3RyaWJ1dGVkIFN3
aXRjaCBBcmNoaXRlY3R1cmUgZHJpdmVycwoKQ09ORklHX0VUSEVSTkVUPXkKQ09ORklHX05F
VF9WRU5ET1JfQUxBQ1JJVEVDSD15CiMgQ09ORklHX0FMVEVSQV9UU0UgaXMgbm90IHNldApD
T05GSUdfTkVUX1ZFTkRPUl9BTUFaT049eQpDT05GSUdfTkVUX1ZFTkRPUl9BUVVBTlRJQT15
CkNPTkZJR19ORVRfVkVORE9SX0FSQz15CkNPTkZJR19ORVRfVkVORE9SX0FTSVg9eQojIENP
TkZJR19TUElfQVg4ODc5NkMgaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX0JST0FE
Q09NIGlzIG5vdCBzZXQKQ09ORklHX05FVF9WRU5ET1JfQ0FERU5DRT15CkNPTkZJR19NQUNC
PXkKQ09ORklHX01BQ0JfVVNFX0hXU1RBTVA9eQpDT05GSUdfTkVUX1ZFTkRPUl9DQVZJVU09
eQojIENPTkZJR19ORVRfVkVORE9SX0NJUlJVUyBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVO
RE9SX0NPUlRJTkE9eQojIENPTkZJR19HRU1JTklfRVRIRVJORVQgaXMgbm90IHNldApDT05G
SUdfTkVUX1ZFTkRPUl9EQVZJQ09NPXkKIyBDT05GSUdfRE05MDAwIGlzIG5vdCBzZXQKIyBD
T05GSUdfRE05MDUxIGlzIG5vdCBzZXQKIyBDT05GSUdfRE5FVCBpcyBub3Qgc2V0CkNPTkZJ
R19ORVRfVkVORE9SX0VOR0xFREVSPXkKIyBDT05GSUdfVFNORVAgaXMgbm90IHNldApDT05G
SUdfTkVUX1ZFTkRPUl9FWkNISVA9eQojIENPTkZJR19FWkNISVBfTlBTX01BTkFHRU1FTlRf
RU5FVCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfRkFSQURBWSBpcyBub3Qgc2V0
CkNPTkZJR19ORVRfVkVORE9SX0ZVTkdJQkxFPXkKQ09ORklHX05FVF9WRU5ET1JfR09PR0xF
PXkKQ09ORklHX05FVF9WRU5ET1JfSElTSUxJQ09OPXkKIyBDT05GSUdfSElYNUhEMl9HTUFD
IGlzIG5vdCBzZXQKIyBDT05GSUdfSElTSV9GRU1BQyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJ
UDA0X0VUSCBpcyBub3Qgc2V0CiMgQ09ORklHX0hOU19EU0FGIGlzIG5vdCBzZXQKIyBDT05G
SUdfSE5TX0VORVQgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9IVUFXRUk9eQojIENP
TkZJR19ORVRfVkVORE9SX0lOVEVMIGlzIG5vdCBzZXQKQ09ORklHX05FVF9WRU5ET1JfQURJ
PXkKIyBDT05GSUdfQURJTjExMTAgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9MSVRF
WD15CiMgQ09ORklHX0xJVEVYX0xJVEVFVEggaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVO
RE9SX01BUlZFTEwgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9NRUxMQU5PWD15CiMg
Q09ORklHX01MWFNXX0NPUkUgaXMgbm90IHNldAojIENPTkZJR19NTFhGVyBpcyBub3Qgc2V0
CkNPTkZJR19ORVRfVkVORE9SX01FVEE9eQojIENPTkZJR19ORVRfVkVORE9SX01JQ1JFTCBp
cyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfTUlDUk9DSElQIGlzIG5vdCBzZXQKQ09O
RklHX05FVF9WRU5ET1JfTUlDUk9TRU1JPXkKIyBDT05GSUdfTVNDQ19PQ0VMT1RfU1dJVENI
IGlzIG5vdCBzZXQKQ09ORklHX05FVF9WRU5ET1JfTUlDUk9TT0ZUPXkKQ09ORklHX05FVF9W
RU5ET1JfTkk9eQojIENPTkZJR19OSV9YR0VfTUFOQUdFTUVOVF9FTkVUIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkVUX1ZFTkRPUl9OQVRTRU1JIGlzIG5vdCBzZXQKQ09ORklHX05FVF9WRU5E
T1JfTkVUUk9OT01FPXkKIyBDT05GSUdfRVRIT0MgaXMgbm90IHNldApDT05GSUdfTkVUX1ZF
TkRPUl9QRU5TQU5ETz15CkNPTkZJR19ORVRfVkVORE9SX1FVQUxDT01NPXkKIyBDT05GSUdf
UUNBNzAwMF9TUEkgaXMgbm90IHNldAojIENPTkZJR19RQ09NX0VNQUMgaXMgbm90IHNldAoj
IENPTkZJR19STU5FVCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX1JFTkVTQVM9eQpD
T05GSUdfTkVUX1ZFTkRPUl9ST0NLRVI9eQpDT05GSUdfTkVUX1ZFTkRPUl9TQU1TVU5HPXkK
IyBDT05GSUdfU1hHQkVfRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9TRUVR
IGlzIG5vdCBzZXQKQ09ORklHX05FVF9WRU5ET1JfU09MQVJGTEFSRT15CiMgQ09ORklHX05F
VF9WRU5ET1JfU01TQyBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX1NPQ0lPTkVYVD15
CiMgQ09ORklHX05FVF9WRU5ET1JfU1RNSUNSTyBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVO
RE9SX1NZTk9QU1lTPXkKIyBDT05GSUdfRFdDX1hMR01BQyBpcyBub3Qgc2V0CkNPTkZJR19O
RVRfVkVORE9SX1ZFUlRFWENPTT15CiMgQ09ORklHX01TRTEwMlggaXMgbm90IHNldApDT05G
SUdfTkVUX1ZFTkRPUl9WSUE9eQojIENPTkZJR19WSUFfVkVMT0NJVFkgaXMgbm90IHNldApD
T05GSUdfTkVUX1ZFTkRPUl9XQU5HWFVOPXkKIyBDT05GSUdfTkVUX1ZFTkRPUl9XSVpORVQg
aXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9YSUxJTlg9eQojIENPTkZJR19YSUxJTlhf
RU1BQ0xJVEUgaXMgbm90IHNldAojIENPTkZJR19YSUxJTlhfTExfVEVNQUMgaXMgbm90IHNl
dApDT05GSUdfUEhZTElOSz15CkNPTkZJR19QSFlMSUI9eQpDT05GSUdfU1dQSFk9eQojIENP
TkZJR19MRURfVFJJR0dFUl9QSFkgaXMgbm90IHNldApDT05GSUdfUEhZTElCX0xFRFM9eQpD
T05GSUdfRklYRURfUEhZPXkKIyBDT05GSUdfU0ZQIGlzIG5vdCBzZXQKCiMKIyBNSUkgUEhZ
IGRldmljZSBkcml2ZXJzCiMKIyBDT05GSUdfQUlSX0VOODgxMUhfUEhZIGlzIG5vdCBzZXQK
IyBDT05GSUdfQU1EX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX0FESU5fUEhZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQURJTjExMDBfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfQVFVQU5USUFf
UEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfQVg4ODc5NkJfUEhZIGlzIG5vdCBzZXQKIyBDT05G
SUdfQlJPQURDT01fUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfQkNNNTQxNDBfUEhZIGlzIG5v
dCBzZXQKIyBDT05GSUdfQkNNN1hYWF9QSFkgaXMgbm90IHNldAojIENPTkZJR19CQ004NDg4
MV9QSFkgaXMgbm90IHNldAojIENPTkZJR19CQ004N1hYX1BIWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0NJQ0FEQV9QSFkgaXMgbm90IHNldAojIENPTkZJR19DT1JUSU5BX1BIWSBpcyBub3Qg
c2V0CiMgQ09ORklHX0RBVklDT01fUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfSUNQTFVTX1BI
WSBpcyBub3Qgc2V0CiMgQ09ORklHX0xYVF9QSFkgaXMgbm90IHNldAojIENPTkZJR19JTlRF
TF9YV0FZX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX0xTSV9FVDEwMTFDX1BIWSBpcyBub3Qg
c2V0CiMgQ09ORklHX01BUlZFTExfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfTUFSVkVMTF8x
MEdfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfTUFSVkVMTF84OFEyWFhYX1BIWSBpcyBub3Qg
c2V0CiMgQ09ORklHX01BUlZFTExfODhYMjIyMl9QSFkgaXMgbm90IHNldAojIENPTkZJR19N
QVhMSU5FQVJfR1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX01FRElBVEVLX0dFX1BIWSBpcyBu
b3Qgc2V0CkNPTkZJR19NSUNSRUxfUEhZPXkKIyBDT05GSUdfTUlDUk9DSElQX1QxU19QSFkg
aXMgbm90IHNldApDT05GSUdfTUlDUk9DSElQX1BIWT1tCiMgQ09ORklHX01JQ1JPQ0hJUF9U
MV9QSFkgaXMgbm90IHNldAojIENPTkZJR19NSUNST1NFTUlfUEhZIGlzIG5vdCBzZXQKIyBD
T05GSUdfTU9UT1JDT01NX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX05BVElPTkFMX1BIWSBp
cyBub3Qgc2V0CiMgQ09ORklHX05YUF9DQlRYX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX05Y
UF9DNDVfVEpBMTFYWF9QSFkgaXMgbm90IHNldAojIENPTkZJR19OWFBfVEpBMTFYWF9QSFkg
aXMgbm90IHNldAojIENPTkZJR19OQ04yNjAwMF9QSFkgaXMgbm90IHNldAojIENPTkZJR19B
VDgwM1hfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfUUNBODNYWF9QSFkgaXMgbm90IHNldAoj
IENPTkZJR19RQ0E4MDhYX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1FDQTgwN1hfUEhZIGlz
IG5vdCBzZXQKIyBDT05GSUdfUVNFTUlfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVBTFRF
S19QSFkgaXMgbm90IHNldAojIENPTkZJR19SRU5FU0FTX1BIWSBpcyBub3Qgc2V0CiMgQ09O
RklHX1JPQ0tDSElQX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NNU0NfUEhZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU1RFMTBYUCBpcyBub3Qgc2V0CiMgQ09ORklHX1RFUkFORVRJQ1NfUEhZ
IGlzIG5vdCBzZXQKIyBDT05GSUdfRFA4MzgyMl9QSFkgaXMgbm90IHNldAojIENPTkZJR19E
UDgzVEM4MTFfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfRFA4Mzg0OF9QSFkgaXMgbm90IHNl
dAojIENPTkZJR19EUDgzODY3X1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX0RQODM4NjlfUEhZ
IGlzIG5vdCBzZXQKIyBDT05GSUdfRFA4M1RENTEwX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklH
X0RQODNURzcyMF9QSFkgaXMgbm90IHNldAojIENPTkZJR19WSVRFU1NFX1BIWSBpcyBub3Qg
c2V0CiMgQ09ORklHX1hJTElOWF9HTUlJMlJHTUlJIGlzIG5vdCBzZXQKIyBDT05GSUdfTUlD
UkVMX0tTODk5NU1BIGlzIG5vdCBzZXQKIyBDT05GSUdfUFNFX0NPTlRST0xMRVIgaXMgbm90
IHNldApDT05GSUdfQ0FOX0RFVj15CiMgQ09ORklHX0NBTl9WQ0FOIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ0FOX1ZYQ0FOIGlzIG5vdCBzZXQKQ09ORklHX0NBTl9ORVRMSU5LPXkKQ09ORklH
X0NBTl9DQUxDX0JJVFRJTUlORz15CkNPTkZJR19DQU5fUlhfT0ZGTE9BRD15CkNPTkZJR19D
QU5fQVQ5MT15CiMgQ09ORklHX0NBTl9DQU4zMjcgaXMgbm90IHNldAojIENPTkZJR19DQU5f
RkxFWENBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0NBTl9HUkNBTiBpcyBub3Qgc2V0CiMgQ09O
RklHX0NBTl9TTENBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0NBTl9USV9IRUNDIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ0FOX0NfQ0FOIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FOX0NDNzcwIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ0FOX0NUVUNBTkZEX1BMQVRGT1JNIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ0FOX0lGSV9DQU5GRCBpcyBub3Qgc2V0CkNPTkZJR19DQU5fTV9DQU49eQpDT05G
SUdfQ0FOX01fQ0FOX1BMQVRGT1JNPXkKIyBDT05GSUdfQ0FOX01fQ0FOX1RDQU40WDVYIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ0FOX1NKQTEwMDAgaXMgbm90IHNldAojIENPTkZJR19DQU5f
U09GVElORyBpcyBub3Qgc2V0CgojCiMgQ0FOIFNQSSBpbnRlcmZhY2VzCiMKIyBDT05GSUdf
Q0FOX0hJMzExWCBpcyBub3Qgc2V0CiMgQ09ORklHX0NBTl9NQ1AyNTFYIGlzIG5vdCBzZXQK
IyBDT05GSUdfQ0FOX01DUDI1MVhGRCBpcyBub3Qgc2V0CiMgZW5kIG9mIENBTiBTUEkgaW50
ZXJmYWNlcwoKIwojIENBTiBVU0IgaW50ZXJmYWNlcwojCiMgQ09ORklHX0NBTl84REVWX1VT
QiBpcyBub3Qgc2V0CiMgQ09ORklHX0NBTl9FTVNfVVNCIGlzIG5vdCBzZXQKIyBDT05GSUdf
Q0FOX0VTRF9VU0IgaXMgbm90IHNldAojIENPTkZJR19DQU5fRVRBU19FUzU4WCBpcyBub3Qg
c2V0CiMgQ09ORklHX0NBTl9GODE2MDQgaXMgbm90IHNldAojIENPTkZJR19DQU5fR1NfVVNC
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FOX0tWQVNFUl9VU0IgaXMgbm90IHNldAojIENPTkZJ
R19DQU5fTUNCQV9VU0IgaXMgbm90IHNldAojIENPTkZJR19DQU5fUEVBS19VU0IgaXMgbm90
IHNldAojIENPTkZJR19DQU5fVUNBTiBpcyBub3Qgc2V0CiMgZW5kIG9mIENBTiBVU0IgaW50
ZXJmYWNlcwoKIyBDT05GSUdfQ0FOX0RFQlVHX0RFVklDRVMgaXMgbm90IHNldApDT05GSUdf
TURJT19ERVZJQ0U9eQpDT05GSUdfTURJT19CVVM9eQpDT05GSUdfRldOT0RFX01ESU89eQpD
T05GSUdfT0ZfTURJTz15CkNPTkZJR19NRElPX0RFVlJFUz15CiMgQ09ORklHX01ESU9fQklU
QkFORyBpcyBub3Qgc2V0CiMgQ09ORklHX01ESU9fQkNNX1VOSU1BQyBpcyBub3Qgc2V0CiMg
Q09ORklHX01ESU9fSElTSV9GRU1BQyBpcyBub3Qgc2V0CiMgQ09ORklHX01ESU9fTVZVU0Ig
aXMgbm90IHNldAojIENPTkZJR19NRElPX01TQ0NfTUlJTSBpcyBub3Qgc2V0CiMgQ09ORklH
X01ESU9fSVBRNDAxOSBpcyBub3Qgc2V0CiMgQ09ORklHX01ESU9fSVBRODA2NCBpcyBub3Qg
c2V0CgojCiMgTURJTyBNdWx0aXBsZXhlcnMKIwojIENPTkZJR19NRElPX0JVU19NVVhfR1BJ
TyBpcyBub3Qgc2V0CiMgQ09ORklHX01ESU9fQlVTX01VWF9NVUxUSVBMRVhFUiBpcyBub3Qg
c2V0CiMgQ09ORklHX01ESU9fQlVTX01VWF9NTUlPUkVHIGlzIG5vdCBzZXQKCiMKIyBQQ1Mg
ZGV2aWNlIGRyaXZlcnMKIwojIENPTkZJR19QQ1NfWFBDUyBpcyBub3Qgc2V0CiMgZW5kIG9m
IFBDUyBkZXZpY2UgZHJpdmVycwoKIyBDT05GSUdfUFBQIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0xJUCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfTkVUX0RSSVZFUlM9eQojIENPTkZJR19VU0Jf
Q0FUQyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9LQVdFVEggaXMgbm90IHNldAojIENPTkZJ
R19VU0JfUEVHQVNVUyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9SVEw4MTUwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1JUTDgxNTIgaXMgbm90IHNldApDT05GSUdfVVNCX0xBTjc4WFg9
bQojIENPTkZJR19VU0JfVVNCTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lQSEVUSCBp
cyBub3Qgc2V0CkNPTkZJR19XTEFOPXkKQ09ORklHX1dMQU5fVkVORE9SX0FETVRFSz15CkNP
TkZJR19XTEFOX1ZFTkRPUl9BVEg9eQojIENPTkZJR19BVEhfREVCVUcgaXMgbm90IHNldAoj
IENPTkZJR19BVEg5SyBpcyBub3Qgc2V0CiMgQ09ORklHX0FUSDlLX0hUQyBpcyBub3Qgc2V0
CiMgQ09ORklHX0NBUkw5MTcwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRINktMIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVI1NTIzIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRIMTBLIGlzIG5vdCBz
ZXQKIyBDT05GSUdfV0NOMzZYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUSDExSyBpcyBub3Qg
c2V0CkNPTkZJR19XTEFOX1ZFTkRPUl9BVE1FTD15CiMgQ09ORklHX0FUNzZDNTBYX1VTQiBp
cyBub3Qgc2V0CkNPTkZJR19XTEFOX1ZFTkRPUl9CUk9BRENPTT15CiMgQ09ORklHX0I0MyBp
cyBub3Qgc2V0CiMgQ09ORklHX0I0M0xFR0FDWSBpcyBub3Qgc2V0CiMgQ09ORklHX0JSQ01T
TUFDIGlzIG5vdCBzZXQKIyBDT05GSUdfQlJDTUZNQUMgaXMgbm90IHNldApDT05GSUdfV0xB
Tl9WRU5ET1JfSU5URUw9eQpDT05GSUdfV0xBTl9WRU5ET1JfSU5URVJTSUw9eQojIENPTkZJ
R19QNTRfQ09NTU9OIGlzIG5vdCBzZXQKQ09ORklHX1dMQU5fVkVORE9SX01BUlZFTEw9eQoj
IENPTkZJR19MSUJFUlRBUyBpcyBub3Qgc2V0CkNPTkZJR19MSUJFUlRBU19USElORklSTT1t
CiMgQ09ORklHX0xJQkVSVEFTX1RISU5GSVJNX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0xJ
QkVSVEFTX1RISU5GSVJNX1VTQj1tCkNPTkZJR19NV0lGSUVYPW0KQ09ORklHX01XSUZJRVhf
U0RJTz1tCkNPTkZJR19NV0lGSUVYX1VTQj1tCkNPTkZJR19XTEFOX1ZFTkRPUl9NRURJQVRF
Sz15CiMgQ09ORklHX01UNzYwMVUgaXMgbm90IHNldAojIENPTkZJR19NVDc2eDBVIGlzIG5v
dCBzZXQKIyBDT05GSUdfTVQ3NngyVSBpcyBub3Qgc2V0CiMgQ09ORklHX01UNzY2M1UgaXMg
bm90IHNldAojIENPTkZJR19NVDc2NjNTIGlzIG5vdCBzZXQKIyBDT05GSUdfTVQ3OTIxUyBp
cyBub3Qgc2V0CiMgQ09ORklHX01UNzkyMVUgaXMgbm90IHNldAojIENPTkZJR19NVDc5MjVV
IGlzIG5vdCBzZXQKQ09ORklHX1dMQU5fVkVORE9SX01JQ1JPQ0hJUD15CiMgQ09ORklHX1dJ
TEMxMDAwX1NESU8gaXMgbm90IHNldAojIENPTkZJR19XSUxDMTAwMF9TUEkgaXMgbm90IHNl
dApDT05GSUdfV0xBTl9WRU5ET1JfUFVSRUxJRkk9eQojIENPTkZJR19QTEZYTEMgaXMgbm90
IHNldApDT05GSUdfV0xBTl9WRU5ET1JfUkFMSU5LPXkKQ09ORklHX1JUMlgwMD1tCkNPTkZJ
R19SVDI1MDBVU0I9bQpDT05GSUdfUlQ3M1VTQj1tCkNPTkZJR19SVDI4MDBVU0I9bQpDT05G
SUdfUlQyODAwVVNCX1JUMzNYWD15CkNPTkZJR19SVDI4MDBVU0JfUlQzNVhYPXkKIyBDT05G
SUdfUlQyODAwVVNCX1JUMzU3MyBpcyBub3Qgc2V0CkNPTkZJR19SVDI4MDBVU0JfUlQ1M1hY
PXkKQ09ORklHX1JUMjgwMFVTQl9SVDU1WFg9eQpDT05GSUdfUlQyODAwVVNCX1VOS05PV049
eQpDT05GSUdfUlQyODAwX0xJQj1tCkNPTkZJR19SVDJYMDBfTElCX1VTQj1tCkNPTkZJR19S
VDJYMDBfTElCPW0KQ09ORklHX1JUMlgwMF9MSUJfRklSTVdBUkU9eQpDT05GSUdfUlQyWDAw
X0xJQl9DUllQVE89eQpDT05GSUdfUlQyWDAwX0xJQl9MRURTPXkKIyBDT05GSUdfUlQyWDAw
X0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1dMQU5fVkVORE9SX1JFQUxURUs9eQpDT05GSUdf
UlRMODE4Nz1tCkNPTkZJR19SVEw4MTg3X0xFRFM9eQpDT05GSUdfUlRMX0NBUkRTPXkKIyBD
T05GSUdfUlRMODE5MkNVIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRMODE5MkRVIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUlRMOFhYWFUgaXMgbm90IHNldAojIENPTkZJR19SVFc4OCBpcyBub3Qg
c2V0CiMgQ09ORklHX1JUVzg5IGlzIG5vdCBzZXQKQ09ORklHX1dMQU5fVkVORE9SX1JTST15
CiMgQ09ORklHX1JTSV85MVggaXMgbm90IHNldApDT05GSUdfV0xBTl9WRU5ET1JfU0lMQUJT
PXkKIyBDT05GSUdfV0ZYIGlzIG5vdCBzZXQKQ09ORklHX1dMQU5fVkVORE9SX1NUPXkKIyBD
T05GSUdfQ1cxMjAwIGlzIG5vdCBzZXQKQ09ORklHX1dMQU5fVkVORE9SX1RJPXkKIyBDT05G
SUdfV0wxMjUxIGlzIG5vdCBzZXQKIyBDT05GSUdfV0wxMlhYIGlzIG5vdCBzZXQKIyBDT05G
SUdfV0wxOFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfV0xDT1JFIGlzIG5vdCBzZXQKQ09ORklH
X1dMQU5fVkVORE9SX1pZREFTPXkKIyBDT05GSUdfWkQxMjExUlcgaXMgbm90IHNldApDT05G
SUdfV0xBTl9WRU5ET1JfUVVBTlRFTk5BPXkKIyBDT05GSUdfTUFDODAyMTFfSFdTSU0gaXMg
bm90IHNldAojIENPTkZJR19WSVJUX1dJRkkgaXMgbm90IHNldAojIENPTkZJR19XQU4gaXMg
bm90IHNldAoKIwojIFdpcmVsZXNzIFdBTgojCiMgQ09ORklHX1dXQU4gaXMgbm90IHNldAoj
IGVuZCBvZiBXaXJlbGVzcyBXQU4KCiMgQ09ORklHX05FVERFVlNJTSBpcyBub3Qgc2V0CiMg
Q09ORklHX05FVF9GQUlMT1ZFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lTRE4gaXMgbm90IHNl
dAoKIwojIElucHV0IGRldmljZSBzdXBwb3J0CiMKQ09ORklHX0lOUFVUPXkKQ09ORklHX0lO
UFVUX0xFRFM9eQojIENPTkZJR19JTlBVVF9GRl9NRU1MRVNTIGlzIG5vdCBzZXQKIyBDT05G
SUdfSU5QVVRfU1BBUlNFS01BUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX01BVFJJWEtN
QVAgaXMgbm90IHNldAoKIwojIFVzZXJsYW5kIGludGVyZmFjZXMKIwojIENPTkZJR19JTlBV
VF9NT1VTRURFViBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0pPWURFViBpcyBub3Qgc2V0
CkNPTkZJR19JTlBVVF9FVkRFVj15CgojCiMgSW5wdXQgRGV2aWNlIERyaXZlcnMKIwpDT05G
SUdfSU5QVVRfS0VZQk9BUkQ9eQojIENPTkZJR19LRVlCT0FSRF9BREMgaXMgbm90IHNldAoj
IENPTkZJR19LRVlCT0FSRF9BRFA1NTg4IGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRf
QURQNTU4OSBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX0FUS0JEIGlzIG5vdCBzZXQK
IyBDT05GSUdfS0VZQk9BUkRfUVQxMDUwIGlzIG5vdCBzZXQKQ09ORklHX0tFWUJPQVJEX1FU
MTA3MD15CiMgQ09ORklHX0tFWUJPQVJEX1FUMjE2MCBpcyBub3Qgc2V0CiMgQ09ORklHX0tF
WUJPQVJEX0RMSU5LX0RJUjY4NSBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX0xLS0JE
IGlzIG5vdCBzZXQKQ09ORklHX0tFWUJPQVJEX0dQSU89eQojIENPTkZJR19LRVlCT0FSRF9H
UElPX1BPTExFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1RDQTY0MTYgaXMgbm90
IHNldAojIENPTkZJR19LRVlCT0FSRF9UQ0E4NDE4IGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZ
Qk9BUkRfTUFUUklYIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTE04MzIzIGlzIG5v
dCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTE04MzMzIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZ
Qk9BUkRfTUFYNzM1OSBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX01QUjEyMSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX05FV1RPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0tF
WUJPQVJEX09QRU5DT1JFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1BJTkVQSE9O
RSBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1NBTVNVTkcgaXMgbm90IHNldAojIENP
TkZJR19LRVlCT0FSRF9TVE9XQVdBWSBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1NV
TktCRCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX09NQVA0IGlzIG5vdCBzZXQKIyBD
T05GSUdfS0VZQk9BUkRfVE0yX1RPVUNIS0VZIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9B
UkRfWFRLQkQgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9DQVAxMVhYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfS0VZQk9BUkRfQkNNIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRf
Q1lQUkVTU19TRiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX01PVVNFIGlzIG5vdCBzZXQK
IyBDT05GSUdfSU5QVVRfSk9ZU1RJQ0sgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9UQUJM
RVQgaXMgbm90IHNldApDT05GSUdfSU5QVVRfVE9VQ0hTQ1JFRU49eQojIENPTkZJR19UT1VD
SFNDUkVFTl9BRFM3ODQ2IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQUQ3ODc3
IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQUQ3ODc5IGlzIG5vdCBzZXQKQ09O
RklHX1RPVUNIU0NSRUVOX0FEQz15CiMgQ09ORklHX1RPVUNIU0NSRUVOX0FSMTAyMV9JMkMg
aXMgbm90IHNldApDT05GSUdfVE9VQ0hTQ1JFRU5fQVRNRUxfTVhUPXkKIyBDT05GSUdfVE9V
Q0hTQ1JFRU5fQVRNRUxfTVhUX1QzNyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVO
X0FVT19QSVhDSVIgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9CVTIxMDEzIGlz
IG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQlUyMTAyOSBpcyBub3Qgc2V0CiMgQ09O
RklHX1RPVUNIU0NSRUVOX0NISVBPTkVfSUNOODMxOCBpcyBub3Qgc2V0CiMgQ09ORklHX1RP
VUNIU0NSRUVOX0NZOENUTUExNDAgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9D
WThDVE1HMTEwIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQ1lUVFNQX0NPUkUg
aXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9DWVRUU1A1IGlzIG5vdCBzZXQKIyBD
T05GSUdfVE9VQ0hTQ1JFRU5fRFlOQVBSTyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NS
RUVOX0hBTVBTSElSRSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0VFVEkgaXMg
bm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9FR0FMQVggaXMgbm90IHNldAojIENPTkZJ
R19UT1VDSFNDUkVFTl9FR0FMQVhfU0VSSUFMIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hT
Q1JFRU5fRVhDMzAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0ZVSklUU1Ug
aXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9HT09ESVggaXMgbm90IHNldAojIENP
TkZJR19UT1VDSFNDUkVFTl9HT09ESVhfQkVSTElOX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklH
X1RPVUNIU0NSRUVOX0dPT0RJWF9CRVJMSU5fU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9V
Q0hTQ1JFRU5fSElERUVQIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fSFlDT05f
SFk0NlhYIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fSFlOSVRST05fQ1NUWFhY
IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fSUxJMjEwWCBpcyBub3Qgc2V0CiMg
Q09ORklHX1RPVUNIU0NSRUVOX0lMSVRFSyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NS
RUVOX1M2U1k3NjEgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9HVU5aRSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0VLVEYyMTI3IGlzIG5vdCBzZXQKIyBDT05G
SUdfVE9VQ0hTQ1JFRU5fRUxBTiBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0VM
TyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1dBQ09NX1c4MDAxIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fV0FDT01fSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdf
VE9VQ0hTQ1JFRU5fTUFYMTE4MDEgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9N
TVMxMTQgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9NRUxGQVNfTUlQNCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX01TRzI2MzggaXMgbm90IHNldAojIENPTkZJ
R19UT1VDSFNDUkVFTl9NVE9VQ0ggaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9O
T1ZBVEVLX05WVF9UUyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0lNQUdJUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0lNWDZVTF9UU0MgaXMgbm90IHNldAoj
IENPTkZJR19UT1VDSFNDUkVFTl9JTkVYSU8gaXMgbm90IHNldAojIENPTkZJR19UT1VDSFND
UkVFTl9QRU5NT1VOVCBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0VEVF9GVDVY
MDYgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9UT1VDSFJJR0hUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVE9VQ0hXSU4gaXMgbm90IHNldAojIENPTkZJR19U
T1VDSFNDUkVFTl9QSVhDSVIgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9XRFQ4
N1hYX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1VTQl9DT01QT1NJVEUg
aXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9UT1VDSElUMjEzIGlzIG5vdCBzZXQK
IyBDT05GSUdfVE9VQ0hTQ1JFRU5fVFNDX1NFUklPIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9V
Q0hTQ1JFRU5fVFNDMjAwNCBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1RTQzIw
MDUgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9UU0MyMDA3IGlzIG5vdCBzZXQK
IyBDT05GSUdfVE9VQ0hTQ1JFRU5fUk1fVFMgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFND
UkVFTl9TSUxFQUQgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9TSVNfSTJDIGlz
IG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fU1QxMjMyIGlzIG5vdCBzZXQKIyBDT05G
SUdfVE9VQ0hTQ1JFRU5fU1RNRlRTIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5f
U1VSNDAgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9TVVJGQUNFM19TUEkgaXMg
bm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9TWDg2NTQgaXMgbm90IHNldAojIENPTkZJ
R19UT1VDSFNDUkVFTl9UUFM2NTA3WCBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVO
X1pFVDYyMjMgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9aRk9SQ0UgaXMgbm90
IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9DT0xJQlJJX1ZGNTAgaXMgbm90IHNldAojIENP
TkZJR19UT1VDSFNDUkVFTl9ST0hNX0JVMjEwMjMgaXMgbm90IHNldAojIENPTkZJR19UT1VD
SFNDUkVFTl9JUVM1WFggaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9JUVM3MjEx
IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fWklOSVRJWCBpcyBub3Qgc2V0CiMg
Q09ORklHX1RPVUNIU0NSRUVOX0hJTUFYX0hYODMxMTJCIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5QVVRfTUlTQyBpcyBub3Qgc2V0CiMgQ09ORklHX1JNSTRfQ09SRSBpcyBub3Qgc2V0Cgoj
CiMgSGFyZHdhcmUgSS9PIHBvcnRzCiMKIyBDT05GSUdfU0VSSU8gaXMgbm90IHNldAojIENP
TkZJR19HQU1FUE9SVCBpcyBub3Qgc2V0CiMgZW5kIG9mIEhhcmR3YXJlIEkvTyBwb3J0cwoj
IGVuZCBvZiBJbnB1dCBkZXZpY2Ugc3VwcG9ydAoKIwojIENoYXJhY3RlciBkZXZpY2VzCiMK
Q09ORklHX1RUWT15CkNPTkZJR19WVD15CkNPTkZJR19DT05TT0xFX1RSQU5TTEFUSU9OUz15
CkNPTkZJR19WVF9DT05TT0xFPXkKQ09ORklHX1ZUX0NPTlNPTEVfU0xFRVA9eQojIENPTkZJ
R19WVF9IV19DT05TT0xFX0JJTkRJTkcgaXMgbm90IHNldApDT05GSUdfVU5JWDk4X1BUWVM9
eQpDT05GSUdfTEVHQUNZX1BUWVM9eQpDT05GSUdfTEVHQUNZX1BUWV9DT1VOVD00CkNPTkZJ
R19MRUdBQ1lfVElPQ1NUST15CkNPTkZJR19MRElTQ19BVVRPTE9BRD15CgojCiMgU2VyaWFs
IGRyaXZlcnMKIwpDT05GSUdfU0VSSUFMX0VBUkxZQ09OPXkKIyBDT05GSUdfU0VSSUFMXzgy
NTAgaXMgbm90IHNldAoKIwojIE5vbi04MjUwIHNlcmlhbCBwb3J0IHN1cHBvcnQKIwojIENP
TkZJR19TRVJJQUxfRUFSTFlDT05fU0VNSUhPU1QgaXMgbm90IHNldApDT05GSUdfU0VSSUFM
X0FUTUVMPXkKQ09ORklHX1NFUklBTF9BVE1FTF9DT05TT0xFPXkKQ09ORklHX1NFUklBTF9B
VE1FTF9QREM9eQojIENPTkZJR19TRVJJQUxfQVRNRUxfVFRZQVQgaXMgbm90IHNldAojIENP
TkZJR19TRVJJQUxfTUFYMzEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9NQVgzMTBY
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX1VBUlRMSVRFIGlzIG5vdCBzZXQKQ09ORklH
X1NFUklBTF9DT1JFPXkKQ09ORklHX1NFUklBTF9DT1JFX0NPTlNPTEU9eQojIENPTkZJR19T
RVJJQUxfU0lGSVZFIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX1NDQ05YUCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFUklBTF9TQzE2SVM3WFggaXMgbm90IHNldAojIENPTkZJR19TRVJJ
QUxfQUxURVJBX0pUQUdVQVJUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX0FMVEVSQV9V
QVJUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX1hJTElOWF9QU19VQVJUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VSSUFMX0FSQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9GU0xf
TFBVQVJUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX0ZTTF9MSU5GTEVYVUFSVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFUklBTF9DT05FWEFOVF9ESUdJQ09MT1IgaXMgbm90IHNldAoj
IENPTkZJR19TRVJJQUxfU1RfQVNDIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX1NQUkQg
aXMgbm90IHNldAojIGVuZCBvZiBTZXJpYWwgZHJpdmVycwoKQ09ORklHX1NFUklBTF9NQ1RS
TF9HUElPPXkKIyBDT05GSUdfU0VSSUFMX05PTlNUQU5EQVJEIGlzIG5vdCBzZXQKIyBDT05G
SUdfTl9HU00gaXMgbm90IHNldAojIENPTkZJR19OVUxMX1RUWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0hWQ19EQ0MgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfREVWX0JVUyBpcyBub3Qg
c2V0CiMgQ09ORklHX1RUWV9QUklOVEsgaXMgbm90IHNldAojIENPTkZJR19WSVJUSU9fQ09O
U09MRSBpcyBub3Qgc2V0CiMgQ09ORklHX0lQTUlfSEFORExFUiBpcyBub3Qgc2V0CkNPTkZJ
R19IV19SQU5ET009eQojIENPTkZJR19IV19SQU5ET01fVElNRVJJT01FTSBpcyBub3Qgc2V0
CkNPTkZJR19IV19SQU5ET01fQVRNRUw9eQojIENPTkZJR19IV19SQU5ET01fQkE0MzEgaXMg
bm90IHNldAojIENPTkZJR19IV19SQU5ET01fQ0NUUk5HIGlzIG5vdCBzZXQKIyBDT05GSUdf
SFdfUkFORE9NX1hJUEhFUkEgaXMgbm90IHNldApDT05GSUdfREVWTUVNPXkKQ09ORklHX0RF
VlBPUlQ9eQojIENPTkZJR19UQ0dfVFBNIGlzIG5vdCBzZXQKIyBDT05GSUdfWElMTFlCVVMg
aXMgbm90IHNldAojIENPTkZJR19YSUxMWVVTQiBpcyBub3Qgc2V0CiMgZW5kIG9mIENoYXJh
Y3RlciBkZXZpY2VzCgojCiMgSTJDIHN1cHBvcnQKIwpDT05GSUdfSTJDPXkKQ09ORklHX0ky
Q19CT0FSRElORk89eQpDT05GSUdfSTJDX0NIQVJERVY9eQojIENPTkZJR19JMkNfTVVYIGlz
IG5vdCBzZXQKQ09ORklHX0kyQ19IRUxQRVJfQVVUTz15CkNPTkZJR19JMkNfQUxHT0JJVD15
CgojCiMgSTJDIEhhcmR3YXJlIEJ1cyBzdXBwb3J0CiMKCiMKIyBJMkMgc3lzdGVtIGJ1cyBk
cml2ZXJzIChtb3N0bHkgZW1iZWRkZWQgLyBzeXN0ZW0tb24tY2hpcCkKIwpDT05GSUdfSTJD
X0FUOTE9eQojIENPTkZJR19JMkNfQVQ5MV9TTEFWRV9FWFBFUklNRU5UQUwgaXMgbm90IHNl
dAojIENPTkZJR19JMkNfQ0JVU19HUElPIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFU0lH
TldBUkVfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19FTUVWMiBpcyBub3Qgc2V0CkNP
TkZJR19JMkNfR1BJTz15CiMgQ09ORklHX0kyQ19HUElPX0ZBVUxUX0lOSkVDVE9SIGlzIG5v
dCBzZXQKIyBDT05GSUdfSTJDX09DT1JFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19QQ0Ff
UExBVEZPUk0gaXMgbm90IHNldAojIENPTkZJR19JMkNfUkszWCBpcyBub3Qgc2V0CiMgQ09O
RklHX0kyQ19TSU1URUMgaXMgbm90IHNldAojIENPTkZJR19JMkNfWElMSU5YIGlzIG5vdCBz
ZXQKCiMKIyBFeHRlcm5hbCBJMkMvU01CdXMgYWRhcHRlciBkcml2ZXJzCiMKIyBDT05GSUdf
STJDX0RJT0xBTl9VMkMgaXMgbm90IHNldAojIENPTkZJR19JMkNfQ1AyNjE1IGlzIG5vdCBz
ZXQKIyBDT05GSUdfSTJDX1JPQk9URlVaWl9PU0lGIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJD
X1RBT1NfRVZNIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1RJTllfVVNCIGlzIG5vdCBzZXQK
CiMKIyBPdGhlciBJMkMvU01CdXMgYnVzIGRyaXZlcnMKIwojIENPTkZJR19JMkNfVklSVElP
IGlzIG5vdCBzZXQKIyBlbmQgb2YgSTJDIEhhcmR3YXJlIEJ1cyBzdXBwb3J0CgojIENPTkZJ
R19JMkNfU1RVQiBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19TTEFWRSBpcyBub3Qgc2V0CiMg
Q09ORklHX0kyQ19ERUJVR19DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVHX0FM
R08gaXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQlVTIGlzIG5vdCBzZXQKIyBlbmQg
b2YgSTJDIHN1cHBvcnQKCiMgQ09ORklHX0kzQyBpcyBub3Qgc2V0CkNPTkZJR19TUEk9eQoj
IENPTkZJR19TUElfREVCVUcgaXMgbm90IHNldApDT05GSUdfU1BJX01BU1RFUj15CkNPTkZJ
R19TUElfTUVNPXkKCiMKIyBTUEkgTWFzdGVyIENvbnRyb2xsZXIgRHJpdmVycwojCiMgQ09O
RklHX1NQSV9BTFRFUkEgaXMgbm90IHNldApDT05GSUdfU1BJX0FUTUVMPXkKIyBDT05GSUdf
U1BJX0FUOTFfVVNBUlQgaXMgbm90IHNldApDT05GSUdfU1BJX0FUTUVMX1FVQURTUEk9eQoj
IENPTkZJR19TUElfQVhJX1NQSV9FTkdJTkUgaXMgbm90IHNldApDT05GSUdfU1BJX0JJVEJB
Tkc9eQojIENPTkZJR19TUElfQ0FERU5DRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NQSV9DQURF
TkNFX1FVQURTUEkgaXMgbm90IHNldAojIENPTkZJR19TUElfQ0gzNDEgaXMgbm90IHNldAoj
IENPTkZJR19TUElfREVTSUdOV0FSRSBpcyBub3Qgc2V0CkNPTkZJR19TUElfR1BJTz15CiMg
Q09ORklHX1NQSV9GU0xfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX01JQ1JPQ0hJUF9D
T1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX01JQ1JPQ0hJUF9DT1JFX1FTUEkgaXMgbm90
IHNldAojIENPTkZJR19TUElfT0NfVElOWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NQSV9TQzE4
SVM2MDIgaXMgbm90IHNldAojIENPTkZJR19TUElfU0lGSVZFIGlzIG5vdCBzZXQKIyBDT05G
SUdfU1BJX1NOX0ZfT1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NQSV9NWElDIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU1BJX1hDT01NIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX1hJTElOWCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NQSV9aWU5RTVBfR1FTUEkgaXMgbm90IHNldAojIENPTkZJ
R19TUElfQU1EIGlzIG5vdCBzZXQKCiMKIyBTUEkgTXVsdGlwbGV4ZXIgc3VwcG9ydAojCiMg
Q09ORklHX1NQSV9NVVggaXMgbm90IHNldAoKIwojIFNQSSBQcm90b2NvbCBNYXN0ZXJzCiMK
IyBDT05GSUdfU1BJX1NQSURFViBpcyBub3Qgc2V0CiMgQ09ORklHX1NQSV9MT09QQkFDS19U
RVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX1RMRTYyWDAgaXMgbm90IHNldAojIENPTkZJ
R19TUElfU0xBVkUgaXMgbm90IHNldAojIENPTkZJR19TUE1JIGlzIG5vdCBzZXQKIyBDT05G
SUdfSFNJIGlzIG5vdCBzZXQKQ09ORklHX1BQUz15CiMgQ09ORklHX1BQU19ERUJVRyBpcyBu
b3Qgc2V0CgojCiMgUFBTIGNsaWVudHMgc3VwcG9ydAojCiMgQ09ORklHX1BQU19DTElFTlRf
S1RJTUVSIGlzIG5vdCBzZXQKIyBDT05GSUdfUFBTX0NMSUVOVF9MRElTQyBpcyBub3Qgc2V0
CiMgQ09ORklHX1BQU19DTElFTlRfR1BJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1BQU19HRU5F
UkFUT1IgaXMgbm90IHNldAoKIwojIFBUUCBjbG9jayBzdXBwb3J0CiMKQ09ORklHX1BUUF8x
NTg4X0NMT0NLPXkKQ09ORklHX1BUUF8xNTg4X0NMT0NLX09QVElPTkFMPXkKCiMKIyBFbmFi
bGUgUEhZTElCIGFuZCBORVRXT1JLX1BIWV9USU1FU1RBTVBJTkcgdG8gc2VlIHRoZSBhZGRp
dGlvbmFsIGNsb2Nrcy4KIwojIENPTkZJR19QVFBfMTU4OF9DTE9DS19JRFQ4MlAzMyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BUUF8xNTg4X0NMT0NLX0lEVENNIGlzIG5vdCBzZXQKIyBDT05G
SUdfUFRQXzE1ODhfQ0xPQ0tfRkMzVyBpcyBub3Qgc2V0CiMgQ09ORklHX1BUUF8xNTg4X0NM
T0NLX01PQ0sgaXMgbm90IHNldAojIGVuZCBvZiBQVFAgY2xvY2sgc3VwcG9ydAoKQ09ORklH
X1BJTkNUUkw9eQpDT05GSUdfUElOTVVYPXkKQ09ORklHX1BJTkNPTkY9eQpDT05GSUdfR0VO
RVJJQ19QSU5DT05GPXkKIyBDT05GSUdfREVCVUdfUElOQ1RSTCBpcyBub3Qgc2V0CkNPTkZJ
R19QSU5DVFJMX0FUOTE9eQpDT05GSUdfUElOQ1RSTF9BVDkxUElPND15CiMgQ09ORklHX1BJ
TkNUUkxfQVc5NTIzIGlzIG5vdCBzZXQKIyBDT05GSUdfUElOQ1RSTF9DWThDOTVYMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BJTkNUUkxfTUNQMjNTMDggaXMgbm90IHNldAojIENPTkZJR19Q
SU5DVFJMX01JQ1JPQ0hJUF9TR1BJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1BJTkNUUkxfT0NF
TE9UIGlzIG5vdCBzZXQKIyBDT05GSUdfUElOQ1RSTF9TSU5HTEUgaXMgbm90IHNldAojIENP
TkZJR19QSU5DVFJMX1NUTUZYIGlzIG5vdCBzZXQKIyBDT05GSUdfUElOQ1RSTF9TWDE1MFgg
aXMgbm90IHNldAoKIwojIFJlbmVzYXMgcGluY3RybCBkcml2ZXJzCiMKIyBlbmQgb2YgUmVu
ZXNhcyBwaW5jdHJsIGRyaXZlcnMKCkNPTkZJR19HUElPTElCPXkKQ09ORklHX0dQSU9MSUJf
RkFTVFBBVEhfTElNSVQ9NTEyCkNPTkZJR19PRl9HUElPPXkKQ09ORklHX0dQSU9MSUJfSVJR
Q0hJUD15CiMgQ09ORklHX0RFQlVHX0dQSU8gaXMgbm90IHNldApDT05GSUdfR1BJT19TWVNG
Uz15CkNPTkZJR19HUElPX0NERVY9eQpDT05GSUdfR1BJT19DREVWX1YxPXkKCiMKIyBNZW1v
cnkgbWFwcGVkIEdQSU8gZHJpdmVycwojCiMgQ09ORklHX0dQSU9fNzRYWF9NTUlPIGlzIG5v
dCBzZXQKIyBDT05GSUdfR1BJT19BTFRFUkEgaXMgbm90IHNldAojIENPTkZJR19HUElPX0NB
REVOQ0UgaXMgbm90IHNldAojIENPTkZJR19HUElPX0RXQVBCIGlzIG5vdCBzZXQKIyBDT05G
SUdfR1BJT19GVEdQSU8wMTAgaXMgbm90IHNldAojIENPTkZJR19HUElPX0dFTkVSSUNfUExB
VEZPUk0gaXMgbm90IHNldAojIENPTkZJR19HUElPX0dSR1BJTyBpcyBub3Qgc2V0CiMgQ09O
RklHX0dQSU9fSExXRCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fTE9HSUNWQyBpcyBub3Qg
c2V0CiMgQ09ORklHX0dQSU9fTUI4NlM3WCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fTVBD
OFhYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fUE9MQVJGSVJFX1NPQyBpcyBub3Qgc2V0
CkNPTkZJR19HUElPX1NBTUE1RDJfUElPQlU9eQojIENPTkZJR19HUElPX1NJRklWRSBpcyBu
b3Qgc2V0CkNPTkZJR19HUElPX1NZU0NPTj15CiMgQ09ORklHX0dQSU9fWElMSU5YIGlzIG5v
dCBzZXQKIyBDT05GSUdfR1BJT19aRVZJTyBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fQU1E
X0ZDSCBpcyBub3Qgc2V0CiMgZW5kIG9mIE1lbW9yeSBtYXBwZWQgR1BJTyBkcml2ZXJzCgoj
CiMgSTJDIEdQSU8gZXhwYW5kZXJzCiMKIyBDT05GSUdfR1BJT19BRE5QIGlzIG5vdCBzZXQK
IyBDT05GSUdfR1BJT19GWEw2NDA4IGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19EUzQ1MjAg
aXMgbm90IHNldAojIENPTkZJR19HUElPX0dXX1BMRCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQ
SU9fTUFYNzMwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fTUFYNzMyWCBpcyBub3Qgc2V0
CiMgQ09ORklHX0dQSU9fUENBOTUzWCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fUENBOTU3
MCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fUENGODU3WCBpcyBub3Qgc2V0CiMgQ09ORklH
X0dQSU9fVFBJQzI4MTAgaXMgbm90IHNldAojIGVuZCBvZiBJMkMgR1BJTyBleHBhbmRlcnMK
CiMKIyBNRkQgR1BJTyBleHBhbmRlcnMKIwojIENPTkZJR19IVENfRUdQSU8gaXMgbm90IHNl
dAojIGVuZCBvZiBNRkQgR1BJTyBleHBhbmRlcnMKCiMKIyBTUEkgR1BJTyBleHBhbmRlcnMK
IwojIENPTkZJR19HUElPXzc0WDE2NCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fTUFYMzE5
MVggaXMgbm90IHNldAojIENPTkZJR19HUElPX01BWDczMDEgaXMgbm90IHNldAojIENPTkZJ
R19HUElPX01DMzM4ODAgaXMgbm90IHNldAojIENPTkZJR19HUElPX1BJU09TUiBpcyBub3Qg
c2V0CiMgQ09ORklHX0dQSU9fWFJBMTQwMyBpcyBub3Qgc2V0CiMgZW5kIG9mIFNQSSBHUElP
IGV4cGFuZGVycwoKIwojIFVTQiBHUElPIGV4cGFuZGVycwojCiMgQ09ORklHX0dQSU9fTVBT
U0UgaXMgbm90IHNldAojIGVuZCBvZiBVU0IgR1BJTyBleHBhbmRlcnMKCiMKIyBWaXJ0dWFs
IEdQSU8gZHJpdmVycwojCiMgQ09ORklHX0dQSU9fQUdHUkVHQVRPUiBpcyBub3Qgc2V0CiMg
Q09ORklHX0dQSU9fTEFUQ0ggaXMgbm90IHNldAojIENPTkZJR19HUElPX01PQ0tVUCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0dQSU9fU0lNIGlzIG5vdCBzZXQKIyBlbmQgb2YgVmlydHVhbCBH
UElPIGRyaXZlcnMKCiMKIyBHUElPIERlYnVnZ2luZyB1dGlsaXRpZXMKIwojIENPTkZJR19H
UElPX1ZJUlRVU0VSIGlzIG5vdCBzZXQKIyBlbmQgb2YgR1BJTyBEZWJ1Z2dpbmcgdXRpbGl0
aWVzCgojIENPTkZJR19XMSBpcyBub3Qgc2V0CkNPTkZJR19QT1dFUl9SRVNFVD15CkNPTkZJ
R19QT1dFUl9SRVNFVF9BVDkxX1BPV0VST0ZGPXkKQ09ORklHX1BPV0VSX1JFU0VUX0FUOTFf
UkVTRVQ9eQpDT05GSUdfUE9XRVJfUkVTRVRfQVQ5MV9TQU1BNUQyX1NIRFdDPXkKIyBDT05G
SUdfUE9XRVJfUkVTRVRfQlJDTUtPTkEgaXMgbm90IHNldAojIENPTkZJR19QT1dFUl9SRVNF
VF9HUElPIGlzIG5vdCBzZXQKIyBDT05GSUdfUE9XRVJfUkVTRVRfR1BJT19SRVNUQVJUIGlz
IG5vdCBzZXQKIyBDT05GSUdfUE9XRVJfUkVTRVRfTFRDMjk1MiBpcyBub3Qgc2V0CiMgQ09O
RklHX1BPV0VSX1JFU0VUX1JFR1VMQVRPUiBpcyBub3Qgc2V0CiMgQ09ORklHX1BPV0VSX1JF
U0VUX1JFU1RBUlQgaXMgbm90IHNldAojIENPTkZJR19QT1dFUl9SRVNFVF9WRVJTQVRJTEUg
aXMgbm90IHNldAojIENPTkZJR19QT1dFUl9SRVNFVF9TWVNDT04gaXMgbm90IHNldAojIENP
TkZJR19QT1dFUl9SRVNFVF9TWVNDT05fUE9XRVJPRkYgaXMgbm90IHNldAojIENPTkZJR19T
WVNDT05fUkVCT09UX01PREUgaXMgbm90IHNldAojIENPTkZJR19OVk1FTV9SRUJPT1RfTU9E
RSBpcyBub3Qgc2V0CiMgQ09ORklHX1BPV0VSX1NFUVVFTkNJTkcgaXMgbm90IHNldApDT05G
SUdfUE9XRVJfU1VQUExZPXkKIyBDT05GSUdfUE9XRVJfU1VQUExZX0RFQlVHIGlzIG5vdCBz
ZXQKQ09ORklHX1BPV0VSX1NVUFBMWV9IV01PTj15CiMgQ09ORklHX0dFTkVSSUNfQURDX0JB
VFRFUlkgaXMgbm90IHNldAojIENPTkZJR19JUDVYWFhfUE9XRVIgaXMgbm90IHNldAojIENP
TkZJR19URVNUX1BPV0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hBUkdFUl9BRFA1MDYxIGlz
IG5vdCBzZXQKQ09ORklHX0JBVFRFUllfQUNUODk0NUE9eQojIENPTkZJR19CQVRURVJZX0NX
MjAxNSBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfRFMyNzgwIGlzIG5vdCBzZXQKIyBD
T05GSUdfQkFUVEVSWV9EUzI3ODEgaXMgbm90IHNldAojIENPTkZJR19CQVRURVJZX0RTMjc4
MiBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfU0FNU1VOR19TREkgaXMgbm90IHNldAoj
IENPTkZJR19CQVRURVJZX1NCUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJfU0JTIGlz
IG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9CUTI3WFhYIGlzIG5vdCBzZXQKIyBDT05GSUdf
QkFUVEVSWV9NQVgxNzA0MCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfTUFYMTcwNDIg
aXMgbm90IHNldAojIENPTkZJR19CQVRURVJZX01BWDE3MjBYIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ0hBUkdFUl9NQVg4OTAzIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hBUkdFUl9MUDg3Mjcg
aXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19D
SEFSR0VSX01BTkFHRVIgaXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX0xUMzY1MSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJfTFRDNDE2MkwgaXMgbm90IHNldAojIENPTkZJR19D
SEFSR0VSX0RFVEVDVE9SX01BWDE0NjU2IGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hBUkdFUl9N
QVg3Nzk3NiBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJfQlEyNDE1WCBpcyBub3Qgc2V0
CiMgQ09ORklHX0NIQVJHRVJfQlEyNDI1NyBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJf
QlEyNDczNSBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJfQlEyNTE1WCBpcyBub3Qgc2V0
CiMgQ09ORklHX0NIQVJHRVJfQlEyNTg5MCBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJf
QlEyNTk4MCBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJfQlEyNTZYWCBpcyBub3Qgc2V0
CiMgQ09ORklHX0NIQVJHRVJfU01CMzQ3IGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9H
QVVHRV9MVEMyOTQxIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9HT0xERklTSCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfUlQ1MDMzIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hB
UkdFUl9SVDk0NTUgaXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX1JUOTQ2NyBpcyBub3Qg
c2V0CiMgQ09ORklHX0NIQVJHRVJfUlQ5NDcxIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hBUkdF
Ul9VQ1MxMDAyIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hBUkdFUl9CRDk5OTU0IGlzIG5vdCBz
ZXQKIyBDT05GSUdfQkFUVEVSWV9VRzMxMDUgaXMgbm90IHNldAojIENPTkZJR19GVUVMX0dB
VUdFX01NODAxMyBpcyBub3Qgc2V0CkNPTkZJR19IV01PTj15CiMgQ09ORklHX0hXTU9OX0RF
QlVHX0NISVAgaXMgbm90IHNldAoKIwojIE5hdGl2ZSBkcml2ZXJzCiMKIyBDT05GSUdfU0VO
U09SU19BRDczMTQgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FENzQxNCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfQUQ3NDE4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19BRE0xMDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDI2IGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDI5IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19BRE0xMDMxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMTc3IGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19BRE05MjQwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19BRFQ3MzEwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDEwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDExIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19BRFQ3NDYyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDcwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDc1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19BSFQxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQVFVQUNPTVBVVEVSX0Q1TkVY
VCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQVMzNzAgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0FTQzc2MjEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FTVVNfUk9H
X1JZVUpJTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQVhJX0ZBTl9DT05UUk9MIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BVFhQMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfQ0hJUENBUDIgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0NPUlNBSVJfQ1BS
TyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQ09SU0FJUl9QU1UgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0RTNjIwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19EUzE2
MjEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0Y3MTgwNUYgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0Y3MTg4MkZHIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19GNzUz
NzVTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19GVFNURVVUQVRFUyBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfR0lHQUJZVEVfV0FURVJGT1JDRSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfR0w1MThTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfR0w1MjBT
TSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRzc2MEEgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0c3NjIgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0dQSU9fRkFOIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19ISUg2MTMwIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19IUzMwMDEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0hUVTMxIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19JSU9fSFdNT04gaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX0lTTDI4MDIyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19JVDg3IGlzIG5v
dCBzZXQKQ09ORklHX1NFTlNPUlNfSkM0Mj1tCiMgQ09ORklHX1NFTlNPUlNfUE9XRVJaIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19QT1dSMTIyMCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfTElORUFHRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTFRDMjk0NSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTFRDMjk0N19JMkMgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0xUQzI5NDdfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19M
VEMyOTkwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MVEMyOTkxIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19MVEMyOTkyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19M
VEM0MTUxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MVEM0MjE1IGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19MVEM0MjIyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19M
VEM0MjQ1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MVEM0MjYwIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19MVEM0MjYxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19M
VEM0MjgyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19NQVgxMTExIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19NQVgxMjcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01B
WDE2MDY1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19NQVgxNjE5IGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19NQVgxNjY4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19N
QVgxOTcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01BWDMxNzIyIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19NQVgzMTczMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
TUFYMzE3NjAgaXMgbm90IHNldAojIENPTkZJR19NQVgzMTgyNyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfTUFYNjYyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYNjYy
MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYNjYzOSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfTUFYNjY1MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYNjY5
NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYMzE3OTAgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX01DMzRWUjUwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUNQ
MzAyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVEM2NTQgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX1RQUzIzODYxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19NUjc1
MjAzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRENYWCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfTE02MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03MCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfTE03NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03NyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfTE03OCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04MCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfTE04NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04NyBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfTE05MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05
MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05MyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfTE05NTIzNCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05NTI0MSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05NTI0NSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfUEM4NzM2MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfUEM4NzQyNyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTlRDX1RIRVJNSVNUT1IgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX05DVDY2ODMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX05D
VDY3NzVfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19OQ1Q3MzYzIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19OQ1Q3ODAyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19OQ1Q3OTA0IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19OUENNN1hYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19OWlhUX0tSQUtFTjIgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX05aWFRfS1JBS0VOMyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTlpYVF9T
TUFSVDIgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX09DQ19QOF9JMkMgaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX1BDRjg1OTEgaXMgbm90IHNldAojIENPTkZJR19QTUJVUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfUFQ1MTYxTCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfUFdNX0ZBTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0JUU0kgaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX1NCUk1JIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19TSFQxNSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0hUMjEgaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX1NIVDN4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19T
SFQ0eCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0hUQzEgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0RNRTE3MzcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0VNQzE0
MDMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0VNQzIxMDMgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0VNQzIzMDUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0VNQzZX
MjAxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19TTVNDNDdNMSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfU01TQzQ3TTE5MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
U01TQzQ3QjM5NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0NINTYyNyBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfU0NINTYzNiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfU1RUUzc1MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURDMTI4RDgxOCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURTNzgyOCBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfQURTNzg3MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQU1DNjgyMSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSU5BMjA5IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19JTkEyWFggaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0lOQTIzOCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfSU5BMzIyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfU1BENTExOCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVEM3NCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfVEhNQzUwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19U
TVAxMDIgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1RNUDEwMyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfVE1QMTA4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UTVA0
MDEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1RNUDQyMSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfVE1QNDY0IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UTVA1MTMg
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1ZUMTIxMSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfVzgzNzczRyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzgxRCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzkxRCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfVzgzNzkyRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzkzIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19XODM3OTUgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX1c4M0w3ODVUUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzTDc4Nk5H
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19XODM2MjdIRiBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfVzgzNjI3RUhGIGlzIG5vdCBzZXQKIyBDT05GSUdfVEhFUk1BTCBpcyBu
b3Qgc2V0CkNPTkZJR19XQVRDSERPRz15CkNPTkZJR19XQVRDSERPR19DT1JFPXkKIyBDT05G
SUdfV0FUQ0hET0dfTk9XQVlPVVQgaXMgbm90IHNldApDT05GSUdfV0FUQ0hET0dfSEFORExF
X0JPT1RfRU5BQkxFRD15CkNPTkZJR19XQVRDSERPR19PUEVOX1RJTUVPVVQ9MAojIENPTkZJ
R19XQVRDSERPR19TWVNGUyBpcyBub3Qgc2V0CiMgQ09ORklHX1dBVENIRE9HX0hSVElNRVJf
UFJFVElNRU9VVCBpcyBub3Qgc2V0CgojCiMgV2F0Y2hkb2cgUHJldGltZW91dCBHb3Zlcm5v
cnMKIwojIENPTkZJR19XQVRDSERPR19QUkVUSU1FT1VUX0dPViBpcyBub3Qgc2V0CgojCiMg
V2F0Y2hkb2cgRGV2aWNlIERyaXZlcnMKIwojIENPTkZJR19TT0ZUX1dBVENIRE9HIGlzIG5v
dCBzZXQKIyBDT05GSUdfR1BJT19XQVRDSERPRyBpcyBub3Qgc2V0CiMgQ09ORklHX1hJTElO
WF9XQVRDSERPRyBpcyBub3Qgc2V0CiMgQ09ORklHX1pJSVJBVkVfV0FUQ0hET0cgaXMgbm90
IHNldApDT05GSUdfQVQ5MVNBTTlYX1dBVENIRE9HPXkKQ09ORklHX1NBTUE1RDRfV0FUQ0hE
T0c9eQojIENPTkZJR19DQURFTkNFX1dBVENIRE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfRlRX
RFQwMTBfV0FUQ0hET0cgaXMgbm90IHNldAojIENPTkZJR19EV19XQVRDSERPRyBpcyBub3Qg
c2V0CiMgQ09ORklHX01BWDYzWFhfV0FUQ0hET0cgaXMgbm90IHNldAojIENPTkZJR19BUk1f
U01DX1dBVENIRE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVOX0EyMV9XRFQgaXMgbm90IHNl
dAoKIwojIFVTQi1iYXNlZCBXYXRjaGRvZyBDYXJkcwojCiMgQ09ORklHX1VTQlBDV0FUQ0hE
T0cgaXMgbm90IHNldApDT05GSUdfU1NCX1BPU1NJQkxFPXkKIyBDT05GSUdfU1NCIGlzIG5v
dCBzZXQKQ09ORklHX0JDTUFfUE9TU0lCTEU9eQojIENPTkZJR19CQ01BIGlzIG5vdCBzZXQK
CiMKIyBNdWx0aWZ1bmN0aW9uIGRldmljZSBkcml2ZXJzCiMKQ09ORklHX01GRF9DT1JFPXkK
IyBDT05GSUdfTUZEX0FEUDU1ODUgaXMgbm90IHNldApDT05GSUdfTUZEX0FDVDg5NDVBPXkK
IyBDT05GSUdfTUZEX0FTMzcxMSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9TTVBSTyBpcyBu
b3Qgc2V0CiMgQ09ORklHX01GRF9BUzM3MjIgaXMgbm90IHNldAojIENPTkZJR19QTUlDX0FE
UDU1MjAgaXMgbm90IHNldAojIENPTkZJR19NRkRfQUFUMjg3MF9DT1JFIGlzIG5vdCBzZXQK
Q09ORklHX01GRF9BVDkxX1VTQVJUPXkKQ09ORklHX01GRF9BVE1FTF9GTEVYQ09NPXkKQ09O
RklHX01GRF9BVE1FTF9ITENEQz15CkNPTkZJR19NRkRfQVRNRUxfU01DPXkKIyBDT05GSUdf
TUZEX0JDTTU5MFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0JEOTU3MU1XViBpcyBub3Qg
c2V0CiMgQ09ORklHX01GRF9BWFAyMFhfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0NT
NDJMNDNfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01BREVSQSBpcyBub3Qgc2V0CiMg
Q09ORklHX01GRF9NQVg1OTcwIGlzIG5vdCBzZXQKIyBDT05GSUdfUE1JQ19EQTkwM1ggaXMg
bm90IHNldAojIENPTkZJR19NRkRfREE5MDUyX1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX01G
RF9EQTkwNTJfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0RBOTA1NSBpcyBub3Qgc2V0
CiMgQ09ORklHX01GRF9EQTkwNjIgaXMgbm90IHNldAojIENPTkZJR19NRkRfREE5MDYzIGlz
IG5vdCBzZXQKIyBDT05GSUdfTUZEX0RBOTE1MCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9E
TE4yIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0dBVEVXT1JLU19HU0MgaXMgbm90IHNldAoj
IENPTkZJR19NRkRfTUMxM1hYWF9TUEkgaXMgbm90IHNldAojIENPTkZJR19NRkRfTUMxM1hY
WF9JMkMgaXMgbm90IHNldAojIENPTkZJR19NRkRfTVAyNjI5IGlzIG5vdCBzZXQKIyBDT05G
SUdfTUZEX0hJNjQyMV9QTUlDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0lRUzYyWCBpcyBu
b3Qgc2V0CiMgQ09ORklHX01GRF9LRU1QTEQgaXMgbm90IHNldAojIENPTkZJR19NRkRfODhQ
TTgwMCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF84OFBNODA1IGlzIG5vdCBzZXQKIyBDT05G
SUdfTUZEXzg4UE04NjBYIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEXzg4UE04ODZfUE1JQyBp
cyBub3Qgc2V0CiMgQ09ORklHX01GRF9NQVgxNDU3NyBpcyBub3Qgc2V0CiMgQ09ORklHX01G
RF9NQVg3NzU0MSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9NQVg3NzYyMCBpcyBub3Qgc2V0
CiMgQ09ORklHX01GRF9NQVg3NzY1MCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9NQVg3NzY4
NiBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9NQVg3NzY5MyBpcyBub3Qgc2V0CiMgQ09ORklH
X01GRF9NQVg3NzcwNSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9NQVg3NzcxNCBpcyBub3Qg
c2V0CiMgQ09ORklHX01GRF9NQVg3Nzg0MyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9NQVg4
OTA3IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01BWDg5MjUgaXMgbm90IHNldAojIENPTkZJ
R19NRkRfTUFYODk5NyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9NQVg4OTk4IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTUZEX01UNjM2MCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9NVDYzNzAg
aXMgbm90IHNldAojIENPTkZJR19NRkRfTVQ2Mzk3IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZE
X01FTkYyMUJNQyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9PQ0VMT1QgaXMgbm90IHNldAoj
IENPTkZJR19FWlhfUENBUCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9DUENBUCBpcyBub3Qg
c2V0CiMgQ09ORklHX01GRF9WSVBFUkJPQVJEIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX05U
WEVDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1JFVFUgaXMgbm90IHNldAojIENPTkZJR19N
RkRfUE04WFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1NZNzYzNkEgaXMgbm90IHNldAoj
IENPTkZJR19NRkRfUlQ0ODMxIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1JUNTAzMyBpcyBu
b3Qgc2V0CiMgQ09ORklHX01GRF9SVDUxMjAgaXMgbm90IHNldAojIENPTkZJR19NRkRfUkM1
VDU4MyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9SSzhYWF9JMkMgaXMgbm90IHNldAojIENP
TkZJR19NRkRfUks4WFhfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1JONVQ2MTggaXMg
bm90IHNldAojIENPTkZJR19NRkRfU0VDX0NPUkUgaXMgbm90IHNldAojIENPTkZJR19NRkRf
U0k0NzZYX0NPUkUgaXMgbm90IHNldAojIENPTkZJR19NRkRfU001MDEgaXMgbm90IHNldAoj
IENPTkZJR19NRkRfU0tZODE0NTIgaXMgbm90IHNldAojIENPTkZJR19NRkRfU1RNUEUgaXMg
bm90IHNldApDT05GSUdfTUZEX1NZU0NPTj15CiMgQ09ORklHX01GRF9MUDM5NDMgaXMgbm90
IHNldAojIENPTkZJR19NRkRfTFA4Nzg4IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1RJX0xN
VSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9QQUxNQVMgaXMgbm90IHNldAojIENPTkZJR19U
UFM2MTA1WCBpcyBub3Qgc2V0CiMgQ09ORklHX1RQUzY1MDEwIGlzIG5vdCBzZXQKIyBDT05G
SUdfVFBTNjUwN1ggaXMgbm90IHNldAojIENPTkZJR19NRkRfVFBTNjUwODYgaXMgbm90IHNl
dAojIENPTkZJR19NRkRfVFBTNjUwOTAgaXMgbm90IHNldAojIENPTkZJR19NRkRfVFBTNjUy
MTcgaXMgbm90IHNldAojIENPTkZJR19NRkRfVElfTFA4NzNYIGlzIG5vdCBzZXQKIyBDT05G
SUdfTUZEX1RJX0xQODc1NjUgaXMgbm90IHNldAojIENPTkZJR19NRkRfVFBTNjUyMTggaXMg
bm90IHNldAojIENPTkZJR19NRkRfVFBTNjUyMTkgaXMgbm90IHNldAojIENPTkZJR19NRkRf
VFBTNjU4NlggaXMgbm90IHNldAojIENPTkZJR19NRkRfVFBTNjU5MTAgaXMgbm90IHNldAoj
IENPTkZJR19NRkRfVFBTNjU5MTJfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1RQUzY1
OTEyX1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9UUFM2NTk0X0kyQyBpcyBub3Qgc2V0
CiMgQ09ORklHX01GRF9UUFM2NTk0X1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1RXTDQwMzBf
Q09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX1RXTDYwNDBfQ09SRSBpcyBub3Qgc2V0CiMgQ09O
RklHX01GRF9XTDEyNzNfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9MTTM1MzMgaXMg
bm90IHNldAojIENPTkZJR19NRkRfVEMzNTg5WCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9U
UU1YODYgaXMgbm90IHNldAojIENPTkZJR19NRkRfTE9DSE5BR0FSIGlzIG5vdCBzZXQKIyBD
T05GSUdfTUZEX0FSSVpPTkFfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0FSSVpPTkFf
U1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dNODQwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X01GRF9XTTgzMVhfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dNODMxWF9TUEkgaXMg
bm90IHNldAojIENPTkZJR19NRkRfV004MzUwX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX01G
RF9XTTg5OTQgaXMgbm90IHNldAojIENPTkZJR19NRkRfUk9ITV9CRDcxOFhYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTUZEX1JPSE1fQkQ3MTgyOCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9S
T0hNX0JEOTU3WE1VRiBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9ST0hNX0JEOTY4MDEgaXMg
bm90IHNldAojIENPTkZJR19NRkRfU1RQTUlDMSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9T
VE1GWCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9BVEMyNjBYX0kyQyBpcyBub3Qgc2V0CiMg
Q09ORklHX01GRF9RQ09NX1BNODAwOCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9DUzQwTDUw
X0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9DUzQwTDUwX1NQSSBpcyBub3Qgc2V0CiMg
Q09ORklHX01GRF9JTlRFTF9NMTBfQk1DX1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9S
U01VX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9SU01VX1NQSSBpcyBub3Qgc2V0CiMg
ZW5kIG9mIE11bHRpZnVuY3Rpb24gZGV2aWNlIGRyaXZlcnMKCkNPTkZJR19SRUdVTEFUT1I9
eQojIENPTkZJR19SRUdVTEFUT1JfREVCVUcgaXMgbm90IHNldApDT05GSUdfUkVHVUxBVE9S
X0ZJWEVEX1ZPTFRBR0U9eQojIENPTkZJR19SRUdVTEFUT1JfVklSVFVBTF9DT05TVU1FUiBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9VU0VSU1BBQ0VfQ09OU1VNRVIgaXMgbm90
IHNldAojIENPTkZJR19SRUdVTEFUT1JfTkVUTElOS19FVkVOVFMgaXMgbm90IHNldAojIENP
TkZJR19SRUdVTEFUT1JfODhQRzg2WCBpcyBub3Qgc2V0CkNPTkZJR19SRUdVTEFUT1JfQUNU
ODg2NT15CkNPTkZJR19SRUdVTEFUT1JfQUNUODk0NUE9eQojIENPTkZJR19SRUdVTEFUT1Jf
QUQ1Mzk4IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX0FXMzc1MDMgaXMgbm90IHNl
dAojIENPTkZJR19SRUdVTEFUT1JfREE5MTIxIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxB
VE9SX0RBOTIxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9EQTkyMTEgaXMgbm90
IHNldAojIENPTkZJR19SRUdVTEFUT1JfRkFONTM1NTUgaXMgbm90IHNldAojIENPTkZJR19S
RUdVTEFUT1JfRkFONTM4ODAgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfR1BJTyBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9JU0w5MzA1IGlzIG5vdCBzZXQKIyBDT05G
SUdfUkVHVUxBVE9SX0lTTDYyNzFBIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX0xQ
Mzk3MSBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9MUDM5NzIgaXMgbm90IHNldAoj
IENPTkZJR19SRUdVTEFUT1JfTFA4NzJYIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9S
X0xQODc1NSBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9MVEMzNTg5IGlzIG5vdCBz
ZXQKIyBDT05GSUdfUkVHVUxBVE9SX0xUQzM2NzYgaXMgbm90IHNldAojIENPTkZJR19SRUdV
TEFUT1JfTUFYMTU4NiBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9NQVg3NzUwMyBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9NQVg3Nzg1NyBpcyBub3Qgc2V0CiMgQ09O
RklHX1JFR1VMQVRPUl9NQVg4NjQ5IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX01B
WDg2NjAgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfTUFYODg5MyBpcyBub3Qgc2V0
CiMgQ09ORklHX1JFR1VMQVRPUl9NQVg4OTUyIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxB
VE9SX01BWDIwMDg2IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX01BWDIwNDExIGlz
IG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX01BWDc3ODI2IGlzIG5vdCBzZXQKQ09ORklH
X1JFR1VMQVRPUl9NQ1AxNjUwMj15CiMgQ09ORklHX1JFR1VMQVRPUl9NUDU0MTYgaXMgbm90
IHNldAojIENPTkZJR19SRUdVTEFUT1JfTVA4ODU5IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVH
VUxBVE9SX01QODg2WCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9NUFE3OTIwIGlz
IG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX01UNjMxMSBpcyBub3Qgc2V0CiMgQ09ORklH
X1JFR1VMQVRPUl9QQ0E5NDUwIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX1BGOTQ1
MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9QRjhYMDAgaXMgbm90IHNldAojIENP
TkZJR19SRUdVTEFUT1JfUEZVWkUxMDAgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1Jf
UFY4ODA2MCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9QVjg4MDgwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUkVHVUxBVE9SX1BWODgwOTAgaXMgbm90IHNldApDT05GSUdfUkVHVUxB
VE9SX1BXTT1tCiMgQ09ORklHX1JFR1VMQVRPUl9SQUEyMTUzMDAgaXMgbm90IHNldAojIENP
TkZJR19SRUdVTEFUT1JfUkFTUEJFUlJZUElfVE9VQ0hTQ1JFRU5fQVRUSU5ZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUkVHVUxBVE9SX1JUNDgwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VM
QVRPUl9SVDQ4MDMgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfUlQ1MTkwQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9SVDU3MzkgaXMgbm90IHNldAojIENPTkZJR19S
RUdVTEFUT1JfUlQ1NzU5IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX1JUNjE2MCBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9SVDYxOTAgaXMgbm90IHNldAojIENPTkZJ
R19SRUdVTEFUT1JfUlQ2MjQ1IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX1JUUTIx
MzQgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfUlRNVjIwIGlzIG5vdCBzZXQKIyBD
T05GSUdfUkVHVUxBVE9SX1JUUTY3NTIgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1Jf
UlRRMjIwOCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9TTEc1MTAwMCBpcyBub3Qg
c2V0CiMgQ09ORklHX1JFR1VMQVRPUl9TWTgxMDZBIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVH
VUxBVE9SX1NZODgyNFggaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfU1k4ODI3TiBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9UUFM1MTYzMiBpcyBub3Qgc2V0CiMgQ09O
RklHX1JFR1VMQVRPUl9UUFM2MjM2MCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9U
UFM2Mjg2WCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9UUFM2Mjg3WCBpcyBub3Qg
c2V0CiMgQ09ORklHX1JFR1VMQVRPUl9UUFM2NTAyMyBpcyBub3Qgc2V0CiMgQ09ORklHX1JF
R1VMQVRPUl9UUFM2NTA3WCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9UUFM2NTEz
MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9UUFM2NTI0WCBpcyBub3Qgc2V0CiMg
Q09ORklHX1JFR1VMQVRPUl9WQ1RSTCBpcyBub3Qgc2V0CiMgQ09ORklHX1JDX0NPUkUgaXMg
bm90IHNldAoKIwojIENFQyBzdXBwb3J0CiMKIyBDT05GSUdfTUVESUFfQ0VDX1NVUFBPUlQg
aXMgbm90IHNldAojIGVuZCBvZiBDRUMgc3VwcG9ydAoKQ09ORklHX01FRElBX1NVUFBPUlQ9
eQpDT05GSUdfTUVESUFfU1VQUE9SVF9GSUxURVI9eQojIENPTkZJR19NRURJQV9TVUJEUlZf
QVVUT1NFTEVDVCBpcyBub3Qgc2V0CgojCiMgTWVkaWEgZGV2aWNlIHR5cGVzCiMKQ09ORklH
X01FRElBX0NBTUVSQV9TVVBQT1JUPXkKIyBDT05GSUdfTUVESUFfQU5BTE9HX1RWX1NVUFBP
UlQgaXMgbm90IHNldAojIENPTkZJR19NRURJQV9ESUdJVEFMX1RWX1NVUFBPUlQgaXMgbm90
IHNldAojIENPTkZJR19NRURJQV9SQURJT19TVVBQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdf
TUVESUFfU0RSX1NVUFBPUlQgaXMgbm90IHNldApDT05GSUdfTUVESUFfUExBVEZPUk1fU1VQ
UE9SVD15CiMgQ09ORklHX01FRElBX1RFU1RfU1VQUE9SVCBpcyBub3Qgc2V0CiMgZW5kIG9m
IE1lZGlhIGRldmljZSB0eXBlcwoKQ09ORklHX1ZJREVPX0RFVj15CkNPTkZJR19NRURJQV9D
T05UUk9MTEVSPXkKCiMKIyBWaWRlbzRMaW51eCBvcHRpb25zCiMKQ09ORklHX1ZJREVPX1Y0
TDJfSTJDPXkKQ09ORklHX1ZJREVPX1Y0TDJfU1VCREVWX0FQST15CiMgQ09ORklHX1ZJREVP
X0FEVl9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0ZJWEVEX01JTk9SX1JBTkdF
UyBpcyBub3Qgc2V0CkNPTkZJR19WNEwyX0ZXTk9ERT15CkNPTkZJR19WNEwyX0FTWU5DPXkK
IyBlbmQgb2YgVmlkZW80TGludXggb3B0aW9ucwoKIwojIE1lZGlhIGNvbnRyb2xsZXIgb3B0
aW9ucwojCiMgZW5kIG9mIE1lZGlhIGNvbnRyb2xsZXIgb3B0aW9ucwoKIwojIE1lZGlhIGRy
aXZlcnMKIwoKIwojIERyaXZlcnMgZmlsdGVyZWQgYXMgc2VsZWN0ZWQgYXQgJ0ZpbHRlciBt
ZWRpYSBkcml2ZXJzJwojCgojCiMgTWVkaWEgZHJpdmVycwojCkNPTkZJR19NRURJQV9VU0Jf
U1VQUE9SVD15CgojCiMgV2ViY2FtIGRldmljZXMKIwojIENPTkZJR19VU0JfR1NQQ0EgaXMg
bm90IHNldAojIENPTkZJR19VU0JfUFdDIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1MyMjU1
IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fVVNCVFYgaXMgbm90IHNldApDT05GSUdfVVNC
X1ZJREVPX0NMQVNTPW0KQ09ORklHX1VTQl9WSURFT19DTEFTU19JTlBVVF9FVkRFVj15Cgoj
CiMgV2ViY2FtLCBUViAoYW5hbG9nL2RpZ2l0YWwpIFVTQiBkZXZpY2VzCiMKIyBDT05GSUdf
VklERU9fRU0yOFhYIGlzIG5vdCBzZXQKQ09ORklHX01FRElBX1BMQVRGT1JNX0RSSVZFUlM9
eQpDT05GSUdfVjRMX1BMQVRGT1JNX0RSSVZFUlM9eQojIENPTkZJR19WNExfTUVNMk1FTV9E
UklWRVJTIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fTVVYIGlzIG5vdCBzZXQKCiMKIyBB
bGxlZ3JvIERWVCBtZWRpYSBwbGF0Zm9ybSBkcml2ZXJzCiMKCiMKIyBBbWxvZ2ljIG1lZGlh
IHBsYXRmb3JtIGRyaXZlcnMKIwoKIwojIEFtcGhpb24gZHJpdmVycwojCgojCiMgQXNwZWVk
IG1lZGlhIHBsYXRmb3JtIGRyaXZlcnMKIwoKIwojIEF0bWVsIG1lZGlhIHBsYXRmb3JtIGRy
aXZlcnMKIwpDT05GSUdfVklERU9fQVRNRUxfSVNJPXkKCiMKIyBDYWRlbmNlIG1lZGlhIHBs
YXRmb3JtIGRyaXZlcnMKIwojIENPTkZJR19WSURFT19DQURFTkNFX0NTSTJSWCBpcyBub3Qg
c2V0CiMgQ09ORklHX1ZJREVPX0NBREVOQ0VfQ1NJMlRYIGlzIG5vdCBzZXQKCiMKIyBDaGlw
cyZNZWRpYSBtZWRpYSBwbGF0Zm9ybSBkcml2ZXJzCiMKCiMKIyBJbnRlbCBtZWRpYSBwbGF0
Zm9ybSBkcml2ZXJzCiMKCiMKIyBNYXJ2ZWxsIG1lZGlhIHBsYXRmb3JtIGRyaXZlcnMKIwoK
IwojIE1lZGlhdGVrIG1lZGlhIHBsYXRmb3JtIGRyaXZlcnMKIwoKIwojIE1pY3JvY2hpcCBU
ZWNobm9sb2d5LCBJbmMuIG1lZGlhIHBsYXRmb3JtIGRyaXZlcnMKIwpDT05GSUdfVklERU9f
TUlDUk9DSElQX0lTQz15CiMgQ09ORklHX1ZJREVPX01JQ1JPQ0hJUF9YSVNDIGlzIG5vdCBz
ZXQKQ09ORklHX1ZJREVPX01JQ1JPQ0hJUF9JU0NfQkFTRT15CiMgQ09ORklHX1ZJREVPX01J
Q1JPQ0hJUF9DU0kyREMgaXMgbm90IHNldAoKIwojIE51dm90b24gbWVkaWEgcGxhdGZvcm0g
ZHJpdmVycwojCgojCiMgTlZpZGlhIG1lZGlhIHBsYXRmb3JtIGRyaXZlcnMKIwoKIwojIE5Y
UCBtZWRpYSBwbGF0Zm9ybSBkcml2ZXJzCiMKCiMKIyBRdWFsY29tbSBtZWRpYSBwbGF0Zm9y
bSBkcml2ZXJzCiMKCiMKIyBSYXNwYmVycnkgUGkgbWVkaWEgcGxhdGZvcm0gZHJpdmVycwoj
CiMgQ09ORklHX1ZJREVPX1JQMV9DRkUgaXMgbm90IHNldAoKIwojIFJlbmVzYXMgbWVkaWEg
cGxhdGZvcm0gZHJpdmVycwojCgojCiMgUm9ja2NoaXAgbWVkaWEgcGxhdGZvcm0gZHJpdmVy
cwojCgojCiMgU2Ftc3VuZyBtZWRpYSBwbGF0Zm9ybSBkcml2ZXJzCiMKCiMKIyBTVE1pY3Jv
ZWxlY3Ryb25pY3MgbWVkaWEgcGxhdGZvcm0gZHJpdmVycwojCgojCiMgU3VueGkgbWVkaWEg
cGxhdGZvcm0gZHJpdmVycwojCgojCiMgVGV4YXMgSW5zdHJ1bWVudHMgZHJpdmVycwojCgoj
CiMgVmVyaXNpbGljb24gbWVkaWEgcGxhdGZvcm0gZHJpdmVycwojCgojCiMgVklBIG1lZGlh
IHBsYXRmb3JtIGRyaXZlcnMKIwoKIwojIFhpbGlueCBtZWRpYSBwbGF0Zm9ybSBkcml2ZXJz
CiMKIyBDT05GSUdfVklERU9fWElMSU5YIGlzIG5vdCBzZXQKQ09ORklHX1VWQ19DT01NT049
bQpDT05GSUdfVklERU9CVUYyX0NPUkU9eQpDT05GSUdfVklERU9CVUYyX1Y0TDI9eQpDT05G
SUdfVklERU9CVUYyX01FTU9QUz15CkNPTkZJR19WSURFT0JVRjJfRE1BX0NPTlRJRz15CkNP
TkZJR19WSURFT0JVRjJfVk1BTExPQz1tCiMgZW5kIG9mIE1lZGlhIGRyaXZlcnMKCiMKIyBN
ZWRpYSBhbmNpbGxhcnkgZHJpdmVycwojCkNPTkZJR19WSURFT19DQU1FUkFfU0VOU09SPXkK
IyBDT05GSUdfVklERU9fQUxWSVVNX0NTSTIgaXMgbm90IHNldAojIENPTkZJR19WSURFT19B
UjA1MjEgaXMgbm90IHNldAojIENPTkZJR19WSURFT19HQzAzMDggaXMgbm90IHNldAojIENP
TkZJR19WSURFT19HQzA1QTIgaXMgbm90IHNldAojIENPTkZJR19WSURFT19HQzA4QTMgaXMg
bm90IHNldAojIENPTkZJR19WSURFT19HQzIxNDUgaXMgbm90IHNldAojIENPTkZJR19WSURF
T19ISTU1NiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0hJODQ2IGlzIG5vdCBzZXQKIyBD
T05GSUdfVklERU9fSEk4NDcgaXMgbm90IHNldAojIENPTkZJR19WSURFT19JTVgyMDggaXMg
bm90IHNldAojIENPTkZJR19WSURFT19JTVgyMTQgaXMgbm90IHNldAojIENPTkZJR19WSURF
T19JTVgyMTkgaXMgbm90IHNldAojIENPTkZJR19WSURFT19JTVgyNTggaXMgbm90IHNldAoj
IENPTkZJR19WSURFT19JTVgyNzQgaXMgbm90IHNldAojIENPTkZJR19WSURFT19JTVgyODMg
aXMgbm90IHNldAojIENPTkZJR19WSURFT19JTVgyOTAgaXMgbm90IHNldAojIENPTkZJR19W
SURFT19JTVgyOTYgaXMgbm90IHNldAojIENPTkZJR19WSURFT19JTVgzMTkgaXMgbm90IHNl
dAojIENPTkZJR19WSURFT19JTVgzMzQgaXMgbm90IHNldAojIENPTkZJR19WSURFT19JTVgz
MzUgaXMgbm90IHNldAojIENPTkZJR19WSURFT19JTVgzNTUgaXMgbm90IHNldAojIENPTkZJ
R19WSURFT19JTVg0MTIgaXMgbm90IHNldAojIENPTkZJR19WSURFT19JTVg0MTUgaXMgbm90
IHNldAojIENPTkZJR19WSURFT19NVDlNMDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9f
TVQ5TTExMSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX01UOU0xMTQgaXMgbm90IHNldAoj
IENPTkZJR19WSURFT19NVDlQMDMxIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fTVQ5VDEx
MiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX01UOVYwMTEgaXMgbm90IHNldApDT05GSUdf
VklERU9fTVQ5VjAzMj1tCiMgQ09ORklHX1ZJREVPX01UOVYxMTEgaXMgbm90IHNldAojIENP
TkZJR19WSURFT19PRzAxQTFCIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fT1YwMUExMCBp
cyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX09WMDJBMTAgaXMgbm90IHNldAojIENPTkZJR19W
SURFT19PVjA4RDEwIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fT1YwOFg0MCBpcyBub3Qg
c2V0CiMgQ09ORklHX1ZJREVPX09WMTM4NTggaXMgbm90IHNldAojIENPTkZJR19WSURFT19P
VjEzQjEwIGlzIG5vdCBzZXQKQ09ORklHX1ZJREVPX09WMjY0MD1tCiMgQ09ORklHX1ZJREVP
X09WMjY1OSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX09WMjY4MCBpcyBub3Qgc2V0CiMg
Q09ORklHX1ZJREVPX09WMjY4NSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX09WNDY4OSBp
cyBub3Qgc2V0CkNPTkZJR19WSURFT19PVjU2NDA9bQojIENPTkZJR19WSURFT19PVjU2NDUg
aXMgbm90IHNldAojIENPTkZJR19WSURFT19PVjU2NDcgaXMgbm90IHNldAojIENPTkZJR19W
SURFT19PVjU2NDggaXMgbm90IHNldAojIENPTkZJR19WSURFT19PVjU2NzAgaXMgbm90IHNl
dAojIENPTkZJR19WSURFT19PVjU2NzUgaXMgbm90IHNldAojIENPTkZJR19WSURFT19PVjU2
OTMgaXMgbm90IHNldAojIENPTkZJR19WSURFT19PVjU2OTUgaXMgbm90IHNldAojIENPTkZJ
R19WSURFT19PVjY0QTQwIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fT1Y2NjUwIGlzIG5v
dCBzZXQKIyBDT05GSUdfVklERU9fT1Y3MjUxIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9f
T1Y3NjQwIGlzIG5vdCBzZXQKQ09ORklHX1ZJREVPX09WNzY3MD1tCiMgQ09ORklHX1ZJREVP
X09WNzcyWCBpcyBub3Qgc2V0CkNPTkZJR19WSURFT19PVjc3NDA9bQojIENPTkZJR19WSURF
T19PVjg4NTYgaXMgbm90IHNldAojIENPTkZJR19WSURFT19PVjg4NTggaXMgbm90IHNldAoj
IENPTkZJR19WSURFT19PVjg4NjUgaXMgbm90IHNldAojIENPTkZJR19WSURFT19PVjkyODIg
aXMgbm90IHNldAojIENPTkZJR19WSURFT19PVjk2NDAgaXMgbm90IHNldAojIENPTkZJR19W
SURFT19PVjk2NTAgaXMgbm90IHNldAojIENPTkZJR19WSURFT19SREFDTTIwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVklERU9fUkRBQ00yMSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1JK
NTROMSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1M1QzczTTMgaXMgbm90IHNldAojIENP
TkZJR19WSURFT19TNUs1QkFGIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fUzVLNkEzIGlz
IG5vdCBzZXQKIyBDT05GSUdfVklERU9fVkdYWTYxIGlzIG5vdCBzZXQKIyBDT05GSUdfVklE
RU9fQ0NTIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fRVQ4RUs4IGlzIG5vdCBzZXQKCiMK
IyBDYW1lcmEgSVNQcwojCiMgQ09ORklHX1ZJREVPX1RIUDczMTIgaXMgbm90IHNldAojIGVu
ZCBvZiBDYW1lcmEgSVNQcwoKIwojIExlbnMgZHJpdmVycwojCiMgQ09ORklHX1ZJREVPX0FE
NTgyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0FLNzM3NSBpcyBub3Qgc2V0CiMgQ09O
RklHX1ZJREVPX0RXOTcxNCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0RXOTcxOSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1ZJREVPX0RXOTc2OCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVP
X0RXOTgwN19WQ00gaXMgbm90IHNldAojIGVuZCBvZiBMZW5zIGRyaXZlcnMKCiMKIyBGbGFz
aCBkZXZpY2VzCiMKIyBDT05GSUdfVklERU9fQURQMTY1MyBpcyBub3Qgc2V0CiMgQ09ORklH
X1ZJREVPX0xNMzU2MCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0xNMzY0NiBpcyBub3Qg
c2V0CiMgZW5kIG9mIEZsYXNoIGRldmljZXMKCiMKIyBBdWRpbyBkZWNvZGVycywgcHJvY2Vz
c29ycyBhbmQgbWl4ZXJzCiMKIyBDT05GSUdfVklERU9fQ1MzMzA4IGlzIG5vdCBzZXQKIyBD
T05GSUdfVklERU9fQ1M1MzQ1IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fQ1M1M0wzMkEg
aXMgbm90IHNldAojIENPTkZJR19WSURFT19NU1AzNDAwIGlzIG5vdCBzZXQKIyBDT05GSUdf
VklERU9fU09OWV9CVEZfTVBYIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fVERBMTk5N1gg
aXMgbm90IHNldAojIENPTkZJR19WSURFT19UREE3NDMyIGlzIG5vdCBzZXQKIyBDT05GSUdf
VklERU9fVERBOTg0MCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1RFQTY0MTVDIGlzIG5v
dCBzZXQKIyBDT05GSUdfVklERU9fVEVBNjQyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVP
X1RMVjMyMEFJQzIzQiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1RWQVVESU8gaXMgbm90
IHNldAojIENPTkZJR19WSURFT19VREExMzQyIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9f
VlAyN1NNUFggaXMgbm90IHNldAojIENPTkZJR19WSURFT19XTTg3MzkgaXMgbm90IHNldAoj
IENPTkZJR19WSURFT19XTTg3NzUgaXMgbm90IHNldAojIGVuZCBvZiBBdWRpbyBkZWNvZGVy
cywgcHJvY2Vzc29ycyBhbmQgbWl4ZXJzCgojCiMgUkRTIGRlY29kZXJzCiMKIyBDT05GSUdf
VklERU9fU0FBNjU4OCBpcyBub3Qgc2V0CiMgZW5kIG9mIFJEUyBkZWNvZGVycwoKIwojIFZp
ZGVvIGRlY29kZXJzCiMKIyBDT05GSUdfVklERU9fQURWNzE4MCBpcyBub3Qgc2V0CiMgQ09O
RklHX1ZJREVPX0FEVjcxODMgaXMgbm90IHNldAojIENPTkZJR19WSURFT19BRFY3NDhYIGlz
IG5vdCBzZXQKIyBDT05GSUdfVklERU9fQURWNzYwNCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJ
REVPX0FEVjc4NDIgaXMgbm90IHNldAojIENPTkZJR19WSURFT19CVDgxOSBpcyBub3Qgc2V0
CiMgQ09ORklHX1ZJREVPX0JUODU2IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fQlQ4NjYg
aXMgbm90IHNldAojIENPTkZJR19WSURFT19JU0w3OTk4WCBpcyBub3Qgc2V0CiMgQ09ORklH
X1ZJREVPX0tTMDEyNyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX01MODZWNzY2NyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1ZJREVPX1NBQTcxMTAgaXMgbm90IHNldAojIENPTkZJR19WSURF
T19TQUE3MTFYIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fVEMzNTg3NDMgaXMgbm90IHNl
dAojIENPTkZJR19WSURFT19UQzM1ODc0NiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1RW
UDUxNFggaXMgbm90IHNldAojIENPTkZJR19WSURFT19UVlA1MTUwIGlzIG5vdCBzZXQKIyBD
T05GSUdfVklERU9fVFZQNzAwMiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1RXMjgwNCBp
cyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1RXOTkwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJ
REVPX1RXOTkwMyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1RXOTkwNiBpcyBub3Qgc2V0
CiMgQ09ORklHX1ZJREVPX1RXOTkxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1ZQWDMy
MjAgaXMgbm90IHNldAoKIwojIFZpZGVvIGFuZCBhdWRpbyBkZWNvZGVycwojCiMgQ09ORklH
X1ZJREVPX1NBQTcxN1ggaXMgbm90IHNldAojIENPTkZJR19WSURFT19DWDI1ODQwIGlzIG5v
dCBzZXQKIyBlbmQgb2YgVmlkZW8gZGVjb2RlcnMKCiMKIyBWaWRlbyBlbmNvZGVycwojCiMg
Q09ORklHX1ZJREVPX0FEVjcxNzAgaXMgbm90IHNldAojIENPTkZJR19WSURFT19BRFY3MTc1
IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fQURWNzM0MyBpcyBub3Qgc2V0CiMgQ09ORklH
X1ZJREVPX0FEVjczOTMgaXMgbm90IHNldAojIENPTkZJR19WSURFT19BRFY3NTExIGlzIG5v
dCBzZXQKIyBDT05GSUdfVklERU9fQUs4ODFYIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9f
U0FBNzEyNyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1NBQTcxODUgaXMgbm90IHNldAoj
IENPTkZJR19WSURFT19USFM4MjAwIGlzIG5vdCBzZXQKIyBlbmQgb2YgVmlkZW8gZW5jb2Rl
cnMKCiMKIyBWaWRlbyBpbXByb3ZlbWVudCBjaGlwcwojCiMgQ09ORklHX1ZJREVPX1VQRDY0
MDMxQSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1VQRDY0MDgzIGlzIG5vdCBzZXQKIyBl
bmQgb2YgVmlkZW8gaW1wcm92ZW1lbnQgY2hpcHMKCiMKIyBBdWRpby9WaWRlbyBjb21wcmVz
c2lvbiBjaGlwcwojCiMgQ09ORklHX1ZJREVPX1NBQTY3NTJIUyBpcyBub3Qgc2V0CiMgZW5k
IG9mIEF1ZGlvL1ZpZGVvIGNvbXByZXNzaW9uIGNoaXBzCgojCiMgU0RSIHR1bmVyIGNoaXBz
CiMKIyBlbmQgb2YgU0RSIHR1bmVyIGNoaXBzCgojCiMgTWlzY2VsbGFuZW91cyBoZWxwZXIg
Y2hpcHMKIwojIENPTkZJR19WSURFT19JMkMgaXMgbm90IHNldAojIENPTkZJR19WSURFT19N
NTI3OTAgaXMgbm90IHNldAojIENPTkZJR19WSURFT19TVF9NSVBJRDAyIGlzIG5vdCBzZXQK
IyBDT05GSUdfVklERU9fVEhTNzMwMyBpcyBub3Qgc2V0CiMgZW5kIG9mIE1pc2NlbGxhbmVv
dXMgaGVscGVyIGNoaXBzCgojCiMgVmlkZW8gc2VyaWFsaXplcnMgYW5kIGRlc2VyaWFsaXpl
cnMKIwojIENPTkZJR19WSURFT19EUzkwVUI5MTMgaXMgbm90IHNldAojIENPTkZJR19WSURF
T19EUzkwVUI5NTMgaXMgbm90IHNldAojIENPTkZJR19WSURFT19EUzkwVUI5NjAgaXMgbm90
IHNldAojIENPTkZJR19WSURFT19NQVg5NjcxNCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVP
X01BWDk2NzE3IGlzIG5vdCBzZXQKIyBlbmQgb2YgVmlkZW8gc2VyaWFsaXplcnMgYW5kIGRl
c2VyaWFsaXplcnMKCiMKIyBNZWRpYSBTUEkgQWRhcHRlcnMKIwojIENPTkZJR19WSURFT19H
UzE2NjIgaXMgbm90IHNldAojIGVuZCBvZiBNZWRpYSBTUEkgQWRhcHRlcnMKIyBlbmQgb2Yg
TWVkaWEgYW5jaWxsYXJ5IGRyaXZlcnMKCiMKIyBHcmFwaGljcyBzdXBwb3J0CiMKQ09ORklH
X1ZJREVPPXkKIyBDT05GSUdfQVVYRElTUExBWSBpcyBub3Qgc2V0CkNPTkZJR19EUk09eQoj
IENPTkZJR19EUk1fREVCVUdfTU0gaXMgbm90IHNldApDT05GSUdfRFJNX0tNU19IRUxQRVI9
eQojIENPTkZJR19EUk1fUEFOSUMgaXMgbm90IHNldAojIENPTkZJR19EUk1fREVCVUdfRFBf
TVNUX1RPUE9MT0dZX1JFRlMgaXMgbm90IHNldAojIENPTkZJR19EUk1fREVCVUdfTU9ERVNF
VF9MT0NLIGlzIG5vdCBzZXQKQ09ORklHX0RSTV9DTElFTlRfU0VMRUNUSU9OPXkKCiMKIyBT
dXBwb3J0ZWQgRFJNIGNsaWVudHMKIwojIENPTkZJR19EUk1fRkJERVZfRU1VTEFUSU9OIGlz
IG5vdCBzZXQKIyBDT05GSUdfRFJNX0NMSUVOVF9MT0cgaXMgbm90IHNldAojIGVuZCBvZiBT
dXBwb3J0ZWQgRFJNIGNsaWVudHMKCiMgQ09ORklHX0RSTV9MT0FEX0VESURfRklSTVdBUkUg
aXMgbm90IHNldApDT05GSUdfRFJNX0RJU1BMQVlfRFBfQVVYX0JVUz15CkNPTkZJR19EUk1f
RElTUExBWV9IRUxQRVI9eQojIENPTkZJR19EUk1fRElTUExBWV9EUF9BVVhfQ0VDIGlzIG5v
dCBzZXQKIyBDT05GSUdfRFJNX0RJU1BMQVlfRFBfQVVYX0NIQVJERVYgaXMgbm90IHNldApD
T05GSUdfRFJNX0RJU1BMQVlfRFBfSEVMUEVSPXkKQ09ORklHX0RSTV9HRU1fRE1BX0hFTFBF
Uj15CgojCiMgQVJNIGRldmljZXMKIwojIENPTkZJR19EUk1fSERMQ0QgaXMgbm90IHNldAoj
IENPTkZJR19EUk1fTUFMSV9ESVNQTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX0tPTUVE
QSBpcyBub3Qgc2V0CiMgZW5kIG9mIEFSTSBkZXZpY2VzCgojIENPTkZJR19EUk1fVkdFTSBp
cyBub3Qgc2V0CiMgQ09ORklHX0RSTV9WS01TIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1VE
TCBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9BUk1BREEgaXMgbm90IHNldApDT05GSUdfRFJN
X0FUTUVMX0hMQ0RDPXkKIyBDT05GSUdfRFJNX1RJTENEQyBpcyBub3Qgc2V0CiMgQ09ORklH
X0RSTV9WSVJUSU9fR1BVIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX0ZTTF9EQ1UgaXMgbm90
IHNldApDT05GSUdfRFJNX1BBTkVMPXkKCiMKIyBEaXNwbGF5IFBhbmVscwojCiMgQ09ORklH
X0RSTV9QQU5FTF9BQlRfWTAzMFhYMDY3QSBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9QQU5F
TF9BUk1fVkVSU0FUSUxFIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1BBTkVMX0FVT19BMDMw
SlROMDEgaXMgbm90IHNldAojIENPTkZJR19EUk1fUEFORUxfTFZEUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0RSTV9QQU5FTF9JTElURUtfSUw5MzIyIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJN
X1BBTkVMX0lMSVRFS19JTEk5MzQxIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1BBTkVMX0lO
Tk9MVVhfRUowMzBOQSBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9QQU5FTF9MR19MQjAzNVEw
MiBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9QQU5FTF9MR19MRzQ1NzMgaXMgbm90IHNldAoj
IENPTkZJR19EUk1fUEFORUxfTkVDX05MODA0OEhMMTEgaXMgbm90IHNldAojIENPTkZJR19E
Uk1fUEFORUxfTkVXVklTSU9OX05WMzA1MkMgaXMgbm90IHNldAojIENPTkZJR19EUk1fUEFO
RUxfTk9WQVRFS19OVDM5MDE2IGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1BBTkVMX09MSU1F
WF9MQ0RfT0xJTlVYSU5PIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1BBTkVMX09SSVNFVEVD
SF9PVEE1NjAxQSBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9QQU5FTF9TQU1TVU5HX1M2RTg4
QTBfQU1TNDUyRUYwMSBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9QQU5FTF9TQU1TVU5HX0FU
TkEzM1hDMjAgaXMgbm90IHNldAojIENPTkZJR19EUk1fUEFORUxfU0FNU1VOR19EQjc0MzAg
aXMgbm90IHNldAojIENPTkZJR19EUk1fUEFORUxfU0FNU1VOR19MRDkwNDAgaXMgbm90IHNl
dAojIENPTkZJR19EUk1fUEFORUxfU0FNU1VOR19TNkQyN0ExIGlzIG5vdCBzZXQKIyBDT05G
SUdfRFJNX1BBTkVMX1NBTVNVTkdfUzZEN0FBMCBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9Q
QU5FTF9TQU1TVU5HX1M2RTYzTTAgaXMgbm90IHNldAojIENPTkZJR19EUk1fUEFORUxfU0FN
U1VOR19TNkU4QUEwIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1BBTkVMX1NFSUtPXzQzV1ZG
MUcgaXMgbm90IHNldAojIENPTkZJR19EUk1fUEFORUxfU0hBUlBfTFMwMzdWN0RXMDEgaXMg
bm90IHNldAojIENPTkZJR19EUk1fUEFORUxfU0lUUk9OSVhfU1Q3NzAxIGlzIG5vdCBzZXQK
IyBDT05GSUdfRFJNX1BBTkVMX1NJVFJPTklYX1NUNzc4OVYgaXMgbm90IHNldAojIENPTkZJ
R19EUk1fUEFORUxfU09OWV9BQ1g1NjVBS00gaXMgbm90IHNldApDT05GSUdfRFJNX1BBTkVM
X0VEUD15CkNPTkZJR19EUk1fUEFORUxfU0lNUExFPXkKIyBDT05GSUdfRFJNX1BBTkVMX1RQ
T19URDAyOFRURUMxIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1BBTkVMX1RQT19URDA0M01U
RUExIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1BBTkVMX1RQT19UUEcxMTAgaXMgbm90IHNl
dAojIENPTkZJR19EUk1fUEFORUxfV0lERUNISVBTX1dTMjQwMSBpcyBub3Qgc2V0CiMgZW5k
IG9mIERpc3BsYXkgUGFuZWxzCgpDT05GSUdfRFJNX0JSSURHRT15CkNPTkZJR19EUk1fUEFO
RUxfQlJJREdFPXkKCiMKIyBEaXNwbGF5IEludGVyZmFjZSBCcmlkZ2VzCiMKIyBDT05GSUdf
RFJNX0NISVBPTkVfSUNONjIxMSBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9DSFJPTlRFTF9D
SDcwMzMgaXMgbm90IHNldAojIENPTkZJR19EUk1fRElTUExBWV9DT05ORUNUT1IgaXMgbm90
IHNldAojIENPTkZJR19EUk1fSTJDX05YUF9UREE5OThYIGlzIG5vdCBzZXQKIyBDT05GSUdf
RFJNX0lURV9JVDYyNjMgaXMgbm90IHNldAojIENPTkZJR19EUk1fSVRFX0lUNjUwNSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RSTV9MT05USVVNX0xUODkxMkIgaXMgbm90IHNldAojIENPTkZJ
R19EUk1fTE9OVElVTV9MVDkyMTEgaXMgbm90IHNldAojIENPTkZJR19EUk1fTE9OVElVTV9M
VDk2MTEgaXMgbm90IHNldAojIENPTkZJR19EUk1fTE9OVElVTV9MVDk2MTFVWEMgaXMgbm90
IHNldAojIENPTkZJR19EUk1fSVRFX0lUNjYxMjEgaXMgbm90IHNldAojIENPTkZJR19EUk1f
TFZEU19DT0RFQyBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9NRUdBQ0hJUFNfU1REUFhYWFhf
R0VfQjg1MFYzX0ZXIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX01JQ1JPQ0hJUF9MVkRTX1NF
UklBTElaRVIgaXMgbm90IHNldAojIENPTkZJR19EUk1fTldMX01JUElfRFNJIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRFJNX05YUF9QVE4zNDYwIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1BB
UkFERV9QUzg2MjIgaXMgbm90IHNldAojIENPTkZJR19EUk1fUEFSQURFX1BTODY0MCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RSTV9TQU1TVU5HX0RTSU0gaXMgbm90IHNldAojIENPTkZJR19E
Uk1fU0lMX1NJSTg2MjAgaXMgbm90IHNldAojIENPTkZJR19EUk1fU0lJOTAyWCBpcyBub3Qg
c2V0CiMgQ09ORklHX0RSTV9TSUk5MjM0IGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1NJTVBM
RV9CUklER0UgaXMgbm90IHNldAojIENPTkZJR19EUk1fVEhJTkVfVEhDNjNMVkQxMDI0IGlz
IG5vdCBzZXQKIyBDT05GSUdfRFJNX1RPU0hJQkFfVEMzNTg3NjIgaXMgbm90IHNldAojIENP
TkZJR19EUk1fVE9TSElCQV9UQzM1ODc2NCBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9UT1NI
SUJBX1RDMzU4NzY3IGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1RPU0hJQkFfVEMzNTg3Njgg
aXMgbm90IHNldAojIENPTkZJR19EUk1fVE9TSElCQV9UQzM1ODc3NSBpcyBub3Qgc2V0CiMg
Q09ORklHX0RSTV9USV9ETFBDMzQzMyBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9USV9URFAx
NTggaXMgbm90IHNldAojIENPTkZJR19EUk1fVElfVEZQNDEwIGlzIG5vdCBzZXQKIyBDT05G
SUdfRFJNX1RJX1NONjVEU0k4MyBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9USV9TTjY1RFNJ
ODYgaXMgbm90IHNldAojIENPTkZJR19EUk1fVElfVFBEMTJTMDE1IGlzIG5vdCBzZXQKIyBD
T05GSUdfRFJNX0FOQUxPR0lYX0FOWDYzNDUgaXMgbm90IHNldAojIENPTkZJR19EUk1fQU5B
TE9HSVhfQU5YNzhYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9BTkFMT0dJWF9BTlg3NjI1
IGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX0kyQ19BRFY3NTExIGlzIG5vdCBzZXQKIyBDT05G
SUdfRFJNX0NETlNfRFNJIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX0NETlNfTUhEUDg1NDYg
aXMgbm90IHNldAojIGVuZCBvZiBEaXNwbGF5IEludGVyZmFjZSBCcmlkZ2VzCgojIENPTkZJ
R19EUk1fRVROQVZJViBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9MT0dJQ1ZDIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRFJNX0FQUExFVEJEUk0gaXMgbm90IHNldAojIENPTkZJR19EUk1fQVJD
UEdVIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX0dNMTJVMzIwIGlzIG5vdCBzZXQKIyBDT05G
SUdfRFJNX1BBTkVMX01JUElfREJJIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1NJTVBMRURS
TSBpcyBub3Qgc2V0CiMgQ09ORklHX1RJTllEUk1fSFg4MzU3RCBpcyBub3Qgc2V0CiMgQ09O
RklHX1RJTllEUk1fSUxJOTE2MyBpcyBub3Qgc2V0CiMgQ09ORklHX1RJTllEUk1fSUxJOTIy
NSBpcyBub3Qgc2V0CiMgQ09ORklHX1RJTllEUk1fSUxJOTM0MSBpcyBub3Qgc2V0CiMgQ09O
RklHX1RJTllEUk1fSUxJOTQ4NiBpcyBub3Qgc2V0CiMgQ09ORklHX1RJTllEUk1fTUkwMjgz
UVQgaXMgbm90IHNldAojIENPTkZJR19USU5ZRFJNX1JFUEFQRVIgaXMgbm90IHNldAojIENP
TkZJR19USU5ZRFJNX1NIQVJQX01FTU9SWSBpcyBub3Qgc2V0CiMgQ09ORklHX1RJTllEUk1f
U1Q3NTg2IGlzIG5vdCBzZXQKIyBDT05GSUdfVElOWURSTV9TVDc3MzVSIGlzIG5vdCBzZXQK
IyBDT05GSUdfRFJNX1BMMTExIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX0xJTUEgaXMgbm90
IHNldAojIENPTkZJR19EUk1fUEFORlJPU1QgaXMgbm90IHNldAojIENPTkZJR19EUk1fUEFO
VEhPUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9USURTUyBpcyBub3Qgc2V0CiMgQ09ORklH
X0RSTV9HVUQgaXMgbm90IHNldAojIENPTkZJR19EUk1fU1NEMTMwWCBpcyBub3Qgc2V0CiMg
Q09ORklHX0RSTV9XRVJST1IgaXMgbm90IHNldApDT05GSUdfRFJNX1BBTkVMX09SSUVOVEFU
SU9OX1FVSVJLUz15CgojCiMgRnJhbWUgYnVmZmVyIERldmljZXMKIwojIENPTkZJR19GQiBp
cyBub3Qgc2V0CiMgZW5kIG9mIEZyYW1lIGJ1ZmZlciBEZXZpY2VzCgojCiMgQmFja2xpZ2h0
ICYgTENEIGRldmljZSBzdXBwb3J0CiMKQ09ORklHX0xDRF9DTEFTU19ERVZJQ0U9eQojIENP
TkZJR19MQ0RfTDRGMDAyNDJUMDMgaXMgbm90IHNldAojIENPTkZJR19MQ0RfTE1TMjgzR0Yw
NSBpcyBub3Qgc2V0CiMgQ09ORklHX0xDRF9MVFYzNTBRViBpcyBub3Qgc2V0CiMgQ09ORklH
X0xDRF9JTEk5MjJYIGlzIG5vdCBzZXQKIyBDT05GSUdfTENEX0lMSTkzMjAgaXMgbm90IHNl
dAojIENPTkZJR19MQ0RfVERPMjRNIGlzIG5vdCBzZXQKIyBDT05GSUdfTENEX1ZHRzI0MzJB
NCBpcyBub3Qgc2V0CiMgQ09ORklHX0xDRF9QTEFURk9STSBpcyBub3Qgc2V0CiMgQ09ORklH
X0xDRF9BTVMzNjlGRzA2IGlzIG5vdCBzZXQKIyBDT05GSUdfTENEX0xNUzUwMUtGMDMgaXMg
bm90IHNldAojIENPTkZJR19MQ0RfSFg4MzU3IGlzIG5vdCBzZXQKIyBDT05GSUdfTENEX09U
TTMyMjVBIGlzIG5vdCBzZXQKQ09ORklHX0JBQ0tMSUdIVF9DTEFTU19ERVZJQ0U9eQojIENP
TkZJR19CQUNLTElHSFRfS1REMjUzIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS0xJR0hUX0tU
RDI4MDEgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfS1RaODg2NiBpcyBub3Qgc2V0
CkNPTkZJR19CQUNLTElHSFRfUFdNPXkKIyBDT05GSUdfQkFDS0xJR0hUX1FDT01fV0xFRCBp
cyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tMSUdIVF9BRFA4ODYwIGlzIG5vdCBzZXQKIyBDT05G
SUdfQkFDS0xJR0hUX0FEUDg4NzAgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfTE0z
NTA5IGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS0xJR0hUX0xNMzYzMEEgaXMgbm90IHNldAoj
IENPTkZJR19CQUNLTElHSFRfTE0zNjM5IGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS0xJR0hU
X0xQODU1WCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tMSUdIVF9NUDMzMDlDIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQkFDS0xJR0hUX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19CQUNLTElH
SFRfTFY1MjA3TFAgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfQkQ2MTA3IGlzIG5v
dCBzZXQKIyBDT05GSUdfQkFDS0xJR0hUX0FSQ1hDTk4gaXMgbm90IHNldAojIENPTkZJR19C
QUNLTElHSFRfTEVEIGlzIG5vdCBzZXQKIyBlbmQgb2YgQmFja2xpZ2h0ICYgTENEIGRldmlj
ZSBzdXBwb3J0CgpDT05GSUdfVklERU9NT0RFX0hFTFBFUlM9eQpDT05GSUdfSERNST15Cgoj
CiMgQ29uc29sZSBkaXNwbGF5IGRyaXZlciBzdXBwb3J0CiMKQ09ORklHX0RVTU1ZX0NPTlNP
TEU9eQpDT05GSUdfRFVNTVlfQ09OU09MRV9DT0xVTU5TPTgwCkNPTkZJR19EVU1NWV9DT05T
T0xFX1JPV1M9MzAKIyBlbmQgb2YgQ29uc29sZSBkaXNwbGF5IGRyaXZlciBzdXBwb3J0CiMg
ZW5kIG9mIEdyYXBoaWNzIHN1cHBvcnQKCiMgQ09ORklHX0RSTV9BQ0NFTCBpcyBub3Qgc2V0
CkNPTkZJR19TT1VORD15CkNPTkZJR19TTkQ9eQpDT05GSUdfU05EX1RJTUVSPXkKQ09ORklH
X1NORF9QQ009eQpDT05GSUdfU05EX0RNQUVOR0lORV9QQ009eQpDT05GSUdfU05EX0pBQ0s9
eQpDT05GSUdfU05EX0pBQ0tfSU5QVVRfREVWPXkKIyBDT05GSUdfU05EX09TU0VNVUwgaXMg
bm90IHNldApDT05GSUdfU05EX1BDTV9USU1FUj15CiMgQ09ORklHX1NORF9IUlRJTUVSIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX0RZTkFNSUNfTUlOT1JTIGlzIG5vdCBzZXQKQ09ORklH
X1NORF9TVVBQT1JUX09MRF9BUEk9eQpDT05GSUdfU05EX1BST0NfRlM9eQpDT05GSUdfU05E
X1ZFUkJPU0VfUFJPQ0ZTPXkKQ09ORklHX1NORF9DVExfRkFTVF9MT09LVVA9eQojIENPTkZJ
R19TTkRfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19TTkRfQ1RMX0lOUFVUX1ZBTElEQVRJ
T04gaXMgbm90IHNldAojIENPTkZJR19TTkRfVVRJTUVSIGlzIG5vdCBzZXQKIyBDT05GSUdf
U05EX1NFUVVFTkNFUiBpcyBub3Qgc2V0CkNPTkZJR19TTkRfRFJJVkVSUz15CiMgQ09ORklH
X1NORF9EVU1NWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BTE9PUCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9QQ01URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX01UUEFWIGlzIG5v
dCBzZXQKIyBDT05GSUdfU05EX1NFUklBTF9VMTY1NTAgaXMgbm90IHNldAojIENPTkZJR19T
TkRfTVBVNDAxIGlzIG5vdCBzZXQKCiMKIyBIRC1BdWRpbwojCiMgZW5kIG9mIEhELUF1ZGlv
CgpDT05GSUdfU05EX0hEQV9QUkVBTExPQ19TSVpFPTY0CkNPTkZJR19TTkRfQVJNPXkKCiMK
IyBBdG1lbCBkZXZpY2VzIChBVDkxKQojCiMgQ09ORklHX1NORF9BVE1FTF9BQzk3QyBpcyBu
b3Qgc2V0CiMgZW5kIG9mIEF0bWVsIGRldmljZXMgKEFUOTEpCgpDT05GSUdfU05EX1NQST15
CiMgQ09ORklHX1NORF9BVDczQzIxMyBpcyBub3Qgc2V0CkNPTkZJR19TTkRfVVNCPXkKIyBD
T05GSUdfU05EX1VTQl9BVURJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9VU0JfVUExMDEg
aXMgbm90IHNldAojIENPTkZJR19TTkRfVVNCX0NBSUFRIGlzIG5vdCBzZXQKIyBDT05GSUdf
U05EX1VTQl82RklSRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9VU0JfSElGQUNFIGlzIG5v
dCBzZXQKIyBDT05GSUdfU05EX0JDRDIwMDAgaXMgbm90IHNldAojIENPTkZJR19TTkRfVVNC
X1BPRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9VU0JfUE9ESEQgaXMgbm90IHNldAojIENP
TkZJR19TTkRfVVNCX1RPTkVQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1VTQl9WQVJJ
QVggaXMgbm90IHNldApDT05GSUdfU05EX1NPQz15CkNPTkZJR19TTkRfU09DX0dFTkVSSUNf
RE1BRU5HSU5FX1BDTT15CiMgQ09ORklHX1NORF9TT0NfQURJIGlzIG5vdCBzZXQKIyBDT05G
SUdfU05EX1NPQ19BTURfQUNQIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FNRF9BQ1BfQ09O
RklHIGlzIG5vdCBzZXQKQ09ORklHX1NORF9BVE1FTF9TT0M9eQpDT05GSUdfU05EX0FUTUVM
X1NPQ19QREM9eQpDT05GSUdfU05EX0FUTUVMX1NPQ19ETUE9eQpDT05GSUdfU05EX0FUTUVM
X1NPQ19TU0M9eQojIENPTkZJR19TTkRfQVRNRUxfU09DX1NTQ19QREMgaXMgbm90IHNldApD
T05GSUdfU05EX0FUTUVMX1NPQ19TU0NfRE1BPXkKIyBDT05GSUdfU05EX0FUOTFfU09DX1NB
TTlHMjBfV004NzMxIGlzIG5vdCBzZXQKQ09ORklHX1NORF9BVE1FTF9TT0NfV004OTA0PXkK
IyBDT05GSUdfU05EX0FUOTFfU09DX1NBTTlYNV9XTTg3MzEgaXMgbm90IHNldApDT05GSUdf
U05EX0FUTUVMX1NPQ19DTEFTU0Q9eQpDT05GSUdfU05EX0FUTUVMX1NPQ19QRE1JQz15CkNP
TkZJR19TTkRfQVRNRUxfU09DX1RTRTg1MF9QQ001MTQyPW0KQ09ORklHX1NORF9BVE1FTF9T
T0NfSTJTPXkKQ09ORklHX1NORF9TT0NfTUlLUk9FX1BST1RPPW0KIyBDT05GSUdfU05EX01D
SFBfU09DX0kyU19NQ0MgaXMgbm90IHNldAojIENPTkZJR19TTkRfTUNIUF9TT0NfU1BESUZU
WCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9NQ0hQX1NPQ19TUERJRlJYIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX01DSFBfU09DX1BETUMgaXMgbm90IHNldAojIENPTkZJR19TTkRfQkNN
NjNYWF9JMlNfV0hJU1RMRVIgaXMgbm90IHNldAojIENPTkZJR19TTkRfREVTSUdOV0FSRV9J
MlMgaXMgbm90IHNldAoKIwojIFNvQyBBdWRpbyBmb3IgRnJlZXNjYWxlIENQVXMKIwoKIwoj
IENvbW1vbiBTb0MgQXVkaW8gb3B0aW9ucyBmb3IgRnJlZXNjYWxlIENQVXM6CiMKIyBDT05G
SUdfU05EX1NPQ19GU0xfQVNSQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfRlNMX1NB
SSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfRlNMX0FVRE1JWCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9TT0NfRlNMX1NTSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfRlNM
X1NQRElGIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19GU0xfRVNBSSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NORF9TT0NfRlNMX01JQ0ZJTCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9T
T0NfRlNMX1hDVlIgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX0lNWF9BVURNVVggaXMg
bm90IHNldAojIGVuZCBvZiBTb0MgQXVkaW8gZm9yIEZyZWVzY2FsZSBDUFVzCgojIENPTkZJ
R19TTkRfU09DX0NIVjNfSTJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0kyU19ISTYyMTBf
STJTIGlzIG5vdCBzZXQKCiMKIyBTb0MgQXVkaW8gZm9yIExvb25nc29uIENQVXMKIwojIGVu
ZCBvZiBTb0MgQXVkaW8gZm9yIExvb25nc29uIENQVXMKCiMgQ09ORklHX1NORF9TT0NfSU1H
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19NVEtfQlRDVlNEIGlzIG5vdCBzZXQKQ09O
RklHX1NORF9TT0NfU0RDQV9PUFRJT05BTD15CiMgQ09ORklHX1NORF9TT0NfU09GX1RPUExF
VkVMIGlzIG5vdCBzZXQKCiMKIyBTVE1pY3JvZWxlY3Ryb25pY3MgU1RNMzIgU09DIGF1ZGlv
IHN1cHBvcnQKIwojIGVuZCBvZiBTVE1pY3JvZWxlY3Ryb25pY3MgU1RNMzIgU09DIGF1ZGlv
IHN1cHBvcnQKCiMgQ09ORklHX1NORF9TT0NfWElMSU5YX0kyUyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9TT0NfWElMSU5YX0FVRElPX0ZPUk1BVFRFUiBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9TT0NfWElMSU5YX1NQRElGIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19YVEZQ
R0FfSTJTIGlzIG5vdCBzZXQKQ09ORklHX1NORF9TT0NfSTJDX0FORF9TUEk9eQoKIwojIENP
REVDIGRyaXZlcnMKIwojIENPTkZJR19TTkRfU09DX0FDOTdfQ09ERUMgaXMgbm90IHNldAoj
IENPTkZJR19TTkRfU09DX0FEQVUxMzcyX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9T
T0NfQURBVTEzNzJfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19BREFVMTM3MyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQURBVTE3MDEgaXMgbm90IHNldAojIENPTkZJ
R19TTkRfU09DX0FEQVUxNzYxX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQURB
VTE3NjFfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19BREFVNzAwMiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9TT0NfQURBVTcxMThfSFcgaXMgbm90IHNldAojIENPTkZJR19T
TkRfU09DX0FEQVU3MTE4X0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQUs0MTA0
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19BSzQxMTggaXMgbm90IHNldAojIENPTkZJ
R19TTkRfU09DX0FLNDM3NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQUs0NDU4IGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19BSzQ1NTQgaXMgbm90IHNldAojIENPTkZJR19T
TkRfU09DX0FLNDYxMyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQUs0NjE5IGlzIG5v
dCBzZXQKIyBDT05GSUdfU05EX1NPQ19BSzQ2NDIgaXMgbm90IHNldAojIENPTkZJR19TTkRf
U09DX0FLNTM4NiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQUs1NTU4IGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX1NPQ19BTEM1NjIzIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NP
Q19BVURJT19JSU9fQVVYIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19BVzg3MzggaXMg
bm90IHNldAojIENPTkZJR19TTkRfU09DX0FXODgzOTUgaXMgbm90IHNldAojIENPTkZJR19T
TkRfU09DX0FXODgxNjYgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX0FXODgyNjEgaXMg
bm90IHNldAojIENPTkZJR19TTkRfU09DX0FXODgwODEgaXMgbm90IHNldAojIENPTkZJR19T
TkRfU09DX0FXODczOTAgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX0FXODgzOTkgaXMg
bm90IHNldAojIENPTkZJR19TTkRfU09DX0JEMjg2MjMgaXMgbm90IHNldAojIENPTkZJR19T
TkRfU09DX0JUX1NDTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQ0hWM19DT0RFQyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQ1MzNUwzMiBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9TT0NfQ1MzNUwzMyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQ1MzNUwzNCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQ1MzNUwzNSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9TT0NfQ1MzNUwzNiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQ1MzNUw0MV9T
UEkgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX0NTMzVMNDFfSTJDIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX1NPQ19DUzM1TDQ1X1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9T
T0NfQ1MzNUw0NV9JMkMgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX0NTMzVMNTZfSTJD
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19DUzM1TDU2X1NQSSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9TT0NfQ1M0Mkw0MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQ1M0
Mkw1MV9JMkMgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX0NTNDJMNTIgaXMgbm90IHNl
dAojIENPTkZJR19TTkRfU09DX0NTNDJMNTYgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09D
X0NTNDJMNzMgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX0NTNDJMODMgaXMgbm90IHNl
dAojIENPTkZJR19TTkRfU09DX0NTNDJMODQgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09D
X0NTNDIzNCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQ1M0MjY1IGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX1NPQ19DUzQyNzAgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX0NT
NDI3MV9JMkMgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX0NTNDI3MV9TUEkgaXMgbm90
IHNldAojIENPTkZJR19TTkRfU09DX0NTNDJYWDhfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdf
U05EX1NPQ19DUzQzMTMwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19DUzQzNDEgaXMg
bm90IHNldAojIENPTkZJR19TTkRfU09DX0NTNDM0OSBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9TT0NfQ1M1M0wzMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQ1M1MzBYX0kyQyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfQ1gyMDcyWCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9TT0NfREE3MjEzIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19ETUlDIGlzIG5v
dCBzZXQKIyBDT05GSUdfU05EX1NPQ19FUzcxMzQgaXMgbm90IHNldAojIENPTkZJR19TTkRf
U09DX0VTNzI0MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfRVM4MzExIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX1NPQ19FUzgzMTYgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09D
X0VTODMyMyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfRVM4MzI2IGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX1NPQ19FUzgzMjhfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NP
Q19FUzgzMjhfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19HVE02MDEgaXMgbm90
IHNldAojIENPTkZJR19TTkRfU09DX0hEQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0Nf
SUNTNDM0MzIgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX0lEVDgyMTAzNCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9TT0NfTUFYOTgwODggaXMgbm90IHNldAojIENPTkZJR19TTkRf
U09DX01BWDk4MDkwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19NQVg5ODM1N0EgaXMg
bm90IHNldAojIENPTkZJR19TTkRfU09DX01BWDk4NTA0IGlzIG5vdCBzZXQKIyBDT05GSUdf
U05EX1NPQ19NQVg5ODY3IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19NQVg5ODkyNyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfTUFYOTg1MjAgaXMgbm90IHNldAojIENPTkZJ
R19TTkRfU09DX01BWDk4MzczX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfTUFY
OTgzODggaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX01BWDk4MzkwIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX1NPQ19NQVg5ODM5NiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0Nf
TUFYOTg2MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfTVNNODkxNl9XQ0RfRElHSVRB
TCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfUENNMTY4MSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9TT0NfUENNMTc4OV9JMkMgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1BD
TTE3OVhfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19QQ00xNzlYX1NQSSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfUENNMTg2WF9JMkMgaXMgbm90IHNldAojIENPTkZJ
R19TTkRfU09DX1BDTTE4NlhfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19QQ00z
MDYwX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfUENNMzA2MF9TUEkgaXMgbm90
IHNldAojIENPTkZJR19TTkRfU09DX1BDTTMxNjhBX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9TT0NfUENNMzE2OEFfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19QQ001
MTAyQSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfU09DX1BDTTUxMng9bQpDT05GSUdfU05EX1NP
Q19QQ001MTJ4X0kyQz1tCiMgQ09ORklHX1NORF9TT0NfUENNNTEyeF9TUEkgaXMgbm90IHNl
dAojIENPTkZJR19TTkRfU09DX1BDTTYyNDAgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09D
X1BFQjI0NjYgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1JUNTYxNiBpcyBub3Qgc2V0
CiMgQ09ORklHX1NORF9TT0NfUlQ1NjMxIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19S
VDU2NDAgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1JUNTY1OSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9TT0NfUlQ5MTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19SVFE5
MTI4IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19TR1RMNTAwMCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9TT0NfU0lNUExFX0FNUExJRklFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9TT0NfU0lNUExFX01VWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfU01BMTMwMyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfU01BMTMwNyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9TT0NfU1BESUYgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1NSQzRYWFhfSTJD
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19TU00yMzA1IGlzIG5vdCBzZXQKIyBDT05G
SUdfU05EX1NPQ19TU00yNTE4IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19TU00yNjAy
X1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfU1NNMjYwMl9JMkMgaXMgbm90IHNl
dAojIENPTkZJR19TTkRfU09DX1NTTTM1MTUgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09D
X1NTTTQ1NjcgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1NUQTMyWCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NORF9TT0NfU1RBMzUwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19T
VElfU0FTIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19UQVMyNTUyIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX1NPQ19UQVMyNTYyIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19U
QVMyNzY0IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19UQVMyNzcwIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX1NPQ19UQVMyNzgwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19U
QVMyNzgxX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfVEFTNTA4NiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9TT0NfVEFTNTcxWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9T
T0NfVEFTNTcyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfVEFTNTgwNU0gaXMgbm90
IHNldAojIENPTkZJR19TTkRfU09DX1RBUzY0MjQgaXMgbm90IHNldAojIENPTkZJR19TTkRf
U09DX1REQTc0MTkgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1RGQTk4NzkgaXMgbm90
IHNldAojIENPTkZJR19TTkRfU09DX1RGQTk4OVggaXMgbm90IHNldAojIENPTkZJR19TTkRf
U09DX1RMVjMyMEFEQzNYWFggaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1RMVjMyMEFJ
QzIzX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfVExWMzIwQUlDMjNfU1BJIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19UTFYzMjBBSUMzMVhYIGlzIG5vdCBzZXQKIyBD
T05GSUdfU05EX1NPQ19UTFYzMjBBSUMzMlg0X0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9TT0NfVExWMzIwQUlDMzJYNF9TUEkgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1RM
VjMyMEFJQzNYX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfVExWMzIwQUlDM1hf
U1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19UTFYzMjBBRENYMTQwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX1NPQ19UUzNBMjI3RSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9T
T0NfVFNDUzQyWFggaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1RTQ1M0NTQgaXMgbm90
IHNldAojIENPTkZJR19TTkRfU09DX1VEQTEzMzQgaXMgbm90IHNldAojIENPTkZJR19TTkRf
U09DX1VEQTEzNDIgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1dNODUxMCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9TT0NfV004NTIzIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NP
Q19XTTg1MjQgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1dNODU4MCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NORF9TT0NfV004NzExIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19X
TTg3MjggaXMgbm90IHNldApDT05GSUdfU05EX1NPQ19XTTg3MzE9bQojIENPTkZJR19TTkRf
U09DX1dNODczMV9JMkMgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1dNODczMV9TUEkg
aXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX1dNODczNyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9TT0NfV004NzQxIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19XTTg3NTAgaXMg
bm90IHNldAojIENPTkZJR19TTkRfU09DX1dNODc1MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9TT0NfV004NzcwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19XTTg3NzYgaXMgbm90
IHNldAojIENPTkZJR19TTkRfU09DX1dNODc4MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9T
T0NfV004ODA0X0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfV004ODA0X1NQSSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfV004OTAzIGlzIG5vdCBzZXQKQ09ORklHX1NO
RF9TT0NfV004OTA0PXkKIyBDT05GSUdfU05EX1NPQ19XTTg5NDAgaXMgbm90IHNldAojIENP
TkZJR19TTkRfU09DX1dNODk2MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfV004OTYx
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19XTTg5NjIgaXMgbm90IHNldAojIENPTkZJ
R19TTkRfU09DX1dNODk3NCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfV004OTc4IGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19XTTg5ODUgaXMgbm90IHNldAojIENPTkZJR19T
TkRfU09DX1pMMzgwNjAgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX01BWDk3NTkgaXMg
bm90IHNldAojIENPTkZJR19TTkRfU09DX01UNjM1MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9TT0NfTVQ2MzU3IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19NVDYzNTggaXMgbm90
IHNldAojIENPTkZJR19TTkRfU09DX01UNjY2MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9T
T0NfTkFVODMxNSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfTkFVODU0MCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9TT0NfTkFVODgxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9T
T0NfTkFVODgyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfTkFVODgyMiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9TT0NfTkFVODgyNCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9T
T0NfTlRQODkxOCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfTlRQODgzNSBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9TT0NfVFBBNjEzMEEyIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X1NPQ19MUEFTU19XU0FfTUFDUk8gaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DX0xQQVNT
X1ZBX01BQ1JPIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQ19MUEFTU19SWF9NQUNSTyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT0NfTFBBU1NfVFhfTUFDUk8gaXMgbm90IHNldAoj
IGVuZCBvZiBDT0RFQyBkcml2ZXJzCgojIENPTkZJR19TTkRfU0lNUExFX0NBUkQgaXMgbm90
IHNldAojIENPTkZJR19TTkRfQVVESU9fR1JBUEhfQ0FSRCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9BVURJT19HUkFQSF9DQVJEMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9URVNUX0NP
TVBPTkVOVCBpcyBub3Qgc2V0CkNPTkZJR19ISURfU1VQUE9SVD15CkNPTkZJR19ISUQ9eQoj
IENPTkZJR19ISURfQkFUVEVSWV9TVFJFTkdUSCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRFJB
VyBpcyBub3Qgc2V0CiMgQ09ORklHX1VISUQgaXMgbm90IHNldAojIENPTkZJR19ISURfR0VO
RVJJQyBpcyBub3Qgc2V0CgojCiMgU3BlY2lhbCBISUQgZHJpdmVycwojCiMgQ09ORklHX0hJ
RF9BNFRFQ0ggaXMgbm90IHNldAojIENPTkZJR19ISURfQUNDVVRPVUNIIGlzIG5vdCBzZXQK
IyBDT05GSUdfSElEX0FDUlVYIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0FQUExFIGlzIG5v
dCBzZXQKIyBDT05GSUdfSElEX0FQUExFSVIgaXMgbm90IHNldAojIENPTkZJR19ISURfQVBQ
TEVUQl9CTCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9BUFBMRVRCX0tCRCBpcyBub3Qgc2V0
CiMgQ09ORklHX0hJRF9BU1VTIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0FVUkVBTCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hJRF9CRUxLSU4gaXMgbm90IHNldAojIENPTkZJR19ISURfQkVU
T1BfRkYgaXMgbm90IHNldAojIENPTkZJR19ISURfQklHQkVOX0ZGIGlzIG5vdCBzZXQKIyBD
T05GSUdfSElEX0NIRVJSWSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9DSElDT05ZIGlzIG5v
dCBzZXQKIyBDT05GSUdfSElEX0NPUlNBSVIgaXMgbm90IHNldAojIENPTkZJR19ISURfQ09V
R0FSIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX01BQ0FMTFkgaXMgbm90IHNldAojIENPTkZJ
R19ISURfUFJPRElLRVlTIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0NNRURJQSBpcyBub3Qg
c2V0CiMgQ09ORklHX0hJRF9DUkVBVElWRV9TQjA1NDAgaXMgbm90IHNldAojIENPTkZJR19I
SURfQ1lQUkVTUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9EUkFHT05SSVNFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSElEX0VNU19GRiBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9FTEFOIGlz
IG5vdCBzZXQKIyBDT05GSUdfSElEX0VMRUNPTSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9F
TE8gaXMgbm90IHNldAojIENPTkZJR19ISURfRVZJU0lPTiBpcyBub3Qgc2V0CiMgQ09ORklH
X0hJRF9FWktFWSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9HRU1CSVJEIGlzIG5vdCBzZXQK
IyBDT05GSUdfSElEX0dGUk0gaXMgbm90IHNldAojIENPTkZJR19ISURfR0xPUklPVVMgaXMg
bm90IHNldAojIENPTkZJR19ISURfSE9MVEVLIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0dP
T0RJWF9TUEkgaXMgbm90IHNldAojIENPTkZJR19ISURfR09PR0xFX1NUQURJQV9GRiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hJRF9WSVZBTERJIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0dU
NjgzUiBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9LRVlUT1VDSCBpcyBub3Qgc2V0CiMgQ09O
RklHX0hJRF9LWUUgaXMgbm90IHNldAojIENPTkZJR19ISURfS1lTT05BIGlzIG5vdCBzZXQK
IyBDT05GSUdfSElEX1VDTE9HSUMgaXMgbm90IHNldAojIENPTkZJR19ISURfV0FMVE9QIGlz
IG5vdCBzZXQKIyBDT05GSUdfSElEX1ZJRVdTT05JQyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJ
RF9WUkMyIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1hJQU9NSSBpcyBub3Qgc2V0CiMgQ09O
RklHX0hJRF9HWVJBVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9JQ0FERSBpcyBub3Qg
c2V0CiMgQ09ORklHX0hJRF9JVEUgaXMgbm90IHNldAojIENPTkZJR19ISURfSkFCUkEgaXMg
bm90IHNldAojIENPTkZJR19ISURfVFdJTkhBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9L
RU5TSU5HVE9OIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0xDUE9XRVIgaXMgbm90IHNldAoj
IENPTkZJR19ISURfTEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0xFVFNLRVRDSCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hJRF9NQUdJQ01PVVNFIGlzIG5vdCBzZXQKIyBDT05GSUdfSElE
X01BTFRST04gaXMgbm90IHNldAojIENPTkZJR19ISURfTUFZRkxBU0ggaXMgbm90IHNldAoj
IENPTkZJR19ISURfTUVHQVdPUkxEX0ZGIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1JFRFJB
R09OIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX01JQ1JPU09GVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0hJRF9NT05URVJFWSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9NVUxUSVRPVUNIIGlz
IG5vdCBzZXQKIyBDT05GSUdfSElEX05JTlRFTkRPIGlzIG5vdCBzZXQKIyBDT05GSUdfSElE
X05USSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9OVFJJRyBpcyBub3Qgc2V0CiMgQ09ORklH
X0hJRF9PUlRFSyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9QQU5USEVSTE9SRCBpcyBub3Qg
c2V0CiMgQ09ORklHX0hJRF9QRU5NT1VOVCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9QRVRB
TFlOWCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9QSUNPTENEIGlzIG5vdCBzZXQKIyBDT05G
SUdfSElEX1BMQU5UUk9OSUNTIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1BYUkMgaXMgbm90
IHNldAojIENPTkZJR19ISURfUkFaRVIgaXMgbm90IHNldAojIENPTkZJR19ISURfUFJJTUFY
IGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1JFVFJPREUgaXMgbm90IHNldAojIENPTkZJR19I
SURfUk9DQ0FUIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1NBSVRFSyBpcyBub3Qgc2V0CiMg
Q09ORklHX0hJRF9TQU1TVU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1NFTUlURUsgaXMg
bm90IHNldAojIENPTkZJR19ISURfU0lHTUFNSUNSTyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJ
RF9TT05ZIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1NQRUVETElOSyBpcyBub3Qgc2V0CiMg
Q09ORklHX0hJRF9TVEVBTSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9TVEVFTFNFUklFUyBp
cyBub3Qgc2V0CiMgQ09ORklHX0hJRF9TVU5QTFVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSElE
X1JNSSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9HUkVFTkFTSUEgaXMgbm90IHNldAojIENP
TkZJR19ISURfU01BUlRKT1lQTFVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1RJVk8gaXMg
bm90IHNldAojIENPTkZJR19ISURfVE9QU0VFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9U
T1BSRSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9USElOR00gaXMgbm90IHNldAojIENPTkZJ
R19ISURfVEhSVVNUTUFTVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1VEUkFXX1BTMyBp
cyBub3Qgc2V0CiMgQ09ORklHX0hJRF9VMkZaRVJPIGlzIG5vdCBzZXQKIyBDT05GSUdfSElE
X1dBQ09NIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1dJSU1PVEUgaXMgbm90IHNldAojIENP
TkZJR19ISURfV0lOV0lORyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9YSU5NTyBpcyBub3Qg
c2V0CiMgQ09ORklHX0hJRF9aRVJPUExVUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9aWURB
Q1JPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9TRU5TT1JfSFVCIGlzIG5vdCBzZXQKIyBD
T05GSUdfSElEX0FMUFMgaXMgbm90IHNldAojIENPTkZJR19ISURfTUNQMjIwMCBpcyBub3Qg
c2V0CiMgQ09ORklHX0hJRF9NQ1AyMjIxIGlzIG5vdCBzZXQKIyBlbmQgb2YgU3BlY2lhbCBI
SUQgZHJpdmVycwoKIwojIEhJRC1CUEYgc3VwcG9ydAojCiMgZW5kIG9mIEhJRC1CUEYgc3Vw
cG9ydAoKQ09ORklHX0kyQ19ISUQ9eQojIENPTkZJR19JMkNfSElEX09GIGlzIG5vdCBzZXQK
IyBDT05GSUdfSTJDX0hJRF9PRl9FTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0hJRF9P
Rl9HT09ESVggaXMgbm90IHNldAoKIwojIFVTQiBISUQgc3VwcG9ydAojCkNPTkZJR19VU0Jf
SElEPXkKIyBDT05GSUdfSElEX1BJRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9ISURERVYg
aXMgbm90IHNldAojIGVuZCBvZiBVU0IgSElEIHN1cHBvcnQKCkNPTkZJR19VU0JfT0hDSV9M
SVRUTEVfRU5ESUFOPXkKQ09ORklHX1VTQl9TVVBQT1JUPXkKQ09ORklHX1VTQl9DT01NT049
eQojIENPTkZJR19VU0JfTEVEX1RSSUcgaXMgbm90IHNldAojIENPTkZJR19VU0JfVUxQSV9C
VVMgaXMgbm90IHNldAojIENPTkZJR19VU0JfQ09OTl9HUElPIGlzIG5vdCBzZXQKQ09ORklH
X1VTQl9BUkNIX0hBU19IQ0Q9eQpDT05GSUdfVVNCPXkKQ09ORklHX1VTQl9BTk5PVU5DRV9O
RVdfREVWSUNFUz15CgojCiMgTWlzY2VsbGFuZW91cyBVU0Igb3B0aW9ucwojCkNPTkZJR19V
U0JfREVGQVVMVF9QRVJTSVNUPXkKIyBDT05GSUdfVVNCX0ZFV19JTklUX1JFVFJJRVMgaXMg
bm90IHNldAojIENPTkZJR19VU0JfRFlOQU1JQ19NSU5PUlMgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfT1RHIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX09UR19QUk9EVUNUTElTVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9PVEdfRElTQUJMRV9FWFRFUk5BTF9IVUIgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfTEVEU19UUklHR0VSX1VTQlBPUlQgaXMgbm90IHNldApDT05GSUdf
VVNCX0FVVE9TVVNQRU5EX0RFTEFZPTIKQ09ORklHX1VTQl9ERUZBVUxUX0FVVEhPUklaQVRJ
T05fTU9ERT0xCiMgQ09ORklHX1VTQl9NT04gaXMgbm90IHNldAoKIwojIFVTQiBIb3N0IENv
bnRyb2xsZXIgRHJpdmVycwojCiMgQ09ORklHX1VTQl9DNjdYMDBfSENEIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX1hIQ0lfSENEIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9FSENJX0hDRD15
CiMgQ09ORklHX1VTQl9FSENJX1JPT1RfSFVCX1RUIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9F
SENJX1RUX05FV1NDSEVEPXkKIyBDT05GSUdfVVNCX0VIQ0lfRlNMIGlzIG5vdCBzZXQKQ09O
RklHX1VTQl9FSENJX0hDRF9BVDkxPXkKIyBDT05GSUdfVVNCX0VIQ0lfSENEX1BMQVRGT1JN
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX09YVTIxMEhQX0hDRCBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9JU1AxMTZYX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9NQVgzNDIxX0hD
RCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfT0hDSV9IQ0Q9eQpDT05GSUdfVVNCX09IQ0lfSENE
X0FUOTE9eQojIENPTkZJR19VU0JfT0hDSV9IQ0RfUExBVEZPUk0gaXMgbm90IHNldAojIENP
TkZJR19VU0JfU0w4MTFfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1I4QTY2NTk3X0hD
RCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9IQ0RfVEVTVF9NT0RFIGlzIG5vdCBzZXQKCiMK
IyBVU0IgRGV2aWNlIENsYXNzIGRyaXZlcnMKIwpDT05GSUdfVVNCX0FDTT15CiMgQ09ORklH
X1VTQl9QUklOVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1dETSBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9UTUMgaXMgbm90IHNldAoKIwojIE5PVEU6IFVTQl9TVE9SQUdFIGRlcGVu
ZHMgb24gU0NTSSBidXQgQkxLX0RFVl9TRCBtYXkgYWxzbyBiZSBuZWVkZWQ7IHNlZSBVU0Jf
U1RPUkFHRSBIZWxwIGZvciBtb3JlIGluZm8KIwpDT05GSUdfVVNCX1NUT1JBR0U9eQojIENP
TkZJR19VU0JfU1RPUkFHRV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdF
X1JFQUxURUsgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9EQVRBRkFCIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfRlJFRUNPTSBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9TVE9SQUdFX0lTRDIwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX1VT
QkFUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfU0REUjA5IGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX1NUT1JBR0VfU0REUjU1IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NU
T1JBR0VfSlVNUFNIT1QgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9BTEFVREEg
aXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9PTkVUT1VDSCBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9TVE9SQUdFX0tBUk1BIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JB
R0VfQ1lQUkVTU19BVEFDQiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0VORV9V
QjYyNTAgaXMgbm90IHNldAojIENPTkZJR19VU0JfVUFTIGlzIG5vdCBzZXQKCiMKIyBVU0Ig
SW1hZ2luZyBkZXZpY2VzCiMKIyBDT05GSUdfVVNCX01EQzgwMCBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9NSUNST1RFSyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQklQX0NPUkUgaXMgbm90
IHNldAoKIwojIFVTQiBkdWFsLW1vZGUgY29udHJvbGxlciBkcml2ZXJzCiMKIyBDT05GSUdf
VVNCX0NETlNfU1VQUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9NVVNCX0hEUkMgaXMg
bm90IHNldAojIENPTkZJR19VU0JfRFdDMyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9EV0My
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NISVBJREVBIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX0lTUDE3NjAgaXMgbm90IHNldAoKIwojIFVTQiBwb3J0IGRyaXZlcnMKIwpDT05GSUdf
VVNCX1NFUklBTD15CiMgQ09ORklHX1VTQl9TRVJJQUxfQ09OU09MRSBpcyBub3Qgc2V0CkNP
TkZJR19VU0JfU0VSSUFMX0dFTkVSSUM9eQojIENPTkZJR19VU0JfU0VSSUFMX1NJTVBMRSBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfQUlSQ0FCTEUgaXMgbm90IHNldAojIENP
TkZJR19VU0JfU0VSSUFMX0FSSzMxMTYgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFM
X0JFTEtJTiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfQ0gzNDEgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfU0VSSUFMX1dISVRFSEVBVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9TRVJJQUxfRElHSV9BQ0NFTEVQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklB
TF9DUDIxMFggaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0NZUFJFU1NfTTggaXMg
bm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0VNUEVHIGlzIG5vdCBzZXQKQ09ORklHX1VT
Ql9TRVJJQUxfRlRESV9TSU89eQojIENPTkZJR19VU0JfU0VSSUFMX1ZJU09SIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1NFUklBTF9JUEFRIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NF
UklBTF9JUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfRURHRVBPUlQgaXMgbm90
IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0VER0VQT1JUX1RJIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1NFUklBTF9GODEyMzIgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0Y4
MTUzWCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfR0FSTUlOIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX1NFUklBTF9JUFcgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFM
X0lVVSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTl9QREEgaXMgbm90
IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0tFWVNQQU4gaXMgbm90IHNldAojIENPTkZJR19V
U0JfU0VSSUFMX0tMU0kgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0tPQklMX1ND
VCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfTUNUX1UyMzIgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfU0VSSUFMX01FVFJPIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklB
TF9NT1M3NzIwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9NT1M3ODQwIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9NWFVQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX1NFUklBTF9OQVZNQU4gaXMgbm90IHNldApDT05GSUdfVVNCX1NFUklBTF9QTDIzMDM9
eQojIENPTkZJR19VU0JfU0VSSUFMX09USTY4NTggaXMgbm90IHNldAojIENPTkZJR19VU0Jf
U0VSSUFMX1FDQVVYIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9RVUFMQ09NTSBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfU1BDUDhYNSBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9TRVJJQUxfU0FGRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfU0lF
UlJBV0lSRUxFU1MgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX1NZTUJPTCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfVEkgaXMgbm90IHNldAojIENPTkZJR19VU0Jf
U0VSSUFMX0NZQkVSSkFDSyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfT1BUSU9O
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9PTU5JTkVUIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX1NFUklBTF9PUFRJQ09OIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklB
TF9YU0VOU19NVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfV0lTSEJPTkUgaXMg
bm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX1NTVTEwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9TRVJJQUxfUVQyIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9VUEQ3OEYw
NzMwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9YUiBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9TRVJJQUxfREVCVUcgaXMgbm90IHNldAoKIwojIFVTQiBNaXNjZWxsYW5lb3Vz
IGRyaXZlcnMKIwojIENPTkZJR19VU0JfRU1JNjIgaXMgbm90IHNldAojIENPTkZJR19VU0Jf
RU1JMjYgaXMgbm90IHNldAojIENPTkZJR19VU0JfQURVVFVYIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1NFVlNFRyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRUdPVE9XRVIgaXMgbm90
IHNldAojIENPTkZJR19VU0JfTENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NZUFJFU1Nf
Q1k3QzYzIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NZVEhFUk0gaXMgbm90IHNldAojIENP
TkZJR19VU0JfSURNT1VTRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9BUFBMRURJU1BMQVkg
aXMgbm90IHNldAojIENPTkZJR19BUFBMRV9NRklfRkFTVENIQVJHRSBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9TSVNVU0JWR0EgaXMgbm90IHNldAojIENPTkZJR19VU0JfTEQgaXMgbm90
IHNldAojIENPTkZJR19VU0JfVFJBTkNFVklCUkFUT1IgaXMgbm90IHNldAojIENPTkZJR19V
U0JfSU9XQVJSSU9SIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1RFU1QgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfRUhTRVRfVEVTVF9GSVhUVVJFIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X0lTSUdIVEZXIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1lVUkVYIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX0VaVVNCX0ZYMiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9IVUJfVVNCMjUx
WEIgaXMgbm90IHNldAojIENPTkZJR19VU0JfSFNJQ19VU0IzNTAzIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX0hTSUNfVVNCNDYwNCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MSU5LX0xB
WUVSX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19VU0JfQ0hBT1NLRVkgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfT05CT0FSRF9ERVYgaXMgbm90IHNldAoKIwojIFVTQiBQaHlzaWNhbCBM
YXllciBkcml2ZXJzCiMKIyBDT05GSUdfTk9QX1VTQl9YQ0VJViBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9HUElPX1ZCVVMgaXMgbm90IHNldAojIENPTkZJR19VU0JfSVNQMTMwMSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9VTFBJIGlzIG5vdCBzZXQKIyBlbmQgb2YgVVNCIFBoeXNp
Y2FsIExheWVyIGRyaXZlcnMKCkNPTkZJR19VU0JfR0FER0VUPXkKIyBDT05GSUdfVVNCX0dB
REdFVF9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HQURHRVRfREVCVUdfRklMRVMg
aXMgbm90IHNldAojIENPTkZJR19VU0JfR0FER0VUX0RFQlVHX0ZTIGlzIG5vdCBzZXQKQ09O
RklHX1VTQl9HQURHRVRfVkJVU19EUkFXPTIKQ09ORklHX1VTQl9HQURHRVRfU1RPUkFHRV9O
VU1fQlVGRkVSUz0yCiMgQ09ORklHX1VfU0VSSUFMX0NPTlNPTEUgaXMgbm90IHNldAoKIwoj
IFVTQiBQZXJpcGhlcmFsIENvbnRyb2xsZXIKIwojIENPTkZJR19VU0JfQVQ5MSBpcyBub3Qg
c2V0CkNPTkZJR19VU0JfQVRNRUxfVVNCQT15CiMgQ09ORklHX1VTQl9GVVNCMzAwIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX0dSX1VEQyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9SOEE2
NjU5NyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9QWEEyN1ggaXMgbm90IHNldAojIENPTkZJ
R19VU0JfTVZfVURDIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX01WX1UzRCBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9TTlBfVURDX1BMQVQgaXMgbm90IHNldAojIENPTkZJR19VU0JfTTY2
NTkyIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0JEQ19VREMgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfTkVUMjI3MiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HQURHRVRfWElMSU5YIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX01BWDM0MjBfVURDIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX0RVTU1ZX0hDRCBpcyBub3Qgc2V0CiMgZW5kIG9mIFVTQiBQZXJpcGhlcmFsIENvbnRy
b2xsZXIKCkNPTkZJR19VU0JfTElCQ09NUE9TSVRFPXkKQ09ORklHX1VTQl9GX0FDTT15CkNP
TkZJR19VU0JfVV9TRVJJQUw9eQpDT05GSUdfVVNCX0ZfU0VSSUFMPXkKQ09ORklHX1VTQl9G
X09CRVg9eQojIENPTkZJR19VU0JfQ09ORklHRlMgaXMgbm90IHNldAoKIwojIFVTQiBHYWRn
ZXQgcHJlY29tcG9zZWQgY29uZmlndXJhdGlvbnMKIwojIENPTkZJR19VU0JfWkVSTyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9BVURJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9FVEgg
aXMgbm90IHNldAojIENPTkZJR19VU0JfR19OQ00gaXMgbm90IHNldAojIENPTkZJR19VU0Jf
R0FER0VURlMgaXMgbm90IHNldAojIENPTkZJR19VU0JfRlVOQ1RJT05GUyBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9NQVNTX1NUT1JBR0UgaXMgbm90IHNldApDT05GSUdfVVNCX0dfU0VS
SUFMPXkKIyBDT05GSUdfVVNCX01JRElfR0FER0VUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X0dfUFJJTlRFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9DRENfQ09NUE9TSVRFIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX0dfQUNNX01TIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0df
TVVMVEkgaXMgbm90IHNldAojIENPTkZJR19VU0JfR19ISUQgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfR19EQkdQIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dfV0VCQ0FNIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1JBV19HQURHRVQgaXMgbm90IHNldAojIGVuZCBvZiBVU0IgR2Fk
Z2V0IHByZWNvbXBvc2VkIGNvbmZpZ3VyYXRpb25zCgojIENPTkZJR19UWVBFQyBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9ST0xFX1NXSVRDSCBpcyBub3Qgc2V0CkNPTkZJR19NTUM9eQpD
T05GSUdfUFdSU0VRX0VNTUM9eQojIENPTkZJR19QV1JTRVFfU0Q4Nzg3IGlzIG5vdCBzZXQK
Q09ORklHX1BXUlNFUV9TSU1QTEU9eQpDT05GSUdfTU1DX0JMT0NLPXkKQ09ORklHX01NQ19C
TE9DS19NSU5PUlM9OAojIENPTkZJR19TRElPX1VBUlQgaXMgbm90IHNldAojIENPTkZJR19N
TUNfVEVTVCBpcyBub3Qgc2V0CgojCiMgTU1DL1NEL1NESU8gSG9zdCBDb250cm9sbGVyIERy
aXZlcnMKIwojIENPTkZJR19NTUNfREVCVUcgaXMgbm90IHNldApDT05GSUdfTU1DX1NESENJ
PXkKQ09ORklHX01NQ19TREhDSV9QTFRGTT15CiMgQ09ORklHX01NQ19TREhDSV9PRl9BUkFT
QU4gaXMgbm90IHNldApDT05GSUdfTU1DX1NESENJX09GX0FUOTE9eQojIENPTkZJR19NTUNf
U0RIQ0lfT0ZfRFdDTVNIQyBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19TREhDSV9DQURFTkNF
IGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DX1NESENJX0ZfU0RIMzAgaXMgbm90IHNldAojIENP
TkZJR19NTUNfU0RIQ0lfTUlMQkVBVVQgaXMgbm90IHNldApDT05GSUdfTU1DX0FUTUVMTUNJ
PXkKIyBDT05GSUdfTU1DX1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19EVyBpcyBub3Qg
c2V0CiMgQ09ORklHX01NQ19WVUIzMDAgaXMgbm90IHNldAojIENPTkZJR19NTUNfVVNIQyBp
cyBub3Qgc2V0CiMgQ09ORklHX01NQ19VU0RISTZST0wwIGlzIG5vdCBzZXQKIyBDT05GSUdf
TU1DX0NRSENJIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DX0hTUSBpcyBub3Qgc2V0CiMgQ09O
RklHX01NQ19NVEsgaXMgbm90IHNldAojIENPTkZJR19NTUNfU0RIQ0lfWEVOT04gaXMgbm90
IHNldAojIENPTkZJR19TQ1NJX1VGU0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX01FTVNUSUNL
IGlzIG5vdCBzZXQKQ09ORklHX05FV19MRURTPXkKQ09ORklHX0xFRFNfQ0xBU1M9eQojIENP
TkZJR19MRURTX0NMQVNTX0ZMQVNIIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19DTEFTU19N
VUxUSUNPTE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19CUklHSFRORVNTX0hXX0NIQU5H
RUQgaXMgbm90IHNldAoKIwojIExFRCBkcml2ZXJzCiMKIyBDT05GSUdfTEVEU19BTjMwMjU5
QSBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfQVcyMDBYWCBpcyBub3Qgc2V0CiMgQ09ORklH
X0xFRFNfQVcyMDEzIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19CQ002MzI4IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTEVEU19CQ002MzU4IGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19DUjAw
MTQxMTQgaXMgbm90IHNldAojIENPTkZJR19MRURTX0VMMTUyMDMwMDAgaXMgbm90IHNldAoj
IENPTkZJR19MRURTX0xNMzUzMCBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfTE0zNTMyIGlz
IG5vdCBzZXQKIyBDT05GSUdfTEVEU19MTTM2NDIgaXMgbm90IHNldAojIENPTkZJR19MRURT
X0xNMzY5MlggaXMgbm90IHNldAojIENPTkZJR19MRURTX1BDQTk1MzIgaXMgbm90IHNldApD
T05GSUdfTEVEU19HUElPPXkKIyBDT05GSUdfTEVEU19MUDM5NDQgaXMgbm90IHNldAojIENP
TkZJR19MRURTX0xQMzk1MiBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfTFA4ODYwIGlzIG5v
dCBzZXQKIyBDT05GSUdfTEVEU19MUDg4NjQgaXMgbm90IHNldAojIENPTkZJR19MRURTX1BD
QTk1NVggaXMgbm90IHNldAojIENPTkZJR19MRURTX1BDQTk2M1ggaXMgbm90IHNldAojIENP
TkZJR19MRURTX1BDQTk5NVggaXMgbm90IHNldAojIENPTkZJR19MRURTX0RBQzEyNFMwODUg
aXMgbm90IHNldApDT05GSUdfTEVEU19QV009eQojIENPTkZJR19MRURTX1JFR1VMQVRPUiBp
cyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfQkQyNjA2TVZWIGlzIG5vdCBzZXQKIyBDT05GSUdf
TEVEU19CRDI4MDIgaXMgbm90IHNldAojIENPTkZJR19MRURTX0xUMzU5MyBpcyBub3Qgc2V0
CiMgQ09ORklHX0xFRFNfVENBNjUwNyBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfVExDNTkx
WFggaXMgbm90IHNldAojIENPTkZJR19MRURTX0xNMzU1eCBpcyBub3Qgc2V0CiMgQ09ORklH
X0xFRFNfSVMzMUZMMzE5WCBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfSVMzMUZMMzJYWCBp
cyBub3Qgc2V0CgojCiMgTEVEIGRyaXZlciBmb3IgYmxpbmsoMSkgVVNCIFJHQiBMRUQgaXMg
dW5kZXIgU3BlY2lhbCBISUQgZHJpdmVycyAoSElEX1RISU5HTSkKIwojIENPTkZJR19MRURT
X0JMSU5LTSBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfU1lTQ09OIGlzIG5vdCBzZXQKIyBD
T05GSUdfTEVEU19NTFhSRUcgaXMgbm90IHNldAojIENPTkZJR19MRURTX1VTRVIgaXMgbm90
IHNldAojIENPTkZJR19MRURTX1NQSV9CWVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19M
TTM2OTcgaXMgbm90IHNldAojIENPTkZJR19MRURTX1NUMTIwMiBpcyBub3Qgc2V0CgojCiMg
Rmxhc2ggYW5kIFRvcmNoIExFRCBkcml2ZXJzCiMKCiMKIyBSR0IgTEVEIGRyaXZlcnMKIwoK
IwojIExFRCBUcmlnZ2VycwojCkNPTkZJR19MRURTX1RSSUdHRVJTPXkKQ09ORklHX0xFRFNf
VFJJR0dFUl9USU1FUj15CiMgQ09ORklHX0xFRFNfVFJJR0dFUl9PTkVTSE9UIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTEVEU19UUklHR0VSX01URCBpcyBub3Qgc2V0CkNPTkZJR19MRURTX1RS
SUdHRVJfSEVBUlRCRUFUPXkKIyBDT05GSUdfTEVEU19UUklHR0VSX0JBQ0tMSUdIVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0xFRFNfVFJJR0dFUl9DUFUgaXMgbm90IHNldAojIENPTkZJR19M
RURTX1RSSUdHRVJfQUNUSVZJVFkgaXMgbm90IHNldApDT05GSUdfTEVEU19UUklHR0VSX0dQ
SU89eQojIENPTkZJR19MRURTX1RSSUdHRVJfREVGQVVMVF9PTiBpcyBub3Qgc2V0CgojCiMg
aXB0YWJsZXMgdHJpZ2dlciBpcyB1bmRlciBOZXRmaWx0ZXIgY29uZmlnIChMRUQgdGFyZ2V0
KQojCiMgQ09ORklHX0xFRFNfVFJJR0dFUl9UUkFOU0lFTlQgaXMgbm90IHNldAojIENPTkZJ
R19MRURTX1RSSUdHRVJfQ0FNRVJBIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19UUklHR0VS
X1BBTklDIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19UUklHR0VSX05FVERFViBpcyBub3Qg
c2V0CiMgQ09ORklHX0xFRFNfVFJJR0dFUl9QQVRURVJOIGlzIG5vdCBzZXQKIyBDT05GSUdf
TEVEU19UUklHR0VSX1RUWSBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfVFJJR0dFUl9JTlBV
VF9FVkVOVFMgaXMgbm90IHNldAoKIwojIFNpbWF0aWMgTEVEIGRyaXZlcnMKIwojIENPTkZJ
R19BQ0NFU1NJQklMSVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5GSU5JQkFORCBpcyBub3Qg
c2V0CkNPTkZJR19FREFDX0FUT01JQ19TQ1JVQj15CkNPTkZJR19FREFDX1NVUFBPUlQ9eQpD
T05GSUdfUlRDX0xJQj15CkNPTkZJR19SVENfQ0xBU1M9eQpDT05GSUdfUlRDX0hDVE9TWVM9
eQpDT05GSUdfUlRDX0hDVE9TWVNfREVWSUNFPSJydGMwIgpDT05GSUdfUlRDX1NZU1RPSEM9
eQpDT05GSUdfUlRDX1NZU1RPSENfREVWSUNFPSJydGMwIgojIENPTkZJR19SVENfREVCVUcg
aXMgbm90IHNldApDT05GSUdfUlRDX05WTUVNPXkKCiMKIyBSVEMgaW50ZXJmYWNlcwojCkNP
TkZJR19SVENfSU5URl9TWVNGUz15CkNPTkZJR19SVENfSU5URl9QUk9DPXkKQ09ORklHX1JU
Q19JTlRGX0RFVj15CiMgQ09ORklHX1JUQ19JTlRGX0RFVl9VSUVfRU1VTCBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfVEVTVCBpcyBub3Qgc2V0CgojCiMgSTJDIFJUQyBkcml2ZXJz
CiMKIyBDT05GSUdfUlRDX0RSVl9BQkI1WkVTMyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19E
UlZfQUJFT1o5IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9BQlg4MFggaXMgbm90IHNl
dAojIENPTkZJR19SVENfRFJWX0RTMTMwNyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZf
RFMxMzc0IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE2NzIgaXMgbm90IHNldAoj
IENPTkZJR19SVENfRFJWX0hZTTg1NjMgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX01B
WDY5MDAgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX01BWDMxMzM1IGlzIG5vdCBzZXQK
IyBDT05GSUdfUlRDX0RSVl9OQ1QzMDE4WSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZf
UlM1QzM3MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfSVNMMTIwOCBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfSVNMMTIwMjIgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJW
X0lTTDEyMDI2IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9YMTIwNSBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfUENGODUyMyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZf
UENGODUwNjMgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1BDRjg1MzYzIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUlRDX0RSVl9QQ0Y4NTYzIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RS
Vl9QQ0Y4NTgzIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NNDFUODAgaXMgbm90IHNl
dAojIENPTkZJR19SVENfRFJWX0JRMzJLIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9T
MzUzOTBBIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9GTTMxMzAgaXMgbm90IHNldAoj
IENPTkZJR19SVENfRFJWX1JYODAxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlg4
MTExIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9SWDg1ODEgaXMgbm90IHNldAojIENP
TkZJR19SVENfRFJWX1JYODAyNSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRU0zMDI3
IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9SVjMwMjggaXMgbm90IHNldAojIENPTkZJ
R19SVENfRFJWX1JWMzAzMiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlY4ODAzIGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9TRDI0MDVBTCBpcyBub3Qgc2V0CiMgQ09ORklH
X1JUQ19EUlZfU0QzMDc4IGlzIG5vdCBzZXQKCiMKIyBTUEkgUlRDIGRyaXZlcnMKIwojIENP
TkZJR19SVENfRFJWX000MVQ5MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTTQxVDk0
IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzEzMDIgaXMgbm90IHNldAojIENPTkZJ
R19SVENfRFJWX0RTMTMwNSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxMzQzIGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzEzNDcgaXMgbm90IHNldAojIENPTkZJR19S
VENfRFJWX0RTMTM5MCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTUFYNjkxNiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUjk3MDEgaXMgbm90IHNldAojIENPTkZJR19SVENf
RFJWX1JYNDU4MSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlM1QzM0OCBpcyBub3Qg
c2V0CiMgQ09ORklHX1JUQ19EUlZfTUFYNjkwMiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19E
UlZfUENGMjEyMyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTUNQNzk1IGlzIG5vdCBz
ZXQKQ09ORklHX1JUQ19JMkNfQU5EX1NQST15CgojCiMgU1BJIGFuZCBJMkMgUlRDIGRyaXZl
cnMKIwojIENPTkZJR19SVENfRFJWX0RTMzIzMiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19E
UlZfUENGMjEyNyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlYzMDI5QzIgaXMgbm90
IHNldAojIENPTkZJR19SVENfRFJWX1JYNjExMCBpcyBub3Qgc2V0CgojCiMgUGxhdGZvcm0g
UlRDIGRyaXZlcnMKIwojIENPTkZJR19SVENfRFJWX0NNT1MgaXMgbm90IHNldAojIENPTkZJ
R19SVENfRFJWX0RTMTI4NiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxNTExIGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE1NTMgaXMgbm90IHNldAojIENPTkZJR19S
VENfRFJWX0RTMTY4NV9GQU1JTFkgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTc0
MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMyNDA0IGlzIG5vdCBzZXQKIyBDT05G
SUdfUlRDX0RSVl9TVEsxN1RBOCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTTQ4VDg2
IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NNDhUMzUgaXMgbm90IHNldAojIENPTkZJ
R19SVENfRFJWX000OFQ1OSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTVNNNjI0MiBp
cyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlA1QzAxIGlzIG5vdCBzZXQKIyBDT05GSUdf
UlRDX0RSVl9aWU5RTVAgaXMgbm90IHNldAoKIwojIG9uLUNQVSBSVEMgZHJpdmVycwojCkNP
TkZJR19SVENfRFJWX0FUOTFSTTkyMDA9eQojIENPTkZJR19SVENfRFJWX0FUOTFTQU05IGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9DQURFTkNFIGlzIG5vdCBzZXQKIyBDT05GSUdf
UlRDX0RSVl9GVFJUQzAxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUjczMDEgaXMg
bm90IHNldAoKIwojIEhJRCBTZW5zb3IgUlRDIGRyaXZlcnMKIwojIENPTkZJR19SVENfRFJW
X0dPTERGSVNIIGlzIG5vdCBzZXQKQ09ORklHX0RNQURFVklDRVM9eQojIENPTkZJR19ETUFE
RVZJQ0VTX0RFQlVHIGlzIG5vdCBzZXQKCiMKIyBETUEgRGV2aWNlcwojCkNPTkZJR19ETUFf
RU5HSU5FPXkKQ09ORklHX0RNQV9WSVJUVUFMX0NIQU5ORUxTPXkKQ09ORklHX0RNQV9PRj15
CiMgQ09ORklHX0FMVEVSQV9NU0dETUEgaXMgbm90IHNldApDT05GSUdfQVRfSERNQUM9eQpD
T05GSUdfQVRfWERNQUM9eQojIENPTkZJR19EV19BWElfRE1BQyBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZTTF9FRE1BIGlzIG5vdCBzZXQKIyBDT05GSUdfRlNMX1FETUEgaXMgbm90IHNldAoj
IENPTkZJR19JTlRFTF9JRE1BNjQgaXMgbm90IHNldAojIENPTkZJR19OQlBGQVhJX0RNQSBp
cyBub3Qgc2V0CiMgQ09ORklHX1hJTElOWF9ETUEgaXMgbm90IHNldAojIENPTkZJR19YSUxJ
TlhfWERNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1hJTElOWF9aWU5RTVBfRFBETUEgaXMgbm90
IHNldAojIENPTkZJR19BTURfUURNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1FDT01fSElETUFf
TUdNVCBpcyBub3Qgc2V0CiMgQ09ORklHX1FDT01fSElETUEgaXMgbm90IHNldAojIENPTkZJ
R19EV19ETUFDIGlzIG5vdCBzZXQKIyBDT05GSUdfU0ZfUERNQSBpcyBub3Qgc2V0CgojCiMg
RE1BIENsaWVudHMKIwojIENPTkZJR19BU1lOQ19UWF9ETUEgaXMgbm90IHNldAojIENPTkZJ
R19ETUFURVNUIGlzIG5vdCBzZXQKCiMKIyBETUFCVUYgb3B0aW9ucwojCkNPTkZJR19TWU5D
X0ZJTEU9eQojIENPTkZJR19TV19TWU5DIGlzIG5vdCBzZXQKIyBDT05GSUdfVURNQUJVRiBp
cyBub3Qgc2V0CiMgQ09ORklHX0RNQUJVRl9NT1ZFX05PVElGWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0RNQUJVRl9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0RNQUJVRl9TRUxGVEVTVFMg
aXMgbm90IHNldAojIENPTkZJR19ETUFCVUZfSEVBUFMgaXMgbm90IHNldAojIENPTkZJR19E
TUFCVUZfU1lTRlNfU1RBVFMgaXMgbm90IHNldAojIGVuZCBvZiBETUFCVUYgb3B0aW9ucwoK
IyBDT05GSUdfVUlPIGlzIG5vdCBzZXQKIyBDT05GSUdfVkZJTyBpcyBub3Qgc2V0CiMgQ09O
RklHX1ZJUlRfRFJJVkVSUyBpcyBub3Qgc2V0CkNPTkZJR19WSVJUSU9fTUVOVT15CiMgQ09O
RklHX1ZJUlRJT19NTUlPIGlzIG5vdCBzZXQKIyBDT05GSUdfVkRQQSBpcyBub3Qgc2V0CkNP
TkZJR19WSE9TVF9NRU5VPXkKIyBDT05GSUdfVkhPU1RfTkVUIGlzIG5vdCBzZXQKIyBDT05G
SUdfVkhPU1RfQ1JPU1NfRU5ESUFOX0xFR0FDWSBpcyBub3Qgc2V0CgojCiMgTWljcm9zb2Z0
IEh5cGVyLVYgZ3Vlc3Qgc3VwcG9ydAojCiMgZW5kIG9mIE1pY3Jvc29mdCBIeXBlci1WIGd1
ZXN0IHN1cHBvcnQKCiMgQ09ORklHX0dSRVlCVVMgaXMgbm90IHNldAojIENPTkZJR19DT01F
REkgaXMgbm90IHNldApDT05GSUdfU1RBR0lORz15CiMgQ09ORklHX1JUTDg3MjNCUyBpcyBu
b3Qgc2V0CgojCiMgSUlPIHN0YWdpbmcgZHJpdmVycwojCgojCiMgQWNjZWxlcm9tZXRlcnMK
IwojIENPTkZJR19BRElTMTYyMDMgaXMgbm90IHNldAojIGVuZCBvZiBBY2NlbGVyb21ldGVy
cwoKIwojIEFuYWxvZyB0byBkaWdpdGFsIGNvbnZlcnRlcnMKIwojIENPTkZJR19BRDc4MTYg
aXMgbm90IHNldAojIGVuZCBvZiBBbmFsb2cgdG8gZGlnaXRhbCBjb252ZXJ0ZXJzCgojCiMg
QW5hbG9nIGRpZ2l0YWwgYmktZGlyZWN0aW9uIGNvbnZlcnRlcnMKIwojIENPTkZJR19BRFQ3
MzE2IGlzIG5vdCBzZXQKIyBlbmQgb2YgQW5hbG9nIGRpZ2l0YWwgYmktZGlyZWN0aW9uIGNv
bnZlcnRlcnMKCiMKIyBEaXJlY3QgRGlnaXRhbCBTeW50aGVzaXMKIwojIENPTkZJR19BRDk4
MzIgaXMgbm90IHNldAojIENPTkZJR19BRDk4MzQgaXMgbm90IHNldAojIGVuZCBvZiBEaXJl
Y3QgRGlnaXRhbCBTeW50aGVzaXMKCiMKIyBOZXR3b3JrIEFuYWx5emVyLCBJbXBlZGFuY2Ug
Q29udmVydGVycwojCiMgQ09ORklHX0FENTkzMyBpcyBub3Qgc2V0CiMgZW5kIG9mIE5ldHdv
cmsgQW5hbHl6ZXIsIEltcGVkYW5jZSBDb252ZXJ0ZXJzCiMgZW5kIG9mIElJTyBzdGFnaW5n
IGRyaXZlcnMKCkNPTkZJR19TVEFHSU5HX01FRElBPXkKIyBDT05GSUdfVklERU9fTUFYOTY3
MTIgaXMgbm90IHNldAoKIwojIFN0YXJGaXZlIG1lZGlhIHBsYXRmb3JtIGRyaXZlcnMKIwoj
IENPTkZJR19TVEFHSU5HX01FRElBX0RFUFJFQ0FURUQgaXMgbm90IHNldAojIENPTkZJR19Y
SUxfQVhJU19GSUZPIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJQiBpcyBub3Qgc2V0CiMgQ09O
RklHX0dPTERGSVNIIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hST01FX1BMQVRGT1JNUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX01FTExBTk9YX1BMQVRGT1JNIGlzIG5vdCBzZXQKQ09ORklHX0hB
VkVfQ0xLPXkKQ09ORklHX0hBVkVfQ0xLX1BSRVBBUkU9eQpDT05GSUdfQ09NTU9OX0NMSz15
CgojCiMgQ2xvY2sgZHJpdmVyIGZvciBBUk0gUmVmZXJlbmNlIGRlc2lnbnMKIwojIENPTkZJ
R19DTEtfSUNTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NMS19TUDgxMCBpcyBub3Qgc2V0CiMg
ZW5kIG9mIENsb2NrIGRyaXZlciBmb3IgQVJNIFJlZmVyZW5jZSBkZXNpZ25zCgojIENPTkZJ
R19MTUswNDgzMiBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTU1PTl9DTEtfTUFYOTQ4NSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NPTU1PTl9DTEtfU0k1MzQxIGlzIG5vdCBzZXQKIyBDT05GSUdf
Q09NTU9OX0NMS19TSTUzNTEgaXMgbm90IHNldAojIENPTkZJR19DT01NT05fQ0xLX1NJNTE0
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NTU9OX0NMS19TSTU0NCBpcyBub3Qgc2V0CiMgQ09O
RklHX0NPTU1PTl9DTEtfU0k1NzAgaXMgbm90IHNldAojIENPTkZJR19DT01NT05fQ0xLX0NE
Q0U3MDYgaXMgbm90IHNldAojIENPTkZJR19DT01NT05fQ0xLX0NEQ0U5MjUgaXMgbm90IHNl
dAojIENPTkZJR19DT01NT05fQ0xLX0NTMjAwMF9DUCBpcyBub3Qgc2V0CiMgQ09ORklHX0NP
TU1PTl9DTEtfQVhJX0NMS0dFTiBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTU1PTl9DTEtfUFdN
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NTU9OX0NMS19SUzlfUENJRSBpcyBub3Qgc2V0CiMg
Q09ORklHX0NPTU1PTl9DTEtfU0k1MjFYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTU1PTl9D
TEtfVkMzIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NTU9OX0NMS19WQzUgaXMgbm90IHNldAoj
IENPTkZJR19DT01NT05fQ0xLX1ZDNyBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTU1PTl9DTEtf
RklYRURfTU1JTyBpcyBub3Qgc2V0CiMgQ09ORklHX1hJTElOWF9WQ1UgaXMgbm90IHNldAoj
IENPTkZJR19DT01NT05fQ0xLX1hMTlhfQ0xLV1pSRCBpcyBub3Qgc2V0CiMgQ09ORklHX0hX
U1BJTkxPQ0sgaXMgbm90IHNldAoKIwojIENsb2NrIFNvdXJjZSBkcml2ZXJzCiMKQ09ORklH
X1RJTUVSX09GPXkKQ09ORklHX1RJTUVSX1BST0JFPXkKIyBDT05GSUdfQVJNX1RJTUVSX1NQ
ODA0IGlzIG5vdCBzZXQKQ09ORklHX0FUTUVMX1RDQl9DTEtTUkM9eQojIENPTkZJR19NSUNS
T0NISVBfUElUNjRCIGlzIG5vdCBzZXQKIyBlbmQgb2YgQ2xvY2sgU291cmNlIGRyaXZlcnMK
CiMgQ09ORklHX01BSUxCT1ggaXMgbm90IHNldAojIENPTkZJR19JT01NVV9TVVBQT1JUIGlz
IG5vdCBzZXQKCiMKIyBSZW1vdGVwcm9jIGRyaXZlcnMKIwojIENPTkZJR19SRU1PVEVQUk9D
IGlzIG5vdCBzZXQKIyBlbmQgb2YgUmVtb3RlcHJvYyBkcml2ZXJzCgojCiMgUnBtc2cgZHJp
dmVycwojCiMgQ09ORklHX1JQTVNHX1ZJUlRJTyBpcyBub3Qgc2V0CiMgZW5kIG9mIFJwbXNn
IGRyaXZlcnMKCiMgQ09ORklHX1NPVU5EV0lSRSBpcyBub3Qgc2V0CgojCiMgU09DIChTeXN0
ZW0gT24gQ2hpcCkgc3BlY2lmaWMgRHJpdmVycwojCgojCiMgQW1sb2dpYyBTb0MgZHJpdmVy
cwojCiMgZW5kIG9mIEFtbG9naWMgU29DIGRyaXZlcnMKCkNPTkZJR19BVDkxX1NPQ19JRD15
CiMgQ09ORklHX0FUOTFfU09DX1NGUiBpcyBub3Qgc2V0CgojCiMgQnJvYWRjb20gU29DIGRy
aXZlcnMKIwojIGVuZCBvZiBCcm9hZGNvbSBTb0MgZHJpdmVycwoKIwojIE5YUC9GcmVlc2Nh
bGUgUW9ySVEgU29DIGRyaXZlcnMKIwojIENPTkZJR19RVUlDQ19FTkdJTkUgaXMgbm90IHNl
dAojIENPTkZJR19GU0xfUkNQTSBpcyBub3Qgc2V0CiMgZW5kIG9mIE5YUC9GcmVlc2NhbGUg
UW9ySVEgU29DIGRyaXZlcnMKCiMKIyBmdWppdHN1IFNvQyBkcml2ZXJzCiMKIyBlbmQgb2Yg
ZnVqaXRzdSBTb0MgZHJpdmVycwoKIwojIGkuTVggU29DIGRyaXZlcnMKIwojIGVuZCBvZiBp
Lk1YIFNvQyBkcml2ZXJzCgojCiMgRW5hYmxlIExpdGVYIFNvQyBCdWlsZGVyIHNwZWNpZmlj
IGRyaXZlcnMKIwojIENPTkZJR19MSVRFWF9TT0NfQ09OVFJPTExFUiBpcyBub3Qgc2V0CiMg
ZW5kIG9mIEVuYWJsZSBMaXRlWCBTb0MgQnVpbGRlciBzcGVjaWZpYyBkcml2ZXJzCgojIENP
TkZJR19XUENNNDUwX1NPQyBpcyBub3Qgc2V0CgojCiMgUXVhbGNvbW0gU29DIGRyaXZlcnMK
IwojIGVuZCBvZiBRdWFsY29tbSBTb0MgZHJpdmVycwoKIyBDT05GSUdfU09DX1RJIGlzIG5v
dCBzZXQKCiMKIyBYaWxpbnggU29DIGRyaXZlcnMKIwojIGVuZCBvZiBYaWxpbnggU29DIGRy
aXZlcnMKIyBlbmQgb2YgU09DIChTeXN0ZW0gT24gQ2hpcCkgc3BlY2lmaWMgRHJpdmVycwoK
IwojIFBNIERvbWFpbnMKIwoKIwojIEFtbG9naWMgUE0gRG9tYWlucwojCiMgZW5kIG9mIEFt
bG9naWMgUE0gRG9tYWlucwoKIwojIEJyb2FkY29tIFBNIERvbWFpbnMKIwojIGVuZCBvZiBC
cm9hZGNvbSBQTSBEb21haW5zCgojCiMgaS5NWCBQTSBEb21haW5zCiMKIyBlbmQgb2YgaS5N
WCBQTSBEb21haW5zCgojCiMgUXVhbGNvbW0gUE0gRG9tYWlucwojCiMgZW5kIG9mIFF1YWxj
b21tIFBNIERvbWFpbnMKIyBlbmQgb2YgUE0gRG9tYWlucwoKIyBDT05GSUdfUE1fREVWRlJF
USBpcyBub3Qgc2V0CiMgQ09ORklHX0VYVENPTiBpcyBub3Qgc2V0CkNPTkZJR19NRU1PUlk9
eQpDT05GSUdfQVRNRUxfRUJJPXkKQ09ORklHX0lJTz15CkNPTkZJR19JSU9fQlVGRkVSPXkK
Q09ORklHX0lJT19CVUZGRVJfQ0I9eQojIENPTkZJR19JSU9fQlVGRkVSX0RNQSBpcyBub3Qg
c2V0CiMgQ09ORklHX0lJT19CVUZGRVJfRE1BRU5HSU5FIGlzIG5vdCBzZXQKIyBDT05GSUdf
SUlPX0JVRkZFUl9IV19DT05TVU1FUiBpcyBub3Qgc2V0CkNPTkZJR19JSU9fS0ZJRk9fQlVG
PXkKQ09ORklHX0lJT19UUklHR0VSRURfQlVGRkVSPXkKIyBDT05GSUdfSUlPX0NPTkZJR0ZT
IGlzIG5vdCBzZXQKQ09ORklHX0lJT19UUklHR0VSPXkKQ09ORklHX0lJT19DT05TVU1FUlNf
UEVSX1RSSUdHRVI9MgojIENPTkZJR19JSU9fU1dfREVWSUNFIGlzIG5vdCBzZXQKIyBDT05G
SUdfSUlPX1NXX1RSSUdHRVIgaXMgbm90IHNldAojIENPTkZJR19JSU9fVFJJR0dFUkVEX0VW
RU5UIGlzIG5vdCBzZXQKCiMKIyBBY2NlbGVyb21ldGVycwojCiMgQ09ORklHX0FESVMxNjIw
MSBpcyBub3Qgc2V0CiMgQ09ORklHX0FESVMxNjIwOSBpcyBub3Qgc2V0CiMgQ09ORklHX0FE
WEwzMTNfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfQURYTDMxM19TUEkgaXMgbm90IHNldAoj
IENPTkZJR19BRFhMMzQ1X0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX0FEWEwzNDVfU1BJIGlz
IG5vdCBzZXQKIyBDT05GSUdfQURYTDM1NV9JMkMgaXMgbm90IHNldAojIENPTkZJR19BRFhM
MzU1X1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX0FEWEwzNjdfU1BJIGlzIG5vdCBzZXQKIyBD
T05GSUdfQURYTDM2N19JMkMgaXMgbm90IHNldAojIENPTkZJR19BRFhMMzcyX1NQSSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FEWEwzNzJfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfQURYTDM4
MF9TUEkgaXMgbm90IHNldAojIENPTkZJR19BRFhMMzgwX0kyQyBpcyBub3Qgc2V0CiMgQ09O
RklHX0JNQTE4MCBpcyBub3Qgc2V0CiMgQ09ORklHX0JNQTIyMCBpcyBub3Qgc2V0CiMgQ09O
RklHX0JNQTQwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0JNQzE1MF9BQ0NFTCBpcyBub3Qgc2V0
CiMgQ09ORklHX0JNSTA4OF9BQ0NFTCBpcyBub3Qgc2V0CiMgQ09ORklHX0RBMjgwIGlzIG5v
dCBzZXQKIyBDT05GSUdfREEzMTEgaXMgbm90IHNldAojIENPTkZJR19ETUFSRDA2IGlzIG5v
dCBzZXQKIyBDT05GSUdfRE1BUkQwOSBpcyBub3Qgc2V0CiMgQ09ORklHX0RNQVJEMTAgaXMg
bm90IHNldAojIENPTkZJR19GWExTODk2MkFGX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZY
TFM4OTYyQUZfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfSUlPX1NUX0FDQ0VMXzNBWElTIGlz
IG5vdCBzZXQKIyBDT05GSUdfSUlPX0tYMDIyQV9TUEkgaXMgbm90IHNldAojIENPTkZJR19J
SU9fS1gwMjJBX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX0tYU0Q5IGlzIG5vdCBzZXQKIyBD
T05GSUdfS1hDSksxMDEzIGlzIG5vdCBzZXQKIyBDT05GSUdfTUMzMjMwIGlzIG5vdCBzZXQK
IyBDT05GSUdfTU1BNzQ1NV9JMkMgaXMgbm90IHNldAojIENPTkZJR19NTUE3NDU1X1NQSSBp
cyBub3Qgc2V0CiMgQ09ORklHX01NQTc2NjAgaXMgbm90IHNldAojIENPTkZJR19NTUE4NDUy
IGlzIG5vdCBzZXQKIyBDT05GSUdfTU1BOTU1MSBpcyBub3Qgc2V0CiMgQ09ORklHX01NQTk1
NTMgaXMgbm90IHNldAojIENPTkZJR19NU0EzMTEgaXMgbm90IHNldAojIENPTkZJR19NWEM0
MDA1IGlzIG5vdCBzZXQKIyBDT05GSUdfTVhDNjI1NSBpcyBub3Qgc2V0CiMgQ09ORklHX1ND
QTMwMDAgaXMgbm90IHNldAojIENPTkZJR19TQ0EzMzAwIGlzIG5vdCBzZXQKIyBDT05GSUdf
U1RLODMxMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NUSzhCQTUwIGlzIG5vdCBzZXQKIyBlbmQg
b2YgQWNjZWxlcm9tZXRlcnMKCiMKIyBBbmFsb2cgdG8gZGlnaXRhbCBjb252ZXJ0ZXJzCiMK
IyBDT05GSUdfQUQ0MDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQUQ0MDMwIGlzIG5vdCBzZXQK
IyBDT05GSUdfQUQ0MTMwIGlzIG5vdCBzZXQKIyBDT05GSUdfQUQ0Njk1IGlzIG5vdCBzZXQK
IyBDT05GSUdfQUQ0ODUxIGlzIG5vdCBzZXQKIyBDT05GSUdfQUQ3MDkxUjUgaXMgbm90IHNl
dAojIENPTkZJR19BRDcwOTFSOCBpcyBub3Qgc2V0CiMgQ09ORklHX0FENzEyNCBpcyBub3Qg
c2V0CiMgQ09ORklHX0FENzE3MyBpcyBub3Qgc2V0CiMgQ09ORklHX0FENzE5MSBpcyBub3Qg
c2V0CiMgQ09ORklHX0FENzE5MiBpcyBub3Qgc2V0CiMgQ09ORklHX0FENzI2NiBpcyBub3Qg
c2V0CiMgQ09ORklHX0FENzI4MCBpcyBub3Qgc2V0CiMgQ09ORklHX0FENzI5MSBpcyBub3Qg
c2V0CiMgQ09ORklHX0FENzI5MiBpcyBub3Qgc2V0CiMgQ09ORklHX0FENzI5OCBpcyBub3Qg
c2V0CiMgQ09ORklHX0FENzM4MCBpcyBub3Qgc2V0CiMgQ09ORklHX0FENzQ3NiBpcyBub3Qg
c2V0CiMgQ09ORklHX0FENzYwNl9JRkFDRV9QQVJBTExFTCBpcyBub3Qgc2V0CiMgQ09ORklH
X0FENzYwNl9JRkFDRV9TUEkgaXMgbm90IHNldAojIENPTkZJR19BRDc2MjUgaXMgbm90IHNl
dAojIENPTkZJR19BRDc3NjYgaXMgbm90IHNldAojIENPTkZJR19BRDc3NjhfMSBpcyBub3Qg
c2V0CiMgQ09ORklHX0FENzc3OSBpcyBub3Qgc2V0CiMgQ09ORklHX0FENzc4MCBpcyBub3Qg
c2V0CiMgQ09ORklHX0FENzc5MSBpcyBub3Qgc2V0CiMgQ09ORklHX0FENzc5MyBpcyBub3Qg
c2V0CiMgQ09ORklHX0FENzg4NyBpcyBub3Qgc2V0CiMgQ09ORklHX0FENzkyMyBpcyBub3Qg
c2V0CiMgQ09ORklHX0FENzk0NCBpcyBub3Qgc2V0CiMgQ09ORklHX0FENzk0OSBpcyBub3Qg
c2V0CiMgQ09ORklHX0FENzk5WCBpcyBub3Qgc2V0CiMgQ09ORklHX0FEOTQ2NyBpcyBub3Qg
c2V0CkNPTkZJR19BVDkxX0FEQz15CkNPTkZJR19BVDkxX1NBTUE1RDJfQURDPXkKIyBDT05G
SUdfQ0MxMDAwMV9BREMgaXMgbm90IHNldApDT05GSUdfRU5WRUxPUEVfREVURUNUT1I9bQoj
IENPTkZJR19HRUhDX1BNQ19BREMgaXMgbm90IHNldAojIENPTkZJR19ISTg0MzUgaXMgbm90
IHNldAojIENPTkZJR19IWDcxMSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOQTJYWF9BREMgaXMg
bm90IHNldAojIENPTkZJR19MVEMyMzA5IGlzIG5vdCBzZXQKIyBDT05GSUdfTFRDMjQ3MSBp
cyBub3Qgc2V0CiMgQ09ORklHX0xUQzI0ODUgaXMgbm90IHNldAojIENPTkZJR19MVEMyNDk2
IGlzIG5vdCBzZXQKIyBDT05GSUdfTFRDMjQ5NyBpcyBub3Qgc2V0CiMgQ09ORklHX01BWDEw
MjcgaXMgbm90IHNldAojIENPTkZJR19NQVgxMTEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX01B
WDExMTggaXMgbm90IHNldAojIENPTkZJR19NQVgxMTIwNSBpcyBub3Qgc2V0CiMgQ09ORklH
X01BWDExNDEwIGlzIG5vdCBzZXQKIyBDT05GSUdfTUFYMTI0MSBpcyBub3Qgc2V0CiMgQ09O
RklHX01BWDEzNjMgaXMgbm90IHNldAojIENPTkZJR19NQVgzNDQwOCBpcyBub3Qgc2V0CiMg
Q09ORklHX01BWDk2MTEgaXMgbm90IHNldAojIENPTkZJR19NQ1AzMjBYIGlzIG5vdCBzZXQK
IyBDT05GSUdfTUNQMzQyMiBpcyBub3Qgc2V0CiMgQ09ORklHX01DUDM1NjQgaXMgbm90IHNl
dAojIENPTkZJR19NQ1AzOTExIGlzIG5vdCBzZXQKIyBDT05GSUdfTkFVNzgwMiBpcyBub3Qg
c2V0CiMgQ09ORklHX1BBQzE5MjEgaXMgbm90IHNldApDT05GSUdfUEFDMTkzND1tCiMgQ09O
RklHX1JJQ0hURUtfUlRRNjA1NiBpcyBub3Qgc2V0CiMgQ09ORklHX1NEX0FEQ19NT0RVTEFU
T1IgaXMgbm90IHNldAojIENPTkZJR19USV9BREMwODFDIGlzIG5vdCBzZXQKIyBDT05GSUdf
VElfQURDMDgzMiBpcyBub3Qgc2V0CiMgQ09ORklHX1RJX0FEQzA4NFMwMjEgaXMgbm90IHNl
dAojIENPTkZJR19USV9BREMxMjEzOCBpcyBub3Qgc2V0CiMgQ09ORklHX1RJX0FEQzEwOFMx
MDIgaXMgbm90IHNldAojIENPTkZJR19USV9BREMxMjhTMDUyIGlzIG5vdCBzZXQKIyBDT05G
SUdfVElfQURDMTYxUzYyNiBpcyBub3Qgc2V0CiMgQ09ORklHX1RJX0FEUzEwMTUgaXMgbm90
IHNldAojIENPTkZJR19USV9BRFMxMTE5IGlzIG5vdCBzZXQKIyBDT05GSUdfVElfQURTNzEz
OCBpcyBub3Qgc2V0CiMgQ09ORklHX1RJX0FEUzc5MjQgaXMgbm90IHNldAojIENPTkZJR19U
SV9BRFMxMTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVElfQURTMTI5OCBpcyBub3Qgc2V0CiMg
Q09ORklHX1RJX0FEUzc5NTAgaXMgbm90IHNldAojIENPTkZJR19USV9BRFM4MzQ0IGlzIG5v
dCBzZXQKIyBDT05GSUdfVElfQURTODY4OCBpcyBub3Qgc2V0CiMgQ09ORklHX1RJX0FEUzEy
NFMwOCBpcyBub3Qgc2V0CiMgQ09ORklHX1RJX0FEUzEzMUUwOCBpcyBub3Qgc2V0CiMgQ09O
RklHX1RJX0xNUDkyMDY0IGlzIG5vdCBzZXQKIyBDT05GSUdfVElfVExDNDU0MSBpcyBub3Qg
c2V0CiMgQ09ORklHX1RJX1RTQzIwNDYgaXMgbm90IHNldAojIENPTkZJR19WRjYxMF9BREMg
aXMgbm90IHNldAojIENPTkZJR19YSUxJTlhfWEFEQyBpcyBub3Qgc2V0CiMgZW5kIG9mIEFu
YWxvZyB0byBkaWdpdGFsIGNvbnZlcnRlcnMKCiMKIyBBbmFsb2cgdG8gZGlnaXRhbCBhbmQg
ZGlnaXRhbCB0byBhbmFsb2cgY29udmVydGVycwojCiMgQ09ORklHX0FENzQxMTUgaXMgbm90
IHNldAojIENPTkZJR19BRDc0NDEzUiBpcyBub3Qgc2V0CiMgZW5kIG9mIEFuYWxvZyB0byBk
aWdpdGFsIGFuZCBkaWdpdGFsIHRvIGFuYWxvZyBjb252ZXJ0ZXJzCgojCiMgQW5hbG9nIEZy
b250IEVuZHMKIwojIENPTkZJR19JSU9fUkVTQ0FMRSBpcyBub3Qgc2V0CiMgZW5kIG9mIEFu
YWxvZyBGcm9udCBFbmRzCgojCiMgQW1wbGlmaWVycwojCiMgQ09ORklHX0FEODM2NiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FEQTQyNTAgaXMgbm90IHNldAojIENPTkZJR19ITUM0MjUgaXMg
bm90IHNldAojIGVuZCBvZiBBbXBsaWZpZXJzCgojCiMgQ2FwYWNpdGFuY2UgdG8gZGlnaXRh
bCBjb252ZXJ0ZXJzCiMKIyBDT05GSUdfQUQ3MTUwIGlzIG5vdCBzZXQKIyBDT05GSUdfQUQ3
NzQ2IGlzIG5vdCBzZXQKIyBlbmQgb2YgQ2FwYWNpdGFuY2UgdG8gZGlnaXRhbCBjb252ZXJ0
ZXJzCgojCiMgQ2hlbWljYWwgU2Vuc29ycwojCiMgQ09ORklHX0FPU09OR19BR1MwMk1BIGlz
IG5vdCBzZXQKIyBDT05GSUdfQVRMQVNfUEhfU0VOU09SIGlzIG5vdCBzZXQKIyBDT05GSUdf
QVRMQVNfRVpPX1NFTlNPUiBpcyBub3Qgc2V0CiMgQ09ORklHX0JNRTY4MCBpcyBub3Qgc2V0
CiMgQ09ORklHX0NDUzgxMSBpcyBub3Qgc2V0CiMgQ09ORklHX0VOUzE2MCBpcyBub3Qgc2V0
CiMgQ09ORklHX0lBUUNPUkUgaXMgbm90IHNldAojIENPTkZJR19TQ0QzMF9DT1JFIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0NENFggaXMgbm90IHNldAojIENPTkZJR19TRU5TSVJJT05fU0dQ
MzAgaXMgbm90IHNldAojIENPTkZJR19TRU5TSVJJT05fU0dQNDAgaXMgbm90IHNldAojIENP
TkZJR19TUFMzMF9JMkMgaXMgbm90IHNldAojIENPTkZJR19TRU5TRUFJUl9TVU5SSVNFX0NP
MiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZaODlYIGlzIG5vdCBzZXQKIyBlbmQgb2YgQ2hlbWlj
YWwgU2Vuc29ycwoKIwojIEhpZCBTZW5zb3IgSUlPIENvbW1vbgojCiMgZW5kIG9mIEhpZCBT
ZW5zb3IgSUlPIENvbW1vbgoKIwojIElJTyBTQ01JIFNlbnNvcnMKIwojIGVuZCBvZiBJSU8g
U0NNSSBTZW5zb3JzCgojCiMgU1NQIFNlbnNvciBDb21tb24KIwojIENPTkZJR19JSU9fU1NQ
X1NFTlNPUkhVQiBpcyBub3Qgc2V0CiMgZW5kIG9mIFNTUCBTZW5zb3IgQ29tbW9uCgojCiMg
RGlnaXRhbCB0byBhbmFsb2cgY29udmVydGVycwojCiMgQ09ORklHX0FEMzU1MlJfSFMgaXMg
bm90IHNldAojIENPTkZJR19BRDM1NTJSIGlzIG5vdCBzZXQKIyBDT05GSUdfQUQ1MDY0IGlz
IG5vdCBzZXQKIyBDT05GSUdfQUQ1MzYwIGlzIG5vdCBzZXQKIyBDT05GSUdfQUQ1MzgwIGlz
IG5vdCBzZXQKIyBDT05GSUdfQUQ1NDIxIGlzIG5vdCBzZXQKIyBDT05GSUdfQUQ1NDQ2IGlz
IG5vdCBzZXQKIyBDT05GSUdfQUQ1NDQ5IGlzIG5vdCBzZXQKIyBDT05GSUdfQUQ1NTkyUiBp
cyBub3Qgc2V0CiMgQ09ORklHX0FENTU5M1IgaXMgbm90IHNldAojIENPTkZJR19BRDU1MDQg
aXMgbm90IHNldAojIENPTkZJR19BRDU2MjRSX1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX0FE
OTczOUEgaXMgbm90IHNldAojIENPTkZJR19MVEMyNjg4IGlzIG5vdCBzZXQKIyBDT05GSUdf
QUQ1Njg2X1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX0FENTY5Nl9JMkMgaXMgbm90IHNldAoj
IENPTkZJR19BRDU3NTUgaXMgbm90IHNldAojIENPTkZJR19BRDU3NTggaXMgbm90IHNldAoj
IENPTkZJR19BRDU3NjEgaXMgbm90IHNldAojIENPTkZJR19BRDU3NjQgaXMgbm90IHNldAoj
IENPTkZJR19BRDU3NjYgaXMgbm90IHNldAojIENPTkZJR19BRDU3NzBSIGlzIG5vdCBzZXQK
IyBDT05GSUdfQUQ1NzkxIGlzIG5vdCBzZXQKIyBDT05GSUdfQUQ3MjkzIGlzIG5vdCBzZXQK
IyBDT05GSUdfQUQ3MzAzIGlzIG5vdCBzZXQKIyBDT05GSUdfQUQ4NDYwIGlzIG5vdCBzZXQK
IyBDT05GSUdfQUQ4ODAxIGlzIG5vdCBzZXQKIyBDT05GSUdfQkQ3OTcwMyBpcyBub3Qgc2V0
CkNPTkZJR19EUE9UX0RBQz1tCiMgQ09ORklHX0RTNDQyNCBpcyBub3Qgc2V0CiMgQ09ORklH
X0xUQzE2NjAgaXMgbm90IHNldAojIENPTkZJR19MVEMyNjMyIGlzIG5vdCBzZXQKIyBDT05G
SUdfTFRDMjY2NCBpcyBub3Qgc2V0CiMgQ09ORklHX002MjMzMiBpcyBub3Qgc2V0CiMgQ09O
RklHX01BWDUxNyBpcyBub3Qgc2V0CiMgQ09ORklHX01BWDU1MjIgaXMgbm90IHNldAojIENP
TkZJR19NQVg1ODIxIGlzIG5vdCBzZXQKIyBDT05GSUdfTUNQNDcyNSBpcyBub3Qgc2V0CiMg
Q09ORklHX01DUDQ3MjggaXMgbm90IHNldAojIENPTkZJR19NQ1A0ODIxIGlzIG5vdCBzZXQK
IyBDT05GSUdfTUNQNDkyMiBpcyBub3Qgc2V0CiMgQ09ORklHX1RJX0RBQzA4MlMwODUgaXMg
bm90IHNldAojIENPTkZJR19USV9EQUM1NTcxIGlzIG5vdCBzZXQKIyBDT05GSUdfVElfREFD
NzMxMSBpcyBub3Qgc2V0CiMgQ09ORklHX1RJX0RBQzc2MTIgaXMgbm90IHNldAojIENPTkZJ
R19WRjYxMF9EQUMgaXMgbm90IHNldAojIGVuZCBvZiBEaWdpdGFsIHRvIGFuYWxvZyBjb252
ZXJ0ZXJzCgojCiMgSUlPIGR1bW15IGRyaXZlcgojCiMgZW5kIG9mIElJTyBkdW1teSBkcml2
ZXIKCiMKIyBGaWx0ZXJzCiMKIyBlbmQgb2YgRmlsdGVycwoKIwojIEZyZXF1ZW5jeSBTeW50
aGVzaXplcnMgRERTL1BMTAojCgojCiMgQ2xvY2sgR2VuZXJhdG9yL0Rpc3RyaWJ1dGlvbgoj
CiMgQ09ORklHX0FEOTUyMyBpcyBub3Qgc2V0CiMgZW5kIG9mIENsb2NrIEdlbmVyYXRvci9E
aXN0cmlidXRpb24KCiMKIyBQaGFzZS1Mb2NrZWQgTG9vcCAoUExMKSBmcmVxdWVuY3kgc3lu
dGhlc2l6ZXJzCiMKIyBDT05GSUdfQURGNDM1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0FERjQz
NzEgaXMgbm90IHNldAojIENPTkZJR19BREY0Mzc3IGlzIG5vdCBzZXQKIyBDT05GSUdfQURN
Rk0yMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQURNVjEwMTMgaXMgbm90IHNldAojIENPTkZJ
R19BRE1WNDQyMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FEUkY2NzgwIGlzIG5vdCBzZXQKIyBl
bmQgb2YgUGhhc2UtTG9ja2VkIExvb3AgKFBMTCkgZnJlcXVlbmN5IHN5bnRoZXNpemVycwoj
IGVuZCBvZiBGcmVxdWVuY3kgU3ludGhlc2l6ZXJzIEREUy9QTEwKCiMKIyBEaWdpdGFsIGd5
cm9zY29wZSBzZW5zb3JzCiMKIyBDT05GSUdfQURJUzE2MDgwIGlzIG5vdCBzZXQKIyBDT05G
SUdfQURJUzE2MTMwIGlzIG5vdCBzZXQKIyBDT05GSUdfQURJUzE2MTM2IGlzIG5vdCBzZXQK
IyBDT05GSUdfQURJUzE2MjYwIGlzIG5vdCBzZXQKIyBDT05GSUdfQURYUlMyOTAgaXMgbm90
IHNldAojIENPTkZJR19BRFhSUzQ1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0JNRzE2MCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0ZYQVMyMTAwMkMgaXMgbm90IHNldAojIENPTkZJR19NUFUzMDUw
X0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX0lJT19TVF9HWVJPXzNBWElTIGlzIG5vdCBzZXQK
IyBDT05GSUdfSVRHMzIwMCBpcyBub3Qgc2V0CiMgZW5kIG9mIERpZ2l0YWwgZ3lyb3Njb3Bl
IHNlbnNvcnMKCiMKIyBIZWFsdGggU2Vuc29ycwojCgojCiMgSGVhcnQgUmF0ZSBNb25pdG9y
cwojCiMgQ09ORklHX0FGRTQ0MDMgaXMgbm90IHNldAojIENPTkZJR19BRkU0NDA0IGlzIG5v
dCBzZXQKIyBDT05GSUdfTUFYMzAxMDAgaXMgbm90IHNldAojIENPTkZJR19NQVgzMDEwMiBp
cyBub3Qgc2V0CiMgZW5kIG9mIEhlYXJ0IFJhdGUgTW9uaXRvcnMKIyBlbmQgb2YgSGVhbHRo
IFNlbnNvcnMKCiMKIyBIdW1pZGl0eSBzZW5zb3JzCiMKIyBDT05GSUdfQU0yMzE1IGlzIG5v
dCBzZXQKIyBDT05GSUdfREhUMTEgaXMgbm90IHNldAojIENPTkZJR19FTlMyMTAgaXMgbm90
IHNldAojIENPTkZJR19IREMxMDBYIGlzIG5vdCBzZXQKIyBDT05GSUdfSERDMjAxMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hEQzMwMjAgaXMgbm90IHNldAojIENPTkZJR19IVFMyMjEgaXMg
bm90IHNldAojIENPTkZJR19IVFUyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NJNzAwNSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NJNzAyMCBpcyBub3Qgc2V0CiMgZW5kIG9mIEh1bWlkaXR5IHNl
bnNvcnMKCiMKIyBJbmVydGlhbCBtZWFzdXJlbWVudCB1bml0cwojCiMgQ09ORklHX0FESVMx
NjQwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FESVMxNjQ2MCBpcyBub3Qgc2V0CiMgQ09ORklH
X0FESVMxNjQ3NSBpcyBub3Qgc2V0CiMgQ09ORklHX0FESVMxNjQ4MCBpcyBub3Qgc2V0CiMg
Q09ORklHX0FESVMxNjU1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0JNSTE2MF9JMkMgaXMgbm90
IHNldAojIENPTkZJR19CTUkxNjBfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfQk1JMjcwX0ky
QyBpcyBub3Qgc2V0CiMgQ09ORklHX0JNSTI3MF9TUEkgaXMgbm90IHNldAojIENPTkZJR19C
TUkzMjNfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfQk1JMzIzX1NQSSBpcyBub3Qgc2V0CiMg
Q09ORklHX0JPU0NIX0JOTzA1NV9JMkMgaXMgbm90IHNldAojIENPTkZJR19GWE9TODcwMF9J
MkMgaXMgbm90IHNldAojIENPTkZJR19GWE9TODcwMF9TUEkgaXMgbm90IHNldAojIENPTkZJ
R19LTVg2MSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOVl9JQ000MjYwMF9JMkMgaXMgbm90IHNl
dAojIENPTkZJR19JTlZfSUNNNDI2MDBfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5WX01Q
VTYwNTBfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5WX01QVTYwNTBfU1BJIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU01JMjQwIGlzIG5vdCBzZXQKIyBDT05GSUdfSUlPX1NUX0xTTTZEU1gg
aXMgbm90IHNldAojIENPTkZJR19JSU9fU1RfTFNNOURTMCBpcyBub3Qgc2V0CiMgZW5kIG9m
IEluZXJ0aWFsIG1lYXN1cmVtZW50IHVuaXRzCgojCiMgTGlnaHQgc2Vuc29ycwojCiMgQ09O
RklHX0FESkRfUzMxMSBpcyBub3Qgc2V0CiMgQ09ORklHX0FEVVgxMDIwIGlzIG5vdCBzZXQK
IyBDT05GSUdfQUwzMDAwQSBpcyBub3Qgc2V0CiMgQ09ORklHX0FMMzAxMCBpcyBub3Qgc2V0
CiMgQ09ORklHX0FMMzMyMEEgaXMgbm90IHNldAojIENPTkZJR19BUERTOTE2MCBpcyBub3Qg
c2V0CiMgQ09ORklHX0FQRFM5MzAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVBEUzkzMDYgaXMg
bm90IHNldAojIENPTkZJR19BUERTOTk2MCBpcyBub3Qgc2V0CiMgQ09ORklHX0FTNzMyMTEg
aXMgbm90IHNldAojIENPTkZJR19CSDE3NDUgaXMgbm90IHNldAojIENPTkZJR19CSDE3NTAg
aXMgbm90IHNldAojIENPTkZJR19CSDE3ODAgaXMgbm90IHNldAojIENPTkZJR19DTTMyMTgx
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ00zMjMyIGlzIG5vdCBzZXQKIyBDT05GSUdfQ00zMzIz
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ00zNjA1IGlzIG5vdCBzZXQKIyBDT05GSUdfQ00zNjY1
MSBpcyBub3Qgc2V0CiMgQ09ORklHX0dQMkFQMDAyIGlzIG5vdCBzZXQKIyBDT05GSUdfR1Ay
QVAwMjBBMDBGIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19JU0wyOTAxOCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfSVNMMjkwMjggaXMgbm90IHNldAojIENPTkZJR19JU0wy
OTEyNSBpcyBub3Qgc2V0CiMgQ09ORklHX0lTTDc2NjgyIGlzIG5vdCBzZXQKIyBDT05GSUdf
SlNBMTIxMiBpcyBub3Qgc2V0CiMgQ09ORklHX1JPSE1fQlUyNzAzNCBpcyBub3Qgc2V0CiMg
Q09ORklHX1JQUjA1MjEgaXMgbm90IHNldAojIENPTkZJR19MVFIzOTAgaXMgbm90IHNldAoj
IENPTkZJR19MVFI1MDEgaXMgbm90IHNldAojIENPTkZJR19MVFJGMjE2QSBpcyBub3Qgc2V0
CiMgQ09ORklHX0xWMDEwNENTIGlzIG5vdCBzZXQKIyBDT05GSUdfTUFYNDQwMDAgaXMgbm90
IHNldAojIENPTkZJR19NQVg0NDAwOSBpcyBub3Qgc2V0CiMgQ09ORklHX05PQTEzMDUgaXMg
bm90IHNldAojIENPTkZJR19PUFQzMDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfT1BUNDAwMSBp
cyBub3Qgc2V0CiMgQ09ORklHX09QVDQwNjAgaXMgbm90IHNldAojIENPTkZJR19QQTEyMjAz
MDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0kxMTMzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0kx
MTQ1IGlzIG5vdCBzZXQKIyBDT05GSUdfU1RLMzMxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NU
X1VWSVMyNSBpcyBub3Qgc2V0CiMgQ09ORklHX1RDUzM0MTQgaXMgbm90IHNldAojIENPTkZJ
R19UQ1MzNDcyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UU0wyNTYzIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVFNMMjU4MyBpcyBub3Qgc2V0CiMgQ09ORklHX1RTTDI1OTEgaXMgbm90
IHNldAojIENPTkZJR19UU0wyNzcyIGlzIG5vdCBzZXQKIyBDT05GSUdfVFNMNDUzMSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTNTE4MkQgaXMgbm90IHNldAojIENPTkZJR19WQ05MNDAwMCBp
cyBub3Qgc2V0CiMgQ09ORklHX1ZDTkw0MDM1IGlzIG5vdCBzZXQKIyBDT05GSUdfVkVNTDMy
MzUgaXMgbm90IHNldAojIENPTkZJR19WRU1MNjAzMCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZF
TUw2MDQwIGlzIG5vdCBzZXQKIyBDT05GSUdfVkVNTDYwNzAgaXMgbm90IHNldAojIENPTkZJ
R19WRU1MNjA3NSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZMNjE4MCBpcyBub3Qgc2V0CiMgQ09O
RklHX1pPUFQyMjAxIGlzIG5vdCBzZXQKIyBlbmQgb2YgTGlnaHQgc2Vuc29ycwoKIwojIE1h
Z25ldG9tZXRlciBzZW5zb3JzCiMKIyBDT05GSUdfQUY4MTMzSiBpcyBub3Qgc2V0CiMgQ09O
RklHX0FLODk3NCBpcyBub3Qgc2V0CiMgQ09ORklHX0FLODk3NSBpcyBub3Qgc2V0CiMgQ09O
RklHX0FLMDk5MTEgaXMgbm90IHNldAojIENPTkZJR19BTFMzMTMwMCBpcyBub3Qgc2V0CiMg
Q09ORklHX0JNQzE1MF9NQUdOX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX0JNQzE1MF9NQUdO
X1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX01BRzMxMTAgaXMgbm90IHNldAojIENPTkZJR19N
TUMzNTI0MCBpcyBub3Qgc2V0CiMgQ09ORklHX0lJT19TVF9NQUdOXzNBWElTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19ITUM1ODQzX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfSE1DNTg0M19TUEkgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1JNMzEwMF9J
MkMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1JNMzEwMF9TUEkgaXMgbm90IHNldAoj
IENPTkZJR19TSTcyMTAgaXMgbm90IHNldAojIENPTkZJR19USV9UTUFHNTI3MyBpcyBub3Qg
c2V0CiMgQ09ORklHX1lBTUFIQV9ZQVM1MzAgaXMgbm90IHNldAojIGVuZCBvZiBNYWduZXRv
bWV0ZXIgc2Vuc29ycwoKIwojIE11bHRpcGxleGVycwojCiMgQ09ORklHX0lJT19NVVggaXMg
bm90IHNldAojIGVuZCBvZiBNdWx0aXBsZXhlcnMKCiMKIyBJbmNsaW5vbWV0ZXIgc2Vuc29y
cwojCiMgZW5kIG9mIEluY2xpbm9tZXRlciBzZW5zb3JzCgojCiMgVHJpZ2dlcnMgLSBzdGFu
ZGFsb25lCiMKIyBDT05GSUdfSUlPX0lOVEVSUlVQVF9UUklHR0VSIGlzIG5vdCBzZXQKIyBD
T05GSUdfSUlPX1NZU0ZTX1RSSUdHRVIgaXMgbm90IHNldAojIGVuZCBvZiBUcmlnZ2VycyAt
IHN0YW5kYWxvbmUKCiMKIyBMaW5lYXIgYW5kIGFuZ3VsYXIgcG9zaXRpb24gc2Vuc29ycwoj
CiMgZW5kIG9mIExpbmVhciBhbmQgYW5ndWxhciBwb3NpdGlvbiBzZW5zb3JzCgojCiMgRGln
aXRhbCBwb3RlbnRpb21ldGVycwojCiMgQ09ORklHX0FENTExMCBpcyBub3Qgc2V0CiMgQ09O
RklHX0FENTI3MiBpcyBub3Qgc2V0CiMgQ09ORklHX0RTMTgwMyBpcyBub3Qgc2V0CiMgQ09O
RklHX01BWDU0MzIgaXMgbm90IHNldAojIENPTkZJR19NQVg1NDgxIGlzIG5vdCBzZXQKIyBD
T05GSUdfTUFYNTQ4NyBpcyBub3Qgc2V0CiMgQ09ORklHX01DUDQwMTggaXMgbm90IHNldAoj
IENPTkZJR19NQ1A0MTMxIGlzIG5vdCBzZXQKQ09ORklHX01DUDQ1MzE9bQojIENPTkZJR19N
Q1A0MTAxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1RQTDAxMDIgaXMgbm90IHNldAojIENPTkZJ
R19YOTI1MCBpcyBub3Qgc2V0CiMgZW5kIG9mIERpZ2l0YWwgcG90ZW50aW9tZXRlcnMKCiMK
IyBEaWdpdGFsIHBvdGVudGlvc3RhdHMKIwojIENPTkZJR19MTVA5MTAwMCBpcyBub3Qgc2V0
CiMgZW5kIG9mIERpZ2l0YWwgcG90ZW50aW9zdGF0cwoKIwojIFByZXNzdXJlIHNlbnNvcnMK
IwojIENPTkZJR19BQlAwNjBNRyBpcyBub3Qgc2V0CiMgQ09ORklHX1JPSE1fQk0xMzkwIGlz
IG5vdCBzZXQKIyBDT05GSUdfQk1QMjgwIGlzIG5vdCBzZXQKIyBDT05GSUdfRExITDYwRCBp
cyBub3Qgc2V0CiMgQ09ORklHX0RQUzMxMCBpcyBub3Qgc2V0CiMgQ09ORklHX0hQMDMgaXMg
bm90IHNldAojIENPTkZJR19IU0MwMzBQQSBpcyBub3Qgc2V0CiMgQ09ORklHX0lDUDEwMTAw
IGlzIG5vdCBzZXQKIyBDT05GSUdfTVBMMTE1X0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX01Q
TDExNV9TUEkgaXMgbm90IHNldAojIENPTkZJR19NUEwzMTE1IGlzIG5vdCBzZXQKIyBDT05G
SUdfTVBSTFMwMDI1UEEgaXMgbm90IHNldAojIENPTkZJR19NUzU2MTEgaXMgbm90IHNldAoj
IENPTkZJR19NUzU2MzcgaXMgbm90IHNldAojIENPTkZJR19TRFA1MDAgaXMgbm90IHNldAoj
IENPTkZJR19JSU9fU1RfUFJFU1MgaXMgbm90IHNldAojIENPTkZJR19UNTQwMyBpcyBub3Qg
c2V0CiMgQ09ORklHX0hQMjA2QyBpcyBub3Qgc2V0CiMgQ09ORklHX1pQQTIzMjYgaXMgbm90
IHNldAojIGVuZCBvZiBQcmVzc3VyZSBzZW5zb3JzCgojCiMgTGlnaHRuaW5nIHNlbnNvcnMK
IwojIENPTkZJR19BUzM5MzUgaXMgbm90IHNldAojIGVuZCBvZiBMaWdodG5pbmcgc2Vuc29y
cwoKIwojIFByb3hpbWl0eSBhbmQgZGlzdGFuY2Ugc2Vuc29ycwojCiMgQ09ORklHX0hYOTAy
M1MgaXMgbm90IHNldAojIENPTkZJR19JUlNEMjAwIGlzIG5vdCBzZXQKIyBDT05GSUdfSVNM
Mjk1MDEgaXMgbm90IHNldAojIENPTkZJR19MSURBUl9MSVRFX1YyIGlzIG5vdCBzZXQKIyBD
T05GSUdfTUIxMjMyIGlzIG5vdCBzZXQKIyBDT05GSUdfUElORyBpcyBub3Qgc2V0CiMgQ09O
RklHX1JGRDc3NDAyIGlzIG5vdCBzZXQKIyBDT05GSUdfU1JGMDQgaXMgbm90IHNldAojIENP
TkZJR19TWDkzMTAgaXMgbm90IHNldAojIENPTkZJR19TWDkzMjQgaXMgbm90IHNldAojIENP
TkZJR19TWDkzNjAgaXMgbm90IHNldAojIENPTkZJR19TWDk1MDAgaXMgbm90IHNldAojIENP
TkZJR19TUkYwOCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZDTkwzMDIwIGlzIG5vdCBzZXQKIyBD
T05GSUdfVkw1M0wwWF9JMkMgaXMgbm90IHNldAojIENPTkZJR19BVzk2MTAzIGlzIG5vdCBz
ZXQKIyBlbmQgb2YgUHJveGltaXR5IGFuZCBkaXN0YW5jZSBzZW5zb3JzCgojCiMgUmVzb2x2
ZXIgdG8gZGlnaXRhbCBjb252ZXJ0ZXJzCiMKIyBDT05GSUdfQUQyUzkwIGlzIG5vdCBzZXQK
IyBDT05GSUdfQUQyUzEyMDAgaXMgbm90IHNldAojIENPTkZJR19BRDJTMTIxMCBpcyBub3Qg
c2V0CiMgZW5kIG9mIFJlc29sdmVyIHRvIGRpZ2l0YWwgY29udmVydGVycwoKIwojIFRlbXBl
cmF0dXJlIHNlbnNvcnMKIwojIENPTkZJR19MVEMyOTgzIGlzIG5vdCBzZXQKIyBDT05GSUdf
TUFYSU1fVEhFUk1PQ09VUExFIGlzIG5vdCBzZXQKIyBDT05GSUdfTUxYOTA2MTQgaXMgbm90
IHNldAojIENPTkZJR19NTFg5MDYzMiBpcyBub3Qgc2V0CiMgQ09ORklHX01MWDkwNjM1IGlz
IG5vdCBzZXQKIyBDT05GSUdfVE1QMDA2IGlzIG5vdCBzZXQKIyBDT05GSUdfVE1QMDA3IGlz
IG5vdCBzZXQKIyBDT05GSUdfVE1QMTE3IGlzIG5vdCBzZXQKIyBDT05GSUdfVFNZUzAxIGlz
IG5vdCBzZXQKIyBDT05GSUdfVFNZUzAyRCBpcyBub3Qgc2V0CiMgQ09ORklHX01BWDMwMjA4
IGlzIG5vdCBzZXQKIyBDT05GSUdfTUFYMzE4NTYgaXMgbm90IHNldAojIENPTkZJR19NQVgz
MTg2NSBpcyBub3Qgc2V0CiMgQ09ORklHX01DUDk2MDAgaXMgbm90IHNldAojIGVuZCBvZiBU
ZW1wZXJhdHVyZSBzZW5zb3JzCgpDT05GSUdfUFdNPXkKIyBDT05GSUdfUFdNX0RFQlVHIGlz
IG5vdCBzZXQKQ09ORklHX1BXTV9BVE1FTD15CkNPTkZJR19QV01fQVRNRUxfSExDRENfUFdN
PXkKQ09ORklHX1BXTV9BVE1FTF9UQ0I9eQojIENPTkZJR19QV01fQ0xLIGlzIG5vdCBzZXQK
IyBDT05GSUdfUFdNX0ZTTF9GVE0gaXMgbm90IHNldAojIENPTkZJR19QV01fR1BJTyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BXTV9QQ0E5Njg1IGlzIG5vdCBzZXQKIyBDT05GSUdfUFdNX1hJ
TElOWCBpcyBub3Qgc2V0CgojCiMgSVJRIGNoaXAgc3VwcG9ydAojCkNPTkZJR19JUlFDSElQ
PXkKIyBDT05GSUdfQUxfRklDIGlzIG5vdCBzZXQKQ09ORklHX0FUTUVMX0FJQzVfSVJRPXkK
IyBDT05GSUdfWElMSU5YX0lOVEMgaXMgbm90IHNldAojIENPTkZJR19NQ0hQX0VJQyBpcyBu
b3Qgc2V0CiMgZW5kIG9mIElSUSBjaGlwIHN1cHBvcnQKCiMgQ09ORklHX0lQQUNLX0JVUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFU0VUX0NPTlRST0xMRVIgaXMgbm90IHNldAoKIwojIFBI
WSBTdWJzeXN0ZW0KIwojIENPTkZJR19HRU5FUklDX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklH
X1BIWV9DQU5fVFJBTlNDRUlWRVIgaXMgbm90IHNldAojIENPTkZJR19QSFlfTlhQX1BUTjMy
MjIgaXMgbm90IHNldAoKIwojIFBIWSBkcml2ZXJzIGZvciBCcm9hZGNvbSBwbGF0Zm9ybXMK
IwojIENPTkZJR19CQ01fS09OQV9VU0IyX1BIWSBpcyBub3Qgc2V0CiMgZW5kIG9mIFBIWSBk
cml2ZXJzIGZvciBCcm9hZGNvbSBwbGF0Zm9ybXMKCiMgQ09ORklHX1BIWV9DQURFTkNFX1RP
UlJFTlQgaXMgbm90IHNldAojIENPTkZJR19QSFlfQ0FERU5DRV9EUEhZIGlzIG5vdCBzZXQK
IyBDT05GSUdfUEhZX0NBREVOQ0VfRFBIWV9SWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BIWV9D
QURFTkNFX1NBTFZPIGlzIG5vdCBzZXQKIyBDT05GSUdfUEhZX1BYQV8yOE5NX0hTSUMgaXMg
bm90IHNldAojIENPTkZJR19QSFlfUFhBXzI4Tk1fVVNCMiBpcyBub3Qgc2V0CiMgQ09ORklH
X1BIWV9DUENBUF9VU0IgaXMgbm90IHNldAojIENPTkZJR19QSFlfTUFQUEhPTkVfTURNNjYw
MCBpcyBub3Qgc2V0CiMgQ09ORklHX1BIWV9PQ0VMT1RfU0VSREVTIGlzIG5vdCBzZXQKIyBl
bmQgb2YgUEhZIFN1YnN5c3RlbQoKIyBDT05GSUdfUE9XRVJDQVAgaXMgbm90IHNldAojIENP
TkZJR19NQ0IgaXMgbm90IHNldAojIENPTkZJR19SQVMgaXMgbm90IHNldAoKIwojIEFuZHJv
aWQKIwojIENPTkZJR19BTkRST0lEX0JJTkRFUl9JUEMgaXMgbm90IHNldAojIGVuZCBvZiBB
bmRyb2lkCgojIENPTkZJR19EQVggaXMgbm90IHNldApDT05GSUdfTlZNRU09eQpDT05GSUdf
TlZNRU1fU1lTRlM9eQpDT05GSUdfTlZNRU1fTEFZT1VUUz15CgojCiMgTGF5b3V0IFR5cGVz
CiMKIyBDT05GSUdfTlZNRU1fTEFZT1VUX1NMMjhfVlBEIGlzIG5vdCBzZXQKIyBDT05GSUdf
TlZNRU1fTEFZT1VUX09OSUVfVExWIGlzIG5vdCBzZXQKIyBDT05GSUdfTlZNRU1fTEFZT1VU
X1VfQk9PVF9FTlYgaXMgbm90IHNldAojIGVuZCBvZiBMYXlvdXQgVHlwZXMKCiMgQ09ORklH
X05WTUVNX01JQ1JPQ0hJUF9PVFBDIGlzIG5vdCBzZXQKIyBDT05GSUdfTlZNRU1fUk1FTSBp
cyBub3Qgc2V0CiMgQ09ORklHX05WTUVNX1VfQk9PVF9FTlYgaXMgbm90IHNldAoKIwojIEhX
IHRyYWNpbmcgc3VwcG9ydAojCiMgQ09ORklHX1NUTSBpcyBub3Qgc2V0CiMgQ09ORklHX0lO
VEVMX1RIIGlzIG5vdCBzZXQKIyBlbmQgb2YgSFcgdHJhY2luZyBzdXBwb3J0CgojIENPTkZJ
R19GUEdBIGlzIG5vdCBzZXQKIyBDT05GSUdfRlNJIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVF
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0lPWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NMSU1CVVMg
aXMgbm90IHNldAojIENPTkZJR19JTlRFUkNPTk5FQ1QgaXMgbm90IHNldAojIENPTkZJR19D
T1VOVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9TVCBpcyBub3Qgc2V0CiMgQ09ORklHX1BF
Q0kgaXMgbm90IHNldAojIENPTkZJR19IVEUgaXMgbm90IHNldAojIGVuZCBvZiBEZXZpY2Ug
RHJpdmVycwoKIwojIEZpbGUgc3lzdGVtcwojCkNPTkZJR19EQ0FDSEVfV09SRF9BQ0NFU1M9
eQojIENPTkZJR19WQUxJREFURV9GU19QQVJTRVIgaXMgbm90IHNldApDT05GSUdfRlNfSU9N
QVA9eQpDT05GSUdfQlVGRkVSX0hFQUQ9eQpDT05GSUdfTEVHQUNZX0RJUkVDVF9JTz15CiMg
Q09ORklHX0VYVDJfRlMgaXMgbm90IHNldAojIENPTkZJR19FWFQzX0ZTIGlzIG5vdCBzZXQK
Q09ORklHX0VYVDRfRlM9eQpDT05GSUdfRVhUNF9VU0VfRk9SX0VYVDI9eQojIENPTkZJR19F
WFQ0X0ZTX1BPU0lYX0FDTCBpcyBub3Qgc2V0CiMgQ09ORklHX0VYVDRfRlNfU0VDVVJJVFkg
aXMgbm90IHNldAojIENPTkZJR19FWFQ0X0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0pCRDI9
eQojIENPTkZJR19KQkQyX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0ZTX01CQ0FDSEU9eQoj
IENPTkZJR19KRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19YRlNfRlMgaXMgbm90IHNldAoj
IENPTkZJR19HRlMyX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfT0NGUzJfRlMgaXMgbm90IHNl
dAojIENPTkZJR19CVFJGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX05JTEZTMl9GUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0YyRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19CQ0FDSEVGU19G
UyBpcyBub3Qgc2V0CkNPTkZJR19FWFBPUlRGUz15CiMgQ09ORklHX0VYUE9SVEZTX0JMT0NL
X09QUyBpcyBub3Qgc2V0CkNPTkZJR19GSUxFX0xPQ0tJTkc9eQojIENPTkZJR19GU19FTkNS
WVBUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfRlNfVkVSSVRZIGlzIG5vdCBzZXQKQ09ORklH
X0ZTTk9USUZZPXkKQ09ORklHX0ROT1RJRlk9eQpDT05GSUdfSU5PVElGWV9VU0VSPXkKQ09O
RklHX0ZBTk9USUZZPXkKIyBDT05GSUdfRkFOT1RJRllfQUNDRVNTX1BFUk1JU1NJT05TIGlz
IG5vdCBzZXQKIyBDT05GSUdfUVVPVEEgaXMgbm90IHNldApDT05GSUdfQVVUT0ZTX0ZTPW0K
IyBDT05GSUdfRlVTRV9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX09WRVJMQVlfRlMgaXMgbm90
IHNldAoKIwojIENhY2hlcwojCiMgZW5kIG9mIENhY2hlcwoKIwojIENELVJPTS9EVkQgRmls
ZXN5c3RlbXMKIwojIENPTkZJR19JU085NjYwX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfVURG
X0ZTIGlzIG5vdCBzZXQKIyBlbmQgb2YgQ0QtUk9NL0RWRCBGaWxlc3lzdGVtcwoKIwojIERP
Uy9GQVQvRVhGQVQvTlQgRmlsZXN5c3RlbXMKIwpDT05GSUdfRkFUX0ZTPXkKIyBDT05GSUdf
TVNET1NfRlMgaXMgbm90IHNldApDT05GSUdfVkZBVF9GUz15CkNPTkZJR19GQVRfREVGQVVM
VF9DT0RFUEFHRT00MzcKQ09ORklHX0ZBVF9ERUZBVUxUX0lPQ0hBUlNFVD0iaXNvODg1OS0x
IgojIENPTkZJR19GQVRfREVGQVVMVF9VVEY4IGlzIG5vdCBzZXQKIyBDT05GSUdfRVhGQVRf
RlMgaXMgbm90IHNldAojIENPTkZJR19OVEZTM19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX05U
RlNfRlMgaXMgbm90IHNldAojIGVuZCBvZiBET1MvRkFUL0VYRkFUL05UIEZpbGVzeXN0ZW1z
CgojCiMgUHNldWRvIGZpbGVzeXN0ZW1zCiMKQ09ORklHX1BST0NfRlM9eQpDT05GSUdfUFJP
Q19WTUNPUkU9eQojIENPTkZJR19QUk9DX1ZNQ09SRV9ERVZJQ0VfRFVNUCBpcyBub3Qgc2V0
CkNPTkZJR19QUk9DX1NZU0NUTD15CkNPTkZJR19QUk9DX1BBR0VfTU9OSVRPUj15CiMgQ09O
RklHX1BST0NfQ0hJTERSRU4gaXMgbm90IHNldApDT05GSUdfS0VSTkZTPXkKQ09ORklHX1NZ
U0ZTPXkKQ09ORklHX1RNUEZTPXkKIyBDT05GSUdfVE1QRlNfUE9TSVhfQUNMIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVE1QRlNfWEFUVFIgaXMgbm90IHNldAojIENPTkZJR19UTVBGU19RVU9U
QSBpcyBub3Qgc2V0CkNPTkZJR19DT05GSUdGU19GUz15CiMgZW5kIG9mIFBzZXVkbyBmaWxl
c3lzdGVtcwoKQ09ORklHX01JU0NfRklMRVNZU1RFTVM9eQojIENPTkZJR19PUkFOR0VGU19G
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0FERlNfRlMgaXMgbm90IHNldAojIENPTkZJR19BRkZT
X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfRUNSWVBUX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdf
SEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSEZTUExVU19GUyBpcyBub3Qgc2V0CiMgQ09O
RklHX0JFRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19CRlNfRlMgaXMgbm90IHNldAojIENP
TkZJR19FRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19KRkZTMl9GUyBpcyBub3Qgc2V0CkNP
TkZJR19VQklGU19GUz15CkNPTkZJR19VQklGU19GU19BRFZBTkNFRF9DT01QUj15CkNPTkZJ
R19VQklGU19GU19MWk89eQpDT05GSUdfVUJJRlNfRlNfWkxJQj15CkNPTkZJR19VQklGU19G
U19aU1REPXkKIyBDT05GSUdfVUJJRlNfQVRJTUVfU1VQUE9SVCBpcyBub3Qgc2V0CkNPTkZJ
R19VQklGU19GU19YQVRUUj15CkNPTkZJR19VQklGU19GU19TRUNVUklUWT15CiMgQ09ORklH
X1VCSUZTX0ZTX0FVVEhFTlRJQ0FUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JBTUZTIGlz
IG5vdCBzZXQKIyBDT05GSUdfU1FVQVNIRlMgaXMgbm90IHNldAojIENPTkZJR19WWEZTX0ZT
IGlzIG5vdCBzZXQKIyBDT05GSUdfTUlOSVhfRlMgaXMgbm90IHNldAojIENPTkZJR19PTUZT
X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSFBGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1FO
WDRGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1FOWDZGU19GUyBpcyBub3Qgc2V0CiMgQ09O
RklHX1JPTUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfUFNUT1JFIGlzIG5vdCBzZXQKIyBD
T05GSUdfVUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfRVJPRlNfRlMgaXMgbm90IHNldApD
T05GSUdfTkVUV09SS19GSUxFU1lTVEVNUz15CkNPTkZJR19ORlNfRlM9eQojIENPTkZJR19O
RlNfVjIgaXMgbm90IHNldApDT05GSUdfTkZTX1YzPXkKIyBDT05GSUdfTkZTX1YzX0FDTCBp
cyBub3Qgc2V0CiMgQ09ORklHX05GU19WNCBpcyBub3Qgc2V0CkNPTkZJR19ST09UX05GUz15
CiMgQ09ORklHX05GU19GU0NBQ0hFIGlzIG5vdCBzZXQKQ09ORklHX05GU19ESVNBQkxFX1VE
UF9TVVBQT1JUPXkKIyBDT05GSUdfTkZTRCBpcyBub3Qgc2V0CkNPTkZJR19HUkFDRV9QRVJJ
T0Q9eQpDT05GSUdfTE9DS0Q9eQpDT05GSUdfTE9DS0RfVjQ9eQpDT05GSUdfTkZTX0NPTU1P
Tj15CkNPTkZJR19TVU5SUEM9eQpDT05GSUdfU1VOUlBDX0dTUz15CkNPTkZJR19SUENTRUNf
R1NTX0tSQjU9eQojIENPTkZJR19TVU5SUENfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19D
RVBIX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0lGUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NN
Ql9TRVJWRVIgaXMgbm90IHNldAojIENPTkZJR19DT0RBX0ZTIGlzIG5vdCBzZXQKIyBDT05G
SUdfQUZTX0ZTIGlzIG5vdCBzZXQKQ09ORklHX05MUz15CkNPTkZJR19OTFNfREVGQVVMVD0i
aXNvODg1OS0xIgpDT05GSUdfTkxTX0NPREVQQUdFXzQzNz15CiMgQ09ORklHX05MU19DT0RF
UEFHRV83MzcgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfNzc1IGlzIG5vdCBz
ZXQKQ09ORklHX05MU19DT0RFUEFHRV84NTA9eQojIENPTkZJR19OTFNfQ09ERVBBR0VfODUy
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1NSBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19DT0RFUEFHRV84NTcgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0Vf
ODYwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MSBpcyBub3Qgc2V0CiMg
Q09ORklHX05MU19DT0RFUEFHRV84NjIgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBB
R0VfODYzIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2NCBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjUgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09E
RVBBR0VfODY2IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2OSBpcyBub3Qg
c2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV85MzYgaXMgbm90IHNldAojIENPTkZJR19OTFNf
Q09ERVBBR0VfOTUwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzkzMiBpcyBu
b3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV85NDkgaXMgbm90IHNldAojIENPTkZJR19O
TFNfQ09ERVBBR0VfODc0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfOCBpcyBu
b3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV8xMjUwIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkxTX0NPREVQQUdFXzEyNTEgaXMgbm90IHNldAojIENPTkZJR19OTFNfQVNDSUkgaXMgbm90
IHNldApDT05GSUdfTkxTX0lTTzg4NTlfMT15CiMgQ09ORklHX05MU19JU084ODU5XzIgaXMg
bm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8zIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxT
X0lTTzg4NTlfNCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzUgaXMgbm90IHNl
dAojIENPTkZJR19OTFNfSVNPODg1OV82IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4
NTlfNyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzkgaXMgbm90IHNldAojIENP
TkZJR19OTFNfSVNPODg1OV8xMyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzE0
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMTUgaXMgbm90IHNldAojIENPTkZJ
R19OTFNfS09JOF9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0tPSThfVSBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19NQUNfUk9NQU4gaXMgbm90IHNldAojIENPTkZJR19OTFNfTUFDX0NF
TFRJQyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNfQ0VOVEVVUk8gaXMgbm90IHNldAoj
IENPTkZJR19OTFNfTUFDX0NST0FUSUFOIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX01BQ19D
WVJJTExJQyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNfR0FFTElDIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkxTX01BQ19HUkVFSyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNfSUNF
TEFORCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNfSU5VSVQgaXMgbm90IHNldAojIENP
TkZJR19OTFNfTUFDX1JPTUFOSUFOIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX01BQ19UVVJL
SVNIIGlzIG5vdCBzZXQKQ09ORklHX05MU19VVEY4PXkKIyBDT05GSUdfRExNIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVU5JQ09ERSBpcyBub3Qgc2V0CkNPTkZJR19JT19XUT15CiMgZW5kIG9m
IEZpbGUgc3lzdGVtcwoKIwojIFNlY3VyaXR5IG9wdGlvbnMKIwpDT05GSUdfS0VZUz15CiMg
Q09ORklHX0tFWVNfUkVRVUVTVF9DQUNIRSBpcyBub3Qgc2V0CiMgQ09ORklHX1BFUlNJU1RF
TlRfS0VZUklOR1MgaXMgbm90IHNldAojIENPTkZJR19CSUdfS0VZUyBpcyBub3Qgc2V0CiMg
Q09ORklHX1RSVVNURURfS0VZUyBpcyBub3Qgc2V0CiMgQ09ORklHX0VOQ1JZUFRFRF9LRVlT
IGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZX0RIX09QRVJBVElPTlMgaXMgbm90IHNldAojIENP
TkZJR19TRUNVUklUWV9ETUVTR19SRVNUUklDVCBpcyBub3Qgc2V0CkNPTkZJR19QUk9DX01F
TV9BTFdBWVNfRk9SQ0U9eQojIENPTkZJR19QUk9DX01FTV9GT1JDRV9QVFJBQ0UgaXMgbm90
IHNldAojIENPTkZJR19QUk9DX01FTV9OT19GT1JDRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
Q1VSSVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VDVVJJVFlGUyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NUQVRJQ19VU0VSTU9ERUhFTFBFUiBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX1NF
Q1VSSVRZX0RBQz15CkNPTkZJR19MU009ImxhbmRsb2NrLGxvY2tkb3duLHlhbWEsbG9hZHBp
bixzYWZlc2V0aWQsaXBlLGJwZiIKCiMKIyBLZXJuZWwgaGFyZGVuaW5nIG9wdGlvbnMKIwoK
IwojIE1lbW9yeSBpbml0aWFsaXphdGlvbgojCkNPTkZJR19DQ19IQVNfQVVUT19WQVJfSU5J
VF9QQVRURVJOPXkKQ09ORklHX0NDX0hBU19BVVRPX1ZBUl9JTklUX1pFUk9fQkFSRT15CkNP
TkZJR19DQ19IQVNfQVVUT19WQVJfSU5JVF9aRVJPPXkKIyBDT05GSUdfSU5JVF9TVEFDS19O
T05FIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5JVF9TVEFDS19BTExfUEFUVEVSTiBpcyBub3Qg
c2V0CkNPTkZJR19JTklUX1NUQUNLX0FMTF9aRVJPPXkKIyBDT05GSUdfSU5JVF9PTl9BTExP
Q19ERUZBVUxUX09OIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5JVF9PTl9GUkVFX0RFRkFVTFRf
T04gaXMgbm90IHNldApDT05GSUdfQ0NfSEFTX1pFUk9fQ0FMTF9VU0VEX1JFR1M9eQojIENP
TkZJR19aRVJPX0NBTExfVVNFRF9SRUdTIGlzIG5vdCBzZXQKIyBlbmQgb2YgTWVtb3J5IGlu
aXRpYWxpemF0aW9uCgojCiMgQm91bmRzIGNoZWNraW5nCiMKIyBDT05GSUdfRk9SVElGWV9T
T1VSQ0UgaXMgbm90IHNldAojIENPTkZJR19IQVJERU5FRF9VU0VSQ09QWSBpcyBub3Qgc2V0
CiMgZW5kIG9mIEJvdW5kcyBjaGVja2luZwoKIwojIEhhcmRlbmluZyBvZiBrZXJuZWwgZGF0
YSBzdHJ1Y3R1cmVzCiMKIyBDT05GSUdfTElTVF9IQVJERU5FRCBpcyBub3Qgc2V0CiMgQ09O
RklHX0JVR19PTl9EQVRBX0NPUlJVUFRJT04gaXMgbm90IHNldAojIGVuZCBvZiBIYXJkZW5p
bmcgb2Yga2VybmVsIGRhdGEgc3RydWN0dXJlcwoKQ09ORklHX1JBTkRTVFJVQ1RfTk9ORT15
CiMgZW5kIG9mIEtlcm5lbCBoYXJkZW5pbmcgb3B0aW9ucwojIGVuZCBvZiBTZWN1cml0eSBv
cHRpb25zCgpDT05GSUdfQ1JZUFRPPXkKCiMKIyBDcnlwdG8gY29yZSBvciBoZWxwZXIKIwpD
T05GSUdfQ1JZUFRPX0FMR0FQST15CkNPTkZJR19DUllQVE9fQUxHQVBJMj15CkNPTkZJR19D
UllQVE9fQUVBRD15CkNPTkZJR19DUllQVE9fQUVBRDI9eQpDT05GSUdfQ1JZUFRPX1NJRz15
CkNPTkZJR19DUllQVE9fU0lHMj15CkNPTkZJR19DUllQVE9fU0tDSVBIRVI9eQpDT05GSUdf
Q1JZUFRPX1NLQ0lQSEVSMj15CkNPTkZJR19DUllQVE9fSEFTSD15CkNPTkZJR19DUllQVE9f
SEFTSDI9eQpDT05GSUdfQ1JZUFRPX1JORzI9eQpDT05GSUdfQ1JZUFRPX0FLQ0lQSEVSMj15
CkNPTkZJR19DUllQVE9fQUtDSVBIRVI9eQpDT05GSUdfQ1JZUFRPX0tQUDI9eQpDT05GSUdf
Q1JZUFRPX0FDT01QMj15CkNPTkZJR19DUllQVE9fTUFOQUdFUj15CkNPTkZJR19DUllQVE9f
TUFOQUdFUjI9eQojIENPTkZJR19DUllQVE9fVVNFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0NS
WVBUT19NQU5BR0VSX0RJU0FCTEVfVEVTVFMgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX01B
TkFHRVJfRVhUUkFfVEVTVFM9eQpDT05GSUdfQ1JZUFRPX05VTEw9eQpDT05GSUdfQ1JZUFRP
X05VTEwyPXkKIyBDT05GSUdfQ1JZUFRPX0NSWVBURCBpcyBub3Qgc2V0CkNPTkZJR19DUllQ
VE9fQVVUSEVOQz15CiMgQ09ORklHX0NSWVBUT19LUkI1RU5DIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ1JZUFRPX1RFU1QgaXMgbm90IHNldAojIGVuZCBvZiBDcnlwdG8gY29yZSBvciBoZWxw
ZXIKCiMKIyBQdWJsaWMta2V5IGNyeXB0b2dyYXBoeQojCkNPTkZJR19DUllQVE9fUlNBPXkK
IyBDT05GSUdfQ1JZUFRPX0RIIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0VDREggaXMg
bm90IHNldAojIENPTkZJR19DUllQVE9fRUNEU0EgaXMgbm90IHNldAojIENPTkZJR19DUllQ
VE9fRUNSRFNBIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0NVUlZFMjU1MTkgaXMgbm90
IHNldAojIGVuZCBvZiBQdWJsaWMta2V5IGNyeXB0b2dyYXBoeQoKIwojIEJsb2NrIGNpcGhl
cnMKIwpDT05GSUdfQ1JZUFRPX0FFUz15CiMgQ09ORklHX0NSWVBUT19BRVNfVEkgaXMgbm90
IHNldAojIENPTkZJR19DUllQVE9fQU5VQklTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRP
X0FSSUEgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQkxPV0ZJU0ggaXMgbm90IHNldAoj
IENPTkZJR19DUllQVE9fQ0FNRUxMSUEgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQ0FT
VDUgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQ0FTVDYgaXMgbm90IHNldApDT05GSUdf
Q1JZUFRPX0RFUz15CiMgQ09ORklHX0NSWVBUT19GQ1JZUFQgaXMgbm90IHNldAojIENPTkZJ
R19DUllQVE9fS0hBWkFEIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NFRUQgaXMgbm90
IHNldAojIENPTkZJR19DUllQVE9fU0VSUEVOVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBU
T19TTTRfR0VORVJJQyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19URUEgaXMgbm90IHNl
dAojIENPTkZJR19DUllQVE9fVFdPRklTSCBpcyBub3Qgc2V0CiMgZW5kIG9mIEJsb2NrIGNp
cGhlcnMKCiMKIyBMZW5ndGgtcHJlc2VydmluZyBjaXBoZXJzIGFuZCBtb2RlcwojCiMgQ09O
RklHX0NSWVBUT19BRElBTlRVTSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19BUkM0IGlz
IG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0NIQUNIQTIwIGlzIG5vdCBzZXQKQ09ORklHX0NS
WVBUT19DQkM9eQpDT05GSUdfQ1JZUFRPX0NUUj15CiMgQ09ORklHX0NSWVBUT19DVFMgaXMg
bm90IHNldApDT05GSUdfQ1JZUFRPX0VDQj15CiMgQ09ORklHX0NSWVBUT19IQ1RSMiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NSWVBUT19MUlcgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9f
UENCQyBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fWFRTPXkKIyBlbmQgb2YgTGVuZ3RoLXBy
ZXNlcnZpbmcgY2lwaGVycyBhbmQgbW9kZXMKCiMKIyBBRUFEIChhdXRoZW50aWNhdGVkIGVu
Y3J5cHRpb24gd2l0aCBhc3NvY2lhdGVkIGRhdGEpIGNpcGhlcnMKIwojIENPTkZJR19DUllQ
VE9fQUVHSVMxMjggaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQ0hBQ0hBMjBQT0xZMTMw
NSBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fQ0NNPXkKQ09ORklHX0NSWVBUT19HQ009eQoj
IENPTkZJR19DUllQVE9fU0VRSVYgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fRUNIQUlO
SVYgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fRVNTSVYgaXMgbm90IHNldAojIGVuZCBv
ZiBBRUFEIChhdXRoZW50aWNhdGVkIGVuY3J5cHRpb24gd2l0aCBhc3NvY2lhdGVkIGRhdGEp
IGNpcGhlcnMKCiMKIyBIYXNoZXMsIGRpZ2VzdHMsIGFuZCBNQUNzCiMKIyBDT05GSUdfQ1JZ
UFRPX0JMQUtFMkIgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX0NNQUM9eQpDT05GSUdfQ1JZ
UFRPX0dIQVNIPXkKQ09ORklHX0NSWVBUT19ITUFDPXkKIyBDT05GSUdfQ1JZUFRPX01ENCBp
cyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19NRDUgaXMgbm90IHNldAojIENPTkZJR19DUllQ
VE9fTUlDSEFFTF9NSUMgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fUE9MWTEzMDUgaXMg
bm90IHNldAojIENPTkZJR19DUllQVE9fUk1EMTYwIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBU
T19TSEExPXkKQ09ORklHX0NSWVBUT19TSEEyNTY9eQpDT05GSUdfQ1JZUFRPX1NIQTUxMj15
CiMgQ09ORklHX0NSWVBUT19TSEEzIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NNM19H
RU5FUklDIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NUUkVFQk9HIGlzIG5vdCBzZXQK
IyBDT05GSUdfQ1JZUFRPX1dQNTEyIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1hDQkMg
aXMgbm90IHNldAojIENPTkZJR19DUllQVE9fWFhIQVNIIGlzIG5vdCBzZXQKIyBlbmQgb2Yg
SGFzaGVzLCBkaWdlc3RzLCBhbmQgTUFDcwoKIwojIENSQ3MgKGN5Y2xpYyByZWR1bmRhbmN5
IGNoZWNrcykKIwojIENPTkZJR19DUllQVE9fQ1JDMzJDIGlzIG5vdCBzZXQKIyBDT05GSUdf
Q1JZUFRPX0NSQzMyIGlzIG5vdCBzZXQKIyBlbmQgb2YgQ1JDcyAoY3ljbGljIHJlZHVuZGFu
Y3kgY2hlY2tzKQoKIwojIENvbXByZXNzaW9uCiMKQ09ORklHX0NSWVBUT19ERUZMQVRFPXkK
Q09ORklHX0NSWVBUT19MWk89eQojIENPTkZJR19DUllQVE9fODQyIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JZUFRPX0xaNCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19MWjRIQyBpcyBu
b3Qgc2V0CkNPTkZJR19DUllQVE9fWlNURD15CiMgZW5kIG9mIENvbXByZXNzaW9uCgojCiMg
UmFuZG9tIG51bWJlciBnZW5lcmF0aW9uCiMKIyBDT05GSUdfQ1JZUFRPX0FOU0lfQ1BSTkcg
aXMgbm90IHNldAojIENPTkZJR19DUllQVE9fRFJCR19NRU5VIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ1JZUFRPX0pJVFRFUkVOVFJPUFkgaXMgbm90IHNldAojIGVuZCBvZiBSYW5kb20gbnVt
YmVyIGdlbmVyYXRpb24KCiMKIyBVc2Vyc3BhY2UgaW50ZXJmYWNlCiMKQ09ORklHX0NSWVBU
T19VU0VSX0FQST1tCkNPTkZJR19DUllQVE9fVVNFUl9BUElfSEFTSD1tCkNPTkZJR19DUllQ
VE9fVVNFUl9BUElfU0tDSVBIRVI9bQojIENPTkZJR19DUllQVE9fVVNFUl9BUElfUk5HIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1VTRVJfQVBJX0FFQUQgaXMgbm90IHNldApDT05G
SUdfQ1JZUFRPX1VTRVJfQVBJX0VOQUJMRV9PQlNPTEVURT15CiMgZW5kIG9mIFVzZXJzcGFj
ZSBpbnRlcmZhY2UKCkNPTkZJR19DUllQVE9fSEFTSF9JTkZPPXkKCiMKIyBBY2NlbGVyYXRl
ZCBDcnlwdG9ncmFwaGljIEFsZ29yaXRobXMgZm9yIENQVSAoYXJtKQojCiMgQ09ORklHX0NS
WVBUT19HSEFTSF9BUk1fQ0UgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fTkhQT0xZMTMw
NV9ORU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0JMQUtFMlNfQVJNIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ1JZUFRPX0JMQUtFMkJfTkVPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0NS
WVBUT19TSEExX0FSTSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19TSEExX0FSTV9ORU9O
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NIQTFfQVJNX0NFIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JZUFRPX1NIQTJfQVJNX0NFIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NI
QTI1Nl9BUk0gaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fU0hBNTEyX0FSTSBpcyBub3Qg
c2V0CiMgQ09ORklHX0NSWVBUT19BRVNfQVJNIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRP
X0FFU19BUk1fQlMgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQUVTX0FSTV9DRSBpcyBu
b3Qgc2V0CiMgZW5kIG9mIEFjY2VsZXJhdGVkIENyeXB0b2dyYXBoaWMgQWxnb3JpdGhtcyBm
b3IgQ1BVIChhcm0pCgpDT05GSUdfQ1JZUFRPX0hXPXkKQ09ORklHX0NSWVBUT19ERVZfQVRN
RUxfQVVUSEVOQz15CkNPTkZJR19DUllQVE9fREVWX0FUTUVMX0FFUz15CkNPTkZJR19DUllQ
VE9fREVWX0FUTUVMX1RERVM9eQpDT05GSUdfQ1JZUFRPX0RFVl9BVE1FTF9TSEE9eQojIENP
TkZJR19DUllQVE9fREVWX0FUTUVMX0VDQyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19E
RVZfQVRNRUxfU0hBMjA0QSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19ERVZfU0FGRVhD
RUwgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fREVWX0NDUkVFIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JZUFRPX0RFVl9BTUxPR0lDX0dYTCBpcyBub3Qgc2V0CkNPTkZJR19BU1lNTUVU
UklDX0tFWV9UWVBFPXkKQ09ORklHX0FTWU1NRVRSSUNfUFVCTElDX0tFWV9TVUJUWVBFPXkK
Q09ORklHX1g1MDlfQ0VSVElGSUNBVEVfUEFSU0VSPXkKIyBDT05GSUdfUEtDUzhfUFJJVkFU
RV9LRVlfUEFSU0VSIGlzIG5vdCBzZXQKQ09ORklHX1BLQ1M3X01FU1NBR0VfUEFSU0VSPXkK
IyBDT05GSUdfUEtDUzdfVEVTVF9LRVkgaXMgbm90IHNldAojIENPTkZJR19TSUdORURfUEVf
RklMRV9WRVJJRklDQVRJT04gaXMgbm90IHNldAojIENPTkZJR19GSVBTX1NJR05BVFVSRV9T
RUxGVEVTVCBpcyBub3Qgc2V0CgojCiMgQ2VydGlmaWNhdGVzIGZvciBzaWduYXR1cmUgY2hl
Y2tpbmcKIwpDT05GSUdfU1lTVEVNX1RSVVNURURfS0VZUklORz15CkNPTkZJR19TWVNURU1f
VFJVU1RFRF9LRVlTPSIiCiMgQ09ORklHX1NZU1RFTV9FWFRSQV9DRVJUSUZJQ0FURSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFQ09OREFSWV9UUlVTVEVEX0tFWVJJTkcgaXMgbm90IHNldAoj
IENPTkZJR19TWVNURU1fQkxBQ0tMSVNUX0tFWVJJTkcgaXMgbm90IHNldAojIGVuZCBvZiBD
ZXJ0aWZpY2F0ZXMgZm9yIHNpZ25hdHVyZSBjaGVja2luZwoKIyBDT05GSUdfQ1JZUFRPX0tS
QjUgaXMgbm90IHNldAoKIwojIExpYnJhcnkgcm91dGluZXMKIwpDT05GSUdfTElORUFSX1JB
TkdFUz15CiMgQ09ORklHX1BBQ0tJTkcgaXMgbm90IHNldApDT05GSUdfQklUUkVWRVJTRT15
CkNPTkZJR19IQVZFX0FSQ0hfQklUUkVWRVJTRT15CkNPTkZJR19HRU5FUklDX1NUUk5DUFlf
RlJPTV9VU0VSPXkKQ09ORklHX0dFTkVSSUNfU1RSTkxFTl9VU0VSPXkKQ09ORklHX0dFTkVS
SUNfTkVUX1VUSUxTPXkKIyBDT05GSUdfQ09SRElDIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJJ
TUVfTlVNQkVSUyBpcyBub3Qgc2V0CkNPTkZJR19SQVRJT05BTD15CkNPTkZJR19BUkNIX1VT
RV9DTVBYQ0hHX0xPQ0tSRUY9eQoKIwojIENyeXB0byBsaWJyYXJ5IHJvdXRpbmVzCiMKQ09O
RklHX0NSWVBUT19MSUJfVVRJTFM9eQpDT05GSUdfQ1JZUFRPX0xJQl9BRVM9eQpDT05GSUdf
Q1JZUFRPX0xJQl9BUkM0PXkKQ09ORklHX0NSWVBUT19MSUJfR0YxMjhNVUw9eQpDT05GSUdf
Q1JZUFRPX0xJQl9CTEFLRTJTX0dFTkVSSUM9eQpDT05GSUdfQ1JZUFRPX0xJQl9ERVM9eQpD
T05GSUdfQ1JZUFRPX0xJQl9QT0xZMTMwNV9SU0laRT05CkNPTkZJR19DUllQVE9fTElCX1NI
QTE9eQpDT05GSUdfQ1JZUFRPX0xJQl9TSEEyNTY9eQojIGVuZCBvZiBDcnlwdG8gbGlicmFy
eSByb3V0aW5lcwoKQ09ORklHX0NSQ19DQ0lUVD1tCkNPTkZJR19DUkMxNj15CkNPTkZJR19B
UkNIX0hBU19DUkNfVDEwRElGPXkKQ09ORklHX0NSQ19JVFVfVD1tCkNPTkZJR19DUkMzMj15
CkNPTkZJR19BUkNIX0hBU19DUkMzMj15CkNPTkZJR19DUkMzMl9BUkNIPXkKQ09ORklHX0NS
Q19PUFRJTUlaQVRJT05TPXkKQ09ORklHX1hYSEFTSD15CiMgQ09ORklHX1JBTkRPTTMyX1NF
TEZURVNUIGlzIG5vdCBzZXQKQ09ORklHX1pMSUJfSU5GTEFURT15CkNPTkZJR19aTElCX0RF
RkxBVEU9eQpDT05GSUdfTFpPX0NPTVBSRVNTPXkKQ09ORklHX0xaT19ERUNPTVBSRVNTPXkK
Q09ORklHX0xaNF9ERUNPTVBSRVNTPXkKQ09ORklHX1pTVERfQ09NTU9OPXkKQ09ORklHX1pT
VERfQ09NUFJFU1M9eQpDT05GSUdfWlNURF9ERUNPTVBSRVNTPXkKQ09ORklHX1haX0RFQz15
CkNPTkZJR19YWl9ERUNfWDg2PXkKQ09ORklHX1haX0RFQ19QT1dFUlBDPXkKQ09ORklHX1ha
X0RFQ19BUk09eQpDT05GSUdfWFpfREVDX0FSTVRIVU1CPXkKQ09ORklHX1haX0RFQ19BUk02
ND15CkNPTkZJR19YWl9ERUNfU1BBUkM9eQpDT05GSUdfWFpfREVDX1JJU0NWPXkKIyBDT05G
SUdfWFpfREVDX01JQ1JPTFpNQSBpcyBub3Qgc2V0CkNPTkZJR19YWl9ERUNfQkNKPXkKIyBD
T05GSUdfWFpfREVDX1RFU1QgaXMgbm90IHNldApDT05GSUdfREVDT01QUkVTU19HWklQPXkK
Q09ORklHX0RFQ09NUFJFU1NfQlpJUDI9eQpDT05GSUdfREVDT01QUkVTU19MWk1BPXkKQ09O
RklHX0RFQ09NUFJFU1NfWFo9eQpDT05GSUdfREVDT01QUkVTU19MWk89eQpDT05GSUdfREVD
T01QUkVTU19MWjQ9eQpDT05GSUdfREVDT01QUkVTU19aU1REPXkKQ09ORklHX0dFTkVSSUNf
QUxMT0NBVE9SPXkKQ09ORklHX1hBUlJBWV9NVUxUST15CkNPTkZJR19BU1NPQ0lBVElWRV9B
UlJBWT15CkNPTkZJR19IQVNfSU9NRU09eQpDT05GSUdfSEFTX0lPUE9SVD15CkNPTkZJR19I
QVNfSU9QT1JUX01BUD15CkNPTkZJR19IQVNfRE1BPXkKQ09ORklHX0RNQV9PUFNfSEVMUEVS
Uz15CkNPTkZJR19ORUVEX0RNQV9NQVBfU1RBVEU9eQpDT05GSUdfRE1BX0RFQ0xBUkVfQ09I
RVJFTlQ9eQpDT05GSUdfQVJDSF9IQVNfU0VUVVBfRE1BX09QUz15CkNPTkZJR19BUkNIX0hB
U19URUFSRE9XTl9ETUFfT1BTPXkKQ09ORklHX0FSQ0hfSEFTX1NZTkNfRE1BX0ZPUl9ERVZJ
Q0U9eQpDT05GSUdfQVJDSF9IQVNfU1lOQ19ETUFfRk9SX0NQVT15CkNPTkZJR19ETUFfTkVF
RF9TWU5DPXkKQ09ORklHX0RNQV9OT05DT0hFUkVOVF9NTUFQPXkKQ09ORklHX0FSQ0hfSEFT
X0RNQV9BTExPQz15CiMgQ09ORklHX0RNQV9BUElfREVCVUcgaXMgbm90IHNldAojIENPTkZJ
R19ETUFfTUFQX0JFTkNITUFSSyBpcyBub3Qgc2V0CkNPTkZJR19TR0xfQUxMT0M9eQpDT05G
SUdfRk9SQ0VfTlJfQ1BVUz15CkNPTkZJR19EUUw9eQpDT05GSUdfR0xPQj15CiMgQ09ORklH
X0dMT0JfU0VMRlRFU1QgaXMgbm90IHNldApDT05GSUdfTkxBVFRSPXkKQ09ORklHX0NMWl9U
QUI9eQojIENPTkZJR19JUlFfUE9MTCBpcyBub3Qgc2V0CkNPTkZJR19NUElMSUI9eQpDT05G
SUdfRElNTElCPXkKQ09ORklHX0xJQkZEVD15CkNPTkZJR19PSURfUkVHSVNUUlk9eQpDT05G
SUdfU0dfUE9PTD15CkNPTkZJR19BUkNIX1NUQUNLV0FMSz15CkNPTkZJR19TVEFDS0RFUE9U
PXkKQ09ORklHX1NUQUNLREVQT1RfTUFYX0ZSQU1FUz02NApDT05GSUdfU0JJVE1BUD15CiMg
Q09ORklHX0xXUV9URVNUIGlzIG5vdCBzZXQKIyBlbmQgb2YgTGlicmFyeSByb3V0aW5lcwoK
Q09ORklHX0dFTkVSSUNfTElCX0RFVk1FTV9JU19BTExPV0VEPXkKCiMKIyBLZXJuZWwgaGFj
a2luZwojCgojCiMgcHJpbnRrIGFuZCBkbWVzZyBvcHRpb25zCiMKIyBDT05GSUdfUFJJTlRL
X1RJTUUgaXMgbm90IHNldAojIENPTkZJR19QUklOVEtfQ0FMTEVSIGlzIG5vdCBzZXQKIyBD
T05GSUdfU1RBQ0tUUkFDRV9CVUlMRF9JRCBpcyBub3Qgc2V0CkNPTkZJR19DT05TT0xFX0xP
R0xFVkVMX0RFRkFVTFQ9NwpDT05GSUdfQ09OU09MRV9MT0dMRVZFTF9RVUlFVD00CkNPTkZJ
R19NRVNTQUdFX0xPR0xFVkVMX0RFRkFVTFQ9NAojIENPTkZJR19CT09UX1BSSU5US19ERUxB
WSBpcyBub3Qgc2V0CiMgQ09ORklHX0RZTkFNSUNfREVCVUcgaXMgbm90IHNldAojIENPTkZJ
R19EWU5BTUlDX0RFQlVHX0NPUkUgaXMgbm90IHNldApDT05GSUdfU1lNQk9MSUNfRVJSTkFN
RT15CkNPTkZJR19ERUJVR19CVUdWRVJCT1NFPXkKIyBlbmQgb2YgcHJpbnRrIGFuZCBkbWVz
ZyBvcHRpb25zCgpDT05GSUdfREVCVUdfS0VSTkVMPXkKQ09ORklHX0RFQlVHX01JU0M9eQoK
IwojIENvbXBpbGUtdGltZSBjaGVja3MgYW5kIGNvbXBpbGVyIG9wdGlvbnMKIwpDT05GSUdf
QVNfSEFTX05PTl9DT05TVF9VTEVCMTI4PXkKQ09ORklHX0RFQlVHX0lORk9fTk9ORT15CiMg
Q09ORklHX0RFQlVHX0lORk9fRFdBUkZfVE9PTENIQUlOX0RFRkFVTFQgaXMgbm90IHNldAoj
IENPTkZJR19ERUJVR19JTkZPX0RXQVJGNCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0lO
Rk9fRFdBUkY1IGlzIG5vdCBzZXQKQ09ORklHX0ZSQU1FX1dBUk49MTAyNApDT05GSUdfU1RS
SVBfQVNNX1NZTVM9eQojIENPTkZJR19SRUFEQUJMRV9BU00gaXMgbm90IHNldAojIENPTkZJ
R19IRUFERVJTX0lOU1RBTEwgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TRUNUSU9OX01J
U01BVENIIGlzIG5vdCBzZXQKQ09ORklHX1NFQ1RJT05fTUlTTUFUQ0hfV0FSTl9PTkxZPXkK
IyBDT05GSUdfVk1MSU5VWF9NQVAgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19GT1JDRV9X
RUFLX1BFUl9DUFUgaXMgbm90IHNldAojIGVuZCBvZiBDb21waWxlLXRpbWUgY2hlY2tzIGFu
ZCBjb21waWxlciBvcHRpb25zCgojCiMgR2VuZXJpYyBLZXJuZWwgRGVidWdnaW5nIEluc3Ry
dW1lbnRzCiMKIyBDT05GSUdfTUFHSUNfU1lTUlEgaXMgbm90IHNldApDT05GSUdfREVCVUdf
RlM9eQpDT05GSUdfREVCVUdfRlNfQUxMT1dfQUxMPXkKIyBDT05GSUdfREVCVUdfRlNfRElT
QUxMT1dfTU9VTlQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19GU19BTExPV19OT05FIGlz
IG5vdCBzZXQKQ09ORklHX0hBVkVfQVJDSF9LR0RCPXkKIyBDT05GSUdfS0dEQiBpcyBub3Qg
c2V0CkNPTkZJR19BUkNIX0hBU19VQlNBTj15CiMgQ09ORklHX1VCU0FOIGlzIG5vdCBzZXQK
Q09ORklHX0hBVkVfS0NTQU5fQ09NUElMRVI9eQojIGVuZCBvZiBHZW5lcmljIEtlcm5lbCBE
ZWJ1Z2dpbmcgSW5zdHJ1bWVudHMKCiMKIyBOZXR3b3JraW5nIERlYnVnZ2luZwojCiMgQ09O
RklHX05FVF9ERVZfUkVGQ05UX1RSQUNLRVIgaXMgbm90IHNldAojIENPTkZJR19ORVRfTlNf
UkVGQ05UX1RSQUNLRVIgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19ORVQgaXMgbm90IHNl
dAojIENPTkZJR19ERUJVR19ORVRfU01BTExfUlROTCBpcyBub3Qgc2V0CiMgZW5kIG9mIE5l
dHdvcmtpbmcgRGVidWdnaW5nCgojCiMgTWVtb3J5IERlYnVnZ2luZwojCiMgQ09ORklHX1BB
R0VfRVhURU5TSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfUEFHRUFMTE9DIGlzIG5v
dCBzZXQKQ09ORklHX1NMVUJfREVCVUc9eQojIENPTkZJR19TTFVCX0RFQlVHX09OIGlzIG5v
dCBzZXQKIyBDT05GSUdfUEFHRV9PV05FUiBpcyBub3Qgc2V0CiMgQ09ORklHX1BBR0VfUE9J
U09OSU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfUk9EQVRBX1RFU1QgaXMgbm90IHNl
dApDT05GSUdfSEFWRV9ERUJVR19LTUVNTEVBSz15CiMgQ09ORklHX0RFQlVHX0tNRU1MRUFL
IGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfT0JKRUNUUyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NIUklOS0VSX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfU1RBQ0tfVVNBR0Ug
aXMgbm90IHNldAojIENPTkZJR19TQ0hFRF9TVEFDS19FTkRfQ0hFQ0sgaXMgbm90IHNldAoj
IENPTkZJR19ERUJVR19WRlMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19WTSBpcyBub3Qg
c2V0CkNPTkZJR19BUkNIX0hBU19ERUJVR19WSVJUVUFMPXkKIyBDT05GSUdfREVCVUdfVklS
VFVBTCBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19NRU1PUllfSU5JVD15CiMgQ09ORklHX01F
TV9BTExPQ19QUk9GSUxJTkcgaXMgbm90IHNldApDT05GSUdfSEFWRV9BUkNIX0tBU0FOPXkK
Q09ORklHX0hBVkVfQVJDSF9LQVNBTl9WTUFMTE9DPXkKQ09ORklHX0NDX0hBU19LQVNBTl9H
RU5FUklDPXkKQ09ORklHX0NDX0hBU19XT1JLSU5HX05PU0FOSVRJWkVfQUREUkVTUz15CiMg
Q09ORklHX0tBU0FOIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVJDSF9LRkVOQ0U9eQojIENP
TkZJR19LRkVOQ0UgaXMgbm90IHNldAojIGVuZCBvZiBNZW1vcnkgRGVidWdnaW5nCgojIENP
TkZJR19ERUJVR19TSElSUSBpcyBub3Qgc2V0CgojCiMgRGVidWcgT29wcywgTG9ja3VwcyBh
bmQgSGFuZ3MKIwojIENPTkZJR19QQU5JQ19PTl9PT1BTIGlzIG5vdCBzZXQKQ09ORklHX1BB
TklDX09OX09PUFNfVkFMVUU9MApDT05GSUdfUEFOSUNfVElNRU9VVD0wCiMgQ09ORklHX1NP
RlRMT0NLVVBfREVURUNUT1IgaXMgbm90IHNldAojIENPTkZJR19ERVRFQ1RfSFVOR19UQVNL
IGlzIG5vdCBzZXQKIyBDT05GSUdfV1FfV0FUQ0hET0cgaXMgbm90IHNldAojIENPTkZJR19X
UV9DUFVfSU5URU5TSVZFX1JFUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfTE9DS1VQ
IGlzIG5vdCBzZXQKIyBlbmQgb2YgRGVidWcgT29wcywgTG9ja3VwcyBhbmQgSGFuZ3MKCiMK
IyBTY2hlZHVsZXIgRGVidWdnaW5nCiMKIyBDT05GSUdfU0NIRURTVEFUUyBpcyBub3Qgc2V0
CiMgZW5kIG9mIFNjaGVkdWxlciBEZWJ1Z2dpbmcKCiMKIyBMb2NrIERlYnVnZ2luZyAoc3Bp
bmxvY2tzLCBtdXRleGVzLCBldGMuLi4pCiMKQ09ORklHX0xPQ0tfREVCVUdHSU5HX1NVUFBP
UlQ9eQojIENPTkZJR19QUk9WRV9MT0NLSU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfTE9DS19T
VEFUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfUlRfTVVURVhFUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0RFQlVHX1NQSU5MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTVVURVhF
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1dXX01VVEVYX1NMT1dQQVRIIGlzIG5vdCBz
ZXQKIyBDT05GSUdfREVCVUdfUldTRU1TIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTE9D
S19BTExPQyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0FUT01JQ19TTEVFUCBpcyBub3Qg
c2V0CiMgQ09ORklHX0RFQlVHX0xPQ0tJTkdfQVBJX1NFTEZURVNUUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0xPQ0tfVE9SVFVSRV9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfV1dfTVVURVhf
U0VMRlRFU1QgaXMgbm90IHNldAojIENPTkZJR19TQ0ZfVE9SVFVSRV9URVNUIGlzIG5vdCBz
ZXQKIyBlbmQgb2YgTG9jayBEZWJ1Z2dpbmcgKHNwaW5sb2NrcywgbXV0ZXhlcywgZXRjLi4u
KQoKIyBDT05GSUdfREVCVUdfSVJRRkxBR1MgaXMgbm90IHNldApDT05GSUdfU1RBQ0tUUkFD
RT15CiMgQ09ORklHX1dBUk5fQUxMX1VOU0VFREVEX1JBTkRPTSBpcyBub3Qgc2V0CiMgQ09O
RklHX0RFQlVHX0tPQkpFQ1QgaXMgbm90IHNldAoKIwojIERlYnVnIGtlcm5lbCBkYXRhIHN0
cnVjdHVyZXMKIwojIENPTkZJR19ERUJVR19MSVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVC
VUdfUExJU1QgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TRyBpcyBub3Qgc2V0CiMgQ09O
RklHX0RFQlVHX05PVElGSUVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX01BUExFX1RS
RUUgaXMgbm90IHNldAojIGVuZCBvZiBEZWJ1ZyBrZXJuZWwgZGF0YSBzdHJ1Y3R1cmVzCgoj
CiMgUkNVIERlYnVnZ2luZwojCiMgQ09ORklHX1JDVV9TQ0FMRV9URVNUIGlzIG5vdCBzZXQK
IyBDT05GSUdfUkNVX1RPUlRVUkVfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1JDVV9SRUZf
U0NBTEVfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1JDVV9UUkFDRSBpcyBub3Qgc2V0CiMg
Q09ORklHX1JDVV9FUVNfREVCVUcgaXMgbm90IHNldAojIGVuZCBvZiBSQ1UgRGVidWdnaW5n
CgojIENPTkZJR19ERUJVR19XUV9GT1JDRV9SUl9DUFUgaXMgbm90IHNldAojIENPTkZJR19M
QVRFTkNZVE9QIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfRlVOQ1RJT05fVFJBQ0VSPXkKQ09O
RklHX0hBVkVfRlVOQ1RJT05fR1JBUEhfVFJBQ0VSPXkKQ09ORklHX0hBVkVfRFlOQU1JQ19G
VFJBQ0U9eQpDT05GSUdfSEFWRV9EWU5BTUlDX0ZUUkFDRV9XSVRIX1JFR1M9eQpDT05GSUdf
SEFWRV9GVFJBQ0VfTUNPVU5UX1JFQ09SRD15CkNPTkZJR19IQVZFX1NZU0NBTExfVFJBQ0VQ
T0lOVFM9eQpDT05GSUdfSEFWRV9DX1JFQ09SRE1DT1VOVD15CkNPTkZJR19IQVZFX0JVSUxE
VElNRV9NQ09VTlRfU09SVD15CkNPTkZJR19UUkFDSU5HX1NVUFBPUlQ9eQojIENPTkZJR19G
VFJBQ0UgaXMgbm90IHNldAojIENPTkZJR19TQU1QTEVTIGlzIG5vdCBzZXQKIyBDT05GSUdf
U1RSSUNUX0RFVk1FTSBpcyBub3Qgc2V0CgojCiMgYXJtIERlYnVnZ2luZwojCiMgQ09ORklH
X0FSTV9QVERVTVBfREVCVUdGUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FSTV9ERUJVR19XWCBp
cyBub3Qgc2V0CiMgQ09ORklHX1VOV0lOREVSX0ZSQU1FX1BPSU5URVIgaXMgbm90IHNldApD
T05GSUdfVU5XSU5ERVJfQVJNPXkKQ09ORklHX0FSTV9VTldJTkQ9eQojIENPTkZJR19CQUNL
VFJBQ0VfVkVSQk9TRSBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19VU0VSPXkKIyBDT05GSUdf
REVCVUdfTEwgaXMgbm90IHNldApDT05GSUdfREVCVUdfTExfSU5DTFVERT0ibWFjaC9kZWJ1
Zy1tYWNyby5TIgpDT05GSUdfVU5DT01QUkVTU19JTkNMVURFPSJkZWJ1Zy91bmNvbXByZXNz
LmgiCiMgQ09ORklHX1BJRF9JTl9DT05URVhUSURSIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09S
RVNJR0hUIGlzIG5vdCBzZXQKIyBlbmQgb2YgYXJtIERlYnVnZ2luZwoKIwojIEtlcm5lbCBU
ZXN0aW5nIGFuZCBDb3ZlcmFnZQojCiMgQ09ORklHX0tVTklUIGlzIG5vdCBzZXQKIyBDT05G
SUdfTk9USUZJRVJfRVJST1JfSU5KRUNUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfRkFVTFRf
SU5KRUNUSU9OIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfSEFTX0tDT1Y9eQpDT05GSUdfQ0Nf
SEFTX1NBTkNPVl9UUkFDRV9QQz15CiMgQ09ORklHX0tDT1YgaXMgbm90IHNldApDT05GSUdf
UlVOVElNRV9URVNUSU5HX01FTlU9eQojIENPTkZJR19URVNUX0RIUlkgaXMgbm90IHNldAoj
IENPTkZJR19MS0RUTSBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfTUlOX0hFQVAgaXMgbm90
IHNldAojIENPTkZJR19URVNUX0RJVjY0IGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9NVUxE
SVY2NCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tUUkFDRV9TRUxGX1RFU1QgaXMgbm90IHNl
dAojIENPTkZJR19URVNUX1JFRl9UUkFDS0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfUkJUUkVF
X1RFU1QgaXMgbm90IHNldAojIENPTkZJR19SRUVEX1NPTE9NT05fVEVTVCBpcyBub3Qgc2V0
CiMgQ09ORklHX0lOVEVSVkFMX1RSRUVfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1BFUkNQ
VV9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRPTUlDNjRfU0VMRlRFU1QgaXMgbm90IHNl
dAojIENPTkZJR19URVNUX0hFWERVTVAgaXMgbm90IHNldAojIENPTkZJR19URVNUX0tTVFJU
T1ggaXMgbm90IHNldAojIENPTkZJR19URVNUX0JJVE1BUCBpcyBub3Qgc2V0CiMgQ09ORklH
X1RFU1RfVVVJRCBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfWEFSUkFZIGlzIG5vdCBzZXQK
IyBDT05GSUdfVEVTVF9NQVBMRV9UUkVFIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9SSEFT
SFRBQkxFIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9JREEgaXMgbm90IHNldAojIENPTkZJ
R19URVNUX0xLTSBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfQklUT1BTIGlzIG5vdCBzZXQK
IyBDT05GSUdfVEVTVF9WTUFMTE9DIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9CUEYgaXMg
bm90IHNldAojIENPTkZJR19GSU5EX0JJVF9CRU5DSE1BUksgaXMgbm90IHNldAojIENPTkZJ
R19URVNUX0ZJUk1XQVJFIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9TWVNDVEwgaXMgbm90
IHNldAojIENPTkZJR19URVNUX1VERUxBWSBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfU1RB
VElDX0tFWVMgaXMgbm90IHNldAojIENPTkZJR19URVNUX0tNT0QgaXMgbm90IHNldAojIENP
TkZJR19URVNUX0tBTExTWU1TIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9NRU1DQVRfUCBp
cyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfTUVNSU5JVCBpcyBub3Qgc2V0CiMgQ09ORklHX1RF
U1RfRlJFRV9QQUdFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfT0JKUE9PTCBpcyBub3Qg
c2V0CkNPTkZJR19BUkNIX1VTRV9NRU1URVNUPXkKIyBDT05GSUdfTUVNVEVTVCBpcyBub3Qg
c2V0CiMgZW5kIG9mIEtlcm5lbCBUZXN0aW5nIGFuZCBDb3ZlcmFnZQoKIwojIFJ1c3QgaGFj
a2luZwojCiMgZW5kIG9mIFJ1c3QgaGFja2luZwojIGVuZCBvZiBLZXJuZWwgaGFja2luZwo=


--------------IiVGqNEXBdR9oytAp3x20l1x--
