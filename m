Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8903CB8E9;
	Tue, 29 Sep 2026 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790700406; cv=none; b=SloC76X/b8GEH74nVqdyLkuz8Durhdq8+hlr5nIL9v1F+UAiXJz/PKUqCDFSxwtZTggxnMn1Zgn0y4AkI3hL8QT8B5Kj42AmsILyg+6Zowm5GlO3qlUXUvNGHNnu+oKZ6RwAYWEcsTTxE1Rri8eCs6FLcsiL+ZuIiqhQ3VBG8ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790700406; c=relaxed/simple;
	bh=sHuTYyM1koPNIuxDGZy0vypCtweTVkwjFHI2+UzLEFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a+6nB1OT96Jvh9ucotPfKnfovw9XS0ZwIJrnf7IZVo9JknpHFElhYxnzXnXE1pDxva9K1blcZhOZsfoDGetgDduJqBjv2aiv9x1pg4ca03m8s0X7oTMHwSWAk3RV2ZEWoPGizZATw7/redyq+4XJe78xNs1+K9HLljs8xZK+Gbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr; spf=pass smtp.mailfrom=free.fr; dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b=V72GqbEh; arc=none smtp.client-ip=212.27.42.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b="V72GqbEh"
Received: from L15923.iliad.fr (unknown [78.242.68.224])
	(Authenticated sender: vjardin@free.fr)
	by smtp6-g21.free.fr (Postfix) with ESMTPSA id DF0D478035B;
	Tue, 29 Sep 2026 18:45:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
	s=smtp-20201208; t=1790700402;
	bh=sHuTYyM1koPNIuxDGZy0vypCtweTVkwjFHI2+UzLEFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V72GqbEhpVagYTx4eOxhRTuj9Bz+YUIRuIYO6954AGCWNrs82SWCic0LGvkDbGvUg
	 Td9UFf1y2OdZo22obz/q6DSuGfhNSSSw+LaK59pTdlWWfdfE0lxIy4U6Ur1sA1o55c
	 w/vp2QJpOS/FmloN1o9slMg36yQ2jHZaMrRFoHNn5ACxCtOvTiEhG8Z/TEY1F5gvVs
	 wnFF49J41E5uEb+jwVdWq1A60jFcBE2AWWpmWbEjOyP+s1k4xqQhLjGtQpWPEmT1QL
	 dqwm04K646w4cFKI4sUyFPVfwYYn45Fj83ZWSb8rv1/LO0Jln54yGpb9tgrU2SNSYX
	 0bzoGknELV/PQ==
Date: Tue, 29 Sep 2026 18:45:43 +0200
From: Vincent Jardin <vjardin@free.fr>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Horia =?iso-8859-1?Q?Geanta?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: caam/qi2 - algorithm priority configurable
Message-ID: <arvrN8-o__juAfsk@L15923.iliad.fr>
References: <20260928-for-upstream-caam-qi2-priority-v1-0-e4a8e5f01dbc@free.fr>
 <20260928224143.GA21235@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928224143.GA21235@google.com>

Hi Eric,

On Mon, Sep 28, 2026 at 10:41:43PM +0000, Eric Biggers wrote:
> Is there *any* real-world use case in which these caamalg_qi2.c
> algorithms are worth using?  This looks like another one of those
> problematic drivers pushed by the hardware vendor as a checkbox feature.
> Just doing the crypto on the CPU is almost always much faster and more
> reliable.

It is not black and white, and I am working on some optimizations.
Today, with one key, one A72 core with the Crypto Extensions is about
2x better than the SEC, at every buffer size. However, that core is
then at its limit: 6 to 9 Gbps of AES-128-GCM, fully busy.

With many keys and many buffers in flight, it changes. With 16 KiB
buffers, 16 keys and some WIP fixes (MC firmware configuration mosty, maybe
few kernel fixes), one A72 core feeding the SEC reaches 47.1 Gbps, while
the same core does 9.3 Gbps with the Crypto Extensions. At 4 KiB it is
14.4 against 8.5 Gbps. At low network packet size (WIP about 1400 octet) the
A72 wins.

For single flows, the SEC should not be used: with the current kernel code,
one key cannot go past about 4 Gbps.

So, even if it is tempting to drop caamalg_qi2.c, I believe some users
still have a use for it. Note: I only focused on AES-128-GCM.

> As shown by your other patch
> (https://lore.kernel.org/linux-crypto/20260928-for-upstream-caam-qi-plain-keylen-v1-1-6edb56649cf9@free.fr/)
> it also seems that this driver has been critically broken for the last
> year, with it being unable to set keys.  Evidently, no one has tested or
> used it in the last year until now.

Agreed. CONFIG_CRYPTO_SELFTESTS caught it on the first boot.

> It also has the usual anti-patterns like supporting MD5 and DES.

I cannot argue with that, but I would rather not be the one who drops
them from caamalg_qi2.c.

> I really don't see the point.  Why do people put themselves through
> these issues at all?  It seems this functionality should just be
> disabled everywhere, without putting policy in the device tree which as
> has been noted many times isn't the right place for it.

Definitely, the device tree is not the right place, I get the point.
v2 will move away from it.

My first goal is to get these features working again on the
LX2160A, and to be able to select the crypto backend.

Best regards,
  Vincent
