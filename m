Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B5D36E486;
	Tue, 31 Mar 2026 06:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774939913; cv=none; b=G634v94rFWgs4i0f60FYubX+W2wMbHG2BkWvFFu1cRk9RoHlphVo7I8dQ5GLNln2oGUDqnscCZ755z/pkSc4UGx4hFJeCuMdr+q5OoXOWaDcUSu+QZy/slraWHJBDRuwNfyBUGI32vlQNxeNwm6/AMc27NyeuDWNEamDUBMvIQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774939913; c=relaxed/simple;
	bh=8LAHcu0djLFp6QPvsaFPJTZvDG4Oc6LEUgxk53fe0p8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=GftyWi/nPDPRwDhlIgDNT9nNudrl2GVfFEZCbtX3scG7qfPoGm5itIMmkpGAoy0FYjPbxchak+F7KIaB1w+Fuwlzl9xUK29fiJrtEAHy3OGyALC1uZge0ex2DTpqdtYUEIrY0eKJGctAku9u+z6hDxToy4LqS6VX8n4Um0YVF10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=knn933Lw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="knn933Lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407C9C4AF09;
	Tue, 31 Mar 2026 06:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774939913;
	bh=8LAHcu0djLFp6QPvsaFPJTZvDG4Oc6LEUgxk53fe0p8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=knn933Lw8pqOZIrCFaOvL9E8gj+9y1jGgkbJuyaUt5U+4pEdmjSIajttDi4aJwUNV
	 furGWNnSgNlsNhHm+0poTysI+6aUmqL98DeNgJeDzY75unWIOC1KHyuCGfH/HSdTHP
	 mUeL0iXRNT9nYQ1qBMMewMjvJUhXlNTwV3Va6lMosQqD83JOJOcJyly53zoPFQ9Xla
	 ZzFeg5QYCkUZ1sQP6NYkIXUkG5lCgy0Q+hBj7T7ZsFxq7aKbWC1CUwBXxxg/m5kxrg
	 sGAT5jmng29zJvXENzozSnf0HqneeC2BWC4l0zc+4rQn2gxUN27wd9XYMR+yFa90JE
	 c8mT2w0meG4SA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 45868F4007C;
	Tue, 31 Mar 2026 02:51:52 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 31 Mar 2026 02:51:52 -0400
X-ME-Sender: <xms:CG_LaZ244790v3kV26eXrnI1gtY8XwfIAnXqU3CMIt7_gPodHmzVkw>
    <xme:CG_Laa58HX6x86wHlnbGZbcMA4Vpo9QJlzAvZdvOP_mPCOYLFOk7N1_uPGNWaQPMy
    OkNeVsxKpU2Rl0cLji7Pfgl96YKEyn6FkrKq827-fA8anOBdJNqXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefgeduvdduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpth
    htohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhig
    qdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuh
    igqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjrghs
    ohhnseiigidvtgegrdgtohhm
X-ME-Proxy: <xmx:CG_LaXhWIhCOK1u_DAOEdDK8fe_TW_YilPCl7oWrjPdiKCTjovb1Uw>
    <xmx:CG_LadUQ3GINdqbnk1cJW5PSyTqP_pXPkyR88yiMbolkFW2q7HRNZw>
    <xmx:CG_LaeVXpG-Eth2IsDjLQl399Eu-llXFJ8yNTqwTPVpZ4WQh4rx5xw>
    <xmx:CG_LaVhJPVx9mv7BtWOnGYFkzcyBiFXU18eTjdWbeQp-tLsWpoVYvA>
    <xmx:CG_LaRbBJVF5EA51uGePiBbipse5OUhGbWIRDnQqBDXS-MDWf3e0wCZl>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 2912F700065; Tue, 31 Mar 2026 02:51:52 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ANERO4hFUFtw
Date: Tue, 31 Mar 2026 08:51:21 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <ffa582b8-75aa-4ccd-b618-62be907dc788@app.fastmail.com>
In-Reply-To: <20260331024438.51783-1-ebiggers@kernel.org>
References: <20260331024438.51783-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: Include <crypto/utils.h> instead of <crypto/algapi.h>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 31 Mar 2026, at 04:44, Eric Biggers wrote:
> Since the lib/crypto/ files that include <crypto/algapi.h> need it only
> for the transitive inclusion of <crypto/utils.h> (and not all the
> traditional crypto API stuff that the rest of <crypto/algapi.h> is
> filled with), replace these inclusions with direct inclusions of
> <crypto/utils.h>.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/aescfb.c | 2 +-
>  lib/crypto/chacha.c | 2 +-
>  lib/crypto/memneq.c | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

