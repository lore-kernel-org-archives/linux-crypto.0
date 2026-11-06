Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.246.84.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793959109;
	b=D2Q/ZEpBXL4FSTRmekKDighD9hQCMGl5f0wYKNNZblF5dQQiLTEPbvO2O3fDWJmXEU0u
	 E2J0drz8HZdfpK+BblReR8jzQ1P1nESZ7gz2CqRNz/9Q8tTVMqS5Nt1SLJd3VUe5UTGoQ
	 E95FgjUGOFsy7dJK2AlVKlMLa81+HN3XcHCKG8D0+OwPuB6ePKMCKNv9zx3pPYvXoqdzJ
	 vGwSeOyCcWRrD32CrhBaRZ9WfFvM6u141tLSNXbLi97V82Vx3gCZkJ3jVAuBQOtBFn03D
	 UMQ3nTIq5yb0ZsBP+60wjk5AFwNm1R2VDvNIwPqGNEf+K+am41UCRQrLD5DoWg/NLzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793959109;
	h=DMARC-Filter:Received:Received:Received:DKIM-Signature:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Last-TLS-Session-Version;
	bh=kbFOWcR5A6GDWO1RwMhPHFn30qJ8DBxtRSmC21gCtx4=;
	b=wHZtXY1vVPGGIIuTPVvsxi5I6Wje2vIUqxNW4Fu/GgpmfL3KYQblP99XjwFjdEazONwE
	 3Q2HBZTgLt0f8W8/DMLSp8Vy0Nho+tlA279YpRcqr+qp7SiGmYcyJYEyrSAKIJ5td+H/s
	 R2F+Lb3X5jQT5y16MyuBaNzUyTaPx1+sP/91q6jgvhNhINi0DtU/SziimNu+Rkk8e2H01
	 buD+xDaMsKt+OQI4VrmJ+R9IwYC5Ak7BW/9bdd0IguP0BzGJPTcACDjoYOajSW4bWU+UY
	 eaFQYasD8iD105lldmlEE0Ji/6cnSOM0nHZ65z7hiFjBPqYJf3LZg7bJbIew4FGl84Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bootlin.com;
	spf=pass smtp.mailfrom=bootlin.com;
	dkim=pass header.d=bootlin.com header.i=@bootlin.com header.a=rsa-sha256 header.s=dkim header.b=tcvCobbY;
	arc=none smtp.remote-ip=185.246.84.56
Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB5A606A328
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 09:58:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EB5A606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bootlin.com header.i=@bootlin.com header.a=rsa-sha256 header.s=dkim header.b=tcvCobbY
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 504171A1355;
	Fri,  6 Nov 2026 09:58:26 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 1B4EA5FFBC;
	Fri,  6 Nov 2026 09:58:26 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2BA12103291F9;
	Fri,  6 Nov 2026 10:58:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1793959104; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=kbFOWcR5A6GDWO1RwMhPHFn30qJ8DBxtRSmC21gCtx4=;
	b=tcvCobbYjIy6MNOP2TZqIe7RrPmlVaebdIin+t8AfwE/41bMrqrla3DBS9z9LQQQESELE1
	dkoOfHDwF+Q1ZnOPqvI6/n5Lvzwh8s3rdV9KSfSzczS6mwwjM+pVQt2VA0pzESp2teTxdm
	KE3imiAZSUXihBW8LJ4UmGJlcSe6FX2989eLUTfqo+PaUzx0mi2aj7kcTQJy6TBLiBcpav
	nP9xslvjHOkOh6Xq0WxtWUCMkvLq9Fz8LAmv2ESPxceLVSSIP980DIjZazGdaedDOucMZa
	1PUTFIr6QnqCp+nXdvFdL6c0UzT/Ku8sYE7A5sTYD8FelifqE4hnBIJ6TFByiw==
Message-ID: <1e12523f-a294-4f98-93d9-4ea3479d4456@bootlin.com>
Date: Fri, 6 Nov 2026 10:58:17 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mfd: Use named initializers for acpi_device_id
To: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>,
 Lee Jones <lee@kernel.org>, Chen-Yu Tsai <wens@kernel.org>,
 David Rhodes <david.rhodes@cirrus.com>,
 Richard Fitzgerald <rf@opensource.cirrus.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Mika Westerberg <mika.westerberg@linux.intel.com>,
 Zha Qipeng <qipeng.zha@intel.com>, Qunqin Zhao <zhaoqunqin@loongson.cn>,
 Andy Shevchenko <andy@kernel.org>
Cc: mfd@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-sound@vger.kernel.org, patches@opensource.cirrus.com,
 linux-crypto@vger.kernel.org, Charles Keepax <ckeepax@opensource.cirrus.com>
References: <20261104-acpi-mfd-v2-0-64b9dee3baaf@thegoodpenguin.co.uk>
 <20261104-acpi-mfd-v2-2-64b9dee3baaf@thegoodpenguin.co.uk>
Content-Language: en-US
From: Thomas Richard <thomas.richard@bootlin.com>
In-Reply-To: <20261104-acpi-mfd-v2-2-64b9dee3baaf@thegoodpenguin.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

On 11/4/26 5:09 PM, Pawel Zalewski wrote:
> Use a designated initializer for the acpi_device_id fields which makes the
> code more readable and consistent with how lists are initialized in the
> rest of the kernel code base. Also drop explicitly setting fields to 0
> where it is redundant.
> 
> Unify the list terminator to have a single space between the brackets and
> no trailing comma.
> 
> Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
> Signed-off-by: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
> ---
>  drivers/mfd/axp20x-i2c.c              | 2 +-
>  drivers/mfd/cs42l43-i2c.c             | 8 ++++----
>  drivers/mfd/intel_pmc_bxt.c           | 2 +-
>  drivers/mfd/intel_soc_pmic_bxtwc.c    | 2 +-
>  drivers/mfd/intel_soc_pmic_chtdc_ti.c | 4 ++--
>  drivers/mfd/intel_soc_pmic_chtwc.c    | 2 +-
>  drivers/mfd/intel_soc_pmic_crc.c      | 4 ++--
>  drivers/mfd/intel_soc_pmic_mrfld.c    | 4 ++--
>  drivers/mfd/kempld-core.c             | 6 +++---
>  drivers/mfd/loongson-se.c             | 2 +-
>  drivers/mfd/upboard-fpga.c            | 6 +++---
Acked-by: Thomas Richard <thomas.richard@bootlin.com> # upboard-fpga.c

Best Regards,
Thomas
