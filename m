Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC8C38F82;
	Tue, 11 Jun 2024 18:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718129619; cv=none; b=Hm+PjCGjljXNfzXnIgR27thL9MZaNQQJpUGv+42dQk+8DVkrBR4gbuoC1EJkzEAtR3FSoeu8XQYIZWwbrZLSqd6P9q4qkKRRCZwOpYYuWqHEjRvAbX4kEaTogco4y+VbLF/rhjPNcqkN3aEG53QfGgmSbOx3WkennyxrmQGX/7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718129619; c=relaxed/simple;
	bh=WMZEecGmsRbydV76P/ndWlziO1STDjwqhlh342cdkC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ub6LeH+563+jLYVWUll5E5C7XoPrbM1jpFmzjj/F+DNRWZHeX0UPOLPVFjYBuk3mRzDtK9kBbzI8/ZFPya80ZPO+kC6RF+uYA3SkYpv30vsRpz1yT9Z4rNEo4JSH+s9XnHp0cxqU+w+4wHIGxCi4dWh8RMd4wqGCkIzmmUKmB7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZjNJQPfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZjNJQPfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E7AC2BD10;
	Tue, 11 Jun 2024 18:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718129618;
	bh=WMZEecGmsRbydV76P/ndWlziO1STDjwqhlh342cdkC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZjNJQPfnnlY+7DwulxkilCEhNFCxOPzIrcAc86JJDifNn9NtycuEsN+nqnIeQYGhm
	 dFc/QQesztwI4h8QVsA6x11G1C1dWbg+nTEtrkWoqKVU9QEGSUJDWPCP19E8oB4n87
	 ea6SZ5lYjujkVyXwGX8CHyb//MvUbXOEKz1c2s68WOImcFYYnATmHf35Masf2R8gmk
	 j6PErmq3TIjE5PP2VC/MSnP/PCjROxdgS0g/cH3qPbLeZdpaIjKmVhpHt1BcNhvHTe
	 nN8177/AAdwP+JnzIIXtLPEuV/0oKIU0fT7xbJerdrQ6AZxEV3R2T3uIAvLEmHuMDL
	 PANTYI5E7nAbg==
Date: Tue, 11 Jun 2024 23:43:34 +0530
From: Vinod Koul <vkoul@kernel.org>
To: JiaJie Ho <jiajie.ho@starfivetech.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
Subject: Re: [PATCH v4 5/7] dmaengine: dw-axi-dmac: Support hardware quirks
Message-ID: <ZmiTzqcQpuUgYJsI@matsya>
References: <20240305071006.2181158-1-jiajie.ho@starfivetech.com>
 <20240305071006.2181158-6-jiajie.ho@starfivetech.com>
 <NT0PR01MB11829BA51E18082DBD2976998AE52@NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NT0PR01MB11829BA51E18082DBD2976998AE52@NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn>

On 08-05-24, 02:12, JiaJie Ho wrote:

> Hi Eugeniy/Vinod,
> Could you please help review this patch?

Can you please repost

-- 
~Vinod
