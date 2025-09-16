Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77EA2BE034
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 09:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758016743; cv=none; b=dZ0xaqBF2SNwe8W/KxojarLo50LQqlGSzKEldJfhEY+h1D9ldcMqrVrZfjNNCX/pd/q6ZDeL0F+sluF6wChLPpBFOy8v9mpOO+/pScgqeXm00DWm65ibHIXcweuEnUP85NjAn/sJ6t8e8yQXW6ygWNR2lBBQwyF6v5y1cjqlLsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758016743; c=relaxed/simple;
	bh=Qlj3Irf759RURMTstGjX6Hrvn0DetfaZAAndpsTHlfQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ud2I4yNvN5FsPmt/WKQGEMqvidRcu9PFcKA1VJQ4wL0LF7GCRbmrrAwqaNBCAptUDpLWa9ccp7c2zAe4sIU5pn7UQ/Jw3kjAJMQOKfniWivqpURq7tMoUd7koxQpfgNFDZPGkzCJx6Ybc+c4T+7epH7EhEwbwBkrURfxsMpneNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4S6RwJSw; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4S6RwJSw"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-776aee67e8dso15346366d6.3
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 02:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758016741; x=1758621541; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ihmf+x196EH8nuZxldOMUKvsTYF5JZyh/dMEPXLM1AA=;
        b=4S6RwJSw5Z14tJmY+hPq1KbIjSiPtKHi+GAK3GT+Y1IrqiXj7v+GCN/3UuWFIyXXSF
         IHaDSNajtZgLqF1pCjtUnvParoSsJEuYcsuzIu+NWHwSC3jr9pae/45JedKY6Ezs4mg8
         bmzow9s7TWDj5Gk8dCGFNhdtddjttLJJ3iI0Z0mYVbGj0uxdLvK+ZK9RFeb0HmjKFcZ4
         b47uBRYUps4T1Szs0dlhKdbeQvidTZZKH4qQOy4s9W8u7KvpvhNjGEiwzf5fiv2NnLWd
         /m1dwvj9typEbMzzxrvtkdER+ft67qLGTNvBXexq7CEEOvlEwJHUxQjQ4KKeKpDmPsfm
         /ffQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758016741; x=1758621541;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ihmf+x196EH8nuZxldOMUKvsTYF5JZyh/dMEPXLM1AA=;
        b=lSwk6K0q8LN3cM+O7DcXPn4cKCIM1NQp4TY+YU8qxGm0ssgvuO2GIYZi59nEd95xEE
         2DwH8xdg5hSXTBKzSMYhZEepM3bGWrwBV0ajF/i7LkqC4Vue/nnewtrWSxJdwgbs/WDk
         0GLyLwYdlEegpa1TQPzB8TNtfYCErJfHniK3ySevKOIs2OlEENucugN1QVOWtowbpQEk
         QzaWSWTS7EpyweiKqCqIgRd6NeTwQEGq3xFE5ArfA+xrwlrqo5JPMQkcMcIdvIkRJafj
         OL8SuDgJaPPzTKPasELxw7FOSV+XTDsdXa5ehLGo5Ax24fWXBdxJBUvBPWpBBqmE6Qu/
         p7Bw==
X-Forwarded-Encrypted: i=1; AJvYcCX65hON7/wR9bOONx9SiSltvxjDj4PO/GiR4mBLdsJfzLK2v+WvWHX4uGUgX3pvvf87tJ97vcQ00LtOE70=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9CHkFKLSJXberj+ZjMjPkepJ5zi1P+1+gErnmY0ZpBF/f03la
	Ais4Whtr5Hv1EWk71Yi3W00Q+WoBiYqNP5FrPXmAZOpkJ3b7X6pZd5NYkW2ige2DmjABedIgY0r
	uMe5YuxuDIbq/U7wMFnRpPM9fHZVg9uOIFADjFA5N
