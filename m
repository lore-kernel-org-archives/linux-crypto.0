Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCC444C93
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jul 2024 08:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720427002; cv=none; b=jxo8/7b5WQuC/OAUm6Jj/r01YRdj84VgUBSHEljcZlN837wNiSi11VfuxGvb17Y9tWdG3aA6mfE+hI1mZLmwzflFH9xr+hQXo1oStjzM0+VL0iJvVuJeR9orDoCDFpZ+Sg5ngoZ5OskuSDZkiRchWHBUFIUp7njDj/9Kasynxx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720427002; c=relaxed/simple;
	bh=u9mN5ZVUNKs/SnqYF+TXngxMJE/RrZZ3YGgiYU4pUlc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Jf63QaXN/EGu0Ww84fhqrfm4qPY8w+wIJ7bVzHeDu97nrstB0XpWanBQma5cowbdvIP/UoinLlyHjIZkbv/9Flnuee5Vq/FGy0wFQpvEVMJkm0UySCibp5/T1/t9sN9bWVAWl0VSIVmvinMSl/9oR26CLM5q9a9ieQSgkOTL4S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OdwUleTs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OdwUleTs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720426999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MFZguN8EVoK7OymJmQKuCA2IoYCB5NF4rjLMBNd7sSM=;
	b=OdwUleTsMN+lgcnYznmcQ6M5fIDSVyaD38AcDcapcaBcdUBmrobNaBEiJqMY3MvY+3WjJf
	QicZO0NX3C/8xFocazAtjLhuJrR3Hryfgi8GQ2O3rYuXDTpI10kmIIMb6EX9QulWy6NSC5
	qHZLR2y7fDL6gBa1uXS2mRLgv3AWGlQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-Sc8Fr-N4PFaA0C3wtA3VKQ-1; Mon, 08 Jul 2024 04:23:15 -0400
X-MC-Unique: Sc8Fr-N4PFaA0C3wtA3VKQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-57851ae6090so3262396a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jul 2024 01:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720426994; x=1721031794;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MFZguN8EVoK7OymJmQKuCA2IoYCB5NF4rjLMBNd7sSM=;
        b=GPq6/17YM7jBi6XYO2VrZGtWxP7mrQ05aK4DO5f7V0AJ/bzgspMR92dPECcnfNoEu5
         bSNNG08hqiBPLv33xMrDQ+krHS+LbkpN9MMa8rUhIIYZqEww7yStpHOEh7/lMt27Fzdc
         ZiYThpImHiMn/eROeyYUsgpy4ftzRLZQGXNCARhl4FAv0UWZpzrQe0yC3xGfMan7D9ft
         sHeU/dUK0AvBmr5n0W7Uby0B9l8mkMR+m9kGYEd8kALQTmyMvn2UWIAeF+Q/Hu2IFcHn
         tL2oK9XwtyPxW2NusHvBN/clq5m2D8LNdBXnpVeVXMHRalrcs2KVX40reBbwwLlRHKaE
         qAow==
X-Forwarded-Encrypted: i=1; AJvYcCXiPzdlWDyWdTSyZZTmYWzmnVWUTh33jaxfZLTTRZcIH/z2p5JVN2/85lMZY16llb7IGVQkcaSFBU4XR3QPg0h5Wz5ogufXDDv36XIK
X-Gm-Message-State: AOJu0YzASLyLZcRCWvuj88KW3f7q7qYyoD+vsEVLMGwHde7nVfD1BQby
	1wiz6KvfP1nm09b3K2VxaOtyn5sqneJBwmXIBw8TsqI2hM1MaETTugHBptTlDwvq0b7H9LZatG+
	AMXkAlzuFuw7OnlnCkMKYD6pgxgpxlS4mUAz1cItIcMLirtyZkiezGUQZtvfAuw==
X-Received: by 2002:a05:6402:1ed4:b0:57d:466a:246 with SMTP id 4fb4d7f45d1cf-58e5a8e8d16mr7877318a12.8.1720426994411;
        Mon, 08 Jul 2024 01:23:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEI7JB2DQx/fSTi7SMHizXA4YiB8BrliEg6vtno1cAdZYwZNeZhUcg0gPX1yenfeB1h1VEyFg==
X-Received: by 2002:a05:6402:1ed4:b0:57d:466a:246 with SMTP id 4fb4d7f45d1cf-58e5a8e8d16mr7877294a12.8.1720426993994;
        Mon, 08 Jul 2024 01:23:13 -0700 (PDT)
Received: from [100.81.188.195] ([178.24.249.36])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58fe866155esm3527497a12.20.2024.07.08.01.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jul 2024 01:23:13 -0700 (PDT)
Message-ID: <8bf64731-9e5c-4c8c-b46b-5b18ae3110a1@redhat.com>
Date: Mon, 8 Jul 2024 10:23:10 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 1/4] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
From: David Hildenbrand <david@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, tglx@linutronix.de, linux-crypto@vger.kernel.org,
 linux-api@vger.kernel.org, x86@kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
 Carlos O'Donell <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
 Christian Brauner <brauner@kernel.org>,
 David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
References: <20240707002658.1917440-1-Jason@zx2c4.com>
 <20240707002658.1917440-2-Jason@zx2c4.com>
 <1583c837-a4d5-4a8a-9c1d-2c64548cd199@redhat.com>
 <CAHk-=wjs-9DVeoc430BDOv+dkpDkdVvkEsSJxNVZ+sO51H1dJA@mail.gmail.com>
 <e2f104ac-b6d9-4583-b999-8f975c60d469@redhat.com>
 <CAHk-=wibRRHVH5D4XvX1maQDCT-o4JLkANXHMoZoWdn=tN0TLA@mail.gmail.com>
 <6705c6c8-8b6a-4d03-ae0f-aa83442ec0ab@redhat.com>
 <CAHk-=wi=XvCZ9r897LjEb4ZarLzLtKN1p+Fyig+F2fmQDF8GSA@mail.gmail.com>
 <7439da2e-4a60-4643-9804-17e99ce6e312@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <7439da2e-4a60-4643-9804-17e99ce6e312@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> As a side note, I'll raise that I am not a particular fan of the
> "droppable" terminology, at least with the "read 0s" approach.
> 
>   From a user perspective, the memory might suddenly lose its state and
> read as 0s just like volatile memory when it loses power. "dropping
> pages" sounds more like an implementation detail.

Just to raise why I consider "dropping" an implementation detail: in 
combination with a previous idea I had of exposing "nonvolatile" memory 
to VMs, the following might be interesting:

A hypervisor could expose special "nonvolatile memory" as separate guest 
physical memory region to a VM.

We could use that special memory to back these MAP_XXX regions in our 
guest, in addition to trying to make use of them in the guest kernel, 
for example for something similar to cleancache.

Long story short: it's the hypervisor that could be effectively 
dropping/zeroing out that memory, not the guest VM. "NONVOLATILE" might 
be clearer than "DROPPABLE".

But again, naming is hard ... :)

-- 
Cheers,

David / dhildenb

