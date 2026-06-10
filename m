Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8F026FD9B;
	Wed, 10 Jun 2026 18:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781116929; cv=none; b=osIsSs0pyGeCsSaNtMjNwBuye3r8GAeNXJo2G5kWUTi0bpxlDeSGnpdtW1M1wYgbUhyYd4PGAByIud5DsJzGtMOzwkNoNUgNgXB5Kk5N6R1F5bCnYTk+qHh7sa/sY7NoroNSEXj+W4lIbcIoHOBISnWCYEZdazMrPjWIW29ljwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781116929; c=relaxed/simple;
	bh=+ytYljFPg9lTGiZRIxVSjzdKcaMjWrkFZCulMkUS6kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nqYdaDC/0P8mQGkpoqo+jDuFaEHtvb2HiOl1syIeKDsLtaFnymwjh4n7Mzx2eBPKVWMTJ+K0glnvycoYv96qp5XXzqJ0V30jdmh9zSEAhGHBbcGpYCW6mSPC0866l/aSgC4fdWWGQeHbUzw8C93Ss2F9tYqeGOL9+gghxNduEyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2iCE68C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2iCE68C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12C01F00893;
	Wed, 10 Jun 2026 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781116927;
	bh=cUxZvwIf+9Y61C7TeQJzj6X8xqLB/pguWODIb9UeiwQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M2iCE68Cy6X3/jwTVnf7eWBD6VQdsSxLu7ETMDUKws4X78ZH0mZrkds7+xZ/XYuyB
	 +keahcmOHziJGRw+atRZX+irBmjuajtT4N4jM0LYKpx2CyqwdE6Sg2Ok9pkvwTAQkH
	 x+Ld3z48O8TsAY1N2Qmh3H44pZ31nXh3ETIQ0uD6BVwf6tDTdOL124NAGCXZapcqp/
	 eryOdzz6pEO0Brj16ixaVAmgAcNfqwIa5VHexLA7QM2V1O0ZYZV0uSy4dFFSgsnfBj
	 b14c+LCZEkWOWWLsqRF0WOIDXvwTQQNIR0uF2bBm5peED3/jKW9InR8g3LeSyz6qbF
	 ejkyi8GU6+uhg==
Date: Wed, 10 Jun 2026 18:42:05 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Thara Gopinath <thara.gopinath@linaro.org>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix Qualcomm Crypto engine self tests failures
Message-ID: <20260610184205.GB1158828@google.com>
References: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>

On Wed, Jun 10, 2026 at 11:24:03AM +0530, Kuldeep Singh wrote:
> Steps followed:
>   - Enable EXPERT and CRYPTO_SEFLTESTS config.

So the full tests (CRYPTO_SELFTESTS_FULL) still haven't been run?

- Eric
