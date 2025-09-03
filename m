Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9AF2F5304
	for <linux-crypto@vger.kernel.org>; Wed,  3 Sep 2025 09:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756893267; cv=none; b=S0uzCNERGswnWv3Zc15zCggwUktCQDKZtgC1ov7vLiDOIGigpdnGXn+sYRDHpH/iaGYIfuBExCkoLOtcrdV4GYM3oj/YJQxxAIyxRrVTH+q8enpFz61w80V5RpsYmLQXYBiIcftvNkTrY3cPPPn9gj6pdoqPrCL5xAPwsi1+DIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756893267; c=relaxed/simple;
	bh=RhkEPFn1xmViNE2hu3hA56fTjRO4yTnz3NaB+IP/EoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fqB1IWoo6rWmvhwZPmu/iwxB9zSDAC1GKLF6aVCHtZkPO0sPcFTiDMXJsl11S/OXCjcTAlbmEguUBJ1stQBrKJMxDi6hDVsRts2UVGDnAzRC+E/B7jmYFTlZx/DMDSf3ieMm4CE5nwDYXRAHlDGsrmHyP25kMjyito3oHSZLvAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q0KxacRn; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q0KxacRn"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-7221ce7e814so9414326d6.0
        for <linux-crypto@vger.kernel.org>; Wed, 03 Sep 2025 02:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756893264; x=1757498064; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n2Rzk7zMFMEV7RW/mx0yGAjSShG/CZFQjSUWSelah8c=;
        b=q0KxacRnI/ha291IpqX2IyTxElVbf56j6fSYRbRxV9de97Cpxim8Ry1B+IzgVWlgT7
         x/xsQQFi0txDBQagdFu4hR1mFxlmoyuL74uc/r8oVD/SjU3IqPh3VTfZr3BiPGnII8tv
         k3T0OLKvBE1b6R1JOzLwtWQnA7ey7BkWKPngtHvhhHxJMw1xGRjq/5srXOiAmJuw/BG0
         8sEoY65GjPcXt6h8L3TdfDGGYA1DsA64nfecSIb7rCq/ZJae3safYSW9DdwUTMAz+cg+
         o64hoWEueKUhm3I8bF9Q7l4wXNqNbZarcOaVc7Dr6keltO3rUuiMGHL3+SanNK8x4vPy
         MnPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756893264; x=1757498064;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n2Rzk7zMFMEV7RW/mx0yGAjSShG/CZFQjSUWSelah8c=;
        b=vM1SR+2RK2NfXBkErCE+n5zBKbIEGx26A5zYMdkU8bWYEURz4SVGiRch8is5Hhgnbv
         dZKKwWlDHx7ItP3sMJoTQTI6jwwC4LaZ0wjBSN+2ULx8unJbTqVwGUqjmJ3uPbFrG4Zz
         K7FjpwbZ1fBU59P4M/lZVJdF5HbLeJ9tAc7X+dQEqvruLUk4X/4DqhypEWCLNjMHGCXq
         gYAJhfwSGsbqUUv15spnJSEXfQIMr51RGZ8fPPburx/Kh/ib8gXjm8ynFmuqO/yNXUOt
         P74amy5rgZBITiIbRGX5zd71qxfj25EOMv6BPOgIW3QcsRCIi24vo4OzlVnddMiaaPCs
         cZ0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXgFGsnlPX34QvMaEIcDxCjeoBlS1MynKoRThBaYRbE3012wYS7lOZVy9Hg0lg5VTvGQCGYs6OYjlRoty8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0EC1+F8tvGa7XO4PRCy2NseeNPbZ1CHo82KYTbo0r+fDYvAW7
	f9kLGw8Pwo6e3Ib07RFu5f2sOd2QaHQyA6icBWb59W05hbVfBqndMfxhYw8wqRJIF9wVSAPc0ai
	XP2dYbwG1iESZbcXX1hTwNC5PVgU3bbX/oLZ7ljFJ
X-Gm-Gg: ASbGncueOycfhQIajWCMhd7iLpO6LP+2ZWs+8XsMe4QU2CfQNFuQKoLdYoDBqYyrLF1
	Mp0DlyyTNaZfbCMAbVi6GIdFWWkTlJ8dk80jRdJ/dQmkdH+ki84Zw8i6L2HEvmxsVwQtpIQg31A
	BED6oQrXvDTPRk3jB2nDycV4uasY67/c/ws35dvxlrwoduP5j5+2ibnFzrLHYmsZrSeguemxfJ8
	ayP48Riw4UIFp/GplLMbD9GB0QmP67OWIEqWiViPUM=
X-Google-Smtp-Source: AGHT+IHHxZ7Hfb0qrsN8QMhYVtNZyxle5uZ0dlr8VDvhNcjFGlkqe7J8XNVXFgqPaB9c4DZ7Jz/xYjkzW/9XPfW8urE=
X-Received: by 2002:ad4:5dc9:0:b0:70d:fee8:e588 with SMTP id
 6a1803df08f44-70fac870233mr189626166d6.34.1756893264049; Wed, 03 Sep 2025
 02:54:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-4-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-4-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 3 Sep 2025 11:53:46 +0200
X-Gm-Features: Ac12FXz83uIidiq7UvM7XG7YD3kWK8XfBqOv9db-g6kDKvYfHmTPpgNK10-2Ga0
Message-ID: <CAG_fn=UX9+1=CwGB-KCe+s85ZzQXfhqO+2dJVqs93XLKYedeWw@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 3/7] kfuzztest: implement core module and input processing
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +/**
> + * struct kfuzztest_simple_fuzzer_state - Global state for the KFTF module.

s/KFTF/KFuzzTest


> +
> +               pr_info("KFuzzTest: registered target %s", targ->name);
> +       }
> +
> +       /* Taint the kernel after successfully creating the debugfs entries. */
> +       add_taint(TAINT_TEST, LOCKDEP_STILL_OK);

Maybe elaborate a little that we taint the kernel because these entry
points allow calling (almost) arbitrary kernel code upon user request?


> +       /* Patch pointers. */
> +       for (i = 0; i < rt->num_entries; i++) {
> +               re = rt->entries[i];
> +               src = regions->regions[re.region_id];
> +               ptr_location = (uintptr_t *)((char *)payload_start + src.offset + re.region_offset);
> +               if (re.value == KFUZZTEST_REGIONID_NULL)
> +                       *ptr_location = (uintptr_t)NULL;
> +               else if (re.value < regions->num_regions) {
> +                       dst = regions->regions[re.value];
> +                       *ptr_location = (uintptr_t)((char *)payload_start + dst.offset);
> +               } else
> +                       return -EINVAL;

There should be braces around this return statement, see
https://www.kernel.org/doc/html/latest/process/coding-style.html#placing-braces-and-spaces.

> +
> +static bool kfuzztest_input_is_valid(struct reloc_region_array *regions, struct reloc_table *rt, void *payload_start,
> +                                    void *payload_end)
> +{
> +       size_t payload_size = (char *)payload_end - (char *)payload_start;

You seem to be casting payload_start and payload_end to char* almost
everywhere, maybe declare them as [unsigned] char * instead?
