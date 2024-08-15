Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDCC1AC893
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 14:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732820; cv=none; b=hs47HmlF+STrnbI/h4JXm7lNAWtY3+KGz8Y2D1MmbL3B1CB7chu2f7+Rqbw/HeGu6XTbYtv4IE7ibekP24CObSSni18oqHo/S1veWd4PbwvY+E4mU/Y8KMkI4uAksiR/YplWJ6Z7awxB82pJY6oY1Qv+YxuI/m1sNhD0W0Lu0VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732820; c=relaxed/simple;
	bh=4teuLtYDK/NduiMm78ToqkmlCTNP4Jc/piX9A+gso9E=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=uemIRQ748woOVXJ1Os12rIbBOKDXllFmPGItCP239eKDK6RC5TlU5oj1wZFI78DGm6sBSNu4qIJt+1A4Jq48qFVDwAE1poBhVw7hXOtcRmp3Xxq12V6aF5oQ0v+k372rEzVEt54MgRGtwcmZp9Jf1i7TYsefW3sY8S62sO+beMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=RWEr4V9X; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="RWEr4V9X"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1723732813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xCgJk3wklCJ3udB8OxbmwoYBHrKfJfS5s1g5mdRMNjw=;
	b=RWEr4V9X+mYYAfH6j1QX2hlg+uROiiJMlyglz+4k8uTju1allTILEjATWypspPmbRRzPll
	BOQLmoVWpUZrdM7frweg0Ezvw+KR3e9LscLGXUoINarx1Jo5Y5gKKSSyGw+02g7VjSAhAz
	fIaGHQ1Aewv74T/79eTFn5VCt7IDs1eJys4FOodPuJP2M46TEgEEdmXIkZGG7rpzrspyJq
	jVDVYDldpoIQl0uDLuXsRIrv+Vlz4aIdwMEiqFNlTHnh6voIzwVx4AlF1Pn9MhyJUawL1p
	lnfU8WIrILWaODnYFLcQCK7JcEJtjhk5L33YLC5c7VshLLG1VeNjaQ22XqHszg==
Content-Type: multipart/signed;
 boundary=3037502820252a8e373d9f5ea1cd733f34fb66a0aeb8c2eb17ced4220e3b;
 micalg=pgp-sha256; protocol="application/pgp-signature"
Date: Thu, 15 Aug 2024 16:40:03 +0200
Message-Id: <D3GKA618AGIM.36RB2FW9Z21JE@cknow.org>
To: "Tom Lendacky" <thomas.lendacky@amd.com>, "John Allen"
 <john.allen@amd.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Diederik de Haas" <didi.debian@cknow.org>
Subject: Re: [BUG] Non working HWRNG on AMD Ryzen 5 5500GT
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Diederik de Haas" <didi.debian@cknow.org>
References: <D3GJCRNY4KDK.3SPJB5WP8Z7DK@cknow.org>
 <0561862d-99d9-ae72-49d0-9ad0639482ea@amd.com>
In-Reply-To: <0561862d-99d9-ae72-49d0-9ad0639482ea@amd.com>
X-Migadu-Flow: FLOW_OUT

--3037502820252a8e373d9f5ea1cd733f34fb66a0aeb8c2eb17ced4220e3b
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Aug 15, 2024 at 4:16 PM CEST, Tom Lendacky wrote:
> On 8/15/24 08:56, Diederik de Haas wrote:
> > I recently bought an Asus ROG STRIX B550-F GAMING MB with an
> > AMD Ryzen 5 5500GT CPU (and installed the latest BIOS: 3607).
> > I'm running Debian Testing/Sid on it with kernel 6.9 and now 6.10
> > and it seems to work great.
> > I've been doing some (unrelated) tests with `rngtest` from the
> > `rng-tools5` package and wondered how it would fare on my AMD CPU.
>
> I'm not very familiar with this test. What is the command line that you
> are using to invoke it?

```
root@cs04:~# cat /dev/hwrng | rngtest -c 1000
rngtest 5
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
cat: /dev/hwrng: No such device
rngtest: entropy source drained
```

Or when using ``dd`` you'd get a similar output:

