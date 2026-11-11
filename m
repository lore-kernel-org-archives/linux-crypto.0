Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395416;
	b=BfxsKPBSF/GpUDlrKym13cWWX3aoeX1HaNRlPNFcbOA0rbB+TFwzuw/BCEFm9Mn4xoaG
	 5dHr/AuB+VVsSjuSq564mq9558YXXgF7HhMD6RHdIPdqlLl6GZp5JN1l1reVPeeGxw/Ke
	 s5IfjqSMCCl9bvUJVBh6es9XHyAXDNm6lpCrx/+nSMOARLShRA1jpCHQ12tbePcQw7vSX
	 rnFTKOEdhwU/S+RMWXSTLID8oDtePccck4TJYa9mNmsv4k3fi9Jk6eZ9vi+kv9jHgKxfW
	 w4NzGwt2MTb01C9uWgC3ttfGQuME6ZjMKR0dD1BdY+YFZfs4kOrYCDBHqGFKc1VNfyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395416;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=W4Zd/TWVFnT//vb4/FFMwAQIXVyfGZrnD6iu7ob72UI=;
	b=hMNfgwYdV/syULWug1rshRpXIQg7b5GKe8i8Q8p+9wEy7bvvREDRp8UMS80wpgb6P4dL
	 K9HA7Xc9x5N6IHhdd0ZRwL9EZyh1S6zKhjL114LLvkxrswFGrlxNofE2OogNwNl2iurOd
	 avNViRabyVSn8sv+e2sm53+m4vt/HVPlt7AOgjlvERdsbnmaDqTG03D54qHD+SUXidh/G
	 uaFlmWVR+dFdcecLpzrWeIo28t22/kobrkEoydr3Sfg7nikp/NKNQCVvd/0oaOYFx16Wp
	 +i2LB094u6avYiB7uuyhjdvO7qPXsUGk/Sn14AEk4SdsBku+c8dTgVudRETjI4LL4og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=DHMlKQv2;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF484606A895;
	Wed, 11 Nov 2026 11:10:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF484606A895
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=DHMlKQv2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=W4Zd/TWVFnT//vb4/FFMwAQIXVyfGZrnD6iu7ob72UI=; 
	b=DHMlKQv2B02Hb+AoRBrod1bVe2mTBfhVxzmEX+pAngretmvXktRfmCHXjVGAuo8n8DHCLLOJf9s
	I5GIgyY0+9EMX0S57Ho32uBuQEtqgUcMZmTlRqwJEM7kCCMbAFp9xDcygSw/pVgOinuf9cx85RWxh
	rNqs63P9P6tFB4ur/rkr5mUjnP0vYiGOS17UK0DX1i6b/BzS3Pb1FQLMYpVDLF7DZnkAVC03lrgYi
	guGKtUkyt5PRNt7+7IK/Y0xTO/hT/EF5fCL4d53ORsEsV/ieoswqDmQIHEM7YVPyCcsaXbCI4VWFJ
	MbUortb9+5QZD4lvZYOD+E6Pza3MuohhGamw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR6DT-0000000DmPX-467m;
	Wed, 11 Nov 2026 19:10:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 19:10:11 +0800
Date: Wed, 11 Nov 2026 19:10:11 +0800
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
Subject: Re: [PATCH v12 0/4] crypto: qce - fix self-test issues in skcipher
Message-ID: <avRNE-rPQDTNWvMh@gondor.apana.org.au>
References: <20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com>
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
In-Reply-To: <20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com>

On Mon, Oct 19, 2026 at 04:46:04PM +0200, Bartosz Golaszewski wrote:
> This iteration will hopefully fix the final remaining comment from
> sashiko.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
> Changes in v12:
> - Also reject messages shorter than a full block for AES-XTS
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
> 
> ---
> Bartosz Golaszewski (3):
>       crypto: qce - Reject messages shorter than a block for AES-XTS
>       crypto: qce - Use a fallback for AES-CTR with a partial final block
>       crypto: qce - Use fallback for fragmented skcipher payloads
> 
> Kuldeep Singh (1):
>       crypto: qce - Fix xts-aes-qce for weak keys
> 
>  drivers/crypto/qce/cipher.h   |  1 +
>  drivers/crypto/qce/skcipher.c | 41 +++++++++++++++++++++++++++++++++--------
>  2 files changed, 34 insertions(+), 8 deletions(-)
> ---
> base-commit: f0f20b900bbb8bdcfaf6cb282787854067d8eec8
> change-id: 20261016-qce-fixes-skcipher-e0384a650e25
> 
> Best regards,
> -- 
> Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
