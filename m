Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792705500;
	b=0svRkYc2pa13sWJF9DY7cTeZRt8rvJQKvRoh30AKpuLIUX+FGxCMcMwB+i/fraodGgYl
	 cQzE7M4gJCt5HtVsCpGO4K6TZFTxwBb1rom21wzyBXPnE/8UV0tQm67gfbzwViC/kIZqD
	 C8iMjFj1lOhHx0/pmxeQOk0xrbbmFOdiraESAxW2HrmLKY2MWChW+CNCXsGIvoHQv25pR
	 xrc75A7+xgbhUyxufNLQ72Sbf+Y1hnyeMjlw88XLA7cv1hdXPqglBMvyHKR6tctMLbnj9
	 h+4CG2FaLFLdwq6Gz8OD1naFgfi7T+F7dpUQzW0DrWsYPc884hP7tYv1qIh0Bf1+8OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792705500;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3z/tnqIkbwuOSMz8YvGq/0kmnO/cJuin9JInGArnj78=;
	b=Ikh23/7riNr+GjjQSjoIdDKjJy/LqpKr3cAEZp4LVZq2HCKFs2neXuMJKZYBjnXB7d6p
	 AFQV1W3Z21Ve3l2fUOmQSd0Ec6VTtGKfQsbOuspzD47i1ldO50B2lmnV/pEyyDlbF1zEQ
	 hrZPXaFB6Qzkj7NSo/yGynMANe+h8180nZDsm+et5j0HE51gf6ymX02AiS/G+H7a138pm
	 QY0CJSrAcCkENYOnfj8Cwy36EteG62xgNo2xguct3ereNBu/K48K4uoF87cT33zR5S6bc
	 UhbxsxwcwFPn1bBzK1d1AqTvDpoygIo7kNVIjt6EOw7FNwsO1YIQISYh4RFNgTasZzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UoeHQDI1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BF4606A31B;
	Thu, 22 Oct 2026 21:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UoeHQDI1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9851F01825;
	Thu, 22 Oct 2026 21:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792705499;
	bh=3z/tnqIkbwuOSMz8YvGq/0kmnO/cJuin9JInGArnj78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UoeHQDI15eToRxgaD0Ha7ap01/yMx/3jPiGoCmRX64jHQu1oi978N8hkIdwkWNdiR
	 GNcqbAzXNLJxI0C0g0xTfIfBjI0p20fBbw3+H6cViKiS9/wLHDdKfyTxULZFhmflon
	 i4bxSGg4IfMBvAqsHePGCBlUmX70hzBX0KbIFpnDEd4oKz5Of6dc6Ts9qP8ibKvMFO
	 gNtqKszYUc5kaXz3WNRMMfXCPZ2jnXd3R8SYHKO1BXfGLaDvW+r3xZGInIetq3hIm/
	 fOKwC26Ek6gY52+fDzS6EB7rlks3H9zLSF0NuCdGvcS0zGPL5759rVR2Uba8fgJNtw
	 berlKLS4OzuQg==
Date: Thu, 22 Oct 2026 21:44:57 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Frank.Li@oss.nxp.com, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	Anatolij Gustschin <agust@denx.de>,
	Saeed Bishara <saeed@marvell.com>,
	Rameshwar Prasad Sahu <rsahu@apm.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Anup Patel <anup.patel@broadcom.com>, Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH RFC 1/4] md/dm-integrity: replace async_tx with
 synchronous xor for journal
Message-ID: <20261022214457.GB1383716@google.com>
References: <20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com>
 <20261015-asycn_tx_remove-v1-1-056a7085e0a1@nxp.com>
 <fb9c7c5c-e377-7926-c8f1-a7f9e93c2d46@redhat.com>
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
In-Reply-To: <fb9c7c5c-e377-7926-c8f1-a7f9e93c2d46@redhat.com>

On Thu, Oct 22, 2026 at 03:24:18PM +0200, Mikulas Patocka wrote:
> > async_tx adds significant complexity and maintenance overhead while
> > providing little practical benefit on modern systems, where RAID parity
> > computation is typically performed more efficiently by CPU-based XOR/PQ
> > implementations than by DMA engine offload.

This patch is to dm-integrity, which is doing an XOR, but not for a RAID
parity computation.  The above paragraph should be adjusted.

> > ---
> >  drivers/md/dm-integrity.c | 26 ++++++++++++++------------
> >  1 file changed, 14 insertions(+), 12 deletions(-)

Should also drop the 'select ASYNC_XOR' from CONFIG_DM_INTEGRITY.

> > +		src0 = kmap_local_page(source_pl[pl_index].page);
> > +		src1 = kmap_local_page(ic->journal_xor[pl_index].page);
> > +		dst  = kmap_local_page(target_pl[pl_index].page);
> > +
> > +		memcpy(dst + pl_offset, src0 + pl_offset, this_step);
> > +		crypto_xor(dst + pl_offset, src1 + pl_offset, this_step);

crypto_xor_cpy(), instead of memcpy() + crypto_xor().

Also, these pages come from dm_integrity_alloc_page_list() which
allocates them in lowmem, and elsewhere in the file they are accessed
using lowmem_page_address().  So the kmap_local is not necessary.

Also note that crypto_xor() and crypto_xor_cpy() just use scalar
instructions.  Probably fine (it's just an XOR after all), but it might
be worthwhile to mention why xor_gen() isn't used instead.  Is it
because the pointers and lengths aren't aligned well enough for that?
Or just because not enough data is being processed here to bother?

- Eric
