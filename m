Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793065995;
	b=pz4Y1e19lodBQsdeBy99ule+lD5GUa4XmndJwx4yWGOWXTlUsf42G4g0IH8C79DBOxMg
	 j/lEUyHpBbRKmN9Gl4ROLEAPsJXBioV/wJ4/h4QLtor6PY3eOqMplIqjErXzHoc1mbf3u
	 vwE+3pl4PgWvLB6ha02C/PdUwEeSYghSiA6pud/m2/hoCKuTbvpK7opk2ooCQ1iFg+aTv
	 MgyeX3i/FSsdDt4HyI/y1Gq5KU9caEwjmDvN7LboLUIw1gExn4tBvlJsQ6SHvDhkIchQ9
	 K+IOmaDj6XcVOF3N9WF7dyeVKqqgaTdSvAWE8x+2IqozRGo38pzT21e/7yswQq7krIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793065995;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TZ3vDW+xlT4qckPyl2QtHhSTWtflIaJrQOwf//kUUbE=;
	b=E98BB9FzTqd6Ux0KG/K+0+6+FjxXil0+KTdNLSXNG8V8Yz3dUXxtOwA2/6vonq7TFKqk
	 Nmwv51bt6AkLPhgKMKz+xLalLDY3Cra/L8QhZr/TUq6UET/DF2sE2N4ATMt6IdUzahgfc
	 cRM8lJ1jqceEZjlc7CbxTh8rhQcpHw1cgM41dFfbvvSmeTNiNJPcuGxcDs6jrz30icbFd
	 9q8znEDuF2qDPiJ7dNsjjfpaf/McL5FkYO2qnt9/zK43g7INyXLFqm4IL5RFpXq1J+x3q
	 r/gM0EpCHxgZ+a3SczGtoy+ilRrbvUULtq0eB1TbMw7ZKu04ux+dXdgR1+51aHJGz6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m1CLdswt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA1A606A31A;
	Tue, 27 Oct 2026 01:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m1CLdswt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47FF1F01825;
	Tue, 27 Oct 2026 01:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793065995;
	bh=TZ3vDW+xlT4qckPyl2QtHhSTWtflIaJrQOwf//kUUbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m1CLdswt+XWBl5l1c0W9+gwTcKzCPrXY/WmApOYb9IaRGL1oA0M3JzuhydePXW9Fo
	 MRLF8ooewBF7ozFQJzERkGbwfG4XsZkBIagk5iJpWqWAYd29k/IV1+eGweNUsJO+6q
	 +2mlXeW8lgKhTK1Sg/3bHqWoQLsaAP4wfuM/98EaWLjo27WAT6ZRTmyXZ1XLbpl3co
	 WxVUuM6NW4Obh03VNtVOyLXcEn2m365cpV10HUoKeSQe8z73JIuLeVxG1hqUm9uDsK
	 JWq3Ozx+JvY8K29p4MZ9dbvmyCaiB2+mu8j2H8YWco18n/4IVK9nHhkabhcJOroXoV
	 2KtqD79HIAG0A==
Date: Mon, 26 Oct 2026 18:53:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Antonio Quartulli <antonio@mandelbit.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib/crypto: tests: Add KUnit tests and benchmark for
 ChaCha
Message-ID: <20261027015313.GD2395@quark>
References: <20261025234758.3219829-1-antonio@mandelbit.com>
 <20261025234758.3219829-2-antonio@mandelbit.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025234758.3219829-2-antonio@mandelbit.com>

On Mon, Oct 26, 2026 at 12:47:54AM +0100, Antonio Quartulli wrote:
> +	for (size_t i = 0; i < 10000000; i += max_len)
> +		chacha_crypt(&st, data, data, max_len, 20);

The calls to chacha_crypt() with constant 20 argument should be
chacha20_crypt().  Mainly so that if people copy-and-paste this outside
of test code, they use the right one.

Otherwise this test looks fine.  I'll apply it once the merge window
closes.

- Eric
