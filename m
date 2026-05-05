Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAAF30DECE;
	Tue,  5 May 2026 08:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777970866; cv=none; b=dX1MLfdR8WEku4shskZKHkjo96yZCm88e5pkvdXCf7i28zwE+CKA+966OZYOttKbyRidudOJUl4b9/6lVvXMJERb40Fj2v0thvh7bjslxI1scdSHgkpByGHFjQh/HDse+HTZFCjjVVfBS6Xy5e7jfoiZm41y9n3nEb5npxEnxeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777970866; c=relaxed/simple;
	bh=6woaXkWn/UyXlX6O9ZWOlm6riTCzBCqgY+XIFBYNcRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z0gQlYHo0/xRq13nuPqoiYszYKk2AKsEfGMKABoLagmG6/LxaRlQjHGPu+pSAWCE99cHyeTqlDR3ilW1FxgqmkRFwkUgLzMC8KisEw5WOgkKtbu6KvPnHIb+UsNqCyqUBGs5FNTk5T6YsI25YXWIb5GZVf2oXY5bkvKnOGlN8ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qtkcsVFS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qtkcsVFS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=q6ogfR9XsZzxV0IP4o2qM+ST0JG04Rs+HVzk7P2dQG8=; 
	b=qtkcsVFSYOjHl7ej7wmSnOHZAVgTiPZbKTks3hgxLMY6ozgjPFOsjcRY76kdowoTK/a6UGU6hPL
	TKet62ncykzzjF6KPq9kKoIABYBmWKs4AD99MvMOwGtzQ8NgZZBIXfZB2NIT5RqL+Tdixx8T4F4NI
	SZrvyJ1khkJAwI2dCrvYF9gYCcIHm58qjNclCGwSXZ5UutaeVeIE9qgB84p1+GahP2+SHQPRmrhge
	nw/6jOw2ytuiHxjoaiZtF7gUT4h0lqob0keDR9rpiQ51aMDQZENu1ZNTIBSGqmCCkIjMwUNTmaabO
	EOc/N8uzdOfDmppYehC0nI1NCzgEddgIYOFg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKBR7-00BN4l-1C;
	Tue, 05 May 2026 16:47:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 16:47:25 +0800
Date: Tue, 5 May 2026 16:47:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	cros-qcom-dts-watchers@chromium.org,
	Eric Biggers <ebiggers@google.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
	Bartosz Golaszewski <brgl@kernel.org>,
	David Wronek <davidwronek@gmail.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Melody Olvera <quic_molvera@quicinc.com>,
	Alexander Koskovich <akoskovich@pm.me>,
	Abel Vesa <abelvesa@kernel.org>, Brian Masney <bmasney@redhat.com>,
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
	Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v5 01/13] dt-bindings: crypto: qcom,ice: Fix missing
 power-domain and iface clk
Message-ID: <afmuncmBrrvddHTU@gondor.apana.org.au>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
 <20260416-qcom_ice_power_and_clk_vote-v5-1-5ccf5d7e2846@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416-qcom_ice_power_and_clk_vote-v5-1-5ccf5d7e2846@oss.qualcomm.com>

On Thu, Apr 16, 2026 at 05:29:18PM +0530, Harshal Dev wrote:
> The DT bindings for inline-crypto engine do not specify the UFS_PHY_GDSC
> power-domain and iface clock. Without enabling the iface clock and the
> associated power-domain the ICE hardware cannot function correctly and
> leads to unclocked hardware accesses being observed during probe.
> 
> Fix the DT bindings for inline-crypto engine to require the UFS_PHY_GDSC
> power-domain and iface clock for new devices (Eliza and Milos) introduced
> in the current release (7.1) with yet-to-stabilize ABI, while preserving
> backward compatibility for older devices.
> 
> Fixes: 618195a7ac3df ("dt-bindings: crypto: qcom,inline-crypto-engine: Document the Eliza ICE")
> Fixes: 85faec1e85555 ("dt-bindings: crypto: qcom,inline-crypto-engine: document the Milos ICE")
> Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 35 +++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
