Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395470;
	b=Ak28A59ZY293JNBdo/RVqnSCPMitqOOkrImleOivf+iFr3Ev8o/3g7zc6xCYpcavZp3+
	 ggHvNzmY4etcbukhU7foSGikVChjjYuWXt2qB+1uqS55YW2y0x1PEh7Hz9mRJTqnPH2vA
	 Rpii1kjYKTGpz6aezneQijzRQpbQWkv3fGI0lXfA5iPYmtcxWqjqHoLTO4xARf5t/QvGP
	 3stNS3DFecS51/s8PfB9KTFGFf9VJPln3R73A/G+an0GYfEBZYTV2Q2CharCUxfku5VhM
	 UxexNyICFqW6tL7UHqFy+p7NhIIriWLA22v8Kx305QQ+uHi2fW/OSw8t1D9CIac2cbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395470;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Wqf670lVRIqkSlXkc/j0Hs3DDZypkVmJhCP0wEC28B8=;
	b=QQEbblUfkc8XGp4olvO7V3seu/TllyeamQzP7CUrVjYuoDX24tSrZAzfsSAryNU0mPdu
	 uun7T18hKRNidsgYEEXx0o4biCVJm/jRzmNwx7hvvl1ChgulrHKKpVWV8/4FkTHFD5Jt4
	 A+5d2kq2ITNX4FWTrGJ5YbIq6fVYYZSlqducihv8H2HQ7qCnnaG0qowtv8ErHY2qGYZYZ
	 BoTvb7pQdiOUnwIoF4R7y8b94qoe2CUifFEHE1Y04PEk+mSEnEiURc4QF8SqoC/1DqeKZ
	 qe27c8lEGTWANu9so/D07IEdXuq/TTXIxpNzX1wuQ9wwNnwS8/gJsF54kc2vxzCWK7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=OEHFVsDd;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67525606A32E;
	Wed, 11 Nov 2026 11:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67525606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=OEHFVsDd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Wqf670lVRIqkSlXkc/j0Hs3DDZypkVmJhCP0wEC28B8=; 
	b=OEHFVsDdXtsM4pU2FvmQHtHOH51IpmoKSRBy1vWyxbsZMT3R4KbiFcEzULHteifp3rB35e2F7/H
	qQJfhosuWbVI51TWDfsflOrn/c9wBanTDe0ipURHOK+Y4epyY2l5pcpJ3Wi2SAJbuqi96cKEVS5of
	YjTOBeZLf7UAh9xKlvC8F/qAsOU2eq/rsJvJlnaURTcAQLUwi7L9YBbkl7lurLKCofj7K3xXgiIib
	e0RKiiFQJhjPYkN2y03VGAu6FCk+zcajXQ+8KhLpt/8p6+DpOwUxUJ2KtJTHk4AXaAT9mXEg/Y3d/
	7/0YKCOLJgdZdDD321Fnv/CNk3gxjVKdQ6xw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR6EM-0000000DmQ4-297H;
	Wed, 11 Nov 2026 19:11:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 19:11:06 +0800
Date: Wed, 11 Nov 2026 19:11:06 +0800
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
Subject: Re: [PATCH v12 0/3] crypto - qce: fix self-test issues in aead
Message-ID: <avRNSjAu-KDqJHSw@gondor.apana.org.au>
References: <20261020-qce-fixes-aead-v12-0-77a2e09abd0c@oss.qualcomm.com>
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
In-Reply-To: <20261020-qce-fixes-aead-v12-0-77a2e09abd0c@oss.qualcomm.com>

On Tue, Oct 20, 2026 at 02:47:00PM +0200, Bartosz Golaszewski wrote:
> As requested by Herbert: this is the aead part of the QCE fixes sent
> separately for easier review.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
> Changes in v12:
> - clear the ctx->need_fallback flag for key sizes other than AES-192
>   (sashiko)
> - Link to v11: https://patch.msgid.link/20261019-qce-fixes-aead-v11-0-11c55cc7a695@oss.qualcomm.com
> 
> Changes in v11:
> - Split out the aead patches into a smaller series for easier review
> - add a patch fixing a race condition resulting from sharing
>   ctx->eed_fallback by concurrent requests
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
> Bartosz Golaszewski (3):
>       crypto: qce - Don't modify the TFM context for per-request fallback
>       crypto: qce - Use a fallback for CCM with a partial final block
>       crypto: qce - Use fallback for CCM with a fragmented payload
> 
>  drivers/crypto/qce/aead.c | 46 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 36 insertions(+), 10 deletions(-)
> ---
> base-commit: 0aac16003b01b9282491ea3d454697c2dc7e8c78
> change-id: 20261019-qce-fixes-aead-e229fa2015e3
> 
> Best regards,
> -- 
> Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
