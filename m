Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794596361;
	b=XnCa8gJohvLypBWe7HW57ZteLPL5zUZdVz2iym6qJYG4WDU8VPrfZI/tk4u9KdEZpH26
	 PHG/SZNJ52zbRb3yTzxEgyx7TRNFdr4EqZirX2cU5EK09eErE0sZZcbI1df1BalYISV/k
	 iq/TEJEDcGDEXpxeC/zozkLXQ9B2Yz9Y2ZmSFA/8Dpbiyhdx2+50coBbCIVZcg3nlLPIN
	 nESN60EuFQZQ/4IA3wse9/qsfbuWQ69STaUpyLwjbWGSpwjnJJ0lLXpLIElq1DrDdi765
	 nYnUfW1SMKaCcaHDA86JEzKCTjkkG8/dIgV1Xz3c8lY25ZLc7W9r60k6XNPovz7+FPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794596361;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=oKYwtAy384se2IlC59uUmr1JNttg2fedjzRBumwdbzc=;
	b=DKRkIVXybbMMxJgn/ciCbYR4DO04wpjj9t3cCZLNqiuxVsAI0Q0P2wHGOM8PNNPI40T1
	 EOJkm1nJXFmnGyfkbMtf6I9HkOYVxl+kfg55ZWvQf12wKavuBNBO1IRhSnZlAZw/RINua
	 fAoNvUDjJTtcEtVaza1YDlaQ3Y0l0hSlQvWNka60vEaJ1EP7odHikQ4u0bF61m5ed/c4Z
	 idu6lAebe82pHJtJqATE10OI6Fa7ghCJoIoRfzZ17y2n4R7BnDB2YI53QDT9bI3RBXemJ
	 Ebw+QDui+pvJoYhuhg8MtM/T4K+fh8COUPOwOuMDgBbvTBjsY/NBNaSaFld54+cPSBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nDaMOK5u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A493606B2E3;
	Fri, 13 Nov 2026 18:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nDaMOK5u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A1A1F000C8;
	Fri, 13 Nov 2026 18:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596361;
	bh=oKYwtAy384se2IlC59uUmr1JNttg2fedjzRBumwdbzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nDaMOK5ufaeDqLt20jMUOOFsoToU8KhFAITZrzYGZ5tnRHmbk8MNbY5DTp1RyyRhY
	 pwu+PiHZ4SYlcc/o4KvRMOD8wmuah0AswpS378uqlDWhL+qtabrTTsYD3XIGAFbgAM
	 naVKXN0cCv+oFBi7TLU2v41Lva+96UI9hqUYc8wyhFgWXmAybc+i2W2Jjp9bc5A0J4
	 XqGijg3octrWxKt6+JH4v0sT3ciI7yM1CJ6pmnqlzKO6vg+r3rDUvBc9+QjNjMBSqR
	 ZWsdA5AskjJaRMxWZRo8XcFbtRa1Dfhzx6LdAUieE7Ac+ZxfJlGePWNAA+Lh4Q51Sx
	 GOzvkKh0TXAmA==
Date: Fri, 13 Nov 2026 18:59:08 +0000
From: Lee Jones <lee@kernel.org>
To: Thomas Richard <thomas.richard@bootlin.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Andi Shyti <andi.shyti@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	Andy Shevchenko <andy@kernel.org>, AnilKumar Ch <anilkumar@ti.com>,
	Arnd Bergmann <arnd@arndb.de>, Binbin Zhou <zhoubinbin@loongson.cn>,
	Brent Casavant <bcasavan@sgi.com>,
	Chong Qiao <qiaochong@loongson.cn>,
	Corey Minyard <corey@minyard.net>,
	David Lechner <dlechner@baylibre.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Felipe Balbi <balbi@ti.com>, Gyungoh Yoo <jack.yoo@maxim-ic.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Joshua Kinard <linux@kumba.dev>, Kai Svahn <kai.svahn@nokia.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Kumar Sanghvi <kumar.sanghvi@stericsson.com>,
	Linus Walleij <linusw@kernel.org>, linux-crypto@vger.kernel.org,
	linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
	Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
	Mattias Wallin <mattias.wallin@stericsson.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>, mfd@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Milo Kim <woogyom.kim@gmail.com>, Ming Yu <tmyu0@nuvoton.com>,
	Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
	Pantelis Antoniou <panto@antoniou-consulting.com>,
	Pat Gefre <pfg@sgi.com>, Paul Burton <paulburton@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Rabin Vincent <rabin.vincent@stericsson.com>,
	Rachna Patil <rachna@ti.com>, Roger Quadros <rogerq@kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Shi Hao <i.shihao.999@gmail.com>,
	Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
	Stanislaw Skowronek <skylark@unaligned.org>,
	Stephen Warren <swarren@nvidia.com>,
	Sundar Iyer <sundar.iyer@stericsson.com>,
	syed khasim <x0khasim@ti.com>,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Tony Lindgren <tony@atomide.com>,
	Yinggang Gu <guyinggang@loongson.cn>
Subject: Re: [PATCH v2 00/27] mfd: Assorted resource lifetime, teardown, and
 error-handling fixes
Message-ID: <20261113185908.GI6323@joneslee-macbookpro.roam.internal>
References: <20261027093306.2812695-1-lee@kernel.org>
 <179458365250.76424.12505088783548230611.b4-ty@b4>
 <5a68f043-7c9a-44ef-b297-2821886bdcfe@bootlin.com>
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
In-Reply-To: <5a68f043-7c9a-44ef-b297-2821886bdcfe@bootlin.com>

On Fri, 13 Nov 2026, Thomas Richard wrote:

> Hi Lee,
> 
> On 11/13/26 4:27 PM, Lee Jones wrote:
> > [26/27] i2c: cgbc: Propagate hardware errors when polling read status
> >         (no commit info)
> 
> I noticed you did not applied this patch. It conflicts with my ongoing
> series "Congatec Board Controller: Add storage devices support". For the
> V5 I rebased it on top of Krzysztof's series that you applied and this
> series.
> 
> I don't know what is your plan for this patch. Will you apply it? Should
> I pick it into my series, or should we have to deal with I2C tree?
> Please let me know.

I didn't merge it because it's not mine to take.

I can either take it with an Ack or happy for anyone else to take it.

-- 
Lee Jones
