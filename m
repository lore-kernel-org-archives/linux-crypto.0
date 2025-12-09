Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50363054C7
	for <linux-crypto@vger.kernel.org>; Tue,  9 Dec 2025 19:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765309001; cv=none; b=exqI+qy/TJmtKZO382uDccJZxcxBUQ6O/xkhKPJZopn886MoX4QxO9ftTK0+AYbF+q2OyutKUY1trSvdkJ+IbIHm3ugUZcEhFwF0QQQOU7zTyY8Hoazpkxo3NAazK+PDz2iZSEPLMBcZ9YysP7B53kjYY5Blyl4JVNhh1eRJ8/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765309001; c=relaxed/simple;
	bh=XxkXDA7gnyPd9eZkgVBPV6Ob4QQwfW59MXLLyyVUHWw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To; b=TVUoNa8RgDpZF0CcT8hXjdgxAkRzufeexQzpk9wcYbXenyeHZiB+aJ4B9kRSjUWKxEL3UcCwkpLn97C+nJgCn61JcUar9glGiDr/IE23DbaOA9/D3f8KWpjGIZJ7GQ9OIQimOts/qYj0WAvTnCsL3C77Mx4WyqLh4r0E0x8qS/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com; spf=pass smtp.mailfrom=cknow-tech.com; dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b=m5ketdiI; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b="m5ketdiI"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow-tech.com;
	s=key1; t=1765308994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HKPFIYCR+ZJv7w5p0UHlLNtuIAEwTPk2t63quVSSOzc=;
	b=m5ketdiIJNKB+fbuCFxWvrlW0LPwZG0Qp4xBdp6vNK4Jecp/DeDBGEUPPF+Sie/x7NtTun
	zxYfMpaVt+3VNUwWk29RX/tCsSkxJ7fPE2px69mR1zDNhba4tPwmIfT/mvK/WDfZdJhsWK
	zjDRK93Moh1daU+76XeVmy3Ekx+dBUParH1fKBedC//IbLsHKc53qVct+V/iL8usQpD6ja
	NhBuodiuukKtSL+oZbgnRhzJZOEnpqBUkP656P65Hp8CZN+LvINav6n6AY1HleYUgOoZav
	sqrJm7CkERFqZxwm0lQSnNRr2LuNhRa547x8HF9enj96NryqUOdegaMMH+wvuQ==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 09 Dec 2025 20:36:32 +0100
Message-Id: <DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com>
Subject: ERROR: alg: shash: ghash-neon test failed (wrong result) on test
 vector 1, cfg="init+update+final aligned buffer"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Diederik de Haas" <diederik@cknow-tech.com>
To: <linux-crypto@vger.kernel.org>
X-Migadu-Flow: FLOW_OUT

Hi,

With either 6.18-rc1 or -rc2 I saw the above error in dmesg:
https://paste.sr.ht/~diederik/54ed00a4cdcf5f9285674cf940d53a1ffd7ecc4f
and then the stack trace in the dmesg warnings.

This was on a (Rockchip based) PineTab2 (rk3566) on arm64.
Didn't have time to report it then and then it seems like the error was
gone with 6.18-rc5, so I assumed it was fixed*.

Then I started up an Raspberry Pi 3B+ (also arm64) with Debian's 6.17.9
kernel ... and I saw that error again. I also tried Debian's 6.17.2 and
my own 6.18(.0) kernel and they also showed that error.

So I guess there is an actual problem?
For completeness, the error and warnings (incl stack trace) on 6.17.9:

