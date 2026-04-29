Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A20D3B8D4F
	for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 08:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777453133; cv=none; b=R/UhZ0qw7xkMi5wtQ4crda/aHllVBwcLvx/8kXPDm8obsQJvdR2c1krn/qP/Ci3XNmKvhMXDLEaAMwGYTJXKYVWY8Y2iZrdH+sYDhI85e4GWxinv37teNvNsfrD5eeNHZAarfr12TTezIpeBVE63vCXjTF5qQlNWPM4XyIDqvlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777453133; c=relaxed/simple;
	bh=7ABbcjeqAhsd70OTFn1PMgAbY9j8jyhWPiQE6YrlePM=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JXwPE0OrN7v66lb0dnFDcDPZ4ZjweDKZewmSCd40ecUfz6Vj0ixqF5JVjrHaM09axClWnyDGDtqvLAJszdZufODM/madkszCv3232vX6uZ3GQnBEUJAYIPGkP3Yg5A1qejZcBjE3Vax9e7SnIH7Udm+/TGofJnzgDCfo6JmuSrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SGvAZIsT; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SGvAZIsT"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a746f9c092so736608e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 01:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777453128; x=1778057928; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qmmdCKtqVQ0OVoV5psS5B4BuI5zsGui9KVJ4RSpn3To=;
        b=SGvAZIsTnNMcx6VW8SL/VC0gNKxsmurC8D81brsZzsFuhbUvbdC/KL2Jw7F91MST5m
         UQaC+2Fij0vuDvO1NrfbG1owQX8a3VP3VVUwyQVslEYJqzR3YOBHqlASgsuorWw7MYAg
         J8GdKFbDAre57JMBXdxiKOApH9Lle1V2a3gRFIhb41LQckceOyq3rmfxOam4y0U7qiAR
         Lkqb8Ei9V2rM9DMETTc0jHRTEiuTPpGMjPWVKFkR7CiR76wQQSWKRKpml7KkozvvwlQd
         cKdD4Y579azKtUfQewYmPL4L7robs5v3AfkwWBPs7oiYyhMA+tJy1Zaav0yNUhy7Izxy
         2w4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777453128; x=1778057928;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qmmdCKtqVQ0OVoV5psS5B4BuI5zsGui9KVJ4RSpn3To=;
        b=RSSNINLugl2dkV2hjeOs2JPq1KT/IbFwDq+gTLLzgEdx4io1O680Icb7l6GKs0AQqU
         VgokRgD9F2tpwcUxDtcMQMKUKQTFf9Gem7pgl4U/oN78NSKJmTKFfhqaYlnTGiKvXXTW
         nKulS+/z7+gpVroS5xdJbd4u4RkgUhfO+Ayl6AG7f7XJvNVAPMtUjvu35Iju2Q4NKC73
         EbPsHRrHIzzhDjp5qjiiMPTFo1xqFXZJ8BSGQcZKBXrbPP9ePA2fPOZym7rfhiDxaFkb
         M8IX3yOeNBqK0TUiw2dTYxwAjCeFIumAn63ze4SK3xifJccqgNMAbmhw9JUCslUAF1wb
         g1Uw==
X-Forwarded-Encrypted: i=1; AFNElJ9g1Q7ZnLpoRi/jT74UnYXlXib1wlbzSOGnBWoMIm6bluhMZ8/UeQ0y1fm0MqS1KCO0gg/NSirZijwN5vY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFrZ+17HUAZahiQuZg2zF/q1BrT8KfvdRjSiq+03fIkp4ydBPE
	DqylC4uGCF7r5ZtbKbGbc7/DdkMJbqrAikpx7SE1Ok34Fc/6/CHMZQ1U
X-Gm-Gg: AeBDievdoYA3ZuOqAG8Dl8Id6ZhtpdryUb2OcnzCgNPNfYXxW6UCx4JfvxXOzWd6Ykl
	1UUsT/oQKcVurasApEnRdcfqU8VMjUjbN0WQWpfMT9DMrVnMSPdvDP0Y+FdBkMA5QnI3sNh5Fv9
	cySFl20DsAhAH1bDvZFJErCKn4PmgbPOv3XP+0wMsE9uWe1XVr1zzgYSZkDYyPlG/bx/u5m6FJM
	NU7muFdnoBZxqMAwHCE/B9g0rWB9KlpKlsTyd2sv2uHCtklQ/6SiDNFxYuxm/JzHR1IElCq6rz2
	FZO/6kAVx8yuIGmDB1iFXe75zYQPmyKGQOlAiTaq7Rh9Kr3qO1gkXWI4GEZlv0bBFRw/MHz4+Kl
	JNxn69NHZI+JSRww6WDzFQcfGlD5fsAxBqcLZt76mW3Wr0hPn1b+j3NS/CXdCfxn7r1PVnPjc5p
	E=
X-Received: by 2002:a05:6512:3d1d:b0:5a4:4f9:be5 with SMTP id 2adb3069b0e04-5a74a337c02mr885659e87.5.1777453128244;
        Wed, 29 Apr 2026 01:58:48 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a74a6f355fsm377139e87.24.2026.04.29.01.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 01:58:47 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 29 Apr 2026 10:58:46 +0200
To: Vlastimil Babka <vbabka@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>
Subject: Re: [PATCH 1/2] mm/slab: Add kvfree_atomic() helper
Message-ID: <afHIRrqj20hCMily@milan>
References: <20260428161419.94695-1-urezki@gmail.com>
 <2d996917-60bb-4ef9-b397-65decf3b296d@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d996917-60bb-4ef9-b397-65decf3b296d@suse.com>

On Wed, Apr 29, 2026 at 10:28:02AM +0200, Vlastimil Babka wrote:
> +Cc SLAB maintainers. Please use get_maintainers.pl next time.
> 
> On 4/28/26 18:14, Uladzislau Rezki (Sony) wrote:
> > kvmalloc() now supports non-sleeping GFP flags, including
> > the vmalloc fallback path. This means it may return vmalloc
> > memory even for GFP_ATOMIC and GFP_NOWAIT allocations.
> > 
> > Freeing such memory with kvfree() may then end up calling
> > vfree(), which is not safe for non-sleeping contexts.
> > 
> > Introduce kvfree_atomic() helper for such cases. It mirrors
> > kvfree(), but uses vfree_atomic() for vmalloced memory.
> > 
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
Thank you and thank you for adding SLAB maintainers!

--
Uladzislau Rezki
