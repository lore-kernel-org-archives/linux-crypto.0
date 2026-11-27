Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795754847;
	b=VJgmGWPsYjEEAXgYSfajC0z7VI/JhcZe4Z/8tk+wQ9sI/OgqveyEt698IwqD73W0Ek+F
	 lMRnU8Q6KuqKwk0Ct6p51xM3XQDXy1HZjzW2nsX4Dd/Y8S95hXnqz6JzTbjB3CAjgSfZ4
	 8YxRMTKdSvDswXQTgKCO6d4++FSedKR3MrP7pNQ9+ZknP/k1Ydl+m9932XjIBmiAybz6p
	 d7NieXVNzmGWijfy2fBKH2W/7j3cPo4H00Z2gfRP921W7cIl4ziAlVsOQ6mNMzFY9UY1l
	 xaW5f41qfryuDOvXZhpsdxxnwalM8ZuwX3M1/UmOqPbFs1C2gW6dh3s8B32I7Tq6/Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795754847;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=cLk6wMlnDdE3g4ZXcc50MUMtekz7+zCR2k+er2JNUzc=;
	b=U0xfg2yG+R8Rn6MF7GtlJMVBUy9IiA3Ehklnly+sn9nf/psPa3NZL13tM1bdlQCJdYE7
	 Z6IA4kOAHAa/3DuxlQ+oWUQAkL4GWYhdmGeaU/lHzRpX0UA8fRZvdDa8l/wIHPOcV3Xcr
	 Vn0IdJM6NyyUo7nf4Kqt/igTDE5IgxAlI41S2Fq272VzZx20JmlzGE8fuJLwXlnjOMZp/
	 dSkggF0I0UgF+uyjqMeGSYTgugbyj3TQRvdmBYzoUTJFmjCuWxYAxkwAKA77U+nCA/Spe
	 CX+7gQdunAjr3VJwNV/CzghQ+9pS2wTmG5sGCRgYqrFegWxNlSJAFYSXDiKp4Yag1QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=i83K4lDS;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA197606A32F;
	Fri, 27 Nov 2026 04:47:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA197606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=i83K4lDS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=cLk6wMlnDdE3g4ZXcc50MUMtekz7+zCR2k+er2JNUzc=; 
	b=i83K4lDSWMooFqiBxnncDmx78GZ/PzPOZJAqpV4wgyKlGS/tzOldIl990PmZM+MrsFv1f0R7GWT
	M2VYgDwPh9lDA1l1Ze+wVll83vVC892+4lbdlQWPo7i2XUqumFRZY+Y1KvC73Uy9SM0LQ+mJDm7Gg
	uecgOyjpAwpOotCjIg6YzZxZ/FEhDfp4nJlIJmzPn/WzxIF75EVjEXn72mdh6G1g+r0FDlHQZV38l
	rR1uE93FhI25kINoqFIhXtPHrXAYwETl1LEjmuoO5+90fWBs8fSAJuX5+cqrRCBznoofYqt5RdYat
	erYdybmUDOXZUhrAU1mHv10PCn8NnUIaq0cQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWnrY-00000002VG0-2kCJ;
	Fri, 27 Nov 2026 12:47:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 12:47:08 +0800
Date: Fri, 27 Nov 2026 12:47:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: hang.suan.wang@altera.com
Cc: Dinh Nguyen <dinguyen@kernel.org>, linux-kernel@vger.kernel.org,
	Olivia Mackall <olivia@selenic.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	linux-crypto@vger.kernel.org,
	muhammad.nazim.amirul.nazle.asmade@altera.com,
	tze.yee.ng@altera.com, chee.nouk.phoon@altera.com,
	genevieve.chan@altera.com, adrian.ho.yin.ng@altera.com
Subject: Re: [PATCH v1 0/2] Add FCS Random Number Generator (RNG) driver
Message-ID: <awkLTH9XLvWLBjdJ@gondor.apana.org.au>
References: <cover.1795167624.git.hang.suan.wang@altera.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1795167624.git.hang.suan.wang@altera.com>

