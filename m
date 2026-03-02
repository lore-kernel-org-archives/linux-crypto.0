Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBFD199FBA;
	Mon,  2 Mar 2026 15:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772463703; cv=none; b=gM2qYHcNXo/gjces55AcaSgj+756O9CsGfpvfkxzGeil+oG1mXKz4SWP1FeD1Dem+aWQM3N73rLaeD6W4Sc+rSybFlsn/ns1BSFcISYiuShJSmknvdZ7S7or6SCaAfRf4tMziaTTEQMRNX9vmOpW+dzjCoy3NuR+WwMXTWadhMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772463703; c=relaxed/simple;
	bh=maqDe6NPfVIquOD2GOighvv8QFIrYsBv7aw26FBg2TY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=ZFLA7QN72NiECGx9PBTxI2QGvN7aw6zOREA0AqOD5uA7MQeirKqsTFAvCtLk4SZ8GC4DGbVXbjJUa5e+gscf/k63iXh2lEWeuAoxKRHBiclQ/DKFHWrL+ltbEs2m1Gl/vSnFGVzHii5/13CaMge0cxIPW8ph/Sq7qeN6kiXKlnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=phGw8JTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="phGw8JTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFE8C19423;
	Mon,  2 Mar 2026 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772463703;
	bh=maqDe6NPfVIquOD2GOighvv8QFIrYsBv7aw26FBg2TY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=phGw8JTPfWT2pnhdQNJQuj1js3KwuvX16dNDPpUes2FE0hFSqEmGnAc8DVtW1QGJI
	 Rdc2pcXChMrMbz95xgj51DlHKuUl9Wq8NK9fV/pEl3UGEvocI0jacC8DZDlmrYrlpz
	 OxLiQJTz8eqzNpOccGHLvRQhvYWuRUBFAYUod9JJYZpIazNYLB2x7SaL6cbTxmhUx9
	 L+5C9vi9Zs9nQO6SoQqjizRdiycWEf5jVWIm0Om5DwKSZpwh6aHe2jp+YZrW6nt+5J
	 T0BI2tu9+WLZzt18JmA81ifweNElfWzUyOM2J6/L5tV9V/TRVlUzLYjVdyQPxT4ir8
	 6x2owRUYJVCfQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id EF790F40099;
	Mon,  2 Mar 2026 10:01:41 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 02 Mar 2026 10:01:41 -0500
X-ME-Sender: <xms:VaalaTUlr_62YhioR00PH6Ad1XnK8iVZ13U3J1YOEG238K3ckIxFzA>
    <xme:VaalaWZJa-quWcfyCEeHA1peJ3fPyEY7M4StgRrihcVWNPpox-lL8pqGDdpVFu2R6
    w3eMHSfO7c7GUE1MEObUzPnbzS5387G0uKwziEJQ298G2XdOKRuCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvheejleekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehrrggvmhhorghrieefsehgmhgrihhlrdgtohhmpdhrtghpthhtohephhgvrhgsvg
    hrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopegurghvihgu
    ghhofiesghhoohhglhgvrdgtohhmpdhrtghpthhtohepkhhunhhithdquggvvhesghhooh
    hglhgvghhrohhuphhsrdgtohhmpdhrtghpthhtohepvggsihhgghgvrhhssehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopegsrhgvnhgurghnrdhhihhgghhinhhssehlihhnuhigrd
    guvghvpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepjhgrshhonhesiiigvdgtgedrtghomh
X-ME-Proxy: <xmx:Vaalae0FbkY-OeIjS36iRova0BkWKbr0iReWiotmMOpPG2W5Zvts8g>
    <xmx:VaalaUJ1HAPpyJDwxH9aGZ7Qo7_Id84Yq1MYW_4T52cde6nAhrpo7A>
    <xmx:VaalaRgRbZVkzvCuHYry64hCjFhmim5JR3vGI8OvtCuNa8muRV2C8g>
    <xmx:VaalacBO7gfvcvHXwMmdnB5FG8xaN5uoz5mAS8z8TeL9Bse0ydf23w>
    <xmx:Vaalab5w-Cc64NLJnoeyepOUty5opXHlIgcO8g4BTbgyuqnATg_gwfyL>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CC19170006B; Mon,  2 Mar 2026 10:01:41 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A6P9aY1iDOPo
Date: Mon, 02 Mar 2026 16:01:20 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, kunit-dev@googlegroups.com,
 "Brendan Higgins" <brendan.higgins@linux.dev>,
 "David Gow" <davidgow@google.com>, "Rae Moar" <raemoar63@gmail.com>
Message-Id: <80de5b59-74d4-4009-9870-15bf2da35ce4@app.fastmail.com>
In-Reply-To: <20260301040140.490310-1-ebiggers@kernel.org>
References: <20260301040140.490310-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: tests: Add a .kunitconfig file
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 1 Mar 2026, at 05:01, Eric Biggers wrote:
> Add a .kunitconfig file to the lib/crypto/ directory so that the crypto
> library tests can be run more easily using kunit.py.  Example with UML:
>
>     tools/testing/kunit/kunit.py run --kunitconfig=lib/crypto
>
> Example with QEMU:
>
>     tools/testing/kunit/kunit.py run --kunitconfig=lib/crypto 
> --arch=arm64 --make_options LLVM=1
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This is targeting libcrypto-fixes
>
>  lib/crypto/.kunitconfig | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>  create mode 100644 lib/crypto/.kunitconfig
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
> new file mode 100644
> index 0000000000000..197d00065b4f5
> --- /dev/null
> +++ b/lib/crypto/.kunitconfig
> @@ -0,0 +1,34 @@
> +CONFIG_KUNIT=y
> +
> +# These kconfig options select all the CONFIG_CRYPTO_LIB_* symbols that have a
> +# corresponding KUnit test.  CONFIG_CRYPTO_LIB_* cannot be directly enabled
> +# here, since they are hidden symbols.
> +CONFIG_CRYPTO=y
> +CONFIG_CRYPTO_ADIANTUM=y
> +CONFIG_CRYPTO_BLAKE2B=y
> +CONFIG_CRYPTO_CHACHA20POLY1305=y
> +CONFIG_CRYPTO_HCTR2=y
> +CONFIG_CRYPTO_MD5=y
> +CONFIG_CRYPTO_MLDSA=y
> +CONFIG_CRYPTO_SHA1=y
> +CONFIG_CRYPTO_SHA256=y
> +CONFIG_CRYPTO_SHA512=y
> +CONFIG_CRYPTO_SHA3=y
> +CONFIG_INET=y
> +CONFIG_IPV6=y
> +CONFIG_NET=y
> +CONFIG_NETDEVICES=y
> +CONFIG_WIREGUARD=y
> +
> +CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST=y
> +CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST=y
> +CONFIG_CRYPTO_LIB_CURVE25519_KUNIT_TEST=y
> +CONFIG_CRYPTO_LIB_MD5_KUNIT_TEST=y
> +CONFIG_CRYPTO_LIB_MLDSA_KUNIT_TEST=y
> +CONFIG_CRYPTO_LIB_NH_KUNIT_TEST=y
> +CONFIG_CRYPTO_LIB_POLY1305_KUNIT_TEST=y
> +CONFIG_CRYPTO_LIB_POLYVAL_KUNIT_TEST=y
> +CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST=y
> +CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST=y
> +CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST=y
> +CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST=y
>
> base-commit: 4478e8eeb87120c11e90041864c2233238b2155a
> -- 
> 2.53.0