```
[   21.438404] alg: shash: ghash-neon test failed (wrong result) on test ve=
ctor 1, cfg=3D"init+update+final aligned buffer"
[   21.448906] alg: self-tests for ghash using ghash-neon failed (rc=3D-22)
[   21.448927] ------------[ cut here ]------------
[   21.460059] alg: self-tests for ghash using ghash-neon failed (rc=3D-22)
[   21.460231] WARNING: CPU: 0 PID: 650 at crypto/testmgr.c:5827 alg_test+0=
x92c/0x950
[   21.474266] Modules linked in: ghash_ce gf128mul gcm ccm algif_aead des_=
generic libdes rfcomm algif_skcipher bnep aes_neon_blk md4 algif_hash af_al=
g evdev vc4 snd_soc_hdmi_codec brcmfmac_wcc snd_soc_core btsdio nls_ascii s=
nd_compress brcmfmac microchip nls_cp437 bcm2835_v4l2(C) snd_pcm_dmaengine =
drm_exec brcmutil hci_uart bcm2835_mmal_vchiq(C) drm_display_helper vfat bt=
qca fat videobuf2_vmalloc lan78xx btrtl cfg80211 videobuf2_memops cec video=
buf2_v4l2 phylink btintel rc_core of_mdio btbcm videodev drm_client_lib fix=
ed_phy fwnode_mdio drm_dma_helper snd_bcm2835(C) libphy videobuf2_common sn=
d_pcm bluetooth mdio_bus mc drm_kms_helper snd_timer snd cpufreq_dt soundco=
re ecdh_generic rfkill raspberrypi_cpufreq pwrseq_core ledtrig_default_on b=
cm2835_thermal vchiq(C) pwm_bcm2835 bcm2835_rng leds_gpio pkcs8_key_parser =
drm efi_pstore configfs nfnetlink autofs4 ext4 crc16 mbcache jbd2 crc32c_cr=
yptoapi onboard_usb_dev dwc2 udc_core usbcore sdhci_iproc sdhci_pltfm sdhci=
 bcm2835_wdt usb_common bcm2835 phy_generic i2c_bcm2835
[   21.565523] CPU: 0 UID: 0 PID: 650 Comm: cryptomgr_test Tainted: G      =
   C          6.17.9+deb14-arm64 #1 PREEMPTLAZY  Debian 6.17.9-1
[   21.577700] Tainted: [C]=3DCRAP
[   21.580655] Hardware name: Raspberry Pi 3 Model B Plus Rev 1.3 (DT)
[   21.587014] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   21.594062] pc : alg_test+0x92c/0x950
[   21.597746] lr : alg_test+0x92c/0x950
[   21.601446] sp : ffff800081413d20
[   21.604793] x29: ffff800081413dd0 x28: 0000000000000111 x27: 00000000fff=
fffea
[   21.612030] x26: 0000000000000088 x25: ffffb3112dfa7d48 x24: 00000000fff=
fffff
[   21.621241] x23: 0000000000000089 x22: 000000000104000e x21: ffff0000063=
20e00
[   21.629874] x20: ffffb3112f6d0000 x19: ffffb3112dfa9f48 x18: 00000000000=
00000
[   21.638500] x17: 726f746365762074 x16: ffffb3112d52c1a8 x15: ffffb3112f1=
b45e0
[   21.647115] x14: ffffb3112f0d7480 x13: 00000000000000c0 x12: 00000004ff2=
01560
[   21.655729] x11: 00000000000000c0 x10: 0000000000000d40 x9 : ffffb3112cf=
28078
[   21.664327] x8 : ffff00000575dda0 x7 : 0000000000000004 x6 : 00000000000=
00000
[   21.672936] x5 : 0000000000000000 x4 : ffff00000575d000 x3 : ffff000004a=
d2800
[   21.681520] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000057=
5d000
[   21.690116] Call trace:
[   21.693925]  alg_test+0x92c/0x950 (P)
[   21.698952]  cryptomgr_test+0x2c/0x58
[   21.703972]  kthread+0x148/0x240
[   21.708535]  ret_from_fork+0x10/0x20
[   21.713440] ---[ end trace 0000000000000000 ]---
```

Hopefully this'll tell you where the (likely) problem is at.

Cheers,
  Diederik

*) Reading my own comment from that paste ... I possibly switched to an
'rkbin' based U-Boot and that's why I didn't see it anymore
