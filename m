Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793618296;
	b=PLbuCfGq3cXeeTHvzDWlM+2dnfNoT9Eb2gwjsCZ/9whg7BQubeOTSjUGj4IaBITEbwOD
	 165IjsSuntiftsmlhGTFTddDDsLiZAh4BwGuP4Keb6SKBteYWtzccXpdNMVK5sjG+BlH5
	 GJ0k308rxXXL6yRJwYl9isjjiJKfatAhM0zocp2JZ1ohjjbeRW9BaamIL1Iq/1F2o2AS3
	 cahQv7s5BgWpxKQl0bFOtAvigr2obIAsw35MCo8lM+1inbpy3wkIndyn0imi3XucVmD55
	 vDf8tCeZCrFmesZmcIM7RCOXTcg3W8wxWvPxt9SUMtiWikPztmdXDTi+xATNGUPNlTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793618296;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Date:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1yynEp54ZHg/bAl3tECuL99Dgvavr9fresZi3o0Y1io=;
	b=B6mIXYglk13ngimBPnwcf81V7vtJ+RMS5XqMH68VXjsrcrLk9Z3EPD6ExMCPwKDop62y
	 iRrv5NPdJIySP5nctEzeXZ0sDME9ma5f1EjsuuRDKwYTPsGcDFDSK9XTBEREva/tkOaIz
	 CC54jjN2j8vVzdaIKDB/mu/hXqKZyRoM4KlIGGU786Ce/83bdVcom2V6sX83BWTYnxgS6
	 lpG8Nh9+6UGhGuFFBDBHEe90oN574ao5A+tKCKezCx7EaHhwz6S/T81NqVtj/3G7yZrbH
	 fp5iX1TWOq5gIBrLm01lI0kTrIcPU25RLnPo00j66PUduq0uTlJdoCALszIJFZk/h/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HLXOpm8E;
	arc=none smtp.remote-ip=209.85.167.51
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9630960A262C
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 11:18:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9630960A262C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HLXOpm8E
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5ba3ec92031so3843365e87.2
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 03:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793618294; x=1794223094; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1yynEp54ZHg/bAl3tECuL99Dgvavr9fresZi3o0Y1io=;
        b=HLXOpm8ENVpkY58LUtPdSmKtWAjb0kBQBWUI9OSY32i0qu+IF4ZGEGl8hOjOUqBPwJ
         qucTFrRAybe/WdWOvtPbOiR3zr+8hSiRo0D2S5QK8cF5RWRjPBVF4R6T74uwLPlEsVVM
         M3R0rOY5sP5zynRjiyNvFXxxqVyQAX8KbW2aEA4Kj6gSaWYc3cwmgu+Ve63x6rVk8Bx0
         fzeSkGIMJDt7Nd06VPOygUrVFuxvgrwQ3y/iplClvGv4nNyisUI58oXnw8xPB4oEP5iL
         oo+WmRiIVTNz7nx4soa4rvaeUAeBf+nZ1MxJEyN2xjM1jKuXKT7Su6H2jP65P+FaAfQM
         xkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793618294; x=1794223094;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1yynEp54ZHg/bAl3tECuL99Dgvavr9fresZi3o0Y1io=;
        b=XwN+azw0MnCz9YbHp20bTAGHdW8fjC0XtlnfICzMXuxVYcgBzL4Zer4WAHVbyy1Qky
         hRm4hMk1Uj8GzwfNFUhRwrzMmOkHd3SM53Z9HMwUAtcW5Z7PwQ6eb6Zck35Zku9UUU5O
         bUF+ANYLBmclJb8YCIcsd5DGcPR18wJxNH0xQwhRRmcW4yL9OBXLQiEsW8KZ2TIKPyYp
         jMi6QU8jF3s3mQ1uVTeLwQovVFRc/i9TYU6iP5D5dWIOlv79YPOfUhB27luyLIhLk2h2
         e6yETwkKDjncL/Xy47jRfQ7R5H39s5BSzTCVdwrVwwoUSL67mnsboajxzzLu0MjyNXI+
         9EbQ==
