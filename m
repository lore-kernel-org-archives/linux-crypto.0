Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1777A15687C;
	Wed, 23 Oct 2024 04:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729656991; cv=none; b=dOPrxT2DImjv2LUgKBFEcPW8EeCbah3EqadHc3lvhnYOVbXWCYETfXA8TLnjrZamcBVTV3htsTe0YsTVpvrq/vvKjb8oGSG+gssNm98D6p3kosMwka/CvJj07EL9cO0f8rVA8sSyRhjn6D7uozIkc+hfzwpp2T99wSlX1zcoyAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729656991; c=relaxed/simple;
	bh=6V3ir9qX6Ww5o+c6Oefzfls5TqkWcrCBX/JxJBEn8iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LE8rpWeXSd3CWcXxu/LqP/iNjzy0fkOgCahxoFBTD3rRfAemDdcr2j0InJOju6G01j8OJutziObNapteOmtJ0CVBBG/BZ36+l7FX9vSeJweVUZmzZ3+Rp98u4ky86oO4b6fMRCY/CyFsaTl/+YyohE3BFJ6ZklfYnw7ayw1RrtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QNHJJWf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QNHJJWf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AA1C4CEE5;
	Wed, 23 Oct 2024 04:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729656991;
	bh=6V3ir9qX6Ww5o+c6Oefzfls5TqkWcrCBX/JxJBEn8iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNHJJWf1T+ZJuXyqpamaZMkKESblVB4Uvj16wyFiRzrNtP/bWO4pQxHIqckoJPArU
	 9H7JZvPP6iAxdowLn7F+HHlvJ17WZD+xuoxLqJhCjlW3Vt9Q6LFJmSQB5OTNXevfmE
	 +t4BqAVRCdNLV1eCDCfebWV3R/j2/JjWcEXQDZ5N9kVG+ZcF42RDsWwio69h5a9wZN
	 t4ITPQBLngdo2sIrzkCoBo10im1w3zi+Y9/+E3LQ99Or2Li0ynwuh3scnUrxDU43tz
	 9TJXadLY0qf7wqLJqjzwetdPTt0jcsA1xmitW45G1bxugD8T7SIupHdiPmtqkhhDko
	 JePH1tm8iS8Zw==
From: Bjorn Andersson <andersson@kernel.org>
To: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Yuvaraj Ranganathan <quic_yrangana@quicinc.com>
Cc: linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	quic_sravank@quicinc.com
Subject: Re: (subset) [PATCH V1 0/2] Add QCrypto support for SA8775P
Date: Tue, 22 Oct 2024 23:16:06 -0500
Message-ID: <172965696401.224417.15857728120662303586.b4-ty@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241017144500.3968797-1-quic_yrangana@quicinc.com>
References: <20241017144500.3968797-1-quic_yrangana@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 17 Oct 2024 20:14:58 +0530, Yuvaraj Ranganathan wrote:
> Document SA8775P support for QCrypto driver and add QCE
> and Crypto BAM DMA nodes.
> 
> Yuvaraj Ranganathan (2):
>   dt-bindings: crypto: qcom-qce: document the SA8775P crypto engine
>   arm64: dts: qcom: sa8775p: add QCrypto nodes
> 
> [...]

Applied, thanks!

[2/2] arm64: dts: qcom: sa8775p: add QCrypto nodes
      commit: 7ff3da43ef4453a6295bf82cb942168414043119

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
