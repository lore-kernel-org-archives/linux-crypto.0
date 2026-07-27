Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24BEF9C0;
	Mon, 27 Jul 2026 09:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785144658; cv=none; b=ermCrbHdxLgi+b4vRmtuexMyUCNb9h3RI3gT5hxP+Y2CXC+HheOVh5J7ZWpm2TRFeNz+md2ByODsUOFl6NAdTuFpU6CI5Ac97UKdFxrVYHqErDgzwLwhoxA5Ff0YiLPiMwjBYX6Rnlvmx4uxAh1N9vpz7A4qjpCzr/W1hYrZV1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785144658; c=relaxed/simple;
	bh=F6f6JF+XoulsWWI3muxdI5ov+5b/IxKXdexfjitQPKk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=LWIJULFqyTVaZNT+4lnaC+RyOllbCwwz+I5r5C+6PXPezIDKn7XxS7SottEKD1EYTopHz9xzYBPrWjxAtb0/zL4WcbWf6gyvli+GIV6VvEPyzZYVLzs2L0x3yxt4Hf+3D1UBbA5aqZBl9b7FBMfFDYMCx+FVwmYecKKgqV3kluM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=JQWpD2fB; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="JQWpD2fB"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id D1E394E40F95;
	Mon, 27 Jul 2026 09:30:52 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 9F06C601BE;
	Mon, 27 Jul 2026 09:30:52 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 08A9111C1233F;
	Mon, 27 Jul 2026 11:30:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1785144647; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=BUP62wRsO+EbAGO5aA2p8k2/TDLP9Fn+YaLE4jUmggQ=;
	b=JQWpD2fBn9mCsn2vFzla08N/OGsYBp5JQA3TMYLMxlU/cwxd6UceT6VquF8Mx9pbFYLw98
	qmh6VkO98rovEAgArCzmoxKnt22zJcatAeU3YovFWEcZoWytt6/2HR8cFe7gYX+s2/cHOS
	mH5kpIqtncmq2bGlpzMPVgx+aFqB4r9Q0vQS19mxBXel2GKAGpR76n/i8aDPV5DCD7UShM
	FTk4tAVUkq5MYDiL+Lbmy8OLu9AgGASnztZ0ZprOJiLzLctkvsNCFhCCI1ulef075mjuC9
	Fx4oCNWeBXIDI0jKRhohCPdxmF6aubDKQnX9ZAL1WXH/nCuzw8uFuP09xoVAfg==
Message-ID: <d0d77fe9-d806-4ecf-9e40-7ddab8dcac45@bootlin.com>
Date: Mon, 27 Jul 2026 11:30:41 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Thomas Richard <thomas.richard@bootlin.com>
Subject: Re: [PATCH v4] hwrng: core - Stop/start hwrng_fillfn() kthread
 before/after suspend-resume
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Olivia Mackall <olivia@selenic.com>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregory.clement@bootlin.com, richard.genoud@bootlin.com, u-kumar1@ti.com,
 a-kumar2@ti.com
References: <20260713-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v4-1-b5fb4c520b05@bootlin.com>
 <amaef-KUBBjOcyMH@gondor.apana.org.au>
Content-Language: en-US
In-Reply-To: <amaef-KUBBjOcyMH@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

On 7/27/26 1:55 AM, Herbert Xu wrote:
> On Mon, Jul 13, 2026 at 01:25:37PM +0200, Thomas Richard (TI) wrote:
>>
>> This is the fourth iteration, as requested by Herbert I replaced BUG_ON()
>> by lockdep_assert_held().
>> ---
>> Changes in v4:
>> - use lockdep_assert_held() instead of BUG_ON()
>> - Link to v3: https://lore.kernel.org/r/20260703-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v3-1-b7165cb9cf38@bootlin.com
> 
> https://sashiko.dev/#/patchset/20260713-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v4-1-b5fb4c520b05%40bootlin.com
> 
> Sashiko is asking about whether user-space can restart the hwrng
> thread via sysfs after you stop it in the notifier.  I know nothing
> about suspension so I can't say whether that's possible.  But if
> it is possible then you'd need to close the race window with a flag
> of some kind.

Oh yes, indeed Sashiko is right. PM notifiers are run before user space
processes freezing.

What do you think if I lock the rng_mutex at the very beginning of
suspend and release it at the end of resume?

static int hwrng_pm_notifier(struct notifier_block *nb,
			     unsigned long action,
			     void *data)
{
	switch (action) {
	case PM_SUSPEND_PREPARE:
	case PM_HIBERNATION_PREPARE:
	case PM_RESTORE_PREPARE:
		mutex_lock(&rng_mutex);
		hwrng_stop_hwrng_fillfn();
		break;

	case PM_POST_SUSPEND:
	case PM_POST_HIBERNATION:
	case PM_POST_RESTORE:
		if (rcu_access_pointer(current_rng))
			hwrng_start_hwrng_fillfn();
		mutex_unlock(&rng_mutex);
		break;
	}

	return NOTIFY_DONE;
}

IIUC once rng_mutex is locked nobody can start the hwrng_thread.

And even if suspend sequence fails somewhere, POST PM notifier will be
run, so mutex will be released in any cases.

Best Regards,
Thomas
