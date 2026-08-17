Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FA63FCB2F
	for <linux-crypto@vger.kernel.org>; Mon, 17 Aug 2026 11:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786965466; cv=none; b=lTcTgRXcWyDtMYWb6oApDPICiLIc7SQ9x9vAjg0gL/PqtizZ/qK1u4LPHuZl6HoSAqs/YfPCHDf+Mc5xHYlKX/dv0Fpe2eXUKrdYUsj85URFC6N6aquJZ42/GH9KvqwkzJmkmihbgClBZfhb7s/StKkPtyXmtpteNsNNoezlXkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786965466; c=relaxed/simple;
	bh=nmIJqKYUorjBeUTJ55+kjKbsShLkxxa8SVIxElN7dTc=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=Vcv2VP+r9zBHkA7nQ/0WnpAq6fkFeV9Glb0bgIjrJchHL7/uHVWJkXWCi4S+oL8IKyas76BmWB2WxUTh3txEjExz6cNSJ1/i4Azy5pTZ0P6hmgMITc0lrVj4vN31M+dqQRNnLK7HfwTNLvpCZUZca8NkbYv62yaJkt6epXgyv5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UheXgto0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=N4JVShq7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UheXgto0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="N4JVShq7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786965464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jlLmM3V4bNqNAIwd0E7E4syK/sSR82TVvTikdxpHb34=;
	b=UheXgto0hpL3yCYPxDDFfae9wzMhNL1u6df7yW9lpS9GfIf2uS6VN844CE33SjbmXzXuZf
	CtawJT76cXlMFWYp2MSHBGqHf9w8dbWB3A5LFhXVuCG/j1WuNQezVdinBmMcFGWG3u/b8u
	VZjM6EiOt143Ols3/4AdUFVpCPAj7AY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-eD_XA6dIM_yHDlam5BrFuw-1; Mon, 17 Aug 2026 07:17:42 -0400
X-MC-Unique: eD_XA6dIM_yHDlam5BrFuw-1
X-Mimecast-MFC-AGG-ID: eD_XA6dIM_yHDlam5BrFuw_1786965462
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47fe85684b9so2751905f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Aug 2026 04:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786965461; x=1787570261; darn=vger.kernel.org;
        h=date:content-transfer-encoding:content-type:mime-version
         :organization:references:in-reply-to:message-id:subject:cc:to:from
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jlLmM3V4bNqNAIwd0E7E4syK/sSR82TVvTikdxpHb34=;
        b=N4JVShq7MhCNlo68qwtt2kPCCgiQhhJY09ARkrDZ8MHxpQKR8Xm6dL5hgkCx+a6kte
         S+1rsqpNHsUEhXz/h8y/nqKv/Ga9p5SDgRNwQ2oyQahq30G66+ylQ3dW4V/nqRzjiA7B
         WdnmCNwEh9EBkoERhPifTYHXKBvYMgUNOpRCRlld3Sh8C8rMaqqqnPLfJvjdYTJvjcSZ
         bMPc3Jp1lqRtM2je1Zu3IElqeRcAL+wsQJdjUnzt45znkDaMZwYTfrMxOlyLy0MSIsLH
         PR4B1nNkShuRqDjwQUG1pcF7xUttkex8z5tUNjWKaqPQxbZEd96SpLdXsGZAaOLKO9Sb
         Qvlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786965461; x=1787570261;
        h=date:content-transfer-encoding:content-type:mime-version
         :organization:references:in-reply-to:message-id:subject:cc:to:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jlLmM3V4bNqNAIwd0E7E4syK/sSR82TVvTikdxpHb34=;
        b=dFtKHK+WfcDT/qcSmHZKHMnQECKJOOGTMjFXDTjdMbgUHWtJJz0OCwX+5fTneu/Soz
         Yk+/1iYfUc1b532ZyD4rJ0Xi/6DoL3uSdyi+wSXNi5+41SqfYE2qLqcW7GU9D+Wx0Kc5
         e/1Awn4QsutMcgklYft6jePA0ZotGGEqgHtF/hZ0fkoDosoDJtiKUMOmfaT8Tq7Q4HPM
         JuQ4t8TXa36n17F2CRqwtIH6TwoOBpjBBYgJ0w4x/6Fxq/Zlurnnnwb3tbFG/lWbx0Vz
         W73FIkUGow4fZgkBFozTktlIw8SFwhnDN9anRljlusEME5IJOFPyaQ2kmfvhL5uKQjJK
         XuLQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpai2l3gKY/Uw9RAJsXlD4gRamAboyLW5MVEWp4QmAekr2qTr8wqNq0nunR5tC8YSJG1dktv9VngklnMsA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcrPyhc/fkRgAXt8uNPUaRNGDyWXE5OJjAoVkNY9X9XmTl4VvS
	0PPm6oDVpjT4/7NMNxoW8IAOTIR2yCVD+VyZ1DRxPHF4ZmzDcGcD97oAmeZ4TkOhZ8z/BtI1BME
	1RsiZ+mqaA32q4qWEHPGqDl7sXrqBzPMeZQnkeOGNcnCKD44x/33kP0KoR3pRxzyKeA==
