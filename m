Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [144.76.133.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B669E3016E0;
	Wed, 25 Feb 2026 08:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772007204; cv=none; b=V1PGjT2b48LQIQwXZDGvoHNWn+7twZOj+CMCz1iaa+wEHfiTBK0mNdlyK24CaHCrZj5kOD39hLbkg9IotXetsVRq6qXbPXkvSk1ceWsNKMg6zAVBlhS9BRUKJJHFok2lLpzP9tag/zYJaLvvSZpOAe2n8krV7t6Rq870OGHHJMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772007204; c=relaxed/simple;
	bh=KUUez5uTABvsfkIoQWeF7EQs/6IlDgmfkFG1eB8jMfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dztb4mtnaCFhkTM8bKnXIeRnYjMzIQYNChK3yQe/6L+MpJaFgmSfrtkGlRKGNcBYV7AFtz1edGq1Ij5GWOPuk07kjggbLqnougYZWq5VH1VFJhQFjGYRFGQ51L5QjsIeu9afGyN4OtTh7iW+KRMcrcA0svTTn/xfpQrND2ytg7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=144.76.133.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id 4AEBD2041551;
	Wed, 25 Feb 2026 09:13:12 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 048CB24533; Wed, 25 Feb 2026 09:13:12 +0100 (CET)
Date: Wed, 25 Feb 2026 09:13:11 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
Cc: "ebiggers@google.com" <ebiggers@google.com>,
	"horia.geanta@nxp.com" <horia.geanta@nxp.com>,
	"pankaj.gupta@nxp.com" <pankaj.gupta@nxp.com>,
	"gaurav.jain@nxp.com" <gaurav.jain@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"ignat@cloudflare.com" <ignat@cloudflare.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] crypto: caam - RSA encrypt doesn't always complete new
 data in out_buf
Message-ID: <aZ6vF1CHpcp5d5qk@wunner.de>
References: <6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com>
 <aZ296wd7fLE6X3-U@wunner.de>
 <e1d7ad1106dbb259f7c61bdd1910ac9f08012725.camel@ginzinger.com>
 <aZ3Uqaec79TUrP2I@wunner.de>
 <e36dd6fa756015ec1f2a16002fabfa941c33d367.camel@ginzinger.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e36dd6fa756015ec1f2a16002fabfa941c33d367.camel@ginzinger.com>

On Wed, Feb 25, 2026 at 08:02:08AM +0000, Kepplinger-Novakovic Martin wrote:
> ok I can confirm: "git checkout 2f1f34c1bf7b^" indeed is ok and
> 2f1f34c1bf7b is bad.
> 
> It's not the same behaviour I described (from v6.18/v6.19. that could be
> a combination of bugs) because on 2f1f34c1bf7b regdb cert verify succeeds,
> only dm-verity fails

Hm, I assume CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API=n magically
makes the issue go away?
