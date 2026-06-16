Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CADB3CF050;
	Tue, 16 Jun 2026 05:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781587191; cv=none; b=nM5Jja+UHYASYSZk1YLIcY3pqw6YtPqp71b+rtwUnvTwpCjCnYFzoD/XpG8ZI5MrD4CxTLMprspapupmMfC/98prtGY/tFjrv898ZVUVaYNukc+aYA7dzfuh7A0Fb7V346L9bFXOFYW0GJYZWA1n2UGvNGuFW5yqjP/H8MEFbF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781587191; c=relaxed/simple;
	bh=gLXwPiCRPIvq+YcbMIKq8VQg1wqJjHU8IQ5H1jeimw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdOIJ65eWx2JPOVa24NT+0OWfSNsuNNr2VWvCFJIlfdEimLZWjd1NF7KkbHgap3PKZtt9uHqVyikGsg9Mp2NaMHvYuVncgNNKzOpaVoOWX0J+jCasOb7qgl5D8kLBJeJBdvgR8ff48StwLkCRaFXgf+AC1i7+ARJDx4GJB1qBVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/vTdyzL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/vTdyzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B296E1F000E9;
	Tue, 16 Jun 2026 05:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781587190;
	bh=KvBrSwBFTSZ+t/K9ooRkcCfKUkhV2wprBH0/WVJTQv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U/vTdyzL1eIsF2urLv8BqnMYsg3bu3Wqb9Tq5VvEdjR6zHUSKSGcJz/iDWl3VPyti
	 i5OIrYbpy7vEbeV+EkdAi5ZIR4ITxMob7Xme4VbYeVr4xMu/xgSHF4OHyxLU4FTKEu
	 jNmav7I7y917ZQ+RBuFOP0yb1iNEXmy4dRr9pG8nWas2Htza2GeO4gsDTYCh7nYQKD
	 N4kw69C5Om6+F6WX3GB+G+R9EIrasDdDQuhtUI9iHlMIBL42OjP5BSuy0dHtNbXHkU
	 drHu/heyZesWAm6VR2246BSasG1m14t9J/HHBbFfceycEq8DwqFAPGY21nOd7xMoej
	 IAIPPpAlCOyaQ==
Date: Mon, 15 Jun 2026 22:18:20 -0700
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
Subject: Re: [PATCH v2 1/8] crypto: qce - Remove unsafe/deprecated algorithms
Message-ID: <20260616051820.GA127019@sol>
References: <20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com>
 <20260615-qce-fix-self-tests-v2-1-dc911f1aad42@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-qce-fix-self-tests-v2-1-dc911f1aad42@oss.qualcomm.com>

On Mon, Jun 15, 2026 at 05:49:52PM +0200, Bartosz Golaszewski wrote:
> Remove algorithms that are either unsafe or deprecated and have no
> in-kernel users that cannot be served by the ARM CE implementations.
> 
> AES-ECB reveals plaintext patterns (identical plaintext blocks produce
> identical ciphertext blocks) and should not be exposed as a hardware-
> accelerated primitive. DES, Triple DES and HMAC-SHA1 have been
> deprecated for years.
> 
> Remove ecb(aes), cbc(des), ecb(des3_ede), cbc(des3_ede), hmac(sha1) and
> all AEAD variants built on these primitives. Also clean up the - now dead
> - code, flags and constants.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

What is the rationale for still supporting the following?

    sha1
    ecb(des)
    authenc(hmac(sha256),cbc(des))

- Eric
