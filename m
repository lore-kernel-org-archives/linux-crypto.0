Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964516;
	b=U0tNDMP4kxEu4FPdXwVPWqERzdjbL95dpE4yaSb6sCgya4UG/WMg3PH1EFZ+O22tc5xH
	 GUqrJqzmYGpa9cD6LX50UxQ1R2J3bXs4XtKBO7yEho5EyaCC8VVekMKOBe/dyTURvsRnF
	 oYKuSz0hB9SR8M688KG0UdXtClChzt9VLmKHPUlstML49vLexffw5ggdfxrwUtB3PQBSw
	 BHli3IgtZwmKZR3V+QN9naNvCZ3dsvUFtmPatFmeD69vwEzvUhsysUS+sTObP1cBeJHww
	 I3l6y3W3kf7KH2RSC/7R+RwqaLKXuhEfgD9y6Bo3hfYD7CYKZ20YMgyfUsbWzYHHPfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964516;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=CIy0lVCVJTm092QOP8ykWpxdfJotD/wijuOAR10N4ZM=;
	b=14uyE7RPHvweVHAh3PKLVEVvu98qhiGTRIq6IveYntRtyKTcCBZWeb4gxe6eSrcP1Rnm
	 VOielU66tHd3Ryx7ZDSPsJbiEirelSEiJ3WeQMjlVSarcJs5uqQnsgRI8HTIFNoLX5Tla
	 Bx7GrmaXWmhRgJCRwnLUNS5wfRyixZcqwsZr9Sh9Wkue21Ol+IZGHPIEYDoV5Dhp7a2L/
	 S+TIB7oeuU91F0lpVr/4Cj1bjuPFKYcRwI4SqKFzfnuGKQjQt0BWRrV8oRmExhhcXiIvF
	 Y4gb+7tBpmiRQoWnaqA5RCMtabPHSbKtEX5ykZ/f64ismuReOrTAbzgDbobicE7zFSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=cTvo9FKB;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B9F606A32E;
	Fri,  6 Nov 2026 11:28:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5B9F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=cTvo9FKB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=CIy0lVCVJTm092QOP8ykWpxdfJotD/wijuOAR10N4ZM=; 
	b=cTvo9FKB5Qy/jdvM3frit45Y30XB0MYV81CeJ7OMzmtpFdgLgEj0NLJTC3QCbRG+RaEwX/IfVt0
	7/AGu/xbaV6JHkUR01JKE058jtOfC86o7U7M2ztn1KE2Izvjn2xXEbUcWnty/S9sag5ydWogwCwwq
	aoqjfazTa8VuACnXx2N/ZzawMACaxn7N+RAVg6lgWaE4uhrBCTmmaGHOzLnVkQ5V52UMxOL9Onuhn
	tDsKNi8SjzErRH7OoLgHoCYBtwfnzijRu7ftDyPpBMFcghAniW6JFJJB+QF3McokcXhE/iX3OQw/e
	Sa6tnV+e1BoxAOfFhmDC40g0+PXSYVtSAC1A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPI7Q-0000000Br5b-1IrV;
	Fri, 06 Nov 2026 19:28:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:28:28 +0800
Date: Fri, 6 Nov 2026 19:28:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Abel Vesa <abelvesa@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Subject: Re: [PATCH] crypto: qce - Fix HMAC self-test failures for empty
 messages
Message-ID: <au253K71iaZeVNth@gondor.apana.org.au>
References: <20261016-qce-fixes-sha-v1-1-3ee5a30d84f3@oss.qualcomm.com>
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
In-Reply-To: <20261016-qce-fixes-sha-v1-1-3ee5a30d84f3@oss.qualcomm.com>

