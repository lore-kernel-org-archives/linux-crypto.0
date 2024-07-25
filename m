Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E8B17588
	for <linux-crypto@vger.kernel.org>; Thu, 25 Jul 2024 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721928080; cv=none; b=Cu+u/kKmPF750YDHFAYLIvXhNgMVUM/DvFW2YgWbnb9jyPzJW62WKjo+TFx/NcV7ztqK4SnZZWr7Gh5GCVlCDKMGkPtCcBEucEI0io8I45gKcwGSLZEfSZl0BCeeFp+GTU2LjWXQQCL72Tzxf/Ww8P5/Fl3/7m5J/VQPU6mNrXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721928080; c=relaxed/simple;
	bh=L0LOSg0VQO3PDyUpf27E5dmEAxesk/J4GrY7urab8NA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b40PYHuIltoa1Key2LKtGjuP6rnw0mnjSSOIkqZIE8NocrE1CN1MUHV79YkDBHtQmvsCp2nBV3KRpPccPlcOG97bpcUq0e8GwcKwfcazMKH7woJRzOAr33eHekCxXYawyNmkpI9O4aNp4XlpBctJvdkay/u/Anac6nRKo1Gwd4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rdlbMQT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rdlbMQT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1826CC116B1;
	Thu, 25 Jul 2024 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721928080;
	bh=L0LOSg0VQO3PDyUpf27E5dmEAxesk/J4GrY7urab8NA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rdlbMQT7z5DTs3khWLOKMDLar6th+8iW2ZbR2KxOB34Hk0dBr9wZwgg2C9q+g0iVh
	 qWndx+P4oof9Ac1X4SAUiY7+rt1hrt9OeKBC4DzwM0DdmssQu/nCCCRzMFaVIuSUTJ
	 ef4e6Zd+nJNDQquNsRp3dITrnFQBFD83S9K0GZjrcZUj+X3MaphVfABOsJ1T/rsExf
	 FUDkY4lPnYNQUa2xgW1vy+hFvl8QSkQs6qvLe6R5dfsMDvnJifnnF/cXbQrzqWKjrC
	 07K1k0IbdIweya0AEnGhAVIz4na7+yGfuwU+mmQuDSRLlMouyC8mJny50OUt2kjLpb
	 SFh9sa6bOxvvQ==
Date: Thu, 25 Jul 2024 10:21:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	linux-crypto@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 8/9] nvmet-tcp: support secure channel concatenation
Message-ID: <20240725172118.GA2020@sol.localdomain>
References: <20240722142122.128258-1-hare@kernel.org>
 <20240722142122.128258-9-hare@kernel.org>
 <20240723014854.GC2319848@google.com>
 <f69aee16-8238-48cc-986a-6d9dc7f6d933@suse.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f69aee16-8238-48cc-986a-6d9dc7f6d933@suse.de>

On Thu, Jul 25, 2024 at 01:50:19PM +0200, Hannes Reinecke wrote:
> On 7/23/24 03:48, Eric Biggers wrote:
> > On Mon, Jul 22, 2024 at 04:21:21PM +0200, Hannes Reinecke wrote:
> > > +	ret = nvme_auth_generate_digest(sq->ctrl->shash_id, psk, psk_len,
> > > +					sq->ctrl->subsysnqn,
> > > +					sq->ctrl->hostnqn, &digest);
> > > +	if (ret) {
> > > +		pr_warn("%s: ctrl %d qid %d failed to generate digest, error %d\n",
> > > +			__func__, sq->ctrl->cntlid, sq->qid, ret);
> > > +		goto out_free_psk;
> > > +	}
> > > +	ret = nvme_auth_derive_tls_psk(sq->ctrl->shash_id, psk, psk_len,
> > > +				       digest, &tls_psk);
> > > +	if (ret) {
> > > +		pr_warn("%s: ctrl %d qid %d failed to derive TLS PSK, error %d\n",
> > > +			__func__, sq->ctrl->cntlid, sq->qid, ret);
> > > +		goto out_free_digest;
> > > +	}
> > 
> > This reuses 'psk' as both an HMAC key and as input keying material for HKDF.
> > It's *probably* still secure, but this violates cryptographic best practices in
> > that it reuses a key for multiple purposes.  Is this a defect in the spec?
> > 
> This is using a digest calculated from the actual PSK key material, true.
> You are right that with that we probably impact cryptographic
> reliability, but that that is what the spec mandates.

How set in stone is this specification?  Is it finalized and has it been
implemented by anyone else?  Your code didn't correctly implement the spec
anyway, so at least you must not have done any interoperability testing.

> 
> Actual reason for this modification was the need to identify the TLS PSKs
> for each connection, _and_ support key refresh.
> 
> We identify TLS PSKs by the combination of '<hash> <hostnqn> <subsysnqn>',
> where '<hostnqn>' is the identification of the
> initiator (source), and '<subsynqn>' the identification of the
> target. But as we regenerate the PSK for each reset we are having
> a hard time identifying the newly generated PSK by the original
> '<hash> <hostnqn> <subsysnqn>' tuple only.
> We cannot delete the original TLS PSK directly as it might be used
> by other connections, so there will be a time where both PSKs
> are valid and have to be stored in the keyring.
> 
> And keeping a global 'revision' counter is horrible, the alternative
> of having a per-connection instance counter is similarly unpleasant.
> 
> Not ideal, true, so if you have better ideas I'd like to hear them.
> 
> But thanks for your consideration. I'll be bringing them up.
> 

You are already using HKDF, so you could just use that, similar to how fscrypt
uses HKDF to derive both its key identifiers and its actual subkeys.  HKDF can
be used to derive both public and non-public values; there's no need to use a
separate algorithm such as plain HMAC just because you need a public value.

- Eric
