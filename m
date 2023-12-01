Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="XEFyTw9Y"
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D2B197
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 10:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=fG2Fz4H3y08YKpGEdC2oAWvh9beJ6Xli5gxvnBYWfVU=;
	t=1701455715; x=1702665315; b=XEFyTw9Y+h+QCzl6gRDFFx4QuVn/ODExXKfw/qJ7pehvo+n
	SBPe867rINz8dr6EL7HP6JDPrvkhCSwIVPRVkyS5UHEO9k5yuOR9kFkP8M9GXm32pnRkktb3MYclK
	AeO8OiUvYQ8t2nFvKHbnexAUdmztRljv/Ckrt9gnjJT9NWwtYz9POOLN7NThDGe46sm09TvzfkCpA
	Sw7HxgYarqTugZJC+Hlao+HZyLcd/HrDzVCDkD46Fx5nWuM4d6WgVt2A8NXWCWfHkBf1MNsFGOZ+B
	Ic1pAUcEh/wKnY3RXNuR58DZNcXDHtABHN81QzxJRAOWBGMSpCPmwGpammF4eF2g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1r98M4-0000000BPGG-1voz;
	Fri, 01 Dec 2023 19:35:12 +0100
Message-ID: <8ddb48606cebe4e404d17a627138aa5c5af6dccd.camel@sipsolutions.net>
Subject: Re: jitterentropy vs. simulation
From: Johannes Berg <johannes@sipsolutions.net>
To: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>, 
	linux-um@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, Stephan =?ISO-8859-1?Q?M=FCller?=
	 <smueller@chronox.de>
Date: Fri, 01 Dec 2023 19:35:11 +0100
In-Reply-To: <7db861e3-60e4-0ed4-9b28-25a89069a9db@kot-begemot.co.uk>
References: 
	<e4800de3138d3987d9f3c68310fcd9f3abc7a366.camel@sipsolutions.net>
	 <7db861e3-60e4-0ed4-9b28-25a89069a9db@kot-begemot.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

[I guess we should keep the CCs so other see it]

> Looking at the stuck check it will be bogus in simulations.

True.

> You might as well ifdef that instead.
>=20
> If a simulation is running insert the entropy regardless and do not compu=
te the derivatives used in the check.

Actually you mostly don't want anything inserted in that case, so it's
not bad to skip it.

I was mostly thinking this might be better than adding a completely
unrelated ifdef. Also I guess in real systems with a bad implementation
of random_get_entropy(), the second/third derivates might be
constant/zero for quite a while, so may be better to abort?

In any case, I couldn't figure out any way to not configure this into
the kernel when any kind of crypto is also in ...

johannes

