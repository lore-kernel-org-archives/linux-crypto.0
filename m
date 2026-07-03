Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4736E23393F
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 08:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783066597; cv=none; b=LQ9cLLu76Og5fHt8bWOVS5WvqDvGWfYv0dCy5IaOD/2JrR0SxuhEpagpIbAzY1FJQq1O03pMTQqTzg2/v1bwiWb3PUufUPIo4cjuEfr5RXC3wHfM0upAE26PmD6T803aVAOYBs358TplV/PeVBcmRJ7NlrQsg3De63HahLMXgek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783066597; c=relaxed/simple;
	bh=EIBe/UpzO28bJYvjkpUVEnGyTFedIlsOKy7KllFDjS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i3tQnhMp4B7yVRqCjX8MOSeiyVxSlce/lbOcXAb6KgjpCSzgm9lBjcWcmEyxL8w4gIGc1SE/MTYMzNElm2RXGQIk5t4acEGhIFWrJ2mxtBD0AgW307i8Yf6jw4yaicUzOLFocLMXyj1SrFn7fYG3l0sq1WM9kQ+Tq9DBVjdMc6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=Dn5x12fV; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="Dn5x12fV"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id D97024E40C55
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 08:16:33 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id AD9AC60300;
	Fri,  3 Jul 2026 08:16:33 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E2A7A104C95A8;
	Fri,  3 Jul 2026 10:16:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1783066593; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=TGphaH8QpkCQumsy46H81CexagRvkzNp/RPzeBq7vK8=;
	b=Dn5x12fVjq213GZK/j3jC5OEIxbWQye+oa7hSDqnHrDdJMBDL2RRXd/q5+dVO5wO7NS4HO
	1bwqdKwQX3spt7oQgTW5Au+7eVfU1ZI0/xH2LQujzwa8uR78CDAoind7Wxg9WjfLcoA9VX
	gJQpWVOvKj/xJl4PaMBpHQURvRwute+Nc67dvEM+pNYzqV47GTShOSJ01CiqXf326eRLHk
	7p28cOpxeNI9R57BZFT6tNBvOvlkLqc5obVPcOxdKI76UAWtG/wbVu3WfYwbwOJjn0bBMR
	nefycSHiBL5MVBIJNCJus0uLNdt8faUZNDYr3sPhcM23SAGLJmMn61gaQZYWjg==
Message-ID: <26e5a7b2-8369-4cbe-90f6-56c5991e8301@bootlin.com>
Date: Fri, 3 Jul 2026 10:16:26 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] hwrng: core - Do not read data during PM sleep
 transition
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Olivia Mackall <olivia@selenic.com>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregory.clement@bootlin.com, richard.genoud@bootlin.com, u-kumar1@ti.com,
 a-kumar2@ti.com
References: <20260601-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v2-1-667ce5da32ee@bootlin.com>
 <aipEqj982ozWJXn4@gondor.apana.org.au>
Content-Language: en-US
From: Thomas Richard <thomas.richard@bootlin.com>
In-Reply-To: <aipEqj982ozWJXn4@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

On 6/11/26 7:16 AM, Herbert Xu wrote:
> On Mon, Jun 01, 2026 at 03:19:13PM +0200, Thomas Richard (TI) wrote:
>>
>> @@ -538,8 +539,9 @@ static int hwrng_fillfn(void *unused)
>>  		}
>>  
>>  		mutex_lock(&reading_mutex);
>> -		rc = rng_get_data(rng, rng_fillbuf,
>> -				  rng_buffer_size(), 1);
>> +		if (!pm_sleep_transition_in_progress())
>> +			rc = rng_get_data(rng, rng_fillbuf,
>> +					  rng_buffer_size(), 1);
> 
> Sashiko asks how this can be safe given that there is no locking
> at all.  That's exactly what I was going to ask :)

Yes indeed, you are right. I dug again the topic (including the freeze
solution I implemented in a first time), and I may have found the right
solution. The only way is to stop the hwrng_fillfn() kthread before
suspend and restart it after resume. Fortunately there is a mechanism to
do this: pm_notifier. I'll send a patch soon.

Best Regards,
Thomas
