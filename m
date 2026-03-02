Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3409B3FD13D
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 14:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772460921; cv=none; b=da9UogIrFWFqxYcp3OcZA2AygLSEWDI3IGWPFtmB10jVluMc/k+7m0gD7lLPlWfpeHqQKrCo/ko+kPuKcgJQ6ChycA7oo6MJE4HG4JNqZ0y3/aU8V3LlZX4uNSxVd8dNuYpBqmldZg0Vkwd/WUE3p8ILaDE8gfX1sxbjJ/pa/do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772460921; c=relaxed/simple;
	bh=MRsB+ggb9gY6OTnRsgy4soOGBpDiwxz0KPu+0ZYKyS4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=HqVuMEN3vEQoqUgJaCPl0aUv8uJYi/KmJ1lp7maYz6Ep3t8caAYWCOcAmXMe9ZOJ1uh0QK+sa6haxDUigaSDRRXVQnhqPuM8uAtF/UILhMDJGjR9chh6aVgX9K/yrtLGU/aGWJxyTYkuH8fDWL03Ok6bc2dPYzC+RbcPAtlZH/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZYFf1xaj; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZYFf1xaj"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772460908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7s+ZulK9w2XgyNuxI+xCHbmVgtE2eA3P4tLtW8NCy2E=;
	b=ZYFf1xajMxKVCniWPHlKnuWaSfG0ndZ7M1ifSQ9fG/pIAngImahqbQRGpeBreH9yBQYoKr
	YpUGSIR2JIvuDt2kqWmp77JWoEkMXOaCfqYX/L/okesrgAVaFiksLKKSOPY1B5t9DjoNpl
	HGMGT2FxTZKAIo97ZdInDWsp8V8KTjo=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: [PATCH] crypto: qce - Remove return variable and unused
 assignments
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <68c63578-ff12-4f4a-86a0-212c2a6adfd6@oss.qualcomm.com>
Date: Mon, 2 Mar 2026 15:15:02 +0100
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 linux-crypto@vger.kernel.org,
 linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <380D92D8-9451-408C-B9D0-C2A46BB0F1FC@linux.dev>
References: <20260302113453.938998-2-thorsten.blum@linux.dev>
 <68c63578-ff12-4f4a-86a0-212c2a6adfd6@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Migadu-Flow: FLOW_OUT

On 2. Mar 2026, at 13:47, Konrad Dybcio wrote:
> On 3/2/26 12:34 PM, Thorsten Blum wrote:
>> In qce_aead_done(), the return variable 'ret' is no longer used - remove
>> it. And qce_aead_prepare_dst_buf() jumps directly to 'dst_tbl_free:' on
>> error and returns 'sg' - drop the useless 'ret' assignments.
>> 
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
>> drivers/crypto/qce/aead.c | 12 +++---------
>> 1 file changed, 3 insertions(+), 9 deletions(-)
>> [...]
> 
> This could be made much better with a DEFINE_FREE()

I'm not sure this would be an improvement given that 'sg' points into
'rctx->dst_tbl', which is intentionally kept alive after this function.

Thanks,
Thorsten

