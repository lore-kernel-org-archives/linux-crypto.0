Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A136134EF1F;
	Mon,  1 Jun 2026 06:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780294561; cv=none; b=tBBFrKcG7wXw/gwdh4A0HgD5oHPohcwMo5S8HIXW0Di9T0AQ7wbwWQ0keNxQlwbQnYZDRsYDSINzKwWi/TelEifxtzYTBtUWNqQNhsbADsISbTzCY+UFwLu6Ve31Rti+4uHz2MgdqeDNj/iV83PxPH7UYfckhVhsVpwnga4Mb7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780294561; c=relaxed/simple;
	bh=An+Et4XywLlNvsznQ3jwd4+ap9PkQCqZ45FpI1W5BD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C66dDs2AIzsgEwqn9BZ4c+eZ77W4+GPcUNe0chZB+K8T/72EhLF/d+XP8kV+gPb8VRY5f5WYLy1EiCRGXP8V2ulk9GTOJfoUCW2bB9NyrRfsk4xCUfon1290XcQJoKNoswbByjOoyXn8YdXf/4J7Ej0VCNHi6XkWNEqUB/lrbUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IrosvPTL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IrosvPTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428A11F00893;
	Mon,  1 Jun 2026 06:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780294559;
	bh=0T/O5ac2hSWODWPsOjYTceNCUDT0CjxOn57lFOMJvy8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IrosvPTLz5TNKHQg9SrOHFYIUEU4+CNuKpN58oqtToC2C9CP5BJnu38jSBhmo07R+
	 QwiZguEiaUYDZGI2ZiDtSBuAv/o5EoP3pp39Mth7zXNJUqtiar5/cpPxz7mtQ30UsZ
	 UhimXEPMTAaCEobdMNHB3UN+TPhk57QHxsbmc686Wy1kzcUrAUdnyNMCG/kpVM/eIb
	 1pdgCcQ4dl+d0s8aVvXLKtN8JhpHlk8QHraELxPpdsTxhghqC7rBAqXP3p8Wt2AMpK
	 W1OVknXQrN9/Sp6cPy3ivBtxTexrCRxgzLm4r913/p2+e55NRVOcj0fGByeNDM0CUk
	 VFUnNZPm/RK6A==
Message-ID: <1488f7b3-cda0-4267-827c-fae23b17c1e8@kernel.org>
Date: Mon, 1 Jun 2026 08:15:54 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/29] crypto: talitos - Driver cleanup
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> The Freescale Integrated Security Engine (SEC) aka "Talitos" driver
> implementation is a monolithic ~3800-line file that mixes SEC1 and SEC2
> hardware variants with hash, skcipher, aead and hwrng algorithm.
> 
> This series reorganises the driver to improve readability and
> maintainability.

Did you analyse the cost of this series ? bloat-o-meter gives the 
following result, allthough I'm a bit surprised there are only added 
items, no removed items:

