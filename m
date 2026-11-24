Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795551642;
	b=r/YkF/u0+vqzb9aWbr+I7DQqEyJSLavpSm3ZKg0Ify7VKeUzFcRNc6eHI1Rh7fyEbaqq
	 0NLEbBPXvWJ2Kab9HTp+eJux1CPS/Kurs3WiforCvavtKN0s2gCfuEFv+mHp2TsnGVOT/
	 jD3ICf3bF34LaO+x9lvFJzlTInOAVCa/0FiW8mkNxNVh5mC0lSTAHNK8K2+l2Dph4GmBk
	 DiMkSKspMKEqeK+kXqpbmyusRECeOwOM/jrVWbk0TBZw8q8Qigfb3MpHHEUKzn6XcX1u/
	 MUbRW1lcnvuJVwYswZIEfGGxoAuW4wjNcSmiK9ufsO+Yd+lg2bfBbbvm2sn/DOdLGTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795551642;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SuAGoQXREiWQsrWDhfb/EjKtLC4QuRo6T16dlNndy6I=;
	b=pTo3xgeB8GVKMQhND0q3rJsbb52nRGPvR45lnAhBqBCZ5yoNtuJEUdbS/GEmh5ZBpeas
	 btaxfenHwsne0UQqZAZLOeEPhNdtrNBtINGwbkWs7a24S+1SeuawBzxq75LZ/gf3zYGYh
	 sDWB5b17vCjCCDgZGRcDtBepmHIM7TKNmT9w+lciDmpnIpTDIsoGDaQ0VU5HmcakAUQc6
	 copnChX8tDJzzo7Zh12MHqW2HnruaEJj5noUnIcOcHwGoSxx5yXvUq7F7c+GCyw0rybLl
	 WQ66awbX5kJF0KGPvGEcsnM5GI1mzJq/pWwR+p+C7bAdC15XOeZ4VXRXY+ytKwltGNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EpCZT6Ut;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 45C56606A31E;
	Tue, 24 Nov 2026 20:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EpCZT6Ut
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 490221F000C0;
	Tue, 24 Nov 2026 20:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795551641;
	bh=SuAGoQXREiWQsrWDhfb/EjKtLC4QuRo6T16dlNndy6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EpCZT6UtgQ16nWYXI9lVCS80/sTVSKxnfoTlbvkbqsGhTtnxYtUWVkXUyAj4eyB6y
	 7w07w802t/zo9bITY3kwTN40Tb1ksJaWqcwNieak9R4GbzDddzHHBDiSRpFRIbJmOl
	 RarJqc+ZQPNkcFOzQYRfWZz1JpVfhrTeIfXdtLsuSKW+e0zrqmuQYenAYudHyL/aaO
	 qqjcdleA94Qe6kchCVdBrrUSGhH9+Rg7rdplA6AhW3hxKXQnE005Lk0m4QZiU38LRX
	 FO2tnr/1H0FJTVJITAGxajAYKHEbEgAQnRPMnGWRTaEjk0KpoebpnDph+ukQDC1481
	 TQNMSp+jfWv8g==
Date: Tue, 24 Nov 2026 22:20:38 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: dm-devel@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v2 0/9] KEYS: trusted: asymmetric keys
Message-ID: <awXxlkS9vo11BCMo@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
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
In-Reply-To: <20261124194043.1651679-1-jarkko@kernel.org>

