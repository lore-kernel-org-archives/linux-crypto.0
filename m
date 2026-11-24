Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795524569;
	b=OOJEcta0e+vP07eWuhQHw0+c6oHGuYncLq9SmlANPLhK2NewM/XLKZDJSUva+y62fM8U
	 oeQszKVc+CYmwY7/ze2B8oeyEGj/z8CvqZBN0ZDHcuc8jWUemsXWyNu8QgwIGv5uzGTv3
	 7tkabnyrM1MOomsInV3gV8E+kszCUepJn2uPDzO1BBxWVZyqJNDebmG3go99KyR0MITrd
	 BAoTpehnYC4hwgsII1cFlZYuCMQYHkM6Ih194p3/R2TTB1wV3s3sNvVALSZL81VFKcUYO
	 0Gk0klLsobYqQogRwXNQHd0N3x4bZue1RNqIBOD0NVdmOu6UjLQ7Y+T4rFkIYJMMDKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795524569;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=J9XplP6Btvmy8akDBMWonshihuj26swf32dfVCUgdwg=;
	b=BNXJvbjQnWRiL1RyiJDO+GJCFVPX7+zsRptOmTba4LuG50zbfji/FW66agRSQEoRMTOD
	 XzKjQmIk+luwRzFmaUmCPeMFqbkrnx/KLoB3XnhViQgrhh/5osq2dqKhP76KRqCQvIWTS
	 gFDOQXJSmAON1eAEZ+4ztJ2KOYZQOMFYvQ/9IlqEQgSPEvHCw1zsb8dbz76wNnLjX66Cf
	 O/MK2386l6B9N1uWa3oJ2abVVs0OeENuRG3aMORuh/qylJ4xUY7hgxxsRCbRW5LWuDEQW
	 4RRBamWLtgVp+ydXa6Mrf5DUz7sbLe0smHsc/r6wqvAyIleaTi2hF/aVSq3so/qyK8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HPMv9Ks9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EFE07606A321;
	Tue, 24 Nov 2026 12:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HPMv9Ks9
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 96AA31F000C0;
	Tue, 24 Nov 2026 12:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795524568;
	bh=J9XplP6Btvmy8akDBMWonshihuj26swf32dfVCUgdwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HPMv9Ks9RGmhXNlYVzmrF7fiPSZhSSY3aqC8P5S0GQN6L1zk5smaEQhGwYwSfdSLW
	 8B76U3f120fruQNJP+CoCr/6NcIsMwlBkJCMu7qc7OhdOj7vir5m9uCmpdaCo/jFmc
	 hUa1WJijxAufBSUc7lOaUpSGT3J7oLXXtQpiQETmCYbfrypt6OXvi1yQmtzpDVDjrs
	 zn6wba7BdFuSPT8sLEVnKU2iF+TKI4DRsNob+AspmsppE6QfRl7BqaipHkfIt8KaQx
	 I0/mEo8KR0ez81M6VQbedljNFlQ9gxFWx1zhmzDsdt1qwipYEPXJw53n8/EykbSE7+
	 Xm8xFV5xXaVTQ==
Date: Tue, 24 Nov 2026 13:49:24 +0100
From: Bartosz Golaszewski <brgl@kernel.org>
To: Lee Jones <lee@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 09/10] crypto: qce - Terminate RX DMA channel if TX
 preparation fails
Message-ID: <h7xgt73ey2qxy3f7zdw6k2xvraqng6vffemqae54kx2yhz5ojr@44pwnv7y63hw>
References: <20261123151055.2533735-1-lee@kernel.org>
 <20261123151055.2533735-10-lee@kernel.org>
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
In-Reply-To: <20261123151055.2533735-10-lee@kernel.org>

On Mon, Nov 23, 2026 at 03:10:00PM +0000, Lee Jones wrote:
> qce_dma_prep_sgs() prepares and submits the rxchan DMA descriptor via
> qce_dma_prep_sg() before preparing the txchan descriptor.  If the
> subsequent txchan preparation fails, qce_dma_prep_sgs() returns an
> error while leaving the submitted rxchan descriptor queued in the DMA
> engine, and callers jump straight to unmapping their scatterlists
> without calling qce_dma_terminate_all().
> 
> On the next cryptographic request, qce_dma_issue_pending() flushes the
> stale rxchan descriptor against already-unmapped memory.
> 
> Terminate rxchan via dmaengine_terminate_async() when preparing txchan
> fails in qce_dma_prep_sgs().
> 
> Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
> Closes: https://sashiko.dev/#/bug/linux-0b5dbd9f-7869-4856-a8e5-47c2c6e342f1
> Cc: stable@vger.kernel.org
> Signed-off-by: Lee Jones <lee@kernel.org>
> ---

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com> 
