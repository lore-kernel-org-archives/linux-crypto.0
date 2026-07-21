Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892E73793CA;
	Tue, 21 Jul 2026 13:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642074; cv=none; b=H1I9+z48iQvIociAFwMpNe99Ig++pM79fi4ZKlCLE8PfZh/T1ZocbRAce/y8L36h2coyVnPmMtZTuzT48ox2blVHU5YPDU6DKWo4FdgAcnugWqPhqblyQ/7Mnz88wTewFFLkTYIpgBjXmlOOj0O0639KsY+Fji/C/g8RlrOt+tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642074; c=relaxed/simple;
	bh=KuIR2OSYWi7Ee3W0VJNUoIjsKfYpstGhIn43+Gk8aRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MPvJVFCuhXMAtP4HWVSPga4hBHDK6F+NN9Y5oyVumG+076DBWMRrNk4v5zcZyYjhX6RMAe+n587KA0gPtm8fY8AWFM3VSeH1uO08J7bI5374ePoqp7CwDKdTpf8s5eV4Ndj8AXcKkW7QoHVdc828P+lCsgr5hdYgdlNxklHzBLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=hiHcM4I2; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="hiHcM4I2"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id DEEB84E40EA3;
	Tue, 21 Jul 2026 13:54:29 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id B2F8060368;
	Tue, 21 Jul 2026 13:54:29 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3D30411BD0B36;
	Tue, 21 Jul 2026 15:54:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784642069; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=YMlyzCE9U4b2/JDvprzsZg5b/5Vp40jiMB5uvXtd9ng=;
	b=hiHcM4I2jsCkDbTZ5BwsiVa+5O8vm3IZbQq6QDRo2YdpWYtWgLK7W53NWcmaFo0MtE715O
	NIht5PIgmIYt/HmrDRxNO5OXAe1N8DI/KoBZ0jCX3hftKCu/5e3PBIXZys7cjBDFifuyt2
	m0HdCzfn7hZYs1ZkeEBk3ur2Z5CsnHI3FFsA+silFb1Vq9k67cEhFH+DVzTxnWOExIyA/Z
	4woFAgcIFHKshuu7uWbe3ezSg4JzlLZd33YVRQKETZZtvdE4H+tuUAxlXifIwGKpM9BoOf
	YM79sa4alkk/3Cwe0KLwogOvs3Ae4sKtC8dJ2iNvoqaaaMOkWwUNyJFJoJmxQA==
Message-ID: <291e6fd8-e96a-40da-8542-762365bd55af@bootlin.com>
Date: Tue, 21 Jul 2026 15:54:26 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/19] crypto: talitos - Driver cleanup
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>,
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-6e94359bf72d@bootlin.com>
Content-Language: en-US
From: Paul Louvel <paul.louvel@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-6e94359bf72d@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hi,

Sorry, I forgot to write and close by cover letter before sending it --'

On 7/21/26 3:40 PM, Paul Louvel wrote:
> The Freescale Integrated Security Engine (SEC) aka "Talitos" driver
> implementation is a monolithic ~3800-line file that mixes SEC1 and SEC2
> hardware variants with hash, skcipher, aead and hwrng algorithm.
>
> This series reorganises the driver to improve readability and
> maintainability:
>
> - Split the driver into a dedicated directory with separate files for
>    hash, skcipher, aead, and hwrng implementations.
>
> - Modernise the crypto API usage: adopt {init,exit}_tfm (deprecated
>    cra_init/cra_exit), use CRYPTO_AHASH_ALG_BLOCK_ONLY to eliminate
>    manual partial-block buffering, and use macros to deduplicate
>    algorithm definitions.
>
> - Introduce a is_sec1() helper to get rid of is_sec1 variables /
>    parameters.
>
> - Define descriptor/pointer structures for each hardware version,
>    instead of using a single structure and anonymous union.
>
> No functional changes are intended except for patch 1.
>
> This series depends on the "crypto: talitos - bug fixes" series :
> https://patch.msgid.link/20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com
>
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
> Changes in v3:
> - EDITME: describe what is new in this series revision.
> - EDITME: use bulletpoints and terse descriptions.
> - Link to v2: https://patch.msgid.link/20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com
>
> Changes in v2:
> - Fixed compilation warnings and errors.
> - Instead of using ops to dispatch SEC1/SEC2 variants, keep the small
>    helpers, and introduce is_sec1() inline function that can use static
>    key branching in case both hardware version are compiled.
> - Dropped the SEC1/SEC2 function variants inside the core driver file.
> - Reworded the cover letter for clarity.
> - Link to v1: https://patch.msgid.link/20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com
>
> To: Herbert Xu <herbert@gondor.apana.org.au>
> To: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> ---
> Paul Louvel (19):
>        crypto: talitos/hash - Use CRYPTO_AHASH_BLOCK_ONLY API
>        crypto: talitos - Move driver into dedicated directory
>        crypto: talitos - Add missing includes to driver header file
>        crypto: talitos/hwrng - Move into separate file
>        crypto: talitos - Prepare crypto implementation file splitting
>        crypto: talitos/hash - Move into separate file
>        crypto: talitos/skcipher - Move into separate file
>        crypto: talitos/aead - Move into separate file
>        crypto: talitos/hash - Convert to {init,exit}_tfm type-specific API
>        crypto: talitos/skcipher - Convert to {init,exit}_tfm type-specific API
>        crypto: talitos/aead - Convert to {init,exit}_tfm type-specific API
>        crypto: talitos/hash - Use macro for algorithm definitions
>        crypto: talitos/skcipher - Use macro for algorithm definitions
>        crypto: talitos/aead - Use macro for algorithm definitions
>        crypto: talitos - Remove alg settings in talitos_register_common()
>        crypto: talitos - Introduce is_sec1() helper with static key support
>        crypto: talitos - Replace has_ftr_sec1() with is_sec1() static key helper
>        crypto: talitos - Introduce per-SEC-version descriptor and pointer structures
>        crypto: talitos - Remove TALITOS_DESC_SIZE macro
>
>   drivers/crypto/Kconfig                    |   38 +-
>   drivers/crypto/Makefile                   |    2 +-
>   drivers/crypto/talitos.c                  | 3640 -----------------------------
>   drivers/crypto/talitos/Kconfig            |   36 +
>   drivers/crypto/talitos/Makefile           |    3 +
>   drivers/crypto/talitos/talitos-aead.c     |  657 ++++++
>   drivers/crypto/talitos/talitos-hash.c     |  695 ++++++
>   drivers/crypto/talitos/talitos-rng.c      |   93 +
>   drivers/crypto/talitos/talitos-skcipher.c |  356 +++
>   drivers/crypto/talitos/talitos.c          | 1337 +++++++++++
>   drivers/crypto/{ => talitos}/talitos.h    |  316 ++-
>   11 files changed, 3467 insertions(+), 3706 deletions(-)
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
> https://bootlin.com
>
-- 
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

