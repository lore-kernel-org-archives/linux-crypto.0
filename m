Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231B435950;
	Mon, 29 Sep 2025 03:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759117312; cv=none; b=gNTOXIDcWFV/p07gL8CeAN3ZePGnAMle4+BBwYm+uUCMILHxIb1Jm/nN6ryfH2jBEkB87yLAZTFIsEZCKJjxIrslJZxqvtDNd+zrq6h16eVmQxsIgv1C4DluPl0G4EZEpven8Qz/9C+54H+IiU2cAKpWZP66m9P4omLdPxLVsUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759117312; c=relaxed/simple;
	bh=RI2ipaHB29egjGOrvmIxSfS8MvurjHVJ7zwPYtv3sZA=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=gmXOkbEJ4thIhhMhFaWu8n6vZ+4VdkzW+AyC2OZ1O9ps3HkyI1mogXy1J/b9SKEleqEYz2io+69k8O67rRKDuSJw5dHpzphUiZCHb789oWI12RgN+zlK4et2mYgiXTImN84uiYKyr5HWOKB4kRKfcfqCc9F83MzqQlAix+kINa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=kP7NE0Vd; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=B/Y8KrTe; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="kP7NE0Vd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="B/Y8KrTe"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 283131400076;
	Sun, 28 Sep 2025 23:41:48 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sun, 28 Sep 2025 23:41:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1759117308; x=1759203708; bh=yjtaEvshITSwrEdSYBlewMXUbBwlvgxkvSi
	tYOUauSA=; b=kP7NE0VdDlIq/miDmk7Sj3YNDTtpRmp6XEmCHJf+j8m27c6d8/A
	69lT5AQ97tBOR5nOOWxX2nmFL/Z8UKzC5T7CwOyfmMG4lRauBX9Z+dN294tZIVuc
	+F4X3AeB6T/TUJs2GnI49gxbNVbdcb+J5jwiLxJT8WDnji9xqejGAxgoqVdDSgLd
	Ud6Zo6gZqRwgXQ25em/lNGTcJ5Bd/m56NEkWZ0Zxxnuka3ajUBCdEGM76QjSN7Fy
	mEPlQVRFjjvaUgWKrc7Hl4WPuVife3LfO2RZ5MIr0L2oZ4HyFsDUBGPW/T91bESI
	CCxQdlfK6uMJQ6dYtCZQKL0xnfcsdGL8qTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1759117308; x=
	1759203708; bh=yjtaEvshITSwrEdSYBlewMXUbBwlvgxkvSitYOUauSA=; b=B
	/Y8KrTeF8avUW/ph5EyAR++W6vbVymD/EwK1xQaMRJJD+sb10AUYtH3zjLWUwy9V
	CZBsa9wLrmT5HXzye3P+GIY10x8VhQiMwD3ZyvhrhPAXIO3Ng8WFK1TQAxOK/+dJ
	bECV2k6vyr6UWsjggdP3fqXXyCl0m4F6nId0RPtGRFa46xvwpe/vo0NMJ+MgUTvd
	2qPBIqiDnj9yM+r++05ZHA123OCbS/Yk6vRGT0gsLlyTSTgjqwlPsDwvUpt1rZL7
	jJkbBtOtiaXZ0dnDwRFr4zU5E+UHhkPNGf3L5kwFs8jsaGbVtpEFjUdDVVwt03e5
	9zq2VYB33UXcK/GLpz8RQ==
X-ME-Sender: <xms:-v_ZaMJ8lPT8o_it_22s0icuNX3dX0ZX6CaNAbqRexy650xrHVpyXg>
    <xme:-v_ZaOZu9ciUvExU7IDingF4TVT4o1x0GyzGuUZqPhv6XHdhCEF49cXuTVwhh0dL_
    k2ZdKQ9zJgWTtu4utEE3fpAr5r1_Ofq4X6vnunWtAjVpmwGLg>
