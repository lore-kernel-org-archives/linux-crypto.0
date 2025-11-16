Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11833093AA
	for <linux-crypto@vger.kernel.org>; Sun, 16 Nov 2025 16:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763311791; cv=none; b=bhxDm2646WTuBHWN720Mp7ll4BYPG6v9JoEB8l7McfyDrjQgDJMOL5ASnQqIc1rmWa/ZYiHC2VIcZ2KJnt/3yWVGQuYDpHw1durdPuREYAJd7kRxrAhqgYxw3AtIDhST5mYdF3CPnWXF6u0bi+L1KXbIfT4HONYnz/nmJJol9qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763311791; c=relaxed/simple;
	bh=CUPTKBgw0WdF7nGsD7yxeah7Cl8OgUDUMve2dz2HbuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BY5DVxTGGJ7HNwia+l++JaKHWNsyojCEmG0VPLYoKZMI62/CLn8EfMAD0ZABrL79mnlj9NspYwO/5GiIyzNXkwRCYq0StRRtI9P78p9+FPtmPtsJhpzp8Rp0zDG2vWeKzN/ricNa3V4YWn7zTcbQvQISUZQfes4LfqFayxujHFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qoy1gHtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qoy1gHtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234C4C116B1;
	Sun, 16 Nov 2025 16:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763311790;
	bh=CUPTKBgw0WdF7nGsD7yxeah7Cl8OgUDUMve2dz2HbuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qoy1gHtVMMMFcMsLq1O7QOg20D5V+qMNipfY4h+FIfXYJhlz9o+BRyvIg0ldF4iXI
	 SvQ6hDc+lBtJG0jdUSHtrTRdsrqqQtsDWVvqplPGQlDCdM1Y/MXnlzJ13vOpOE66Cj
	 9ksSN2xFd0bLYYs8jnSWuJcwMnTPW7WQbFvRI15avOuxhSl55F9yxGXhVQVB37XmcU
	 3HliZBZ2BjagosAiqF435CqwzFupIEcaZqcm+0WE5YYq0QKee+gWUxic2yHfr4bNDT
	 dnHbQEFxEOnmbGduZS4vXifu7HbhJJ4w8PhHHoxIAyS8OHVTBKq0MeHKxMGznrzDrs
	 NdQ0oG8AvYqlw==
From: Sasha Levin <sashal@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 6.17] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Sun, 16 Nov 2025 11:49:48 -0500
Message-ID: <20251116164948.3593978-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251111202923.242700-1-ebiggers@kernel.org>
References: <20251111202923.242700-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Subject: lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN

Thanks!
