Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792706723;
	b=2tGOjzcGe5N1wJW1rQ+LL3hshiTsuZzJRiOJH3lUqf7e/yYWH/UtU+0DKp1v11R6Axe9
	 ehF2/QGbAY3+ubMnOS6Mne98/EBwFeM8aGjyL43mOPc4126weShwoFX3XOhdWmbr0Loo5
	 42d7UxO4kZ1WVE8GmtisIE8LaFNAB5/qTelQSPoeJJG0cAcEr+Ui9cfK/TPD/HkO9riL2
	 ob0P5GmbxcxBSVGyoH4Ykn/5rbmyTZRlHErJCg3x5HdPZAoznGYOD3bMThnKbMYF6kzND
	 Hw9t1/DtK4tSDzKdA0B+c+2835ppT0x3E0danXJLIxOqVE5ZYjSXMsLcYG1+rHfvw4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792706723;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=1/BUQdhYtXycx0vnNfE9NP3iNYT1zXH+kKAKzMrdrV0=;
	b=UvfqLGNydsPhZVukSX9cDazERPd8hwxtNQAZiPbig7QGAXlfI0KgIwQCr83Tvkv/dhe2
	 DAcbZ3zNljweDE/5nilkhQQKf2TSkQDsMaL1sSMan3jD2pr8yeGbXz9AoKNy2+4HT6KQP
	 nbGB6UEL4lLyoXqoc48KqAOgxn+LUG9Q9tCt06y48qfsTmIJo4eo9bhwHsiib7n8kD/2c
	 7O+C3TH3rJ1cXekF5WGA0y9qrYa3oXhHl7pMcWpqlpOzxDlbegUXY/ExKkzIE3qH50vZA
	 h5QZH1rkMBfazXBbkJo2r+6/1iI58jVjSwew23jLaHkc3ekiUIUErenlC4/oq1f4tew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--suseendranb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=CuXs0wbv;
	arc=none smtp.remote-ip=209.85.215.197
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59447606A324
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 22:05:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59447606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suseendranb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=CuXs0wbv
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd68bf391e1so148544a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 15:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792706723; x=1793311523; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1/BUQdhYtXycx0vnNfE9NP3iNYT1zXH+kKAKzMrdrV0=;
        b=CuXs0wbvrutvyKXXoh7DNB5Dw0dO9AcxLvyh3/AGBwEefUPCuveDo2yjZOrZwuGsub
         e/3CXuTsw14Wi9o+HOrgqP4AuX96/dJD8PE14mimU0n76rAFITT9B42jqFik1gc9NlKZ
         HnTXaRIRVxHQpbiWZ+ZDXn/kMBE3D+oIizavCEQPH7JeL71gScjDEswYGQ8dOAge8omo
         pqX9LgpNVMaP5rLPuESIcAkcE84m87wclCRDxpPwfi+gH5oWbGp+Gih9n2J0/L4Tc6JV
         jC1FCtslRQ0u2M7eXbSDoCj9T/xysZtvY+SYQ4oPNcDszc/uYinpnWkfJzMLBX83YvGd
         91cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792706723; x=1793311523;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1/BUQdhYtXycx0vnNfE9NP3iNYT1zXH+kKAKzMrdrV0=;
        b=tU81szFYUxB3IbpPSNVo8z8qOAn8pS1G1MF8w+28HRbnnOnohOtbTrY3N7l4nJSPDK
         Rus4FSr7oMtDJhjqhITuYvlBHV+alxpF2zSzD3F+xumzvSt4ceE5IlU58XP5Trr6KeWS
         O4iWkPR1Ez9oZkG3jafbraHB8HTpsu0jS64yaTxirkolCiaQjUBsWTb3kJHymJOZ9vwY
         hxjAgyNKBzSSzveGWGG6KOcbpT2V72v2ZyA7A54693qIofOuocEhj7H85zIAnZn8W74T
         gFKzHomIhsAXfco79FqbZibXMD4kUeRe7RJ7l2IdrL9J8mDp8lFIW57GNblAZTlUZYSw
         Pakg==
X-Forwarded-Encrypted: i=1; AKwUvBxt1N0lpHH/Y/zgcox5P0mSz994rCw9HcU/qU4HS2JmUNstO3OkwpWs9L6QsI2PDpYsuaNPUaikeQeP4rM=@vger.kernel.org
X-Gm-Message-State: AFq9FYJLWx8q9BkasnrUNTb+NAunVESzFPhyDN5KW/VvZHU5ZTE0Emm3
	D1TFG9W3huSv29HHNUusmKzh/zPxwub8pdbeuqnf1HiFL0MTu0nwIpiJupQnOnRS6SG1ianhx4V
	8CoGhhOUaN8TV6sCYuz9iEBieaA==
X-Received: from pfblr27.prod.google.com ([2002:a05:6a00:739b:b0:88d:74fb:fa56])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:748b:b0:3e2:7030:9080 with SMTP id adf61e73a8af0-3e36945eec6mr190250637.47.1792706722405;
 Thu, 22 Oct 2026 15:05:22 -0700 (PDT)
Date: Thu, 22 Oct 2026 22:05:16 +0000
In-Reply-To: <CAO9r8zN6hN4h5m9pg4xQpirJj3o2nhGx5dxAuSddZ8+UenYnMg@mail.gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-3-suseendranb@google.com> <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
 <20261022155144.4177200-1-suseendranb@google.com> <CAO9r8zP+GUE-hcGWSGzhLNLcchFoZ38EMVCAtX5yZ78tZ0bbgA@mail.gmail.com>
 <20261022183319.163484-1-suseendranb@google.com> <CAO9r8zN6hN4h5m9pg4xQpirJj3o2nhGx5dxAuSddZ8+UenYnMg@mail.gmail.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022220516.383697-1-suseendranb@google.com>
Subject: Re: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor compression
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Suseendran Bhaskaran <suseendranb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 22, 2026 at 12:15:51PM -0700, Yosry Ahmed wrote:
> On Thu, Oct 22, 2026 at 11:33 AM Suseendran Bhaskaran
> <suseendranb@google.com> wrote:
[...]
> > Since dlen is only valid when !comp_ret, we could normalize comp_ret
> > first when !comp_ret and then just check 'if (comp_ret)':
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -874,19 +874,24 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> >          */
> >         comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
> >         dlen = acomp_ctx->req->dlen;
> > +       if (!comp_ret) {
> > +               if (dlen == PAGE_SIZE)
> > +                       comp_ret = -ENOSPC;
> > +               else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
> > +                       comp_ret = -EINVAL;
> > +       }
> >
> >         /*
> >          * If a page cannot be compressed into a size smaller than PAGE_SIZE,
> >          * save the content as is without a compression, to keep the LRU order
> >          * of writebacks.  If writeback is disabled, reject the page since it
> >          * only adds metadata overhead.  swap_writeout() will put the page back
> >          * to the active LRU list in the case.
> >          */
> > -       if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
> > +       if (comp_ret) {
> >                 rcu_read_lock();
> >                 if (!mem_cgroup_zswap_writeback_enabled(
> >                                         folio_memcg(page_folio(page)))) {
> >                         rcu_read_unlock();
> > -                       comp_ret = comp_ret ? comp_ret : -EINVAL;
> >                         goto unlock;
> >                 }
> >
> > Does this look good to you?
>
> Yes. I assume this is completely independent from patch 1, so we can
> tell Herbert to pick up patch 1 and send this separately?

Yes, this change is completely independent from patch 1. Herbert can
pick up patch 1 as-is.
I will address the latest Sashiko finding on patch 2 and send the updated
patch as a standalone change separately.