X-Forwarded-Encrypted: i=1; AKwUvBxP2XtoMijlpB8MQ4NAXHuHX7/6pi41yUDkhfNJl9GlljWbPGkhB4B3Q7uqGRZoBC0x/rbyntYYxCQf+xU=@vger.kernel.org
X-Gm-Message-State: APuU4Z/ipT38uFAdIZP8ifgtGn0AIiDzdjGDBxRrdIoTSz3STexuIPR9
	0DTUrzd/Tpjhe+rf7hsNZKQyX/dOenuWo74XURc/QPdTdL6rvl5F8S32
X-Gm-Gg: AYBFou2B0x78m7L7RTs5gJoeTcgvg8GiGC2ZL1Gcsn0HSZJYLv0sZtiBr8jW/dM/AxW
	xd7LKPK5YHcO/umpNGDuF2fK47xZifhBcZUeHZtz4Ha95cAapJUJppe1TNpsdfQ2XYqa0sxHl3L
	Cfcmw029P98opUi38Qbz2KyFrTvTlCosIvOQgfK6e2cOSPsCduCdc6pEPSdZ6GKXxxJG6eZewNZ
	WeDbN1R5b9wnGZGVyAPK+xmDj2fH7RDxKc4bGcTv3g16jIOLUIDpuwGPGVJMqnt9u+8YubeRL8K
	oidu1jiJIjZ/I1GZ3wWCCiCil6cTPeXB6hpCdfJrCO45ZQOVBwqy5QRvgu2QiidEUoLxhglQkup
	GIWmy98FqnCko2xK0hBYZ9IBvI5WXpaWyO6dEGqJU7hzaxP8vCj9O3/fW2RB/RTw+E8NZwBzeuK
	28HosqG/eeROopY+tfnojrATuEfpFXFkoK09j/H49UKK2x5ICs9hOQ0NiodpvvyKcUpAn+cq5OY
	pVUfoZrPAsiPWek9DcMXQpDoTl3BB6ceaqoNxgJtpDusAXubvMi3Os49dYOsr7p4DaEtVGdpquI
	zLMh8REadbIhBOoD7mhvGGHQZgZ899n/A+DLO1t/UhcjHGDMuTpnBQ==
X-Received: by 2002:a05:6512:1392:b0:5bf:c9c7:eae2 with SMTP id 2adb3069b0e04-5bfd9596876mr3227650e87.66.1793618293591;
        Mon, 02 Nov 2026 03:18:13 -0800 (PST)
Received: from pc636 (host-95-203-3-139.mobileonline.telia.com. [95.203.3.139])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe074168bsm1622248e87.63.2026.11.02.03.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 03:18:12 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 2 Nov 2026 12:18:09 +0100
To: Matthew Wilcox <willy@infradead.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
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
Message-ID: <auhxcS4rtrPG3tVF@pc636>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <auQhkHG6XlgNTdRr@gondor.apana.org.au>
 <auRo5WBj2OlKlWGW@pc636>
 <auTrzlSFCWNJYisW@casper.infradead.org>
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
In-Reply-To: <auTrzlSFCWNJYisW@casper.infradead.org>

Hello, Matthew!

> On Fri, Oct 30, 2026 at 10:52:37AM +0100, Uladzislau Rezki wrote:
> > The problem with spin_lock_irqsave() is that vmalloc() path can take
> > time to alloc and map pages. I am not sure this is worth to switch to
> > irq-save locking primitive. So this is the "heaviest" allocator in the
> > kernel. Callers have to be careful how the call vmalloc().
> > 
> > IMO, this caller has to be fixed.
> 
> Which caller, though?  Are you saying rhashtable_insert_rehash()
> needs to call kmalloc() instead of kvmalloc()?
>
The problem is that we used to BUG_ON() in vmalloc if soft-irq or BH
is disabled, i.e. for vmalloc it is incorrect state.

See https://lore.kernel.org/all/69ff8c7c.050a0220.1036b8.000b.GAE@google.com/
Two patches to address this:

1. https://lore.kernel.org/all/20260515153009.2296191-1-urezki@gmail.com/
2. https://lore.kernel.org/all/20261026102503.30860-1-urezki@gmail.com/

second can be updated and resent as it checks if the context does soft
irq processing whereas it allows:

bh-disable;
vmalloc();

forbidding this will address the rhashtable deadlock(discussed here) but
this will just fail allocation because it is incorrect state for vmalloc
and calling kvmalloc() for rhashtable will not succeed.

i.e. rhashtable context should be fixed also. This is what i meant by
saying: this caller has to be fixed.

--
Uladzislau Rezki
