Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8BE189BBD;
	Wed, 13 Nov 2024 09:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731491873; cv=none; b=E9nd1DD5rkAJhtf7APa3m7hCANIlaiZ3Gx1jzCLMFis8+yEbetFzo5OcgQ+SVK1shJKX5Wo3bsy5P46rAPKscNHQSlw0lkojx0Hv3u60V9rOMnYgeJ6W2wzPbwXPacqA0+vNKZPWJ3oRno4Wb02n6g9pjF7JOp8hFA5Y+xsGq6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731491873; c=relaxed/simple;
	bh=w6Alk8VVEQgRUP+tvubPnlYaH+7oRXgCpRc94/ufxjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eRDX3ACyNzLBjxDDI0Z5xw0kkECr/CCTYfz1hG3Xp8a2HFA64o+4KLFxBr6OyL3WH0fKlrtAn02RP1ASfUs436L94+5ebRiYkbJ6FXer64LDbacnW6UjYJtfvDDtETAyeE9OddIXZaCSX3FwKvg7MQTYjwckFcmMBBpu7HvOTI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=Dc4/wbHJ; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="Dc4/wbHJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=xCT+3mbbEsg7xBrW0ZIDJcwqb3FMvOEHonafQfmkguI=; t=1731491871;
	x=1731923871; b=Dc4/wbHJP1ySiAh2YfUGnCq1AmZaAhbFpGBjyyvmzbwDKgeM9nAOCa1+PWrPQ
	FZvv4qfll5V5tfGiY+ZDSdJFb23xMvdRvQW9sy40L+qYY2/Wc+liMEzm2NmZJPAhnXKtQppJ5nz+Y
	OVYROXm53AZDsX617CO+VDwqxV/RhV+EFGWKbHqmQTRbxMoMuuv5kb1A79O3lq5mExAKknlm8TMsQ
	MjLB+sEC6ElmOOTGd8L5EauvWwKIdDhOKO5UgGTgWhfV44eOtT9/4BDIoYCdeDtiP3jAbWTMl6943
	4if5fnPS8blnA0xE0UPq0C4ZT27j3nHTGdTKvrpsGLhx33y+Sw==;
Received: from [2a02:8108:8980:2478:87e9:6c79:5f84:367d]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1tBA8C-0001tk-46; Wed, 13 Nov 2024 10:57:48 +0100
Message-ID: <1287d1f4-893f-4ace-947a-f85c4e0ee69d@leemhuis.info>
Date: Wed, 13 Nov 2024 10:57:47 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on Turris
 Omnia
To: Klaus Kudielka <klaus.kudielka@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Boris Brezillon <bbrezillon@kernel.org>, Arnaud Ebalard <arno@natisbad.org>,
 Romain Perier <romain.perier@free-electrons.com>
References: <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
 <ZwZAExmK52txvHE8@gondor.apana.org.au>
 <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>
 <ZwduxHxQtHdzz-kl@gondor.apana.org.au> <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
 <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
 <Zw31JIEyh28vK9q7@gondor.apana.org.au>
 <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <2ae8006f3cfc40ae66b34659365596ac8507d1da.camel@gmail.com>
 <Zw-NJwLXXQ0DwR8b@gondor.apana.org.au>
 <3f14a6d189b65182ed502d534a49ae289e12dcb8.camel@gmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: en-MW
In-Reply-To: <3f14a6d189b65182ed502d534a49ae289e12dcb8.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1731491871;cd0426ed;
X-HE-SMSGID: 1tBA8C-0001tk-46

On 12.11.24 20:33, Klaus Kudielka wrote:
> On Wed, 2024-10-16 at 17:53 +0800, Herbert Xu wrote:
>> Alright, so next I'm going to try to make TDMA entirely single-
>> threaded and see if that fixes it.
> 
> Hi, since this was marked as "not worth tracking*,

FWIW, I was taken back and forth and then decided with going down that
route -- but I might be wrong with the assessment.

> here a summary of my understanding
> 
> - hardware: Turris Omnia, Marvell Armada 385 (same behaviour on 2 devices)
> - the crypto self-tests on the hash algorithms provided by the  Marvell CESA
>   driver fail randomly (1-5 failures in 90% of the boots, rarely without failure)
> - this is likely a bug in the driver, which had been hidden for a long time
> - it is now exposed by parallel invocation of self-tests, introduced in v6.12-rc1,
>   commit 37da5d0ffa ("crypto: api - Do not wait for tests during registration")
> - to be safe, the algorithms in question (6 in total) have been set to priority 0 in
>   commit e845d2399a ("crypto: marvell/cesa - Disable hash algorithms")
> - so, there should be no immediate harm by wrong hashes (at least in 6.12)

Yeah, that round about was my understanding as well, which is why I
decided it's for now not worth spending time keeping an eye on. Would be
something different if it would turn out that some practical use case
(and not just self-tests) that worked earlier now is suddenly affected.
Or if that "set to priority 0" would lead to a significant performance
regression (but given the brokenness of the driver it thus could be seen
as a good thing).

Ciao, Thorsten
