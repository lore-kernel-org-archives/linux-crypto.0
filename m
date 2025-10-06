Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6F1219E8D;
	Mon,  6 Oct 2025 09:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759741608; cv=none; b=DV+KkXR1FqmTsICr6ZH2wv/ILVwpcoNeSa5aKt9MTkinS4X3dc6qDe1AHQLRn0RmhboHgCNyWfm+W8q5+/ErYS05l9y2C00OxUTP90bwWSMIo6qC3jD3U+XBmQdztiwdXq+aIE5wt8sojgAq6oqDnJkKz2Mar3GUwG7uT6ENmAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759741608; c=relaxed/simple;
	bh=xRNYcmWHVy9+rCxbrkxC7eKueSZYi3qjzHfFxl9ECYg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=MJuCUOW4Fgp9M1I6svPhTugYITF6ffRF8F21SnzqCLs5Qf8nvdWd0UuHXy/IBJdmYnu6ezuUL1Zg+orVeyTFMH5gybRlOp62emoItsZzPWXWwRRF9Rp9JLRepel+nOgjwN5xAJkNCtCrMTv1tk6WGSZy0XcWv2vvqopyQJrO8Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=A6haOVVu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ifuwRhCD; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="A6haOVVu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ifuwRhCD"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A0CED14000B6;
	Mon,  6 Oct 2025 05:06:44 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Mon, 06 Oct 2025 05:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1759741604;
	 x=1759828004; bh=GteAlwawFXfbnqA53uD7MPQFqbjH5yXXPYtKPXcgtd4=; b=
	A6haOVVuUxnYrnBwImh+OfR1gdGrw/QjPVvoFWVqrOrvoYMVp4ZcQ1RINRhlWHeT
	nB8i89rxtHeoWmnKPAnO8CjfMgTtzV+E/H+6bI4SAHnisCMGAES2eGP89i8RFLP0
	ENU9eo27kfDgxSSVp01WjGCvRw+0YGavz6bhhZoLJ3q08em2sn/+4tji6MX9kwBV
	obcdhm69G/NmFUA42M5/cabMctl0vg7foHHWM9mOgLOgfO+dLv7W5+qMTE0Wmfaq
	ub9UmHG7FqKItTSQAw4uuGn48mpjFiqtB8rGbLY4YA6O7fInaVLKj+qYkwzeCkA0
	erjjDflsBibubTjthKR/+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1759741604; x=
	1759828004; bh=GteAlwawFXfbnqA53uD7MPQFqbjH5yXXPYtKPXcgtd4=; b=i
	fuwRhCDAaC4fJI6sIFUOJs+6isA/hhSfrWrmD12iIEbMGHdibrniT6arNk8O6lNw
	dzFYfQvx6QYftsvxrdYSi4hHnRWp4vpBzIMM3ijKU1UbPurg+wdMNstmhQgCUwSu
	m99ylBg2mAzRYm4AEuF1lVi+onQJ0iMjtMGC85GIMNbEiOby4cwPQxjvBhJ/e+GA
	g5isJMRUBPlpET3nEQupTkOucC7+swgRD+1Scwd7AM9LdBmeWF6E9yssQlOts4FJ
	6m8kBJ88ifMFEwH/0DtH94bThF3Lg3mQUkLfhO5qfmMvp5T2GzsgAhMXgZjJnjN9
	rWmvzxMFrId3dE6Ppkd8Q==
X-ME-Sender: <xms:o4bjaAcSFNyOB0d8DGsdJlMvDwBT97yGRq_kAlNKVpzmfptFbxb3Og>
    <xme:o4bjaNDKwEjJ637TwMfwccKPF9k4atMQRcdpFUaST43GZdW8zjBlTKFkZcImuXuGN
    0mMkkXMEiYBYEYaxIDhi2LR9XopcwalO66IpdbNljMrJrRH4pYOB7ZE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeljedufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduhedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtoheprghurhgvlhhivghnsegruhhrvghlfedvrdhnvghtpdhrtghpthhtoh
    epmhhmrgihvghrsegsrhhorggutghomhdrtghomhdprhgtphhtthhopehnihgtohhlrghs
    rdhfrhgrthhtrghrohhlihestgholhhlrggsohhrrgdrtghomhdprhgtphhtthhopegrnh
    hsuhgvlhhsmhhthhesghhmrghilhdrtghomhdprhgtphhtthhopehhvghrsggvrhhtsehg
    ohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtoheprghrnhgusehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehgvggvrhhtsehlihhnuhigqdhmieekkhdrohhrghdp
    rhgtphhtthhopegtrghirdhhuhhoqhhinhhgsehlihhnuhigrdguvghvpdhrtghpthhtoh
    epuggrnhhivghlsehmrghkrhhothhophhirgdrohhrgh
