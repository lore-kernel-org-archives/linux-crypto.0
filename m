Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AB85221D5;
	Tue, 29 Sep 2026 12:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790686730; cv=none; b=JHfRRk0X17UG5cqoQTF5KrsuJoIBfVyiBmU3wDKOJgwk1GnAM2klxp+sktrEauAnHwNSIkhR1+6hv6jy3ygIDSgo6iZtTGpSIeSIOKWipewYrR79ubYA7eJE7DGegZkqpEou6djMJXRgYbc4Q6V+/HYbKjQzuiBqibS32uzYhkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790686730; c=relaxed/simple;
	bh=W5WBJWjR+YEpaPvINZanO9tBiGOMnygayoUKa9O10lE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I6g5SQ2JCNQDugvLlyc6Jpg/JewK/NMlqWpSuTKrWdOaNKJHid6jJkRshr4DGFm8uN1qvjVdGhqtb3h6B5ggt1ePwW7X+JR30T4km3HWhyiNjUZmWZMiYpzgwJ6KtahnPRcb0BN5NNn4Tt1lYrYoHpHkvDYPs8b8GqqeV/clqkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr; spf=pass smtp.mailfrom=free.fr; dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b=KPC4p2Ci; arc=none smtp.client-ip=212.27.42.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b="KPC4p2Ci"
Received: from L15923.iliad.fr (unknown [213.36.7.12])
	(Authenticated sender: vjardin@free.fr)
	by smtp6-g21.free.fr (Postfix) with ESMTPSA id 1C28E780389;
	Tue, 29 Sep 2026 14:58:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
	s=smtp-20201208; t=1790686726;
	bh=W5WBJWjR+YEpaPvINZanO9tBiGOMnygayoUKa9O10lE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KPC4p2CiGf7uawt3WHebNWJJTe2iHDlRR1dJ11YKNvqWH9d/qY0od1B+/FoQ9qAEZ
	 x2IJqvHLxH1gS5n7uYY1MxpK52EcHUKrGVPMQS0m/QimX26UkyLxk++9VAjI0kqjUM
	 rRvYuQkp1wNNtQd/30d22Re6h+gaXQgPz7+qLWH6t1+2hWgLd7B+eNlbGPn9YzvDPp
	 WLjbfIDnPkzDG5LICnfKOUOxqXzFpikAfTQLR+R2iusRuhm8c25177wmGyZYYNHIg3
	 tMAOK0nb6FETt42pMgVK5iJNHTdxyx0AtR/Nrzz53TwXsMectfOt6KTy8DkZHJkcAu
	 DZQY1nf2SL2mA==
Date: Tue, 29 Sep 2026 14:58:30 +0200
From: Vincent Jardin <vjardin@free.fr>
To: Krzysztof Kozlowski <krzk@kernel.org>
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
Subject: Re: [PATCH 2/3] dt-bindings: crypto: fsl,sec-v4.0: add
 fsl,qi2-crypto-priority
Message-ID: <aru19hzLNGqVmKIR@L15923.iliad.fr>
References: <20260928-for-upstream-caam-qi2-priority-v1-0-e4a8e5f01dbc@free.fr>
 <20260928-for-upstream-caam-qi2-priority-v1-2-e4a8e5f01dbc@free.fr>
 <20260929-mysterious-fast-cormorant-37005b@quoll>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260929-mysterious-fast-cormorant-37005b@quoll>

Hi,

Le 29/09/26 11:08, Krzysztof Kozlowski a écrit :
> On Mon, Sep 28, 2026 at 04:01:04PM +0200, Vincent Jardin wrote:
> > Let a board set the crypto API priority of the algorithms the DPAA2
> > front end (dpaa2_caam) registers.
> > 
> > Benefits: Its DTS decides whether the SEC or the CPU is the default for
> > in-kernel crypto.
> > 
> > Signed-off-by: Vincent Jardin <vjardin@free.fr>
> > ---
> >  Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> 
> Same as previous tries for crypto drivers - not a hardware property.
> 
> You described the desired Linux feature or behavior, not the actual
> hardware. The bindings are about the latter, so instead you need to
> rephrase the property and its description to match actual hardware
> capabilities/features/configuration etc.

agree, I'll avoid it.

Vincent