add/remove: 36/0 grow/shrink: 44/0 up/down: 34309/0 (34309)
Function                                     old     new   delta
aead_driver_algs                               -    9280   +9280
hash_driver_algs                               -    5568   +5568
skcipher_driver_algs                           -    3712   +3712
ipsec_esp                                   1552    3088   +1536
ahash_process_req                           1912    3368   +1456
common_nonsnoop.constprop                    884    1704    +820
aead_des3_setkey                             628    1256    +628
ahash_setkey                                 608    1220    +612
ipsec_esp_unmap                              468    1028    +560
sec1_talitos_handle_error                      -     548    +548
aead_setkey                                  460     920    +460
talitos1_interrupt_4ch                      2204    2648    +444
aead_decrypt                                 432     868    +436
free_edesc_list_from                         348     772    +424
sec1_dma_map_request                           -     356    +356
ahash_import                                 352     708    +356
talitos_register_hash                          -     344    +344
skcipher_setkey.isra                           -     336    +336
ahash_export                                 312     628    +316
ahash_init                                   300     604    +304
talitos1_done_4ch                            280     560    +280
common_nonsnoop_unmap                        192     460    +268
talitos_rng_init                             252     504    +252
ipsec_esp_decrypt_swauth_done                236     472    +236
sec1_reset_device                              -     220    +220
talitos_register_aead                          -     208    +208
sec1_reset_channel                             -     208    +208
sec1_talitos_probe_irq                         -     204    +204
talitos1_done_ch0                            196     392    +196
skcipher_encrypt                             164     360    +196
skcipher_decrypt                             164     360    +196
skcipher_des3_setkey                         192     380    +188
ipsec_esp_decrypt_hwauth_done                144     320    +176
ipsec_esp_encrypt_done                       172     344    +172
ahash_digest_sha224_swinit                   172     344    +172
talitos_rng_data_present                     164     328    +164
ahash_init_sha224_swinit                     164     328    +164
aead_encrypt                                 132     296    +164
skcipher_done                                144     292    +148
talitos_register_skcipher                      -     144    +144
skcipher_des_setkey                          140     280    +140
sec1_get_request_hdr                           -     132    +132
sec1_dma_unmap_request                         -     132    +132
crypto_des_verify_key                        132     264    +132
talitos_register_rng                           -     124    +124
sec1_configure_device                          -     108    +108
aead_edesc_alloc                             104     208    +104
skcipher_edesc_alloc                          92     184     +92
ahash_done                                    92     184     +92
skcipher_aes_setkey                           44     120     +76
sec1_search_desc_hdr_in_request                -      76     +76
talitos_unregister_rng                         -      68     +68
talitos_rng_data_read                         64     128     +64
padded_hash                                   64     128     +64
ahash_digest                                  60     120     +60
sec1_init_task                                 -      52     +52
sec1_ops                                       -      40     +40
talitos_register_sec1                          -      32     +32
talitos_cra_init_ahash                        84     108     +24
sec1_ptr_ops                                   -      24     +24
sec1_copy_talitos_ptr                          -      20     +20
talitos_cra_init_skcipher                     76      92     +16
talitos_cra_init_aead                         76      92     +16
sec1_get_ptr                                   -      16     +16
sec1_desc_ops                                  -      16     +16
ahash_update                                  16      32     +16
ahash_finup                                   16      32     +16
ahash_final                                   16      32     +16
sec1_to_talitos_ptr                            -      12     +12
talitos_cra_exit_skcipher                      -       8      +8
talitos_cra_exit_ahash                         -       8      +8
talitos_cra_exit_aead                          -       8      +8
sec1_set_hdr                                   -       8      +8
sec1_get_ptr_value                             -       8      +8
sec1_get_hdr_lo                                -       8      +8
sec1_get_hdr                                   -       8      +8
sec1_from_talitos_ptr_len                      -       8      +8
__already_done                                 2       7      +5
sec1_to_talitos_ptr_ext_set                    -       4      +4
sec1_to_talitos_ptr_ext_or                     -       4      +4
Total: Before=41269, After=75578, chg +83.14%



