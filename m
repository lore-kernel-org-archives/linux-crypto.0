Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A577650A60
	for <linux-crypto@vger.kernel.org>; Fri, 15 Mar 2024 17:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710525342; cv=none; b=DIt7Pt0MInybuhzeEH0WNva+bYjzXTO5t351zh38SmtLYFPEmPmQQobRnxly7hHNg1nXapLqX6SKpmLpiuTEXfuY8nlPR0Z4YRptHiGkOUEDPHj89tIqzDthaAYiZRuQvML0nFQg3elj6yPdXHSkFVGmYHcJgxbqD+VKotUYgd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710525342; c=relaxed/simple;
	bh=LGt8WK/1hB86Nlqgbkb4iVLi6lNryc9HuXvBLw4wgBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U00rAWozB1r7+ZRmhl/EtK1SX84kPfTqE7k05hEEPZF18JBf67jRI2KeywE2Cek1d3N1DeZMKrmU2MxCSfNQJq61Bhy1Q7sbAme1OhU7N5RQ3O2tELNyzgVC5rQgHNFDdYYEbYAqKvA09kVRxvmPF0S7yzcqNh06iE8JeVxI2SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=il/XMT7D; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="il/XMT7D"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-dc6d8bd612dso2228983276.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 Mar 2024 10:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1710525338; x=1711130138; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vJ9xZeTvmbYgKVwvBBdEbKjvWmRS5XdcC5rxmLmvB6g=;
        b=il/XMT7DvG7VHlrNe1BaRJZYwS1R42OGOl0kz+erO8m4fpAsdWoOG6e+jPJkSk/vnE
         y5AMf3vkgSJW56LxtHgvf+7sKbiE2KoTrt5IWwvwFJjIkYQl87VrIPHaYlSK3bOeJ4cI
         DTHsxdGtED4RAzaMr/z0MJnDLC9Z2D+MEq596hjmvUHg7tbkPpThdhYeyQpWWxsczJvX
         vRKFdEbBPc/i3TFDGuX7I4g0/hDFL593fob7aMialKvmUibQmhxh3RzhROdkpyK5VIni
         L9YoiVe3e7j1pmQuzUmqPEcqc3YtL9Q8tgXgs7Kh2PnlSc5AQqKxzxXVkkDfoX1f3kGM
         mCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710525338; x=1711130138;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJ9xZeTvmbYgKVwvBBdEbKjvWmRS5XdcC5rxmLmvB6g=;
        b=mmWSxG/nD3ajfck5WzMtZPkkFxGenNan/AjcOn36vyrnFjFFXAEbLnQZCKdBUg+/tX
         kcvELCr49AU6NnFUWSLAhfPC0U+sM2PwqHNN7Z1TZegLsM/oSdWqd1mgQTJ8gzwa6V9R
         cCwrk6PMPXQNej8cq8fzEjwKk2R+U2/7CuuJOAJuZQuhI9kijtI0TmhbwHCzPcoQe3BX
         kLJbAqm/W3yb0mWysz1PTTcDmzSzcgk4/fnz8YOpNc12RglYqWacdIQHIfa40zU52+gn
         ncTTBFQbtngeLhB5JOkgSMxaR/U7RzRGxQaPaGanUVAxOYFytt8HaAp6C3eyyaIvJ21I
         idEQ==
X-Gm-Message-State: AOJu0YxoXf+IwVlvIdQRg9yBwK9dYJb80HNt4FG2pHdOCBSsDMj8yo9W
	ATgiXhVrlKCfMYurROiCjlvaiu7OTJs3ThbYL9/QiT/NZP4vx9GcAd+RoifTk+YI2gwedv/Jg9k
	x
X-Google-Smtp-Source: AGHT+IE5kr3EfmKvWeo/HTCiCav1ad4ePMl8DcEQtX93jnr9ryzM3scbfrTIz2Kec/6bwW9kFSgRKA==
X-Received: by 2002:a25:b119:0:b0:dd0:6f7:bc3b with SMTP id g25-20020a25b119000000b00dd006f7bc3bmr3280728ybj.10.1710525338551;
        Fri, 15 Mar 2024 10:55:38 -0700 (PDT)
Received: from localhost ([184.147.116.200])
        by smtp.gmail.com with ESMTPSA id d6-20020ac86686000000b004308bdcfc2csm2187661qtp.6.2024.03.15.10.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 10:55:38 -0700 (PDT)
Date: Fri, 15 Mar 2024 13:55:29 -0400
From: Ralph Siemsen <ralph.siemsen@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: af_alg - Disallow multiple in-flight AIO requests
Message-ID: <20240315175529.GA268782@maple.netwinder.org>
References: <ZWWkDZRR33ypncn7@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZWWkDZRR33ypncn7@gondor.apana.org.au>

Hi Herbert,

I have found a regression in userspace behaviour after this patch was 
merged into the 4.19.y kernel. The fix seems to involve backporting a 
few more changes. Could you review details below and confirm if this is 
the right approach?

On Tue, Nov 28, 2023 at 04:25:49PM +0800, Herbert Xu wrote:
>Having multiple in-flight AIO requests results in unpredictable
>output because they all share the same IV.  Fix this by only allowing
>one request at a time.
>
>Fixes: 83094e5e9e49 ("crypto: af_alg - add async support to algif_aead")
>Fixes: a596999b7ddf ("crypto: algif - change algif_skcipher to be asynchronous")
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>---
> crypto/af_alg.c         | 14 +++++++++++++-
> include/crypto/if_alg.h |  3 +++
> 2 files changed, 16 insertions(+), 1 deletion(-)

This change got backported on the 4.19 kernel in January:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.19.y&id=19af0310c8767c993f2a5d5261e4df3f9f465ce1

Since then, I am seeing a regression in a simple openssl encoding test:

openssl enc -k mysecret -aes-256-cbc -in plain.txt -out cipher.txt -engine afalg

It fails intermittently with the message "error writing to file", but 
this error is a bit misleading, the actual problem is that the kernel 
returns -16 (EBUSY) on the encoding operation.

This happens only in 4.19, and not under 5.10. The patch seems correct, 
however it seems we are missing a couple of other patches on 4.19:

f3c802a1f3001 crypto: algif_aead - Only wake up when ctx->more is zero
21dfbcd1f5cbf crypto: algif_aead - fix uninitialized ctx->init

I was able to cherry-pick those into 4.19.y, with just a minor conflict 
in one case. With those applied, the openssl command no longer fails.

I suspect similar changes would be needed also in 5.4 kernel, however I 
neither checked that, nor have I run any tests on that version.

Regards,
-Ralph
