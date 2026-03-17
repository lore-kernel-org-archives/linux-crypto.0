Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E51F3AA1B0
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 11:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773745664; cv=none; b=NtPRt5Nh5eGNKXRpgPb7lgs0sG4mdJb9SK5PFaLe1mv/v+MPgzkoWDBCCBVr5uX2/15AvEcmcIOke4tR7yygS8C6a5qiL8ykulBZ9DgmmmECNazA8R4m3WDQwcTzsZaKfXshrjxlovJN2JNrbpHpEe7Cq5wqmftvEv9zF08OLXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773745664; c=relaxed/simple;
	bh=0np/N4FQH3vTQB1I+tW3xs1OgIIr4cdI8M6uWyZkiOE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=csHANhZguJeaFzT/sOIgDT62u67UUwQBL1zGo9MLPbRrdk0Y7COh09RiOaKmEyzdzu/BLs0X0hW0HVXOFxbMIEPIXdkWY0c9/G/VTuz0EsIsggcN8HbD5Bhu+IcdXYL7hwNy/X6JiSd1ByW0mSjLR/A5tD8duO2O7jy0vkbzj2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lbLzKbyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lbLzKbyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C29DC19425;
	Tue, 17 Mar 2026 11:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745663;
	bh=0np/N4FQH3vTQB1I+tW3xs1OgIIr4cdI8M6uWyZkiOE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=lbLzKbyZPGfIJwAbjPAn9GHNlp/IexHmDRfYObMhySyIOuSTyXLN1VFHTxw1748wv
	 0Ji8KOCkFAmhB/PsbZMm5v5YcUt/tbo/46mmeIQ0IW7Dkv4ku9a2sE7y1P+21c2ki+
	 uGNi0Hmemgid8y83hIYOnTc0w1TCLUm9SWRz8uF2kUTBSFhIFWRLF2AuSYfsYsqcCJ
	 Fr/KkMfAa1YxvqjhCD9B24w60uUjLxD7Z54gxWVmXJoB2bYZ0A/GvqZevMcZyXEre/
	 63SLjUkWOdPUr4YOoPgakzXhv6I9DZKOGfQNvFJg3eS4CDRA0daaAGm5PjE4s+IXNS
	 s6bGbdzuaebDg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 80063F40079;
	Tue, 17 Mar 2026 07:07:42 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 17 Mar 2026 07:07:42 -0400
X-ME-Sender: <xms:_jW5aQxMlv83GHkFjb-GyQy5q48WC30MWdDweTt3JnrOUv_Z4m7B4w>
    <xme:_jW5afH87znyURYjsPHaLJWFM2NdPLLgp0auRsFXGHD1M9s2W3O5wVVnH2YukO_aQ
    2vrod3sUBFGPWeIQHkiHwysJu4dEsG65rfA-KZjUQqMML3WfCKmvr8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdduuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeegtdevuedttedtudehkeethfeludeutddvgeelgeejudetteduledthedv
    ledujeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhtvghsthhsrdhtohholhhsne
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdo
    mhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledqfeefvd
    duieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtgho
    mhdpnhgspghrtghpthhtohepjedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepug
    grvhhiugesuggrvhhiughgohifrdhnvghtpdhrtghpthhtoheprhgrvghmohgrrheifees
    ghhmrghilhdrtghomhdprhgtphhtthhopehkuhhnihhtqdguvghvsehgohhoghhlvghgrh
    houhhpshdrtghomhdprhgtphhtthhopegvsghighhgvghrsheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepsghrvghnuggrnhdrhhhighhgihhnsheslhhinhhugidruggvvhdprh
    gtphhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:_jW5aWafkQemQyY65g_098pPkJLSrZpwk6z9IgCdL5UBwqkZb7O96A>
    <xmx:_jW5aTfii8Z5O3oft2KaNrzPT_EwW1XCByt60I23_bJ7zQ5kMb5uFQ>
    <xmx:_jW5aQ0XW-eU345byBNjAZgzgltu6yxSmuKeCvs3Er-inl21PTQrbg>
    <xmx:_jW5aaJ542yBjRuCwaqPvKyFLQw2FfaHMNSlMhM5xT_v7KVLy7xBrg>
    <xmx:_jW5afETB-3DNPSMyy5iRK4Ee38Zkfpa8lzjGaCGrqB1U_l0ROf6gYlv>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5B740700065; Tue, 17 Mar 2026 07:07:42 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A1ayJ0gWTsgB
Date: Tue, 17 Mar 2026 12:07:22 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, kunit-dev@googlegroups.com,
 "Brendan Higgins" <brendan.higgins@linux.dev>,
 "David Gow" <david@davidgow.net>, "Rae Moar" <raemoar63@gmail.com>
Message-Id: <33f5b17a-6983-42d8-99e0-b5b80639d2b6@app.fastmail.com>
In-Reply-To: <20260314172224.15152-1-ebiggers@kernel.org>
References: <20260314172224.15152-1-ebiggers@kernel.org>
Subject: Re: [PATCH] kunit: configs: Enable all CRC tests in all_tests.config
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 14 Mar 2026, at 18:22, Eric Biggers wrote:
> The new option CONFIG_CRC_ENABLE_ALL_FOR_KUNIT enables all the CRC code
> that has KUnit tests, causing CONFIG_KUNIT_ALL_TESTS to enable all these
> tests.  Add this option to all_tests.config so that kunit.py will run
> them when passed the --alltests option.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting crc-next
> (https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next)
> which has the commit adding CONFIG_CRC_ENABLE_ALL_FOR_KUNIT.
>
> Note that patch also mirrors
> https://lore.kernel.org/linux-crypto/20260314035927.51351-3-ebiggers@kernel.org/
> which does the same for the crypto library tests.
>
>  tools/testing/kunit/configs/all_tests.config | 2 ++
>  1 file changed, 2 insertions(+)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/tools/testing/kunit/configs/all_tests.config 
> b/tools/testing/kunit/configs/all_tests.config
> index 422e186cf3cf1..c1d3659a41cf0 100644
> --- a/tools/testing/kunit/configs/all_tests.config
> +++ b/tools/testing/kunit/configs/all_tests.config
> @@ -44,10 +44,12 @@ CONFIG_REGMAP_BUILD=y
> 
>  CONFIG_AUDIT=y
> 
>  CONFIG_PRIME_NUMBERS=y
> 
> +CONFIG_CRC_ENABLE_ALL_FOR_KUNIT=y
> +
>  CONFIG_SECURITY=y
>  CONFIG_SECURITY_APPARMOR=y
>  CONFIG_SECURITY_LANDLOCK=y
> 
>  CONFIG_SOUND=y
>
> base-commit: c13cee2fc7f137dd25ed50c63eddcc578624f204
> -- 
> 2.53.0
