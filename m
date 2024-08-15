Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEC51AAE30
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 15:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723735358; cv=none; b=o8MpP2AjWF+AnV9breUeJ4qY/seeAsc9RLynw7AY3JbUfUMvXmpgdoKvQ94lj9ErT61DO0mO3fGONbtz3KAByx4ZtyDkIWWrO9X1nmZm/7+74uBiFZlCKm5SQKhaf6dfUZW/A4HoFRthzCKjVkPg3JAfOr7co5slb+Dzw9VxJlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723735358; c=relaxed/simple;
	bh=KRCwhWDiYwpuY5DNHvGmYe0yh8DFD1b3wE/18aSVyoM=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=SUSKcOpivY1TibDTSMJlWFldF7STHFyts9D8PzXbUZLMbr+cXtujgj4Gf5Sl1pBJhkZuAVGusVi8yDZ/RHl8JF8CGZd9fnEFC44oC9KKVovoxbVUldwF9hJjJRsUA9Ujzico/DpNb8PtaLkNjQp3S+3HubmcCmDMjYIBOa+xgrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=mpmXRhhS; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="mpmXRhhS"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1723735354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BkYaxMIDyjPbRKPJjFclx8OLruH7kDK8kaUmSDlRYQ0=;
	b=mpmXRhhSOZyUbGHALlrkg/uhF2Ri8R7ukAqUKY/pZNeueWFF5IRXAhwVrS1Xil29L1spWY
	dj/WQj5a7ZbXeWrAc+uSfbEXEY2In/peitMwJ7rpOYJGCuLuOLtoBFEvvRvsPjBohAZnc1
	7AdUZqIRJ1t+Pz4AsfYGkJaRKmnk3vDfI1MWdyUIUtvtCXauQ0YYWx0eEEjij11NzoyWTd
	UJzQ4grvLJw/WNl2F44uB6Vc826O3NkGRGGqaytFzpCre1STrRnRy+trf2ZO6SCYcWSh3y
	XABfR0CVRMIIXM76i2SvJu0tVnmVt2gPmrpQ5oMWg1A2X7cMlLACm/4W9hj91Q==
Content-Type: multipart/signed;
 boundary=46c1c037275f03f2aa34648b4ba24c14d8c1b470dfe1613910c8a939e26d;
 micalg=pgp-sha256; protocol="application/pgp-signature"
Date: Thu, 15 Aug 2024 17:22:16 +0200
Message-Id: <D3GL6HTEHTEZ.1HKTPS9XG9QMI@cknow.org>
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
 <D3GKA618AGIM.36RB2FW9Z21JE@cknow.org>
 <c28836c4-e823-dc36-e753-1a5ee3831629@amd.com>
In-Reply-To: <c28836c4-e823-dc36-e753-1a5ee3831629@amd.com>
X-Migadu-Flow: FLOW_OUT