```
root@cs04:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
rngtest 5
...

rngtest: starting FIPS tests...
dd: error reading '/dev/hwrng': No such device
0+0 records in
0+0 records out
rngtest: entropy source drained
0 bytes copied, 4.8214e-05 s, 0.0 kB/s
``

Debian package page: https://packages.debian.org/unstable/rng-tools5
Debian hasn't switched to the new upstream (yet?), but that can be found
here: https://github.com/nhorman/rng-tools

> > And I found out it doesn't work at all!
> > But on another system I have (Asus ROG CROSSHAIR VII HERO MB +
> > AMD Ryzen 1800X CPU) it works absolutely fine.
> > 
> > # dmesg | grep ccp
> > [    5.399853] ccp 0000:07:00.2: ccp: unable to access the device: you might
> > be running a broken BIOS.
> > [    5.401031] ccp 0000:07:00.2: tee enabled
> > [    5.401113] ccp 0000:07:00.2: psp enabled
>
> Which system is this output from?

My new system ("cs04") with AMD Ryzen 5 5500GT CPU/APU.

> Can you provide the output from lspci -nn?

```
root@cs04:~# lspci -nn
00:00.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne Root Complex [1022:1630]
00:00.2 IOMMU [0806]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne IOMMU [1022:1631]
00:01.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge [1022:1632]
00:02.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge [1022:1632]
00:02.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne PCIe GPP Bridge [1022:1634]
00:02.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne PCIe GPP Bridge [1022:1634]
00:08.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge [1022:1632]
00:08.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir Internal PCIe GPP Bridge to Bus [1022:1635]
00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller [1022:790b] (rev 51)
00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge [1022:790e] (rev 51)
00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 0 [1022:166a]
00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 1 [1022:166b]
00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 2 [1022:166c]
00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 3 [1022:166d]
00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 4 [1022:166e]
00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 5 [1022:166f]
00:18.6 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 6 [1022:1670]
00:18.7 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 7 [1022:1671]
01:00.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] 500 Series Chipset USB 3.1 XHCI Controller [1022:43ee]
01:00.1 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] 500 Series Chipset SATA Controller [1022:43eb]
01:00.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 500 Series Chipset Switch Upstream Port [1022:43e9]
02:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
02:08.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
02:09.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
05:00.0 Ethernet controller [0200]: Intel Corporation Ethernet Controller I225-V [8086:15f3] (rev 03)
06:00.0 Non-Volatile memory controller [0108]: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO [144d:a80a]
07:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Cezanne [Radeon Vega Series / Radeon Vega Mobile Series] [1002:1638] (rev c9)
07:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Renoir Radeon High Definition Audio Controller [1002:1637]
07:00.2 Encryption controller [1080]: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 10h-1fh) Platform Security Processor [1022:15df]
07:00.3 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne USB 3.1 [1022:1639]
07:00.4 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne USB 3.1 [1022:1639]
07:00.6 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] Family 17h/19h HD Audio Controller [1022:15e3]
```

Cheers,
  Diederik

> Thanks,
> Tom
>
> > 
> > Found an article [1] which could be relevant and downloaded and ran the
> > accompanying test program (written by Jason Donenfeld):
> > # ./amd-rdrand-bug
> > Your RDRAND() does not have the AMD bug.
> > # ./test-rdrand
> > RDRAND() =x47c993c0
> > RDRAND() =xec7c697d
> > ... (more seemingly random numbers)
> > RDRAND() =xba858101
> > 
> > I tried it with the latest microcode dd 2024-07-10, but that didn't make
> > a difference.
> > 
> > So I'd like to know if this may actually be a bug on the kernel side.
> > 
> > Happy to provide additional information or run tests or try patches.
> > 
> > Cheers,
> >   Diederik
> > 
> > [1] https://arstechnica.com/gadgets/2019/10/how-a-months-old-amd-microcode-bug-destroyed-my-weekend/


--3037502820252a8e373d9f5ea1cd733f34fb66a0aeb8c2eb17ced4220e3b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZr4TRQAKCRDXblvOeH7b
bpiZAPwLFmFNu5AedNwOWct9y6v76V6cREhsJr0BGn+uKrDuwQD/cPb6glShnK2b
k4HMVf3p6PVIM9qzw3L7RNhNG7oAyAc=
=pXjB
-----END PGP SIGNATURE-----

--3037502820252a8e373d9f5ea1cd733f34fb66a0aeb8c2eb17ced4220e3b--
