Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795116533;
	b=tsGb8pZfamByUrkRj/7eAR5FVn79S99qAXlEhQKZZEGWSvDrHEGx/YgTLeapi+k5JRIg
	 KlF2RdXrhQe3RAMDdZlhLEVG+4p+f2T5W7gP1Z1FoJv1Qttw0JByR/LGl2bSFF6/+fBVn
	 OaOocLNd+YRB2g/H3yrRni7t/GCNK3poaEvUj04pMkPwwIUZJ8CxpMung+utMcgmyTFdq
	 nJMwCdt0o8e+30fDnsDaxxIo/0KTTcf0RXHvYusGRg46z/BVeTvrHAPp+6oiGncOb+4Lt
	 L8aB+D4kqe0s3zRHMc04qtcS3xcn2ZeFm5g33L/EDmXyxunH0h/emkOtDBKFaztDYDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795116533;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=uvvgHJk3GV58HV73c6RWqlDdgsR7MLu03XDpb7f+R5U=;
	b=prrZlpBWeCC3MY1nm9J9PZPvcrtL0N2vbNzBpFHkAOAxfBTmkVzhnJFUuzWxk2xz+8uI
	 qCEFx0W0f1S+3zB3TMLpjBeI6QqfJi/3Zzx5zRDe30VTos3jw1cu+or1LwWZruhXG2QyM
	 JVbrQyzsf73/Rc6+v47EmMOuiJ5Rul/Yu3fk4w1894kFvg4JHfc0putDHBqJY37KfwVDm
	 hg31y4GKs7oozLeht1CCXmT/sfE7CMbyk74QHSdtp39vqPiJABWBHPo93qz6Qez4fu0Zb
	 tVZAhnaSa+PzLafDecJOYdoC+2IklRzvuziw1IBLUSeR8BtrN6QogEsHeQJ2guLAQFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G5r8Fcjv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90E860A2601;
	Thu, 19 Nov 2026 19:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G5r8Fcjv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D131F000C4;
	Thu, 19 Nov 2026 19:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795116533;
	bh=uvvgHJk3GV58HV73c6RWqlDdgsR7MLu03XDpb7f+R5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G5r8FcjvSJeE4+YGEKojS0fN+BgLOD+rITEuaTx/97IhlsXC+w0TDlduE9sEg7h7P
	 1wD0UmOo+fPXObDWZhQtJttla1t0PPf/AHKfsUcsEn8KW+88KzO8QvZRtyW51xzsdm
	 p+33grHuAQm6a3kdNwobT3j4Ry+YPBGPR0tYTTC6Cs3HCOoA1kixGp1VYIeJVUjqWi
	 hWbHS1W9VlDnj0QEsLqVpI+6yCD7/gXPITeQqyUr3pioTR2WF/8kToOjKe6fsbk2Ff
	 ujoWK79i94Jrqc+VmkNunbBtD9WxhRSB4xbfbTA9lbWZzyoApzethbxEP0aKxCdvbd
	 a4B3Bt+mJszsA==
Date: Thu, 19 Nov 2026 12:28:48 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb+git@google.com>, Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>
Subject: Re: (subset) [PATCH 0/4] Get rid of all NEON intrinsics stdint.h
 type hacks
Message-ID: <20261119192848.GB875856@ax162>
References: <20261029135020.272082-6-ardb+git@google.com>
 <179508547602.2557572.9682726373932810888.b4-ty@b4>
 <81ddf2f1-faec-47ec-b3b1-7210b4e7712b@app.fastmail.com>
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
In-Reply-To: <81ddf2f1-faec-47ec-b3b1-7210b4e7712b@app.fastmail.com>

On Thu, Nov 19, 2026 at 01:08:51PM +0100, Ard Biesheuvel wrote:
> On Thu, 19 Nov 2026, at 11:51, Catalin Marinas wrote:
> > Applied the first three patches to arm64 (for-next/fixes), thanks! I
> > also added a cc stable, though it won't be a straightforward
> > cherry-pick.
> 
> Thanks!

Yes, thanks a lot for picking this up.

Backports to 6.18 and older will definitely look completely different
because we won't have all the refactoring to place this code in lib/.

> > I left the last patch out, IIUC it's just clean-up rather
> > than fixing a problem on arm32 and can go separately via Russell's tree
> > during the next merge window (let me know if you think otherwise).
> >
> 
> I'll let Nathan respond to that.

Yeah, as far as I am aware, we only need the arm64 bits. arm builds are
fine right now. Russell's tree would need to have the first two patches
to apply the arm change if I understand correctly so it could either go
to 7.5 with a backmerge or 7.6 with a base of 7.5-rc1.

-- 
Cheers,
Nathan
