Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52813B47E6
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 06:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783577989; cv=none; b=qgNT+mwwrus+FLElmVxC5UXN5Mx0XIv1rmsc3aGn0DfFRwIMRLjs4xinGyBM70dOHQeHqWYhAo/yOC8dkNKBkbN9xUMz9LLEyDX1Kf8DwSPQdlKG1kmnrvz3OET9XtmNrX/F7ggDPK7qWmriDOz2oAghCKngoUmV4nHCZmZrwok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783577989; c=relaxed/simple;
	bh=lA5oC7wfzNgO9eg+QpgDGee5/cyUa7Fj5mHmFhaVEN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uNmobuxe6479k8+wHWScPUT2bQjkmJme0hWFz0H3tJyWTL6LuH6rgV5fTy85TnBdMcV6+T/6oUK73bW+1yVR+tia1qlMxffp1zBs9WbGQzKAaDG9+1fF9iW4f/bPqwQZykGzsefxGfXQSiOzJuUycoVCo9/a2qSFSPvKv2spfVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ee/4igzL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hiAgNrdK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ee/4igzL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hiAgNrdK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783577986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qpxYAiPSaSnLcsbZMbEmZWD1GqxQDX+qAlfBTgCD48k=;
	b=Ee/4igzLhNp3uEgzvEuNkOlWJ+/sOvAPKPF/kRG4+MR7P1ryBwPXJdRniQDm4jjL3UAOii
	QmHcMJG0e6QPsbgwl2UZ5kg8/fevdvsP3Cf2rMU6uCDr0VCWYyPLUGJrenLPaqY+PD17Sm
	Ao3kUqmm/ELb7o8yBuu74raT8omClqI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-oM5ld3iuOYOOHwuG6bLgfQ-1; Thu, 09 Jul 2026 02:19:45 -0400
X-MC-Unique: oM5ld3iuOYOOHwuG6bLgfQ-1
X-Mimecast-MFC-AGG-ID: oM5ld3iuOYOOHwuG6bLgfQ_1783577984
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-493e0042895so8866125e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2026 23:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783577984; x=1784182784; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qpxYAiPSaSnLcsbZMbEmZWD1GqxQDX+qAlfBTgCD48k=;
        b=hiAgNrdKgInPAcXIw+FrgGUPufvvlQh/eK4XdVimVrEbiJ0d7C2+pG1aj2tKitjzxP
         HxwuD6nl+T1EBdUOezkDm4N65ATAHABiRoB7xb98vA8rNEZ2Vu72UonZKIH551l3tX3b
         ECyNBVrshmstyGGEG8rSSc2uOW9eHCZYV0XQjdsz8vgmS7I0AKAGTIB/jhq8yBWX592P
         zZf/reGKYVaJ8D65lc2rIuYpZGzk0HraI150Sm+XoxFC7g4g4OPg/bDybZpDJ8Mz9gno
         VPHAA4Y4/tv8j1GTatiiFyStp4Bkz3EJ9eaCbLUuUX2Pp7NFv2Q+O9i4UlfUvP8hQq/y
         2BLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783577984; x=1784182784;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qpxYAiPSaSnLcsbZMbEmZWD1GqxQDX+qAlfBTgCD48k=;
        b=WP4W7rwn4n6YwYKagTd/2xSYQz2ISsmwJt4I8THARRwheNejBCa2g2U92fNdqAamRt
         +AyCTqVe/zrVL3P94xRig+YcAiP9D6duKlgUGO7cAmNnWNusxv7rh4SnaMoN2YCxXxEM
         SmZBlWZZMwIyMHC2U7a8uwe/ZuO6E6mYupPEQlsuSNscVmQ9cs+/4PRoeubvqPktHrnx
         Kl88BQJ9+bRu6Wt8IuL8BUpimD5Zy/OscmyS5QTfwtm3l+1t0+8lQMoLJKAyJjZCotzn
         1SFRM1zdBkWO/aObYAcnsrI2MxVAqxD1+5Hi1xOXwu0bvwlxD7KzkaJ0ECIwUVbWnR6K
         EC8Q==
X-Forwarded-Encrypted: i=1; AHgh+Rrw5P7V3WsdpsYscL05o6aEfPbT5KGB847j2W4pFKfXjRV0cWMtcI3kM432TxErpAYZyPDsVf3RLWmsvz8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlYoBfNP73S5fqTfHoQQXU6Hxn9OPE3W3QIas+U59lUhPy50Ok
	W5VfdDACK7XG5wfUj/Kt33qWczhowM0gTjAEObMboS/YJM0h08TgCFeiCxPcBu2pOIsp0X013YI
	AwjkzjrD3Ctt9aqdwszvRVBfSMlzIIYb6ETpuXUYLEiYCEP7W+kcmVn5sb/5ZNGYXvQ==
X-Gm-Gg: AfdE7cmeFVEC0dRjH0C8WWG1oMGofKm/Nq+exBUG+qqbbLawC15c4w8JHHT6mNLvKzJ
	MeVopYhU4WrD5GwDcksPEh0H1aWd+4SfIG7DQobBxmJUh7qZfWeqv2JMAxQNarAiCECvRvmRl2S
	7Tby9oeukqPLninppCfUh1yIB7h7CTWiGCxg5oUQ32mAY8T4dVZ3/qxLW9cWQsXBRYoFeyakOJg
	jpdhxmPriCUhj88EDF1IOIkoditUYasr3hrk0lepTL3OLy3Hu96x8NbZ73aeJ0aIf23tLrOJvF1
	ui9vTtF1a/saKzr7PyTgZwmxAcaBzDYQYq5B15D0lgn/YJm04qSgsyK9fHMViBF4+xdDsO+MB8G
	jSJqFr3/p
X-Received: by 2002:a05:600c:8b17:b0:493:e6f7:ad75 with SMTP id 5b1f17b1804b1-493e6f7afb1mr49809175e9.11.1783577984254;
        Wed, 08 Jul 2026 23:19:44 -0700 (PDT)
X-Received: by 2002:a05:600c:8b17:b0:493:e6f7:ad75 with SMTP id 5b1f17b1804b1-493e6f7afb1mr49808885e9.11.1783577983859;
        Wed, 08 Jul 2026 23:19:43 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.244])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742d0esm34679365e9.13.2026.07.08.23.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 23:19:42 -0700 (PDT)
Message-ID: <aa109637-0102-4341-8bb3-02bf2a90a170@redhat.com>
Date: Thu, 9 Jul 2026 08:19:41 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/crypto: docs: Improve introduction sentence
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260709022747.44635-1-ebiggers@kernel.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260709022747.44635-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/07/2026 04.27, Eric Biggers wrote:
> Make it clear that lib/crypto/ is a kernel-internal library.  It's easy
> for people to come across this page, especially the HTML version online,
> without that context.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   Documentation/crypto/libcrypto.rst | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/crypto/libcrypto.rst b/Documentation/crypto/libcrypto.rst
> index a1557d45b0e5..0733e603d229 100644
> --- a/Documentation/crypto/libcrypto.rst
> +++ b/Documentation/crypto/libcrypto.rst
> @@ -4,8 +4,9 @@
>   Crypto library
>   ==============
>   
> -``lib/crypto/`` provides faster and easier access to cryptographic algorithms
> -than the traditional crypto API.
> +The Linux kernel's crypto library (``lib/crypto/``) provides kernel-internal
> +users of cryptographic algorithms with faster and easier access to those
> +algorithms than the traditional kernel crypto API.
Reviewed-by: Thomas Huth <thuth@redhat.com>