X-ME-Proxy: <xmx:o4bjaDVBRGyiQxPDBvQys3EDOI4xxiSyCIjC3OszXN1CgE_QUZTtOQ>
    <xmx:o4bjaDIxE9UXdVNyzKg7F7_jqciBdXkUXl8jAZ6eQ5e7FWRKR8THpg>
    <xmx:o4bjaPDoIcixkH703wXHXdPUb9N-NRy5Yk7KJknmkSSAV64M_UBlDg>
    <xmx:o4bjaLEtqz73lCG7toIzUWB5vlq5Ig6MbB7dR6IhV7FKE0u-Mal6Ew>
    <xmx:pIbjaFDgUHr2OriFSXanbJ678QIMayb-5IrUrP4dVxl6oEc3qV1dMsTU>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0BEF7700069; Mon,  6 Oct 2025 05:06:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ABZYucWfS4iZ
Date: Mon, 06 Oct 2025 11:06:22 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "Arnd Bergmann" <arnd@kernel.org>
Cc: "Olivia Mackall" <olivia@selenic.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Cai Huoqing" <cai.huoqing@linux.dev>, "Dragan Simic" <dsimic@manjaro.org>,
 "Francesco Dolcini" <francesco.dolcini@toradex.com>,
 "Daniel Golle" <daniel@makrotopia.org>,
 "Christian Marangi" <ansuelsmth@gmail.com>,
 "Aurelien Jarno" <aurelien@aurel32.net>,
 "Markus Mayer" <mmayer@broadcom.com>,
 "Lukas Bulwahn" <lukas.bulwahn@redhat.com>,
 "Nicolas Frattaroli" <nicolas.frattaroli@collabora.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <80792144-66c3-46a7-a1a7-2e934a31ee2b@app.fastmail.com>
In-Reply-To: 
 <CAMuHMdW6jCbB80JhUVjBPnMCAXn5Amdr6KM48jvnd+VnMR40gg@mail.gmail.com>
References: <20250729152804.2411621-1-arnd@kernel.org>
 <CAMuHMdW6jCbB80JhUVjBPnMCAXn5Amdr6KM48jvnd+VnMR40gg@mail.gmail.com>
Subject: Re: [PATCH] hwrng: nomadik: add ARM_AMBA dependency
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Oct 6, 2025, at 10:23, Geert Uytterhoeven wrote:
> On Tue, 29 Jul 2025 at 17:28, Arnd Bergmann <arnd@kernel.org> wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> Compile-testing this driver is only possible when the AMBA bus driver is
>> available in the kernel:
>>
>> x86_64-linux-ld: drivers/char/hw_random/nomadik-rng.o: in function `nmk_rng_remove':
>> nomadik-rng.c:(.text+0x67): undefined reference to `amba_release_regions'
>> x86_64-linux-ld: drivers/char/hw_random/nomadik-rng.o: in function `nmk_rng_probe':
>> nomadik-rng.c:(.text+0xee): undefined reference to `amba_request_regions'
>> x86_64-linux-ld: nomadik-rng.c:(.text+0x18d): undefined reference to `amba_release_regions'
>>
>> The was previously implied by the 'depends on ARCH_NOMADIK', but needs to be
>> specified for the COMPILE_TEST case.
>>
>> Fixes: d5e93b3374e4 ("hwrng: Kconfig - Add helper dependency on COMPILE_TEST")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Thanks for your patch, which is now commit efaa2d815a0e4d1c ("hwrng:
> nomadik - add ARM_AMBA dependency") upstream.
>
>> --- a/drivers/char/hw_random/Kconfig
>> +++ b/drivers/char/hw_random/Kconfig
>> @@ -312,6 +312,7 @@ config HW_RANDOM_INGENIC_TRNG
>>  config HW_RANDOM_NOMADIK
>>         tristate "ST-Ericsson Nomadik Random Number Generator support"
>>         depends on ARCH_NOMADIK || COMPILE_TEST
>> +       depends on ARM_AMBA
>>         default HW_RANDOM
>>         help
>>           This driver provides kernel-side support for the Random Number
>
> After seeing CONFIG_HW_RANDOM_NOMADIK disappear from m68k
> all{mod,yes}config, I became intrigued, as it did build fine before?
> If CONFIG_ARM_AMBA is not enabled, both __amba_driver_register() and
> amba_driver_unregister() become static inline dummies, and the rest
> of the code and data is not referenced, thus optimized away by the
> compiler.  I verified this is the case on amd64 allmodconfig, too.
> How come this failed for you?

I believe this was the result of new build options getting adding
to the randconfig test matrix. If for any reason the
__amba_driver_register() function does not get inlined, the caller
will still have a permanent reference to the amba_driver structure,
and the rest of the file does not get removed by dead-code elimination.

Most likely this change happens because the __init attribute on
the module_init function puts it into a separate section from
the __amba_driver_register() function, causing the compiler to
refuse inlining them. Marking __amba_driver_register() as
__always_inline, or changing the amba_driver_register() macro
to not pass the pointer should also work here.

     Arnd
