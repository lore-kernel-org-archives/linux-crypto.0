Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792868165;
	b=m5POCDMY+3ePAimsTNXtnYwIgJTer6Go81Yki0AqljeEjQlKIQzdZW/JcW+o7+3xsBY+
	 Y/thL5PY3P+EDbRQZk/8x33gac+OPhiId+gpVMtGL5jLsokWFJbPO5IRp3N+RZ/FcEsqj
	 HGRM6DYMwtKm5EYfvTK0RQMKWJShavxl/JzBRLPhUVG24Rr/tKJBWugifG4JQ4mDmh4/f
	 kwyDbV7ijub2bI8Txuhwil17P6x1km1+HZZoiGuPSBm/Hv1k2FjBEOGGbQOk2DFBeWInf
	 +IoCLhkPG/ImQ10PxuNxn7rQtBOzhetdvFXoteNkyaZ41kLXiw2feM2dC3L0EbGljzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792868165;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zHonWZvAJxHm8LpxaiLGc2DeJqF8Z6lwSh7XwdTqGtE=;
	b=uRLOtBnObSNKyOWOf1uE0YdYx2Aesb0bgB6us4b/Xy8Gjp+/6ez6O7jFJTG04nO4IynY
	 B+vGpBy492XK+QjtXgXg02p+y/C22iEcfMvVpWK8/mHTQVKfdRiMcA4AJEQWa5N37csrf
	 Xk2LVs/33TQV8oVck6CdgFCR4oTAfGwvzJaDgtq6GfM2V+GPzlCsAChRv8APTpGvKk1fO
	 n3u/imhluH0hSXVwCHGLzIQQ/eIsko5BNfOyHh1zkpGefYUHfyG14jg1y69dGHagIt6sW
	 EHwBRwPZVQQTzdshJFtAUYc8vRr8Jvi/ISPpK5DqUG10IRiS9wTWvGYuXIODQ5XRoOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GpyvUbE7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE601606A31A;
	Sat, 24 Oct 2026 18:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GpyvUbE7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296E41F01825;
	Sat, 24 Oct 2026 18:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792868164;
	bh=zHonWZvAJxHm8LpxaiLGc2DeJqF8Z6lwSh7XwdTqGtE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GpyvUbE7eXTpMs2EK7JRwxpPhhy1AKc6BWBbFkMqz4MCt3fMHTHKc/R21xtJa8xFy
	 xU0MxFpCbDaaiEoK0vdIt1y0u3I6FoGhQQlxOB7pPz52KEG25CCnBSN/J6GJb50TKx
	 QlkIGVylGZIdRFe4T7UwyYvmmsC1lOP8uVr7pQf5D+213132V0fqyeEHEf6tRsNxvG
	 Ln2T9sW7La2ngqAJyLQ99FKF3mPXMOyra68N9YNt3bdg5a8I07x8Sat24hqho2saz2
	 kLuhp4rVeLyxRXZlDdxiyluGRS7ui2X6IofvChc36FbpXKdUkV2tny/1ME0i1TO+r+
	 /A6t8b2KrnYTg==
Date: Sat, 24 Oct 2026 11:56:02 -0700
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
Subject: Re: [PATCH 0/5] Add support for a TEE agnostic Inline Crypto Engine
 service
Message-ID: <20261024185602.GF2553@quark>
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
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
In-Reply-To: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>

On Wed, Oct 21, 2026 at 09:13:06PM +0530, Harshal Dev wrote:
> This patch series adds a generic ICE service which provides TEE agnostic
> APIs

There is already an ICE driver: drivers/soc/qcom/ice.c.  If it needs to
do different things on different platforms, then it should be updated to
do so.  Adding a separate middleware module underneath it, with the ICE
driver as its sole user, is unnecessary complexity that will just cause
problems.

In fact the middleware module is called qcom_ice.ko, which is the exact
same name as the ICE driver.  That's broken, as it's a name collision.
I think the fact they have the same name hints pretty strongly that the
functionality should just be incorporated into the existing qcom_ice.ko.

AFAICT, this series also breaks boot on platforms without ICE firmware
support, due to indefinite EPROBE_DEFER.  Choosing a simpler design
would help avoid issues like that.

- Eric
