Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5DC370AE2;
	Fri, 24 Jul 2026 18:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784919079; cv=none; b=AdxuUSnRmhttPH9X41E4s3UDNrjABS28thSiXR1/PLc6JGcvtNGS4+fdxw3AtZuj/txlzc2NcriW6812cFu5ygA/8fFBN/cOwb/9KKeGOV8nX5llY/hyn2+P1Wpc2Y+4BCztAADF2VwTD95u5VKQ3f8qjLqBgo+wFw431LUwWnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784919079; c=relaxed/simple;
	bh=lkN7hay+I1vczjrEXLkKxz1uNe2o8GE8ucy+nvWwyWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HuLfWKfWa5NODdHTdszrWUWd4y85ktetXqqsoAC1AjMR/NEm47AkIVAS73uyDT2U+PHmNhCBO7kB2TBJSjcHuFbbeoDbdqdONk/SGAJBkjGN9tpKrRIMPqy6CBPsYHq7XfQZIHj6zUGNcR9kWaJvO3FhPtEVGrwEaYdj2lw3bEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kEtRoTh0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kEtRoTh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7E91F000E9;
	Fri, 24 Jul 2026 18:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784919078;
	bh=IdjD1flds5kDu/q7Lkb+yYFumSniZ7Q7IdNVS9ov+us=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kEtRoTh002Qnn/EGA0uMsBjficw/FAuJukh8JO70z8iBECDpkIoZAyE2ZqwNNhvjk
	 AxNDbnXrczxHaq6H+nQRC1Xqi0010EHOOOhbTlqEa7RYPbmeTgSsDFdgk7L9vVLrUn
	 iEPCCfn5duv0gcg4/UxoPKTXjh4AJjuRwtZOS9g+cBRo8yCCrC504zbBwnJNfFxjsO
	 R6XaT3DJcwJTpeNnC7TQPrkEF6BEKu4CLszJqeNTA1akHGnMuH8PxkZTMVk8UyLngc
	 TEDC9cHrcLKDpm30y5DPYiyJuvQmg7jUNuHgwoeJaaihi6JkqCDLOR1C1IpS+5tZ/T
	 +fY+BNArsfe4Q==
Date: Fri, 24 Jul 2026 18:51:16 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Hendrik Donner <hd@os-cillation.de>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/2] crypto: pcrypt - Remove pcrypt
Message-ID: <20260724185116.GB1572592@google.com>
References: <20260713223234.24812-1-ebiggers@kernel.org>
 <20260713223234.24812-2-ebiggers@kernel.org>
 <37ecba68-947a-45ad-9ec4-361facc06a05@os-cillation.de>
 <20260721195004.GA3383223@google.com>
 <19613c3e-9756-45fc-84b6-b650ba3723a7@os-cillation.de>
 <20260722194023.GB2118@quark>
 <10430138-05b6-46b8-b9d2-7cad5c371fc4@os-cillation.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10430138-05b6-46b8-b9d2-7cad5c371fc4@os-cillation.de>

On Fri, Jul 24, 2026 at 08:19:02PM +0200, Hendrik Donner wrote:
> 
> so i'm now on 7.1.4 with
> 
>   PCI: imx6: Keep i.MX6 Root Port MSI/MSI-X Capabilities with iMSI-RX to
> work around hardware bug
> 
> on top to be able to tune queue settings. And to have a working ethernet
> in the first place, without the patch the NETDEV WATCHDOG resets the
> card all the time due to queues stalling. But now more than 1 CPU are
> serving IRQs.
> 
> With pcrypt
> (seqiv(rfc4106(pcrypt(gcm_base(ctr-aes-neonbs,ghash-lib))))):
> 
> Upload:
> [  4]   0.00-60.00  sec   901 MBytes   126 Mbits/sec
> 
> Download:
> [  4]   0.00-60.00  sec  1.23 GBytes   177 Mbits/sec
> 
> Without pcrypt
> (seqiv(rfc4106(gcm_base(ctr-aes-neonbs,ghash-lib)))):
> 
> Upload:
> [  4]   0.00-60.00  sec   679 MBytes  94.9 Mbits/sec
> 
> Download:
> [  4]   0.00-60.00  sec   674 MBytes  94.3 Mbits/sec
> 
> So counterintuitively pcrypt matters more again. I repeated the tests a
> few times, those numbers are fairly representative. Every run is over a
> 60 sec window.

Thanks for trying it.  Perhaps this is related to the iperf3 test using
only a single flow?  Does that reflect the real-world case for you?

I'm also curious whether you're particularly attached to AES-GCM, or
whether you've considered switching to ChaCha20Poly1305 which would be
much faster on that CPU.  This could be done either by switching to
"rfc7539esp(chacha20,poly1305)" within IPsec, or by just switching to
WireGuard.

If none of those are options for you and you do want pcrypt to be kept
around, could you confirm that you're solely using 'crconf' (run as
root) to enable it, and in particular you're not relying on the
misfeature of also being able to enable it as an unprivileged user using
AF_ALG?  We can keep it around for a bit longer if really needed, but
the unprivileged stuff definitely has to go.  We should also keep in
mind that pcrypt does not get tested very well (as the crypto self-tests
just test serial use) and historically has had a lot of issues.

- Eric
