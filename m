Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A402D29B78B;
	Tue, 30 Jun 2026 17:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782841298; cv=none; b=s72scZdnuWPb2xGT+6brY9XnDRZkNcy/0vjva5IGrBT2bViXFdcrWaBySC9nGMIXbiPefKA1SdPUcrZGTLx2M+8YZxqNOOb0Zp0QLydtxst1uEaK/jtwBjMuEXfpbjpQsMvFxxrPc0ZhSYJsWyasxYU8QJKWCYCNTrpPGzI/t3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782841298; c=relaxed/simple;
	bh=7etjsaTTGVz3MLkhX5I1xB14qcjJmoJHvrsKoUBG60M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=poEnMxz13RoJyxCBWPMhA8uRqZdxVpFh8Ta4/8W6aP/u1jBQPm0zon7pgPJScjYdnEC8cYiecczE4W2ETsJDnLl6hQk5+suNpiymDy8H+sP+e6G8Ps4BNr7TwEbuCH495FdMoTDHzygVnqSamKnfP+q4CqoCAFVXNtxUl008+/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BEl7IIMu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BEl7IIMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F001F000E9;
	Tue, 30 Jun 2026 17:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782841297;
	bh=9sqK9XNlmuYukWWEvxI9I5lAhBvud4djFlqzseQ6qsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BEl7IIMuhuVsquoGPJb4qOjmiRFI/GjgT9TjWsmg7mdOODJZ4vHG5s6S3Cy1jgNTk
	 gH3ed75ZVI3GAe4XRJnxKiXBwFSP3QDfm5iJ/J3/9wb4aTV8EOErPI4Uv+pSIoFBHp
	 PpxeYDpPWl4OP/CFsfycrK9bZUFZww8YbGnqev76r62/87uUtxoi3xelrp/ScK2JDp
	 J4X1rBFCAk0G3w5waa2HHpmO2kMbqmJZmiTRj4IWAzax/W/ijEQ7Xgn+fGsBYuHh+R
	 kNcOFz2Bw9APCOSE/McAW4qRbh3+hNfNjifK1+HFE+ECRXHmEUg+tanOt9eni4kgJH
	 5A4fZtGjSThPg==
Date: Tue, 30 Jun 2026 12:41:36 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Cc: aiqun.yu@oss.qualcomm.com, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
	tingwei.zhang@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
	trilok.soni@oss.qualcomm.com,
	"David S. Miller" <davem@davemloft.net>,
	Vinod Koul <vkoul@kernel.org>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bjorn Andersson <andersson@kernel.org>
Subject: Re: [PATCH v2 2/3] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Maili ICE
Message-ID: <178284129608.4118791.8314319261114374881.robh@kernel.org>
References: <20260628-maili-crypto-v2-0-f8ce760f71d6@oss.qualcomm.com>
 <20260628-maili-crypto-v2-2-f8ce760f71d6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260628-maili-crypto-v2-2-f8ce760f71d6@oss.qualcomm.com>


On Sun, 28 Jun 2026 23:44:36 -0700, Jingyi Wang wrote:
> The Inline Crypto Engine found on Maili SoC is compatible with the common
> baseline IP 'qcom,inline-crypto-engine' and requires the UFS_PHY_GDSC
> power-domain and iface clock. Hence, document the compatible as such.
> 
> Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>

