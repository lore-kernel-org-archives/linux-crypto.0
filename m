Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95A438F926;
	Mon, 13 Apr 2026 20:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776112369; cv=none; b=b1yifVYdsaLqMYiEsUNIJTn19FTqasy6qPmEXDoiaeoSc5J4Up+AuXU5dKYdxK/a25hvuLrvU9pCfH+yxX30lEwqnYh7ed83ktLvazEvMbZwceetFWuRgSUg2fDH49bK2dBReC/vJGz8O+GfFs0Ls+NO37HAcAfNpXWIUkOEolw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776112369; c=relaxed/simple;
	bh=7MUsO27/+aDmpUS/g/a808tgv7all3UDGCF46Pw9BQU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=jSLDzD/phDaKxLAp+BLDSl8JFsBPYsGUSXqgnwRZ5ECD5Snaypow/RQbOQMwR4uNLpgj3vN9a6x7lhKhDNUYEVvywEPTGtfCtR6ihz3GYfhd0587KsvKWwvFwXI6YUxwhEyG+NnF4o4WCODG00HPZKHRwsE+YWHISUH5Vl4iHLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=rATXq6PM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZKs6LhbS; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="rATXq6PM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZKs6LhbS"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7F3A41400040;
	Mon, 13 Apr 2026 16:32:46 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 13 Apr 2026 16:32:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776112366;
	 x=1776198766; bh=wisyQbengZJjiw1dkmtIyz62OB6/nWZTJK66Txm7jTA=; b=
	rATXq6PMSxwbWQD4gM3dDXlraNa7EJP6aqccn33TdzNUo/Ljhq91SoVx333DQTUM
	2u4p7yEwp7pd8PZsygcnbiND52yR8B30411i6lCAddGiNaUOgxGfOIzV3ThotQkv
	2adKuF3lC7Hd5fChgZ6k7BeYSSOx3l+gwIme5/1uZIJHe1gbpn9e7wTDHbIUK/UW
	eFnNR6jVQBp+heRTvQSSHu5iUgUXHptOMAyociWAzQz2P1I3qEFdsl/m5up1eHo5
	gzVPo5lkjbtLSfNC/Yy//rg2TInjuZLetk1lwKDnlrXlh/HsDVbXPbK47tWZHdpM
	kjmVuuO6WlyOBV2BgiMQCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776112366; x=
	1776198766; bh=wisyQbengZJjiw1dkmtIyz62OB6/nWZTJK66Txm7jTA=; b=Z
	Ks6LhbSijt5XiJTd3m3E9P2p7q3wfNIRkyrQHz3O62DyfPdFPRr2lWKi+owdV+Wm
	IhdhtDZnr2AUN0fBlF6cerzdHZA0BtsT5HhfaWw2ZqevBywR7wBuvjfXY/eKL7XU
	9UJ+AN7nQkD1fJ9R1EmZIeXvLRKqa+T/1QBKQDSxz2tCFo+5pquVH0Xr6ICLoxPt
	xCnCaZAvWNZqbrHhfEiMEidGffjCbUrCnjNaM2je5e76SN+Js71Y57EATrBcEPnT
	YY4hVzXweh07970ya5ClJLMo6E0pmlJfi8QjnB+xV1NXlBCAsbPkcCLGXG34Q+rO
	9HdpR69brA5UbIUzRiKpg==
X-ME-Sender: <xms:7FLdabIpPsHO0QTaCW0eVFH_9TiCrL3njcOXDitOOvLTsk64IN7QkQ>
    <xme:7FLdaZ-AlMhBcMiuWhyq78y4IHYgomveRqBsglC7_E4QGYEUDloy8MvRqDWpvFQtb
    6jSwlfK0UePq96dbtSwcn1P8rjmQe9WRpyPogyjb-2YhdKobH1z1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefledvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduhedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepvhhinhgtvghniihordhfrhgrshgtihhnohesrghrmhdrtghomhdprh
    gtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtoheprghn
    ughrvgihkhhnvhhlsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprhihrggsihhnihhnrd
    grrdgrsehgmhgrihhlrdgtohhmpdhrtghpthhtohephhgvrhgsvghrthesghhonhguohhr
    rdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopeguvhihuhhkohhvsehgohhoghhlvg
    drtghomhdprhgtphhtthhopehglhhiuggvrhesghhoohhglhgvrdgtohhmpdhrtghpthht
    ohepkhgrshgrnhdquggvvhesghhoohhglhgvghhrohhuphhsrdgtohhmpdhrtghpthhtoh
    eprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrgh
