Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFAE2DB794;
	Tue, 30 Jun 2026 17:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782841653; cv=none; b=kIVG9H0VFwCDISD4aSrToZMbrgmryAHes3DB7Hwxos4MI1LHlD7pdX4/BSDgw6YC+zbgMf+UoZM8ZYHhqRuw6urMRMc7RDzpPFy9xsf1hpPwBo6MofExX56leX4CxvBxIGhdw4Gq42te7u0xJn22cAkVaE+tTl/F9Q1pjcprk9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782841653; c=relaxed/simple;
	bh=XW4iUjVnb4D9jI5ydYsjbhP127xGVB6ghCda72WgOC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQze3ox6VEgX26rdvtoLsaQDgRk9pMdfuObleqdXecC2pHBdTgu6nrToeCG4W6INt2VIhMb1FlrbNpQwQs+/OS2+jml/+9wRq/PodWNILp0bBgdiqEZeP5tNhAfqwG5976lrqLfr3tFJ/eoXPmCwp3IJFFWggCEZqUGEUv/TASM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWfgRBmA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWfgRBmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE501F000E9;
	Tue, 30 Jun 2026 17:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782841652;
	bh=VludPtiNt/4OgEhY2vReMAGLmH75oM7QiBiAd69e6dI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EWfgRBmAO8mwpzUrAM/0wQhvMt2zhExXSzxpONmLn9SOCdddoZU6z3i/lvcofDgdX
	 MlRAfHMfN9TNIMUz666iPb5u+64KMLbAkgVqNgFnd7dpQOXUkB5PMXQg1v6hvPS7MR
	 Am3JpPp18e59yE5ePurzXhdgH6GdUf8Y91ZbQxXdNTULth3/9nlfeXUORBqcNOKM3I
	 TyQ0MsQHokXbDycjiT7W1JJ9y+7p/Liv7/JcVHDfeVhoUvbcu2/TykOs5/VcvqOKQg
	 SKDWqjrrTSyVJ0MgsIRdZKBfiC3lc52AAIb1lPKkdiUNQewEzdDDBtkVpU+mcu63mU
	 tR4rFLSu/AMkA==
Date: Tue, 30 Jun 2026 12:47:31 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Cc: aiqun.yu@oss.qualcomm.com, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	devicetree@vger.kernel.org, tingwei.zhang@oss.qualcomm.com,
	linux-kernel@vger.kernel.org, yijie.yang@oss.qualcomm.com,
	Bjorn Andersson <andersson@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
	trilok.soni@oss.qualcomm.com,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 3/3] dt-bindings: crypto: qcom,ice: Fix missing
 power-domain and iface clk on Hawi
Message-ID: <178284165109.4128424.1410136801617960222.robh@kernel.org>
References: <20260628-maili-crypto-v2-0-f8ce760f71d6@oss.qualcomm.com>
 <20260628-maili-crypto-v2-3-f8ce760f71d6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260628-maili-crypto-v2-3-f8ce760f71d6@oss.qualcomm.com>


On Sun, 28 Jun 2026 23:44:37 -0700, Jingyi Wang wrote:
> Fix the DT bindings for inline-crypto engine to require the UFS_PHY_GDSC
> power-domain and iface clock on Qualcomm Hawi platform.
> 
> Fixes: d273b258d8d58 ("dt-bindings: crypto: qcom,inline-crypto-engine: Document Hawi ICE")
> Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>

