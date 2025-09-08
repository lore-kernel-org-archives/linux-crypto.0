Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A28530ACF6;
	Mon,  8 Sep 2025 13:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757337093; cv=none; b=Yv0igB/qnM7QABYAOtsE49CwJyNizHnA+LpxzeykOO8GKfavd4ABU2MYwG2RpxwxQFzIRBbcQshL6bRgpuhbafQuKSpaRnTb+9TmpPUHBdoEWZPpt8Fl9W/C0ruKpkaKLOwN+N3OST/LLALhHtBoIawQgmXuAWlPNVx7aLO0m5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757337093; c=relaxed/simple;
	bh=neVpymBMp3ra0hu16F/8V5PEhWaFXO1FE/6JZS7zy8w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uO2acorL5AsEoGinZQdTJxRZpi81SszUHaJj0auwox9hTxUtSDJz/XdKXbES32H4KbpZR027K+xNGuPS8XZlBKc+tvoRN00ptz6mn/loYSHuz+/lBfGzRgOuYTVIz30u5oyi5p3nVOEnR74UCfx22m4Ul5BQdF+GCS85TPy7zOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=up2dWAf4; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="up2dWAf4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NkcpqsNtIfH0/2T4tzf3ihFLKwziOQ6MGxZZ1TVH8gc=;
	t=1757337092; x=1758546692; b=up2dWAf4YkkTq9nTdsnNLP3pkBaPrfxMReZNlF9VI5fn8AX
	7ppjX12KTFUeP22VBKMNETjs8zGhbZrXh3uF5WrlzN2QR3aVImuNPC5XafKa4MefkBL2Yr3QNK7rY
	FZArlPcvFShayPmOdcBO9yuWPcEEx5Dc5DScsAe/sj9BML0Loqa50CfnWm2kqT5V+7Uy/f/dgZrrJ
	FsaoFwRu7YFifZUHuZc0YRe3zJiUTZuy+sx6a2TV8y9pQdr4z0LUxi9p0ev/UZeigldSzXNCNYh4x
	Vp4vb3QXPGENNrX/v4Z74ADjUUVoGSSLjvwQq/HAH6FNzYxn3SuQGyv9waB/gvGQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1uvbeH-00000007aGR-1hXH;
	Mon, 08 Sep 2025 15:11:09 +0200
Message-ID: <513c854db04a727a20ad1fb01423497b3428eea6.camel@sipsolutions.net>
Subject: Re: [PATCH v2 RFC 0/7] KFuzzTest: a new kernel fuzzing framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	glider@google.com
Cc: andreyknvl@gmail.com, brendan.higgins@linux.dev, davidgow@google.com, 
	dvyukov@google.com, jannh@google.com, elver@google.com, rmoar@google.com, 
	shuah@kernel.org, tarasmadan@google.com, kasan-dev@googlegroups.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, 	dhowells@redhat.com, lukas@wunner.de,
 ignat@cloudflare.com, 	herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org
Date: Mon, 08 Sep 2025 15:11:08 +0200
In-Reply-To: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi Ethan,

Since I'm looking at some WiFi fuzzing just now ...

> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format
> converters)

Could you clarify what you mean by "relatively" here? It seems to me
that if you let this fuzz say something like
cfg80211_inform_bss_frame_data(), which parses a frame and registers it
in the global scan list, you might quickly run into the 1000 limit of
the list, etc. since these functions are not stateless. OTOH, it's
obviously possible to just receive a lot of such frames over the air
even, or over simulated air like in syzbot today already.

> This RFC continues to seek feedback on the overall design of KFuzzTest
> and the minor changes made in V2. We are particularly interested in
> comments on:
> - The ergonomics of the API for defining fuzz targets.
> - The overall workflow and usability for a developer adding and running
>   a new in-kernel fuzz target.
> - The high-level architecture.

As far as the architecture is concerned, I'm reading this is built
around syzkaller (like) architecture, in that the fuzzer lives in the
fuzzed kernel's userspace, right?

> We would like to thank David Gow for his detailed feedback regarding the
> potential integration with KUnit. The v1 discussion highlighted three
> potential paths: making KFuzzTests a special case of KUnit tests, sharing
> implementation details in a common library, or keeping the frameworks
> separate while ensuring API familiarity.
>=20
> Following a productive conversation with David, we are moving forward
> with the third option for now. While tighter integration is an
> attractive long-term goal, we believe the most practical first step is
> to establish KFuzzTest as a valuable, standalone framework.

I have been wondering about this from another perspective - with kunit
often running in ARCH=3Dum, and there the kernel being "just" a userspace
process, we should be able to do a "classic" afl-style fork approach to
fuzzing. That way, state doesn't really (have to) matter at all. This is
of course both an advantage (reproducing any issue found is just the
right test with a single input) and disadvantage (the fuzzer won't
modify state first and then find an issue on a later round.)

I was just looking at what external state (such as the physical memory
mapped) UML has and that would need to be disentangled, and it's not
_that_ much if we can have specific configurations, and maybe mostly
shut down the userspace that's running inside UML (and/or have kunit
execute before init/pid 1 when builtin.)

Did you consider such a model at all, and have specific reasons for not
going in this direction, or simply didn't consider because you're coming
from the syzkaller side anyway?

johannes