On Fri, Oct 16, 2026 at 04:23:43PM +0200, Bartosz Golaszewski wrote:
> BAM DMA cannot process zero-length transfers, so the driver always holds
> back at least one byte to submit to the engine and only ever finalizes
> with an empty buffer when nothing is left to submit. For plain hashes
> this was handled by returning the precomputed hash of the empty message
> (tmpl->hash_zero), but HMAC's result depends on the key and cannot be
> constant, so hmac(sha256) produced an incorrect digest for an empty
> message and the crypto self-tests failed.
> 
> A zero pending buffer at finalization time does not necessarily mean the
> message itself is empty, though: the caller can also reach it by
> importing a state that already reflects some hashed data with nothing
> currently buffered (crypto_ahash_import() followed directly by
> finalization). Special-casing only a genuinely empty message would
> silently compute the wrong result for an imported state in that
> scenario.
> 
> Handle every zero-length finalization consistently through the software
> fallback ahash instead. When nothing has been processed yet, let the
> fallback compute the result from scratch using the key already propagated
> to it via setkey(). Otherwise, reconstruct the fallback's running hash
> state from the state kept by the driver and finalize from there,
> accounting for the HMAC ipad block that the engine absorbs internally and
> that never goes through update().
> 
> Cc: stable@vger.kernel.org
> Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
> Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
> As requested by Herbert: I've split the large series fixing self tests
> into smaller chunks for easier review.
> ---
> Changes in v12:
> - Split out the SHA patch into its own submission
> - Link to v11: https://patch.msgid.link/20261016-qce-fixes-skcipher-v11-0-d13ddfe609a4@oss.qualcomm.com
> 
> Changes in v11:
> - Split out the skcipher patches into a smaller series for easier review
> - Drop patch "crypto: qce - Fix CTR-AES for partial block requests" as a
>   subsequent commit makes this adjustment effectively dead code
> - Fix a mid-series build failure due to an earlier bad rebase
> - Link to v10: https://patch.msgid.link/20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com
> 
> Changes in v10:
> - don't pass a NULL buffer to sg_init_one()
> - fix byte order of the imported hash state on empty finalization
> - don't recompute the CTR counter in software for every request
> - reject skcipher requests with a too short scatterlist
> - check fragmentation for empty CCM decryption requests too
> - don't use a static loop iterator (duh...)
> - initialize the return value in qce_handle_queue()
> - Link to v9: https://patch.msgid.link/20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com
> 
> Changes in v9:
> - Rebase on top of cryptodev/master
> - Rephrase Kconfig help text changes
> - Link to v8: https://patch.msgid.link/20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com
> 
> Changes in v8:
> - Add a patch making the crypto driver *not* register algos by default
>   but only if the user explicitly requests it with the provided module
>   parameter
> - Use the "offloader" name for the crypto IP instead of "accelerator"
> - Fix device module table issues
> - Make the core driver use a list (despite it only having a single
>   member now) of child auxiliary devices to register to make it clear we
>   have the intention of extending this once we start the work on secure
>   media playback
> - Link to v7: https://patch.msgid.link/20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com
> 
> Changes in v7:
> - Add follow-up changes converting the QCE crypto driver to auxiliary
>   bus, adding the core QCE driver under drivers/soc/ registering the
>   auxiliary device and removing the BROKEN Kconfig label
> - Link to v6: https://patch.msgid.link/20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com
> 
> Changes in v6:
> - Handle all zero-length HMAC finalizations (like imported state with
>   data already hashed), not only the genuinely empty message case
> - Add an additional patch addressing the fragmented skcipher payload
>   issue
> - Link to v5: https://patch.msgid.link/20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com
> 
> Changes in v5:
> - Dropped patch 1/8 that's already queued
> - Use the pre-allocated fallback ahash for HMAC transforms (Herbert)
> - Link to v4: https://patch.msgid.link/20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com
> 
> Changes in v4:
> - Remove remaining ECB and DES3 bits
> - Pick up tags
> - Link to v3: https://patch.msgid.link/20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com
> 
> Changes in v3:
> - Remove even more algorithms and dead code in patch 1/8
> - Link to v2: https://patch.msgid.link/20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com
> 
> Changes in v2:
> - Add fixes for the full suite of crypto self-tests
> - Add Fixes and Cc tags
> - Link to v1: https://patch.msgid.link/20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com/
> ---
>  drivers/crypto/qce/common.h |  1 -
>  drivers/crypto/qce/sha.c    | 62 ++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 47 insertions(+), 16 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
