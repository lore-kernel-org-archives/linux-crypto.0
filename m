Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180FCEC2
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jul 2024 01:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721699667; cv=none; b=i69CVTFymeysBeETr2oL0wI7yBcemUI7dXLPC8GJcrbfmlEhKSoyxIXnt3JGTrOWJ7CaLxdxSCH41deZzU1/nDgNtNYGsgfTDHs1RuMGOApmZf4cgAOpBDoDXyaAooYDiM+DcL7K6ixyawlmh2vSIIyvHu9Dw1gcyzH6yeIvM8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721699667; c=relaxed/simple;
	bh=8WCj+BKX/80lHp9Jl4kBYqEi8PSbtOt7Odt2bf8LT9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QlOorpa36k8funWeeeKMkjFcfCCYtIxcc3GfBTydnr0MGrQO+Hb4yKY7dUed1fYutMi15kw53jlSRcwcq5q8X46PEv2nlI6G8lg0Wo+Ir6i0Ig0oMv3m/f23l6evSQ0M/ekZaNpynV99paKItJgOYJu6cl2W7SQxgmHWUt4D2Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pcN5DCR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pcN5DCR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96DEC116B1;
	Tue, 23 Jul 2024 01:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721699666;
	bh=8WCj+BKX/80lHp9Jl4kBYqEi8PSbtOt7Odt2bf8LT9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pcN5DCR8DP8/CeHaBpeKF/AFovl/76AxKdVt+vfBZcx/dzT/Zhm0oaJE/EAcVkuDg
	 zR1WV7tIhhzQ7aAbaKjiO7vuqijDzVaMUJTXnAQnhpyAlaTbXefD1smEmoRK9yys51
	 m0AHdAWnW5zP1/QRTAt3w2x3QsZATp5Wi6khKrbPxMZRxa3CrwauvnNX1g1YEUxwQG
	 N+D9FHwTMzbSHEnf8SqsWBIyTVaAjCIsq1izn0dFmVdfrK/ySaNgZInoLB7aBrA9zt
	 wyFnT3Y3jbMOq/AUKBw928blVo4G/w902Ad4//sTqfBBjALjGvlBeRxcb+6pPz7USC
	 sQnJ2tKTilQPw==
Date: Tue, 23 Jul 2024 01:54:25 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, linux-crypto@vger.kernel.org,
	linux-nvme@lists.infradead.org
Subject: Re: [PATCH 5/9] nvme-keyring: add nvme_tls_psk_refresh()
Message-ID: <20240723015425.GD2319848@google.com>
References: <20240722142122.128258-1-hare@kernel.org>
 <20240722142122.128258-6-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240722142122.128258-6-hare@kernel.org>

On Mon, Jul 22, 2024 at 04:21:18PM +0200, Hannes Reinecke wrote:
> +struct key *nvme_tls_psk_refresh(struct key *keyring, char *hostnqn, char *subnqn,
> +		u8 hmac_id, bool generated, u8 *data, size_t data_len, char *digest)

For inputs use pointer to const, e.g. 'const char *hostnqn'.
This applies to the whole patchset.

> +	identity = kzalloc(identity_len, GFP_KERNEL);
> +	if (!identity)
> +		return ERR_PTR(-ENOMEM);
> +
> +	snprintf(identity, identity_len, "NVMe1%c%02d %s %s %s",
> +		 generated ? 'G' : 'R', hmac_id, hostnqn, subnqn, digest);

This is reinventing kasprintf().

- Eric
