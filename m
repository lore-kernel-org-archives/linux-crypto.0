Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B42309EEC;
	Thu, 29 Jan 2026 16:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769702737; cv=none; b=kbcF+jeSAPRpMX7RlJxk+g7uMungB7/aWcfLes4r8Or8ODiPPJGngEB7SIoLI0DwiPlbtZI/c/GgRFSVcgJYpFiG3JPqrIItoA4Eq78bQ3fAx0utHxxUG5iGsEwW7Nm0w6smDyAN7Qhrh/FDbEy6j09Jr/47Qz9Gf75Opk3VhhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769702737; c=relaxed/simple;
	bh=yVdibtwtGBdtM6zRoTTns3ysNbJg04ECgBNHy8kebSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JnuZXbnQdypQAsgof/qMSu+GZroigSeF9UgDgd3PT530+tTO8wJ31f+YwW/Mgi37thJCJ4fREWpZa0lkqka0Xn6dEDC0R9JoGmUqh5qmFYR+kMeRyyVuuLghYDXWHtR0+bv0CG7e6lX343R+Id/mkf4aAMqaLOQWwH9gSPS7KVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=mNSQY84L; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="mNSQY84L"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 5E81CC22F46;
	Thu, 29 Jan 2026 16:05:35 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 4FCDF60746;
	Thu, 29 Jan 2026 16:05:32 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C84C6119A8095;
	Thu, 29 Jan 2026 17:05:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1769702731; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Lc6wWk4IgTT559wWGEQNQjCDMW6utgy5FoBxVvSG2KM=;
	b=mNSQY84LQ52ZnscGD18IByJvZJQQIacVebk2t/plG/whMwn+83Zl1E9OvoWX2V2RxCfoxS
	J7FKlupj1VB7e6rJFirr6RfK/Oy8A6bsRNzcw474UsjN/FbndmiovBhMgwm4YRKoBwKFmx
	3ZeTXY3A03ZQLaJOCIiO8R9mHEDa7oyn4WPEqgrGwV6YrglWUK6/soN5WeE49FI13rIEZA
	q4eMBtWPKykfEWe2ps7aGWr4/JW4mG1Uq3VhlwwNdXdiVcqnGgeBHoWH5R9jClm0TjLX7V
	OKWIWCnc7iGZ2Eb/+sESPRrxzaJ8ZnvdKXHvmTHen/Ais5igGxDQBGU8jw1rrw==
Date: Thu, 29 Jan 2026 17:05:27 +0100
From: Alexandre Belloni <alexandre.belloni@bootlin.com>
To: rouven.czerwinski@linaro.org
Cc: Jens Wiklander <jens.wiklander@linaro.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
	op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-rtc@vger.kernel.org
Subject: Re: [PATCH 3/3] rtc: optee: simplify OP-TEE context match
Message-ID: <202601291605277bc279f4@mail.local>
References: <20260126-optee-simplify-context-match-v1-0-d4104e526cb6@linaro.org>
 <20260126-optee-simplify-context-match-v1-3-d4104e526cb6@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126-optee-simplify-context-match-v1-3-d4104e526cb6@linaro.org>
X-Last-TLS-Session-Version: TLSv1.3

On 26/01/2026 11:11:26+0100, Rouven Czerwinski via B4 Relay wrote:
> From: Rouven Czerwinski <rouven.czerwinski@linaro.org>
> 
> Simplify the TEE implementor ID match by returning the boolean
> expression directly instead of going through an if/else.
> 
> Signed-off-by: Rouven Czerwinski <rouven.czerwinski@linaro.org>
> ---
>  drivers/rtc/rtc-optee.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-optee.c b/drivers/rtc/rtc-optee.c
> index 184c6d142801..2f18be3de684 100644
> --- a/drivers/rtc/rtc-optee.c
> +++ b/drivers/rtc/rtc-optee.c
> @@ -541,10 +541,7 @@ static int optee_rtc_read_info(struct device *dev, struct rtc_device *rtc,
>  
>  static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
>  {
> -	if (ver->impl_id == TEE_IMPL_ID_OPTEE)
> -		return 1;
> -	else
> -		return 0;
> +	return (ver->impl_id == TEE_IMPL_ID_OPTEE);

I guess the correct way to do this would be:

return !!(ver->impl_id == TEE_IMPL_ID_OPTEE);

But is this change actually generating better code?

Before:

static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
{
        if (ver->impl_id == TEE_IMPL_ID_OPTEE)
       0:       e5900000        ldr     r0, [r0]
                return 1;
        else
                return 0;
}
       4:       e2400001        sub     r0, r0, #1
       8:       e16f0f10        clz     r0, r0
       c:       e1a002a0        lsr     r0, r0, #5
      10:       e12fff1e        bx      lr

After:

static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
{
        return !!(ver->impl_id == TEE_IMPL_ID_OPTEE);
       0:       e5900000        ldr     r0, [r0]
}
       4:       e2400001        sub     r0, r0, #1
       8:       e16f0f10        clz     r0, r0
       c:       e1a002a0        lsr     r0, r0, #5
      10:       e12fff1e        bx      lr

I'm in favor of keeping the current version.

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
