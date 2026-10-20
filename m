Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792534360;
	b=xtV8WesZrHOuZTUv9JdMFNTO9Uq9hRPaUy8HlDiLdu4NddJQ2Z+ax8S5nEXrvzALzirv
	 mkU1ms7zSRA8FfWh0XYZBqww5eAwOnOVdV0P+zQfZzXFo9cx0HnywgnbRQl/Lp397ENA8
	 oqVCnDEyKnJaU9ulHWw/gFhNqdwEgsncgyqnmc8mhZ5JDnfF+JFoPS6tRQgz5sM99MuMR
	 kLRiS5ivftJun+fnujEMVywUBWFW0U2nSfbt9tLatGaEg3pO5/S2nQ8zx/WWSpGhfZ2BQ
	 Ep6zrCuxWq8ySPnZr3/GUkqoHYvYbmaFDnLuksQaC9uICz/4HrMTvSvd2OqFzpk42UA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792534360;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=fmgtIA6qJwkKohZoeuwFtzYE4O7BOOE0HHX3RbG2vyo=;
	b=HIlxfQcMBwC5EC/BBUunAm5imeNJp9V0a3NF1ObuqbCrjRlF9aFktXhnmw8DCSbZUKr4
	 P49JqeYmCF3CE+9yYXh6/ab8sEHjX7z3nbaUL16CIBUvlsfR4vG68g+90iYSgM+d6tLgr
	 jQ+lF5b6fxOUx4KT5BtmhXMUVlXW2MQ+5QqLiY6m/f7GepTvdNhKWrXIUlVO0WNDJPy/D
	 diWRlH/4hPPby0qXs6jEbv/UG5Z60G+mjYcttBZuX2m4FKJnpD8gLJEddT9yECclPcpH/
	 tOoMzn64TgODGCxE7ULLVBemhN7tDGLVyYTYEhW12sCL/7zzbgWBrtV2MU7NUQ2Emgg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zx2c4.com;
	spf=pass smtp.mailfrom=zx2c4.com;
	dkim=pass header.d=zx2c4.com header.i=@zx2c4.com header.a=rsa-sha256 header.s=20261015.g header.b=G2N9PesU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8972A606A319
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 22:12:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8972A606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=zx2c4.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zx2c4.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zx2c4.com header.i=@zx2c4.com header.a=rsa-sha256 header.s=20261015.g header.b=G2N9PesU
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4395d31228so3866466b.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 15:12:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792534358; cv=none;
        d=google.com; s=arc-20260327;
        b=FXLjAgZ+ceSnxK/G1w/fSJu//PpbNVzsAOxMgPyEKVKgIOhMPknT0B8gqUkHu7gBkH
         kgtWGEmySXt6qSxsRd8h14bEgAL6O3lxvWgplqFLXtoiXGOQ5UoaJcyWbGHas3YaVPMO
         RmT3ZJjtepJ+HeTswrvtqOkpTd8XxlxARIipflx9wYV2tTwjM/+uy/eWGfoMf53agBlB
         buCh9VTr0+QEu2raa1enfgtRgS8wYkxsFo7bz3j9H0690oKNKIkBG7U3A7mIW1vZXjfv
         YGDYWtXSpRBkj9Kwaf5sPIvIoDJ0UYH2z3/aNpKfPtJQ8YAPSIeaCTghVfZLRkzcArmS
         baMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fmgtIA6qJwkKohZoeuwFtzYE4O7BOOE0HHX3RbG2vyo=;
        fh=yyMrSz7EaJugjDtizEN8nXvIoT9tsyfaYzA4leguV5o=;
        b=FklsL9GB2IVRAZdGOV5ebT1Z/Stwyp+u2Ujfaw+oFF0NninkUr9yFBO580qzAxfP+G
         ZDD5yJv9ssXjCMkiXE8i78j8/mR0rf2ESj0IWxIDw3gkvHUbOcbhgRtCX8tNyEzs97ts
         YsGTtmMiWhp4mq38tA/4oKIuJHkYcGxUTLqRjBgt7gf8ZJWHOGWwQtYhtPK3isKGknqX
         4WUwR6TryYghmp5Necg6MV53Z4aFDefVZoWbLaTrBzaWBZeI3e/qOVZl7t13B27xhgvY
         g1zLvfH1HIth29pPZUK97UR6v6zweOZWRFHS/+H/Ejnsv7xNgAYvElYujx6Efll1LKRF
         9Jxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zx2c4.com; s=20261015.g; t=1792534358; x=1793139158; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fmgtIA6qJwkKohZoeuwFtzYE4O7BOOE0HHX3RbG2vyo=;
        b=G2N9PesUWPGFmepm0J3netFFC2S/zzTtzrL5hnp54WSlvaXCLgt/qmkuWaitmMpea2
         vq1QJK4NC04VtZjnAyu8A6F8pMWYoL+VujbrgcKKSGuktv1dtFZoas9oODP085p/LBVb
         DvDchEM9UatsJdVdj/5YHp5f3TQe4uiErQJL4uv4ySBuJOQTLzvtW2J466Df624gBp03
         2jKcbtK5TYt6fmThgBZ7c/grYLoiQRp61XOK77KvGUerh+ojLUx7emLviziK4qD+T39/
         CqqBt0l3DZPoouZ2fb6sFkQNcWoHPi6cVuKY9c+CDMr1K1pc7hfvvEWQwesqcc337OVD
         Yn1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792534358; x=1793139158;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fmgtIA6qJwkKohZoeuwFtzYE4O7BOOE0HHX3RbG2vyo=;
        b=tJKj8uKLCQDp4uepGcxmBkrhNpOwGxmGkhPcJCpBsH48gaSnQJSKhl+v3G0J7DcMgq
         KX7PMHt+52HGQDCkAFoeGKgqxSjXtti3ddLU+chAs4XsP7J0x7ZILDA/UEXhbzRWzxAQ
         8hKXnZRbWYg1yjNXYsvjfL6ph5vaiM+GL+/YTiVWOvSjM5SDbg7Y5k6JzKkHI2VgoUEY
         JV2NhecT2ETRQHLKe0mMNq9KtbTvRDcorLZ8Fse0CGM6i6IHn39/fS/LqCBdSNT7M8zZ
         Sm+uyd/XpqiRVq32xUjczm1dY1zzlxyF78nRc2zxofmsRsPbRb2RUeKPwHxzrJDPYxWQ
         4WiA==
