Received: from mout-b-107.mailbox.org (mout-b-107.mailbox.org [195.10.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613CB498926;
	Mon, 28 Sep 2026 10:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.10.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790591127; cv=none; b=InxyybMbbos0VY6mCTxf5cqgqsyCVWgUu41ltG/KmBpAOWZAr7HdvlBhcPB9BDrnvdlqHOYVSlZG6Wt/AzDCjHZuPsk/A8q3458Z83jW8vRB5nOR23xqkt1QlCteaitFbUf1xKOMQPgeHc6KS8Pp9PqRBUderHCYMOsJzRen5nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790591127; c=relaxed/simple;
	bh=MT2Bc/ZNls4asFb7dpperaXWEgFdq6n1uxLmf9vLQ58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gx6jkgTNGcqkZsqXbb8pEPuDy5mucTLRNEQMWTf4SIYsFxA9HJirIfmRkGiPP176nerhgScROQJQB+87D9neDrpFFkpQLtBEb0omSPpaTAN29S46zvurtlgLM0Gf6CVmMd8x85dnTfej35OfNG4LDg4rP449O/x8xoC7TI6MJEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com; spf=pass smtp.mailfrom=mandelbit.com; dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b=MB6wiG3p; arc=none smtp.client-ip=195.10.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b="MB6wiG3p"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-107.mailbox.org (Postfix) with ESMTPS id 4htcrS2Cz0z3yZ5;
	Mon, 28 Sep 2026 12:25:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1790591112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5PKjogvk9Bz/ff62lcGFG1HPawyd9V8ON7tXYK3jSgA=;
	b=MB6wiG3pEmvq8yYvVozRUtis4WdO6kSjy12WW8AcwqycCiIFt138JO9EY8WTn1jpMEgKER
	z9cWooHDczpCY3OKh8c9vu/tZYQGbpaqimkB05iudElK4BaIPasQpqP9wF6I7D75GpuhJj
	PZyGJqtthZk/K36X9S3Drww5iWj/3LhUPyVn7RVejxvS8L98Wyy9nVF8EIb8XpXRyv45Kz
	0ijLb3z/Hznsfk3m+iSEvHRiVt44GgSs/ZXt1eCfJdoaf9eDStGsR+07azXnt7e0AEiKv4
	/LkkvpXz89NmiN8FsuQEGcm8AU8dgWDAdkbzH1jyuDtvq8U8b4lovTojcJBU4w==
From: Ralf Lici <ralf@mandelbit.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH crypto 2/2] crypto: safexcel - Map AEAD buffers with accurate DMA directions
Date: Mon, 28 Sep 2026 12:25:00 +0200
Message-ID: <20260928102502.266108-1-ralf@mandelbit.com>
In-Reply-To: <arn3UFsriRlGMXwB@gondor.apana.org.au>
References: <arn3UFsriRlGMXwB@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 28 Sep 2026 15:12:48 +1000, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Sep 23, 2026 at 11:13:17AM +0200, Ralf Lici wrote:
> >
> > There is no caller to identify for that particular single-entry layout,
> > it was only a hypothetical example in response to your question. Even
> > for out-of-place AEAD, the destination starts with space reserved for
> > the associated data (as documented in the comment at the top of
> > include/crypto/aead.h). A single linear destination entry can therefore
> > contain both that reserved prefix, which the device does not write, and
> > the ciphertext and tag, which it does write. Because the DMA direction
> > applies to the whole entry, such a mixed entry is mapped
> > DMA_BIDIRECTIONAL.
>
> So why is it a problem if the dst SG list entries aren't pointing
> to memory that's also occupied by the SG list entries?
>
> Even if the hardware doesn't write to the data, it should be OK to
> map them.
>
> The only issue that I can see is if the same memory is present in
> both the src SG list and the dst SG list, but that is expressly
> forbidden for out-of-place operations, and indeed would be a grave
> security issue.
>

I think the missing point is that DMA_FROM_DEVICE is not neutral for
bytes which the device does not write.

For an out-of-place request, the caller may have already populated the
reserved destination AAD area. The AEAD API says that this area will not
be written by the cipher operation:

  Even in the out-of-place case, space must be reserved in the
  destination for the associated data, even though it won't be written
  to.

With SWIOTLB, however, mapping it as DMA_FROM_DEVICE may leave the
corresponding bounce-buffer bytes uninitialized, and unmapping then
copies those untouched bytes back over the caller's AAD.

The API also explicitly permits the source and destination AAD entries
to describe the exact same byte range (and users do this in practice,
for example nitrox_rfc4106_set_aead_rctx_sglist):

  It is permissible for the "destination" associated data to alias
  the "source" associated data.

Therefore, this is a valid out-of-place request:

  src: [ AAD X ] [ plaintext P ]
  dst: [ AAD X ] [ ciphertext C ] [ tag T ]

P and C use separate storage. Only the two AAD entries point to the same
addresses X.

Safexcel currently maps the source list as DMA_TO_DEVICE and the whole
destination list as DMA_FROM_DEVICE. Consequently, X is mapped as device
output even though the accelerator deliberately does not write it. On a
non-coherent system or with SWIOTLB, unmapping the destination can then
overwrite X with stale data.

Thanks for following up.

-- 
Ralf Lici
Mandelbit Srl
