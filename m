Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9CC3126C2
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 12:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294324; cv=pass; b=rjMOmFMZeOufOr3fk7R4363GIYvAzuENxgOJQoXR/AJxq9dQAltpP0q9k3KTEctuu5XNQKKLXVZbtDNwp27AHmibdTODmE90+ETuMxnrCIRPU/JD4WB/fvimn507oInKtc9U5JUMFRLnoMvjjkRN/TQBbS99C+yMa0P4hCCj4+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294324; c=relaxed/simple;
	bh=EG/J4UGh3eCwSuRcJEkJEJxR7JlBLrl/6GrVtUQBlGs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nTeXAqcXwsN1IAzcnQYto1EmolnpVPqGPQKevpqDrFxmG9TmXwI8nl40X5QXtZTVw9jm8Q1uADOLn+eQ+2QOw44CmmBlqF4pbSIJqZyHvodyG2Knom8x60l9En5qEHyuwS3nGQuxc/0+7i2C5OA25QYvCGivBKrz+jOHlihH5nk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G0Yf1hgu; arc=pass smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G0Yf1hgu"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7dcd89701acso5241864a34.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 05:52:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777294322; cv=none;
        d=google.com; s=arc-20240605;
        b=Y4Ho2a+Zmj2op/Pa488K6Z51yxOwfTQ87xIYS9rVcdpzhVd1nU4EgrFvE7cihoNrGm
         D4bJ/rLmyMHCUo9XvgEq3ZszZ0owlVczAF28eHPPln+wY3oDJnyYQwwpy/xN0xIXwjPB
         7iwjCuCfS2kX9dZb/KYeB1Z8QBhxpPb38yiBvI3oUvpZYDQKgUIXXkFDtmrZVdF+0/l9
         cmDmMfutivqvJFKYjmJldr0BMHiegWn1B/os9nWfFrE9qOT+OF4yPc6FYWZTDEpePsoi
         qV9AFj4n84uhjVESoqfeJKJxWE5JWeyDfcXGi+3RHr9GI56cu0A1q68+5PlHPj0z3wSX
         G+0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EG/J4UGh3eCwSuRcJEkJEJxR7JlBLrl/6GrVtUQBlGs=;
        fh=/uVFru6XyY8vdvyN0jcqHIAQQoguSS/Kp22wQOaEblo=;
        b=OldBsMG2e/xPZY5QPS4QMVqT8frGbWsDG/7YMOV3/rJLkib+jWDtM9mbm9WEp++Sia
         LL+A2IA6ID9H/j5LmPpAZpG/d+nDc7CHlGON9NJfI8mV5YjPnALL4L9t1jBYhH7DWkEB
         hdJQ/LIDMnC5n/CRY5VvCT6dCBFqtKoW/LsXSNegGU7S8qbxuKfWEmiXIDByMWXzr0V8
         ZOpzQGLyC93nujqk11PDXO/ehGALBog0+0syD3TWwr1aDs5yqg9UqO1NRYIlL+ZDbujB
         5czVaJjt8/HcXZ7cS+LCOQbyMFkVn38Z8iCKIpE5c6wqeiYA/nqhahuuRgDmGx8ygzuW
         S9vQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777294322; x=1777899122; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EG/J4UGh3eCwSuRcJEkJEJxR7JlBLrl/6GrVtUQBlGs=;
        b=G0Yf1hguojRHNRSWp8/L/SqogjcktqFRhjfMwoq15RF9QTNw0PXp/OhiaDgz+U+OPX
         0NO9fA8twaLKIluXBPJ6z2lnU7FnvZ1UzhxRYItS48JUIJzPC5jv+ckMkgJLX63hWe7q
         x4oEeDg5vbWUG4yE4R2Gh8gHrdS4BbgKvLS626KiDGYSTbgltrmcwvV2F6ElONsy/B15
         13LDOdKutasevGOaCmmzWXE/eF6U8AHJBNFkfv08BBo8izI0BaS6hs52+vyWmrZPmKq1
         8hz5zOewTuiY2V8hij5CwsqoG2c17ehs2CcEQ8wAFiwocmbto1ezbjOAAyZOeOfxQdyh
         G2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777294322; x=1777899122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EG/J4UGh3eCwSuRcJEkJEJxR7JlBLrl/6GrVtUQBlGs=;
        b=n28Wvn1WGGtISaRl8jMz7/zf6/ziI4aC3rxJegXeb4Fkm7HIiKMqILNyIXorDqoQm/
         lT63Z7x9ypf7PTtlsqQnurfUr99aSUe/Gf02c7XtWWEwf5CCxqId4H2c3chfQBnGvLHz
         KS51PY1ChI/A2WyvPEjdr3vCe8QpyK95re7mzELz3AEImuPK744CtVA2hJd3oCRgd2Mh
         ODP+4gmMJopiOb3nJ60t9Jz2XrWVB1n1IoYKe/eF12GGdRjvPOs9XaKZPdHWIllZ3Flt
         aU/xYSTUSJKyl/+yZpJZY891Mzfiy7qJQ2+D124Zb61piwmeCPO9Yp/qrXYVItP0lwab
         MVVQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ogxV+RgkQPTZqfVwDe3cq7JHYy+pJRYEQ0w3riZyMAqm34eTO1PCcj30pvp4MT5T0+W8WlpF/j5SeRaQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvj5/TDaYmrOJ+ii7nAR0jGZuJP3nKt2l2mBUh6tZnSO29+q43
	3NhnssIzFxvMDnw2KIcPtrhbWzEJ1zDNpVbTA3cYIS7CGXowNUsuQdlMFmoEzV/ezwB/8VNW8Rs
	bxb3pXStItrtdm+Ywe1IkRn8Se6sCvq0=
