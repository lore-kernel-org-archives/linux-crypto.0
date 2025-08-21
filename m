Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2FE341AA5
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755808607; cv=none; b=IqDx/mqjWSBiX+i7lLZwzY96/i4RmAD+qodwJhst7MjekVwepjaZxpfPyEqFSbJwBR2kzBDpsAY0BjEqEZKGFcJeu2rK0O3b8H+LEAMOkHV3T/p2/9cnitQIyNYWXnAe8zRt2DbT+vr9PoI/5t78zQCTf+4EHukIwQPkJphIH34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755808607; c=relaxed/simple;
	bh=yojduCRvPCmYgwaX7kfWJ1p+To4BJmiAMcPa2zQubFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ikd6xi6q1o/lWDRmCAmhfbgOoBhU1WRj8xfKBpzdtViDaY20CI/3AK+iBkCCSZl8vZ/6cDhEonfacAV3RKB+GzzyA28WkBO36gGld2SqKxJJhOWS2RwCLxinIEOvLnm21r8x33YLrrsuvqDWqTaqdG0x16QgXd9UIjYzm8xLoxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FV234+mU; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FV234+mU"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e9505d08ca2so1188362276.3
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1755808604; x=1756413404; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=083PuN2wICwWm8iwB5WBlP6qyKXLyqdZEBdZ0ztp8l8=;
        b=FV234+mU7pRMURRjma/HCXOh7oRBz2o8mZ4HY80Nw18ph+1Eb98oLCMJUBmPlL/wYk
         wbYnIjf40zeiyigCAOvdnmVZW/bVhKI/R6VE8hLE1yX0t518kJFFvAM8OXr9IG/1iZiY
         bM5bWY1XzkQ4ggk041+jvfFIOSBug5NgOCliY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755808604; x=1756413404;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=083PuN2wICwWm8iwB5WBlP6qyKXLyqdZEBdZ0ztp8l8=;
        b=P3Tqo1t+Cyll/yCwJ8ihjHXYQ/hY8Qge95Qqd6U9AkoIoDkcu93a2gXczr+6KZt6rN
         Lm0KR2xfEPdRKg+P7Dcbv9VBF09YSEqHQDiBjmZuPk6MKo8HYG7bP9A0plgnCfJ9j1KT
         QDcCvITq5Ln1GeCwRxChHGkr3zYrpbXVBbWLsmtVg79MltYVU2SzjturyTpnslwinPol
         CjHjlL+a1T0FDrr0hMNsiPOTkZfWjaMkfcsn900LB4HTz1zG7lD4jg1/qXjjzmpCoVmP
         oEs5koF3xcFHREztV1I5CbeoXGoCbbWIWwwr1Kc79C8yt5rY1sIunzkCn8dB+t3otOl5
         eLhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLZ2fkMSb2FqupcqqXxDDkGx24N5U02lxxSg36vOVnnH0MY0cJESEfVH+6XSxG7jDOsprXP4iv1rzSEa8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAVn4kSl9BZo8K7gPpfX1NQSlLnnigCA1wIjqZWDBToQ9Sq8k3
	qTWLh8/Liy2ROoAGD/VP4OE+TyyVe+IJsTcwmItXrRFJdDf0Tk26i2TStEk0YRnrgq2Hg3F2MQ0
	FDWE1CWh3RIofjMCOM3JgwkvlrKSgks93OpMFXuzSBQ==
X-Gm-Gg: ASbGncte/jAs6ydGwfFeomTXwR6OBGJ39AWZ+rbhFlACSVeq5Ij22xgj33bjT8QHnUc
	sBMz1+oLwG4ZgRzLms7QrlEveuqUvZlafyzkivYTI62/I5oWs1XZPQ+5XlhTO4GE4QsVqIfqGbs
	ZYe3FJZghFpiIKPlBy6XT+aPKYXMW7mPL75mi7EilqXak17Wm8rb9U8ZANTa6XhptG2+WIeDXPp
	dNZYgxaSCYvzpVYPVF/0zp6htc=
X-Google-Smtp-Source: AGHT+IHnF0lVhm+1Tun1UWlMLnnSk/jF/jUOt69DP22IOjEUNxjHdHqCJTIRGjm6XM6hiUq/Axp7jnIGuYc/D1Y8ZZI=
X-Received: by 2002:a05:6902:4381:b0:e94:dea:b80b with SMTP id
 3f1490d57ef6-e951c365621mr715984276.40.1755808604080; Thu, 21 Aug 2025
 13:36:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-32-david@redhat.com>
 <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com> <2926d7d9-b44e-40c0-b05d-8c42e99c511d@redhat.com>
In-Reply-To: <2926d7d9-b44e-40c0-b05d-8c42e99c511d@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Aug 2025 16:36:32 -0400
X-Gm-Features: Ac12FXz8i_O0Dca-zCdGNOyRYVeCyfB9Z0ucQ3KoLazk0PNM2PIB2a_qe1sXKks
Message-ID: <CAADWXX81Y3ny6WvDN8EeYvBPa2qy10PKhWfZpj=VBcqczL6npg@mail.gmail.com>
Subject: Re: [PATCH RFC 31/35] crypto: remove nth_page() usage within SG entry
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-arm-kernel@axis.com, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, 
	x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

Oh, an your reply was an invalid email and ended up in my spam-box:

  From: David Hildenbrand <david@redhat.com>

but you apparently didn't use the redhat mail system, so the DKIM signing fails

       dmarc=fail (p=QUARANTINE sp=QUARANTINE dis=QUARANTINE)
header.from=redhat.com

and it gets marked as spam.

I think you may have gone through smtp.kernel.org, but then you need
to use your kernel.org email address to get the DKIM right.

          Linus
