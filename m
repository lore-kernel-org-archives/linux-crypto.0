Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794477321;
	b=n57L9AuReUafq5NOnScQJ7vy6/RXJO4c7rIYA1me5qSBNerBHKsuQTdOToEmpwpBVCoE
	 SrT23wZdYSHg885LuFlDiv7/nkAR3qhUA5rZPz1XMPgRCcGDeIbHYkBPXC8zIfrTil9x1
	 ACiJwvsQWvo+qJzZfg3871/ZMecWQllWMQsMW7w+eTr/rlHaC04sdySozocq7V21WbAhB
	 0S1N+nXAZ8/9u82m/LZj0RT+EjORSn6Kop/wwR3gPDNIdNFcn+pEVfPViMU5DGAkvcNp/
	 HLD57qpSOXVST6mSHfHu+GxXi0pufnBN2lrGx8M02EKMGJ8Mhl6qm+jMDdSCNjp1HQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794477321;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=daYdxD4j4VrMaCUKay40VU3EbgYmyzjrfDBHdslgp3M=;
	b=bh4iOP9ebbbCows1MI8jIS5Ro/VY8iAyaJ4/XBY7Zjf2sCvzoZ6lvN7dDiEd6oE6wWTe
	 1YtgoZqc0fEwyr1cCK3wQUE/i/ceZnMBySiTHkpF3sY1lZ11o1T1cPlJk1UQAEfKQvK7T
	 rMsEXnrViHWTrcaGLQ/i02TW8O1smdQHsAHPLYwyGvkRNODlX3DD6bCcQb3g45juhaAM4
	 KgE++ps7KGZBG4sanlf0KqSZSDTPH18HrL3M6Ec6LRXYsilRVb2tXtJ5jif/k9NzdTCKq
	 haG4W4k429lXOzwMfttLrKOktN7v6eR/un+cHzKug9+NNQrpssj2hm9e48xild7+IRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=rjbfADIe;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6465606A31C;
	Thu, 12 Nov 2026 09:55:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6465606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=rjbfADIe
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=daYdxD4j4VrMaCUKay40VU3EbgYmyzjrfDBHdslgp3M=; 
	b=rjbfADIeRC+SXRzNKMV7WfT/TGkkV+2VbFSNJGhDW3wRToHbNxkXvbAONNA79sgzM1ZQODJBUcI
	n3FFHtLoNo75rhAqJ3nF+k2BMJMkIAnNLZ66NV8/CEWznwAZyVwTnn/jClKRbKna1tVb8pQwUMpZ0
	X7Pi6k43LFeSpPC9CQxYOE1KXchpTmnZ4kRKopTHvBpMQTigfWd3Ck5YXmUraSwfljfcuSvHrQhm/
	PKaw/DnDKjAKFSE/9k78XKFA4f3RBLCYsm50qWm6XVe5k3xzZrarRZ/smE9mSQaHVCuCUH7FpIPlL
	MKgY2FkcDqkou4Nve8LoCDomJN4KC8fuFJ+w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRRWL-0000000EDds-3fiC;
	Thu, 12 Nov 2026 17:55:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Nov 2026 17:55:05 +0800
Date: Thu, 12 Nov 2026 17:55:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Erwin Pawliczek <pawliczekerwin@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Lukas Wunner <lukas@wunner.de>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Paul Louvel <paul.louvel@bootlin.com>
Subject: Re: [PATCH] crypto: ecc - Randomize the initial Z in
 ecc_make_pub_key()
Message-ID: <avWM-fsR_sC11zXB@gondor.apana.org.au>
References: <20260928042641.307683-1-pawliczekerwin@gmail.com>
 <20261026034429.742489-1-pawliczekerwin@gmail.com>
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
In-Reply-To: <20261026034429.742489-1-pawliczekerwin@gmail.com>

On Sun, Oct 25, 2026 at 10:44:29PM -0500, Erwin Pawliczek wrote:
> ecc_make_pub_key() calls ecc_point_mult() without an initial Z, so the
> final Z, and therefore the input to vli_mod_inv(), is a deterministic
> function of the private key. vli_mod_inv() is not constant time, so
> key generation leaks information about the private key through its
> running time.
> 
> crypto_ecdh_shared_secret() already passes a random initial Z, which
> blinds the inversion input. Do the same in ecc_make_pub_key().
> 
> Key generation is used in the kernel by Bluetooth SMP and TPM2 HMAC
> sessions, which generate ephemeral P-256 keys.
> 
> crypto_kpp_generate_public_key(), KVM guest on an i7-1165G7 (median
> over 4 boots of the best of 9 runs of 300 calls):
> 
>     P-256:   744.9 us ->  753.2 us (+1.1%; within noise)
>     P-384:  1674.2 us -> 1651.6 us (-1.4%; within noise)
> 
> Suggested-by: Ignat Korchagin <ignat@linux.win>
> Signed-off-by: Erwin Pawliczek <pawliczekerwin@gmail.com>
> ---
> Replaces "crypto: ecc - Use constant-time modular inversion in ecc_point_mult()":
> https://lore.kernel.org/all/20260928042641.307683-1-pawliczekerwin@gmail.com/
> 
>  crypto/ecc.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
