Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4797A51C58;
	Wed, 20 Mar 2024 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710947624; cv=none; b=baC+EyYX9+2eU1ppERQkIw40R5LnfGUmiQ/71GW+kdjG5pbI3zZtGBKJ92pP0Quke1IwVvpcoby53QSmhZK+Qh7K92dblVM68o986znLtKYLzOZS5K1Q0AnroyE8jNsAklOgN7Z3jAzl/Z8NQu0mCi8I1hkxyTyBkJZMSt+G3is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710947624; c=relaxed/simple;
	bh=LtLbr9/vDD9oCkEi6bkKIcq4qBaMLATwiFb0k5KE+TU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WMyQyupp3oZVRSuUgxRHzlKbbegxOKj6bPFnG9gk4ojbL9ikL7NrjVRx3Fl6nx4QCx7Oy/1ZDEL8QSpGO3tv6XCrCgKbP1ecdxfetql7GT9fnz6sCkdj0UwPhH+CSj3QnEl0aUj2gV/C/89PbfyqeuddoqSFGGisr8AU6Qzu1S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=T8/8XNdC; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="T8/8XNdC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:References:Reply-To:Cc:To:From:Subject:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=OLxm6fLIR0Yj0UHnwoux3tx7eG7VNhXfLRRrf+zGO48=;
	t=1710947622; x=1711379622; b=T8/8XNdC0Bbhfcq+MyDCKDnP5j7iJctSxm8gwzjsvimd48N
	zC8aE/w38g+eUdxC2rvmA0+bV72KEtwY4+0epVG87Eda0QH2GrOpecm9JnBbLf3fiyWvrSjtYyauS
	Q3DObdWY0zYERZfSoyOXWbbRXOawhQ/ieoubrLr8ARJkOCrEkns39h4erPp5fM8gdjM9M4AEZV5gI
	kcMJeOnzjf2VZjNAwop9jMBIMsCdncWaxtJlVIqFtfiLvZVyXlmjQwSdZH7i5y6dKQOHixucdQA/W
	vEe93KErzXSJ1K4YTCZSNjijBaO0o4lGZysVcD2Rh/6gwPb3EsUMjmwRTOCLKd3Q==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rmxdL-0000FB-JQ; Wed, 20 Mar 2024 16:13:39 +0100
Message-ID: <d9aae981-ea93-418e-8c98-94eb27f4a80d@leemhuis.info>
Date: Wed, 20 Mar 2024 16:13:39 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: af_alg - Disallow multiple in-flight AIO requests
Content-Language: en-US, de-DE
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
To: Ralph Siemsen <ralph.siemsen@linaro.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Sasha Levin <sashal@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
 Linux kernel regressions list <regressions@lists.linux.dev>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>,
 Linux regressions mailing list <regressions@lists.linux.dev>
References: <ZWWkDZRR33ypncn7@gondor.apana.org.au>
 <20240315175529.GA268782@maple.netwinder.org>
 <256024ba-c889-4400-a7cd-002291e64ad5@leemhuis.info>
In-Reply-To: <256024ba-c889-4400-a7cd-002291e64ad5@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1710947622;8e374c55;
X-HE-SMSGID: 1rmxdL-0000FB-JQ

On 20.03.24 15:54, Linux regression tracking (Thorsten Leemhuis) wrote:
> [CCing the stable team, as it looks like two prerequisite changes for a
> patch already applied are missing in at least 4.19.y]

Argh, race condition, it's now 15 minutes later and I by chance just saw
that Ralph about about 45 minutes ago took action as well an brought the
issue to the stable teams attention:
https://lore.kernel.org/all/20240320143143.1643630-1-ralph.siemsen@linaro.org/

Guess its best if everyone ignored my earlier mail. Sorry, bad timing,
happens.

Ciao, Thorsten

> On 15.03.24 18:55, Ralph Siemsen wrote:
>>
>> I have found a regression in userspace behaviour after this patch was
>> merged into the 4.19.y kernel. The fix seems to involve backporting a
>> few more changes. Could you review details below and confirm if this is
>> the right approach?
> 
> FWIW, developers are totally free to not care about stable and longterm
> kernels series. Not sure if Herbert is among those developers, but it
> might explain why there is no reply yet. That's why I CCed the stable
> maintainers, strictly speaking they are responsible.
> 
>> On Tue, Nov 28, 2023 at 04:25:49PM +0800, Herbert Xu wrote:
>>> Having multiple in-flight AIO requests results in unpredictable
>>> output because they all share the same IV.  Fix this by only allowing
>>> one request at a time.
>> [...]
>> This change got backported on the 4.19 kernel in January:
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.19.y&id=19af0310c8767c993f2a5d5261e4df3f9f465ce1
>>
>> Since then, I am seeCiao, ing a regression in a simple openssl encoding test:
>>
>> openssl enc -k mysecret -aes-256-cbc -in plain.txt -out cipher.txt
>> -engine afalg
>>
>> It fails intermittently with the message "error writing to file", but
>> this error is a bit misleading, the actual problem is that the kernel
>> returns -16 (EBUSY) on the encoding operation.
>>
>> This happens only in 4.19, and not under 5.10. The patch seems correct,
>> however it seems we are missing a couple of other patches on 4.19:
>>
>> f3c802a1f3001 crypto: algif_aead - Only wake up when ctx->more is zero
>> 21dfbcd1f5cbf crypto: algif_aead - fix uninitialized ctx->init
>>
>> I was able to cherry-pick those into 4.19.y, with just a minor conflict
>> in one case. With those applied, the openssl command no longer fails.
> 
> Some feedback here from Herbert would of course be splendid, but maybe
> your tests are all the stable team needs to pick those up for a future
> 4.19.y release.
> 
>> I suspect similar changes would be needed also in 5.4 kernel, however I
>> neither checked that, nor have I run any tests on that version.
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> --
> Everything you wanna know about Linux kernel regression tracking:
> https://linux-regtracking.leemhuis.info/about/#tldr
> If I did something stupid, please tell me, as explained on that page.
> 
> 
