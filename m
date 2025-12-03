Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478342F25FE
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 11:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764762356; cv=none; b=dxm8zw78uT3BSltY98T3qnB2AW/kQCC1MQMAo219oJjeDWGJc3NBaoE/u3VCjY9OphAhgo2EOt+zHWesVf3yozXkmz+B6wyRtGS3MQDDUDg+oQODAfQ7bLaddkjOHJdBNUoF5eVuWzbS00OZRGMsy7QztH0xNc0hyqQUbr6fAsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764762356; c=relaxed/simple;
	bh=jfvwANw8GGCqWqo0EONSZfGmof/FFpic3hgfJnrQewA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=RCl8UTScurK3pxgB9jopRTo5X+A2d0J0iI6KUU2pMhNb5+DSlhcaV1Him2LE2ADExc1nkWENskLSU/YhxaNBeqqA5MNwoTRo/abgUAxN2FnUshi3hAob9tc/j6TQOfffrlTiBZXEeZ5iqjlZgg/z1ttqp4pBc7Smi4sp3pTGWaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NJEu/Dgb; arc=none smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NJEu/Dgb"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6443b62daf6so102803d50.0
        for <linux-crypto@vger.kernel.org>; Wed, 03 Dec 2025 03:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764762354; x=1765367154; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jfvwANw8GGCqWqo0EONSZfGmof/FFpic3hgfJnrQewA=;
        b=NJEu/DgbLyc1l5ReFmZi/I2c3FbEgmnsZbRqgb+xCHjYxiCu6EOip6W9aHy+mT49cf
         /VSIck/LZutkUDAZ9y7hbYzlGgm6fLClopm1rJaLUdmiPTonNOUjane+1SsEccJ7znky
         poggxx5Io2fPjl3b9pGJVJLmjyXIU/vsAOsyUwE/YhJcYblsdsr1MpgGQKxqtux310d1
         V5u3yzP1uh/6Gwgo7s/knsDwHjPN6a17MLKrAjJn2spLpI9ftPYOKT2iCTT1uDjrZePi
         Q+N1ugicQ10PwSMI+LiS983gxlCvi6B5X493q4rqGa+dQX93o8yQZ232mcEmpXNQWkF9
         1RbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764762354; x=1765367154;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jfvwANw8GGCqWqo0EONSZfGmof/FFpic3hgfJnrQewA=;
        b=EnEL5AAFyIfRB6CFE9SEh4YE2ihgJ7UpQ5tpla8k3FOWWNmyygivm6/b1AD3Omfn7F
         K3POmlUJOTP0Y2+DUs4cGfApt5NcE1r+ebowbLfqQRw11UCMrRo6TgNfCkVV/fVK2f3j
         bE/7OfsLsptcucdC+2J3iU2pRWFKiLTaLdtl0MUkJsVom3gMM0Yc+Fx7j3ohlHVIUL2Z
         I8SgIvFtAKpjUI7d3X60dR9penjfyyxsXbZYB4zmR0brcf9srt6WMsuhbEs4ENaehAga
         ydEDzxiL0jlUWJrx/nHtyUUVbw2XcXrYPEa6D4akVt8Cmur6N0RbfhTrRT7QesyI2wmi
         +I7A==
X-Forwarded-Encrypted: i=1; AJvYcCXU0WyNryGg20cK0I6R+jrutSO9gBqNoluDEMgHPc1ySfu+m1lsNfEqTHvRsu183CIE6FKeQgkypgiQcKU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2GiK7mLvpJL5KAqNZXbLKtoT6OB5dSnBHrsBvKrxL/8P40abw
	WNwINw33INi16pSxOAi2taCLLNy45vQ+WfImmlfjeaHFe77ay3nMSu0JoJka8PD2cmnvWe7A9cZ
	dZMy21PKlj0x19bpOk6zR286BiEGGbiQ=
X-Gm-Gg: ASbGncvhAuDw6nz3fpBMPfbadayf7M+5ColuHH8BrFeqEE7KMz2nWLh038raxbxwv7Z
	/LzkgTaFzrj9e1shq6ZUStF0u8CaQSgUoSAeawJT2a1bP5A4gVOdynrETrXYoDQvHNEpYdx/suI
	2TWQmj4QBwv4TR3x6e+mehnbQ1k3r0AZMKHB6B+WfGbdTHyCDPsMo24C20vr3C3mnkA/eXeR79S
	VPi2P9rAoR1YqSSOd9PA9XB/4rVq9+X9ejGKux5SdMMzO+kkrFttU7Hse8TwO+xFo5bBuTxgC7G
	ZFUxRd+SgQ==
X-Google-Smtp-Source: AGHT+IEzU9CLw4PO4lmYYb5juhpUEGTESsPrMuN6tZE9k8WytumrivMEP4GUWCLQ68YIJ8LPazd59Iywcm9CqJaSUrA=
X-Received: by 2002:a05:690e:128e:b0:641:f5bc:6947 with SMTP id
 956f58d0204a3-64437073804mr1442037d50.75.1764762354130; Wed, 03 Dec 2025
 03:45:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203031118.32421-1-dqfext@gmail.com>
In-Reply-To: <20251203031118.32421-1-dqfext@gmail.com>
From: Qingfang Deng <dqfext@gmail.com>
Date: Wed, 3 Dec 2025 19:45:43 +0800
X-Gm-Features: AWmQ_bmfGntaecZ1RTUsCEUg4Yl3KtYpBbTaL8cy1gSBY1rv4jjjOQZWeIddQrs
Message-ID: <CALW65jZw0O4-_=koAWz_F=wv33vFZy8nkQs-RHjEczRv6ZDiVg@mail.gmail.com>
Subject: Re: [PATCH] crypto: eip93: fix sleep inside spinlock
To: Christian Marangi <ansuelsmth@gmail.com>, Antoine Tenart <atenart@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Richard van Schagen <vschagen@icloud.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Please disregard the patch, as I found out the issue is that
crypto_async_request can be in an atomic context, so the driver is not
allowed to sleep unless CRYPTO_TFM_REQ_MAY_SLEEP is set.
I'll send v2 with an updated message.

Regards,
Qingfang
