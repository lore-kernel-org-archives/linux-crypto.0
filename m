Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3271F7076
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 11:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742557475; cv=none; b=mSrBRdzfEIkSwe9xNrFVmyWGqpS3z36F3Ry5VvK7ThSjIJibxYvSuItgYmKowF7LLgE+6WITvJ8baPXf2hD2hEsDLOiSZRYdrhBbSIePp9ho2f9qOZDV4xyVB2OEqQ05m1uaW0w1FTQhNDxM/yJWb0k4QmDcWsWl3y1U7CzPg/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742557475; c=relaxed/simple;
	bh=KNDS1g8j6f+AvmtYpdekdrFwzgMEbklqgoZaGGtYXw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OGouyks3a0v2+S54Xl0Bt9VZYahdpMK7e8sEQqnlLOKruwtNzvfLwy435er2s59/pKlYfHDY4c65MPGb4j9YnYd8Vwnf0ox+sSeG3rRztXvd6pwkm1aacZOUI50quRGgpzVGki1sJCcKb18jzEC69KW35wM95S1NKst5Wkk/Q9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kv364BIy; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kv364BIy"
Message-ID: <4ef747cd-44e2-4e98-9b06-26ecbb327c6b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742557470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j9O6EnKomd8VOYO2C5XfZ5ep846tqd+NQlKkGBrIJ7U=;
	b=Kv364BIybwQQGEd+OZA7NRR+mM1rbPLqm7DdmOA7tuuJ4+vgLTbUYI4q9e+IBed6lJK/Fn
	FvH1le5cEdXboYDvwYh9nTzilPdKZMvRE5kcDkgsdbD+22716HP0UtUyhnSKEySFDaaI0n
	ZbEPBPc+Ni2E+y8klEPqayN2x9SN9Kg=
Date: Fri, 21 Mar 2025 11:44:25 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] MAINTAINERS: Update email address for Arnaud Ebalard
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Arnaud EBALARD <arnaud.ebalard@ssi.gouv.fr>,
 Boris Brezillon <bbrezillon@kernel.org>, Srujana Challa <schalla@marvell.com>
References: <Z91Ld28V6L2ek-JV@gondor.apana.org.au>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <Z91Ld28V6L2ek-JV@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 21/03/2025 11:20, Herbert Xu wrote:
> The existing email address for Arnaud Ebalard is bouncing.  Update
> it to what appears to be the most recently used email address.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f8fb396e6b37..68c903bf6aa0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14010,7 +14010,7 @@ F:	include/uapi/drm/armada_drm.h
>   
>   MARVELL CRYPTO DRIVER
>   M:	Boris Brezillon <bbrezillon@kernel.org>
> -M:	Arnaud Ebalard <arno@natisbad.org>
> +M:	Arnaud Ebalard <arnaud.ebalard@ssi.gouv.fr>
>   M:	Srujana Challa <schalla@marvell.com>
>   L:	linux-crypto@vger.kernel.org
>   S:	Maintained

Maybe also add the entry to .mailmap to let get_maintainer.pl work
correctly?
