Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D86139DBE4;
	Sun, 19 Jul 2026 15:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473243; cv=none; b=UYuYwwOE4AbOTqBomyDoSxZ5t3gGNfeC9R+P0g58H8gG2kavKz1G3WKF7lEja6zEdSDx4N46Np0FF1dYiolkZDDyhLjLnnuXmSTflssv2LnO+OVaqZFnqjxhTTQCOYfqnaeN+oOTama5AgtkfHjJuCSM6o43hTRQhvqrlpEBCOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473243; c=relaxed/simple;
	bh=tGhN2uV1WzLAahSp0Hy4ZQaAuCy6aDgfirOiN0tGWXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cc7zwPfs40N4NFLyEKx4oagzBqyk8o4Mv7QUiDZCCJUyFD4JJsEDDZN2DkKxqxvOSI1jZm0S9f76OYbk9mnboME8I+GkZCVwxCbWO2sm2W3Vz3X8t76djdTGzD076lZusEnJ0vsX/WDUJAXv50A8lFYeHr/tlEEwUYWUbTfOr0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZ0+ajDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZ0+ajDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F591F00A3D;
	Sun, 19 Jul 2026 15:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784473242;
	bh=WpkD8MQKrC+jDmbGLobs0i4G1Ax9jQZbVYzYuUo8JNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZ0+ajDdZBVVDxM/Z+FsKyfH3QIBYzg8xeIngpYR4Jiry229cVCI1X8AV0YNwbQN7
	 4/t2HvEYfFGo8AUnGIcKzYsT1ZPuknXpBEglT/iOwPHMuuWlUNWlig0+SlApo0E07I
	 yhGQF4R1MKw4Bhi/Wz88BgkCZMhVmu7nBo2JexHicBhc6IBeEiLLegdk6EFcX2fQ4o
	 G7gK3OpE/rna7M0xu+3BXwnQgxZGOBOqmk/wrZXFmSujp+nHTGJuQ6v7NH7Pb4K4pf
	 0rrH7zMfVBBhOG7zua4TcsAGTKD2pQ8kh/lXsIMHxkN269qNYf6MDeT23htlfTlg3J
	 66tILWBPcwVaQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Taeyang Lee <0wn@theori.io>,
	Feng Ning <feng@innora.ai>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5.15,5.10] crypto: af_alg - Remove zero-copy support from skcipher and aead
Date: Sun, 19 Jul 2026 11:00:16 -0400
Message-ID: <20260718192718.0002-stable-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260717033403.285821-1-ebiggers@kernel.org>
References: <20260717033403.285821-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The zero-copy support is one of the riskiest aspects of AF_ALG.  It
> allows userspace to request cryptographic operations directly on
> pagecache pages of files like the 'su' binary.

Queued for 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