X-ME-Proxy: <xmx:7FLdac0oO-vlNOqqSNsxP18yTNpCenPoLuBjAr7PgH631OwHfbgFUQ>
    <xmx:7FLdaVnLWpGauDtwk-V2X_PhlIV5bj27AilLZh8GW2J6pTLFrVz1Nw>
    <xmx:7FLdabumYpBLHZpkso0du9jfnEj1lJPM1_7dsxD5w4m7izvgTOUgkg>
    <xmx:7FLdaV1Ll8sK3EAS4yD8GmGPJGumcFWlVK6kuKVwTMoN-_7oYhrIPQ>
    <xmx:7lLdaUpQrLPwfMFD-ZXCrxK0Hg0J74l4Mz6om6wQpFpE6tJqmETvHxDG>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A4B2A70006A; Mon, 13 Apr 2026 16:32:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A0Zw7CNZgRBF
Date: Mon, 13 Apr 2026 22:32:24 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lukas Wunner" <lukas@wunner.de>
Cc: "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Ignat Korchagin" <ignat@linux.win>, "Stefan Berger" <stefanb@linux.ibm.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, "Alexander Potapenko" <glider@google.com>,
 "Andrey Konovalov" <andreyknvl@gmail.com>,
 "Dmitry Vyukov" <dvyukov@google.com>,
 "Vincenzo Frascino" <vincenzo.frascino@arm.com>
Message-Id: <d82181fe-a70d-4c64-a411-4bf80c51f58f@app.fastmail.com>
In-Reply-To: <ad1IHo1rkVxqeMkc@wunner.de>
References: 
 <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>
 <adY8iUPrnoXDp_-g@ashevche-desk.local> <adZZ70lNnhoDnwok@wunner.de>
 <05d3e296-1b61-4ab4-9bec-6c11407e6f89@app.fastmail.com>
 <ad1IHo1rkVxqeMkc@wunner.de>
Subject: Re: [PATCH] crypto: ecc - Unbreak the build on arm with CONFIG_KASAN_STACK=y
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Apr 13, 2026, at 21:46, Lukas Wunner wrote:
> On Mon, Apr 13, 2026 at 05:42:39PM +0200, Arnd Bergmann wrote:
>> On Wed, Apr 8, 2026, at 15:36, Lukas Wunner wrote:
>
> Attached please find the Assembler output created by gcc -save-temps,
> both the original version and the one with limited inlining.
>
> The former requires a 1360 bytes stack frame, the latter 1232 bytes.
> E.g. xycz_initial_double() is not inlined into ecc_point_mult(),
> together with all its recursive baggage, so the latter version
> contains two branch instructions to that function which the former
> (original) version does not contain.

Thanks!

So it indeed appears that the problem does not go away but only
stays below the arbitrary threshold of 1280 bytes (which was
recently raised). I would not trust that to actually be the
case across all architectures then, as there are some targets
like mips or parisc tend to use even more stack space than
arm. With your current patch, that means there is a good chance
the problem will come back later.

> At the beginning of the function, it looks like the same register values
> are stored to multiple locations on the stack.  I assume that's what you
> mean by awful code generation?  This odd behavior seems more subdued in
> the version with limited inlining.

Right. As far as I can tell, the source code is heavily optimized
for performance, but with the sanitizer active this would likely
be several times slower, both from the actual sanitizing and
from the register spilling. I can see how the use of 'u64'
arrays makes this harder for a 32-bit target with limited
available registers.

     Arnd
