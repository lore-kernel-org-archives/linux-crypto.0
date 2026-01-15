Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3543D27F72C;
	Thu, 15 Jan 2026 20:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768509940; cv=none; b=XQLK2VXc/dUoT7389H+VlASSVyymMXHdopYmfZ0XRbK5+fAjYmNoI7yaVSc3Qibux82ogcuRFjVs8pDDKx4/t8ORZxjqWzVemZ2Lu2JDQNs+QVbQ28mf0EkoK6YJ6imAmUC9wcvDqQ68kb10p2PKPUx56o0j3+Ovn8tjvr83E6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768509940; c=relaxed/simple;
	bh=TrVJ81gNlKGWflE9lzJbsnP9K0M2Q7j3JRWiu7197P4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWdoU1t6+obKKeL/nt7xObD62LhzAbzj8oOxXAP2TGTKANYrzwRatKZTOtha1pelLcSHlFHDL5fM/m63umGtkt2CNsoIFSoh43ZaZujsa5fK9Rl7tUbPYHx4TNuT7sJLci+Me58MsQWCow0GTTRHFaNr4e121a2CEHIeTtq8lGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u+snff/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u+snff/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144BAC116D0;
	Thu, 15 Jan 2026 20:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768509939;
	bh=TrVJ81gNlKGWflE9lzJbsnP9K0M2Q7j3JRWiu7197P4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u+snff/V7iHtCcygjYFJPTDIRB2va5QWcv2YTvthzYkkKO1dcLaPj0r1cWb+Qb0Ai
	 ZVpOJ/eQka5sAfYC6lulUHJjHAJpvcWXM+J1c9dpGfWO8QtlVm/Cw2UmGDfsxb+hb2
	 IyAaokiFcv3t0x5Ft7gH2uq7nPZ/1cVZRdTZbS2YPI+uHUJfIZ2X9X7c3kyukr5qNM
	 R+2zdGs48Km5Khd4oVNLQDGIKWfd0F+kukNy4BH3hlSFRi//OC1itB5pkumE0828um
	 nikeLbBlI0f+FnI5/oQ1XMHlgzziQOiqCsrTkLzNGbBUcWTeyZjD33D9GwKuEKNpfZ
	 SyUTiXJoNf48g==
Date: Thu, 15 Jan 2026 12:45:37 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>
Subject: Re: [PATCH v2 00/35] AES library improvements
Message-ID: <20260115204537.GB3138@quark>
References: <20260112192035.10427-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>

On Mon, Jan 12, 2026 at 11:19:58AM -0800, Eric Biggers wrote:
> This series applies to libcrypto-next.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git aes-lib-v2
> 
> This series makes three main improvements to the kernel's AES library:

FYI, applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

As always, additional reviews still appreciated!

- Eric
