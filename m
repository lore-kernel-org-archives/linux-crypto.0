Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB7C3B14C9;
	Fri, 19 Jun 2026 16:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781887601; cv=none; b=PNYOLMgpIbmRK5AjJUFv+xMhcW8eoRmHTlsprQm8qdaPewQwwVx76gZ2eQs0HA/l++69u0OP2kH1bAZumMaZmkPYmQHfhvCD/6Q67LkL2fRrRWsj3EyN+JFkXaj/+ouZTZ+nEVy9t27LxbrnpgLqfrWUX3UuZQdbqR/X3XJmfY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781887601; c=relaxed/simple;
	bh=W+ryORRTmj+ILuSp3QvcLjpV9WPLF5j4G8We2apjGeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sM/p93p4Qe88OlQ/Ne5kF0Yy3heairm4e1Abe+8gbol4JR6wrIEXM2Llf1vRzFIZcUvrRnLrGG9365PD2HD9ELEqKsSqhd9mSIYR23lR6mTRFlX3QwyD4j1e8hl6DFeOcNRl4K4vqHG36T0DIISXYa/9KxJcgbVataUOu4y07co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKUHuK7I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKUHuK7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8AC1F000E9;
	Fri, 19 Jun 2026 16:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781887600;
	bh=c5JRDdmtgCFvN6wGQfLZcw3GVOJePJ67hBap933kVOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SKUHuK7IfuvVPpbdswcNr/zHJA3JX+wzizv6Xk0rwpcUSkO0FCqLevy7gBo6PK4k0
	 BLpnD17OqvnuWXDaIGKRvPOdifz3tqo8p9xCpfqQFe4vB+hfOBn4ek4QZYdb2eApjh
	 fS8QGtZeAACAqLP9opBVeQmp3pqHoO1OyBNEc0X932EeNG9p/sKuvv1eYVF3MOaVkp
	 cmVzCKyaDXaQC8PftMEsR/fyDVhYUyijS2CzWSbiXMYoQkb7unS/d8eI6veyeMMuSj
	 41Xq/N0DOhMfcciXOeos7arNikbbgP9/vOcZ2L4s0EOYgXsXtCM7slzU+4N3fgFTT2
	 piJP5iO2Wz03g==
Date: Fri, 19 Jun 2026 09:45:06 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	dmaengine@vger.kernel.org
Subject: Re: [PATCH 0/5] Shikra: Add DT support for ice, rng and qce
Message-ID: <20260619164506.GA3223@sol>
References: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
 <53b1fa61-9692-42fd-a295-98bbeacbcd9a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53b1fa61-9692-42fd-a295-98bbeacbcd9a@oss.qualcomm.com>

On Fri, Jun 19, 2026 at 02:13:28PM +0530, Kuldeep Singh wrote:
> On 21-05-2026 18:47, Kuldeep Singh wrote:
> > This patchseries attempt to enable sdhc-ice, rng and qce on shikra
> > platform similar to other platforms.
> > 
> > Previously, the 3 dt-bindigs/DT changes were sent as individual series
> > and with feedback received, clubbed them together as all belong to same
> > crypto subsystem.
> > 
> > Here's link to old patchsets.
> > QCE: https://lore.kernel.org/lkml/20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com/
> 
> Hi Eric,
> 
> As selftests issues for QCE are now fixed[1], so shikra series should be
> good to proceed? as your concerns[2] are now addressed.
> I am waiting for merge window to end and will send next rev post that.
> 
> [1]
> https://lore.kernel.org/linux-arm-msm/20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com/
> [2] https://lore.kernel.org/lkml/20260522024912.GC5937@quark/

If you think that then it sounds like you need to read what I actually
said.  The fixes are appreciated but don't change the big picture.

- Eric
