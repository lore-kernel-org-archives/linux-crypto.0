Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F992E2F0E
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 13:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903034; cv=none; b=U8xpSDUsAWxjXf/bV/7ForAsrLDCLHNeDUJhfZicjf7u5WeSYx8n72zlTLDIRi45fJSTFOqWZmCMicigI2r+MQt1ysaz6zThFZL+kdYpOdMPH/YgwhldxtCTCZrsLL7tIBvZa0iEa5dPdEFU4apTi4RCHXpr8FP7KaNaZfA8YO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903034; c=relaxed/simple;
	bh=YWPDXoMAmmrhqB96B1dvHxpf3zUskuMZ18eGdn0GY2w=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Grqv4ZJbKxxiWKvVSdTvirNKBQs59Ewz7OKlNESM5CC+WYxL0UBK6zdVjEx1J3IaHbAiAzaKShiLQwLdQBPoY6IPTrBflqVFxohdB5LTmY4f70zcD9fm2nAHsI3AKf06Y3rllGUpKPuo7VSqEmj5KrWzHMbDhkcTevSzCDK2Tlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A7d9YHlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A7d9YHlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C656C2BCC4;
	Mon,  4 May 2026 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777903033;
	bh=YWPDXoMAmmrhqB96B1dvHxpf3zUskuMZ18eGdn0GY2w=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=A7d9YHlxL8RwDhoxwt4Iw6XstHAIoL8BHcBprllbR4LeOz/uHRYoU7rM5aeyJ2YLD
	 96NzCC/dtcdp5zSDnqDs8teHwkaHYXFMHICWXlIdWLhPMezBo3StSh//nZZlHoJCpz
	 ocnrd/HwAOiMgS2gkTs5cAMd9l1VD+fqqQrLfmbHBEBkteh4J85a0uo2MXji8UccHu
	 RY2Nv3LnBJCrM2Au9IOk84tZDMxzOQo1yeRGrbYUrmCuFkTlgvL/ZOFOrga9nmiZow
	 /2QKuym9p+/nqf58O75q90t0zOKi2ZYG+CAdZAw7VAPaK91jGdZLrMEzeRWEPK9Qgf
	 4eTiwvrtaRvMQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9F3C8F40076;
	Mon,  4 May 2026 09:57:12 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 04 May 2026 09:57:12 -0400
X-ME-Sender: <xms:uKX4aVbphX3bueqjHkPzAnjJsUjan9XSSjyQS3V9aPfIRJlcKabw7w>
    <xme:uKX4aXNxfkwx7RRmuabgb9rsjcSAO-p0sBS6oxizJpTzOjXVLRu28k92kKIwdKtbz
    xwhxpHn8UZgeNdBjLKe-rBHnL0xiwsD6ZhE64AiC0d5X8KBfmtuwFBj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdelledtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepuddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehmphgvsegvlhhlvghrmhgrnhdrihgurdgruhdprhgtphhtthhopehnphhighhgih
    hnsehgmhgrihhlrdgtohhmpdhrtghpthhtohephhgvrhgsvghrthesghhonhguohhrrdgr
    phgrnhgrrdhorhhgrdgruhdprhgtphhtthhopegthhhlvghrohihsehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopegvsghighhgvghrsheskhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepmhgrugguhieslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehlihhnuhigph
    hptgdquggvvheslhhishhtshdrohiilhgrsghsrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:uKX4aX_cimOx7Q9XHUcgFEd8VLiR8vx7N6o9gVSTY3BkmhJWrPe2og>
    <xmx:uKX4aVQ5_L1TE5H6yJohvsN8whHw4sLH7pjUy0xfKntjxtMMbf-9xw>
    <xmx:uKX4aUR34HetQYP-eIxmRSv64rGgH4Ld9LGkkkMGDQ_cf5Com123qA>
    <xmx:uKX4aZ6xaMtnXeCsVfBguusB1Zeu-ghp94nEB2f2jTw-t6rxdgnW-Q>
    <xmx:uKX4aRWiaDaOizpsFO6nXnv69b-g0dtwA4-uwADuwGXeUKsEGB1uKqC2>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7DAAE700065; Mon,  4 May 2026 09:57:12 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 04 May 2026 15:56:52 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, linuxppc-dev@lists.ozlabs.org,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>
Message-Id: <112bf0af-1551-4d3e-ab15-e5dea3fc2435@app.fastmail.com>
In-Reply-To: <111ea924-fef5-441e-9849-83f938c913a7@kernel.org>
References: <20260504041448.15820-1-ebiggers@kernel.org>
 <111ea924-fef5-441e-9849-83f938c913a7@kernel.org>
Subject: Re: [PATCH] lib/crypto: powerpc/md5: Drop powerpc optimized MD5 code
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Christophe,

On Mon, 4 May 2026, at 15:28, Christophe Leroy (CS GROUP) wrote:
...
> I'm really concerned with the optimised MD5 going away now, and I'm also 
> wondering what will be the way to splice a file into the kernel and get 
> it's MD-5 hash from the TALITOS if AF_ALG goes away in medium-term.
>
> What is the way forward ? I'm open to any suggestion as I really can't 
> see where to go for now.
>

AF_ALG was created to give user space access to crypto accelerators that
require privileged execution, for sharing between clients, and for managing
DMA etc.

The fact that kernel crypto code that does not have this requirement was
exposed via AF_ALG too is a historical accident, and this is causing the
pain that Eric describes wrt attack surface etc.

It sounds like you have constructed a vertically integrated system where
the kernel provides the fallback when the Talitos engine is not available
via AF_ALG.

This fallback does not need to live in the kernel, and it would be much
better (as well as more efficient) if user space would implemented MD5
itself if the Talitos cannot be accessed via AF_ALG. In user space, you
can use any implementation you like, generic or asm accelerated. This is
what all other architectures already implement, in OpenSSL etc.

Claiming that your user space software must only implement one code path,
and that punting this to the kernel is therefore required is not a
technical argument: this is just policy on your part that the community
is not bound to.

However, deprecating AF_ALG does not mean that we will ever be able to
remove it entirely. Especially the crypto accelerators that cannot be
accessed by user space in any other way will remain supported as long
as needed for legacy use cases.

But I think we should consider libkcapi as a general purpose crypto
library deprecated too, as well as any other use of AF_ALG in lieu of
user space libraries. It is not the kernel's job to execute user space
code that can easily execute non-privileged as well.

I suppose there will be more discussion soon about AF_ALG deprecation
for software crypto. It is likely that we will need to come up with
an allowlist of algorithms, in order to limit the attack surface to those
algorithms (such as your MD5) that are known to be relied upon by user space,
rather than any random combination of all the buggy template code and
null_ciphers etc.

Do you have any use cases where MD5 is a bottle neck, and the generic
implementation is too slow?


