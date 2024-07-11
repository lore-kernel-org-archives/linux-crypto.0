Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0C616B75D
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jul 2024 19:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720725481; cv=none; b=dgLTkKl4J+f+5O6CbJDzysknE5yXTGFgbJ0nnXnr+w7oq01e7zlel8kLbEPQQtq8PVorROqM3pU/OL1ML43Xk/3TZ6a5HQxF3cr/ErikGWCwxhEMhMBZ3QT2e4F062xCNw2sJK2EMKfxZOfCS5XMCy7/H/4E6JC4W8P+TXQEWU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720725481; c=relaxed/simple;
	bh=jml2mH5xPX6WLHw6QUqvLqc4gm8iBoTV1e8ILzGXDOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dUXpRouup+ZL6+oFJzeycikEvd9VaPRFVAdWajunNQbCS5w0Oq8VUsEcxYxayMFf512/I/N6F3UPzIvKUY1f9PvWrO4HRQ6HqjDmL83nUTTMFeu2MOOKb0LAr6riq7bQ4pAYpLCpNwGuQUJAtRedTIQwR+6oj4vdaDGNPA1NLtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UZ6bQRut; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UZ6bQRut"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-595856e2332so1601233a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jul 2024 12:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720725478; x=1721330278; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PfkbCy6IC8MM2ShGGRIr/7yv5osfVo7ephGJ4Ll7hD8=;
        b=UZ6bQRutE9y1fXyZCAPMmbq4wfcZUdp2IvI6GM1DTlyFoHshJpBxryXnvC2Y4Puo7j
         LWFDJZuK6DVZpGZ4evDHFhakV229Fi9CATz6Gr9chaRLCZNHVyHC0h7oaLoFqqwzDGjx
         tsVc2WIYdbkGsJdxDZxC8T9c5ZoBRDvZQOQA8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720725478; x=1721330278;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PfkbCy6IC8MM2ShGGRIr/7yv5osfVo7ephGJ4Ll7hD8=;
        b=GONwWg+lUQJ/ZmOyfBAdEUZKBJ7pcfOKT1niZwYNWnscnJTMSbOlCZOElF7OJ8SlBx
         yBmNIiEX2IzK+o5RznelwTNp09Mgao7pP1F8NYtZS3xHoPFqJowCvDIMNW/FVlnnwDII
         h/CYDIXq9rFqwUA8NHzbuvpLfAJkOSzPRz921XJ+t2c4Xu3LJUmWAxTU2qZfa2M/5Fqh
         Ra3O88qp+ISd0ymMqJQY3IEkKpbwL4zvCRvpUN2F5bLjexqphVHxBko2yvMFoWIVTHI9
         BY/+DhvTgsMfhC8jh7Vkt1lSjvhGZQ7YkpFzphPFsDVkcsUCgwwsuLJgmfFcTzwg9Jtc
         tsfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIhJBfWT1419sQLZO9dizR7Z2a2quBluha9o8AFeuwEbLdKqrhQOm0nGpaUt4sOaMG50JEfTz4NH51xfeWXNXDWWIgFEtZJZOy6Cuw
X-Gm-Message-State: AOJu0Ywe2jRYrFRYjRT+g/oJZ1mD5FXa17iQVo3xnoIn9f+YGr8HqduM
	miDFuwPUn6C784mNazVMM4Cd4Paq/QKP9W3nlt4U+h/x+PXHUiA2wy8ZkoBEHqmp+G/pqE8KL1m
	YEy4Cbg==
X-Google-Smtp-Source: AGHT+IGkkmFLyCPGy4VCmdwQqJynPks/rWpUSkPCu9W9CAKRWj+zizSs0eiKFJ4gjQAMg0NKzjfYzg==
X-Received: by 2002:aa7:d44b:0:b0:58c:f5bd:eb60 with SMTP id 4fb4d7f45d1cf-594bc7c821cmr5251077a12.33.1720725477956;
        Thu, 11 Jul 2024 12:17:57 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bda308efsm3713405a12.81.2024.07.11.12.17.57
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jul 2024 12:17:57 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-595856e2332so1601208a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jul 2024 12:17:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXGlayf76F4h210n61xdk66WiaceAwLlikzN0DZJnpaZSsDNcYhGTMsviXSr86KXaWZQYpO+HyMRfMQyUXozc0oTvMHZVoHdhfptmtl
X-Received: by 2002:a05:6402:2707:b0:57d:10c:6c40 with SMTP id
 4fb4d7f45d1cf-594ba98e3c7mr6937905a12.7.1720725476855; Thu, 11 Jul 2024
 12:17:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240709130513.98102-1-Jason@zx2c4.com> <20240709130513.98102-2-Jason@zx2c4.com>
 <378f23cb-362e-413a-b221-09a5352e79f2@redhat.com> <9b400450-46bc-41c7-9e89-825993851101@redhat.com>
 <Zo8q7ePlOearG481@zx2c4.com> <Zo9gXAlF-82_EYX1@zx2c4.com> <bf51a483-8725-4222-937f-3d6c66876d34@redhat.com>
 <CAHk-=wh=vzhiDSNaLJdmjkhLqevB8+rhE49pqh0uBwhsV=1ccQ@mail.gmail.com>
 <ZpAR0CgLc28gEkV3@zx2c4.com> <CAHk-=whGE_w46zVk=7S0zOcWv4Dp3EYtuJtzU92ab3pSnnmpHw@mail.gmail.com>
 <37da7835-0d76-463e-b074-455e405b138b@redhat.com>
In-Reply-To: <37da7835-0d76-463e-b074-455e405b138b@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Jul 2024 12:17:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjVc6cpSCJwAqrhPvwBbcQEOL2TEnCELfadhA=n1GN4Ww@mail.gmail.com>
Message-ID: <CAHk-=wjVc6cpSCJwAqrhPvwBbcQEOL2TEnCELfadhA=n1GN4Ww@mail.gmail.com>
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

On Thu, 11 Jul 2024 at 12:08, David Hildenbrand <david@redhat.com> wrote:
>
> We also have these folio_mark_dirty() calls, for example in
> unpin_user_pages_dirty_lock(). Hm ... so preventing the folio from
> getting dirtied is likely shaky.

I do wonder if we should just disallow page pinning for these pages
entirely. When the page can get replaced by zeroes at any time,
pinning it doesn't make much sense.

Except we do have that whole "fast" case that intentionally doesn't
take locks and doesn't have a vma. Darn.

             Linus
