Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EE453E0B;
	Thu, 15 Oct 2026 13:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792071229; cv=none; b=T0GgugnxbpvhfcKvrN6n5DJEfMf8UB05TsKujAv2mf5f9P/A+cctsb34ga++IVi7gdMPrH//bHQG7YJ3hWuSMzRncmCmtrL5Rua1Km9rgHQNQ0CQSBYWfYDxXZTOE4kRG4Tq/rqxcwuw8YiWU3+laa7Y9AD+yUmQLFlUbIe6Cwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792071229; c=relaxed/simple;
	bh=MviIMzC0Cf/AxfEYrjbzfHiXbHXPMrn0LhamOwpMwyU=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=oCnZ8uNRTIR+GoN6Zfdb/IrQaOMWvTRzSVLQ85jzVtLx8I+vWDqRi8ueMipfsLjghBEOEPPk46KkCUM5gWRuNdxVPDv8O24Bc4KsSGzcEVc0johDnKNYLla29OIc0MJwJYqwXXYN2AJmsfNXha8opVznr6EdbMwcIHD08jtgCJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=HbnnUYpm; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="HbnnUYpm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=EHP2hvFmy8UBCS8mi/U7rZKdSsnog2aToax2uD8CT8M=; b=HbnnUYpmc/zHm+HPVcGuA2VgOr
	drLToSBff6qsrl+cNh+DbK1/aNuypJWcMdO3/c4zHJnhAOUpq8oYaWhuua6/sp55T4yJUaBB6iSN1
	U7whGLajawfkxwISzjaZkV0sfC49Sc+aHl9ZfNRg5xXlBzcNISjAiIZCAV40l7ILg+hPLUAQq/28w
	8RcJqXnDzcINU6Nuse//N241NqiZn/aQ6WyH6/q28h8vJSncmJovin7z0XgRdy6Ab6eDzZR3q+NJx
	bem4EZgGIRWWE2OA/62K5qTd0B/dL4TEL8ZZimxSkkereDed75GZ7aMZmulNWaq68C+Gk92oO5sdv
	H1L4XU2w==;
Received: from [::1] (port=35902 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.100.1)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1xHLab-0000000G6B9-403f;
	Thu, 15 Oct 2026 15:33:45 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 15 Oct 2026 15:33:45 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: essiv: fix use-after-free in AEAD path
In-Reply-To: <atDE7dqBGm63pkde@gondor.apana.org.au>
References: <20261015121743.3151400-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <atDE7dqBGm63pkde@gondor.apana.org.au>
User-Agent: Roundcube Webmail/1.6.19
Message-ID: <32b563fa512a97b653bd06bc9bfc0ce0@oss.cyber.gouv.fr>
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

On 2026-10-15 14:19, Herbert Xu wrote:
> On Thu, Oct 15, 2026 at 12:17:43PM +0000, Jérémy Jean wrote:
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
>> +	if (err != -EINPROGRESS && err != -EBUSY)
>> +		kfree(assoc);
> 
> There is no need for assoc at all once the rctx->assoc test is
> dropped.  If the condition is true then rctx cannot have been
> freed.

Indeed, you are totally right, this is definitely simpler, thanks.
Do you prefer I resend a v2 or send a v3?

diff --git a/crypto/essiv.c b/crypto/essiv.c
index a47a3eab6935..3505b2769d93 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -250,7 +250,7 @@ static int essiv_aead_crypt(struct aead_request 
*req, bool enc)
         err = enc ? crypto_aead_encrypt(subreq) :
                     crypto_aead_decrypt(subreq);

-       if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
-               kfree(rctx->assoc);
+       if (err != -EINPROGRESS && err != -EBUSY)
+               kfree(rctx->assoc);
         return err;
  }
