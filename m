Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7062DC357;
	Mon, 17 Aug 2026 02:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786934406; cv=none; b=HBEfHY/4ZGAQKOLaRcSXphMjCTDIqBdQARMAnaKI94I95zRTxxMEal867hlxSZSTXfEMooJtGdh0LdkmxcZSLLDxVZOjqlA3m0fADzWQ95LZ8baHlBbL1h3x/sLDG4U5DUXn9f9eYxuin96StNn4kF2/teX+y164Wpu2rz0wIbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786934406; c=relaxed/simple;
	bh=2UeZ/HmWcIn45dTNZJADixPrwo37bD5fMjpuwoIULpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o8oLHxxWjlpk6eKQOaxXKWqO1fhikHxGMrpkVnp3Y5W0AhH7McZtXcGFn+PR2RFn29zFy3aiQQIpDMDE4u34MHo+9qDa08x4yEEERf+Js+gb+hJruvIKPhQzyz6e55jXbMEYDhMkMzM35PLSpe8VZKbj5x+pX4c16ATRloEJrvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ef552c3699e411f19a56ed5b684f684d-20260817
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:ec181b8e-05fa-490a-9f1e-5c2751423dbc,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:ae25eab65d99249cc23291a37c97dd30,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|865|898,TC:nil,Content:0|15|52,EDM
	:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ef552c3699e411f19a56ed5b684f684d-20260817
X-User: xiaopei01@kylinos.cn
Received: from [10.42.12.251] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 464748840; Mon, 17 Aug 2026 10:39:57 +0800
Message-ID: <3ee744ab-10db-47f1-925f-aa290888921d@kylinos.cn>
Date: Mon, 17 Aug 2026 10:39:54 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hwrng: cctrng: Fix use-after-free in cctrng_remove due to
 race condition
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: hadar.gat@arm.com, olivia@selenic.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <c77fad0623ba0f152490dc14d4029debd789915e.1785828765.git.xiaopei01@kylinos.cn>
 <an-5fU8RgEQM2j_d@gondor.apana.org.au>
From: Pei Xiao <xiaopei01@kylinos.cn>
In-Reply-To: <an-5fU8RgEQM2j_d@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/15 08:57, Herbert Xu 写道:
> On Tue, Aug 04, 2026 at 03:34:41PM +0800, Pei Xiao wrote:
>>
>> diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
>> index a6925211c3b5..dd41f2d1fee5 100644
>> --- a/drivers/char/hw_random/cctrng.c
>> +++ b/drivers/char/hw_random/cctrng.c
>> @@ -568,6 +568,12 @@ static void cctrng_remove(struct platform_device *pdev)
>>  
>>  	cc_trng_pm_fini(drvdata);
>>  
>> +	/* Mask RNG interrupts so cc_isr cannot schedule new work */
>> +	cc_iowrite(drvdata, CC_RNG_IMR_REG_OFFSET, 0xFFFFFFFF);
>> +
>> +	cancel_work_sync(&drvdata->compwork);
>> +	cancel_work_sync(&drvdata->startwork);
> 
> I don't think this closes the race window.  After all, the ISR could
> have already been started before your iowrite call.
> 
> Is there any way to make devm make the cancel_work_sync calls after
> the ISR has been deregistered?
Hi Maintainer,
  Thanks your reply.
  How about this:
diff --git a/drivers/char/hw_random/cctrng.c
b/drivers/char/hw_random/cctrng.c
index a6925211c3b5..c1536660e8d5 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/irqreturn.h>
 #include <linux/workqueue.h>
+#include <linux/devm-helpers.h>
 #include <linux/circ_buf.h>
 #include <linux/completion.h>
 #include <linux/of.h>
@@ -502,8 +503,16 @@ static int cctrng_probe(struct platform_device *pdev)
                return dev_err_probe(dev, PTR_ERR(drvdata->clk),
                                     "Failed to get or enable the clock\n");

-       INIT_WORK(&drvdata->compwork, cc_trng_compwork_handler);
-       INIT_WORK(&drvdata->startwork, cc_trng_startwork_handler);
+       rc = devm_work_autocancel(dev, &drvdata->compwork,
+                                 cc_trng_compwork_handler);
+       if (rc)
+               return rc;
+
+       rc = devm_work_autocancel(dev, &drvdata->startwork,
+                                 cc_trng_startwork_handler);
+       if (rc)
+               return rc;
+
        spin_lock_init(&drvdata->read_lock);

        /* register the driver isr function */

Thanks!

> 
> Thanks,

