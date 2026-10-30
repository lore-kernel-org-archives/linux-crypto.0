Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793353963;
	b=jQ5uDan+pYVRWoSWX2U/qYpY0mBUtaUdGjxJxtC/ccVVX4EBNZzXL091pJy9PX1aSnlI
	 EOGiTKaSnqdhdkIuGndmZcRK5+3MFW1KUl6nQpIL7LNeS4TmZPblExpLqHk/CFqAosIDn
	 7k76243MqxAnfncPuXbOEG4v6hqgWWeDJNULHQp31UP5X7a5grwdo/xUkqfnlM/48yT5a
	 wjRnysFhrzSGHS1Dz9PZ8dRoDWrF8Jpcd5cB5D1V2FU8L5Kvxiqk8PerKc9ZrHGVD3ftd
	 RqppnIDcRGl5m5dsLQLTDuNEinpf1p8OvJYrbePvq/4W2p25EqfRg+srs1W6+rdmVng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793353963;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Date:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2B3bjvz5/cRFhwo9ukB7ZLLCsSJwpiNTa01piLcwoAs=;
	b=i48+o3YcxRJpiCq8kZqMiMks7Vb/CynmkgVyfjUCNZQOkyAXcYUtPCVi/DAuk9y0RI9y
	 0VseF5wIRMZJn97DKu3pAXm80hS0YZWZchUzj5wV5sYPLI2I+j/mwOYGnGv3uBARi77VU
	 mF4Ee6dDSK1oaZjUjIqt/SqPhh2BVMHJuHIyFN4MrbiFYnyx0Y9mTtTHm3m+pkmPrvrt/
	 JqTQciCW50wifpU2UKC4ry0A4puJpzsdEU+z4ZGD6kiGpDVVO1NQhcaAhz67yfBVhIfwc
	 Q6KpZy31h3C1k1DP2lKHkMMntXe6vO38aNzdp2zyq2stKN6YSARp9IGqDT+I0TFnkHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bsuXLYgo;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C876C606A31D
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 09:52:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C876C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bsuXLYgo
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b1aa2848d2so686357a12.3
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 02:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793353961; x=1793958761; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2B3bjvz5/cRFhwo9ukB7ZLLCsSJwpiNTa01piLcwoAs=;
        b=bsuXLYgolet9UtrpUXTjhF0NtZvh4wUfphWhBPdTzAHZ+voK+TzvSJt4jqtpIr4hDY
         BC576Tfm8MvgNixvYZj6Dqi4K3sFXUSX/7ZAfmkSmMMCDN7GxC4LIVVNW4r0Hl+mplFs
         W2by6S5cSgPj0g0wmpKfwfNf/zqgAEOXhiapRngSS2+Fa9wKQHztRhPeqLJ2d8kb2IO7
         Pq0H2NawTdGX7CmkA2qi3LE66II3XNjS223Mo2JwjVI062D0QJpvSdz+nUrtA+uP1o+G
         Q76CkUSavVprulwf+DpSyGG/1MWy2CHk3nt+Xc9tqJwtIHmBIFhTi8Seu1+BLrOUwvFD
         2wXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793353961; x=1793958761;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2B3bjvz5/cRFhwo9ukB7ZLLCsSJwpiNTa01piLcwoAs=;
        b=qrud2kHYNjY+Q/8WXfjgf/Hom92vZYAtxVjDH+ofIWo0dTLr6aO+zvFbL0EKGH6VC2
         2YOtn5nJX/Q/ZTn4owS01WrAn3DEzeb7oF0eZpik6XnJmo/S8fLTKJWbxEQGxq6oLr47
         0TQRb0zxbK5VDOnGwwJHHjrL9PVNUro4SYJp0hQlZw9DZJ2Wb/0PPCj+1Y6bMb23kSj5
         d7d4Ztaivll2kE8yYw0oylnflNLaRjQGEtl2gy92JVH1UPe45W/ktzYoUFR9FGWSuE+/
         GnsUDS3k2oeqsU4SIPpUTbpZQbszq+WQUDwJNw8BTpbaE5oHx/GPsvaKCx1ihs6ejuQf
         Jf6A==
X-Forwarded-Encrypted: i=1; AKwUvBw0S81OnFgZaJ+FEO2EkSXBw6r7btgT/cqQ8wr7dhATxbyDuQejnwPRfHTomLAAIlkNF8A5YGRbcNsYrsw=@vger.kernel.org
X-Gm-Message-State: AFq9FYJUZSKJ4HbF8Hv4FKw9JwnDGBdjXqodQvSE56SvWD2EMorHj345
	XR8UivnaHOYNoCLlM8pj/JcJGgp5HcNVKtwQUja0IPgBKNSwpG/fIlVe
X-Gm-Gg: AYBFou07EQdE4X+FDuJu+WsqGssx76ZQJJlw4CPxPPqtdofF6WFbcFlIBs+e1EjHvs1
	nZQ0p4O53aoP4NtX8WEZ3ZneFjmict5TBp0JFaRbztGmbyVHV2bNevqZ9ZpyChNO9ZADSRXedMa
	+yOkDqjnWQHB3gAtcDssYuwrnLKzYPoB67SMlgTVj4T09Z8p8CazzkonnVnVUiBZr1b0e1rn7A+
	H9gIUspLbPURsUZBi096IwjP3UjGSjYvwnaA4UUamxgmvj/XW+RToTeTwpRZ5zAWAi4C29RGtYs
	/ZpdCHjFKAd8ogH/EMmGQzvM6FMou0Jm0IzjkohKynfOUiefUeNOELJDPevPjN1CV5Z3NJQNaCj
	cGRf7slyApDQBTG9WRbZgsB/iauCUUNG1+pThpB9TgVF3O/eR+uI9flghwZ8Yg55wydo7fO41ro
	uRTyOg8eJnBDCpnyLchG6i3rKjHlaAQ3rvg2V0FsH9oUDCnM7XeakbI90E5ZYOcIljQ3zPnKXBM
	Myf1TlbLWBKCvfZOyk+loxTORPGauSx14gO2ZR6o1Gte+pCvLKpUPqeOKouFRwTj2UlLQ==
X-Received: by 2002:a17:907:d26:b0:c2d:c800:d797 with SMTP id a640c23a62f3a-c4ca79478f8mr163699766b.6.1793353960890;
        Fri, 30 Oct 2026 02:52:40 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4d7b1d556sm432290a12.28.2026.10.30.02.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 02:52:40 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 30 Oct 2026 10:52:37 +0100
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>
Cc: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auRo5WBj2OlKlWGW@pc636>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <auQhkHG6XlgNTdRr@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auQhkHG6XlgNTdRr@gondor.apana.org.au>

> On Thu, Oct 29, 2026 at 10:53:56AM -0400, Liam R. Howlett (Google) wrote:
> >
> > Given where we are in the release, this fixes a real issue that can
> > happen so maybe we take this now and settle the general handling later?
> 
> There is no rush at all since the bug that you found has existed
> since 2025:
> 
> commit c6307674ed82c0c57d6e1e3408e84ac449ab8e94
> Author: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Date:   Tue Oct 7 14:20:35 2025 +0200
> 
>     mm: kvmalloc: add non-blocking support for vmalloc
> 
> Let's take the time to fix this properly.
> 
The problem with spin_lock_irqsave() is that vmalloc() path can take
time to alloc and map pages. I am not sure this is worth to switch to
irq-save locking primitive. So this is the "heaviest" allocator in the
kernel. Callers have to be careful how the call vmalloc().

IMO, this caller has to be fixed.

--
Uladzislau Rezki
