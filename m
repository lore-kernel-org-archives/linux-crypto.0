Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792707117;
	b=PD2vdS6w0sc0stXe1ULrFtgBTqkZaDeC0VEK/2nmoWpcrMITteXeR+CHyyWsFj2l84Cw
	 7TwLMoRi83QTPnztaacU/0CmcGUTkTofP8p67lKYPfFLqmpHBtBry8cjN5OHWrsfhXCot
	 7JC5bTbfJnW7gCvJp8P1DGDN8dB9nBBgiXslLPEyd8ykKDa2FImF5ryWIZjIZElUX1TJl
	 YiPXADeRsoVHfs+5J1BFvzdLbJllfO7Ro/j5VrPPwd4GF7IJE3rz1p09Bs1CdJ4JH0hTC
	 kpsV/v1OVpfriJIOAZl9ivc47GsuF8GnbrUqLKKWmJ4OvwyM96FJZWKyXFKP4Y2g0ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792707117;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=QacJows3gmaboTfKLZmmjG4i7xvTX4p5fR874XUDeTw=;
	b=VuABgTqBc/6VkXAIrBaPpQkhgbiR0lKS/Ez08CYtW8+tWRy5Ryb24SZ+7FGqi9s0GFpv
	 NlhdypT/a5ZONzTraBc92xDLoNM/wXWMGH2fmWKp7UsI/BhgrGI8Hq9fqbz3LwYKyMcfA
	 QhXM02wl95effoE7mMKO5zrKflVeS5oxPiAoAburdRlLgIKQEYTBi0Zdo1xg8M+D3mZO+
	 vN5sl4lFFiTOnBG6UC7b+530gnud+aoNz2+Vy3YHlTOGcyJf/fkhCB6+UMSNgdmyb7uOG
	 T9RAtbRxpmxM0Gjc1UNK4nSyw5E51oQpsLPxZlheESKfXbqazKgsBBHv8e7B1Zc57tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="YfwOT/zV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4FA606A319;
	Thu, 22 Oct 2026 22:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YfwOT/zV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5721F01825;
	Thu, 22 Oct 2026 22:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792707117;
	bh=QacJows3gmaboTfKLZmmjG4i7xvTX4p5fR874XUDeTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YfwOT/zVJEVMCIxmHFCwkUagikrh7EhlUbd/V7ONTJKqFm1j9FK8X7TrZt2UqO+wE
	 Xqg8QA5U0LJoC6TmIlme/U0w9tehgebHvTq23jItnvCrSAln8GX7wuEtHd1IV+HpCB
	 hFF6m3l3lO+3AmCdmaZ4CoknkcHY0Pqeb6w93agvDCiYZ4eiuB51uopVvnAonJXXaw
	 ZYrUlOjGXUAf+L0UPXjjirjNJD8r8t72kjAAyr3qs+2KaNSt9Enud/yJAD88cMMZ6R
	 QfdgueqQ2oYBLsNoBdQH7E3QXnw03GHSEDamjyXai/MiwitBEGAxEr+tsr6bhPXFo7
	 wAJcses0GoZRA==
Date: Thu, 22 Oct 2026 22:11:54 +0000
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
Message-ID: <20261022221154.GA1591067@google.com>
References: <20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com>
 <20261015-asycn_tx_remove-v1-1-056a7085e0a1@nxp.com>
 <fb9c7c5c-e377-7926-c8f1-a7f9e93c2d46@redhat.com>
 <20261022214457.GB1383716@google.com>
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
In-Reply-To: <20261022214457.GB1383716@google.com>

On Thu, Oct 22, 2026 at 09:44:57PM +0000, Eric Biggers wrote:
> On Thu, Oct 22, 2026 at 03:24:18PM +0200, Mikulas Patocka wrote:
> > > async_tx adds significant complexity and maintenance overhead while
> > > providing little practical benefit on modern systems, where RAID parity
> > > computation is typically performed more efficiently by CPU-based XOR/PQ
> > > implementations than by DMA engine offload.
> 
> This patch is to dm-integrity, which is doing an XOR, but not for a RAID
> parity computation.  The above paragraph should be adjusted.
> 
> > > ---
> > >  drivers/md/dm-integrity.c | 26 ++++++++++++++------------
> > >  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> Should also drop the 'select ASYNC_XOR' from CONFIG_DM_INTEGRITY.
> 
> > > +		src0 = kmap_local_page(source_pl[pl_index].page);
> > > +		src1 = kmap_local_page(ic->journal_xor[pl_index].page);
> > > +		dst  = kmap_local_page(target_pl[pl_index].page);
> > > +
> > > +		memcpy(dst + pl_offset, src0 + pl_offset, this_step);
> > > +		crypto_xor(dst + pl_offset, src1 + pl_offset, this_step);
> 
> crypto_xor_cpy(), instead of memcpy() + crypto_xor().
> 
> Also, these pages come from dm_integrity_alloc_page_list() which
> allocates them in lowmem, and elsewhere in the file they are accessed
> using lowmem_page_address().  So the kmap_local is not necessary.
> 
> Also note that crypto_xor() and crypto_xor_cpy() just use scalar
> instructions.  Probably fine (it's just an XOR after all), but it might
> be worthwhile to mention why xor_gen() isn't used instead.  Is it
> because the pointers and lengths aren't aligned well enough for that?
> Or just because not enough data is being processed here to bother?

There's also a stale comment:

    /* mirror async_tx per-page completion accounting */
    complete_journal_op(comp);

- Eric
