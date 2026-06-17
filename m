Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFF647DFA5;
	Wed, 17 Jun 2026 16:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781712355; cv=none; b=V/xo82ENgWg9HNZsX0T6zqIgw31tTRwAHCrl2rZtSMaGTvRIYIGfEm0mNsAVmqR0N3pT6RWenLt6AVBW8JjluJ6CTS8g53vi3s4vfG3jd2PPDVo10NZ42LvZwgeXxThIJP1+3LH81JfjELoXWz4X1W3e5EytcO7DJIFRvOeINHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781712355; c=relaxed/simple;
	bh=xy5pKmpHR+8apKnOQYTmpDygAfYhxlGd9QQhURnxDB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grHmdLXBjaLp4MUk513lVLf+mcMimtND6Zgxm1OL0mj7xeN2eLT/ZvTpusAf0eNAkwQRDgdBIy8yO0V2c/MVaAWcjUzT70vcjN0+1vwswFQBp8UdFIA9IHQNGj5R/wMqRL6MDfhlpYSbflxRHQ0PWqXgaY/xtDMmZokntQ4rqTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QeXpHjOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QeXpHjOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8EA1F00A3D;
	Wed, 17 Jun 2026 16:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781712345;
	bh=Bpns6yus6XLe48Ane9Z4QuHWfQYFi/6/9PVRUaHA5qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QeXpHjOZfwNWL9KTxEQnzpY41ylIsdi+mnTMtyDNCU7IzT7h/eGyRBA++5D4ytpjF
	 7VV+hd5MKl5R1qWerv0K3Mz4UR+EFyT4g0GohxEpeOv7XClJmZr10ZTM/wTVmW/6+F
	 tAPcrEvr7gMLLOzPOmMQZcJo6qcslbEGlCT8cjO1CSakBwcnKuxwDVO79CjBW5wY29
	 Y/t8T3QU4gCrwqmfiJn5Ph67cWTAKrza/lvY5TbTq6SnucCudxXeMBomaPJbZeQ6vN
	 jMeWdX/QAdBncvPT2OjvjT6KuPIz5jrES0WmHC74pcLAzhWgtfz/YtgB9QsMvFvFt3
	 uoXA/zaZwY+8A==
Date: Wed, 17 Jun 2026 16:05:43 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, brgl@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/8] crypto: qce - Remove unsafe/deprecated algorithms
Message-ID: <20260617160543.GB785086@google.com>
References: <20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com>
 <20260617-qce-fix-self-tests-v3-1-ecc2b4dedcfd@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617-qce-fix-self-tests-v3-1-ecc2b4dedcfd@oss.qualcomm.com>

On Wed, Jun 17, 2026 at 05:49:30PM +0200, Bartosz Golaszewski wrote:
> Remove algorithms that are either unsafe or deprecated and have no
> in-kernel users that cannot be served by the ARM CE implementations.
> 
> AES-ECB reveals plaintext patterns (identical plaintext blocks produce
> identical ciphertext blocks) and should not be exposed as a hardware-
> accelerated primitive. DES, Triple DES and HMAC-SHA1 have been
> deprecated for years.
> 
> Remove sha1, ecb(aes), ecb(des), cbc(des), ecb(des3_ede), cbc(des3_ede),
> hmac(sha1) and all AEAD variants built on these primitives as well as
> authenc(hmac(sha256),cbc(des)). Also clean up the - now dead - code,
> flags and constants.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

Acked-by: Eric Biggers <ebiggers@kernel.org>

Looks pretty comprehensive, but I did notice a few leftovers: a comment
still mentions DES3_EDE_BLOCK_SIZE, and there's still some ECB-related
code (grep for ENCR_MODE_ECB, QCE_MODE_ECB, and IS_ECB).

- Eric
