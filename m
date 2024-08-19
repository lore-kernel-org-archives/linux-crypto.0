Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174723BBF2
	for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2024 15:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724080978; cv=none; b=l9v7PKvoBkwc3fdM2IGsQSc9HOQQObie2tci6vTXykJteuFajIjMKc019tKvh87J1tBEHZmhQP7QxkNwsYGJN0/NjOlsBbO/WUA3mUKjNqxWcpOWptZ7OJTRZ8k6y5o07iowzJ1Bv7yPYeWRIvc+wo7l9kT7PFOp9cFBuRxzeXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724080978; c=relaxed/simple;
	bh=rIJ7qDoHBFqwJPzOBh+RyN54+dYS6AM5Nf04a59ITos=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hQ9Vq3H3tK3FkFcS1JZKmeBKbZlMcYHHD/2Ymd/ofGREmpWKqoWPie73RSYTbDTvxg0m4DKIOcE1BrQ8GYP5vnIgVLnsnie+ZWOGXrv3Mhfl120X5tvSs9WDl5ZaLjvel1+iLvTTWcO963vmTw9VonZFxyWgRs3hHJ/b1y3Kask=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=K4x1VMKf; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="K4x1VMKf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724080976;
	bh=rIJ7qDoHBFqwJPzOBh+RyN54+dYS6AM5Nf04a59ITos=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=K4x1VMKfAdicidZqSH46IGkStK3fw6XIzP8rajyHOVasuj48noV3ItSuL7rjiN/6B
	 eTxHI3w/9nkxuMNVPuzRhXSiGwXqb27IJMWq2kMCqBWSBlb74Mv+FW5N6JSWpLpLG1
	 kTmrJUVzZDP8nSE8oDirlF3CmLBu4Jp1D9HFHR10=
Received: from [192.168.124.6] (unknown [113.200.174.126])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id E979D66F27;
	Mon, 19 Aug 2024 11:22:53 -0400 (EDT)
Message-ID: <9e8cef1dee1ce1624cc0f90c9b5eb4c4ddfd3949.camel@xry111.site>
Subject: Re:
From: Xi Ruoyao <xry111@xry111.site>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, WANG Xuerui
 <kernel@xen0n.name>,  linux-crypto@vger.kernel.org,
 loongarch@lists.linux.dev, Jinyang He <hejinyang@loongson.cn>, Tiezhu Yang
 <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 19 Aug 2024 23:22:51 +0800
In-Reply-To: <CAAhV-H5a42p6AAda=ncqCdmpHyc_tpXHjDVHq_F1pPZumfGeLw@mail.gmail.com>
References: <20240816110717.10249-1-xry111@xry111.site>
	 <CAAhV-H5a42p6AAda=ncqCdmpHyc_tpXHjDVHq_F1pPZumfGeLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-08-19 at 20:40 +0800, Huacai Chen wrote:
> Hi, Ruoyao,
>=20
> Why no subject?

Because I misused git send-email (again) :(.


--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
