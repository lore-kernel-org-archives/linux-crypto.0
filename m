Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291038;
	b=Rda4n5ghfUJsvBHZ0/CAWTODZvq0znnilx06NircbsbmUtWhH3GXHRTZwASR9B0+jlSa
	 sYiG6SSOHS71T4Vjo9zISBzZQkpVx+75WJXEhDgQCuO8/LcmQPVJr5K0F8b6/ujqfUe81
	 DCChsvq65a+6nhcadXR8rdaDdOeInGnPlfbixvDOZwr65bbCHYEihd/iYYevMfPbyJ3gW
	 pywmrmkoV3PypQe1vBL074m3NnjQPOGPnArSnSjY2c3X48SAHyZ6k+r8bswkr0kjOTHMi
	 GmmhsWuQoIgE+ifotLxVRsBeuPtL1NcfyNHZ6u15V3FA90L3MXeJz+HhREQeQzQJrWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291038;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=p7BExmyMwiDR5UEEieV2XRoxDfKEo1NhnCavqA/tY9Y=;
	b=CyJVoIyK7i5EN36QK0y9n7sglhJQGVBSvx0+/oykoq46DW3MDOA8vRx05N+P1EemOLmA
	 NNJqwJ9kX0XucKSV1U7yb0uXNiOf5ePmfftxyPB48+PR+2f/R8LFO89u8idutXAJZur1V
	 2CfZUCqU8MaUFpFu+i7GADNKF06ZH9rRBgoJMO/of5A9ud8wlbF5c9YAUoDLBBIil0+Vp
	 viQ4epE3akQHrAvxHzPj167ofwyA/0AR2wC+6jNDpsyPFgWr5t4bQ9sUJrwLLRHFfRgIH
	 EkkfqzNorywRZuixrDQZ1+O37J7ziuMCcafts69D8f83N6iGWHEfI79OydXSJ5Eq42g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=I5v0dbac;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B603F606A329
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 16:23:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B603F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=I5v0dbac
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a5036bbac7so15240545e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 09:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793291036; x=1793895836; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p7BExmyMwiDR5UEEieV2XRoxDfKEo1NhnCavqA/tY9Y=;
        b=I5v0dbacQ4WP0S/nvP67diDEkx+Vv6y4Vjt08cxXyOXPUgCwobUt63/XJTKiQCkeWk
         tNluPM75qr/BN9xemD4XGZO2jsPx1WVjuYnfdUtrK3NsxN8PPZI5MpFNWjEKcF8n3shg
         0pVhoqq1m3uk/bsX5bpmUoeBd/ey5Ixjnxvb1K/MpUjTM5LLGhw96k9A0d8zjCcRqBrQ
         oAznT5mDL+wan+lDbK+hPt0BeO7CVqKDr7yFPUdCzozcckXOqKegEPLmSNI2PQ8bbiWk
         dMMUiyPg2vwginbUlo2u08eK+9QNSL7/hACAdzJibVqS/AbeQYPUktcNujs5tzy6Nf6q
         8KPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793291036; x=1793895836;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p7BExmyMwiDR5UEEieV2XRoxDfKEo1NhnCavqA/tY9Y=;
        b=pUHmZGISfHsG6lRVS13D+hfQrcxGHXaJHW7qMcfVZ2C5yPDi9JqqC2WCHockCVE8Oq
         evtesR2ciOp/ieRqbCFUa0Thk01u1ooebHI83a3Cnw2s1av9+O5V4k9QahKUjQ/rULvc
         jEPCA63qYeNULm90AY11sfQLK2badOwu5SvuW2QAV7BdeAw4rXgHEKFeZ0rWjfqyKYYx
         jPW+/GhlC+FbQ23WzAPt1TGHseyIYNxzD8c7S7yo+WvbtemqhjMybxwV0j+L6MsoC4Px
         iG2QokV1yO5ZsE0GFE/TD6OknF1oNSrWMgjrmGwlmhxKz1+IPlNCBHKsYUGIoDeqPyRp
         PbKQ==
X-Forwarded-Encrypted: i=1; AKwUvBzT7QM5QEImqBHCrAusRyh7gvw16DLMgu3wT/4YL4DoNiRXOPbqHkv4yQ1rnh0ljp3hxkrv0etpj+zpW/E=@vger.kernel.org
X-Gm-Message-State: AFq9FYK35YkH0Wc3o/nSVphS0KihKWwtJWoAfgEuvQcqgdCZosMlGGNY
	DyiFgMFPkNRPVcBPlQ6BuXAsllVBreq+xTXV1b37WuIGiO3zgPYmJ6vlRVv1cvTUz5M=
