Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFC3221275
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 06:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777874894; cv=none; b=V0bpIgg/k2Td+2NO/TkI6pF7GsG8wyMfS9O7zwZWzs2Twb+tlM1+B46lRemnGxDYcqTf0v1plg0Agn6J/SrlRNYMNwMNE2aTnByyFtkTLn46RxhDMU488pDLCcVekIoRCXIDSEe+QJfLueu1VeLpG/JDQPeHUHLvKqktldh1Btc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777874894; c=relaxed/simple;
	bh=TOca50pS01td/jUU/FwvS94h/ZEqq56G62bJ29EsyTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ERbGLbNHeZxwZXxL4nW/rpCH4tW2/6hXN8dFMp1Od0OXineF1G6re+KvUbR0fmX84v0z5Erl8Kgoxx0GwwGnY5tMJVCgG1/mBCVkc/tb4Cm5VjdgZaKR8Mdw8VU5Jbiy+W1LNt3NOYuhsOe6EPuXeGWpmqr4xEfEW8WcBBiViyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QhCH+wW3; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QhCH+wW3"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43fe3e22e33so1933072f8f.0
        for <linux-crypto@vger.kernel.org>; Sun, 03 May 2026 23:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777874892; x=1778479692; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FaZbHH/IOIhjmW6XYALmsYnEPoCz+hdT8OiAn2Buu0Q=;
        b=QhCH+wW3fF3bQzGoEUdD59gxzQOG4IEs93UltD8/sUoe5+Q2gkLcAtI/DJHBtaxj8r
         u2wemYayLdl9YODLjbBrzcG2aV8f+TBxHyw6wSN8ep3xM9CwfDKEfbXro6a6eBtfEhOi
         KZ7iISrUtQSl5mRKG5jQU0I0cwVyAmZn7u37YnGoFKwS6ODPU1GC66OLs8sp7UKNhRnX
         otglfgrA6U1QeCDIhyhhw9c/b4kZ7WqkBip9vvfyK+mjp4xxY8cvNrrWhtRCW1RV1YRU
         64C69e4p4ku+951Swm78hukPeDWiS+HcBl/xIJCGW3Fmk11i8QdOJj5L7gOtkRCBPzmf
         6AhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777874892; x=1778479692;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FaZbHH/IOIhjmW6XYALmsYnEPoCz+hdT8OiAn2Buu0Q=;
        b=jsSQkFfA1RNgwr90JgwMAZwE0E/LKXNPvT+2F64pIuqpsjo9SvG2a+TdmouIDCraUi
         yFv+zA0zYaoIci9sUa8HlXcM0g6G/n0LIkvgbYW0aD9rSH86roK1rXvl82xYeomFa74p
         IwxQOh1m0IIJLQR/9yCCwGTcrxIwLgmnH0Oc9NzL56ASKnXvePsoS3wOJVGguU1JH/X3
         1pA2FhDsxuVevniZMhu/UsDywPvDZCkMhUOCOddlbhgr6UP4AS0J7cVWlvdxx2VVfksF
         T/K4nrK21ubvRRZ3hSTPcalqQO1TaSxZuyCJcwRIhPnRe1wwavkW8VkqgBTKcEfLdCWn
         F5qQ==
X-Gm-Message-State: AOJu0YxfsJtQOD03XvbBxUq5RlIEU+mlLxGRpcP7Je/hyUypk+53Xfo3
	Ab8Jokg7CcpEIwffigto7BBYgU2cm4BDasOYeAvVNSVNgrm1NyanC3JSJTmExIG7
X-Gm-Gg: AeBDieueT75TsB6vOE1dBeN+McFh99z8zJMD7hKNoEZejchtYM55MlzWeYQbeVpdXH6
	MZzSHe3KwCBsxDk7bMmlK6/uAQpHNKORR2MnY/LBpv7XOpypOWuM5F8nUJZnDaYD/Bp1kjcqubM
	jjNVo+j1xrSEa/BIxZvnH/a1Bp0o7vZR4anE8GSUb35muSpPw+oorSZEOZIXYs++VKobHP8ep48
	5i05QhHuvWMEqfk1PM0Gsa9lNczTOfatRU1kpsQaQv6UW++zcUUf1rFcRKRxfOJcI0qE7HWVdmP
	CYmCjs9+t4EcEGzDQpXLbQtG7gUMnohSMgvRjuouiCpQ8aIxHYUIfTlW9MSbhySzBy1/KW8Ayui
	U6oObxuB/qNMP6L+CNzDJSQtAVsPXE4vonoJ7PlVXcIbSjqhh87uaAST21VrEC30IY9ADH9KUwa
	I/Q177vxa88HZn7Vmz3/zhY7ul7Wx5FO2kZRrJYwCL+npjYVZ5a7OjbhPNtjo=
X-Received: by 2002:a05:6000:2407:b0:43c:fb48:6856 with SMTP id ffacd0b85a97d-44bb34e71cdmr13957607f8f.13.1777874891529;
        Sun, 03 May 2026 23:08:11 -0700 (PDT)
Received: from [192.168.2.14] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a8ea7cf97sm27118213f8f.6.2026.05.03.23.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 23:08:11 -0700 (PDT)
Message-ID: <5dd3be22-13fb-41fb-b469-1ae6472200b1@gmail.com>
Date: Mon, 4 May 2026 08:08:10 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: AF_ALG algorithms required by cryptsetup
To: Eric Biggers <ebiggers@kernel.org>,
 cryptsetup development <cryptsetup@lists.linux.dev>
Cc: linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Demi Marie Obenour <demiobenour@gmail.com>
References: <20260504052400.GB2289@sol>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20260504052400.GB2289@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/26 7:24 AM, Eric Biggers wrote:
> Hi Milan,
> 
> AF_ALG is going to have to go away eventually, due to its frequent
> vulnerabilities which vastly outweigh its benefits.  Userspace crypto
> code can be, should be, and generally already is used instead.

Heh, I just send reply to the thread on security list. I know about this.
(It is probably waiting for moderation, cannot find link to paste here yet.)

In general, it is more complicated and need some time, but it can be done.

> Is a reasonably definitive list of the algorithms cryptsetup needs from
> AF_ALG available anywhere, so that an allowlist can be implemented on
> the kernel side?

For Veracrypt support, it would be easy to create list.
But maybe we can do it differently completely without AF_ALG.

> (It would need to be unioned with what iwd uses as well.)
> 
> Also, what are the biggest blockers to removing the AF_ALG dependency
> from cryptsetup, in your view?
> 
> Finally, how well would a CAP_SYS_ADMIN or CAP_NET_ADMIN restriction
> work for cryptsetup?  IIUC, volume formatting and opening require root
> anyway, and all the device-mapper ioctls already require CAP_SYS_ADMIN.
> I know 'cryptsetup benchmark' would be affected, but that tends to be a
> one-off manually-run thing, which people could add 'sudo' to.

Formatting does not require root, basically only device-mapper interaction
requires it now.

LUKS should be completely OK without AF_ALG (it calls userspace backend),
it is about other formats.

I'll reply later.

Milan

