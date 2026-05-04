Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1196D3A6B6A
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 11:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777895022; cv=none; b=S/p7kDreEbv1s8sQaOdCLc3EnesmHHM3thR6oNoXVa0FWd47TRgr7AlvFcJ6mDXlBHHR66oW4BNZ0U7G39uOpnUipxBupEbfyZHHo4LFi8mOmUYSX/z0h2/wTSUFA7plgGypY1ii8XHvOLbAb56fnAl55GplOBB3SQ88gtTF3nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777895022; c=relaxed/simple;
	bh=vqtPq34eTX5fZopa1Zag6rnbLG2P5/lfyqob6OhB+EQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=IUrgDlcBDZEqp8h3P4ZjU5IwczCERGxZjuJa++HbmqA4pG7cFShxwVY+1NaaY1ENBlaj4HR9zSgE9EFxwOzKjgyq+2vB4PpyKO/noR3kgbAoEO256jqwFHYVClsLlb72bpSKawtmEMFqdQFw7cG1JDN6I7Jfm2yVsHlYWpfsV4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRzwcGv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRzwcGv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B44C2BCF5;
	Mon,  4 May 2026 11:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777895021;
	bh=vqtPq34eTX5fZopa1Zag6rnbLG2P5/lfyqob6OhB+EQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=TRzwcGv1Ajx5T7hnntSSiIUBzvABTGKblO2p7jQR3Cc8yBBcjXHcp/3DLaT+bRVs/
	 EpBqhOfGm2vgoUdOlPbCMx5hQaswCCKcogkzuZj1VwF2QJdpUEzamlx06tlPJc7huk
	 UMKadcwuRmFHY9ew9xMM8dZiBOFoh/xFQnOH/Sg3GCN67eb3TXCBtgHgBz3OuBJSnr
	 VXwSF2SioysV0Fklh6ke/TkVq2x/5D9ngEoe47uCkcogYMMYZ3vne01k2F2LsdNjZI
	 ab7vKqS9YoRSrsrOMEdJoVWQgX4YNBHJ0Kf0H/XxBSCBZX1P/jSNOMalWpJSagJjo1
	 HjOan3D+dAhNQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 810D5F40076;
	Mon,  4 May 2026 07:43:40 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 04 May 2026 07:43:40 -0400
X-ME-Sender: <xms:bIb4aWyG5Uegze_yqOlM-EzjzyFDhC2-5C9ORwUDjrIcyVXxLlQCcw>
    <xme:bIb4adEXnkI6Ft2knI1j7d8i_b248eBkZ5wh-uo96SSHDVcGd5LDa7XrweqhTOJt4
    P_SycdmcBn0vBkm75s6HIlpntyWno3y0D-1Q2RLhWcrsxjcssxAkGM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdelkeejhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepkedvffekhffggeevkeeftdeifffhleegteeivdeifffhkeefieekteeugeet
    teetnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhguodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieejtdehtddtjeelqdeffedvudeigeduhedqrghruggspeepkh
    gvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurdgtohhmpdhnsggprhgtphhtthhopedu
    tddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhhpvgesvghllhgvrhhmrghnrd
    hiugdrrghupdhrtghpthhtohepnhhpihhgghhinhesghhmrghilhdrtghomhdprhgtphht
    thhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpth
    htoheptghhlhgvrhhohieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvggsihhgghgv
    rhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmrgguugihsehlihhnuhigrdhisg
    hmrdgtohhmpdhrtghpthhtoheplhhinhhugihpphgtqdguvghvsehlihhsthhsrdhoiihl
    rggsshdrohhrghdprhgtphhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhk
    vghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:bIb4abXzzI1UfrhrPlxN9md_Jz-fcbJQUBjcbSj-IYkS7HFjccAqdA>
    <xmx:bIb4aVKfwlYJqT3UyrS2cf8V1ATnVsvKa-V_S_xYMmyAHegfXA1baw>
    <xmx:bIb4aWoYJA5MWKXForks4dPpx0Ax7QOapWp7ep4m8sKkelYtKyUdWg>
    <xmx:bIb4acxyBAwqoVbOzu2RtzjfLsuU_qgLJuoBkSY0e7le6s4NoPLhjQ>
    <xmx:bIb4aas2saJ82QEA7kBUOGWVkc8PHr4fbXPkJ9y5edAHm_o55ehfbmyD>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5F56C700069; Mon,  4 May 2026 07:43:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 04 May 2026 13:43:20 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, linuxppc-dev@lists.ozlabs.org,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>
Message-Id: <b895db29-e738-4d1e-87fe-d5a569902ebe@app.fastmail.com>
In-Reply-To: <20260504041448.15820-1-ebiggers@kernel.org>
References: <20260504041448.15820-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: powerpc/md5: Drop powerpc optimized MD5 code
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Mon, 4 May 2026, at 06:14, Eric Biggers wrote:
> Earlier the decision was made to keep this code for a while, despite no
> other architectures having optimized MD5 code anymore, because of
> someone using it via AF_ALG via libkcapi-hasher
> (https://lore.kernel.org/r/f0d771d5-ed70-444c-957a-ad4c16f6c115@csgroup.eu/)
>
> However, with AF_ALG itself now being on its way out due to its
> continuous stream of security vulnerabilities
> (https://lore.kernel.org/r/20260430011544.31823-1-ebiggers@kernel.org/),
> it's time to be a bit more forceful with nudging people towards
> userspace crypto code.  It's always been the better solution anyway, and
> it's much more efficient if properly optimized code is used.
>
> Thus, drop the PowerPC optimized MD5 code.  Note that this code contains
> no privileged instructions and could be run in userspace just fine.
>
> MD5 is still supported, just with the generic code only.  I.e., this
> commit only changes performance; it isn't a hard break.
>
> This also has no effect on implementations of md5sum that already just
> use userspace code (as they should), for example the coreutils one.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
