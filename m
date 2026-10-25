Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792948769;
	b=pmdGeXU7z6G8Raw/lI6ZVjr3LEgcgFlvmRrHvZ+2RRJzNYqVYQ7xG3Fx+6NybQz4Krhq
	 tW7imJ2MKkZ4Ku7KhACn09WhhOBU09oLVuML9NIuSO5ARuz8l7cM2xrKYoUIhQyQdYJzn
	 uPxlMJIxSSO2u+BlFewXLmhSKIrc4TsTFyRYLd6sl7yOZXNoJeepXDOTb5SkG+jQfWzM8
	 WOgYkNMT1aFoffSQOB8kVaPdtc/uNcCjNwilK4wk3pGIzY5qKcy2jih8BGxW7w3sldNCL
	 /sBJefk0g9XmFzSCRnlEq0mEo6CgA6RwUoUGMr5NmILJoEKZqRuM//wZeOQw4VyUxAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792948769;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4apbpOD/RfD18CBpD+KC1y2A7pzzope/+sQEbeyorak=;
	b=UU0Ia66h8VsLxJ7AUsBfyxLYuWWW+OAgqa5a7zOKm+UDu5XyxWOua6QFC2SgK7cytQn2
	 c1c0vDs6BLqeafyCgXvWryHuvA6ttUQx8klCNzbs0UNUc+KxpmMPizE8gr1iy4EuspC7M
	 y5TuuR4o4zHfhdE/1YHY0Ltm6YXeYhl55R49427mutc/r+sXDO0K5yjZFGV0+LeY6d6yX
	 3RkcU6WQNQv429p7hM/2A+4qJT8pgs2cxmuS1A1u//i1e/DfLG3cuInv9SWfoTf3h5ond
	 baOf+1zdhmiCDl62lDzVQa7+zxw0A+vqj1X7Q6+B41Irdpt9nonRhaWRJ/7RMj/SAwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkdiu9GV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C61606A31A;
	Sun, 25 Oct 2026 17:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkdiu9GV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC481F01825;
	Sun, 25 Oct 2026 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792948768;
	bh=4apbpOD/RfD18CBpD+KC1y2A7pzzope/+sQEbeyorak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jkdiu9GVtJznxpt/87GYKGTKken/6rU925XJDOhhM0BIKW9hczfucvL0/waKCrDK3
	 FYeZ4gvo6HkrkYoN8dhYYohzz/+jStjIMxZr/NCd8viKUpQ9+jlAtLiEx9b+b/KdUZ
	 tkIoWk67vmlX+ea1QzdARsjEehpj/biCrjk4iFt8en3zQKwM4/81UNLKFvg0GgtH7B
	 WDDeE8wPkmH8Vc5unQsFkwi9NItOkfnsbOYngp6a9fi61UKoY3PauRROn4KId2VdDN
	 AONemPFLbBmUhsqJDRTwBHJrUFwVSnNrY/fRNEAze54EBcOhQS9Glr4uwTaQIvAyLQ
	 5OaDoZKBqbqyg==
Date: Sun, 25 Oct 2026 10:19:03 -0700
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
Message-ID: <20261025171903.GA2212@quark>
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
 <20261024185602.GF2553@quark>
 <b5cc804e-0f73-4ec9-88bf-ef6dd04eea83@oss.qualcomm.com>
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
In-Reply-To: <b5cc804e-0f73-4ec9-88bf-ef6dd04eea83@oss.qualcomm.com>

On Sun, Oct 25, 2026 at 10:16:49PM +0530, Harshal Dev wrote:
> By moving the TEE call re-direction to a separate middleware we are ensuring
> that we only touch the 9-10 lines in the driver which depend on the TEE firmware.
> Merging this functionality in the ICE driver would substantially increases
> the total file size.

Again, it would be simpler to handle it directly in the existing
qcom_ice module.  Yes, there will then be more code in that module, but
then the new single-user middleware module wouldn't be needed.

> This is why probe always defers if this check fails:
> https://elixir.bootlin.com/linux/v7.3/source/drivers/soc/qcom/ice.c#L568

Nope, it's:

	if (!qcom_scm_is_available())
		return ERR_PTR(-EPROBE_DEFER);

	if (!qcom_scm_ice_available()) {
		dev_warn(dev, "ICE SCM interface not found\n");
		return ERR_PTR(-EOPNOTSUPP);
	}

So if SCM is not available at all then the probe is deferred.  But if
just the ICE interface is unavailable then UFS or eMMC comes up without
ICE support.  This series regresses the latter fallback behavior.

- Eric
