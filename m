Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201033E49E9
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 07:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335721; cv=none; b=r8NGz2icZftPTCDIggJBeLxBl+//cBm76iITjPCfB6vDy0Si2IIJ/mMLxBDcwe2GJOfqgix5t1uDo/rxstwidgPc5ejvavRGhCXV0hehnQmxn80PJ5GQCW2z/2BrBRFwG9r/MKVT1kDzc8rA3FnIR9PXf/UwCLVLCNvQkOtzzq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335721; c=relaxed/simple;
	bh=LqmhBA2Uaqj96r7IoqhILAq5dspdgOGcSa9hyKEtVSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dFJe5Sa5jtciJsAUI75kUwMe/K5wtkmXAZY7mfJivrBjWLq0ks17NugBrUqUY/nq7L2vAP+lXVfvuAMpq0LGHQVYErFD3JI2tge7uPuMsjYq3vEQfd8kIwCx1RhFApiKWcPOp6S1weDNoCI0QUvRt7ZInIGeEeXvKpDELT6pYaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jnd9SLym; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jnd9SLym"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-484415c8bf2so609508f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2026 00:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788335718; x=1788940518; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6YX0g1ltOeVRJXePTRjTJXJYLcoS+wQGBHQ9Rhr0r0g=;
        b=jnd9SLymUfbnTIvOXekvWtxAKvJ+p84oG/hHo+EX1YZkWYmbNQ3SIGJkIfSDFh43Y1
         z9F5uIp4TV39aFT1R52bQ2yl8XOkO0Jtd+IB/aYjpUSNGRvGf+rAogncAGoOtA/xBbKI
         98/hCtbrzraUX1KA7/zJvglLQ/R93mvnsAdKmfr10CltQfYz7Yq/PcLLUiwMRTm2Ktgw
         pcVqe9MsN9i+5e2JjF2gcfyj7NMbOclTNk0+I/9EMpkbBHpS4K+wBw3EARNzuHidGZyF
         gsba11uQnjLt6vrmU3rPY0dXjJxxA+RZAIMNRJOmyF//Iw1GgfnhHRz/0N4HsdLCsGvq
         8uEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788335718; x=1788940518;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6YX0g1ltOeVRJXePTRjTJXJYLcoS+wQGBHQ9Rhr0r0g=;
        b=aIKVT4jLhjprQxQWwyFQJhyh2Y40ISkEJ0JzvphRIYcnXp1zQ0x23AdVeYYzuDbNq2
         eV461EVhVLHble17Ag2X2//us0ovfIC1gRI/cdF6G/JofhhE7Rs4gpXQZhLrgEydM3gS
         s3//pRMBTUgbHQZ0L3zousIoB/eui4wk777mGPJtGhTETJDP+SjlKKvG4AHGROJbYl7K
         yyaTkseN9CfExedCGoP7+NG6R68FhBM2WBvr6UqMr9WA9UPh7h78pZPqFNGMiIpdEQw5
         zHEQHIAb7Suh+xORUp4ta9dTZEQHLd328SpCFS7juWjbNkN7tj0IcifbFRZbcpDvkNnF
         fWmA==
X-Gm-Message-State: AFuF++nf3aLTbAyejlqlr4F+r+vGMuT0P8k6STNCmUkHrWCtFrHsbau1
	iGEvby9jneXMQRAgzpV+VnTf224hanpFERRNHRGMhrKxTLZFRUBMEuOZ
X-Gm-Gg: AYBFou2o3YhGKySCTpGO17dj8A/5akfBeMy7k2ogluUx0dYWzu3JVIYaEeJEnS+sU+i
	gFd84KnwSoULCoyBeIoVFoeu5WzSjzV60rXidplWv01Txdf+IXMqb9U/sr7IBzgFJMC4e+ZvUJu
	/UXavsu+sd3FBRTYo3SQoD3i9e3e1XM/4THgnMdMl6HR4KA+WK6US5gvngaUNBEgpTGf8L0NZ5w
	/YFrZowXNaH2ohn3w+Vxtr2dnSbLt6Au099zasvlPq6zQEK/vfMsLbKhByOeTSSHV8Dzn95ZZaU
	tnobBvUdj1MH8fmGQ6jztuW/1YTqrY8iT0DpBTaMrTVMUCXkeeJgQIB1Qfsv90VhDW8TxNy/RRI
	I4/NnQDb5BRIPG5ldum1rBuqC06Lt9oExmszazN5NyMvveAPbRu2A/obMIZgRk4nGHTXwem+Tbv
	d7UdU348RrVkyQjKyqEmJ5Y2/aVOorjMo+wZmyU0E5RhjfjHWsDWv5wQWu146Z2kER97p9m9dZ+
	1GA5RdentphVxHBXthXzMEUJ8Q4cDADw/o0TRVEr90e1eiKdKwApwOw
X-Received: by 2002:adf:e196:0:b0:482:e451:6810 with SMTP id ffacd0b85a97d-48488dee050mr5700746f8f.1.1788335717956;
        Wed, 02 Sep 2026 00:55:17 -0700 (PDT)
Received: from [10.0.1.42] (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch. [83.173.201.248])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448ed30c0sm4797705f8f.24.2026.09.02.00.55.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 00:55:17 -0700 (PDT)
Message-ID: <fe9a266d-695a-4379-9aaf-8ed9ce02efa2@gmail.com>
Date: Wed, 2 Sep 2026 09:55:15 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] crypto: caam: map job ring registers without claiming
 region
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, =?UTF-8?Q?Horia_Geant=C4=83?=
 <horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>,
 Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 open list <linux-kernel@vger.kernel.org>,
 Francesco Dolcini <francesco@dolcini.it>,
 Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
References: <20260901203736.13248-1-rosenp@gmail.com>
 <20260902061059.GA7187@francesco-nb>
Content-Language: en-US
From: Emanuele Ghidoli <ghidoliemanuele@gmail.com>
In-Reply-To: <20260902061059.GA7187@francesco-nb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/2/26 08:10, Francesco Dolcini wrote:
> + Emanuele
> 
> On Tue, Sep 01, 2026 at 01:37:36PM -0700, Rosen Penev wrote:
>> devm_platform_ioremap_resource() ends up calling request_mem_region(),
>> which fails with -EBUSY on i.MX SoCs:
>>
>> There the job rings are modelled as sub-regions of their parent
>> fsl,sec-v4.0 register window, and caam_probe() already reserves the
>> whole window exclusively via devm_of_iomap() before the children are
>> populated.  Every job ring therefore collides with its own parent and
>> fails to probe, taking the hardware RNG offline (seen on i.MX6, i.MX7
>> and i.MX8 boards such as colibri-imx7 and verdin-imx8mp).
>>
>> Map the job ring registers with devm_ioremap() instead, which does not
>> claim the (already owned) region.
>>
>> Fixes: 9a955c0a7d11 ("crypto: caam - simplify probe resource and IRQ handling")
>> Assisted-by: opencode:big-pickle
>> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> 
> Reported-by: Emanuele Ghidoli <ghidoliemanuele@gmail.com>
> Closes: https://lore.kernel.org/lkml/20260901194524.908240-1-ghidoliemanuele@gmail.com/
> 
> Thanks,
> Francesco

Tested on colibri-imx7.

Tested-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

Thanks,
Emanuele