On Tue, Nov 24, 2026 at 09:40:34PM +0200, Jarkko Sakkinen wrote:
> OVERVIEW
> ========
> 
> Extend  TPM 2.0 trusted keys to load ASN.1 TPMKey [1] asymmetric keys
> (OID_TPMLoadableKey, 2.23.133.10.1.3) and expose keyctl pkey-operations
> directly on key_type_trusted. In addition there are some TPMKey
> interoperability fixes.
> 
> I.e. this my old series with a twist: instead of introducing a separate
> subtype for asymmetric keys, factor out pkey-operations into a separate
> CONFIG_KEYCTL_PKEY-feature, and wire asymmetric operations to
> key_type_trusted.
> 
> This work was originally derived from [3] and is direct offspring of
> [2].
> 
> [1] https://www.hansenpartnership.com/draft-bottomley-tpm2-keys.html
> [2] https://lore.kernel.org/linux-integrity/20240520184727.22038-1-jarkko@kernel.org/
> [3] https://lore.kernel.org/all/20200518172704.29608-1-prestwoj@gmail.com/
> 
> CHANGES
> =======
> 
> v2:
> - lib/asn1_encoder: Remove unreachable !bytes_len branch in
>   asn1_encode_integer_bytes().
> - tpm: Bounds-check ECC coordinates, defer state updates until after
>   validation, and verify subsequent TPM2_RH_NULL primaries against
>   chip->null_key_name in tpm2_parse_create_primary().
> - trusted: Reject trailing or truncated TPM2B bytes in tpm2_key_decode() so
>   tpm2_load_cmd() and tpm2_asym_load() pass the same blob length.
> - trusted: Avoid 32-bit param_size wraparound in tpm2_asym_rsa_decrypt()
>   and tpm2_asym_parse_signature().
> 
> VERSIONS
> ========
> 
> v1: https://lore.kernel.org/keyrings/20261124120044.1481752-1-jarkko@kernel.org/
> 
> Cc: dm-devel@lists.linux.dev
> Cc: keyrings@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-integrity@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: David Gstir <david@sigma-star.at>
> Cc: David Howells <dhowells@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Ignat Korchagin <ignat@linux.win>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: James Prestwood <prestwoj@gmail.com>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Mimi Zohar <zohar@linux.ibm.com>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Peter Huewe <peterhuewe@gmx.de>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Sumit Garg <sumit.garg@kernel.org>
> 
> Jarkko Sakkinen (9):
>   KEYS: trusted: Allow ASN.1 TPM2 sealed data shorter than MIN_KEY_SIZE
>   lib/asn1_encoder: Add asn1_encode_integer_bytes()
>   tpm: Export tpm2_create_primary()
>   tpm: Add persistent hierarchies to tpm2_create_primary()
>   KEYS: trusted: Extend TPMKey support
>   KEYS: Factor out KEYCTL_PKEY
>   KEYS: trusted: Reject zero-length keys in symmetric consumers
>   KEYS: trusted: Factor out TPM2 blob loading
>   KEYS: trusted: Add asymmetric key support for TPM2
> 
>  .../security/keys/trusted-encrypted.rst       |   25 +-
>  crypto/af_alg.c                               |    2 +
>  crypto/asymmetric_keys/Kconfig                |    1 +
>  drivers/char/tpm/Kconfig                      |    2 +-
>  drivers/char/tpm/tpm2-sessions.c              |  239 +--
>  drivers/md/dm-crypt.c                         |    2 +-
>  include/keys/trusted-type.h                   |    5 +-
>  include/keys/trusted_tpm.h                    |   16 +-
>  include/linux/asn1_encoder.h                  |    3 +
>  include/linux/tpm.h                           |    2 +
>  include/linux/tpm_command.h                   |   13 +
>  lib/asn1_encoder.c                            |   56 +
>  security/keys/Kconfig                         |    3 +
>  security/keys/Makefile                        |    2 +-
>  .../keys/encrypted-keys/masterkey_trusted.c   |    5 +
>  security/keys/internal.h                      |    2 +-
>  security/keys/keyctl.c                        |    2 +-
>  security/keys/trusted-keys/Kconfig            |   10 +
>  security/keys/trusted-keys/tpm2key.asn1       |   19 +
>  security/keys/trusted-keys/trusted_core.c     |   20 +-
>  security/keys/trusted-keys/trusted_tpm1.c     |   26 +
>  security/keys/trusted-keys/trusted_tpm2.c     | 1339 ++++++++++++++++-
>  22 files changed, 1585 insertions(+), 209 deletions(-)
> 
> --
> 2.47.3
> 

"Sashiko has reviewed this 9-patch series and found no issues."

There is not much new code here. The only major change is decoupling
from asymmetric-keys, and thus being able to have just one hardware
backed key type, which I think makes whole a lot of sense.

Br, Jarkko
