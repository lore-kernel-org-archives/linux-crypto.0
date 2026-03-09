Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096F138F941;
	Mon,  9 Mar 2026 12:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773058854; cv=none; b=mYn/W0rKz3Yuq2pOmNUoaKgk6Ln9xaKM4ETa74mzMV+GpT5wF9t928LH53LfPmn6u34LSm41emXEgVClJFUC3hC2RLQAGflAABd+0lCofPp8fclD4WadN64FJAWUUfxqiLpes9Au/s/tgYi8WzWqmO3F+k95evXqub9r8B1Gsow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773058854; c=relaxed/simple;
	bh=fL3hLVnTFB1ULsWHX1c38wG7D5BZu0jsxXjZxMC9DHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+ArwJKeXpZxJK/F8g0PNSUtDxzAtpWUNvdtKSr/b/zJZyXeCvV9kvEQ7zXuNGSJT0Aknr/91w2XM+OVpCkkHzkVGMFeujuEByoJXaITDbFby0pzquzxhYSlw0hPnrbvJsbzeN0vhoIXs45NtWxL/mbjm7NrBNcFwOt8gGoeQPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeoW3o/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeoW3o/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A243C4CEF7;
	Mon,  9 Mar 2026 12:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773058853;
	bh=fL3hLVnTFB1ULsWHX1c38wG7D5BZu0jsxXjZxMC9DHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PeoW3o/Gov8/ZSTsI0rXXDkBR70WIdoWPz0gxW6lA+51RkHnpAKsejEo9Vrlyw2II
	 IlFH+AIC/uh6SqmxgMDXQfl65RTkHF5D5arAbzeFSu0s0QX7+Z7uljrLiJ8L5y8plu
	 Az2ypS0GzM2l0WIFcqo3HBUqAmC0NMO++Rtn05J6ztKR3FWfNPkBlnO6FHOAWCk96m
	 QmtN7Dr5Xa6CPJfjnxyJ3Gi5nLZqJob+WhGmZLuLQnSher3Je0nLpeXm27C8SX3DAF
	 Wc+e+jOtb4iU5Isn6qHkTDPrdwlVBzUNS1roHpi20WhzItPbUPxWmTD1AixCj0/eiD
	 b542wsL9qvwQA==
Date: Mon, 9 Mar 2026 17:50:38 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Abel Vesa <abel.vesa@oss.qualcomm.com>, cros-qcom-dts-watchers@chromium.org, 
	Brian Masney <bmasney@redhat.com>, Neeraj Soni <neeraj.soni@oss.qualcomm.com>, 
	Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] soc: qcom: ice: Add explicit power-domain and
 clock voting calls for ICE
Message-ID: <4tq4cyc3m7eguydrvriiygsumzrfmqkrrm3pwieixivzx7fvle@kuemcabrb4xd>
References: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
 <20260123-qcom_ice_power_and_clk_vote-v1-11-e9059776f85c@qti.qualcomm.com>
 <vimd3tbnu4mr2uqporj7d4fv23aq2cb6e5een43yz5spe4u2xx@ufyzb2lzlc6j>
 <b32c7091-b2c4-443d-b58e-759b471f67db@oss.qualcomm.com>
 <4a76fuanyf45d56p64qmc7c3qcovbzt7jc27uern4lr4bchl6n@l6buzvakrrcg>
 <320ff1c6-34ed-4b6f-b0f8-db79a14b7101@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <320ff1c6-34ed-4b6f-b0f8-db79a14b7101@oss.qualcomm.com>

On Mon, Mar 09, 2026 at 05:29:34PM +0530, Harshal Dev wrote:

[...]

> >> As per discussion on the DT binding patch, I can do this once we decide to break the
> >> DT backward compatibility with a subsequent patch which makes both clocks mandatory.
> >> For v2, I am planning to continue to treat the 'iface' clock as optional via
> >> devm_clk_get_optional() API.
> >>
> > 
> > Even if you do not mark 'iface' as 'required', this API will work just fine. It
> > will get and enable whatever clocks defined in the DT node. It is upto the
> > binding to define, what all should be present.
> 
> Agreed Manivannan, however, I realize that for legacy DT bindings, where ICE instance is
> specified as part of the UFS/EMMC driver node, qcom_ice_create() receives the storage
> device, if we call devm_clk_bulk_get_all_enabled() then all clocks specified in the
> storage node would be returned and enabled. However, qcom_ice_create() should only enable
> clocks relevant for ICE operation, i.e., core and iface clocks. iface being optional
> for the time being as discussed.
> 

Yikes! This design is too ugly... But anyhow, we have to live with it.

> And so, for suspend() and resume() as well, it seems I will have to continue with preparing
> and enabling/disabling both the clocks individually.
> 

Ok fine.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