> One of the main motivation for this series is to eleminate all the
> conditionals around the has_ftr_sec1(). Some checks still remains in
> crypto algorithm implementation at the end of the series.
> 
> Patch 1 adds the CRYPTO_AHASH_ALG_BLOCK_ONLY flag for the ahash
> implementation to eliminate manual partial-block buffering.
> 
> Driver reorganisation (patches 2-9):
> 
>    Move the driver into a dedicated directory, split the different crypto
>    implementation into dedicated translation units.
> 
> Algorithm definition cleanup (patches 10-17):
> 
>    Remove algorithm property mutations from the registration loop, delete
>    the now-unused priority field in struct talitos_alg_template, and
>    convert hash, skcipher and aead to the type-specific init_tfm/exit_tfm
>    API, replacing the deprecated cra_init/cra_exit fields.
> 
>    Use preprocessor macros to deduplicate the hash, skcipher and aead
>    algorithm definitions.
> 
> SEC1/SEC2 ops abstraction (patches 18-27):
> 
>    Introduce struct talitos_ops, split SEC1/SEC2-specific
>    code into separate function variants, and replace runtime is_sec1
>    conditionals with indirect calls through the ops table.
> 
>    Export common channel and error handling routines, and move SEC1 and
>    SEC2 ops into dedicated translation units.
> 
>    Introduce struct talitos_ptr_ops to abstract SEC1/SEC2 pointer
>    helpers behind per-SEC-version ops, then remove the now-unused
>    global pointer helper functions.
> 
>    Introduce per-SEC-version descriptor structures and ops.
> 
> Patch 28 cleans up the includes in the core driver file now that all
> crypto implementation code has been moved out.
> 
> Patch 29 removes a now-useless macro.
> 
> No functional changes are intended for patches 2-29.
> 
> This series depends on the "crypto: talitos - bug fixes" series :
> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpatch.msgid.link%2F20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942%40bootlin.com&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C55c202dc74294a47211f08debc98cf05%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639155561647821924%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=jor10ujpsx58tqxZUNGvDx63lqwVJW5asMdUS8CF1zg%3D&reserved=0
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
> Paul Louvel (29):
>        crypto: talitos/hash - Use CRYPTO_AHASH_BLOCK_ONLY API
>        crypto: talitos - Move driver into dedicated directory
>        crypto: talitos - Add missing includes to driver header file
>        crypto: talitos/hwrng - Move into separate file
>        crypto: talitos - Prepare crypto implementation file splitting
>        crypto: talitos - Introduce registration helper
>        crypto: talitos/hash - Move into separate file
>        crypto: talitos/skcipher - Move into separate file
>        crypto: talitos/aead - Move into separate file
>        crypto: talitos - Remove alg settings in talitos_register_common()
>        crypto: talitos - Remove unused priority field in struct talitos_alg_template
>        crypto: talitos/hash - Convert to init_tfm/exit_tfm type-specific API
>        crypto: talitos/skcipher - Convert to init/exit type-specific API
>        crypto: talitos/aead - Convert to init/exit type-specific API
>        crypto: talitos/hash - Use macro for algorithm definitions
>        crypto: talitos/skcipher - Use macro for algorithm definitions
>        crypto: talitos/aead - Use macro for algorithm definitions
>        crypto: talitos - Split SEC1/SEC2 code into separate function variants
>        crypto: talitos - Introduce struct talitos_ops
>        crypto: talitos - Replace SEC1/SEC2 conditionals with ops dispatch
>        crypto: talitos - Export common channel and error handling routines
>        crypto: talitos - Move SEC1 ops into talitos-sec1.c
>        crypto: talitos - Move SEC2 ops into talitos-sec2.c
>        crypto: talitos - Introduce per-SEC-version pointer helper ops
>        crypto: talitos - Dispatch pointer helpers through ptr_ops
>        crypto: talitos - Remove now-unused global pointer helpers
>        crypto: talitos - Introduce per-SEC-version descriptor structures and ops
>        crypto: talitos - Clean up includes in core driver file
>        crypto: talitos - Remove TALITOS_DESC_SIZE macro
> 
>   drivers/crypto/Kconfig                    |   38 +-
>   drivers/crypto/Makefile                   |    2 +-
>   drivers/crypto/talitos.c                  | 3640 -----------------------------
>   drivers/crypto/talitos/Kconfig            |   36 +
>   drivers/crypto/talitos/Makefile           |    6 +
>   drivers/crypto/talitos/talitos-aead.c     |  677 ++++++
>   drivers/crypto/talitos/talitos-hash.c     |  711 ++++++
>   drivers/crypto/talitos/talitos-rng.c      |   93 +
>   drivers/crypto/talitos/talitos-sec1.c     |  374 +++
>   drivers/crypto/talitos/talitos-sec2.c     |  404 ++++
>   drivers/crypto/talitos/talitos-skcipher.c |  364 +++
>   drivers/crypto/talitos/talitos.c          |  917 ++++++++
>   drivers/crypto/{ => talitos}/talitos.h    |  255 +-
>   13 files changed, 3810 insertions(+), 3707 deletions(-)
> ---
> base-commit: db8b9f227833e729faf44a512aa1e88a625b5ad8
> change-id: 20260518-7-1-rc1_talitos_cleanup-9231a64e29fa
> prerequisite-change-id: 20260504-bootlin_test-7-1-rc1_sec_bugfix-13169ed07ddc:v3
> prerequisite-patch-id: 7b364911e4b8d1c1033eb14e67ed24dac6a4bc13
> prerequisite-patch-id: 2c1cd7fdd003d9a116a697efa25d1716d548389f
> prerequisite-patch-id: b12bdbf565747609e0cfe0609a42cf69b5d816a1
> prerequisite-patch-id: 72cb2bc0fc2a48a5a029b049c199f4c86085cf04
> prerequisite-patch-id: 5f1f5ad6add760161bd48875df48c0893aa12613
> prerequisite-patch-id: 934931086968229434d15a2f2358aeb7e6975a1d
> prerequisite-patch-id: 8a0b4828fc0690e0c841bc9adcc6568bb522e0e8
> prerequisite-patch-id: 1d870f32e7dbf9a8bd3b8979558544107693e0f4
> prerequisite-patch-id: 758c18d7c9fabb14bd90df62e5e8a62a6f880db4
> prerequisite-patch-id: ce6e9e585f8edc1861ae6bb8fbdd836c20cbd290
> prerequisite-patch-id: 9446dc03e442ea81c5f5b39e802e01b37da29971
> 
> Best regards,
> --
> Paul Louvel, Bootlin
> Embedded Linux and Kernel engineering
> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbootlin.com%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C55c202dc74294a47211f08debc98cf05%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639155561647851452%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=orDISoOYFS%2F%2F0ThHpS71R6nscnJxyMar0jASTbsYdG8%3D&reserved=0
> 