On Fri, Nov 20, 2026 at 01:51:31AM -0800, hang.suan.wang@altera.com wrote:
> From: Hang Suan Wang <hang.suan.wang@altera.com>
> 
> This series adds a hw_random front-end for the random-number service of
> the Altera SoCFPGA Crypto Service (FCS).
> 
> The driver owns no session or service-layer state: every request goes
> through the FCS core, which serializes access to the SDM crypto session
> and forwards it to the SDM through ATF.
> 
> The SDM is the hardware security controller in Altera SoCFPGA devices. Host
> software reaches it through the existing stratix10-svc mailbox, which uses
> Arm Trusted Firmware SIP SMC calls.
> 
> The Agilex FPGA series generator is an SP 800-90A compliant DRNG hardware
> block in the SDM, in particular, Agilex 7 is SP 800-90A compliant DRBG
> generation flow and is seeded with the TRNG hardware block.
> 
> Unlike existing hw_random drivers, this RNG produces data only while an
> SDM crypto session is open (for example, via FCS_IOC_OPEN_SESSION on
> /dev/socfpga-fcs). The session belongs to the file that opened it, not
> to this driver. With no session open, socfpga_fcs_core_engine() returns
> -ENOTCONN and the error is passed through unchanged: read() on
> /dev/hwrng fails with that error, and the hw_random entropy thread treats
> it as a transient failure and retries. The open and close session ioctl
> was added in the previous series:
> https://lore.kernel.org/all/179492434088.3111216.6016447945055810112.b4-ty@kernel.org/
> 
> The ATF accepts only a non-zero, 4-byte-aligned length, from 4 bytes up
> to 4080 bytes per request.
> 
> hwrng.quality is left at 0. The hw_random core documents 0 as the maximum
> (1024 bits of entropy per 1024 bits of input), and with the default
> quality of 1024 that is the value applied at registration. That matches
> a conditioned SP 800-90A DRNG, so the driver does not publish a separate
> estimate.
> 
> The series is organized as follows:
> Patch 1 (prerequisite) extends the stratix10-svc service layer with the
> FCS command codes and matching SIP SMC function IDs.
> 
> Patch 2 adds the RNG driver: socfpga-fcs-rng hw_random driver. Add
> FCS_DEV_RANDOM_NUMBER_GEN_EXT in the FCS core. The socfpga-fcs-rng child
> device registered by the FCS driver. Also, add MAINTAINERS entry for
> this new driver.
> 
> Testing:
> Built for arm64 (defconfig + CONFIG_HW_RANDOM_SOCFPGA_FCS=m).
> Tested on an Agilex 5 SoC FPGA board
> root@testsocfpga# ./fcs_client -R dbg.bin -j 64 && hexdump -C dbg.bin
> 00000000 15 fc 77 a9 86 17 0b b5 91 b3 db ce a9 39 48 f1 |..w..........9H.|
> 00000010 65 00 80 9a 63 b8 1e 99 df 56 6f b4 ef 66 73 f9 |e...c....Vo..fs.|
> 00000020 91 66 c6 94 94 38 f1 9f cd 3a c7 6e b1 63 1d e2 |.f...8...:.n.c..|
> 00000030 03 ec 29 01 4f 27 4a de e7 7e 67 95 c2 44 e7 04 |..).O'J..~g..D..|
> 00000040
> 
> Set timeout to 1000s for operation: rngtest
> cat /dev/hwrng | rngtest -c 2000 2>&1
> rngtest 6.17
> Copyright (c) 2004 by Henrique de Moraes Holschuh
> This is free software; see the source for copying conditions. There is NO 
> warranty;
> not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> 	rngtest: starting FIPS tests...
> 	rngtest: bits received from input: 40000032
> 	rngtest: FIPS 140-2 successes: 1998
> 	rngtest: FIPS 140-2 failures: 2
> 	rngtest: FIPS 140-2(2001-10-10) Monobit: 0
> 	rngtest: FIPS 140-2(2001-10-10) Poker: 0
> 	rngtest: FIPS 140-2(2001-10-10) Runs: 1
> 	rngtest: FIPS 140-2(2001-10-10) Long run: 1
> 	rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> 	rngtest: input channel speed: (min=495.429; avg=52178.721; 
> 								   max=10000000000.000)bits/s
> 	rngtest: FIPS tests speed: (min=47.329; avg=70.926; max=91.699)Mibits/s
> 	rngtest: Program run time: 807497698 microseconds
> 
> ---
> Hang Suan Wang (2):
>   firmware: stratix10-svc: add FCS random-number command for Agilex 5
>   hwrng: socfpga-fcs - Add FCS random number generator driver
> 
>  MAINTAINERS                                   |   1 +
>  drivers/char/hw_random/Kconfig                |  12 ++
>  drivers/char/hw_random/Makefile               |   1 +
>  drivers/char/hw_random/socfpga-fcs-rng.c      | 133 ++++++++++++++++++
>  drivers/firmware/socfpga-fcs-core.c           |  71 +++++++---
>  drivers/firmware/socfpga-fcs.c                |  33 +++++
>  drivers/firmware/stratix10-svc.c              |   8 ++
>  include/linux/firmware/intel/socfpga-fcs.h    |  23 ++-
>  include/linux/firmware/intel/stratix10-smc.h  |  46 ++++++
>  .../firmware/intel/stratix10-svc-client.h     |   1 +
>  10 files changed, 300 insertions(+), 29 deletions(-)
>  create mode 100644 drivers/char/hw_random/socfpga-fcs-rng.c
> 
> -- 
> 2.43.7

Sashiko failed to apply your patches.  Please rebase and resubmit;

https://sashiko.dev/#/patchset/cover.1795167624.git.hang.suan.wang%40altera.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
