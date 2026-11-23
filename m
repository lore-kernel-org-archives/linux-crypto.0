Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795447773;
	b=QGZ+vGXCv9vrX4+vj1hTFpa/FkeEUxHorKTXSW1ww9gUUGn8lpns/XeTAG3EaIuLg5qm
	 b6ldK6LeYuKvkwRB5zmGcO6ro/JuQ2LNL47hLus3xAim/Y16qJ18dcAC7Bz4Wb40EKOnK
	 oBMO1iHUGrhzQJj+VE3V40cI79m5KGQGPs+i9zrWJeCFpC8F+rHKlOV0VVlzLClIsLrU1
	 uZ9dCCDFMON0wmwU7oc+Uo/gfzmFe85jDkZpdtPaLFrB0IfMsYpuV//Uk+ZuZ+qsDrdO8
	 +mK5j/HTyTl0o1eqPuzzGgpTALRy61xyI1F+TYWcJwu+uFPVnl560cMYs6J52Ps6azA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447773;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=R020g54OZZm83YeqwM84l5L4106wrL7JprwR9fNpr1w=;
	b=bYF79yacx7KM84JGzauYDNAhzSrsltrgVaBlcJuBkqlIGcHlRD2IrBgEC6ezxArb3rrX
	 YQRG1ESg4wOt1BHA2tKQPVKithJzOWIil/SC48MHzB4VszcsGq9lzPdaCEduPSJo7Va47
	 LfCEYmUynFrDusIEEZJfdlSAr+Fan83N55g9xpfuwqfmGbUCwpqzczgDDEG9sOdB61cXs
	 +JZ/iIVCXF605aM2ROdTeG6tTujq7uYUIrZ8PJd+cYaOg1PFadMD6sthvsCWQK6T0tIao
	 ckwckjPtYiVJFSrdgTMExmMt1q+/+WeT8xvD/N3pEk4VU06kDRRs8M5UqvoTBG9ioJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kmRWDqC5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 61BE4606A330;
	Mon, 23 Nov 2026 15:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kmRWDqC5
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F262F1F00A00;
	Mon, 23 Nov 2026 15:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795447772;
	bh=R020g54OZZm83YeqwM84l5L4106wrL7JprwR9fNpr1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kmRWDqC5dXQeZvZlh8qlBEYVX2C4qge3Vx5LcqUOzLbGhOXUzSCBBvmBQ3/FYP4QI
	 9fH4LRaObVabwwJsjL54XiIoxXVtOhguSEki4tToCARmQaLQfLLD1vcvo7v2ptTcAx
	 W2fwJqLRWgQjOJ+cNomsUK4IZRtamaNcqp63tOvpSgDJKtAUCPqoSUO2A7vCf/TboV
	 sgGAQC9YQxJ/2pyJ1bBY6CNN9um1SVzoe/jnXHqY5mn37KuwBIU/Dm66uI7NvwCL7a
	 /DMLgdTEw70bOxRpEWMuDt4RufIOFgiaIuGI+A2LOr+jAbMRMcwhR6LRRaZUKDRl+C
	 BsbVpXEi+F00Q==
Date: Mon, 23 Nov 2026 16:29:28 +0100
From: Bartosz Golaszewski <brgl@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Eric Biggers <ebiggers@kernel.org>, Demi Marie Obenour <demiobenour@gmail.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Subject: Re: [PATCH v12 1/4] crypto: qce - convert to auxiliary bus
Message-ID: <sfsgrwaj6ichkuafqvrpmql67664x6vyxgz7lwjxhywbf5zc3l@edz4qooziklt>
References: <20261120-qce-fix-self-tests-v12-0-b5a2a44bc5ae@oss.qualcomm.com>
 <20261120-qce-fix-self-tests-v12-1-b5a2a44bc5ae@oss.qualcomm.com>
 <c26b8002-c246-45cb-bca0-8f596a2a425b@kernel.org>
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
In-Reply-To: <c26b8002-c246-45cb-bca0-8f596a2a425b@kernel.org>

On Sat, Nov 21, 2026 at 02:05:57PM +0100, Krzysztof Kozlowski wrote:
> On 20/11/2026 20:34, Bartosz Golaszewski wrote:
> > This driver is disabled in arm64 defconfig but one of its
> 
> That's true for next, but your patch #3 seems to disagree. That's
> confusing. Maybe you meant disabled for arm64 platforms or marked as
> broken? Because anyway defconfig does not matter here - even if drivers
> are not enabled in defconfig (so stay disabled), they should not be
> affected with unbisectable changes.
>

Keeping this fully bisectable (it is build-time bisectable actually)
would mean squashing all 4 patches together. If nobody objects, I can do
this of course.

Bart
