Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7C518C932;
	Thu,  2 Jan 2025 08:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735807789; cv=none; b=BIT/v04Z6uTVbi16uj69anfWC8TDH7QVxL7JCzxOwb2sxA7m+FNVJZ6bs20NlYrxyRkwKDaOz4C8cglhosQS7nI/exd45hhitLuRt92PzozzUnzcMbUi/ezbPJR65hoEn5N3RM/3xjTvIgZe+iRCVPxTJKF7ngweNgCP5Ox//iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735807789; c=relaxed/simple;
	bh=WUK1SMs8GoW5u3MdAb41usLLlfEP0svpUzHtinjtVFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QYu2r8hLUsG+BI5zsNUzRQewqLsI+Bg0U2WbzuEW5sTMm5Z264XCQ197rAJ7VNgi4ixk1iNCd7muUej8WVQBMGTRLzmtdPC2g1tPiWUSmXn9xZXWn0lp2UCsBTlnpgVl8Ey9g0y0TXTfn7aMgqSsOQHT6axCE5lSxH7gqIJK6Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aTpU5Zwf; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aTpU5Zwf"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aae81f4fdc4so1717343966b.0;
        Thu, 02 Jan 2025 00:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735807787; x=1736412587; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VfGIzY3hMcgxJ/ViB/BOPn4C/1Cm0PNkLobtpeWUwuY=;
        b=aTpU5ZwfagpMdwQCB19RNIPeCClWILy8Jy+U/6dN2OrR8IduN2PCIruWmnhdE8n4K6
         uvhoDzLcx6KUvvP1YzVCNy+eDfUuHP5oq2eol9bD/XHB4MJiZC73a58Kq7nXhaQKJ233
         VubZ/5+kOtaiqZzg6txMBtqNRH0cSaeMnTKL6v3NJYYFy/9+54WhKdj2yZavYHXKUX1X
         +BnQ+NuRjoMSTtZjZvYi04dIj4M1l23WmLYKbmeZMdJvg2KW7UCHJGqeSh+scqo16Gnx
         j+rudWQOieApuomo+rJ5Ql3Mnu8Lk5oAArAtEXrYlVdfVvs1valdYd9ZjJ/stkEQDrfs
         shlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735807787; x=1736412587;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VfGIzY3hMcgxJ/ViB/BOPn4C/1Cm0PNkLobtpeWUwuY=;
        b=QJEHDK18QUkGqAVbrilpewsXZnr5wTicudzMLItrSr6t2Z6LxiIkKf5eWa/Kf1dn10
         fZBi8HxslAiAw8iYk8gNPPrFwRtrn9aT8wgKGtc0BGRKiwrQELIsi0+g9dclEGfdj6Zt
         ESHP3m0Psz4/hEMMWfGz9arRVDJkPkFklZYZ4rypoPJEhtBr9/Jd1iNfnbI1LVAKc7U3
         Jq884pCtmw7plcBTcG9gEcekuV1feaarR9ySaMXKW9UZPX+bYDpQDD2Yj5dScHYqmfhk
         kiyf8roo3V/yB29m4lXK8aoE7ueDXSijMJ3y4WDxq7g7RlFWrZ7mMuo7Dd0XmVxXEZBa
         u/dg==
X-Forwarded-Encrypted: i=1; AJvYcCWXZBkp2hWFMi+BcJ1SODIgr0wcRDZkTfB9ZC5kY5NZin5o/uIrGgmI49ULR8LSdUyBlDUw7VROH84BspM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxusbFrrdNEkQgA6Qshg4Gy7Dv/JpLUFSH0kGJj5UDCuu95DYv/
	hoUeBDTZILmrslAoP/mEjIDj2NzMyeeDAwkW/N8tDTNf+I+cDucJ
X-Gm-Gg: ASbGncunAsT1sUiv6bOrbI9swySINUvFG2u1mszKMtdQdkBHkIp7CSCwoR0yJ7k0h5J
	eHFbIsjIzvmVQkf3HLZVR6eqQECwTBm+v4paEn7D731jKYS7plT9335xZyfWD+oLgr3GRXq5a31
	RfYlGBWVcKgeMSi3tiLqnsHfMnOOYeFtimhVjw15wbV4UcnlLwcldbVpv2uenrQ1jygC9ywYRAC
	xsvn4vKEWYx41LUOmf38HVUEa25lV8XIXSW+uJSUkteLiWlw51IceaWEKB0k1qpRoVkXkKfklAp
	02vq
X-Google-Smtp-Source: AGHT+IGR6w55Z2SZ3nZ3oj2p1eo1H7ALyhhR760ZcjCEU/ByjDQUNJ9BeQGetfSa6UDnitD3OWjP1Q==
X-Received: by 2002:a17:907:7250:b0:aa6:7737:199c with SMTP id a640c23a62f3a-aac2b0a5b5cmr4943543566b.15.1735807786354;
        Thu, 02 Jan 2025 00:49:46 -0800 (PST)
Received: from [147.251.42.106] (fosforos.fi.muni.cz. [147.251.42.106])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f0159b8sm1766632566b.157.2025.01.02.00.49.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2025 00:49:45 -0800 (PST)
Message-ID: <86e3502f-5d24-4779-9d3b-3cd79288fa0d@gmail.com>
Date: Thu, 2 Jan 2025 09:49:45 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: vmac - remove unused VMAC algorithm
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
 Atharva Tiwari <evepolonium@gmail.com>, Shane Wang <shane.wang@intel.com>
References: <20241226194309.27733-1-ebiggers@kernel.org>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20241226194309.27733-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/26/24 8:43 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Remove the vmac64 template, as it has no known users.  It also continues
> to have longstanding bugs such as alignment violations (see
> https://lore.kernel.org/r/20241226134847.6690-1-evepolonium@gmail.com/).

...

> No in-tree user has appeared since then, other than potentially the
> usual components that allow specifying arbitrary hash algorithms by
> name, namely AF_ALG and dm-integrity.  However there are no indications
> that VMAC is being used with these components.  Debian Code Search and
> web searches for "vmac64" (the actual algorithm name) do not return any
> results other than the kernel itself, suggesting that it does not appear
> in any other code or documentation.  Explicitly grepping the source code
> of the usual suspects (libell, iwd, cryptsetup) finds no matches either.

AFAIK it was never used for dm-integrity / cryptsetup and I am not even able
to make it work for test now (isn't the vmac64 alg module init even broken?).

Just remove it...

Thanks,
Milan

