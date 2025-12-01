Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4820A36D507
	for <linux-crypto@vger.kernel.org>; Mon,  1 Dec 2025 05:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764567587; cv=none; b=awq413/tJZwlNM4n8dywiC6yklNCKrC9K1HGEsZLbaO1P51iH5J9wJsb21zTSA5Q1BLKPdaVIVM4MY3qD7QTx3XL6XhhCiNdvabVYJybEKwGI9FdRaFavHB97JhJhDAI8YGkTMm68t3LhLMIG7brdVvoXF0hDg8Q8QlTQTL6QDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764567587; c=relaxed/simple;
	bh=Ao2BeZssoMFg0fnlF9J+ILrtBVo0HwPaumkMPOkL/YY=;
	h=Message-ID:Date:MIME-Version:Subject:References:To:Cc:From:
	 In-Reply-To:Content-Type; b=G9UOOc9GUAHFK5pFyNbl5Xw03tq/l+9f/ApUtZPsP8xPkqcKI8R1+iv9KWXI5ChjZjPYMjTp5DoU+Y720cGXHTjcAMhvF8/4jnsKBqMzINH/nRDWFGwRvXkcGT4FrqmDIZUz2r8hJMjKFmjugVNsj3/pHObSr48UhsGIKPhKIi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=THjiOg6P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="THjiOg6P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:Cc:To:References:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=HV19tRtEDdfrqeX2iUSZivHIZ2UHhEEW9OIHSsaAK9E=; b=THjiOg6Pz43c7QhbPky2TyNvOq
	OKY699e1zK0K9fwsggDfCpNU2+QspGM3OmfdyLl2brUauG5UZwHCee3dYcaBltcuy2jtAU/J6iV1t
	NcXhjH42TowXaXRzBuMyg7ObCms6xNalMcA7pHu9B/nAjaXYx9UImq4LllT+gjugOmkwrJrZAhJPX
	FMQQx6TtgbmokKve8ikOPWIpgwN64TJt5MPEdq8NciAKTB5KOvLqO0+dXmxIbMXX2eUgbidPX1zul
	m5AkIrrbczcIC/L/OMfPUNnrbrsBI2jrlvxBTZZEPtEAWTcGDX9P/qQJGT/3yWVTJPc/hfToTBIKp
	II50PN8Q==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vPwdR-00000002wCy-2h1N;
	Mon, 01 Dec 2025 05:39:41 +0000
Message-ID: <db554bca-4d85-4243-9f38-bdbaa48cd080@infradead.org>
Date: Sun, 30 Nov 2025 21:39:41 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?RndkOiBbUkVHUkVTU0lPTl0gbmV4dC9tYXN0ZXI6IChidWlsZCkg4oCY?=
 =?UTF-8?Q?sev=5Ftio=5Fpresent=E2=80=99_defined_but_not_used_=5B-Werror=3Dun?=
 =?UTF-8?Q?used-function=5D_i=2E=2E=2E?=
References: <176456514339.2642.17409010068566138864@1ece3ece63ba>
Content-Language: en-US
To: Linux Crypto List <linux-crypto@vger.kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <176456514339.2642.17409010068566138864@1ece3ece63ba>
X-Forwarded-Message-Id: <176456514339.2642.17409010068566138864@1ece3ece63ba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.


I haven't looked at the kernel config, but it must be when
CONFIG_PCI_TSM is not set/enabled.


-------- Forwarded Message --------
Subject: [REGRESSION] next/master: (build) ‘sev_tio_present’ defined but not used [-Werror=unused-function] i...
Date: Mon, 01 Dec 2025 04:59:03 -0000
From: KernelCI bot <bot@kernelci.org>
Reply-To: kernelci@lists.linux.dev
To: kernelci-results@groups.io
CC: regressions@lists.linux.dev, gus@collabora.com, linux-next@vger.kernel.org





Hello,

New build issue found on next/master:

---
 ‘sev_tio_present’ defined but not used [-Werror=unused-function] in drivers/crypto/ccp/sev-dev.o (drivers/crypto/ccp/sev-dev.c) [logspec:kbuild,kbuild.compiler.error]
---

- dashboard: https://d.kernelci.org/i/maestro:ce1c65862af14252fd16691d2f1397e0a5827d32
- giturl: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
- commit HEAD:  95cb2fd6ce0ad61af54191fe5ef271d7177f9c3a
- tags: next-20251201

Please include the KernelCI tag when submitting a fix:

Reported-by: kernelci.org bot <bot@kernelci.org>


Log excerpt:
=====================================================
drivers/crypto/ccp/sev-dev.c:1361:13: error: ‘sev_tio_present’ defined but not used [-Werror=unused-function]
 1361 | static bool sev_tio_present(struct sev_device *sev)
      |             ^~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
  AR      drivers/firmware/psci/built-in.a
  CC      drivers/crypto/ccp/tee-dev.o

=====================================================


# Builds where the incident occurred:

## cros://chromeos-6.12/x86_64/chromeos-amd-stoneyridge.flavour.config+lab-setup+x86-board+CONFIG_MODULE_COMPRESS=n+CONFIG_MODULE_COMPRESS_NONE=y on (x86_64):
- compiler: gcc-14
- config: https://files.kernelci.org/kbuild-gcc-14-x86-chromeos-amd-692d0f81f5b8743b1f6e0fde/.config
- dashboard: https://d.kernelci.org/build/maestro:692d0f81f5b8743b1f6e0fde


#kernelci issue maestro:ce1c65862af14252fd16691d2f1397e0a5827d32

--
This is an experimental report format. Please send feedback in!
Talk to us at kernelci@lists.linux.dev

Made with love by the KernelCI team - https://kernelci.org


-- 
~Randy
