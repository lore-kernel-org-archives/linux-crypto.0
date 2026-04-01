Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D024337C922;
	Wed,  1 Apr 2026 07:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775028697; cv=none; b=q6ZBhpyqjWJ9cNX/R+RN9TpxPf2468Ls/8iwuuATr8jbfImJximqnQ97fwvsGFWijd75Yd85d2g3KL6ies31QWOzq/F9H3pqYn5iTIv3P8NIyStGD5YgJVYal8+zxuSF/yU1l/mZq2NDf1yrnM5TIsOi1g8jazeG3I8oU+U8/Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775028697; c=relaxed/simple;
	bh=vZvf/vVpL0TiY5ZKgcWYM5rS1YoFp9IzxhJ2gXiagmE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=trnz2I+rcPl2rDNh7hS7Hpizr+UP6FUnLQ7/XVR0xRgt0ckcG+tZ3QVd1jtl+FYrmCrObJKhpG00mlZkGvF0E37L9SsSO9A3WuG2fO0A7j6v+oA/HpYz4vcEZz3g5SjQ2sKtFTmTn5pTeNprRJuoszPbcH6F41vLlPdIXgGJHzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SYWV9S9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SYWV9S9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D216C19423;
	Wed,  1 Apr 2026 07:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775028697;
	bh=vZvf/vVpL0TiY5ZKgcWYM5rS1YoFp9IzxhJ2gXiagmE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=SYWV9S9JOPdd0lRec0HSUQlsyrtHtgjk9ef7Y/ilneC6WVni+PhPr030HUFgwjBNh
	 rsfG1WtYG3ba6OmFqFTIo7ySCbJbH9sL6aCW8D4WK8VHAKv4XNN3ec/rmqoxqkmIUK
	 yYDPsnJy0RzlceOoZfRW45UQxpVxRRgf+aNyct5T3RoJxqqCJJED80/Ak7iqS1HsHd
	 YQ1qpyCj/+KUloYuxhfAW4UCxxNJiFDmO/pXFO2LsRU7+6KE8+riH5TxS4bAlE61OZ
	 0h7ZP3C1DYhokVHrtDzcxqmUPPUQ24wxi+2taXd0qQPsRLzjNBsKJJuUSyyuFvfE6h
	 HdkhncYE4RhaA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 259D1F40068;
	Wed,  1 Apr 2026 03:31:36 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 01 Apr 2026 03:31:36 -0400
X-ME-Sender: <xms:2MnMaaHm4T4QYRopeb_k0u-IP72s0FjMw8re_yTLtXQq5vF4en4ubw>
    <xme:2MnMaWKsXtEwH49ab1VjovzsCSsh_fzhZ4_n1FvxJYmTWAbfaS3Y4zG5TyqmBcsgJ
    u3yZfxEs990g1tgOvV11lPOXo8jwjyU2_aDGo1DS9Ev6uoiXTl3a-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcuuehi
    vghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeeijeef
    udenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    guodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeelqdef
    fedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurd
    gtohhmpdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegvsghighhgvghrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrg
    hrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthht
    oheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:2MnMabzlLuIOMdDHdnsjklbTZHXD0_RQEbTiNq8Q267ZF-wY43t-Jg>
    <xmx:2MnMaaKf21xJI8X8a0i4PYRgx4ukZRjpUvVtpQLYv4ywyI9wyE1vVA>
    <xmx:2MnMadoWWSNl-3NhLzvw-Z_zO0m7WiH9AsaoqQkd9SQy6IgeMUKDqg>
    <xmx:2MnMaRLBD7oT2YPQoBFMhNFu0gnyT-E-ztvRpU-ZcCOYtqYNnQ0p2A>
    <xmx:2MnMaaQd2S26f81LOu27D9Oc3j_AM9QP7RDgoWPyVlNKcCbERNk-SNVk>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0A850700065; Wed,  1 Apr 2026 03:31:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AYwEts-iKrmF
Date: Wed, 01 Apr 2026 09:31:15 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-Id: <d44355c5-51fe-4d69-a347-a97f6ccb7d14@app.fastmail.com>
In-Reply-To: <20260401004431.151432-1-ebiggers@kernel.org>
References: <20260401004431.151432-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crc: arm64: Assume a little-endian kernel
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 1 Apr 2026, at 02:44, Eric Biggers wrote:
> Since support for big-endian arm64 kernels was removed, the CPU_LE()
> macro now unconditionally emits the code it is passed, and the CPU_BE()
> macro now unconditionally discards the code it is passed.
>
> Simplify the assembly code in lib/crc/arm64/ accordingly.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting crc-next
>
>  lib/crc/arm64/crc-t10dif-core.S | 56 ++++++++++++++++-----------------
>  lib/crc/arm64/crc32-core.S      |  9 ++----
>  2 files changed, 30 insertions(+), 35 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
