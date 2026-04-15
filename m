Received: from email.studentenwerk.mhn.de (email.studentenwerk.mhn.de [141.84.225.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA63B3806AB;
	Wed, 15 Apr 2026 19:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.84.225.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776282887; cv=none; b=OqR3kdFNi4+CgM8zvWECuGok3ZFS6Owsu+229VIgw9X3OB3o7Gv0peVms9QRix+beY+CeUUJAteW1jfFAACG5VBW6JOXlJvb7auyAund2Sr/yI5NGpNZUviYIkVrSlhcH09A1O7sJ4HVpQ84Z9gbOVLsQr/ZxFzxPrN70D8MbE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776282887; c=relaxed/simple;
	bh=GqI2Gs9OUJa6V6yXJkbo24YkX1gE9FSjCe3QzKGxOdU=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=gwJMJjmoCE+qq/BTxWSiPQ6SH2WxFQrucjfvv6awEvnH6ABR8iNnxMisnZFNZB1plZCFB+4JHWSmzLQ8T+vJ+BhnBD9/si0JbFEFjBBx325mU59IGS+mATqAEajON69s+ilRZZDKKNC8l4HdjnqnQEJ5L4TOrnPDtFw6D4WrQQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stwm.de; spf=pass smtp.mailfrom=stwm.de; dkim=pass (2048-bit key) header.d=stwm.de header.i=@stwm.de header.b=gv+MnD7O; arc=none smtp.client-ip=141.84.225.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stwm.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stwm.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stwm.de header.i=@stwm.de header.b="gv+MnD7O"
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
	by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 4fwsL26jd3zRhRp;
	Wed, 15 Apr 2026 21:54:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
	t=1776282874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3g3rnn+9sRXXC9cy6rVtmbBlrKkv+ND1FL9Xo7oJwj8=;
	b=gv+MnD7Ou9kVvudMniwF5TsAp+cl7PQM9M+f8Xui8243g6b7GbyhAp/VCCCuvTjNO1JicM
	RVsyhHbp0RG3Nb66t30oOZFJKBVVdeNyWqu8ot1Et3VubOBqVVyYlP0CZDbPLeYm+UmYLf
	GIBF3vCV5MqlJu/4UAV3bFsIRCNmyO5FnDGmvZlelvSRo5DMiuiPGZOYBf2XgD0Arx5NaG
	dInblpHlopZN7JfJTwhtQXkMnOB79PgQP97ZEE0KtmwgS2zFObVtVh9ggdzXCI4gmk7p2J
	yYIMxi+7tBlQCD2DaywpPVO5oZZLu7XXIFpMExYu/ACcm1eT6yfqc8pvT6dsEg==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 15 Apr 2026 21:54:34 +0200
From: Wolfgang Walter <linux@stwm.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, Sasha Levin
 <sashal@kernel.org>, Linux Crypto Mailing List
 <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: authencesn - Fix src offset when decrypting
 in-place
In-Reply-To: <ad7QGhjPKRh-Vvm5@gondor.apana.org.au>
References: <2026041152-boaster-patrol-1918@gregkh>
 <b397c5b34ed7484aad6e0acf7e1319c6@stwm.de>
 <ad7QGhjPKRh-Vvm5@gondor.apana.org.au>
Message-ID: <9225cb77b2c7e71f209865bada94beb1@stwm.de>
X-Sender: linux@stwm.de
Organization: =?UTF-8?Q?Studierendenwerk_M=C3=BCnchen_Oberbayern?=
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

Hello,

Am 2026-04-15 01:39, schrieb Herbert Xu:
> On Tue, Apr 14, 2026 at 06:52:22PM +0200, Wolfgang Walter wrote:
>> Hello,
>> 
>> with 6.12.18 ipsec stopped working for us. After reverting commit
>> 
>> commit 153d5520c3f9fd62e71c7e7f9e34b59cf411e555.
>> Author: Herbert Xu <herbert@gondor.apana.org.au>
>> Date:   Fri Mar 27 15:04:17 2026 +0900
>> 
>>     crypto: authencesn - Do not place hiseq at end of dst for 
>> out-of-place
>> decryption
> 
> Yes this is broken.  Please try this patch:
> 
> ---8<---
> The src SG list offset wasn't set properly when decrypting in-place,
> fix it.
> 
> Reported-by: Wolfgang Walter <linux@stwm.de>
> Fixes: e02494114ebf ("crypto: authencesn - Do not place hiseq at end of 
> dst for out-of-place decryption")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/authencesn.c b/crypto/authencesn.c
> index c0a01d738d9b..af3d584e584f 100644
> --- a/crypto/authencesn.c
> +++ b/crypto/authencesn.c
> @@ -228,9 +228,11 @@ static int crypto_authenc_esn_decrypt_tail(struct 
> aead_request *req,
> 
>  decrypt:
> 
> -	if (src != dst)
> -		src = scatterwalk_ffwd(areq_ctx->src, src, assoclen);
>  	dst = scatterwalk_ffwd(areq_ctx->dst, dst, assoclen);
> +	if (req->src == req->dst)
> +		src = dst;
> +	else
> +		src = scatterwalk_ffwd(areq_ctx->src, src, assoclen);
> 
>  	skcipher_request_set_tfm(skreq, ctx->enc);
>  	skcipher_request_set_callback(skreq, flags,

Applied the patch on v6.18.22, and ipsec works again.

Thanks,
-- 
Wolfgang Walter
Studierendenwerk München Oberbayern
Anstalt des öffentlichen Rechts
