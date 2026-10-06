Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A373DBD51;
	Tue,  6 Oct 2026 10:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281430; cv=none; b=ewGYrGZxtJ7ENaKZJtY9il+jR2L+L4jn3GRMO57z23TLQva7FB8tL/3lWhOudfrEnLjnV4skHTZfEJs6pmzsM/2lPoG+rb3xJsjTFxNVFpa/2B72bzlWn9Lgsfclyvmpu5MIpyXACMVOUQ2RE1LW5ivklqyVGKVLgAbha3M7NlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281430; c=relaxed/simple;
	bh=wCBKwAO3RldU2ESPFI6THPXILvQkLLbyNG3wUXkZEWo=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=EX3I8wyOmVAILSWdKfF1BM3+t1NB/DOQDmm2mVZ9eV4mQ5miPYxvV+GccjxUmKV41so5ew6qyyQJOVnWwpXdLPyO9m+NxCrwDAkbZGrXnAtfwYPlnDOImIto17ML7AgQDctrb64uHTK/rIPYrcFvFVdhjE0AaE+oP4hLTUa/hD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVDUfh8n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVDUfh8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8631F000FF;
	Tue,  6 Oct 2026 10:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791281429;
	bh=mN1fLUx6U4l11L6MnXB4bhyBo8psXKYYXKG+AATtHRY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=IVDUfh8nXRjNdwWnnspKOckVBC1AiAw5MkmIYbWhVv7P2wTzk5HkMj+1YwUFZgIIJ
	 Ndtg/qPwG7blVYnRKYzRSvsm34pJ1aZuodHn+U4FfFZvjWJtRLcbJu4RzsD0TdvgF8
	 +ne7SoB2NT03Iehbyy+UybpejGQ75i/TYV3QwsJNV0j77F4BzqvirJyDbwPw2aTGKP
	 DNjfBYSpYNM5pTiFnetb1oopM1OJLnUPGq1A2HSLNrMWEg2390UK8nmBrLy9Ogr1dU
	 JRacKobcRveqmBfItkN5R79VVajVP36p8Drca0xLRoUYI6s7FmdN6C0yNxabAvTJFd
	 7hyfDizUBX0Pg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 67970198003A;
	Tue,  6 Oct 2026 06:10:27 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 06 Oct 2026 06:10:27 -0400
X-ME-Sender: <xms:EcnEalNtbXfScbAZRgq9tnCaopQU5A-aPkJLy6C6QJMSuQR6iS_E4A>
    <xme:EcnEaizy4sdBhUndLOtxQ4R9nUMYFL-cw9vouDFSd-qqs53x03hIIMtS-nJ5xBUuK
    Bz0jXMv2IuSrQ2pJLJzVgFlpEIKf9QAToCBA7vk131BcxdjehL4O2FC>
X-ME-Proxy-Cause: dmFkZTF+ynibvRhAiAMRnJcUgqJ6a+xA9WFexSAZHW4HGxJsRcSVNIqtsmNcaUTY1UDF4I
    u8MBKVSyEqTH81/lAETkaXgb4jhEYHL+MLxq+rqwyyY4+aEhcn9AsF/yzLZdpsc9D0Oko1
    l71nfHkL/AGbdZgMSJaz0ucEZBUI1sA6aN/Q7VyNOjA41fNcwMqUUZhhuTaAXSuyDw5kkP
    3ZW4cPj30662ajbsHnwtpu+JjzHhOO1XqUNczq8GoAKa/uLQtZCYDX98QCOW56XECpGYzP
    /1eT5aKoVsgskOBpFD7LBGDPQxaNsDpIjj38BpRGs+UYnRCaESDmvh/qk0pFLMX/wH4yf/
    3yWDQhzUSRshsPr8DIdWWB30L2SbfwfPE3tEd9MWtQBrgn8n74tRCytHcBRHwmUlmCHmZl
    KKvo22DmjMrAYapiHJP9KqBSmx+aUEa8uDKt+igoFvrzMNtuU328TuuLzTzr52afPynLO+
    QI0grAo6NDRi2hsZfQw/REZ1A2+jX1K9TnXbFQTNwc6eUqhM8xTmK4u3noE2ModVSml+ox
    kScqB2GmK5d0vxGtKlmLv1auOb5jMeV2RTYAWNeUAQUpRhBhuj+07WjqadDb+EtvWiAvti
    bPwoQcNmcyPKRjpGDTIN3pGbAl48gT2buzU6M6r/uIzSkg3nOhNS4C7JARmA
X-ME-Proxy: <xmx:E8nEasuotUdV6-kMjEGnqQubhntuhVYzbZs8NJ3GyMu9cyvX0tKgLQ>
    <xmx:E8nEalc-20OBlVsL1HRRzc3z2O1pnxl10k4Af2GIxIhtOikqYICyBA>
    <xmx:E8nEap8FU0trtXMK5AkWmcgIpbi-fkooWU3ql2Ci4dIiRGFQ1VbknQ>
    <xmx:E8nEagQfruypz-WMNtOnayodTOPR5XVtA7YhNvuEpETRXNhUsxMgzw>
    <xmx:E8nEaqqhzsyNudpYgGcckZzJANBZMvBzRa1cbT7iwNziGAXQw5Zw06Ys>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 9782CF80096; Tue,  6 Oct 2026 06:10:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 Oct 2026 12:10:03 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, stable@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>
Message-Id: <3631bd3a-2186-4fcf-bceb-28fb4ed97d54@app.fastmail.com>
In-Reply-To: <20261006083432.16328-1-ebiggers@kernel.org>
References: <20261006083432.16328-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: poly1305: Use memzero_explicit() in poly1305_final()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Tue, 6 Oct 2026, at 10:34, Eric Biggers wrote:
> Use memzero_explicit() instead of a plain struct assignment to guarantee
> zeroization of the 'struct poly1305_desc_ctx'.
>
> Note that dead store elimination was only theoretically possible with
> link-time optimization here.  But it's still worth fixing.
>
> Fixes: a1d93064094c ("crypto: poly1305 - expose init/update/final 
> library interface")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: 
> https://sashiko.dev/#/bug/linux-c3a6bd76-f6ab-4203-892a-cd06f7aa0c34
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/poly1305.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
> index f313ccc4b4dd2..048c7afe86138 100644
> --- a/lib/crypto/poly1305.c
> +++ b/lib/crypto/poly1305.c
> @@ -78,7 +78,7 @@ void poly1305_final(struct poly1305_desc_ctx *desc, u8 *dst)
>  	}
> 
>  	poly1305_emit(&desc->state.h, dst, desc->s);
> -	*desc = (struct poly1305_desc_ctx){};
> +	memzero_explicit(desc, sizeof(*desc));
>  }
>  EXPORT_SYMBOL(poly1305_final);
> 
>
> base-commit: 6a50ce0af5c91fd665d65d357af8ae55db1df7d0
> -- 
> 2.56.0
