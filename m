Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BED723A984
	for <linux-crypto@vger.kernel.org>; Sun, 16 Nov 2025 17:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763313584; cv=none; b=NE5xNYSqlfUSj4rECpxCo47F/38LHK/CCRsGPfCFLQe6L7g8Crkoefe3tkfSk2LYakYo4ZedJvaIbtatUvpsR8cBODmOIWOkE8EZ4Sngjx2EzJJJQ/aSSF43GSoO+k2OP4IbxsYUJGFnAuB1UM/kMsUUwtmiw8TPk8UR6DoPbmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763313584; c=relaxed/simple;
	bh=CUPTKBgw0WdF7nGsD7yxeah7Cl8OgUDUMve2dz2HbuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEsw8pc2ip89t0WvuUMTzwAhqruZJirmJE2l+T7HnBxaEXmqePiAjR0VU82lOebziUh1mWBozbkcTqB1iZn2NF+MCwmjl3PVMZzk3a8RQkMIlO7/J0p1Dw+DwdsrgpXOTghNiKWotUFiiBYDPU+DsgsrG8nRmxZZVJky8EIUtN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q+4mQdLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q+4mQdLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DEBC4CEF1;
	Sun, 16 Nov 2025 17:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763313583;
	bh=CUPTKBgw0WdF7nGsD7yxeah7Cl8OgUDUMve2dz2HbuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+4mQdLzJyOH8fyS1uqXt0v7AG7t8OmsI2G9Je5Hp4y2v5uO7jBYLvvVgkGNVbabI
	 5za5wIl/PctGaowYkQNlLFSco9WJgRoZG5Mz9W8iVxQEv5v8r26/umekNBI/GAhUYU
	 hVsR5nTcsXLP5rdSDa97GKqjLvI46kS8b4X/14Rcg6WuiD+MsFtWQpLgBzZALmcwi+
	 DgRiY76ly8o6V649UmoDpEOWwDM9Sw6+UEVty/fH/W2wgh9GbM0UVOn0wI/EJ1zUcL
	 dVz6v2D7OvKTjwJ5GXlZWw0LFZ9/5Ee9soCNxlFJmZ4ccYyshOYKyjSGYhZu5ln5CL
	 DR8Qo/shX5MGw==
From: Sasha Levin <sashal@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 6.12] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Sun, 16 Nov 2025 12:19:42 -0500
Message-ID: <20251116171942.3613128-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251111202936.242896-1-ebiggers@kernel.org>
References: <20251111202936.242896-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Subject: lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN

Thanks!
