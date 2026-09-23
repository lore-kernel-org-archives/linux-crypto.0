Received: from mout-b-202.mailbox.org (mout-b-202.mailbox.org [195.10.208.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BF1480968;
	Wed, 23 Sep 2026 09:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.10.208.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790154825; cv=none; b=HW2KiXw2bEbyDqYITwy7QLCNPwl/BNe3bp7y+8nCyW84Fm8zkA+LDBWoUDBwsxadjQybGiiDNmNuD8FFhgP1wc5mF+7u1nlvexnGis6IH7jrg5cxyV8YbZCLoMyx4NjNdWCmfeTtnTvnOhPi/Adq8ykaUl1SjDSP9RoNc+ek3zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790154825; c=relaxed/simple;
	bh=H8/WVNhgRRbdHHjOQs6qkrY50aChoEZtMuZ2QnJuwLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MO45g7coPJ4RO+iHNrePrAfpGcmUevLS70nXl8VVq0/HLqcHXT+28dHLRkswct6gU7FzFUR2xDCN83aAEI/f3OtDwIKN2pCIW8kB4VrA1yyMVDPP/dh2waWuQq7n2/kRJOTTOlKtW/CdX99q4grGP6ax25oqZFvJs7BqbN+h0kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com; spf=pass smtp.mailfrom=mandelbit.com; dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b=j1tG9bXN; arc=none smtp.client-ip=195.10.208.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b="j1tG9bXN"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-202.mailbox.org (Postfix) with ESMTPS id 4hqWV31ThxzKnnM;
	Wed, 23 Sep 2026 11:13:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1790154811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TTU/qI1kp9M6tVqM8doRUWR+9Id6GptuRD4bFzeM+qs=;
	b=j1tG9bXNYO3AL74LjDhASxtjGozZ9SmaNkfKwpJ9+dKNdETAiGyaB8xqvaIvjZ3Q4o/1lg
	gazvO8MI/VJLlabIzsFpkwn4VgKO42LUcOVnB6xSdoshN3CvOE7Mm6xycCYTSUdGDGRDOH
	HjkdU6JhC7jJ0MLsWooMd3IcLp7+XeTBpAcJPJ1hVl2EEdx4U21k7hOKntCuKB9DHWQm3S
	mPXuG3u0jdjmCKSC8B93z0rdBZieb3tBMUEIuLXaCNtegjY0V2acgVlLRYBid9So75OvXR
	xsVvZ0sSueJ9TdPanumSP37V6rbmStX8vj4b8UfVXUH4EctL9kjNw1qyMQLVog==
From: Ralf Lici <ralf@mandelbit.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH crypto 2/2] crypto: safexcel - Map AEAD buffers with accurate DMA directions
Date: Wed, 23 Sep 2026 11:13:17 +0200
Message-ID: <20260923091318.194633-1-ralf@mandelbit.com>
In-Reply-To: <arOOmSnC1NxvG1nw@gondor.apana.org.au>
References: <arOOmSnC1NxvG1nw@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 23 Sep 2026 18:32:25 +1000, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Sep 23, 2026 at 09:26:46AM +0200, Ralf Lici wrote:
> >
> > No, the regions do not need to occupy separate sg entries, the patch
> > selects the direction conservatively for the whole entry.
> > 
> > For a completely linear in-place request, the entry overlaps the output
> > range and is therefore mapped DMA_BIDIRECTIONAL. For an out-of-place
> > request, the source is mapped DMA_TO_DEVICE. For example, a single
> > destination entry covering:
> > 
> >     [ AAD | ciphertext | tag ]
> > 
> > has a logical output range covering only:
> > 
> >           [ ciphertext | tag ]
> > 
> > Since the entry also contains the preserved AAD prefix, it is classified
> > as mixed and mapped DMA_BIDIRECTIONAL. The same applies if an entry
> > extends beyond the end of the output range.
>
> Wait, I think this suggests that the caller is giving us bogus
> input.
>
> If the input is out-of-place, it shouldn't contain overlapping
> data.
>
> Which caller is this?
>
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>

Sorry, that was a misunderstanding, used "overlap" poorly. I only meant
that one sg entry can contain both the reserved AAD prefix and the bytes
written by the device. I did not mean that the source and destination
share memory.

There is no caller to identify for that particular single-entry layout,
it was only a hypothetical example in response to your question. Even
for out-of-place AEAD, the destination starts with space reserved for
the associated data (as documented in the comment at the top of
include/crypto/aead.h). A single linear destination entry can therefore
contain both that reserved prefix, which the device does not write, and
the ciphertext and tag, which it does write. Because the DMA direction
applies to the whole entry, such a mixed entry is mapped
DMA_BIDIRECTIONAL.

-- 
Ralf Lici
Mandelbit Srl
