Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E98A45DF5B;
	Wed, 30 Sep 2026 09:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759344; cv=none; b=GRShw1gyQUTH2muwiPtKnj7BCMviDMvlBwlUpT3foj+fO5BWij0Kuz/lm9aTY0cdyxmiVAqNh5VmXvggsAlRoh0Cu7zTGJrSVMDgnV579AJRey/aCRQlAfjBoROA/62duJrxeAW+Br7Gq1dHiJxEn2pi4NPHvEKH3j8m+foMde0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759344; c=relaxed/simple;
	bh=55xGQO+w6GLeg1bQFhjKSGYGUTJZzPla73l0Sz2cK6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYnwtr9/FC+Szc1jRlgHZ4NCqCHcTY+LQ8RdZVJ7zncFAwGOJYIg73mUWjQxWOlyz4illaQA7UjWM7275wpfeAcYwlKTU2ovJ6M5gIMSpgavkj3FFUqR3PfXYoYNdJGyVK7qMX9qFggUELjaM1NLmlv5L/v4qlyK4VT5Q9eOUgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr; spf=pass smtp.mailfrom=free.fr; dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b=CHCz4HOF; arc=none smtp.client-ip=212.27.42.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b="CHCz4HOF"
Received: from L20747.iliad.fr (unknown [213.36.7.12])
	(Authenticated sender: vjardin@free.fr)
	by smtp6-g21.free.fr (Postfix) with ESMTPSA id 8AA0B780514;
	Wed, 30 Sep 2026 11:08:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
	s=smtp-20201208; t=1790759339;
	bh=55xGQO+w6GLeg1bQFhjKSGYGUTJZzPla73l0Sz2cK6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CHCz4HOFK2lTteHDjl4CVBdEzMTIBt4Bm2uqtbAw50iSX94xCFG7oQFbr6Xa+gH2X
	 GXRqUwfptq4iQi6dx0lO/DFKe2LstmPsconxmhSrW8o32k4NkS7Gx6tWOiHkJc8TK6
	 wN6emXp6SFwx8czC3H2q+gqVOCw/2dupW4tRmcqeYDkQ9gPYUmhwdyUmWyE2PPh82X
	 bYncgHu+MGkndjUoZfOx/xiOyJC8hzvDe8sBfuTq0fM7a+6D0ugk2zBFLUI3Wa7Rh5
	 8CGyPGL97EVIBNPbRI2TCszxL2bGTmUmOTayZ/8L2gJbXYvl784nJpDsmShlpHEKqH
	 VyhPPo6KyL8ZQ==
Date: Wed, 30 Sep 2026 11:08:48 +0200
From: Vincent Jardin <vjardin@free.fr>
To: "Sahil Malhotra (OSS)" <sahil.malhotra@oss.nxp.com>
Cc: Horia Geanta <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH v2] crypto: caam/qi2 - lower the algorithm priority
Message-ID: <arzRoCQHvM_K9y9W@L20747.iliad.fr>
References: <20260929-for-upstream-caam-qi2-priority-v2-1-bf0559ebf574@free.fr>
 <DB9PR04MB8139034E6D0186A687183208828B2@DB9PR04MB8139.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB9PR04MB8139034E6D0186A687183208828B2@DB9PR04MB8139.eurprd04.prod.outlook.com>

Hi Sahil,

Le 30/09/26 07:21, Sahil Malhotra (OSS) a écrit :
> Hi Vincent,
> 
> I'm not sure I understand the need for this change.
> Is it now expected that hardware accelerators should have a lower default priority than ARM CE?
> Users who want to use ARM CE can already choose it at runtime, so changing the default priority does not seem necessary from my perspective.

Not as a general rule. The default priority should select what is best
for most users with the platform as it ships, and on the LX2160A this
is the CE.

Measured on an LX2160A (16x Cortex-A72 at 2.2 GHz) with tcrypt,
AES-128-GCM encryption, 4 KiB requests:

    gcm-aes-ce                      1 core      1107 MB/s
    gcm-aes-caam-qi2, 1 in flight               128 MB/s
    gcm-aes-caam-qi2, 32 in flight  1.4 cores   418 MB/s

It is the same for cbc, ctr, xts, rfc4106 and sha256/512, at every
size I measured: the SEC is slower, and its driver path costs more CPU
per byte than doing the crypto on the core.

The SEC can win, but only in a narrow case. The MC DPC and DPL have to
be tuned for it (one DPIO and one DPSECI queue pair per CPU, and the
SEC coherency setting in the DPC), and the load has to be large
buffers over many keys. I did set such scenario for my internal
working cases, but it they are not the default cases.

This is the case of QAT in commit
  8024774190a5 ("crypto: qat - lower priority for skcipher and aead algorithms")
most users call the crypto API synchronously on small buffers and do not
benefit from the accelerator.

  > Users who want to use ARM CE can already choose it at runtime, so
  > changing the default priority does not seem necessary from my
  > perspective.

In practice it works the other way round. IPsec, dm-crypt or kTLS ask
for an algorithm by name and get the highest priority, they do not
choose a driver. The users who gain from the SEC are the ones who also
tune the DPC and DPL for it, and they can raise its priority with
crypto_user, or ask for the driver by name.

So the CPU should be the 1st gear, and the SEC should be the next one,
for those who set the platform up for it. It is not a statement that hardware
crypto is slower in general.

I only measured the LX2160A, not the LS1088A or LS2088A. If you have
numbers there with the SEC ahead, I'm happy to look at them.

Best regards,
  Vincent
