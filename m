Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB134CB5B;
	Wed, 20 Mar 2024 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946471; cv=none; b=cN+atIXNolBQfm5sLFRwbtRblC2VGAHlybbJOhX5hPxlLlnDR3nHMw+mO+CnRn9694sUtWl5AlUan/OoIf5zU/iR8KryuyZWNJP3bq/xG9T6O1bWjskOvzZuuMIPakp213CRRgJHJiYtRXi29wXJtqOb3aLf7W+69Fx6sWWl0AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946471; c=relaxed/simple;
	bh=l84i0sEPInrq5lJIYS2I2zVxcDj2BHW/93OahkYwp5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ig+jE6dM3uIKhVuGFyitEj8t196zNIIXqft83NbPapo7um/4Kj2bpCR4VqxyB+C5kXh+8YY9+X8jBNXbVtVUYrQvaahLXnBGJ8aSHG0DdSyuNjiowOpqurDj2IVra84ctBZbDAxB4hal2Aa5k+6o9sSIzd4OOlKRCtr8f5JOgdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=H8WeWHZf; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="H8WeWHZf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=6Gjn1V01WyKkpjbLddeTXkLKXDQ7KdJBsP0B81Mf7Og=;
	t=1710946469; x=1711378469; b=H8WeWHZfwR1UrES/n/Hoq4kB8xlYUssm/masRNb2G7BN6+b
	QP4mCIlYKS7CUEVzfixKTDH9mcdYr6ok/qzZToJ502excVlLMYNYvw6jKuCBtW+bQfdD7LNVy1Wam
	e2nyGKFK4FmYB52HMjqdJLNUmsYY9N2sg/TDmqgGWvBJ4bncd6Hbj4NTSkcqMJfIhrgki757cLd+I
	DuAujzMNK22zjNwWpAzYR3uyC4EQDCvccHK8/3SKI8XqAuJ9yw+/VGSgJEzi2pOXw+IxatnM9fx8W
	pWgSX6qC3JE3AQD7g4yYMa4ykwdaU2zADb0oEk4V9aS9Lu0dLvxLN+rtfVo5q2Xg==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rmxKc-0004oj-MI; Wed, 20 Mar 2024 15:54:18 +0100
Message-ID: <256024ba-c889-4400-a7cd-002291e64ad5@leemhuis.info>
Date: Wed, 20 Mar 2024 15:54:18 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: af_alg - Disallow multiple in-flight AIO requests
Content-Language: en-US, de-DE
To: Ralph Siemsen <ralph.siemsen@linaro.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Sasha Levin <sashal@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <ZWWkDZRR33ypncn7@gondor.apana.org.au>
 <20240315175529.GA268782@maple.netwinder.org>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <20240315175529.GA268782@maple.netwinder.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1710946469;e25eb307;
X-HE-SMSGID: 1rmxKc-0004oj-MI

[CCing the stable team, as it looks like two prerequisite changes for a
patch already applied are missing in at least 4.19.y]

On 15.03.24 18:55, Ralph Siemsen wrote:
> 
> I have found a regression in userspace behaviour after this patch was
> merged into the 4.19.y kernel. The fix seems to involve backporting a
> few more changes. Could you review details below and confirm if this is
> the right approach?

FWIW, developers are totally free to not care about stable and longterm
kernels series. Not sure if Herbert is among those developers, but it
might explain why there is no reply yet. That's why I CCed the stable
maintainers, strictly speaking they are responsible.

> On Tue, Nov 28, 2023 at 04:25:49PM +0800, Herbert Xu wrote:
>> Having multiple in-flight AIO requests results in unpredictable
>> output because they all share the same IV.  Fix this by only allowing
>> one request at a time.
> [...]
> This change got backported on the 4.19 kernel in January:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.19.y&id=19af0310c8767c993f2a5d5261e4df3f9f465ce1
> 
> Since then, I am seeCiao, ing a regression in a simple openssl encoding test:
> 
> openssl enc -k mysecret -aes-256-cbc -in plain.txt -out cipher.txt
> -engine afalg
> 
> It fails intermittently with the message "error writing to file", but
> this error is a bit misleading, the actual problem is that the kernel
> returns -16 (EBUSY) on the encoding operation.
> 
> This happens only in 4.19, and not under 5.10. The patch seems correct,
> however it seems we are missing a couple of other patches on 4.19:
> 
> f3c802a1f3001 crypto: algif_aead - Only wake up when ctx->more is zero
> 21dfbcd1f5cbf crypto: algif_aead - fix uninitialized ctx->init
> 
> I was able to cherry-pick those into 4.19.y, with just a minor conflict
> in one case. With those applied, the openssl command no longer fails.

Some feedback here from Herbert would of course be splendid, but maybe
your tests are all the stable team needs to pick those up for a future
4.19.y release.

> I suspect similar changes would be needed also in 5.4 kernel, however I
> neither checked that, nor have I run any tests on that version.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
