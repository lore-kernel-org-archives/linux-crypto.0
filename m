Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFCEAD59;
	Tue, 11 Jun 2024 02:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718073155; cv=none; b=gJc8+BeRtEdEQ+Xf+lPZWyH0OZKsrbc5xOnb2bsEdY42rhJaie13R7ptHm0+QAySxEjM5l396xmkcU6I1h7zcZT2jS5fT4alt0RVIGBW14HxwJMsHorj3TsLs7n0lrLXetkttQtcITItlL05JX/32JmAzGGjob3hTDbf2FNfF1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718073155; c=relaxed/simple;
	bh=il6VZjleomLNSXm4SPKD3Lg7Gunw+n3GoT8C4A8a638=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EVKNHSIDw8+Jg3ijpMC4ghDj16QKtsoSLDAsqgFPmnXY7KD5R8EQ9UK9jP5UCIl04jgrMrv+0R2jFL+fVPH2n9572lod1j+9pT+Z8wwtcYGSBh1s5se2/XM5FBXmVZDBXELMhLkAjA52zzk1J3mmOEJad/BfbH9qzIDpvCq+PeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sGrIV-007rLt-0K;
	Tue, 11 Jun 2024 10:31:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Jun 2024 10:31:45 +0800
Date: Tue, 11 Jun 2024 10:31:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kamlesh Gurudasani <kamlesh@ti.com>, Eric Biggers <ebiggers@kernel.org>
Cc: kristo@kernel.org, will@kernel.org, akpm@linux-foundation.org,
	davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, robh@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	vigneshr@ti.com, catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 0/6] Add support for MCRC64 engine to calculate 64-bit
 CRC in Full-CPU mode
Message-ID: <Zme3EcW4Uz8kTbTt@gondor.apana.org.au>
References: <20240524-mcrc64-upstream-v3-0-24b94d8e8578@ti.com>
 <87tti098af.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tti098af.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>

On Mon, Jun 10, 2024 at 08:03:44PM +0530, Kamlesh Gurudasani wrote:
> <kamlesh@ti.com> writes:
> 
> > From: Kamlesh Gurudasani <kamlesh@ti.com>
> >
> > MCRC64 engine calculates 64-bit cyclic redundancy checks (CRC)
> > according to the ISO 3309 standard.
> 
> Could you please review this and let me know if any changes are needed
> to get it merged.

Eric Biggers had concerns about adding this to the kernel.  I'd
like know if he's OK with this or not.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