X-Gm-Gg: AeBDiev2nzSdv1lDidGjy6fBWYM/vnICbo6IDbRecn+zH/gkDT+0IDT5UHybuvWB+Mq
	Ra5w3OnLglTn/bcF/Tx2bK9xDUirKAehLxmyrHQfA6qNqEHAGgz/ZbtHUvvwK+peyqfqu4HsRuO
	dv4AxLx+eH66Qu2Mgp/S+kNyk5/G79DOOoy2XlPT0fzaNRmjMW2R+Esluv1FKsEJYK/Jv8Gb0Tq
	ocJSLpmD+BlU4dkeXwFDDURD3p03lJiWdfozA8T7PfG8tj7f/mm7IwH0n/R5WFAFkqQNqTHE8wR
	hLmUEtEwuFg5Ysnxd5H7AuRKZH/6dg0=
X-Received: by 2002:a05:6830:6732:b0:7d7:f638:7a03 with SMTP id
 46e09a7af769-7dc950ff385mr27811030a34.10.1777294322529; Mon, 27 Apr 2026
 05:52:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
 <ae9ItoKFvB12Qimn@gondor.apana.org.au> <20260427-ledig-urform-4719da0a06d2@brauner>
In-Reply-To: <20260427-ledig-urform-4719da0a06d2@brauner>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Mon, 27 Apr 2026 17:51:51 +0500
X-Gm-Features: AVHnY4IScH53UaYPIaA6YOC4aKjN9vN_SqKv35Tn7RXxw0SMwzMLtQd2SMg1vdw
Message-ID: <CABXGCsPtb5dsz9tJFO-42qY4Cqd4MDg=m3g-9CshQgO00keyOA@mail.gmail.com>
Subject: Re: [PATCH] rhashtable: give each instance its own lockdep class
To: Christian Brauner <brauner@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Thomas Graf <tgraf@suug.ch>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com, 
	Jan Kara <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 5:21=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> >
> > But could you please try this patch and see if it also fixes
> > your problem?
> >
> > https://patchwork.kernel.org/project/linux-crypto/patch/20260422213349.=
1345098-2-mikhail.v.gavrilov@gmail.com/
>
> Possibly, I don't have a way to easily reproduce this though.
> Imho, the right thing would be to have both: actual useful keyed lockdep
> annotation and - if safe - dropping the mutex.

Agreed -- the two changes are orthogonal: yours fixes the lockdep
class collapse, mine removes a mutex acquisition that has been
unnecessary since cancel_work_sync() was added in front of it.

On the safety of dropping the mutex: rhashtable_free_and_destroy()'s
documented contract already requires the caller to ensure no
concurrent operations, and cancel_work_sync(&ht->run_work) at the
top of the function quiesces the only in-library writer (the rehash
worker). After that, the tables are owned exclusively by this
function. The walks I switch from rht_dereference() to
rcu_dereference_raw() were already correct; the lockdep annotation
was just asking for a lock that no longer needs to be held.

I checked all in-tree callers of rhashtable_free_and_destroy() (and
of rhashtable_destroy(), which inlines the same teardown) for
correctness against the contract; none rely on the mutex for
serialization with anything other than the rehash worker.

I have no objection to either patch order. Happy to rebase mine on
top of yours, or for it to go in independently via Herbert's tree
once yours is merged.

--=20
Thanks,
Mikhail