X-ME-Received: <xmr:-v_ZaO-3bq1MbsftNHI9_wQxojEjF83CPrdBN8crfz2bHbqRrZ6f4iT8NfVzpBg1bg2Tyr4rx0ewVp-55geNcMkyMXKmlJd-a31pjf65QQsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdejieeliecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpegtgfgghffvvefujghffffkrhesthejredttddtjeenucfhrhhomheppfgvihhluehr
    ohifnhcuoehnvghilhgssehofihnmhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpe
    duteefhfduveehvdefueefvdffkeevkefgtdefgffgkeehjeeghfetiefhgffgleenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehnvghilhgsse
    hofihnmhgrihhlrdhnvghtpdhnsggprhgtphhtthhopeeipdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehtghhrrghfsehsuhhughdrtghhpdhrtghpthhtohepjhhirg
    hnghdrsghirghosehlihhnuhigrdguvghvpdhrtghpthhtohephhgvrhgsvghrthesghho
    nhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopehmvghnghhlohhnghekrd
    guohhnghesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:-v_ZaPZ4aLIheUqbRt6q6xJWDJKErBHbFvKpoO2JYe6R1njzPMzHTg>
    <xmx:-v_ZaCNZpfGv098yuLx2epYtA_38XPxvqwIDR3FaoX_SV8X1rsFSng>
    <xmx:-v_ZaLDFDUonA674eAlrVdyUnJ0F_XjCQKO7p6z_5stjcAMWLEwN4w>
    <xmx:-v_ZaJKnkzmMILrG71zFkZZRRjnTMplaY3ucK0fj_HfDIiX3hWTneA>
    <xmx:_P_ZaDrFGbhOd__Tb7qZYXvD9O4nYE758VQABCFEpXDYDMmNM4McY3XB>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 28 Sep 2025 23:41:44 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Menglong Dong" <menglong8.dong@gmail.com>
Cc: herbert@gondor.apana.org.au, tgraf@suug.ch, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, jiang.biao@linux.dev
Subject: Re: [PATCH] rhashtable: use likely/unlikely for rhashtable lookup
In-reply-to: <20250928061950.34531-1-dongml2@chinatelecom.cn>
References: <20250928061950.34531-1-dongml2@chinatelecom.cn>
Date: Mon, 29 Sep 2025 13:41:41 +1000
Message-id: <175911730161.1696783.8081419303155421417@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Sun, 28 Sep 2025, Menglong Dong wrote:
> Sometimes, the result of the rhashtable_lookup() is expected to be found
> or not found. Therefore, we can use likely() or unlikely() for such cases.
> 
> Following new functions are introduced, which will use likely or unlikely
> during the lookup:
> 
>  rhashtable_lookup_likely
>  rhashtable_lookup_unlikely
>  rhltable_lookup_likely
>  rhltable_lookup_unlikely
> 
> A micro-benchmark is made for these new functions: lookup a existed entry
> repeatedly for 100000000 times, and rhashtable_lookup_likely() gets ~30%
> speedup.

I generally like this patch - it seems well structured and leaves the
code easy to maintain.

I think you have made a good case for rhashtable_lookup_likely() and it
seems sensible to optimise that case.

I'm less sure of rhashtable_lookup_unlikely() - you have provided no
measurements for that.

In general we expect an rhashtable to be between 33% and 75% full.  The
inevitable hash collisions will mean that the number of used slots in
the bucket table will be a little less that this.  But let's assume 50%
of the buckets are in use at any time on average.

If you are using rhashtable_lookup_likely() you expect to find the
target so you expect the bucket to not be empty, so it is reasonable to
tell the compiler that it is "likely" that the pointer isn't NULL.

However if you don't expect to find the target, that DOESN'T mean you
expect the bucket to be empty - it could have another item it in.  All
you can really say is that the probability of an empty bucket matches
the degree of utilisation of the table - so about 50% as discussed
above.

So I don't think it is reasonable to ever tell the compiler that an
bucket being empty is "likely".  You also use "likely()" for deciding
whether or not to subtract the key offset from the address before
returning a pointer.  This is a valid thing to tell the compiler, but we
would need numbers to confirm whether or not it was worth adding to the
API.

If, however, you could provide numbers showing that in an rhashtable
with lots of entries, a lookup for a non-existing key was faster with
the rhashtable_lookup_unlikely() code, then I would find that
interesting and worth pursuing.

In general it would be interesting to know the number for both
successful lookups and unsuccessful lookups across all three proposed
lookup versions.  I don't know how helpful it would be, but I would find
it interesting...

Thanks,
NeilBrown
