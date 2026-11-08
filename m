Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794169516;
	b=2+0JV3ZBtmPwGAuRYApM9kMy5GzdbPa80DpH0aEZPoQ6VvOYQimPucRY+O5jGkM4fTe0
	 mZyH+iG3KDU9vt9zopZJtZNgfYnTkVqF+daplhwYI6g5hjAkGkxdbRPKEFILNPMFDwwyV
	 YUI6EehLultwW0K9n02vrQiwMRYLDhPsJKjV2cQJfSCQ9xNz1UvqF9zTaipadU6IDf/iT
	 uRvrpZriMhz0hEn9uanFr/3DRTdx4b0ggCGcjBcrIIYewMvuW8HrrMrkG5Ol7+q+5ZHH1
	 6G1dlYm70LLuItr7m9h8tDW0wJ5CoM4tw6Zl6QyEbVo6Y2foRfACpMY4DCjwibcZw0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794169516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=t7cY+6NWmVienmp1bdnCVZgC3Mp13pEN4ebodHzuBiY=;
	b=eLqHDk7XFr4AobOUK1cVzXRvQ19rx9Lb0/gPwSFVacwcWBLgzP+wIqaVcsCmX1iDrjg4
	 gxoS6ppnFkTSrLYethqWPz3FuoQEc0SGKZGuCjsI1H13vImqAFyR/7qHywsmS3Ovf5a65
	 fxmyXLg2EXzAHlKT6h3csxWTxF0JF1oUiBXO8cwScMxgUPxwriW7y/2UZj9NO/pCQQIap
	 7iXljNxGjVp0Qq4sKcoB73ZjIfNtRwhGDEGFAKCU30+HyWlR9LRCnvkuqIoLfW0hN/bKR
	 q/dcH5742NHtdm31l4embTEeNrr4aI6SaszX32eXgPbkYukm8rl2TJ8MAUqkmhYHYuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZbOmQm0U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2C360826EA;
	Sun,  8 Nov 2026 20:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZbOmQm0U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6FC1F008A3;
	Sun,  8 Nov 2026 20:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794169516;
	bh=t7cY+6NWmVienmp1bdnCVZgC3Mp13pEN4ebodHzuBiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbOmQm0UzhPn/3GG7XFoBoL8oK+I9MQFevClJ3w1MPJXr0vvgbNGpxKeHNWtx2xS2
	 bV4LMIM5TuuJWYele+i73Mk51K6VX8mpSFYcLbUJCWMObc++/0N3/ezYIULlqJbueV
	 sZ/PEc7377wskeY2vQSRCTmGuc9Sw+yTZ/mdKcX7zysW/cFQXt7qW5HZxv9WOqwEQq
	 cISusoGw6hH4nfpDN2CcEYhOH3aUK+aXrBYk6UeMtY8o3n8zXBeqchw+mD1JePSFHW
	 42/qfVRN3pmZqwc8znVf2HG266aqBqaG17UMzoofYve948tx/kgS3dYXLrsi41sNKQ
	 COGQOY+hE7t/Q==
From: Bjorn Andersson <andersson@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH v3 0/2] Enable ICE for UFS on Hamoa IoT EVK
Date: Sun,  8 Nov 2026 14:21:36 -0600
Message-ID: <179416929216.628393.6105568062871758017.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728-hamoa_ufs_ice_change-v3-0-293c7c6c2ae5@oss.qualcomm.com>
References: <20260728-hamoa_ufs_ice_change-v3-0-293c7c6c2ae5@oss.qualcomm.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 28 Jul 2026 17:53:54 +0800, Wenjia Zhang wrote:
> This series enables the Inline Crypto Engine (ICE) hardware for UFS
> storage on the Qualcomm X1E80100 (Hamoa IoT EVK) platform.
> 
> The ICE hardware provides AES-256-XTS inline encryption/decryption for
> UFS storage, offloading cryptographic operations from the CPU. The
> hardware version on this platform is ICE v4.0.1 with HWKM v2 support.
> 
> [...]

Applied, thanks!

[2/2] arm64: dts: qcom: hamoa: Add ICE node for UFS inline encryption
      commit: a4de07fca934ea5de6ddc0eee4ea5bacc60aa0f3

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
