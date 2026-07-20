Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853C14071E4;
	Mon, 20 Jul 2026 17:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568077; cv=none; b=XZRZUiStogCilblOLSMVwiih9hpSfakV7h0H+HnpMv44RaatzGzeEF/syO30GoYPh1AJfBmzPqpM6S5s1qjKQaUnT7GnXltqG3LCS2ZkH4LmhrzIe9yiMAFf72sWNcExiWcawpHr58LWqA4zQeAhB9c6mKzrM8aSBQn1y7J4Z9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568077; c=relaxed/simple;
	bh=NpjqvR5iMF/T4h2ZSD8K8PW5WBE2D1Rl8R41msRGgqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSJqMH+g0xoE7z7Ovootdcr3zsEV1t+xiPSUFO0HlrDjL6031VMlo0ArvN+3t+iAXWoS/UY2cjJhhwQTNw594kn1ABI0wnBThnSd3v2a0JMTDOprqLmUDYIdoNIdsobPfLA0gxZinMRvUzPZldAPq4wn7xpwc8y/7Uhp6ZvTDVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xwy6zCvA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xwy6zCvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1B81F00A3A;
	Mon, 20 Jul 2026 17:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784568072;
	bh=SGtCH7mIfcIM/1qkGvsi7yUip9RKdC9Pt1BJ37nWdi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xwy6zCvAdzF6J8grXogsrMzsaWmXIez9yS5g4drrlnLnPac46jcwZSMgZ5ovV+gW4
	 W7RFBKW1bHYMyw9JvnrGfFdZ4ntkGH7hyggVHYte4njYCfx9MjXaM8IiGs7aw1ccHx
	 /C2F6XI20CdWl//Lva7bcka9f5UUnSNHjy62EZ2k43yNrgS7l5jY8wSCYsmKhB5uUz
	 UHbXmsEvMxJbpwjWm1yRZnHLlN8gEKi5Kiwn8JtgDHQJlAHzGJ3F4qvsBYIkcn/ZMc
	 AQLkcLWDzL041Z3APtb4gX/Uu1sEYgfQ6ud59D+Qsd1VULv/wS177yt3jYYWVmq567
	 j1VFONlsm3hLw==
From: Bjorn Andersson <andersson@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: (subset) [PATCH v2 0/2] Add TRNG support for Glymur SoC
Date: Mon, 20 Jul 2026 12:21:01 -0500
Message-ID: <178456806282.1732507.17127203162851359741.b4-ty@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424-glymur_trng_enablement-v2-0-0603cbe68440@oss.qualcomm.com>
References: <20260424-glymur_trng_enablement-v2-0-0603cbe68440@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 24 Apr 2026 14:05:06 +0530, Harshal Dev wrote:
> Document and add the device-tree node to enable TRNG for Glymur SoC.
> 
> 

Applied, thanks!

[2/2] arm64: dts: qcom: glymur: add TRNG node
      commit: 5d7ebb1f36ad8a51f4e60819a8c5bddf04a8d1a2

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
