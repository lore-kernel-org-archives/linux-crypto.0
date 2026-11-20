Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168401;
	b=FgYWerVO++wph08bcDCogRqJ3BQnrG7gdsBjdg0qC7xJ7Xe4Z3ZL+sPQ6cj9Xf3y9Z+r
	 Q0AO6g1vZ2i1+D2JtT0kmKnnO96dTW4e6K/IDiBozj4quIt8qQyVnVkyCIc0gOKGYezLr
	 9W7FDAAWoc9hXaRQyIiYsnjAxMsfe9H3YNzjOwLqZc2oe5tnIo5dl0MMKeUgEHvaYE2yL
	 CPeR3KSvyUIBi2V57T79Vl0wjiUSzaQ/z6iVTzJFfmJUY+xN6eOqdr8a0yQsMj2fH8SRZ
	 yeXtwtkugmfeo6Q9HeVTmFRT7FWOVFIqJYTQDRpPw9NWNZtTDQPXyeVyuYudiPh6wmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168401;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Xe8p+THTYE4R8n1uVUz1iWDTmEZ3tmdAF0ebwBSOgfw=;
	b=TR9woCJ4ktQ6BodRDq584qClGWdKM1/n958ZjAwnEm51P1CPsFi92LT+GkLmUwkv7nhG
	 BQC5Lvyb0w22SsGK3rNKOJqbTuPy0WotHtXH2jzxNWSdSZ6+YLtr40cO1kmV9hwIs3qZ8
	 2CGprIGMGUHsnSFd3jF5uy96uKdJXfJZTYTXigSnEgujEXmRn+Igd+fhGZkp5jUw64uyT
	 xcp4K8j0po2asVs3+mPUhDEWcIhF5e48kKcSxDBH2sz1w5khgx64LW55yPs0CBvOvtpO5
	 S+kgCuqIBhJhHRR4K4jFBn5zUIQRg2XScPCY4Xwm6vC/ttc2rDlENEVlb6fmycet4cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=hTrz9Krg;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10744606A320;
	Fri, 20 Nov 2026 09:53:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10744606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=hTrz9Krg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Xe8p+THTYE4R8n1uVUz1iWDTmEZ3tmdAF0ebwBSOgfw=; 
	b=hTrz9KrgpDaiAVrfJPYS74R3P7nOtGsDDHNIRZdiBRVLXTLEb10o75G2EaIvr1V7qUxfxjlXyTP
	JYGqVgqbJtg8VZA8rgjnPRAZV2K/hl/z5XTRkkJOj364XbDwBgs23g/pay4bRO80kiIUwYOsfI2Kp
	Iish9buLdN/9Xj6yAn7YQUtSAHLGQQSLwCRho2deQQzXNQmjT+D+GH+d3jSZ9w68xhZBsKRMLcocE
	sm2/SYiHDq4PmBS6SoIziRWuQdm+HZwn87Ss8nLGiJ6XsniGtr8La//4dZDF8du8tZEg4fgf67bg8
	5X4W7HtdnbPcJeDpbat4pmNTM92aZwI3/OZg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULId-0000000HYfF-15ek;
	Fri, 20 Nov 2026 17:52:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:52:55 +0800
Date: Fri, 20 Nov 2026 17:52:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: florian.bauckholt@cispa.de
Cc: David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] KEYS: asymmetric: Fix PKCS#1 decryption of an empty
 message
Message-ID: <awAYd8Gsf5sjgH7q@gondor.apana.org.au>
References: <20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de>
 <20261111-keyctl-pkey-fixes-v1-2-934ebaa267a7@cispa.de>
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
In-Reply-To: <20261111-keyctl-pkey-fixes-v1-2-934ebaa267a7@cispa.de>

On Wed, Nov 11, 2026 at 04:56:08PM +0100, Florian Bauckholt via B4 Relay wrote:
> From: Florian Bauckholt <florian.bauckholt@cispa.de>
> 
> KEYCTL_PKEY_DECRYPT with enc=pkcs1 on a valid ciphertext of an empty
> message returns the key size instead of 0, and the output buffer is
> filled with the ciphertext.
> 
> crypto_akcipher_sync_encrypt() returns 0 on success, so
> software_key_eds_op() maps a result of 0 to crypto_akcipher_maxsize().
> The mapping is applied to decryption as well, but
> crypto_akcipher_sync_decrypt() returns the length of the plaintext,
> which is 0 for an empty message. By then crypto_akcipher_sync_post()
> has copied its scratch buffer to the output. pkcs1pad copied nothing
> into that buffer, so it still holds the ciphertext.
> 
> Only the caller's own input is returned, so nothing is disclosed, and
> messages that are not empty are decrypted correctly. An empty message
> is valid, though: RFC 8017 section 7.2 only limits the message length
> to k - 11 octets.
> 
> Apply the mapping to encryption only.
> 
> Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without scatterlists")
> Cc: stable@vger.kernel.org # v6.5+
> Link: https://lore.kernel.org/all/20260919221742.3709658-1-benquike@gmail.com/
> Signed-off-by: Florian Bauckholt <florian.bauckholt@cispa.de>
> ---
>  crypto/asymmetric_keys/public_key.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
