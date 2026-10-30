Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793393654;
	b=XWAFNc/hAMv0CSUPJau42gBd2NjIPF/8NPTZLBMwx2sYT4fFkqvHkbQCcTrr3FY87GFF
	 M3KAfnoW5+9gGQGWrkDT6fn2jo1hG5uoC/dEtSOohp0DV2j98UqmbvKst3IeWobodven7
	 WYVBXxSkaX3edO3Msy3FyU5X+6FN5U8D7OowfxVsnavhjtQC+E0FHKWabsl4m0+GMRbr+
	 qmVo5GPi5kSLHBFkeGadJxiuuqsrwyys4zFIbGneIZI/qVYAWzNEirEfVHfxf2aFnIM/8
	 rhMPa6iRdJO3FmmJJpn2TJ8NTsaaMHDZGg1wApN+7Xska/wnGQqxPhd3qWdhzJBV/RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793393654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=X0lYYe/wCl6huPOqebzWHZTcDSo/atNz2oair4XDCQs=;
	b=N8UgFsArvKglcvdApGyiIMGDzMQxSw/IYqyqtKPmL1cq8zfOFqUo3FdhSx7XBWido3+h
	 6RPonTGONm+zljbdPJkb7Ec6hO341YbjyMLi5AFArE5rU+t6dEiXtU0ST0ed9GtMI2Ebn
	 TS8nNC231fC9hh/PpsqaHBfCnscwizZsOsKcB+SMmESOF8sGFJyGFQzAmCbRIsvkS/6iw
	 tANgVDSlNEOskoFOkImSxsevzpgSOMn6CuSwGPEz2HLH0unkjHqgYok7KD4XcQaKI84LE
	 IQS/CaOh0cvK5FZGoWaneEcKP8lyrfZ8ZfvKPy/HhqdNO29omrmoYdG9eeErd2O4iWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJ30ZDQw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2E7606A31C;
	Fri, 30 Oct 2026 20:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJ30ZDQw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9741F00A15;
	Fri, 30 Oct 2026 20:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793393653;
	bh=X0lYYe/wCl6huPOqebzWHZTcDSo/atNz2oair4XDCQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJ30ZDQw0wH5T06kutDrnBN0YEFnyGDdfBuANz1vbB/xq0kzCM+VHopvcysZnGU08
	 74QTr1gbUhTBjKlo/XdCCFKoBtqsGaHHAHjOxYxRyXaeS70qU8GYTx8NZbIv28WAdX
	 tx3gFz2x2tiouBti7mqTVjDV/+o1xjDmf3sSxas8V167NJnUsO8eX07zukPMlhPNyB
	 oX4Pii+l+MiFVlXd9aaGTZ6vdIWzOK4rWaUEg4drj+fvi2HI9mGrRD++dCxFIOXFre
	 9nwNCwxE9AX0qqKm/ebjo3DHXCP0pNGMa3k1E/MqbEbxE1NArJ1rKdfhhfb3/1oIX0
	 c3hSrLXwmFBkA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 6.1 1069/1887] crypto: jitter - replace LFSR with SHA3-256
Date: Fri, 30 Oct 2026 16:54:04 -0400
Message-ID: <2026-10-30-1-daily-reply-0001-jitter-sha3-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029210038.GB49373@quark>
References: <20261029210038.GB49373@quark>
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

> But also this commit had known bugs that were fixed in follow-up commits
> such as 735b72568c73, 908dffaf88a2, 9aa7e045f4af7, maybe others.

Queued the first one for 6.1. 908dffaf88a2 ("crypto: jitter - add oversampling
of noise source") is already in 6.1. 9aa7e045f4af ("crypto: jitter - Mark
intermediary memory as clean") only adds a KMSAN annotation and is not in 6.12
or 6.6 either, so I left it out.

-- 
Thanks,
Sasha
