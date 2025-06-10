Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370372620F1
	for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2025 19:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749583316; cv=none; b=etP3rhO07VU9wazo7kOn33ao8/i+Zvohk5KmiQBUnc0B6KB0kg/PYdql0H7UFxXD8lI390yot8cgFG40m/OyrYS1RhmKgBKmM8WdNYnWdjL3EIXfQyhJH6tY7HtfF/GWxDLm54/Ate7dr9dhrl4zNZBuv/k6aFsNPV2IRhzjkM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749583316; c=relaxed/simple;
	bh=MvY65196OkKGiQelyzXqMzmcV5/FC5X0KU+wsmCw2F4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CLauj2EQXvD5Fqddpzazp044wHStfpThKJycYuixMAGX6ECf4ZtEZI9hhr0wsqkSYyGPHuo1+YbKgJWmpaoT8ammNbHTTm/mMSsej0U1nTKuAufjV3nxG5UrxE9ZBoa8WY+VqOw02pQvtYVpRw1r8zyXBrZY90ox0LFa8pnRf+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MwljCyWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MwljCyWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB41C4CEED;
	Tue, 10 Jun 2025 19:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749583316;
	bh=MvY65196OkKGiQelyzXqMzmcV5/FC5X0KU+wsmCw2F4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MwljCyWYyc8YtDsnvhBJ9wOOCxFpAopoKjI6sf7A7Wyb9RY4m84YGhhMqWyZM4/XK
	 5VZA+L/9/rkc0/UWOZR9lB9xiZ8yHz1gj4gA5XXKbn79to1O/nsjXd0TKNmn9xMotg
	 /yJcY3eyxkx7kmYsiOhYMcpBvjEFTawUqOyMfgdGElaMIWH9krgZRCgzLWGSwY8LVu
	 4SobJYaZskufh0q8t+Rg61TTIEcXnOf7noRIKEPB9b6JPNKezv47wZojtYBfpNdiMO
	 M5+GmFrYqClQCn9MRMiS2UDcT4CPFnzABcCQICxWEiISQM2jbc3IWhwjjGJY77ef1P
	 +pqmqVO/nvcCw==
Date: Tue, 10 Jun 2025 12:21:32 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	herbert@gondor.apana.org.au, paul.walmsley@sifive.com,
	alex@ghiti.fr, appro@cryptogams.org, zhang.lyra@gmail.com
Subject: Re: [PATCH v3] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
Message-ID: <20250610192132.GE1649@sol>
References: <20250609074655.203572-3-zhihang.shao.iscas@gmail.com>
 <20250609201306.GD1255@sol>
 <EC8AB5A0-D5C9-4D18-A986-DE66BE46E09A@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EC8AB5A0-D5C9-4D18-A986-DE66BE46E09A@gmail.com>

On Tue, Jun 10, 2025 at 02:57:29PM +0800, Zhihang Shao wrote:
> 
> >> +void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
> >> +  unsigned int len, u32 padbit)
> >> +{
> >> + len = round_down(len, POLY1305_BLOCK_SIZE);
> >> + poly1305_blocks(state, src, len, 1);
> >> +}
> >> +EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
> > 
> > This is ignoring the padbit and forcing it to 1, so this will compute the wrong
> > Poly1305 value for messages with length not a multiple of 16 bytes.
> 
> So Does this mean here the argument of poly1305_blocks should be fixed as poly1305_blocks(state, src, len, padbit)?
> But since the padbit is set to 1 in poly1305_blocks_arch according to the implementation in lib/crypto/poly1305.c, 
> it seems to be no difference here.
> 
> Looking forward to your reply.

While the common case is padbit=1, poly1305_final() passes padbit=0 in the case
where the message ends with a partial block.  So both values have to be
supported.

- Eric
