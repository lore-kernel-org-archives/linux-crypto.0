Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794605646;
	b=qDhfYWJ8OWNHsXLYA86RyilRUTd2qJCT2uOiwn82BYM4OqmrVY0aHqyC9/RLMCpRzFEZ
	 vebAz0GFPzZkJ3WhMaZzQ7YWCNrivx8CtVo2mZ3ASxJ3axMfqm30yHlsxOTzvpLXo4xrM
	 +0B7WAVgBPHsUbTFDFmL12JtxbwXZoZH6G2sAwzjmGNx0g18KROe+EydLmsY/tvU9Ktl9
	 oP23l845mb3hkAVWhhjaBkEP6HcoSq20iELZslo25M5ctMfxK+ov99DgMGjHDYOMB9cdN
	 3tainicvAeaJlC++22ZkP6xD+Y/2cxc88gPjvawJo3pU85YSoZGMUSh9AKYmaNs0dEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794605646;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=msySKRrJQn+I5YfQPoDsZo7AfBDGVsBeXtdyFRs3vfU=;
	b=CIZTPFdGH7lHCskx0wlwSj1c1bZxw7yTOKMbjVPbSCyDX0BziNPAMeJYKp1PDPV+GX20
	 bu2w9LKc6pEUfms0440YuDOyFtXLuQIN+XlEnMyJ0MGhk4fRjSi1esoFqS5TyuExa3fey
	 W8M/VfW2kK0Oi7bDSie75YSqor9uPiLbP71gfFpNbe8qb+dWfq8ktNGqlNyOTrmvWd/Ut
	 UgpUi3yrQgDLSIZVcoUE8Otv2W2LyMyPSWH1AbV1tJ6umBncCjH5ltOLHzrrPCLLgH62c
	 GPGrYJaxlzketAcFZAL2z1wmh/pep8Y9rGIdzNpy6F3MdMWR9bfOsuPZ4sBs2wvwEBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMRlRGpz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AA2606A327;
	Fri, 13 Nov 2026 21:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMRlRGpz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516A01F000C4;
	Fri, 13 Nov 2026 21:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605645;
	bh=msySKRrJQn+I5YfQPoDsZo7AfBDGVsBeXtdyFRs3vfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LMRlRGpz/ezGTIE6x3NKmL4BH2Jv2Le659sXO8CJtwAiZ8FTHIQzNGqKX9GPHoPav
	 jADjah2izFJI/NmzMCZVcvNPPrAVVh/Z7jHwE+34a9pQkBTbvLXIdURy+EzeIHC8CU
	 e5GTvuE73NnvizGcmxwwoOZVGTDIR0PL6iDfQvLToMIQmAn95m9jYTaM+22sZe+ibx
	 EtL3GdinmlfXP4aBnoP8g8+VQCxuJyIDgio4LOa+ZyIEuO8gmGazTnopbl7ashb5xL
	 G+8qQ3Z3BHkDyZEublAgPXSzWn84O00EfuuhsI2p4Ahsw0XJUe17XaL7LFMK7UQOp3
	 F3dNdxRolKjlg==
Date: Fri, 13 Nov 2026 13:34:03 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>,
	Basant Kumar <basantk@qti.qualcomm.com>,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 2/6] firmware: qcom_scm: Transition to ICE TZ agnostic
 operations
Message-ID: <20261113213403.GA35210@quark>
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
 <20261111-ice-migrate-tee-svc-v2-2-29d19f6c92ab@oss.qualcomm.com>
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
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-2-29d19f6c92ab@oss.qualcomm.com>

On Wed, Nov 11, 2026 at 07:47:02PM +0530, Harshal Dev wrote:
> Transition the ICE related SCM calls to the generic ICE TZ operations by
> registering them with the ICE driver and wrapping them in exported APIs
> with the same signature.
> 
> This prepares the ICE driver for eventual migration to the TZ agnostic
> secure programming interfaces once the TEE bus based back-end becomes
> available.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  drivers/firmware/qcom/qcom_scm.c | 131 +++++++++++++++++++++++++++++++--------
>  1 file changed, 106 insertions(+), 25 deletions(-)

Wouldn't it make more sense to leave qcom_scm alone, and have qcom_ice
decide whether it should call qcom_scm_ice_*() or the OP-TEE backend?
That would avoid the circular dependency between qcom_scm and qcom_ice
which this patch introduces, and eliminate the need for patches 2 and 6.

- Eric
