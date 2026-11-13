Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.246.85.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794597013;
	b=jwoEOaz6XjKMmFzGKMyOjAOYz4iJqySZzDnoPzoxL4TEnfD0T99/d1gYWuEcEEnAVRg1
	 couWA9cOLfd/+s+EDn+jPYr6UNItB9BVEF2fVepHwx8qQvGt5RNyS17TfxbloQBIzkBP1
	 5y5mEypSL9jZNT1aQYX0XznFqSu8UsRVjPg6W9s63twmnWMSI8mPQXa3d5jaaqhMzoIfA
	 S/kkCnr31DLzkc7HebOwYkZQc3uE0T7fXKf9TJzqlQgep210SD9G12BRdBn3zuKQD/oic
	 dmFw+ZuHQbWTICSAE9rGSsaFTFbiwZtENIw4LB0P+Xdy58DofYEFuzUafQiTm8eyBvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794597013;
	h=DMARC-Filter:Received:Received:Received:DKIM-Signature:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Last-TLS-Session-Version;
	bh=lDonEJwEkOKFs6QGhbZZt9eZVrZuIkbPCbngSkG5pl0=;
	b=CKKmsaVWpFAB8zkFZHWCy9UaONMz9W4/kYAVKk8XdorJh9LhJxP8HGjfHV/0wnDEcrO7
	 UK0aaXB5UASLHqstgSkK6NaamASq6t/LZZkHw5vqPR39SGEM0YOCsm4ALKYdt/cldnI3h
	 0ejktuTrHc49BN+5gGHHwLWn+Gu2iCOBAl6x1EQTTrgDcJHSD/zitEb4fN/2Qw+XPH4kp
	 ppF8YJ5IQIbyjGVibFG+P6C1FMdcsd7mqIPT+tooEtfjGzODWjXrtsjf++GkCvKO4geE5
	 wyLU2vUHXh9uS2ZZnzCsGtLPmY38clhFzq/CNUpRyFyHIwbv1EKxqXPoEDfXKhE8bDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bootlin.com;
	spf=pass smtp.mailfrom=bootlin.com;
	dkim=pass header.d=bootlin.com header.i=@bootlin.com header.a=rsa-sha256 header.s=dkim header.b=xmodXLO2;
	arc=none smtp.remote-ip=185.246.85.4
Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B142A606F307;
	Fri, 13 Nov 2026 19:10:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B142A606F307
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.a=rsa-sha256 header.s=dkim header.b=xmodXLO2
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 4B9A44E415B1;
	Fri, 13 Nov 2026 19:10:10 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id E9718601F0;
	Fri, 13 Nov 2026 19:10:09 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9743F11BC1337;
	Fri, 13 Nov 2026 20:09:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1794597006; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=lDonEJwEkOKFs6QGhbZZt9eZVrZuIkbPCbngSkG5pl0=;
	b=xmodXLO2E58u1qr7RtCp7N55lifIjz083Q4ZqmD4bvN0+1FcYz30INKc9CBCQaf1S7VQ4s
	2A5kMuGZyrkNgS6FsT6hkOawcP2myuJ87tdxo3tAgFoxHdbwH44B/SMWt/U/hQFmynn7be
	aKv7Fi/VYerRGYAi58OJb26ZP8FrzywVBo0FvAHDd0vu3/5QKOihXY4NgWsYsJ7hsFWBy7
	9lclfV0FVvnodTcnN/0Fr3FMMQvsrzrLQRhMmiYETpnrT07mxl8C8hUxF1a8B/r3YPIx3r
	ttPPtYYc9JwZEjkaplukiacncIVtEd3DfYfroPVa1dCLT6ZTKlaoUJr/gHGg7Q==
Message-ID: <1b038a37-1e97-4540-ba31-5b9288595788@bootlin.com>
Date: Fri, 13 Nov 2026 20:09:39 +0100
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
Subject: Re: [PATCH v2 00/27] mfd: Assorted resource lifetime, teardown, and
 error-handling fixes
