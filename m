Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A172B7080D
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 04:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771819344; cv=none; b=g2QzkwYAJKpC9aaeV1hmPuoWCbLto+kDq4027fj/aedIGFHiaRnKdXlHL9XH8HHrYSMGP7CdGpMoabpc9U719CdSFPzx1cCh9SnztkuXZgsLPPBWaxwJG3l4H6BNKbtsjWU1oMOqwzYuYUGY3VqEqzF2Yq1HRPvNfsh5cjKGmLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771819344; c=relaxed/simple;
	bh=pdJsgHVvquH2mGMT/v4fJ6tGz71bJ9zDzmM6NwNvDFw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WMpDsTm9AHJLiJWa85/+PWFOr8RZTJn7K7p7icrNfg9QYeo+2pDkz403b7TN8pXNHN/+JpKwU8lONB07uKF4zJ1SNr72Wh0/C2ZKB/SVQioaBOSRz3S4Qa5Nf/UqDAAb9pvlvu320KnQH76uig7Ux9Y0Tclm5rBPkUUlFMmEjP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SzMvAIdE; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SzMvAIdE"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c70bc5b4e86so418891a12.0
        for <linux-crypto@vger.kernel.org>; Sun, 22 Feb 2026 20:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771819343; x=1772424143; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ka/2iRfVjKlA/QhdXypyK76dl74TsslDm23BptT7ES8=;
        b=SzMvAIdE8NmXq4VoZls/RHNdODg0pVHOCPKuc2peJZX1hN+Q5ZPH9ni5sRBH6aqUl7
         16chTt80kNKvATkLxMf6NaBc0fMupeOTipk1e9IOZV6yAeJDonlj9DH/Q3P/JULS3Wra
         Ll/VEbM2OTzu0Z7CAzZ40JCGXniCsPC8tsEt1QJpWBsTPnNJ7ygnY9FNv7bE9Zq+GQKa
         zP3guI++3bXQMR+oNX9P2yKcpqzL4DMm95AvUGnI2JWQKasYb6oSjU+8uXBNUyQKUnH7
         MDFY1hRA8M2GA9RAwM/PIpyFXJN3QfA4VsjhPHtZk1NdDW7fvk2pcEHxyueAvmYuyH5Y
         hgMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771819343; x=1772424143;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ka/2iRfVjKlA/QhdXypyK76dl74TsslDm23BptT7ES8=;
        b=Rhea5cNDnX1u02ZcBFy28L/3v5rBAnPOtF177W3kotsxpCIOBiAQPrdRpLiLt6vjdu
         RQKTO6z0NlJgpT0t7utx7+qr7E+5S2+L2JVMkTBVFJFSlfEpXIyi4lf7O8ETU6DTag0w
         LXx2vjS9f30stcPksJWsXGGbIU6Q0Ypznk6+yGMHM5mwVND7KPNYlUqjLCR0+Ne7UxJX
         GJHl14JekaiJtOoUXW3zXHFhHu2eHI5Ol6xo4MOUH2JnLKcTxAm2yIsbGxDuYfRd8uzm
         PpPuud4vaQ4vPXumVoRtIV61XPQ71Xb8lRbQCGLR9Z90bk+jpM1iw7ZQ14ufznxgx1WZ
         HI0g==
X-Forwarded-Encrypted: i=1; AJvYcCW/yO/V1h4TUPWRVGTXzb7GcU2XUHiWokUxe3++DykgBvNdg8KF17/jJhvZlC1tlGJZ4FTDvGOaDKVFZ/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy77lJvuKxSy63qpmQYyFRlqdsOnSbd4UtXeqdiDZwlHqzcB0CG
	do/kC63x+Sj1RQ6z3AACvHPrbHWqNxbU1PiPUbf/58P/Te4PkHbKIqbS
X-Gm-Gg: ATEYQzwr3oxPVzLMDz6tPUyXErN39JAyM4EXkAxFECB67BNn4QLMlI6IsqFWbVpP3hY
	j8MGRkccyUewpRS6l+93DYNOPA0R6c9PTzBe4FkGaGCRQfimsPhwEhvZZCXKOmhdzSTZWO4ajiO
	efyDO+wlqSacgDddAAb86khVCTJE+L1PFuNwb/fMR2uFlJ8oQ2wAnuCShIg1b4O3wLj5DpPz/c0
	O7Jpry1jPML/RMbcymDH4dknR1k6LQo6ePThCWsmPGl1R0PlXE7JlRaMiSQ8b5t3NxMhy7Yfoud
	FYpRasijpOhLp5wRVxW0u7496AHh21esbe3bsnDklc0mfUZ0fNZPM/eMcQd4iWvdFlL+N7eHZ+r
	uxlqafV0qAEU7M/M2Ok1SKFcUu9f+PyuM/qmpNHCu7Tn4yGE+X2YA21zx76TOsEg5+89K7c/DrM
	6LeSqCp8qcHA8J5tvCk8Tl/zz3Df2J6D1Pyqduuf4vo/jXTl7wL5w80oEhkyJYpx/RCRUTYf5Mc
	0tI
X-Received: by 2002:a17:90b:4c85:b0:354:bfb7:db0c with SMTP id 98e67ed59e1d1-358ae8a8246mr5303029a91.22.1771819342555;
        Sun, 22 Feb 2026 20:02:22 -0800 (PST)
Received: from ?IPV6:2405:201:2c:5868:934:7eb8:e5cf:c85a? ([2405:201:2c:5868:934:7eb8:e5cf:c85a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-358a1ad45f7sm4173110a91.1.2026.02.22.20.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Feb 2026 20:02:22 -0800 (PST)
Message-ID: <1205234f-6ddd-4369-834c-6415f8fe0265@gmail.com>
Date: Mon, 23 Feb 2026 09:32:17 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Null deref in scatterwalk_pagedone
To: Eric Biggers <ebiggers@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, herbert@gondor.apana.org.au,
 rakshitawasthi17@gmail.com, Greg KH <gregkh@linuxfoundation.org>,
 security@kernel.org, linux-crypto@vger.kernel.org
References: <e3044be2-1f05-4cfb-99e4-39dc09e4aeb4@gmail.com>
 <63fdfca0-5165-4307-ae8e-c25cbed7f8cb@gmail.com>
 <20260222202123.GA37806@quark>
Content-Language: en-US
From: Manas Ghandat <ghandatmanas@gmail.com>
Autocrypt: addr=ghandatmanas@gmail.com; keydata=
 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
In-Reply-To: <20260222202123.GA37806@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/23/26 01:51, Eric Biggers wrote:
> What kernel feature are you using that does GCM encryption?  E.g.,
> IPsec, TLS, SMB, ...  Is the code in-tree?

I was fuzzing the TLS subsystem when I found the crash. And yes the code is in-tree.

> Any reason linux-crypto isn't Cc'ed on this thread?

Aah, my bad. Added it to CC.

Thanks,
Manas
