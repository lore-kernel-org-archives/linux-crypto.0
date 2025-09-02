Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3742E9EBE
	for <linux-crypto@vger.kernel.org>; Tue,  2 Sep 2025 09:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756804935; cv=none; b=BoTwtIo1u7W1oq15TEVfJVFrRPDYOxhAt72WlhsErWLg9VYN2RxSCGudF4auLV7IMHzwL/3xfHCFwDXDbUVJKHgdGHzkj2lm8i/0wFW8upppRP3VHcBVijk/c01APYfr0SOdJR5QQmCzDPXEK+ym71iJ1VfBpXcRXnVI0i/9lAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756804935; c=relaxed/simple;
	bh=Pv1NlzKjL0xFo8BfGbhy/7KnNZN8WrItjraHEOkXixw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kzTZP6ZDMNgQfDToWsJCVoQX5vZT3zSvnGxa8OZJkExt6ZA2c5yv+Pu1GN9o9l6rgQL7pt10eVIeIO5QYiEvm6A1JJUYoMMxFmT2yNKAe6dam8p8lFc4jOAYKB47hifww5UAO2l01Qt7klrb/qY4Z/yTi+b901mKfZIvef1mKAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ursulin.net; spf=none smtp.mailfrom=ursulin.net; dkim=pass (2048-bit key) header.d=ursulin-net.20230601.gappssmtp.com header.i=@ursulin-net.20230601.gappssmtp.com header.b=BjJ4DkI0; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ursulin.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ursulin.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ursulin-net.20230601.gappssmtp.com header.i=@ursulin-net.20230601.gappssmtp.com header.b="BjJ4DkI0"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45b7d497abaso33599835e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 02 Sep 2025 02:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ursulin-net.20230601.gappssmtp.com; s=20230601; t=1756804931; x=1757409731; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Be300C9M54HN2j6qqn3KzILYOn0Dm/rUn/s4aJntRQ=;
        b=BjJ4DkI0nOIeBWi829gHdcdGEnRHe1ZnQO1njdb+Jyp0kjPhbqnc/pH3IqlbX/mPRt
         KImIiC5IOBhDUsCOe+bsijMfqcLKa+dXYa461vlf8W43jDTp2NN/HyQttUmEPfTyMDsa
         +znjOYbf7zmMPfsw7iujVXgeGLUXtwGXlQ+SY2EucQk11hSB12zyiFkHuuLs1Vp+GMQK
         znrByajiS5QwRXsCGGX/uEAkboujg3cDsCxXhSDvaaKtpi9xTJYSIPVmQMJW+nANv+26
         x3bpMDTCAYkVqg6BQ0C/DVGa/O/iwl4l6QGYI8jJHyq5e0aZ7lgtishdDOyJn3yv5f02
         d/Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756804931; x=1757409731;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Be300C9M54HN2j6qqn3KzILYOn0Dm/rUn/s4aJntRQ=;
        b=QOA9jCnMR5VAx4UDLqaJHCn1XZlCJvdHQx27TrSV/GkIgAc9Gt6XQhfC3y2d2oj5Wc
         2+CLvt8PKFaOz3ICaib6Gr3CU62l0NAyHmG3n7MJe6U2je0v75VT3EA3a6I4KBsNrnsr
         X4b4DUOxVPDigqlqBv/KA6RAJN2cFyRUVOc/L2OBY1qAAo5CcgaQQToKrzjPXemKD/S1
         XNVDorT/Vu2vD1ATxr2EWDegvKDzmWo5piEFS/ac0hbS0F8WagPzgecesUScUAKJr/bc
         Fs+VTtAyiU/DYDwRIIergrtL0eqxCHm1jpFP47i9i/SAI3ov/FMUf8dDx2E62qCLmaoF
         ET6w==
X-Forwarded-Encrypted: i=1; AJvYcCVZP7J8yQ770zVKlmqByvaySz1KU9d1pvBToBJq0+LniSht+gLU4pvCwBFoqFeG9MqbFgzrvX8b2XU4t0k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuIawT7p8ddNivUzpg/2h++wL6T6Fm2/yN7RrgOxIrjEdcwGkM
	EKZvwE8tYcqHEHKD4UGtalypUOc/iz/Y/cRXJWLAIbvllMsGLVBxFcQKGOuGjhNJzAI=
X-Gm-Gg: ASbGncvG7AQ/08GElmmHdTOwlIknl4a7Wxt2zTlDG7dXphrP0PgTDOVwko2KgJrnjeL
	dacwZ9Cl0hIaQwPW7smZG8YB36ylih2AD0y95cKKEWLZRqq9YmcZ+fdszenFDidKQv0UhtSzEX8
	VI+scculylodewPiuYSV/lsytfi+qw2QZCAtwrlosmeOJevLv2WOCi1j1rPOl/ofa8W8klmpC/q
	x/bKLRA8s1n/U+Dw8Ceqp+3p4N4+JOqvQJby6CqeUes2XKcLxsmhl/HTWPAO2Ejo+KevQK1724k
	gZaO0qZAOr7FypR5DZr/7zG+cKOlIWt2zkm7GpRR1FKebJVH8buRd8rE/KAEoP1X6NCyE1ZcDr9
	x2Lm3utNgtUtk1H6BQ2eLOoz8DmUGHk96YQ0=
X-Google-Smtp-Source: AGHT+IFjGWdM7r4OC2xPYq10JBW42QzIVS9ISDbv655toZnOdc57tKWSkMByc2ni755H7QY3mBnVYA==
X-Received: by 2002:a05:600c:a04:b0:45b:7d24:beac with SMTP id 5b1f17b1804b1-45b8553335amr94619035e9.10.1756804930815;
        Tue, 02 Sep 2025 02:22:10 -0700 (PDT)
Received: from [192.168.0.101] ([84.66.36.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d0b9402299sm17994846f8f.18.2025.09.02.02.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 02:22:10 -0700 (PDT)
Message-ID: <4bbf5590-7591-4dfc-a23e-0bda6cb31a80@ursulin.net>
Date: Tue, 2 Sep 2025 10:22:09 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/37] drm/i915/gem: drop nth_page() usage within SG
 entry
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-27-david@redhat.com>
Content-Language: en-GB
From: Tvrtko Ursulin <tursulin@ursulin.net>
In-Reply-To: <20250901150359.867252-27-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 01/09/2025 16:03, David Hildenbrand wrote:
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Tvrtko Ursulin <tursulin@ursulin.net>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   drivers/gpu/drm/i915/gem/i915_gem_pages.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> index c16a57160b262..031d7acc16142 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> @@ -779,7 +779,7 @@ __i915_gem_object_get_page(struct drm_i915_gem_object *obj, pgoff_t n)
>   	GEM_BUG_ON(!i915_gem_object_has_struct_page(obj));
>   
>   	sg = i915_gem_object_get_sg(obj, n, &offset);
> -	return nth_page(sg_page(sg), offset);
> +	return sg_page(sg) + offset;
>   }
>   
>   /* Like i915_gem_object_get_page(), but mark the returned page dirty */

LGTM. If you want an ack to merge via a tree other than i915 you have 
it. I suspect it might be easier to coordinate like that.

Regards,

Tvrtko