X-Gm-Gg: AR+sD133aREcgw88GWAkAi58bG8MJRABrsVsTiUBnDdkA5L6E3dtSWbUlpaJrg8laTx
	6S4ibI9El9VZw6/lSk/3U9xgYhrphGb+v20k6s1NEeepfqUQtSN9EE6HivKcGJybGZAyWO/gKKf
	kDk/lPem27MikgIL5CLWeLFgzKDaYYlYCuawFSah8EEsrFqkD4VDiUBfESkvGt49u+y0sZSIl+l
	JUR2/VU3/DJWkf/4bZZjwUfESwa29B5996x7kP0niKek0aFLd/vssoraB+msoNdv71Wtyd4h3cm
	yNyBQeZbiYXSBmOTboH2bVPV3ayFe6IXJPE/KbUlqpbQZTRvQTL24droO6UWlI8HZo+zGIbN5nI
	kenkpTNH+83svycpatrbwOZ0j0VhV
X-Received: by 2002:a05:6000:18a6:b0:47f:5ec2:d54 with SMTP id ffacd0b85a97d-481607351d6mr41088970f8f.5.1786965461459;
        Mon, 17 Aug 2026 04:17:41 -0700 (PDT)
X-Received: by 2002:a05:6000:18a6:b0:47f:5ec2:d54 with SMTP id ffacd0b85a97d-481607351d6mr41088827f8f.5.1786965460933;
        Mon, 17 Aug 2026 04:17:40 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5a31572sm3207747f8f.5.2026.08.17.04.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 04:17:40 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org, Pablo
 Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil
 Sutter <phil@nwl.cc>, stable@vger.kernel.org
Subject: Re: [PATCH 6/6] netfilter: nft_set_pipapo_avx2: add missing
 vzeroupper
Message-ID: <20260817131738.51554efe@elisabeth>
In-Reply-To: <20260816171518.GA2013@sol>
References: <20260815205750.169336-1-ebiggers@kernel.org>
	<20260815205750.169336-7-ebiggers@kernel.org>
	<20260816123839.3670e5c3@elisabeth>
	<20260816171518.GA2013@sol>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Aug 2026 13:17:39 +0200 (CEST)

On Sun, 16 Aug 2026 10:15:18 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> On Sun, Aug 16, 2026 at 12:38:41PM +0200, Stefano Brivio wrote:
> > Eric, thanks for taking care of this.
> > 
> > The patch looks good to me, I just have two questions:
> > 
> > On Sat, 15 Aug 2026 13:57:50 -0700
> > Eric Biggers <ebiggers@kernel.org> wrote:
> >   
> > > Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
> > > returning from it.  This is needed to avoid degrading the performance of
> > > any later SSE code that may happen to be executed.  
> > 
> > Out of curiosity: was this prompted by some observed latency spike in
> > execution of SSE code, or it's just meant to satisfy the recommendation
> > from AMD and Intel to use it while transitioning from AVX to SSE modes?  
> 
> This one was found by code review.  But the latency spike has been
> observed in other cases with missing vzeroupper, so it's definitely a
> real effect at least on some CPUs.

Ah, interesting, I've been wondering about that.

> > > Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
> > > Cc: stable@vger.kernel.org  
> > 
> > Is this really stable material? Skipping vzeroupper might have a
> > performance impact, but it's not an issue for correctness.
> > 
> > The main reason why I'm asking is that, while vzeroupper might look
> > harmless and obviously safe, it actually caused CVE-2023-20593
> > ("ZenBleed") on AMD Zen 2.
> > 
> > I expect systems receiving stable kernel updates to also run the
> > patched microcode by now, so I'm not overly concerned in any case.  
> 
> It's awkward to mark something as a fix, then not actually want it to be
> fixed everywhere.  The stable maintainers know this, and they often
> apply fixes anyway regardless of 'Cc stable'.

Right, I guess you have point there.

> And if vzeroupper is really not safe due to ZenBleed, then why is it
> used everywhere else in the kernel?  This is just one of the few
> exceptions that doesn't have it.  If it's not safe then they should all
> be alternatives that patch them out to no-ops on affected CPUs.
> 
> But since that was never implemented, and userspace almost always uses
> vzeroupper too, it seems the only real solution is the microcode.  I
> don't think it makes sense to have a middle ground where almost all of
> userspace uses vzeroupper, ~97% of the kernel uses vzeroupper, and a
> random 3% of the kernel doesn't use it.

Don't get me wrong, I wasn't advocating against "fixing" this for
specific paths, rather just pointing out that something seemingly
harmless such as vzeroupper can have nasty side effects.

I used ZenBleed as a mere example, not as a current reason to do or not
do anything specific.

-- 
Stefano

