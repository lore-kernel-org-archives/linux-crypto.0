Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1099237169
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jul 2024 05:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720674447; cv=none; b=om4r7kObdNvxrRkuhG4+dGtVz4pCfq2sLKRi4cYZ5CTYVIQZuKhl32VLaaFRZ42WOVeGGBcf/qNRY2Zxv/TsOaLTYNIpl5ggUyvELKeJHpTw6wrDfViGYOmvgHAeBa6oEWvvhZfRD6jPLgOVV9MqgxTOG8RuVAvwJOZy3EYfnck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720674447; c=relaxed/simple;
	bh=nGrmC0u5rsERqyefhRnP7/QKTu/yo7p7qovzWnDCLCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pQ2CioFNBgiAty4wIN0nmEVtx47hjnwe6tMUi61qiOemx5WpqfjPKh80nuscp58VE+sjMGNizb7rLEZc1T+uZkw/dGbMNB2nnKYxGwbkRDObO82f+3pymCTbUgDosOB+IdOF0ogSHFJYZ9rB9JP0EbiGLvlvha7txGP84jek0bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DgnXdZL9; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DgnXdZL9"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52ea929ea56so903415e87.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jul 2024 22:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720674442; x=1721279242; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jtRyIrmKJ/IBvDIrDZPP2KUo8CcYvxcVDEjZhvnGRqk=;
        b=DgnXdZL9OJUcFxly0JEXNwiYcV2aXLDXrYyio4E/kW/HCSPWfESy80lJD0yuJv4tH6
         TlXJsdL5RVNMjKvzaCQTb983GvWudHY70IpNBA3Eo2sbZhfB74+KQiLUNfQdQHTokwmY
         WREJm9Vu131eI7WDQkT1vCBgjY74rMot+FTO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720674442; x=1721279242;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jtRyIrmKJ/IBvDIrDZPP2KUo8CcYvxcVDEjZhvnGRqk=;
        b=bz7dQ3ihnr0vTdfxn4+eTSonSmZQrkZSK+zPJIcjJEiQECjLdVXIbbBmsryhO+UpAY
         u5WH/6LkRhWmeqqtu0iA689YCAj2HFPjmttK5aCeo34peknnSceUz4sSj25V5nGNw/QI
         j22BiKgUSj2KlgTNblH2OTiHVG+gs+CkmkmmxucUvjn2qHxFyl7w2HdIIA34Ro33a9h0
         tgDLOHrx5i4eHp0c/mdLcdZRmKqeqF/PMY9yQy2/FppjyDerpZklepJry615Np/UzMDi
         91BDYprgmyMXuheilKINhHByBJuz6jKPkNGoQrC+FNW7dlBJQuIgdxX0a/KKagvDcGjw
         SbjA==
X-Forwarded-Encrypted: i=1; AJvYcCUyvbP51nAuyFo8ADzJiW3CErf+e4SYZ5I+BCYSVYGfLpg+/H7UkTybRBGPVX4yHOsHFlWG4rcd4r8Ga3HLKrEVNd00rLXqzBQbROAo
X-Gm-Message-State: AOJu0YzlqnbEwaCltYMQNTnialDspkO4c9RSCSUlrs9sPeT1TLtzsNVW
	5PuwTJHpGzd1fZ20D5cYcZ89SRVcFIGdTCWGSoeSPWmRU7gkeWNMY7McqIQ1fl7L4Z0fj+A0r5k
	F
X-Google-Smtp-Source: AGHT+IEjP0xucXdjWgTK3/DoKcSh/oNViKK03aYQSlGm3drK2aUvTS3kWc2PGa4DQjZfa5EP7B5g0A==
X-Received: by 2002:ac2:442e:0:b0:52c:e17c:cd7b with SMTP id 2adb3069b0e04-52eb999c2cfmr5136772e87.22.1720674442064;
        Wed, 10 Jul 2024 22:07:22 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a797f300b05sm103301166b.134.2024.07.10.22.07.20
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 22:07:20 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5957040e32aso341048a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jul 2024 22:07:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWeV1qFfYkrUd8MFo/R4MCGaWqkh6I+91iK5B1zrj/FLd1ZYIBYOCodRugHdot7YOQpnVNdGsRVXZxPG6Pl/GsJtqa3WvqRVn3mmWMX
X-Received: by 2002:a05:6402:134f:b0:58d:77e0:5c29 with SMTP id
 4fb4d7f45d1cf-594bb181cb8mr5703709a12.10.1720674440224; Wed, 10 Jul 2024
 22:07:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240709130513.98102-1-Jason@zx2c4.com> <20240709130513.98102-2-Jason@zx2c4.com>
 <378f23cb-362e-413a-b221-09a5352e79f2@redhat.com> <9b400450-46bc-41c7-9e89-825993851101@redhat.com>
 <Zo8q7ePlOearG481@zx2c4.com> <Zo9gXAlF-82_EYX1@zx2c4.com> <bf51a483-8725-4222-937f-3d6c66876d34@redhat.com>
In-Reply-To: <bf51a483-8725-4222-937f-3d6c66876d34@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 Jul 2024 22:07:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh=vzhiDSNaLJdmjkhLqevB8+rhE49pqh0uBwhsV=1ccQ@mail.gmail.com>
Message-ID: <CAHk-=wh=vzhiDSNaLJdmjkhLqevB8+rhE49pqh0uBwhsV=1ccQ@mail.gmail.com>
Subject: Re: [PATCH v22 1/4] mm: add MAP_DROPPABLE for designating always
 lazily freeable mappings
To: David Hildenbrand <david@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	tglx@linutronix.de, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, 
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Jul 2024 at 21:46, David Hildenbrand <david@redhat.com> wrote:
>
> Maybe we can find ways of simply never marking these pages dirty, so we
> don't have to special-case that code where we don't really have a VMA at
> hand?

That's one option. Jason's patch basically goes "ignore folio dirty
bit for these pages".

Your suggestion basically says "don't turn folios dirty in the first place".

It's mainly the pte_dirty games in mm/vmscan.c that does it
(walk_pte_range), but also the tear-down in mm/memory.c
(zap_present_folio_ptes). Possibly others that I didn't think of.

Both do have access to the vma, although in the case of
walk_pte_range() we don't actually pass it down because we haven't
needed it).

There's also page_vma_mkclean_one(), try_to_unmap_one() and
try_to_migrate_one().  And possibly many others I haven't even thought
about.

So quite a few places that do that "transfer dirty bit from pte to folio".

The other approach might be to just let all the dirty handling happen
- make droppable pages have a "page->mapping" (and not be anonymous),
and have the mapping->a_ops->writepage() just always return success
immediately.

That might actually be a conceptually simpler model. MAP_DROPPABLE
becomes a shared mapping that just has a really cheap writeback that
throws the data away. No need to worry about swap cache or anything
like that, because that's just for anonymous pages.

I say "conceptually simpler", because right now the patch does depend
on just using the regular anon page faulting etc code.

                 Linus
