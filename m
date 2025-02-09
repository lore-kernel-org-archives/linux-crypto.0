Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9F9339A8;
	Sun,  9 Feb 2025 10:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096024; cv=none; b=YhCcwe7Jzbd6tijIjttEy8zYb3mu7l7JbTSO0XfZpqM9BOpEsDQbkToZB2hD6hfnmu7UYHUns+KRjWX7F/KfLNXdORS97rox4VOPP7JU43dBF7FOPhQziiHSTLI+QMbQw8SHUu2fVaPC1feyKRHxaTt+cwqiVtMGbjdwJ5pAtoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096024; c=relaxed/simple;
	bh=qGVvyAjvkARhsdgoLHKbogxpRXGIPYmKtpRyzaX0DVc=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=u/hG0FSwZbURiBFNOgtJ60T+d+bwTudOUzy8CLeXYediksL3lYjSOMqbDkYyw38LjssS6x0hquM3iB6ExZIpFXlt2R5+CAzLBz7vVivXbYYdEkMya9wDYqesO+aghdS9nYYi9DEa1NNEvSPtn8y6vv8Zg3WaO0bzI8mSiWDhCrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=N6YXyenM; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="N6YXyenM"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1739096021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bONUnRdzPUqHC/OVdxeueVRpPfRNRz240WD8k87l8ok=;
	b=N6YXyenM5acxZBZdecaIYbqIOwfJbZ6y6Mza/2uhoU7uHo4LTb5/b5nMQBstUzrpA7hlE3
	UrpWPkgXPz7LEMSe5LPaMNWQWBK98xTvQ+Bkjgifa/VeL1ol61+ieOCO9VgPXmW933jWhi
	qMbyIDAqSUFvum0zHxiouia2PI3GMOOJdmATs2TBLX9RecUmxWAqal9CuiznVNOphOEf5N
	fREZVogA4DeDIib/C8Jq3Qi2U64xAHtptPEZtn2XxvfH9OCo/XChEzUxmLgdPojFt4lCsw
	+bBntxMd9gg2Yci5b6zeXI9MlIxm9eP11W4FGT3JQdAjuU/2jXlv+4VeNBcMfQ==
Date: Sun, 09 Feb 2025 11:13:38 +0100
From: Dragan Simic <dsimic@manjaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 olivia@selenic.com, didi.debian@cknow.org, heiko@sntech.de
Subject: Re: [PATCH 3/3] hwrng: Don't default to HW_RANDOM when UML_RANDOM is
 the trigger
In-Reply-To: <Z6h7RoBpKd1ZDKhz@gondor.apana.org.au>
References: <cover.1736946020.git.dsimic@manjaro.org>
 <3d3f93bd1f8b9629e48b9ad96099e33069a455c1.1736946020.git.dsimic@manjaro.org>
 <Z6hyK-nU_mLxw-TN@gondor.apana.org.au>
 <1b5988c648403676342b4340c3d78023@manjaro.org>
 <Z6h7RoBpKd1ZDKhz@gondor.apana.org.au>
Message-ID: <d6fd6707808ec4429071e5473c9c2dca@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

On 2025-02-09 10:54, Herbert Xu wrote:
> On Sun, Feb 09, 2025 at 10:37:52AM +0100, Dragan Simic wrote:
>> 
>> Could you, please, clarify why we need(ed) the defaults at all?
>> Also, I'm a bit puzzled about what would be the defaults that are
>> actually needed?  Are you actually referring to what I proposed
>> in my earlier response? [1]  I'd appreciate a clarification.
> 
> In general there shouldn't be any default.  The only exception
> would be perhaps for embedded boards where the RNG is always
> present given the dependencies.  But in that case the default
> should be conditional on the dependency (or perhaps the whole
> config should become unconditional).
> 
> The current defaults are mostly there for historical reasons.

Thanks for the clarification.

I think it would be the best to get rid of the current defaults
in the drivers/char/hw_random/Kconfig file entirely, together with
updating as many of the affected arch/*/configs/*_defconfig files
as possible to select the relevant HW_RANDOM_* config option(s)
whenever that's a sane thing to do.

Such an approach should be both proper and least disruptive.
