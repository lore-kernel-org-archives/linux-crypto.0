Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96EC38DF9;
	Sun,  9 Feb 2025 09:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739093887; cv=none; b=lBecPRiObUCBkb+uTgQIrh50PQn2dvnPy4gDub6/UvxY/pkuWWVj/3upmqYOhANgKqNFEzs7hm5ENnukPxh72ChHNo6yiHu/BQLaqq/yI3ImwqaHKMULuHfkrsIFUvLI/XYp0VSb3g+8wOp905gGJQALQQu1h4V0ssmYYtIB1gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739093887; c=relaxed/simple;
	bh=EpmtyFYBGVsG/DnTSSSBZgkXv6D222ch2OzghSeurDM=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=agoxWqgPKJiTZ7+QpFsqOu1+tHN5etxr0SyiiRPe3LXxr0bhGqv5mXRS39tNoj9DqdkfocIZatJqu96tfeTYZ28cuSxZ2r/ZNMdU3WF350jFqQn4+1iBQ1OAZYGUGFFiMsleRH39suvCeG6btsU2+HBGjYIqDEtqBg6/3SpBY6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=t5i0ZrGw; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="t5i0ZrGw"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1739093878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kj1RH42EzmW4qeTpx5jNsIwjOcynMe/HuS/NZyAXkJo=;
	b=t5i0ZrGwn1tqbHK9ltTneBSump15mE5TM5ZKtu4QhxJHwA53Li8GwHcATNotyTTZsRuvUj
	CoJqn5SNTF/EBcDC0oKFB8NxaW3ArSENG2X0+v8V1e3RrlsY6Zetxnwcx7NtAzKFvlVJaN
	xbaLJMEoLPRjwc3Lygoj8wJIAA/oYM+2P2bGu5sJHue0mianbthKh8U0lzMQbc1wbTT5qw
	Ca2PckvXyBTT3GOHBGpXbge8LHe6qH6XbNDGtvbFZ799ah2wVJ1nVAYln945877W7XQ4G6
	AodMa9XdK0DOL4hHnLuxeeCar6AdEmGL3lZ8MYVT5NGUyCWLqy7AiUu/uGQ0JQ==
Date: Sun, 09 Feb 2025 10:37:52 +0100
From: Dragan Simic <dsimic@manjaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 olivia@selenic.com, didi.debian@cknow.org, heiko@sntech.de
Subject: Re: [PATCH 3/3] hwrng: Don't default to HW_RANDOM when UML_RANDOM is
 the trigger
In-Reply-To: <Z6hyK-nU_mLxw-TN@gondor.apana.org.au>
References: <cover.1736946020.git.dsimic@manjaro.org>
 <3d3f93bd1f8b9629e48b9ad96099e33069a455c1.1736946020.git.dsimic@manjaro.org>
 <Z6hyK-nU_mLxw-TN@gondor.apana.org.au>
Message-ID: <1b5988c648403676342b4340c3d78023@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Herbert,

On 2025-02-09 10:15, Herbert Xu wrote:
> On Wed, Jan 15, 2025 at 02:07:02PM +0100, Dragan Simic wrote:
>> Since the commit 72d3e093afae (um: random: Register random as 
>> hwrng-core
>> device), selecting the UML_RANDOM option may result in various 
>> HW_RANDOM_*
>> options becoming selected as well, which doesn't make much sense for 
>> UML
>> that obviously cannot use any of those HWRNG devices.
>> 
>> Let's have the HW_RANDOM_* options selected by default only when 
>> UML_RANDOM
>> actually isn't already selected.  With that in place, selecting 
>> UML_RANDOM
>> no longer "triggers" the selection of various HW_RANDOM_* options.
>> 
>> Fixes: 72d3e093afae (um: random: Register random as hwrng-core device)
>> Reported-by: Diederik de Haas <didi.debian@cknow.org>
>> Signed-off-by: Dragan Simic <dsimic@manjaro.org>
>> ---
>>  drivers/char/hw_random/Kconfig | 76 
>> +++++++++++++++++-----------------
>>  1 file changed, 38 insertions(+), 38 deletions(-)
>> 
>> diff --git a/drivers/char/hw_random/Kconfig 
>> b/drivers/char/hw_random/Kconfig
>> index e84c7f431840..283aba711af5 100644
>> --- a/drivers/char/hw_random/Kconfig
>> +++ b/drivers/char/hw_random/Kconfig
>> @@ -38,47 +38,47 @@ config HW_RANDOM_TIMERIOMEM
>>  config HW_RANDOM_INTEL
>>  	tristate "Intel HW Random Number Generator support"
>>  	depends on (X86 || COMPILE_TEST) && PCI
>> -	default HW_RANDOM
>> +	default HW_RANDOM if !UML_RANDOM
> 
> This is disgusting.  Just remove all the defaults, and we can
> add back the ones actually needed.  Just remember to set the
> default to something sane like HW_RANDOM && dependencies.

Could you, please, clarify why we need(ed) the defaults at all?
Also, I'm a bit puzzled about what would be the defaults that are
actually needed?  Are you actually referring to what I proposed
in my earlier response? [1]  I'd appreciate a clarification.

As a note, I tried to kind of "fix" it in a least intrusive way,
but I'll gladly have it fixed properly in the v2.  To me, getting
rid of the defaults completely would be the proper way.

[1] 
https://lore.kernel.org/linux-crypto/78b97c27314bfa1c7f0f17a90e623821@manjaro.org/
