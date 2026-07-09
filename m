Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5E92F49FD
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 06:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783577569; cv=none; b=VVjGQ9FZwz8IkTCDRdD0MYIwEUhsYBl6bHMMlVvbHl0UOc3Rmuyzc/RZKmgQuizdjWSIRsYI/a15RARuhMA3uelvf9u+ymj4hPRhkzSlVG/VLtG+i87aCMQ2+M7a/mW0580FKbuI8pws4ZoQXWfdQ7ijq3UDuQwUNE1ujamrUyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783577569; c=relaxed/simple;
	bh=UQgUiICEoYX7KypyjdGPMDkKNZYp44gGMyOoT4NY8jk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qc6X9lnWVIEYIcrl6LSOIdEBCzlB2raOILsFebC7oW1hDklfquztEwN4JiA412hD5sVuueQR1GGAAqhQm2i59VsPEj2qzGIq3hX0SQrHTYEK5eS8NOHmr8/fEC2UANsq/IcIprZE6uJCBK4tu03ZorA/YlQj20A6NJ41uv1VKaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JuQIn8jk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=l5snGDnt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JuQIn8jk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="l5snGDnt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783577566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GdsLEjUUbsQ2OocBAbAJ5juaZkKQkkljxxgPRCvbL4A=;
	b=JuQIn8jk8+2CXcBSvYEppqaUftQjsFdwZIglrNoEYZO9es0NLLUtpc25jvqk3s+j3oNFUA
	gUmZ9CI+qyWgGGRhM1ax6MuKoSg+1QFrcfVg5rVk3hgwdBZu/whMqI+XDMlRDvOhHCcKx/
	pfd1LebyNJlio5GbEnXSNTC/5g/Edi4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-ee4JZo4zMKmx0Ylp8PY13Q-1; Thu, 09 Jul 2026 02:12:45 -0400
X-MC-Unique: ee4JZo4zMKmx0Ylp8PY13Q-1
X-Mimecast-MFC-AGG-ID: ee4JZo4zMKmx0Ylp8PY13Q_1783577564
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-492488f8583so5381595e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2026 23:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783577564; x=1784182364; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GdsLEjUUbsQ2OocBAbAJ5juaZkKQkkljxxgPRCvbL4A=;
        b=l5snGDnthFZXNU9hFqSrTXq8lINP/paK5JxeMRaK41TwSDMEC+3jqhnNUze6oiMeNQ
         K06EZMAjmZ9XL4xLRbuYDkI+9ugh4srJmQDrZLu8S810Sqsnzwn2UoY/0jSMcHJyaLJm
         rFXVGYxf1+4kVlKpd1aZgfRM9KtqPBtzPxTxFlCJRb55aQwFjxRiz7qqVxU196qz1EIB
         i6OQXYVa6xqTIbrO5NAHLxYvQhU8JF15rZZSfkXDWwvDbhdyM1MdcVPhYBkM01Evft/z
         lNGVbtv7E0YdvBYOJi6hDL5VYjTBGv+i3nxEbB4J5VNo3+QXIcaSaBpW0zoE3OjUKvf0
         oTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783577564; x=1784182364;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GdsLEjUUbsQ2OocBAbAJ5juaZkKQkkljxxgPRCvbL4A=;
        b=B1HcRrQtkF0TpUJMc8enIVJVn9vkbi7dfm8h2GaBPFLcPGbetvetOaXaGZjY5rbPWB
         t7JERrwoUrAdBOhOVU4yvzF85reL0i57jhOg2YBXEP3VWldwW2bneTkWHDC2EFdmkKca
         OOYJvQC1xnbBG+87PiM2j8qpOlQWdZn2a+RqX7bWQ3NZas5E3tmR1US9/PGuVfQGZRty
         03jQsVn4C+ycxjlnTw0ghM/Y42W5IvS7otxGVsqvD8JcURM+r1xNyJWpwThs+iShjeoB
         pIoJVyI1vyD9C/nRei7aBOkS1a0wdw3uUfFlcJh8D8hGVc/b3Us9p8NQxsNeSGvEuCg6
         z3Ww==
X-Forwarded-Encrypted: i=1; AHgh+RoqFI42SQBR8zCug3BibOtXiWqy6OVRXIp4LjwmpG3Tn6vXAtHAEhYLJFSTQGCMzbDuukFtyUK87zFxYzI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXOyOsgZ6KbTugi8aKAx2AXL70V9I1CqLd1N+IWc9Qk8rTHz76
	01VPM/XT7Gi7KzuceDscffyOq0JPBI+4wgPAUc/LS+uvokluQi2nc4GTqFmIxij1rgr2bfyftHr
	UQYP3XZpsFWKT683kk2WjvA8TCH7AaDHlll+fZ3SXkvsihKM08Xc8TX0z9LjM2BWHbQ==
X-Gm-Gg: AfdE7cltcPJsOFXztk0POVRcGvxBS5DMntxBQJeDNFdhJI6DaWcRGgF3V7JI8LrwEI9
	k9RJScjHj3MBXJ6emRJtewrtmCLB61PEOP3XOShhl9hu+0Z4Iyb0vgeITjgNJJJmq3MCLuFNnQp
	6IaC2HEGfbl/h+BvkjlogG8B4tABVP3RYkCeWl8+b6vazxvq0naPalgqd29eD1BjUltqKKKifys
	vNCZ+QEaRg+0b7WK47oSt7vJavQjZO75GYBX+C20VJ+vUdJDSNteuRav+A6YqhnxrlD06cPYo/p
	9dSIVbcxYxFqxiw8K5Y2rr0HkR84yDsYo2w5jn415YbEZxx/sHVsvPtmqpy4yigkU9JgvfFkc1R
	auNYzOPwS
X-Received: by 2002:a05:600c:528e:b0:493:c2cc:aecb with SMTP id 5b1f17b1804b1-493e68ef712mr57929095e9.38.1783577564433;
        Wed, 08 Jul 2026 23:12:44 -0700 (PDT)
X-Received: by 2002:a05:600c:528e:b0:493:c2cc:aecb with SMTP id 5b1f17b1804b1-493e68ef712mr57928845e9.38.1783577564019;
        Wed, 08 Jul 2026 23:12:44 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.244])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6df6d9sm41399435e9.7.2026.07.08.23.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 23:12:43 -0700 (PDT)
Message-ID: <fa5ec5b5-3dfe-42a5-ab7a-b6204a223252@redhat.com>
Date: Thu, 9 Jul 2026 08:12:41 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/crypto: docs: Fix some sentence fragments
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260709022651.44216-1-ebiggers@kernel.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260709022651.44216-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/07/2026 04.26, Eric Biggers wrote:
> Currently, the section about the library API for each algorithm begins
> with a noun phrase that was intended to serve as an elaboration on the
> title.  It's better to use complete sentences.
> 
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   .../crypto/libcrypto-blockcipher.rst          |  6 +--
>   Documentation/crypto/libcrypto-hash.rst       | 38 ++++++++++---------
>   Documentation/crypto/libcrypto-signature.rst  |  2 +-
>   3 files changed, 24 insertions(+), 22 deletions(-)
Thank you very much, it sounds much better this way to me!

Reviewed-by: Thomas Huth <thuth@redhat.com>

