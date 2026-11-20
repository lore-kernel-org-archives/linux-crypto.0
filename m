Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168673;
	b=E1KNi/A248jUfiOYWabNhXesD8K4ZiyiINJgb0cqf62PFoblmXo+7F9IjnRrh+87I54j
	 o0n43Herca6oM05PAGgy1efri+8naARiToQ6KqjDTvXJ1vFzFdvuodStdJtFPbMKuS/Vv
	 aJ+uO5xTmcJlN+roGHgC7KntrriPjgzYBwfk3anNDR/itrBER6WAp81HLZFsus/Cm+E8M
	 1aoHSvYc305QkINN6sF2F/YY93JXqTWhmIkSitLBR+RH5KYnH2RZoZnWBhxhMRzLSW+eH
	 AeHQcQ8iMjILrkocVdLRhOjW/urIF4wsumIDvXwxs3NNo09cnRiE1EC8f0UeDI4EYUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168673;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0CJqhfaRwIf9n/RB1oADTEsSvNdb2w12OyIuhDSocvo=;
	b=ZzhsF3YEJian89kiRpNtOXFEdmmxLlcwhw6/bfMYstCMbNEED92rnsW9MM27MdBkZMLB
	 dWdGeszICTzpCIT8UhAAEDfLZDzjO2I+Wj+7WX8Tle8cVVUPX9jAjzUTNmPxsNbTxGpWB
	 jlCHsGM+5f1MKztQoDSfO0dO97e8P16yAHL77qjxPwSrBuORPd0FGc6FMKP3sDxNwLP5h
	 LqTNrR7VBSQ/F44O+az72jx/U2wwUttgVqEuOQWSO5xeeEwhjKhWgR/yotYxdHfuRQId0
	 u9hZgOR6+aohIdaphtTEH6iQYibVqKvUr0/WrF8uFQe9s7e+OnwxdjY13W9HErGkt1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gmD2x3x6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C7900606A320;
	Fri, 20 Nov 2026 09:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gmD2x3x6
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BEED51F000C6;
	Fri, 20 Nov 2026 09:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795168673;
	bh=0CJqhfaRwIf9n/RB1oADTEsSvNdb2w12OyIuhDSocvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gmD2x3x6PsfNrEh+DSm+x40DYGTO+CoCR5AoiTvgLBZX9ziMreBXgWmWD8WD8lqfh
	 piJw8nIoJxjKiWwlsNZsDiF6WQn2PI2+eTmX7OvdB8+sdOF+v7rDl8QjsobA/88k0V
	 RZrhk3QPPKS7H95/ewdgJ4vM+5RS7twMry/5HvZ2chPMjWQWNENvgUB54LjYrre25e
	 heeayolfYmqvt0kl/3xkCTtw6zWwkBFo9tQCGYfRL6qz6vBFUF+kxrovJFgoAS5zeZ
	 I4vd4ZujYmfJNyjMRAcnokjEbKBpLFPgQJopjLDlgTCMCPJcRYpmS2tLA5Ex2LUC/p
	 jT34Sn5zC0NEw==
Date: Fri, 20 Nov 2026 10:57:46 +0100
From: Bartosz Golaszewski <brgl@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Russell King <linux@armlinux.org.uk>, Eric Biggers <ebiggers@kernel.org>, 
	Demi Marie Obenour <demiobenour@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>, Birk Skyum <birk.skyum@pm.me>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v12 0/2] crypto - qce: make algos optional and remove the
 BROKEN label
Message-ID: <2bmlzgxt3xtjbrtt6gypvfkji3tvxclnwld2wjjmzef3cdpgfw@cgohz3kfd2wp>
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

Hi Herbert! There are no more sashiko comments on this. Could you please
take it for v7.4?

Thanks,
Bartosz
