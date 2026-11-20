Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168527;
	b=SK5pm4Gbnor08JOknlufSV+hgQY7ejcR+Z/lZj9SfJQgPnT7H+cMzepeSHBj2Nf0iR/0
	 jp1gXR6TPSeSh5un8bmEnvDALCud3o6Fv6Ay2q/+q/TG6bAhJToyFydJV3GHbnxTonAkR
	 BViroZ+3mUb61F1R9bNBxQ4/pK/tto8mFJXxW557Lu1AD3e9PWaSO07uuTuF9g1r+3+Z5
	 GOey0r4p9piPrQ9s2bGRfKRrdaIkE/UneI2n9Wch6lZemVkCyCOC01i7797Wd3V8Reisa
	 uF4J5yLkIxlAjh+vLVin10TnhwJybyQcUsvMDUZruC0BmxcPFUDEe2+FGXtwbpn82Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168527;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=WBq1coYA+tKY6l3zjpWcUqa8zsToSF905MLNKiI0tu4=;
	b=tyMCnQtmzIraSJn2QDToqR7MT/ayBC/qThjwuLSbumJovzs9T5CmFerKJwndCzZ2qCNu
	 0BibGRDGFs+iRJgCliHKrIrxkViDihaD8Tm/MvcsVqAMdrkua2uSyR8YQYsn/qDnW4/Kp
	 1yaMCcFz5MvITbDK/cVl6kai+JXQaIsYCnPAcNQks1W3qiH69B0mTlI3duKfyF/GcdJ9J
	 aM33b7UVN9IkUeQfaYMReEfSg+NRTJypQMpmV5MyMBOC/weAL/slAes0szg3d3brgf/pt
	 CPa1/1FcXJ+Cdpm3ViTciqIVF8ECy4U5vXtshdvYyekFe/cz0Eu9W4j0JIsPyf7+EmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=bfBvu1k0;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66B6606A320;
	Fri, 20 Nov 2026 09:55:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E66B6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=bfBvu1k0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=WBq1coYA+tKY6l3zjpWcUqa8zsToSF905MLNKiI0tu4=; 
	b=bfBvu1k0/EcVedOGEOLD5tB/aKzbSbP5h+6fHhj0F+VmHZJrE8GSoS8aWuTdX5wkxqQfLD8znGo
	x5/AGcio30EQa1hGjQqtLw7KW9IxVhGtCPUke5hpzmvGTox5z6L3bJ0OOYd8rSwowPfrPg7ge8Qu3
	sbwTQtIvhqKHbc/ef2f5ysWxtOAxPnk8qLlKxXbtWdh3gapDOui1ARZxyuvgdriUJf37iTwCVLB2D
	6YroPHtNSbaSVCkjssly1PwTbSYzXGEPecpqbrPnVItMrVFZZCOUvgDOYKC5xRZpFX0UvPpxqO/yZ
	YH9LX9xaKRoZzz5WevuimYby7tf1y1Ot/IAA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULKs-0000000HYka-25SW;
	Fri, 20 Nov 2026 17:55:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:55:14 +0800
Date: Fri, 20 Nov 2026 17:55:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@armlinux.org.uk>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
	Birk Skyum <birk.skyum@pm.me>, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v12 0/2] crypto - qce: make algos optional and remove the
 BROKEN label
Message-ID: <awAZAoNml0wYEiYM@gondor.apana.org.au>
References: <20261112-qce-fixes-broken-label-v12-0-7b5b9c7083ed@oss.qualcomm.com>
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
In-Reply-To: <20261112-qce-fixes-broken-label-v12-0-7b5b9c7083ed@oss.qualcomm.com>

On Thu, Nov 12, 2026 at 02:20:07PM +0100, Bartosz Golaszewski wrote:
> This is the follow-up to the three smaller series fixing crypto
> self-tests in the QCE driver. It makes the crypto algorithms opt-in via
> a module parameter and removes the BROKEN label so that the driver is
> built by default.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
> Changes in v12:
> - Add module description in patch 1/2
> - Drop dependencies from the series as they're all in linux-next now
> - Link to v11: https://patch.msgid.link/20261022-qce-fixes-broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com
> 
> Changes in v11:
> - Split out the patches making algorithms optional and removing the
>   BROKEN Kconfig label into their own series
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
> 
> ---
> Bartosz Golaszewski (2):
>       crypto: qce - Only register algos if the user really wants it
>       Revert "crypto: qce - Mark QCE as BROKEN"
> 
>  arch/arm/configs/multi_v7_defconfig |  1 +
>  arch/arm64/configs/defconfig        |  1 +
>  drivers/crypto/Kconfig              | 22 +++++++++++++---------
>  drivers/crypto/qce/core.c           | 13 ++++++++++---
>  4 files changed, 25 insertions(+), 12 deletions(-)
> ---
> base-commit: aaa2f954c21b205a0bcd0961e5b2be4e82e58455
> change-id: 20261022-qce-fixes-broken-label-e6aaf9624fe9
> 
> Best regards,
> -- 
> Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