X-Gm-Gg: ASbGnct3Lv9gkwUpl/Y5DZ8OQy1tOqOu66+F8MniXegPQymffmETaM0GGYrAHhZXUtr
	oKm06LwYDj0Z9ALhl/19hdBVpp3/2O23yjqytCaqyahdqkG3ySzL8VEeKeRGI6hftJfUVfydaL4
	5EKio0KgxNNqLe4r6VlAh8aLPRm0GgOW+wNcvZkZkVGCgS1cjPLZaMzAPBVnCfhK5+YcnRWA1ZW
	ddtpWS6Wmsx8fm/Gz7t87eUAPRJlTCWdIMjB3aW5JQT
X-Google-Smtp-Source: AGHT+IFwGoXQKXa3T3Q3VSrPol5k75GVxiDe8CoLpO3guc9BwwyrOEWBkMhzdh4JyC+tSurxuiqJK5Hw+XiDhw5FhJ4=
X-Received: by 2002:ad4:5e8e:0:b0:723:e1c6:8d7 with SMTP id
 6a1803df08f44-767c5aebad5mr178831206d6.64.1758016740321; Tue, 16 Sep 2025
 02:59:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-3-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-3-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Sep 2025 11:58:23 +0200
X-Gm-Features: AS18NWDFgZtzDhBG5IKRN3iWsXFMSPZcawD_BvUUYRoHSVWInp6fN2JP63m3d4s
Message-ID: <CAG_fn=U8Y=WNTNnP35uwQqxmFOnOV7ptdG0i1VjsaYUe3wfRuw@mail.gmail.com>
Subject: Re: [PATCH v1 02/10] kfuzztest: add user-facing API and data structures
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"

> +
> +/**
> + * struct reloc_entry - a single pointer to be patched in an input
> + *
> + * @region_id: The index of the region in the `reloc_region_array` that
> + *     contains the pointer.
> + * @region_offset: The start offset of the pointer inside of the region.
> + * @value: contains the index of the pointee region, or KFUZZTEST_REGIONID_NULL
> + *     if the pointer is NULL.
> + */
> +struct reloc_entry {
> +       uint32_t region_id;
> +       uint32_t region_offset;
> +       uint32_t value;
> +};
> +
> +/**
> + * struct reloc_entry - array of relocations required by an input

Should be `struct reloc_table`.

> + *
> + * @num_entries: the number of pointer relocations.
> + * @padding_size: the number of padded bytes between the last relocation in
> + *     entries, and the start of the payload data. This should be at least
> + *     8 bytes, as it is used for poisoning.
> + * @entries: array of relocations.
> + */
> +struct reloc_table {
> +       uint32_t num_entries;
> +       uint32_t padding_size;
> +       struct reloc_entry entries[];
> +};

> +
> +/**
> + * KFUZZTEST_EXPECT_EQ - constrain a field to be equal to a value
> + *
> + * @arg_type: name of the input structure, without the leading "struct ".
> + * @field: some field that is comparable
> + * @val: a value of the same type as @arg_type.@field
> + */
> +#define KFUZZTEST_EXPECT_EQ(arg_type, field, val)      \
> +       __KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_EQ, arg->field == val);

Nit: you don't need a semicolon here (also in similar cases below).


> +/**
> + * KFUZZTEST_EXPECT_GE - constrain a field to be greater than or equal to a value
> + *
> + * @arg_type: name of the input structure, without the leading "struct ".
> + * @field: some field that is comparable.
> + * @val: a value of the same type as @arg_type.@field.
> + */
> +#define KFUZZTEST_EXPECT_GE(arg_type, field, val)      \
> +       __KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_GE, arg->field >= val);
> +
> +/**
> + * KFUZZTEST_EXPECT_GE - constrain a pointer field to be non-NULL

This should be KFUZZTEST_EXPECT_NOT_NULL.

> + *
> + * @arg_type: name of the input structure, without the leading "struct ".
> + * @field: some field that is comparable.
> + * @val: a value of the same type as @arg_type.@field.

Make sure to fix the parameters as well.
