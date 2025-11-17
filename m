Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373101EF38E;
	Mon, 17 Nov 2025 14:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763391596; cv=none; b=tI87mgwnrw8b5Qap4aVzR5a9qmsCB445iJzwOZkzQ0V4cSQsxKDcwMEKmRqBf8ttjByFRo02jitCMj3Uj08dx9/GgVLUoenQ+6V1znJLZwq1ewaA+aDuKrHg51dfJFdu7kr7ESfwyjzDIl/Ng34YoHwUT2GX8obF+KvTlrOpBzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763391596; c=relaxed/simple;
	bh=nmgQRjDb8Oft8KIz4WO2O7/+6kdhzlFMXqAK4ZWWCP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEfNVoHU0sjN04Y7ltfu8vCplpi4nO49cnSp9inqYI7AEsb1UAOxJBSJzlzySiSulUGtTj1Wm02DYX1vn1mD517qmfTVff6b+GEh+Oq65vZoj1fp8iDO5hw34w3aUqso5r/imoiB1dCv/uJ9VUpPgAYy58jePN+zWHyeACKspjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J1eHrOyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J1eHrOyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEFDC113D0;
	Mon, 17 Nov 2025 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763391595;
	bh=nmgQRjDb8Oft8KIz4WO2O7/+6kdhzlFMXqAK4ZWWCP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1eHrOyY1qSiec0KjVR9jemBmuciaXDsxGaZ2NAuDuH36u/O8Qijmj7mzAxsWlWMo
	 B13geUyMxyfjuqJ+Lu8qqNBaa3ulndbPfZjFIbOObRaZfy1SRNWrsL87XQhf16jvKo
	 iunOMdDpxFZmzVty9B3ijKNnrayYKzD2LxZ4cdVmh4ZVJI0hmpYBUvmZJTdF7SGBVD
	 yZhdfXucrVLt9xlI3z56uOrZCyeAw58utOn9g1OaT6vy4yarFmmrovj5fnwdlGlFD0
	 Gffv8cC/iSHIbEMh5JXF32z8NWGbUXSnLQ9F+uYaeljx17KIZG4HjdKBo9yFONO058
	 rY4HRpkb18cbA==
From: Sasha Levin <sashal@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5.10] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Mon, 17 Nov 2025 09:59:53 -0500
Message-ID: <20251117145953.3875849-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251111202949.242994-1-ebiggers@kernel.org>
References: <20251111202949.242994-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Subject: lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Queue: 5.10

Thanks for the backport!
