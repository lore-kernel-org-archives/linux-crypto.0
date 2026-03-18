Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD4633D51A;
	Wed, 18 Mar 2026 07:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773818621; cv=none; b=ctLpfRFGqi7y70A4JKFAMNa3aeG6qKChnYZPbeUCKhFXur9TmLxzLv6UlCpPy0Smt2OtbhgDWY35AM2t7B6Fu9VPT2ODOq59ZOGiE4EohyU78z+wU2kgrxnKvg0FiHlQWJFkE27H+dsuD21IqH9MOA/jcIVfflkIDnBe1XwEh5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773818621; c=relaxed/simple;
	bh=8x3R6CPVmYSGqUqKR4h+TrEwQ00ToVuASvd1V4yQWq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QlRFKJQiN7sFNyRjR4AnCaSg//g1y+xR1tYMgniwm4oJ8MHPDMeWNZr9PJ3om7+JtDG3aiDbWy5gL+66tuVRdQgwN+ZgpyVc/acYDVpicgmUSDH/pXOc82oX2Ii4dt3e0Tp7jB6GOc2Ej/oj6MGFKsLr/pCYbS1I/GT0hf2IPOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+FLb60z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+FLb60z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF5CC19421;
	Wed, 18 Mar 2026 07:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773818621;
	bh=8x3R6CPVmYSGqUqKR4h+TrEwQ00ToVuASvd1V4yQWq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j+FLb60zqC03P6hrElwRbO4G6kYgmJ+iatkjUax2aDy49YJmRoiigsm65R21WZv3w
	 gSg8GvioEV5kRoX3uqYsRg/kKmsiF7NMjXMvHRnCA7zgOuGni4fqZrLJ0My7pm97bX
	 t3j41PGrv5LFUnRMN9tjtQJMmDP/0qmD+g9jbiLg9BYLZqddhqXPR5BdvIace8APui
	 NpQn1KZWszq/W1PrtaZz5dUfOxgwGUHEUzZhDe5ZOwO34vZmfxaHElwOwN5ON3LWe7
	 Og+XhjSn18LBZ/jeijsWPyXv344iK5XQwE/T1raXuEJoGwQlvgBqu+YDrpB6kMrl97
	 JLXvlA+4arYag==
Date: Wed, 18 Mar 2026 08:23:39 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Abel Vesa <abel.vesa@oss.qualcomm.com>, Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>, 
	cros-qcom-dts-watchers@chromium.org, Eric Biggers <ebiggers@google.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, Jingyi Wang <jingyi.wang@oss.qualcomm.com>, 
	Tengfei Fan <tengfei.fan@oss.qualcomm.com>, Bartosz Golaszewski <brgl@kernel.org>, 
	David Wronek <davidwronek@gmail.com>, Luca Weiss <luca.weiss@fairphone.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Melody Olvera <quic_molvera@quicinc.com>, 
	Alexander Koskovich <akoskovich@pm.me>, Brian Masney <bmasney@redhat.com>, 
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>, Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: Re: [PATCH v3 02/12] dt-bindings: crypto: qcom,ice: Require
 power-domain and iface clk
Message-ID: <20260318-precious-qualified-oryx-ef619f@quoll>
References: <20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com>
 <20260317-qcom_ice_power_and_clk_vote-v3-2-53371dbabd6a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260317-qcom_ice_power_and_clk_vote-v3-2-53371dbabd6a@oss.qualcomm.com>

On Tue, Mar 17, 2026 at 02:50:41PM +0530, Harshal Dev wrote:
> Update the DT bindings for inline-crypto engine to require the power-domain
> and iface clock for Eliza and Milos.
> 

NAK, pointless patch. It makes no sense on its own and it cannot be a
fix for earlier issues, because as a fix standalone is simply WRONG.

Where did you emphasize this is the fix for current RC?

Best regards,
Krzysztof

