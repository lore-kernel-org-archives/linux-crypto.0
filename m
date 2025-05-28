Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD4328DF03;
	Wed, 28 May 2025 16:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748451549; cv=none; b=Fe8dZmVpesr4gMo6qeopNS49mNf5wR/Mpbf+gC6al0oaCsj28gIteXucE25R9sDHXBWP47MkKgy39s25Pz5xr7kVM5Tzww/jnAs36BXVFMjsS5mAP+BlMEeFWrY8fifI1plnGXw0QyCFPEIu54/p9bPs9nKa/qAP+8DOoFLYIfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748451549; c=relaxed/simple;
	bh=xP2c9GIwsMqQtGZLR94lMghxEZG0UL4HkkMvzlYZWO8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=N0ZRVW5B1cCd3pxE7yW2uVHK+E9TIZ3gMUnKvogSenEFWoXalO1CJ9dKsuTZXs+z5R7ijbm/p4bcUyEBCnwGU6EAZLPakyrm3LMgsZ/B38ekLnrIvP2gTH4/pEIgRQDK7Y/ieGdj35FF/it3l/J0SP4uWa9cZN7KjwnDq9Y8o7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=CbvEonSl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KYVf8BpU; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="CbvEonSl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KYVf8BpU"
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id BF5F61140135;
	Wed, 28 May 2025 12:59:06 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Wed, 28 May 2025 12:59:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1748451546;
	 x=1748537946; bh=LDMLe1OsHNvAiaE+yCUbTBas5Ud07EYR3wfP01RS7as=; b=
	CbvEonSlObjQmr/ENFYwXlOn3Cnv1cN+1IEx+e2Ab23SPHhfKgz1XueM3fIcXkNy
	SNAp0dWWYLpZKbcTIbfHX2WF50LYIWSXFyoWc2k4lDZ5LWu8wh+Ve88KSODl6vla
	PDOK3aQC9aMwqDtboyP5v5mx4IIAX2Ur49yCoiq3dSEHzalS8tsVt7X2MOZ+1X7a
	FPrqnkEzHbUGqkywECJZMaABpCIXub1AUUaxeluVYhtY7YDGYr1GYd3N1PctEigD
	FFseJAiDEo8rfwobpyHH8ZETk/Q3TxxWDfMVAWUrFv95sv32QbsaOfaH2aobzCtj
	34WUyaPhAq0m1rSPDNteBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1748451546; x=
	1748537946; bh=LDMLe1OsHNvAiaE+yCUbTBas5Ud07EYR3wfP01RS7as=; b=K
	YVf8BpUEaYAApd+aYNL/QKwjVaXyMecVPGA6F2XwKDk+X6SIwGCLbJS3KfOMpyb7
	moV7fEYaVU2Gcxp6gttLPCXQ3kZTV9Hr7Sq6Ex4Ql6DweYicAPUtZ/wNpJG71ylk
	hgy7zYqbVjO4pv4eBPsq2Y/FfJ1/Lk1UWgUpO56pWM55LNfxdcWAdC4w+VxwjoUx
	q9YQWKLUkDsvSa1GPyKnHL9KVIwlqrboSy0xrp3bS7AAyWPyg+THIDCQ5CHeJ5q/
	DuYLLnu16UIC0UFSwcX+XZKW/luz3uFtrNeng/xPGrTK59CzNLewj1VV8sO/zuo6
	BwlGuk476VBHwu0MNewfA==
X-ME-Sender: <xms:2EA3aGq_c7e29CDINjflnwN6vQsFRKUbM0wL4brFM1H1T2o9msR-zw>
    <xme:2EA3aErY78NnJY5ukk14GqjiP4AQUxHV3mBQ-EFX19AOddbhFlReIIMHkr1SbmZFF
    4oiyrZOGA09GdjRemY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddtgddvfeektdculddtuddrgeefvddrtd
    dtmdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggft
    fghnshhusghstghrihgsvgdpuffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftd
    dtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefk
    jghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfd
    cuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeeh
    udekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
    pdhnsggprhgtphhtthhopedugedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephh
    gvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopehj
    uhhsthhinhhsthhithhtsehgohhoghhlvgdrtghomhdprhgtphhtthhopehlkhhpsehinh
    htvghlrdgtohhmpdhrtghpthhtohepohhlihhvvghrrdhsrghnghesihhnthgvlhdrtgho
    mhdprhgtphhtthhopegvsghighhgvghrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epkhgvvghssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgrrhhmqdhk
    vghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehllh
    hvmheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlohhonhhgrghrtghh
    sehlihhsthhsrdhlihhnuhigrdguvghv
X-ME-Proxy: <xmx:2EA3aLPrCXH1sLOgxGk-N_ufObFw_-vDd88aHQv85aFF9g6SXA9TsA>
    <xmx:2EA3aF6Z49KxjlhsBtzOxXAr-GUQ3t56s0p7YNs-AnjMnWXg0OgDmQ>
    <xmx:2EA3aF6Fnml8oHrs4GRk-ujdxAV-1WPPJ8_WeK8n3b6N_O8cTKrWPQ>
    <xmx:2EA3aFjZ31ssou5dbrszO3e6LRcGJsfzBiCQmfVOoCSGbH_QgocyIg>
    <xmx:2kA3aGXqXDA0CXLM-NXCkKqSIAcrC_X5XH8KNVMj6ZHGavqs6JaLqFeb>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A1161700063; Wed, 28 May 2025 12:59:04 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Tff0b0175c39a25d0
Date: Wed, 28 May 2025 18:58:44 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Kees Cook" <kees@kernel.org>, "Eric Biggers" <ebiggers@kernel.org>,
 "Justin Stitt" <justinstitt@google.com>
Cc: linux-hardening@vger.kernel.org, oe-lkp@lists.linux.dev,
 "kernel test robot" <lkp@intel.com>, linux-kernel@vger.kernel.org,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
 "kernel test robot" <oliver.sang@intel.com>, llvm@lists.linux.dev
Message-Id: <324a5724-7bde-42f2-8910-e70b5b5f9d9e@app.fastmail.com>
In-Reply-To: <202505280937.6802F0F210@keescook>
References: <202505281024.f42beaa7-lkp@intel.com> <20250528061427.GA42911@sol>
 <202505280937.6802F0F210@keescook>
Subject: Re: [linus:master] [crypto]  40b9969796:
 UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305-selftest.c
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, May 28, 2025, at 18:45, Kees Cook wrote:
> On Tue, May 27, 2025 at 11:14:27PM -0700, Eric Biggers wrote:
>> On Wed, May 28, 2025 at 01:15:05PM +0800, kernel test robot wrote:

> I'm not sure how to enforce "don't enable this unless you're developing
> the Overflow Behavior Types" with current Kconfig, given the randconfig
> gap... I have some memory of Arnd doing something special with his
> randconfigs to avoid these kinds of things, but I can't find it now.
>

The main thing I do on the randconfig builds to avoid obscure issues
is to force CONFIG_COMPILE_TEST=y, but that only works for build
testing, not actually running it.

      Arnd