--46c1c037275f03f2aa34648b4ba24c14d8c1b470dfe1613910c8a939e26d
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Aug 15, 2024 at 4:53 PM CEST, Tom Lendacky wrote:
> On 8/15/24 09:40, Diederik de Haas wrote:
> > On Thu Aug 15, 2024 at 4:16 PM CEST, Tom Lendacky wrote:
> >> On 8/15/24 08:56, Diederik de Haas wrote:
> >>> I recently bought an Asus ROG STRIX B550-F GAMING MB with an
> >>> AMD Ryzen 5 5500GT CPU (and installed the latest BIOS: 3607).
> >>> I'm running Debian Testing/Sid on it with kernel 6.9 and now 6.10
> >>> and it seems to work great.
> >>> I've been doing some (unrelated) tests with `rngtest` from the
> >>> `rng-tools5` package and wondered how it would fare on my AMD CPU.
> >>
> >> I'm not very familiar with this test. What is the command line that you
> >> are using to invoke it?
> > 
> > ```
> > root@cs04:~# cat /dev/hwrng | rngtest -c 1000
> > rngtest 5
> > Copyright (c) 2004 by Henrique de Moraes Holschuh
> > This is free software; see the source for copying conditions.
> > There is NO warranty; not even for MERCHANTABILITY or FITNESS
> > FOR A PARTICULAR PURPOSE.
> > 
> > rngtest: starting FIPS tests...
> > cat: /dev/hwrng: No such device
> > rngtest: entropy source drained
>
> Ok, this makes sense since you are using /dev/hwrng. This device does
> not exist because the CCP support in the ccp driver did not create one.
> It appears that the BIOS has blocked access to the MMIO range for the
> CCP so that during initialization, when attempting to read the number of
> queues available, 0xffffffff is read instead of the actual number of
> queues available, which as Jason noted, results in the "broken BIOS"
> message.

Ok, so the BIOS is broken. Good to know. Thanks :)

> This may not matter, though. I don't know if this version of the ASP/CCP
> device (1022:15df) provides any queues to the OS to use.

But I don't know how to interpret this?

I initially contacted Asus (HQ) and they apparently had contact with AMD
about this. I was 'a bit' flabbergasted about the response though:

"We have confirmed with AMD that the Linux system supported by the customer's
CPU (AMD Ryzen 5 5500GT) is Ubuntu:20.04.x.
The corresponding Linux Kernel version is between 5.4 and 5.8, and the
customer's OS version is Linux Kernel version: 6.9.10.
The CPU is not supported."

I have no idea how Ubuntu 20.04 and kernel 5.4 got into that communication
as I clearly said I tested it with Debian and kernel 6.9 and 6.10.
Basically the same as here, except more extensive/detailed.

> The fact that there is no /dev/hwrng device is not a kernel bug, though.
>
> Thanks,
> Tom

Thanks for the responses, much appreciated :-)

Cheers,
  Diederik

> > ```
> > 
> > Or when using ``dd`` you'd get a similar output:
> > 
> > ```
> > root@cs04:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> > rngtest 5
> > ...
> > 
> > rngtest: starting FIPS tests...
> > dd: error reading '/dev/hwrng': No such device
> > 0+0 records in
> > 0+0 records out
> > rngtest: entropy source drained
> > 0 bytes copied, 4.8214e-05 s, 0.0 kB/s
> > ``
> > 
> > Debian package page: https://packages.debian.org/unstable/rng-tools5
> > Debian hasn't switched to the new upstream (yet?), but that can be found
> > here: https://github.com/nhorman/rng-tools
> > 
> >>> And I found out it doesn't work at all!
> >>> But on another system I have (Asus ROG CROSSHAIR VII HERO MB +
> >>> AMD Ryzen 1800X CPU) it works absolutely fine.
> >>>
> >>> # dmesg | grep ccp
> >>> [    5.399853] ccp 0000:07:00.2: ccp: unable to access the device: you might
> >>> be running a broken BIOS.
> >>> [    5.401031] ccp 0000:07:00.2: tee enabled
> >>> [    5.401113] ccp 0000:07:00.2: psp enabled
> >>
> >> Which system is this output from?
> > 
> > My new system ("cs04") with AMD Ryzen 5 5500GT CPU/APU.
> > 
> >> Can you provide the output from lspci -nn?
> > 
> > ```
> > root@cs04:~# lspci -nn
> > 00:00.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne Root Complex [1022:1630]
> > 00:00.2 IOMMU [0806]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne IOMMU [1022:1631]
> > 00:01.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge [1022:1632]
> > 00:02.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge [1022:1632]
> > 00:02.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne PCIe GPP Bridge [1022:1634]
> > 00:02.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne PCIe GPP Bridge [1022:1634]
> > 00:08.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge [1022:1632]
> > 00:08.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir Internal PCIe GPP Bridge to Bus [1022:1635]
> > 00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller [1022:790b] (rev 51)
> > 00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge [1022:790e] (rev 51)
> > 00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 0 [1022:166a]
> > 00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 1 [1022:166b]
> > 00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 2 [1022:166c]
> > 00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 3 [1022:166d]
> > 00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 4 [1022:166e]
> > 00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 5 [1022:166f]
> > 00:18.6 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 6 [1022:1670]
> > 00:18.7 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 7 [1022:1671]
> > 01:00.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] 500 Series Chipset USB 3.1 XHCI Controller [1022:43ee]
> > 01:00.1 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] 500 Series Chipset SATA Controller [1022:43eb]
> > 01:00.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 500 Series Chipset Switch Upstream Port [1022:43e9]
> > 02:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
> > 02:08.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
> > 02:09.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
> > 05:00.0 Ethernet controller [0200]: Intel Corporation Ethernet Controller I225-V [8086:15f3] (rev 03)
> > 06:00.0 Non-Volatile memory controller [0108]: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO [144d:a80a]
> > 07:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Cezanne [Radeon Vega Series / Radeon Vega Mobile Series] [1002:1638] (rev c9)
> > 07:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Renoir Radeon High Definition Audio Controller [1002:1637]
> > 07:00.2 Encryption controller [1080]: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 10h-1fh) Platform Security Processor [1022:15df]
> > 07:00.3 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne USB 3.1 [1022:1639]
> > 07:00.4 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne USB 3.1 [1022:1639]
> > 07:00.6 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] Family 17h/19h HD Audio Controller [1022:15e3]
> > ```
> > 
> > Cheers,
> >   Diederik
> > 
> >> Thanks,
> >> Tom
> >>
> >>>
> >>> Found an article [1] which could be relevant and downloaded and ran the
> >>> accompanying test program (written by Jason Donenfeld):
> >>> # ./amd-rdrand-bug
> >>> Your RDRAND() does not have the AMD bug.
> >>> # ./test-rdrand
> >>> RDRAND() =7c993c0
> >>> RDRAND() =c7c697d
> >>> ... (more seemingly random numbers)
> >>> RDRAND() =a858101
> >>>
> >>> I tried it with the latest microcode dd 2024-07-10, but that didn't make
> >>> a difference.
> >>>
> >>> So I'd like to know if this may actually be a bug on the kernel side.
> >>>
> >>> Happy to provide additional information or run tests or try patches.
> >>>
> >>> Cheers,
> >>>   Diederik
> >>>
> >>> [1] https://arstechnica.com/gadgets/2019/10/how-a-months-old-amd-microcode-bug-destroyed-my-weekend/
> > 


--46c1c037275f03f2aa34648b4ba24c14d8c1b470dfe1613910c8a939e26d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZr4dLAAKCRDXblvOeH7b
bnAZAQCnjOh21bEdvlfiWFV3iKmq7Z8y9MiTQOAqgUZDEz/6UQD+P4yZCHp/7xzv
0PV3kyGi/4mFs42AduB5nofNWXxRSgo=
=z3IY
-----END PGP SIGNATURE-----

--46c1c037275f03f2aa34648b4ba24c14d8c1b470dfe1613910c8a939e26d--