X-Gm-Message-State: AFq9FYIEzDFVPzBPsklg3WJMtnNWxUKBex48aFOTnA2kBBu8SSMrw5LR
	SaB3YRH6XzDvkVa3Yhn/BmUbr9D2Ab11RiLo3fCgERA5dGg/HhZlJmiPwOVkkPPsrVku+qb4udg
	Tulj0A2J0/ahHmoohdimF2JHw3iRR5F4qOMShLaM+gEAVuaLZU8Adxf/FjEI=
X-Gm-Gg: AYBFou1HBOzBTF9QB6wpKpT2ExCIwzkBfwUkpvn3VE2lHNeWLFu7aF1iQouq0hi80FJ
	f+H3metaIcWEPEXgMp4mLS9bF37wmhaE5SEreALbdLBesIyOqFpXYGyZkUeCFIfL86uKxsqvqi7
	hJxQYWfGP/K7AfN1rP0CN/sLVCw/GqlVUjEerGlq5YsmiIf5tdVybUsm6tkVVPLL7o8Pk9MPWoo
	eUH9bl2eThVepA9idsGv74ceKfwBkq2Z6VDf7/mKdhKNy6t7+O+ubXMzfjNnaPav6mKOrY77+ai
	V50veIqRLHgiwTR9T3PQWrpLtFaYIukN0UEDBwzs+FI0KOjmddPdSt2zXdxs7M8rmweK+lJ+rQt
	VkAow7H5ZlTsKLM84GePfX/lqKHXFZ+VATGxzQNsM1jWIr63hRSNlOgXINhS53xomVZOn
X-Received: by 2002:a17:907:720e:b0:c2e:4b90:3c56 with SMTP id
 a640c23a62f3a-c46795945a1mr32948066b.13.1792534357620; Tue, 20 Oct 2026
 15:12:37 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261020215744.GF699485@google.com>
In-Reply-To: <20261020215744.GF699485@google.com>
From: "Jason A. Donenfeld" <jason@zx2c4.com>
Date: Wed, 21 Oct 2026 00:12:26 +0200
X-Gm-Features: AclHuK_0ajymf4Y6YMD5nP6i-vQFp_7zQDAbXeOx0gHvqeUirR5zMsRTPCmAiDI
Message-ID: <CAHmME9ra6ZhHkv-45qmWdnG4W151OrexZ_A6ixS5rh9G3zeAOg@mail.gmail.com>
Subject: Re: Enabling Sashiko replies to linux-crypto?
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

I was looking to do this on the wireguard mailing list too. (I have
some review comments on a PR I need to address for that.) No
objections from me.
