Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795760534;
	b=4jksNADW/9LUA8O4+GgfvuZkrOuNxnhxv+LQHHktZeW8mq31IG4WD11z7XRx18tuJsn9
	 UZVt++SUzXCexigrDqWZFRAWXU+yvYObvDTRYrDDc9UT5tcgIJ832Nyk7K9Tfr5l8A9jQ
	 dtbOoSHFxARvxcHvpxmkZRSHZz77DDOeEHzuHqcIX6EZAVBKNifLUiFM1rQPCGVksc0Dk
	 s9Qb7kEo4sH8B0Ub0YiwYZUBE5dTfOULxqNMq217srby96bcgZpc+TMs1K0voJ5gv4KV7
	 SAvFNKFSsNhnUJ2jlCe4jRVBmap6meoDjqE2PDBi3J99u9gH4n52Yurm8J20yJMQiNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795760534;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=ZMwop0OEMpyal3RAc7tFLnBFdF1UGDC4gKKK5+n2XIY=;
	b=BQurrOzj2sJzPp5f2v8oiVf8DUWGC+hs7Gutw4Guw8L99nl9iC7mxRyV/I9JS9506Sxr
	 hFRg0T5WXmANDkzQO6DGXjNQdFBdyFL3GJrnIUw9SgPOL+e0ESu/aS5iJXDELvMZcGAY1
	 BX+d9Pz5z5cU6+ToEGkIBQ1cHa+m1+sIHdzAZzRTaAjsxMf8ApRK4OIovY8T9Jl2EU+X9
	 C5fzOWhqM2BuVo6yThXqzGORFkLoqKgUtFAV+XuUgup6b438NwGB5JmCORYlPrlB6dWog
	 vjRdLEI7D+svoSq/v5/U5QIh97G/fYcbpDfUcIKkJBo9Rs9nwN1SgNHieLNQLDHU8jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GgckzaFA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CE8D4606A31C;
	Fri, 27 Nov 2026 06:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GgckzaFA
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CE5991F00893;
	Fri, 27 Nov 2026 06:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795760534;
	bh=ZMwop0OEMpyal3RAc7tFLnBFdF1UGDC4gKKK5+n2XIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GgckzaFAspuAAlHJ4238QvFssP0pA8oSbPk/bpGIaGb9NunqeDWyFrKx+FnfmoImY
	 Ae6B3iaFl63J9CFPOxXzE7TF0yymkmtsbVWHx541J1K3bs1YjjD0TmEr60dI0ZHMg5
	 53SWmhzSVBbSWWb9fP0PG1NkklJgAQOf+LA2k0lF2BmtyiTruGHxe1jXKfR64Xv8Hu
	 6ekVfz280AMLR3vQoMW7rHKLUtCQP48HqMEHB4lRlZN8vk1Koonh7belp2iGfZ0yUF
	 1K1+Mv63DoF3AyguSlX/wg3VaG9jtEP3WtZsQsGo3jOACy196K94lfZhILGMmUENRO
	 lEPbOvNRhx9gQ==
Date: Fri, 27 Nov 2026 08:22:10 +0200
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
	David Laight <david.laight.linux@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Jonathan McDowell <noodles@meta.com>,
	Lukas Wunner <lukas@wunner.de>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v5 00/17] KEYS: trusted: asymmetric keys
Message-ID: <awkhklUCPgE2GYMh@kernel.org>
References: <20261127055602.2357884-1-jarkko@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261127055602.2357884-1-jarkko@kernel.org>

