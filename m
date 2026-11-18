Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021699;
	b=YBaCcSzx/AV6jgYERdpToHHQU9ZewCrMltkuAG5NUU2oPtIO7w3Ied5SxeTxHA/e9HUE
	 4VNcvhtaVsI4vukc3CUgGCaXqnKQlOPIMoPSXyHcgLvixgcQTFPvg++SjDBsoYZp5nRYq
	 AWHrTtv/E2MOs92M53uL8p7nXF05pvasENFVjWIJNSXjscaAuLJhyDdkysVLZ7PFPaI4G
	 FrnDizpQoXejZEk1q/2Eay/6i+hIgh7+Igvy3PsFv/qaU5dcvW0sJ8HYUWLla/EPWTGHK
	 FaSJE2FzHd0Zr19E8uBybxqhvBIoqB+BlRHaT8bjUaWhZ7qfavSLxir93Y7W4fIdHNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021699;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=7azEG4KUAyB1sP7mjOcSqRsl7y5AO0uY6cBUlzfxq4A=;
	b=3Y2XwZ8SzBIE4yqIAJCOxiba2Yw+Af5d34dNERSNOY9RKQ4Vlgiht5X6BQWJowv2fG9p
	 fcAu/8hve/IVp4hsFW6HEeu1xNfB4VheFC2VB+4iiwvWnkaEWUAE0m12rPMLKiVBp0UN+
	 SYlj3/rTKge+aJtsMEc1aTOVcDN/x434mFfePRt/pehzjv3q6cgMFyTa7ec/KFIgSim00
	 bLl5/xe1wzqNatmTKHEqO62ABM2gRIMIL4Dhnr3+kzbbZ/yz1vOhDyuQh3WouEslBG6FZ
	 hWek6w+pv/pBnoLKZGaGozhV837yq5uyh8SnU6ZpbTqw4C5i5S7EHMW/wcMvs1349Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YzLiQr3N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8710F606A32C;
	Wed, 18 Nov 2026 17:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YzLiQr3N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E581F000C5;
	Wed, 18 Nov 2026 17:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795021699;
	bh=7azEG4KUAyB1sP7mjOcSqRsl7y5AO0uY6cBUlzfxq4A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=YzLiQr3NKs/FdPe9YkBNn2yrMmEl9lA5sDBWfGqQMcxfR6LfC+/HlARUMsQJIDrgs
	 H3V7T79tpzQIsSIN2b6f/vv1mG/nljpt8jsRLbAIMm6UpwNTKEm+hzpjQ8BhwYap16
	 NZfycQvYCHab7ml7xb2uddCkBMvwtiU5nz+WBBV1rtjNWHTmJH15I56BB5FdwRqeiT
	 qeG4CYMKTOiT1LqbbT/kJ3PrWKZOVuInsvmM90fEca75W2JQG8aWA9L49m66Rn+o53
	 GEe9DwZhjgpaM2EoYR3G7ex01IJ588P3T0e6y32/QhcMfZrrdPxE3JN4eBUWCoWnst
	 X4DAspsvFtxBw==
From: Lee Jones <lee@kernel.org>
To: Lee Jones <lee@kernel.org>, Chen-Yu Tsai <wens@kernel.org>, 
 David Rhodes <david.rhodes@cirrus.com>, 
 Richard Fitzgerald <rf@opensource.cirrus.com>, 
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
 Mika Westerberg <mika.westerberg@linux.intel.com>, 
 Zha Qipeng <qipeng.zha@intel.com>, Qunqin Zhao <zhaoqunqin@loongson.cn>, 
 Thomas Richard <thomas.richard@bootlin.com>, 
 Andy Shevchenko <andy@kernel.org>, 
 Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
Cc: mfd@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-sound@vger.kernel.org, patches@opensource.cirrus.com, 
 linux-crypto@vger.kernel.org, 
 Charles Keepax <ckeepax@opensource.cirrus.com>
In-Reply-To: <20261104-acpi-mfd-v2-0-64b9dee3baaf@thegoodpenguin.co.uk>
References: <20261104-acpi-mfd-v2-0-64b9dee3baaf@thegoodpenguin.co.uk>
Subject: Re: [PATCH v2 0/2] mfd: use designated initializers for
 acpi_device_id
Message-Id: <179502169643.55369.12852293397895853310.b4-ty@b4>
Date: Wed, 18 Nov 2026 17:08:16 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.16-dev-ad80c

On Wed, 04 Nov 2026 16:09:29 +0000, Pawel Zalewski wrote:
> This series is converting lists that contain the acpi_device_id struct,
> which is defined in the include/linux/device-id/acpi.h to make use of named
> initializers (which they do not use currently). This work is part of the on
> going effort in the kernel associated with device-ids [1]
> 
> The plan is to convert acpi_device_id::driver_data to have an anonymous
> union, similarly to what was introduced for PCI and I2C device ID tables.
> The goal is to increase type-safety (most of the existing casts are gone),
> to improve readability and to make use intent a bit more clear:
> 
> [...]

Applied, thanks!

[1/2] mfd: intel-lpss-acpi: Use named initializers for acpi_device_id
      commit: 88e9107ee8adf111b7b8e13b009eb78db9044140
[2/2] mfd: Use named initializers for acpi_device_id
      commit: 9f3af17b87120ec1aa6bf0fa8121e3bfef687cb3

--
Lee Jones [李琼斯]

