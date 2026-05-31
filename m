Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C675623E25B;
	Sun, 31 May 2026 16:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780243304; cv=none; b=PfJHV88SNiFKR+l6v9o0fNY7YQekaKCdHKVHztslkqsbBDD2T7qTlYAb1v4BDLDbZPaThyGCB46RLbP9wQ5PnP4Sbk77JSNIvuDY1laFZXYj5owvmRf0wkWmurJsRX/kz4RuRESTnpSuhA4/kE+Cc7ry7yXDjSoAXNLU/QUNTwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780243304; c=relaxed/simple;
	bh=fhuhiehJFZcSOGn14Hjza4IXXuXrGYzev5Sb76h8B68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/MtUCZ2iRUaPUyJ4uW3Eu4koEIagVMyRM1APw9a5CCrTYtdnQd36HhSFF5wIcKstj8aYdELKrfaQ4B1Jdw9hUqBdAhLbc3aRX3CpjGOCtDOkcK0HdCRkZiJ4lnYnf6KOYWVwFwMRRsLWcNyUiiYExb6ZqmECsuQ5NfSFhgl4X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ialh5EIq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ialh5EIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FF71F00893;
	Sun, 31 May 2026 16:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780243303;
	bh=ps2TjyB09tV9voLQd4jP0mWt7CpejjrGG3yYcZeN2+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ialh5EIqBZjQ1Fuj2nwl996CNtiTfS1EcPFgjXmt7/kZuU6/Qkjf8CwkcdNY2ohX+
	 Vg5ttoC4+58UL+TX7jc4eBQt7clET3tnBW3LOnz7gcFmmCO1YH6moMP65QwkD7Ba/o
	 9OUjlb6xYCHTCSeMayA+hojJ9GgSxnACmNYVqblCSKMkUkTmy2t23TLFxnvE8njWX0
	 CXk6cIYK30sL0dwCORiF1OGWwh5b5QJlGQLiHEGSPTtTtj0xE6F87BUegYqShJ7b7q
	 1j8M+TLJ9YB7hAF4XhGx/4uQFnSH+/DTabyv6nqpLH+osktiIvF+2BICmEMo9SESRM
	 DKscjz1ri6smA==
Date: Sun, 31 May 2026 09:00:20 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Christian Lamparter <chunkeey@gmail.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: crypto4xx - Remove insecure and unused rng_alg
Message-ID: <20260531160020.GA2255@sol>
References: <20260529220430.34135-1-ebiggers@kernel.org>
 <5c74c261-53cf-4185-a8a0-7554bc9fe5f7@wp.pl>
 <20260530192630.GB6807@quark>
 <465adf3a-2c27-43d0-afdb-68ae12b89d10@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465adf3a-2c27-43d0-afdb-68ae12b89d10@wp.pl>

On Sun, May 31, 2026 at 12:15:49PM +0200, Aleksander Jan Bajkowski wrote:
> Hi Eric,
> 
> On 30/05/2026 21:26, Eric Biggers wrote:
> > On Sat, May 30, 2026 at 05:05:19PM +0200, Aleksander Jan Bajkowski wrote:
> > > Hi Eric,
> > > 
> > > On 30/05/2026 00:04, Eric Biggers wrote:
> > > > Remove crypto4xx_rng, as it is insecure and unused:
> > > > 
> > > > - It has only a 64-bit security strength, which is highly inadequate.
> > > >     This can be seen by the fact that crypto4xx_hw_init() seeds it with
> > > >     only 64 bits of entropy, and the fact that the original commit
> > > >     mentions that it implements ANSI X9.17 Annex C.
> > > In addition to a seed, the PRNG also uses ring oscillators as sources of
> > > entropy. The entropy should be higher than 64b. This is the Rambus EIP-73d
> > > IP core. The same IP core is built into eip93 (EIP-73a), eip97 (EIP-73d),
> > > and eip197 (EIP-73d). You can find the documentation online. The complete
> > > "container" is actually Rambus EIP-94, and one of its parts is EIP-73d.
> > Just because it may have another source of entropy doesn't mean its
> > security strength is higher than 64 bits.
> > 
> > I cannot find any documentation other than
> > https://datasheet.octopart.com/PPC460EX-SUB800T-AMCC-datasheet-11553412.pdf
> > which says "ANSI X9.17 Annex C compliant using a DES algorithm".
> > 
> > DES actually has a 56-bit key, so maybe I was over-generous.
> > 
> > And according to https://cacr.uwaterloo.ca/hac/about/chap5.pdf ANSI
> > X9.17 has only a 64-bit state anyway.  So even if we assume the
> > datasheet is incorrect and the algorithm is actually 3DES which has a
> > longer key, the state is likely still 64-bit.
> According to the datasheet, there is no second source of entropy. The PRNG
> has three built-in LFSRs. Each of them can be initialized independently. The
> first LFSR is used to generate input data. The second and third are used to
> generate keys for DES encryption. The output of the first LFSR is encrypted
> using 3DES with two 64-bit keys. Between individual DES operations, data is
> XORed with the seed. It sounds like a fairly secure design if properly
> reseeded.
> There is also a newer design (EIP73a) based on the same algorithm. The
> only difference is the replacing of 3DES with AES using a 2TDEA scheme.
> The DES-based variant is more widely used, even in new SoCs.

Okay, it sounds like you're walking back your claim that there's a
second source of entropy.  That leaves just the 64-bit seed that the
driver writes to CRYPTO4XX_PRNG_SEED_L || CRYPTO4XX_PRNG_SEED_H, which
probably corresponds to the "first LFSR" you mentioned.  The driver
doesn't initialize the other LFSRs.

> > So it isn't looking good.  And since it's an undocumented proprietary
> > design it shouldn't be given the benefit of the doubt either.
> > 
> As I mentioned earlier, this IP core is quite well documented[1] (page 198).
> Half of all SOHO routers have the EIP-73d built in. The algorithm is also
> described in TRM for some of these SoCs :)
> 
> List od SoCs with EIP-73d:
> AMCC PPC405EX/PPC460EX,
> Intel/Maxlinear GRX350, URX850,
> Marvell Armada 37x0, 7k, 8k,
> Mediatek MT7623/MT7981/MT7986/MT7987/MT7988,
> Qualcomm IPQ975x.
> 
> [1] https://www.scribd.com/document/734250956/Safexcel-Ip-94-Plb-Sas-v1-5?_gl=1*dng4pf*_up*MQ..*_ga*OTQ4NjkzMTAxLjE3ODAyMjA4ODI.*_ga_Z4ZC50DED6*czE3ODAyMjA4ODEkbzEkZzEkdDE3ODAyMjA4ODEkajYwJGwwJGgw*_ga_8KZ8BV0P5W*czE3ODAyMjA4ODEkbzEkZzEkdDE3ODAyMjA4ODEkajYwJGwwJGgw

The option to download the file is paywalled.

Anyway, even if it turns out that this is secure (it won't), it's still
unused code that should be removed anyway.  The fact that it's not up to
modern security standards just provides some additional motivation.

- Eric
