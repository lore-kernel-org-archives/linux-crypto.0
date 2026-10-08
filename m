Received: from mout-b-106.mailbox.org (mout-b-106.mailbox.org [195.10.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC8A44063B;
	Thu,  8 Oct 2026 08:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.10.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448032; cv=none; b=mkyXBbDpZQhp2gBYn9K0ievarDDldNPg8zxng8uCfXysdtQivq+du0qAz5QnQgSdA9XOapFLPSE7LuU+87qvUmp6jT91yy1V9JEi2CMwt2OGFABxoMUx79MQAA0kcipvLEd3tY+Tx/+lS9edkHFMjn/MxV2fgYoTXqq56zEdKsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448032; c=relaxed/simple;
	bh=W2FiMfqNT76u+PmRotKF3fwFJBZ6h8Aw6J4ijgeDlEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxeSv/sdlDJ6OnQIGHSVrzQVIYNO/skoU4EZH/6A2hSIt2uYCViyilp9iF5UXGyQQ4YnMaOKbE7oBAzOVz7Y4uSi0bBkrpqIh4zGaTc+Ul7AvhCds9eRcl7km55/AnHXyEPyG/6ozsZPp8bs0JEFtedi/DkYsYTT62oWCTCAtWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com; spf=pass smtp.mailfrom=mandelbit.com; dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b=1LAMQ2dF; arc=none smtp.client-ip=195.10.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b="1LAMQ2dF"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-106.mailbox.org (Postfix) with ESMTPS id 4j0jdX2ZnSzNly6;
	Thu, 08 Oct 2026 10:21:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1791447712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+qaCxgDcAncZY5S4v07CSiuSyR8RtPuFA/S9rsJ2uJk=;
	b=1LAMQ2dFRlFQs4sF2uo9ShvmtNqWgjO+GjQeiF/d+goG5rk46i8lKhy2bpDFsrTyzv+Xok
	AQOfyZ54P94JCNDQZmMvqYpQeoxgY9+zo9mcAROUa8NaoBPS8OgkXcUBtS04eoRU9qFg1o
	RxRZPPOdF57Cm+MrbDJlCp2Ia31DyP3MboCHN0L/V5/RklaI7cUbxr79TCVw3gtkUV1age
	RR8KL6Tgx1Tla1lHpYHVKfAEe8EtyLnmj3KG+fambZzqVkf4/UVVvrHgiOYbHNQufxHovI
	Ffq9VD8LlclU2eCZwcTyLwW0WxfN6oPxu2LUpRIGuUPWIplgaPuo/OxsF1reaw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of ralf@mandelbit.com designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=ralf@mandelbit.com
From: Ralf Lici <ralf@mandelbit.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH crypto 2/2] crypto: safexcel - Map AEAD buffers with accurate DMA directions
Date: Thu,  8 Oct 2026 10:21:44 +0200
Message-ID: <20261008082145.125762-1-ralf@mandelbit.com>
In-Reply-To: <asdL7rQTM5nSTIH5@gondor.apana.org.au>
References: <asdL7rQTM5nSTIH5@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4j0jdX2ZnSzNly6

On Thu, 08 Oct 2026 18:53:18 +1100, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Sep 28, 2026 at 12:25:00PM +0200, Ralf Lici wrote:
> >
> > For an out-of-place request, the caller may have already populated the
> > reserved destination AAD area. The AEAD API says that this area will not
> > be written by the cipher operation:
>
> That's what I was asking.  Which caller is doing this and thus
> would be broken without your patch?
>

The caller which exposed this is the ovpn UDP-GSO transmit path [1],
part of a series currently under review and not in mainline yet. It
builds an out-of-place AEAD request and explicitly copies the
authenticated header into the reserved destination prefix before
submitting it:

  ovpn_aead_encrypt_header(..., aad);
  skb_store_bits(gso_skb, offset, aad, aad_size);

The source AAD then points to the temporary aad buffer, while the
destination AAD points into gso_skb (they are separate storage). The
accelerator skips the destination prefix as required by the AEAD API,
but safexcel maps it as DMA_FROM_DEVICE, so SWIOTLB may copy untouched
bounce-buffer contents over the header during unmap. This is the
out-of-place case in which I reproduced the corruption.

Technically, the in-tree ESP out-of-place path also constructs its
destination around an already initialized header, but my ESP tests did
not reproduce the corruption, so ovpn is the concrete demonstrated case
here.

[1] https://lore.kernel.org/openvpn-devel/f075b9782b14d64756c84e132c138482f08287b9.1790843153.git.ralf@mandelbit.com/

-- 
Ralf Lici
Mandelbit Srl
