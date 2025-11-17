Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D658523A9AD;
	Mon, 17 Nov 2025 14:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763390408; cv=none; b=O4qbr85rCJ7tdiP50lRntTi9fwSzWSkUMTmk2btKEoZ82ru2baqhxfLRom39hOGtrBlhF4e22wF07GwkX+FXSE2wJENmpwsxtu2VqQrmUnPf/ZzNJfPnkIIK9/8nlp3DkfmCGPd8Y0n5jDzLULa3W+A7p+avT2W6/PP4mbYaiJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763390408; c=relaxed/simple;
	bh=XG4H2La49IPH9JICRol1XWzBsQIr45lU2UQ86VKuZj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOESPblKt2kPTNp94hjp8vWqTq9Ove4ZhQue9nRgc57Z1aWMmPSyKaRhX9bsEn6E/E+GiIiTFrx0Ww4KK7sutb1mkPBtJbM6eBeE6ajBYgAoaVh5co4cVoxpfvS2EXPQW/SxpGuEc7bDJDu7vkwQCPA/dYJ76CVhxa7ixqpnsIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=idscZYcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="idscZYcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E0AC4CEF1;
	Mon, 17 Nov 2025 14:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763390408;
	bh=XG4H2La49IPH9JICRol1XWzBsQIr45lU2UQ86VKuZj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idscZYcHGv8Jv8v/H3Yp1ccb8itJfApmliuqawqYoj1TU+gC7GlNIWYig75Jfbw8L
	 5WZNBJR85ofTXv2ZDQKM7MaTdcftnDlr2fMJ5U6Bcbya1TiP2ewaqj7Asto4J8WifV
	 msAPKmlXF16VoO6GUkTDVKMw892GNoIgjLBLwi+YaUsrKLKMlm1gWXao+r7obUk2v7
	 Zjk+9xokWwv0v+iWRTrWvxiOIkvPdw47xrq26jfVTleRuINaXqV9eW2rNzT2O5iNsI
	 fqXny0ZEzZ6gbJ7erJT9bzq/HkZsJR5jbwBo0/qdn4RIAg+y/yNP9EzXCHCbldNuEJ
	 ziCVbKbEout4w==
From: Sasha Levin <sashal@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5.15] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Mon, 17 Nov 2025 09:40:06 -0500
Message-ID: <20251117144006.3870742-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251111202946.242970-1-ebiggers@kernel.org>
References: <20251111202946.242970-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Subject: lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Queue: 5.15

Thanks for the backport!
