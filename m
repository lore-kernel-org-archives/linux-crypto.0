Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6869C258CD0;
	Thu, 21 Aug 2025 11:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=183.62.165.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755775820; cv=none; b=SiWWapSHuVR+XMVU5Md76hYVDXFNaH3YFWwWMAttmDQDJAj1mkw1vM+QZubv2aJwjn21EW9drD2rRtnCo2dvTpm+agq5HyXcZ/7sNgaATVe7Gfe10Bw/ASBPyZ6Y6qIF1nOg9c2QKY9XG93i5BXBEdscZd3bvhBielMPKvEsWeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755775820; c=relaxed/simple;
	bh=fNug6B5FoOaSLfqlAeWf06gl4eEGZSzrkjdUpfMujl8=;
	h=Date:Message-ID:In-Reply-To:References:Mime-Version:From:To:Cc:
	 Subject:Content-Type; b=gMpbQ40vKlYCyqNS4kN7146qT7BrJJHDhkdaBNNuV+TiBHYcPksDaonvanH7ZfRu/LanAIToC9X+qjjrrtsk6zyKKKu02ViYnfYir7KTm9vEgDQOoXsCrIRpSop7Pi9idcTz2YK2SkeO0pbDa4oyMF/o7FItPx7qTsQ5Bu2mZfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=183.62.165.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4c71MJ06Q0z51STh;
	Thu, 21 Aug 2025 19:30:04 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 57LBU1Ct009865;
	Thu, 21 Aug 2025 19:30:01 +0800 (+08)
	(envelope-from zhang.enpei@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 21 Aug 2025 19:30:04 +0800 (CST)
Date: Thu, 21 Aug 2025 19:30:04 +0800 (CST)
X-Zmail-TransId: 2af968a7033c7da-5c409
X-Mailer: Zmail v1.0
Message-ID: <20250821193004046sayrVSp4Q5CxDjeTGN2EF@zte.com.cn>
In-Reply-To: <877014b1-90f1-4bbc-8a42-37d07b15d760@nxp.com>
References: 20250723105027140oF4Bwli1JuZcQ0V5-7pyK@zte.com.cn,877014b1-90f1-4bbc-8a42-37d07b15d760@nxp.com
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <zhang.enpei@zte.com.cn>
To: <horia.geanta@nxp.com>
Cc: <pankaj.gupta@nxp.com>, <gaurav.jain@nxp.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <christophe.jaillet@wanadoo.fr>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gY3J5cHRvOiBjYWFtIC0gc3dpdGNoIHRvIHVzZSBkZXZtX2ttZW1kdXBfYXJyYXkoKQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 57LBU1Ct009865
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: zhang.enpei@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Thu, 21 Aug 2025 19:30:04 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68A7033C.000/4c71MJ06Q0z51STh

Thanks for your review!
I'm curious about whether this patch could be applied or not. If it could, when will it be merged?

Regards,
Zhang
------------------Original------------------
From: horia.geanta <horia.geanta@nxp.com>
To: Zhang Enpei10344075;
Cc: pankaj.gupta <pankaj.gupta@nxp.com>;gaurav.jain <gaurav.jain@nxp.com>;herbert <herbert@gondor.apana.org.au>;davem <davem@davemloft.net>;linux-crypto <linux-crypto@vger.kernel.org>;linux-kernel <linux-kernel@vger.kernel.org>;christophe.jaillet <christophe.jaillet@wanadoo.fr>;
Date: 2025/07/25 16:01
Subject: Re: [PATCH v2] crypto: caam - switch to use devm_kmemdup_array()
On 7/23/2025 5:51 AM, zhang.enpei@zte.com.cn wrote:
> From: Zhang Enpei <zhang.enpei@zte.com.cn>
>
> Use devm_kmemdup_array() to avoid multiplication or possible overflows.
>
> Signed-off-by: Zhang Enpei <zhang.enpei@zte.com.cn>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Thanks,
Horia