X-Gm-Gg: AYBFou32iEe6coQg9HH1Ex18m7B5w9QL28e5eh5d0ckC5Sy/f1C9uu066lGYdZauLNf
	RQvjOIdT0xDUwWV8TT66D9PTRwuH0Z55Fu535vBDY0CjWtO7Po6o+Gkj4ZnvvUgCXlbj/y95JVZ
	HQbcSGpSZARhsn9A5J1N4QNMNy6ZUKnUZQyCYFsy9j42DET6rWyrXFyvxmNbCztUAhiMOVigKBw
	pESrknYVotRClCfeDpYRgSR6f6dMoDHiZcCMR3xSWPlLX7XY09wQfYFrVYRW6jfsJjE4Unuvzcy
	sQCjrx5eK6lqwFKHb4uy6CrJZKNQ7JZBy8r7TLBSMXYLPzWOm//xBhB9eHXVwMOQeISVaZCs6QD
	BMwodQHgG6SQ0k416l3OzQ7fzRpnfeQypo6O1PMZAtiByZ6nqV1v4YxlWL7Fq0qrxCPJ+yI4hr/
	hQTWDkolUBCEucLqZskg/p9Tp+0bkTpZo8FYxbrTLsk7WYVEhYeonSGqViNg9prld5IoOxGCUO8
	5RW4aX6Agmak0IK29MCZbEhCc/BckPoEGDNHDqnmz3H2L0Zn9ScybKJxp8Y/lNDSzZa2uVE5Ojh
	cOzqe1NL+yLJkArf0+h7Y+9XqMv+FODfzHn3VQLBjmU=
X-Received: by 2002:a05:600c:34d3:b0:4a1:e0db:8cf8 with SMTP id 5b1f17b1804b1-4a9643d37f7mr138287835e9.3.1793291036011;
        Thu, 29 Oct 2026 09:23:56 -0700 (PDT)
Received: from localhost (109-81-92-234.rct.o2.cz. [109.81.92.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7ee575e2sm75886455e9.1.2026.10.29.09.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 09:23:55 -0700 (PDT)
Date: Thu, 29 Oct 2026 17:23:54 +0100
From: Michal Hocko <mhocko@suse.com>
To: "Liam R. Howlett (Google)" <liam@infradead.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auNzGgj3OqLTG0Cl@tiehlicka>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
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
In-Reply-To: <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>

On Thu 29-10-26 10:53:56, Liam R. Howlett (Google) wrote:
> 
> Sorry for missing the ML in my initial email, I missed it from
> get_maintainers.  I should have really clued in with such a small cc
> list ;)
> 
> On 26/10/29 11:08AM, Uladzislau Rezki wrote:
> > On Thu, Oct 29, 2026 at 10:16:36AM +0800, Herbert Xu wrote:
> > > On Wed, Oct 28, 2026 at 11:42:18AM -0400, Liam R. Howlett (Google) wrote:
> > > >
> > > > Below, one CPU adds an FDB entry for an RTM_NEWNEIGH netlink request,
> > > > while another CPU is inside vmalloc() or vfree():
> > > > 
> > > >     RTM_NEWNEIGH                      vmalloc() or vfree()
> > > >     ============                      ====================
> > > >     spin_lock_bh(&br->hash_lock)
> > > >                                       spin_lock(&vn->busy.lock)
> > > >     rhashtable_insert_rehash()
> > > >       kvmalloc(GFP_ATOMIC)
> > > >         vmalloc()
> > > >           spin_lock(&vn->busy.lock)
> > > >             waits for the other CPU
> > > >                                       softirq: a frame for the bridge
> > > >                                         spin_lock(&br->hash_lock)
> > > >                                           waits for RTM_NEWNEIGH
> > > 
> > > I think this is a fundamental bug in the kvmalloc non-blocking
> > > support patch.  How can it be used at all if it is susceptible
> > > to such dead-locks?
> > > 
> > > And if you can't use it safely why don't we just get rid of the
> > > broken kvmalloc non-block path and have it always go to kmalloc
> > > like it did before?
> > >  
> > If we have a look at this as we did not have vmalloc() here:
> > 
> > 
> >      RTM_NEWNEIGH                      foo() or ...
> >      ============                      ====================
> >      lock_bh(&br->hash_lock)
> >                                        foo()
> >                                         lock(B)
> >      rhashtable_insert_rehash()
> >          foo()
> >            lock(B)
> >              waits for the other CPU
> >                                        softirq: a frame for the bridge
> >                                          lock(&br->hash_lock)
> >                                            waits for RTM_NEWNEIGH
> > 
> > Same issue?
> 
> Looks like it to me.
> 
> > 
> > I have a question:
> > 
> > GFP_ATOMIC/GFP_NOWAIT guarantee they do not sleep. Do they guarantee
> > not hitting ABBA dead-locks or they are not interrupted?
> 
> GFP_ATOMIC and GFP_NOWAIT can be interrupted.  It's more about not
> waiting for reclaim (kswapd might still run) and GFP_ATOMIC might dip
> into reserves.
> 
> The issue is that kvmalloc() now falls back to vmalloc() for
> non-blocking flags (I am restating this to make sure I'm not missing
> something here, please correct me).

Isn't the real problem that vmalloc should use irqsave version of the
spinlock to preserve the locking constrains of the caller?
-- 
Michal Hocko
SUSE Labs
