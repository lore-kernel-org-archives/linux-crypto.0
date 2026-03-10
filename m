Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6173E9F89;
	Tue, 10 Mar 2026 08:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773129821; cv=none; b=s8cl1yGRBJWuqK0z7wwTryR3i+q0wbbkL1RpIhS0X8FwFrazsnge8I1721xQgg5AWjz11ZWgyu5Yzt+o64Rr9PcBxbT5C4X1Jqxdj9zTHldduFNWeA3xVdZ7Tya/BVnCDgAvzu8/gyH278yPabSdbtqCLkl2TTU6lpQsj0RPFjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773129821; c=relaxed/simple;
	bh=QYykVt/pMggiqx8fiqzV6OVjRy9J86Tpmjmqb5WNIeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JrdhYx/cO4HUM3JQoxcf81gyPtCYprd6N0ApI2tlV4cMVs1EfuzxJq/NqfpqoKxsP9gq0AT9RUAeQb6cEN7r1TvVi6gRmES7Hp2LNiP86ONg5SZiK2oMfH9QKlxUe4D4wWn+yPjZi2qqzgLr5sZW+Ltg0a8OMe8mgvWZ74unJ0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=teuuA2kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="teuuA2kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A680C2BC86;
	Tue, 10 Mar 2026 08:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773129821;
	bh=QYykVt/pMggiqx8fiqzV6OVjRy9J86Tpmjmqb5WNIeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=teuuA2kp3gzhu+cwPiVI5VO5faos1t27JTpMfjBLLawHKpij/eTsDf0bdZMiNMxyO
	 ScshvvIBXaal4tn1We2WJXK2pHvYD5PetpDbJBdSguimULqDINVYSJkGu8iR7ytpIZ
	 BH22TMGqAKMx3TgHgGE1lsXPrufTUhxSz3x8yoH5uPsbK4jbnUFyLFyahZTQ98GJ3R
	 CC47MKFpss2uHV1ia094ELVyRJ6Osny3IolwpdTaZ6vBPua4VluKZum5/csWBxz7Zl
	 6tuzxIL9RmU67l9B095X9Xog9p/pX7qZOFvK+NxvgvPete5FvNLEtPM8Jb/72FLwgw
	 ZT6rN44pw34pA==
Date: Tue, 10 Mar 2026 09:03:38 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Alexander Koskovich <akoskovich@pm.me>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: crypto: ice: Document sm8250 inline
 crypto engine
Message-ID: <20260310-tremendous-vengeful-wapiti-8d9a39@quoll>
References: <20260309-sm8250-ice-v3-0-418bf5c5c042@pm.me>
 <20260309-sm8250-ice-v3-1-418bf5c5c042@pm.me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260309-sm8250-ice-v3-1-418bf5c5c042@pm.me>

On Tue, Mar 10, 2026 at 03:12:53AM +0000, Alexander Koskovich wrote:
> Document the compatible used for the inline crypto engine found on
> SM8250.
> 
> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)
>

<form letter>
This is a friendly reminder during the review process.

It looks like you received a tag and forgot to add it.

If you do not know the process, here is a short explanation:
Please add Acked-by/Reviewed-by/Tested-by tags when posting new
versions of patchset, under or above your Signed-off-by tag, unless
patch changed significantly (e.g. new properties added to the DT
bindings). Tag is "received", when provided in a message replied to you
on the mailing list. Tools like b4 can help here. However, there's no
need to repost patches *only* to add the tags. The upstream maintainer
will do that for tags received on the version they apply.

Please read:
https://elixir.bootlin.com/linux/v6.12-rc3/source/Documentation/process/submitting-patches.rst#L577

If a tag was not added on purpose, please state why and what changed.
</form letter>

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