To: Lee Jones <lee@kernel.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
 Andi Shyti <andi.shyti@kernel.org>, Andreas Kemnade <andreas@kemnade.info>,
 Andy Shevchenko <andy@kernel.org>, AnilKumar Ch <anilkumar@ti.com>,
 Arnd Bergmann <arnd@arndb.de>, Binbin Zhou <zhoubinbin@loongson.cn>,
 Brent Casavant <bcasavan@sgi.com>, Chong Qiao <qiaochong@loongson.cn>,
 Corey Minyard <corey@minyard.net>, David Lechner <dlechner@baylibre.com>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>, Felipe Balbi <balbi@ti.com>,
 Gyungoh Yoo <jack.yoo@maxim-ic.com>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>,
 Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Jarkko Nikula <jarkko.nikula@linux.intel.com>,
 Jonathan Cameron <jic23@kernel.org>, Joshua Kinard <linux@kumba.dev>,
 Kai Svahn <kai.svahn@nokia.com>, Kevin Hilman <khilman@baylibre.com>,
 Kumar Sanghvi <kumar.sanghvi@stericsson.com>,
 Linus Walleij <linusw@kernel.org>, linux-crypto@vger.kernel.org,
 linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
 linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
 Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
 Mattias Wallin <mattias.wallin@stericsson.com>,
 Matti Vaittinen <mazziesaccount@gmail.com>, mfd@lists.linux.dev,
 Mika Westerberg <mika.westerberg@linux.intel.com>,
 Milo Kim <woogyom.kim@gmail.com>, Ming Yu <tmyu0@nuvoton.com>,
 =?UTF-8?Q?Nuno_S=C3=A1?= <nuno.sa@analog.com>,
 Pantelis Antoniou <panto@antoniou-consulting.com>, Pat Gefre <pfg@sgi.com>,
 Paul Burton <paulburton@kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
 Qunqin Zhao <zhaoqunqin@loongson.cn>,
 Rabin Vincent <rabin.vincent@stericsson.com>, Rachna Patil <rachna@ti.com>,
 Roger Quadros <rogerq@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shi Hao <i.shihao.999@gmail.com>,
 Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
 Stanislaw Skowronek <skylark@unaligned.org>,
 Stephen Warren <swarren@nvidia.com>, Sundar Iyer
 <sundar.iyer@stericsson.com>, syed khasim <x0khasim@ti.com>,
 Thomas Bogendoerfer <tbogendoerfer@suse.de>, Tony Lindgren
 <tony@atomide.com>, Yinggang Gu <guyinggang@loongson.cn>
References: <20261027093306.2812695-1-lee@kernel.org>
 <179458365250.76424.12505088783548230611.b4-ty@b4>
 <5a68f043-7c9a-44ef-b297-2821886bdcfe@bootlin.com>
 <20261113185908.GI6323@joneslee-macbookpro.roam.internal>
Content-Language: en-US
From: Thomas Richard <thomas.richard@bootlin.com>
In-Reply-To: <20261113185908.GI6323@joneslee-macbookpro.roam.internal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

On 11/13/26 7:59 PM, Lee Jones wrote:
> On Fri, 13 Nov 2026, Thomas Richard wrote:
> 
>> Hi Lee,
>>
>> On 11/13/26 4:27 PM, Lee Jones wrote:
>>> [26/27] i2c: cgbc: Propagate hardware errors when polling read status
>>>         (no commit info)
>>
>> I noticed you did not applied this patch. It conflicts with my ongoing
>> series "Congatec Board Controller: Add storage devices support". For the
>> V5 I rebased it on top of Krzysztof's series that you applied and this
>> series.
>>
>> I don't know what is your plan for this patch. Will you apply it? Should
>> I pick it into my series, or should we have to deal with I2C tree?
>> Please let me know.
> 
> I didn't merge it because it's not mine to take.
> 
> I can either take it with an Ack or happy for anyone else to take it.

I will add it into my series, it already has a mix of MFD and I2C
patches. So I'll handle the conflict.

Best Regards,
Thomas
