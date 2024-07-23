Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C1C1FDA
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jul 2024 01:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721699335; cv=none; b=OquTxt+LXJTuv2M9/6s1NcjxqUHa8AmqDKzmQeXilGkJp/PGf3dKOscxilC/B/zqr8TIrIM5zMsetp7h9nOnnlsOW4O6ox0cW2QxvKwmiQ+dd6noxN49SfvwaJ2+rO/VZC/oKLEYCvIaNsvgu6ficL3KY1v1iO4/9oG2NzZLhRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721699335; c=relaxed/simple;
	bh=3D9wf9HZOMAl36iRYLRmC2ZZvwA7HUfg+fd9nltv1Gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZ0JHotQHDBaYOth2wPPehIghJTRYVfh8JY/KMZJi84DnbFSiAtUaT8qiaE2XyBv9FgMXIh7Uv3ZOayMN86Pva11TGZZc1OMz5EJscET7PGzy+1WbaYqspBmW/g0KRP8UyOHfqFAHwIB2QulU+G/XXo3Z8WX+4Nmijarr1RxU9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o+RXGdxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o+RXGdxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF2DC116B1;
	Tue, 23 Jul 2024 01:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721699335;
	bh=3D9wf9HZOMAl36iRYLRmC2ZZvwA7HUfg+fd9nltv1Gs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o+RXGdxKG/IYUBu0DTDVtR/tMUAMsUmlHzNyzgm3kKjLBeVFLExt7EaVHn7J5iNO6
	 OJIM2ITyhHGMsADarR8v7wlrdNG+PFVT3EirXlsbswOOtwGaLqZOgAf7v6hxn9ewMZ
	 893nL0A6gKATyurhJT/6W+NQaYU3YKTz//T7C6DFjB1vTlc2FbZhQ4U4TNFTjMtzfE
	 t5uTC2vQG/PY1947RENniG5FRQJRuH69+j6s7BIq7iMM6+pVNHj0LnI3UCq0+VFjva
	 gPvJyXVgrdN1xUYMVTLHTe0TyzQBx59bLOMX0DXDHCgBhmqHSXpJapuilQN7jZ/FAV
	 EL7O2SvA6BROw==
Date: Tue, 23 Jul 2024 01:48:54 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, linux-crypto@vger.kernel.org,
	linux-nvme@lists.infradead.org
Subject: Re: [PATCH 8/9] nvmet-tcp: support secure channel concatenation
Message-ID: <20240723014854.GC2319848@google.com>
References: <20240722142122.128258-1-hare@kernel.org>
 <20240722142122.128258-9-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240722142122.128258-9-hare@kernel.org>

On Mon, Jul 22, 2024 at 04:21:21PM +0200, Hannes Reinecke wrote:
> +	ret = nvme_auth_generate_digest(sq->ctrl->shash_id, psk, psk_len,
> +					sq->ctrl->subsysnqn,
> +					sq->ctrl->hostnqn, &digest);
> +	if (ret) {
> +		pr_warn("%s: ctrl %d qid %d failed to generate digest, error %d\n",
> +			__func__, sq->ctrl->cntlid, sq->qid, ret);
> +		goto out_free_psk;
> +	}
> +	ret = nvme_auth_derive_tls_psk(sq->ctrl->shash_id, psk, psk_len,
> +				       digest, &tls_psk);
> +	if (ret) {
> +		pr_warn("%s: ctrl %d qid %d failed to derive TLS PSK, error %d\n",
> +			__func__, sq->ctrl->cntlid, sq->qid, ret);
> +		goto out_free_digest;
> +	}

This reuses 'psk' as both an HMAC key and as input keying material for HKDF.
It's *probably* still secure, but this violates cryptographic best practices in
that it reuses a key for multiple purposes.  Is this a defect in the spec?

- Eric
