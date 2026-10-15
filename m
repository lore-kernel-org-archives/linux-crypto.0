Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10FD4E36CB;
	Thu, 15 Oct 2026 12:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792066063; cv=none; b=FcVc/wQhKCdeBzYwpw4lBweIlDEuYAhx8CoPn0aAth6HEAcCQVsP/UChrj6IxTl8rzEnFLMeJPbJCnMfklvNX6+k5uL+Xkui9CDYdGmZQV2wxG/QGfsQqDHHgwI+0+dunXFJdXhDigxPYdDcu3TUtFeuMegQDRUrzGrWwYDJHT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792066063; c=relaxed/simple;
	bh=JSTPOfMEMNY5Dif/UXqSkehzAUf9xhNTdJTHWZr2g3k=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=s+JzwR1E7STH7rchqDC39TMnsv6wMIxMmGNR9lG8jePawO7JHqk9UMiCgqg8ESHyNCgSCjXXB9CP5O1lqbaLORDVDVskwJ1u+TBwAXNvipeb1LuFG07RpKWonlReCo8C5XeISWSLL1XpDuK7KqNqnb/pSvJl9TgXVXzJNWdjq3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=KDUS7IGX; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="KDUS7IGX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=gXZus4eIAZOnD1ewViYTrnWW5mwavEiiaKQlGIlSyyQ=; b=KDUS7IGXyOgmYucA1q1TAtJpor
	KhsBtGNjExCM0HVGUINSqmSYnFyse7TkC5/kVQY1cUdSSPmTTKRupGeACJBY/OXsLEOkyJzdv7+d1
	sewnVCfsA6J53BRy2XytgDem2SxzFvRmADRtoJBgpoCniuhNVZ/MkDh2VCJMFb0g+bJCg35JSqV3U
	eqc7+eYlYfNVnlRCzw5Yf5GZa4rVElA2EfpcNZg8nDi5kIqw77mzKaQ34jMJy5vgJAFCSH0QMvrX1
	i0BUXJUrb4/qMEd96W9Lfvsk//ERBuazde2El33S22ljQwEv5fN7HXe4xpjoWCmIM+7+i2J09roJn
	6JUdlw/g==;
Received: from [::1] (port=39656 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.100.1)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1xHKFI-0000000DeN8-1KtR;
	Thu, 15 Oct 2026 14:07:39 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 15 Oct 2026 14:07:28 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: essiv: fix use-after-free in AEAD path
In-Reply-To: <atBKr1-gTDAJ1IRe@gondor.apana.org.au>
References: <20261014222351.2930674-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <atBKr1-gTDAJ1IRe@gondor.apana.org.au>
User-Agent: Roundcube Webmail/1.6.19
Message-ID: <dcf362bd924d7090dbd03ef8af7a6ece@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On 2026-10-15 05:38, Herbert Xu wrote:
> On Wed, Oct 14, 2026 at 10:23:51PM +0000, Jérémy Jean wrote:
>> 
>> @@ -247,11 +248,12 @@ static int essiv_aead_crypt(struct aead_request 
>> *req, bool enc)
>>  				  essiv_aead_done, req);
>>  	aead_request_set_crypt(subreq, src, req->dst, req->cryptlen, 
>> req->iv);
>> 
>> +	assoc = rctx->assoc;
>>  	err = enc ? crypto_aead_encrypt(subreq) :
>>  		    crypto_aead_decrypt(subreq);
>> 
>> -	if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
>> -		kfree(rctx->assoc);
>> +	if (assoc && err != -EINPROGRESS && err != -EBUSY)
>> +		kfree(assoc);
> 
> Last time this came up Ard asked for the rctx->assoc != NULL test
> to be dropped completely.  Could you please do that and resend?

Hello,

Thanks for the feedback.
I have updated the patch, and will send a v2 shortly.

Regards,
Jérémy
