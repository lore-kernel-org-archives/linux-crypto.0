Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756535;
	b=NTYLnOZEOevgWSsS4Bx7NK3w53uUENnmgRMWb45ehZ6gtcqKJumkRPiQSHfECGpCB4NA
	 qt646GNg1ZUiSHLkpGp8wjgXxOfoJIAjm9MINnRP4TnxUzgNTucd3ypT7CDrspqsyH71N
	 60OyHulZpuc0FZqoyNtU8Vvo3Ci5wNZCqftrTMSdEt8WMVZADHfcsQaT98Q8LZpaOxGol
	 mtgkTuk01eF2jKix2fPsYJ6UG3EFV0blITCEYvLcu1ovKVsbdmUvsl4iXZ8Ta8tUz0UJQ
	 TfrSUQ9Khhz0gGSaApp6WelkNHC1HkvCUtRuV4nZ30Z1kpdEpvVo8WU/9pHiJhYj84A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756535;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=vSQw0tXm6EOBMEdw8HTkWdIkd+IFqukqq1+LECzKtek=;
	b=AYYmopk7uEcTQ1qjKsiPFxXC8YDCMAEHiPlK6HDXT9hjthfUQuZnf5mUgtkPGHD8CT2g
	 KciHHu5+BTycHzEE/OCn7Q4XD58hFhDi08cJCSAmXE5mAO0zDPqaNQFzu0lC+powCYx6g
	 ZVtdCGW5h4QQ/AQZs3HnimgrsYiLG2/Y0onNrP4aCvaqfmE8Ua21txvodnjB0liaChwk1
	 dx1FIkGY//PmbHmKm6eMtuHl6b2KGg5xkEhXQPDpUTChchbepHdmf0fi50NCmgmnLWUCd
	 8C3XBTOdzcCwE0UK9REbyHjyIw49SH1rWhbsN68Lc8MaKhvP5hN6OdcvVkBSF1UTnJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=bJ8XuwB9;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4895A606A31C;
	Fri, 27 Nov 2026 05:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4895A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=bJ8XuwB9
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=vSQw0tXm6EOBMEdw8HTkWdIkd+IFqukqq1+LECzKtek=; 
	b=bJ8XuwB92RigT5KWxwn4TkU7SRThrvWvSF89w8wkMAm/BknRJnB2jktc0xxGTHp0fyAOxRH6COL
	GVwclTp0Jn1v9ovcIWacKDOUbfkQuY0n/rcOw+L+BlpOOU1TMYsdlwaYCVqM56LVqvWHneT8kmjyz
	I3QsmWyX0a+IqRpvqTLqzG81VXXOnLOOtm/XyIBmNQdnY9lW3malbD9yWi/kO3syw7x3oCZqioHhc
	QkNSrtpodewVrXpYhOApRzKNv0j6kdn14jUUa34/H3fqIffkYH3SqIfbvHC26JCbSJSPE6iIgUqEx
	kgBI72wF1x268y9j/QjBSgoaUcq3Wp6FoJIg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoJ1-00000002VVk-0ICQ;
	Fri, 27 Nov 2026 13:15:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:15:31 +0800
Date: Fri, 27 Nov 2026 13:15:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	"David S. Miller" <davem@davemloft.net>, kernel@puri.sm,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - handle empty message in ahash_finup_first
Message-ID: <awkR86kDmeYENeva@gondor.apana.org.au>
References: <20261120-caam-empty-v1-1-d82106209428@puri.sm>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-caam-empty-v1-1-d82106209428@puri.sm>

On Fri, Nov 20, 2026 at 12:59:57AM +0100, Sebastian Krzyszkowiak wrote:
> Since commit 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in API"),
> crypto_ahash_final calls crypto_ahash_finup with req->nbytes == 0.
> This leads to an oops on an empty message to hash when ahash_edesc_add_src
> calls sg_dma_address(req->src) if the caller passes NULL as req->src:
> 
>     Unable to handle kernel NULL pointer dereference at virtual
>     address 0000000000000010
>     Call trace:
>      ahash_edesc_add_src+0x40/0x390 (P)
>      ahash_digest+0xcc/0x250
>      ahash_finup_first+0x18/0x30
>      ahash_finup+0x24/0x38
>      ahash_do_req_chain+0xc0/0x1b0
>      crypto_ahash_finup+0x168/0x200
>      hash_recvmsg+0xb0/0x1f0 [algif_hash]
> 
> It can be reproduced on i.MX 8M Quad with the following Python snippet:
> 
>     import socket
>     s = socket.socket(socket.AF_ALG, socket.SOCK_SEQPACKET, 0)
>     s.bind(("hash", "sha256"))
>     op, _ = s.accept()
>     print(op.recv(32).hex())
> 
> The oops was observed being triggered by iwd.
> 
> ahash_finup_first runs only when nothing has been hashed yet, so handle
> the empty-message case by routing it to ahash_final_no_ctx.
> 
> Fixes: 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> ---
>  drivers/crypto/caam/caamalg_qi2.c | 3 +++
>  drivers/crypto/caam/caamhash.c    | 3 +++
>  2 files changed, 6 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
