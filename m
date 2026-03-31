Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A9C40626E
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970815; cv=none; b=aspV3hEVL5njPg4modGpT5smfECT2E6ig4AQPxfCqdTuET4/sX7wDim1p13jT19PHuEJMWQRf4DIxTEPLOFZZkgIlRS624pZ7rkTZj2qsYYRqY7QuL2TqYyoOURulDDK9CI5Zjd97PRKr19WZd/fKsBRul9Sep4g9h826tic9qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970815; c=relaxed/simple;
	bh=cGTb91mpWi0Vk+xK4rlAkEQdHg3AEdVFle70p38K4Eo=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=maO5yzAyjVE/HIvljsFbZLNUA9W+rhtn1230jVP5WR5uU82kiXcignzdgjzjP2co2hM06E5mbKi++ExFXSp2cfwz8Bd1/0pTsEVbnQ9LQPTFO6GRzz+EsYW/pAJLN2hw7+OhefJl3pxgEqRB7p4JI9WmRJXZmiKuISocuu0PDDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ot2831z+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ot2831z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391A4C19423;
	Tue, 31 Mar 2026 15:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774970815;
	bh=cGTb91mpWi0Vk+xK4rlAkEQdHg3AEdVFle70p38K4Eo=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Ot2831z+FnM2V2mXxSrgb2u5Wf+cfHhmuESyvCLtnsBqwA9eVfTDC0jxdkZ909Vey
	 oSduTf+IzkRMzN80RYex3k6680nbNWjTkDJ8oYER4LWQIKTEINqrtGY54ulwZ+9FYj
	 J9JNaYJ+n5ET/pEW1N2DjwRF3XncxXXzEbeNdlses7djp4gCk33LU6VfVldZNNgsU/
	 FoxZpGQ5qHacyPNe3cMjuc5y91tNffRWlVNf4Z8dCJyUuLbGUCwZ+zhbaL0wQI4NWV
	 deOhQhdmDgjI44HlzyVs1IwEnfZqfNRGFK9iu027aUYrfIolWJp3BN1lUcwntpiB79
	 mBGJ5F6zp+u0Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4AB82F40068;
	Tue, 31 Mar 2026 11:26:54 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 31 Mar 2026 11:26:54 -0400
X-ME-Sender: <xms:vufLaRnP7jGMDEKs9R6KR-rMhT9NcYC5tkX4aRHLpm_XmY-E_-BzZA>
    <xme:vufLaXp3WUXeNPgx0OP9Snip83-HhlE51b4F0mXvQRbv_0X6PAyvxEqL-f-ui2XGI
    _wOLbzXLMQn_YcH2X5nI10i8Z_U_eaglJIh3pE9DIDaQ_nbeaX7DtE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegrihhl
    ohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpe
    foggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceuihgv
    shhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieejfedu
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrug
    domhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledqfeef
    vdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtg
    homhdpnhgspghrtghpthhtohepkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohep
    lhhinhhugiesrghrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegrrhhnugesrg
    hrnhgusgdruggvpdhrtghpthhtoheprghruggsodhgihhtsehgohhoghhlvgdrtghomhdp
    rhgtphhtthhopegvsghighhgvghrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtohephhgthheslhhsthdruggvpdhrtghpthhtoheplhhinhhugidqtghrhi
    hpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrhgr
    ihgusehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:vufLaSDlpIOvmANuwL8ix1lnr_yqbJILA8Bl3xRrAJrd9TOh5FUcqQ>
    <xmx:vufLaRcEHTqZ1eLDCST-8gypWZwQ72K5LhNbWW7K8CH8yovOc48xKg>
    <xmx:vufLaZ2Xuwik_Dnced0A_4CwLiKHWLeQpUE9SkaLolTZlUZgbUa1IQ>
    <xmx:vufLaQhSdD5W8cRbT3__88924YQ8u-CgV4tyFYv814ldtp9YJNB0tw>
    <xmx:vufLaakZoXFTDdgitJ3HwidQpKshtY8WpFesO1CPSItfAEkNiemJvmUx>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 2218D700065; Tue, 31 Mar 2026 11:26:54 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ALlDvrZQNrMB
Date: Tue, 31 Mar 2026 17:26:33 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Christoph Hellwig" <hch@lst.de>, "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-raid@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org, "Russell King" <linux@armlinux.org.uk>,
 "Arnd Bergmann" <arnd@arndb.de>, "Eric Biggers" <ebiggers@kernel.org>
Message-Id: <2176aab5-2167-4cdf-9090-0f8e0a6fb5a0@app.fastmail.com>
In-Reply-To: <20260331151653.GA8011@lst.de>
References: <20260331074940.55502-7-ardb+git@google.com>
 <20260331151653.GA8011@lst.de>
Subject: Re: [PATCH v2 0/5] xor/arm: Replace vectorized version with intrinsics
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Tue, 31 Mar 2026, at 17:16, Christoph Hellwig wrote:
> Looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>

Thanks.

> I think some of the intrinsics patches were also in your crc64 series,
> so I'm not sure how to be merge this.

The first patch is used by both series, yes. If this is good to go, we might as well just merge it, and defer the crc work (or at least the 32-bit ARM specific changes) to the next cycle. I am in no particular hurry with any of this, so whatever works for other people is fine with me.

The RAID pieces are going through akpm's tree, right?

Eric, any preferences? (assuming you are on board with the CRC64 changes in the first place)

