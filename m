Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794434112;
	b=r2zUPObxC7nr7p/KZm4m5ecIxYJyKcGoEuPGv6srvB73+gO+hMEh7BsFaATN4WVqY/Uq
	 Z6vsIBJsC76FRqyrOTtfPYaOWW6/AmSY2tjePEJSu0u9CH8uul996PAoMW4WsO2cWN6Sj
	 j/Bb/5e/ZfCb1jeR6AWek/erTnDJexUIbyIvwdIJzcetj97xPpXMvBFOa7qCYi6p1KfGo
	 q91Bl6/i6DLF5oDWv7Ih1C+R0skyT78uCRPHRfLYYxtXMof92xqbOEydOcKTcxT7rq8DT
	 gUc+JOPI+QGiPMzKs7Z0Clj6B+DQHc9j7F8HbYClUFO4h0dJOPtczPQNJF1KqKGr8xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794434112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=r90VN1i946TL4syWfDlOVhXHniHktEZtEL8fMtnnM7c=;
	b=rv1rJOstL5k0EpXzXDh/UEs0g3hFPnWih5R+g/7ngULQO7pe6oCAuTgGYi3MIbZen2Bk
	 AzL9bygd4ojLNANt+K2sQM7EDpMpJsnI965ufANyxnmS7bGUZIRg2Qa5TBL61+pmoRhQI
	 TdzUxzy7vp2gsPstdS98Cxft93bN2MY6xxprbg7CVHl08JVz7vPFxT8o+od11dt69lIbw
	 /PUoYVKhqlIAoY5k2Bbn00hORZUtwrh+LLJglwhAsQK0p/iwHAC6SkLUvSZf9Vj9fjZGb
	 JMy9KidwrONVJTdWnBKT5X4FPzNjwok8aJjNXfT1ZmCXK6/gpaq5skFVu08xbg1V65g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A+O3RsxM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED08860A2613;
	Wed, 11 Nov 2026 21:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A+O3RsxM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CD11F00A05;
	Wed, 11 Nov 2026 21:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434111;
	bh=r90VN1i946TL4syWfDlOVhXHniHktEZtEL8fMtnnM7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+O3RsxM7TROwsstQ5pqyZ+NGsVnJI/JVxOxQuyZF3/kD1qylWNM7XvlTSCgu433C
	 MvBXNE7X7Iq0cKvXzj8AHrJyIRVkOuHQkV6gQYBndU0tlsCAywWI1IeWKTX86cr5wZ
	 VP9L1klvh9sYhBZNgOPb4u1PU6vg0w+rLAsPPW8u1IDE2RZ189Qal9s8KZJ15lrec3
	 W4+UcgrvR9+TvAyshbz7B1m0rlcCTne9YN1rEb4rXoBXSXqxgHSq3tdies7kr5Axr0
	 psfpYI1ZQyLQLNq8yIRuR8fysN24+tG4dYaI1+9Xt3Woo2h4jVYKvT5qoe72A9Ix7l
	 /sP9ROGBdBegQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-mips@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 6.18] lib/crypto: mips: Disable Octeon SHA code on little-endian kernels
Date: Wed, 11 Nov 2026 16:54:46 -0500
Message-ID: <2026-11-11-1-daily-reply-0013-265a96e30ea8e44241b1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110212631.36307-1-ebiggers@kernel.org>
References: <20261110212631.36307-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH 6.18] lib/crypto: mips: Disable Octeon SHA code on little-endian kernels
Queued for 6.18, 6.12, 6.6, 6.1, 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