On Fri, Nov 27, 2026 at 07:55:45AM +0200, Jarkko Sakkinen wrote:
> OVERVIEW
> ========
> 
> Extend TPM 2.0 trusted keys to load ASN.1 TPMKey [1] asymmetric keys
> (OID_TPMLoadableKey, 2.23.133.10.1.3) and expose keyctl pkey-operations
> directly on key_type_trusted. In addition there are some TPMKey
> interoperability fixes.
> 
> I.e. this my old series with a twist: instead of introducing a separate
> subtype for asymmetric keys, factor out pkey-operations into a separate
> CONFIG_KEYCTL_PKEY-feature, and wire asymmetric operations to
> key_type_trusted.
> 
> This work was originally derived from [3], is direct offspring of [2],
> and folds in the prerequisite tpm2-sessions and tpm-buf cleanups from
> [4].
> 
> [1] https://www.hansenpartnership.com/draft-bottomley-tpm2-keys.html
> [2] https://lore.kernel.org/linux-integrity/20240520184727.22038-1-jarkko@kernel.org/
> [3] https://lore.kernel.org/all/20200518172704.29608-1-prestwoj@gmail.com/
> [4] https://lore.kernel.org/linux-integrity/20261116005105.1573016-1-jarkko@kernel.org/
> 
> CHANGES
> =======
> 
> v5:
> - tpm / trusted: Fold in the tpm2-sessions and fallible tpm_buf_read*()
>   patches [4] (adding Jonathan McDowell's Reviewed-by to "tpm2-sessions:
>   Drop TPM2_NAME_SIZE"), resolve handle names with tpm2_read_public(),
>   and replace the custom tpm2_read_*() / tpm2_skip_bytes() helpers with
>   tpm_buf_read_u{16,32}() in tpm2_asym_parse_*_public().
> - trusted: Split "KEYS: trusted: Add asymmetric key support for TPM2"
>   into a framework patch ("KEYS: trusted: Add asymmetric key
>   operations", adding optional asym_* callbacks on struct
>   trusted_key_ops and HAVE_TRUSTED_KEYS_ASYMMETRIC) and the TPM2 backend
>   patch.
> - trusted: Move "KEYS: trusted: Validate public_len before reading key
>   attributes" to patch 01/17 and add the Fixes tag for e5fb5d2c5a03.
> 
> v4:
> - KEYS: Turn CONFIG_KEYCTL_PKEY into a hidden helper symbol selected per
>   subsystem: add off-by-default CONFIG_ASYMMETRIC_KEY_PKEY for software
>   asymmetric keys, and switch TURRIS_SIGNING_KEY,
>   TURRIS_OMNIA_MCU_KEYCTL, and TURRIS_MOX_RWTM_KEYCTL from
>   CONFIG_ASYMMETRIC_KEY_TYPE to CONFIG_KEYCTL_PKEY (remaining default y).
> - trusted: Default CONFIG_TRUSTED_KEYS_ASYMMETRIC to y and select
>   CONFIG_KEYCTL_PKEY.
> - trusted: Split "KEYS: trusted: Factor out TPM2 blob loading" into
>   separate patches for public_len bounds checking, the private backend
>   pointer in trusted_key_payload, and TPM2 blob loading.
> 
> v3:
> - KEYS: Move CONFIG_KEYCTL_PKEY factoring to the beginning of the series
>   and make it an off-by-default prompt instead of selecting it from
>   CONFIG_ASYMMETRIC_KEY_TYPE.
> - trusted: Make CONFIG_TRUSTED_KEYS_ASYMMETRIC depend on
>   CONFIG_KEYCTL_PKEY instead of selecting it.
> - trusted: Use unsigned int instead of u16 for data_len and min_len in
>   tpm2_unseal_cmd().
> - asn1: The reason for not supporting implicit tags was that it follows
>   what other functions do in asn1_encoder.c, and is that way coherent.
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
> v4: https://lore.kernel.org/keyrings/20261126205021.2200819-1-jarkko@kernel.org/
> v3: https://lore.kernel.org/keyrings/20261125180616.1854753-1-jarkko@kernel.org/
> v2: https://lore.kernel.org/keyrings/20261124194043.1651679-1-jarkko@kernel.org/
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
> Cc: David Laight <david.laight.linux@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Ignat Korchagin <ignat@linux.win>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: James Prestwood <prestwoj@gmail.com>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Jonathan McDowell <noodles@meta.com>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Marek Behún <kabel@kernel.org>
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
> Jarkko Sakkinen (17):
>   KEYS: trusted: Validate public_len before reading key attributes
>   KEYS: Factor out KEYCTL_PKEY
>   tpm2-sessions: Drop TPM2_NAME_SIZE
>   KEYS: trusted: Open code tpm2_buf_append_auth()
>   KEYS: trusted: Remove dead branch from tpm2_unseal_cmd
>   tpm2-sessions: Re-orchestrate tpm2_read_public() use
>   tpm-buf: Make tpm_buf_read*() fallible
>   KEYS: trusted: Allow ASN.1 TPM2 sealed data shorter than MIN_KEY_SIZE
>   lib/asn1_encoder: Add asn1_encode_integer_bytes()
>   tpm: Export tpm2_create_primary()
>   tpm: Add persistent hierarchies to tpm2_create_primary()
>   KEYS: trusted: Extend TPMKey support
>   KEYS: trusted: Reject zero-length keys in symmetric consumers
>   KEYS: trusted: Add private backend data to trusted_key_payload
>   KEYS: trusted: Factor out TPM2 blob loading
>   KEYS: trusted: Add asymmetric key operations
>   KEYS: trusted: Add asymmetric key support for TPM2
> 
>  .../security/keys/trusted-encrypted.rst       |   25 +-
>  crypto/af_alg.c                               |    2 +
>  crypto/asymmetric_keys/Kconfig                |   11 +
>  crypto/asymmetric_keys/asymmetric_keys.h      |    2 +
>  crypto/asymmetric_keys/asymmetric_type.c      |    4 +
>  drivers/char/tpm/Kconfig                      |    2 +-
>  drivers/char/tpm/tpm-buf.c                    |   56 +-
>  drivers/char/tpm/tpm-sysfs.c                  |    2 +-
>  drivers/char/tpm/tpm2-cmd.c                   |    9 +-
>  drivers/char/tpm/tpm2-sessions.c              |  524 ++++---
>  drivers/firmware/Kconfig                      |    1 -
>  drivers/md/dm-crypt.c                         |    2 +-
>  drivers/platform/cznic/Kconfig                |    3 +-
>  include/keys/trusted-type.h                   |   19 +-
>  include/keys/trusted_tpm.h                    |   18 +-
>  include/linux/asn1_encoder.h                  |    3 +
>  include/linux/tpm.h                           |   20 +-
>  include/linux/tpm_buf.h                       |    6 +-
>  include/linux/tpm_command.h                   |   13 +
>  lib/asn1_encoder.c                            |   56 +
>  security/keys/Kconfig                         |    3 +
>  security/keys/Makefile                        |    2 +-
>  .../keys/encrypted-keys/masterkey_trusted.c   |    5 +
>  security/keys/internal.h                      |    2 +-
>  security/keys/keyctl.c                        |    2 +-
>  security/keys/trusted-keys/Kconfig            |   15 +
>  security/keys/trusted-keys/tpm2key.asn1       |   19 +
>  security/keys/trusted-keys/trusted_core.c     |  103 +-
>  security/keys/trusted-keys/trusted_tpm1.c     |   24 +
>  security/keys/trusted-keys/trusted_tpm2.c     | 1329 +++++++++++++++--
>  30 files changed, 1872 insertions(+), 410 deletions(-)
> 
> -- 
> 2.47.3
> 

Surprsingly after rebase and splitting asymmetric operations to their
own patch Sashiko found nothing to complain about.

Most of the stuff is number of years old just piggybacked into this
huge patch set.

Br, Jarkko
