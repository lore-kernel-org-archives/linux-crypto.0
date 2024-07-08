Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D967119B
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jul 2024 00:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720397331; cv=none; b=jK4Cbx8/sMaMZDXr7gHFTATuF1AsYRai28Qb45WUDHyHbnz87tTwuLXosfwyVhgR8bTONXaDZL+vTZdjHpfYgnaShN3+PzGQp0hL2q+9Va9ebCO0kHCTUmWpQERy7e5A0E2W1mcknTFjrAO8uxVjjiRZfmuBPQ6CDSaJ+UKfXJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720397331; c=relaxed/simple;
	bh=vn3ej6uz5HJ27Cac3DuFzn+uB9SQgk0rY+AAwVDZ1TA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZfyeiE/uqmJtJs3GICoUlAupuyhemBSB7igbjZY8/y/tXnWiKJD1s6v7Lm//pNIHXSoEskHrameuzk6fx97IeMVitc0rYhCEKR1e0Ls2jTyNw8W7qf2BA4ZkfmgN1mtBUS+2V7+A+f3RGw5FLkbjf3QT83Vvh3PZKzSXLoht4Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X9Zmvy1a; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X9Zmvy1a"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-58ba3e38027so3827555a12.1
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jul 2024 17:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720397327; x=1721002127; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AxHB4WSH7xbSrF4sriiEMDo3clBzyxps6KE5BYXF8FA=;
        b=X9Zmvy1a0/BwfgyjzRqkPU4zGtAANjSG92h3XEF3bjsujpRD1G3XU9krfRQ+ZVZAtT
         rKb6IQr9Jcsl4b07Dp7dq+I36CNKpLEQVrEF+LtnpasVLja2RytPKGtcFa0ZH0e55DET
         PHZqOIw7BGFsSaLCeYDr9Xv9GtZLI/JQJ7Yc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720397327; x=1721002127;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AxHB4WSH7xbSrF4sriiEMDo3clBzyxps6KE5BYXF8FA=;
        b=QeLjQ1+phE2vI8uKpGarN+9KtbLvYq6qDcayxa+kd5XU+JAUXvqlNGEVeV/a6cFrAo
         OpHMyyFOoS90I53i6Qq+f2HLEKUvPfUY/ci+SlheyzudUVG5WHeXxmfOV8TF41GZnTpe
         SozhUyOtPRVQrqbITi+udq9PYsLWTWDDp3fGiwE+b6o5AqUOKbOAOHtu3To6aoLv7h3q
         afsj6RpFN4/K6gAIo5o9F2r5XmrwkJZgYusUYVuQDdXH/mnqZkMlT7Z0dqPgIDnAOOtW
         /USnJiU0fgUF0JnsSqaOCiIJI1+T/RcVraa0Iiuw3bQey/ZbvDZjdXsODvGBZQ8cjOHt
         /9wQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxM9OhdSfVKFslnS8ll7UjhnBacY6ttq4JpP+lRJYckiy3mamBp7BedNzMpcoheFeJhhuVp4fYb5RHMzvVQ6shJL9Ps12730mtgD5E
X-Gm-Message-State: AOJu0Yy/lBhEfrwAI0rb57zooDZCNyhxpPlVbUdRneUhAUOfZdK21WRR
	hTcafe1JdoSU0cJlByMfZcqCGyiKSZwkzPq1rd6j+C1m3++3oGfXU54SYjNlrwUzyBTBzWDUuyS
	rYUnGuQ==
X-Google-Smtp-Source: AGHT+IF7t1Aw4xjQMbJvq6DEt/mUDXyVYYDqWifo8rWIx5+ahB3xyU2E1fbW6kkJ+y+gK/mnjJJimg==
X-Received: by 2002:a05:6402:280d:b0:57c:c2b6:176d with SMTP id 4fb4d7f45d1cf-58e5c826881mr8090709a12.32.1720397327087;
        Sun, 07 Jul 2024 17:08:47 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58f08760bcbsm3943800a12.39.2024.07.07.17.08.46
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jul 2024 17:08:46 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a77dc08db60so224504966b.1
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jul 2024 17:08:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXEVHkaSGED6b/5OIWcnLaEfaRxm5M6xQCwRfLJJF9E2oOXALlF4h/iUbHrFOPg2nUwMXGIWmAc35XEOnpnIoqU1W+yO3rOkhWQLzFo
X-Received: by 2002:a17:906:ce53:b0:a6f:af8e:b75d with SMTP id
 a640c23a62f3a-a77ba4552damr759244366b.8.1720397325858; Sun, 07 Jul 2024
 17:08:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240707002658.1917440-1-Jason@zx2c4.com> <20240707002658.1917440-2-Jason@zx2c4.com>
 <1583c837-a4d5-4a8a-9c1d-2c64548cd199@redhat.com> <CAHk-=wjs-9DVeoc430BDOv+dkpDkdVvkEsSJxNVZ+sO51H1dJA@mail.gmail.com>
 <e2f104ac-b6d9-4583-b999-8f975c60d469@redhat.com> <CAHk-=wibRRHVH5D4XvX1maQDCT-o4JLkANXHMoZoWdn=tN0TLA@mail.gmail.com>
 <6705c6c8-8b6a-4d03-ae0f-aa83442ec0ab@redhat.com>
In-Reply-To: <6705c6c8-8b6a-4d03-ae0f-aa83442ec0ab@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Jul 2024 17:08:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi=XvCZ9r897LjEb4ZarLzLtKN1p+Fyig+F2fmQDF8GSA@mail.gmail.com>
Message-ID: <CAHk-=wi=XvCZ9r897LjEb4ZarLzLtKN1p+Fyig+F2fmQDF8GSA@mail.gmail.com>
Subject: Re: [PATCH v21 1/4] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: David Hildenbrand <david@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	tglx@linutronix.de, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, 
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 7 Jul 2024 at 14:01, David Hildenbrand <david@redhat.com> wrote:
>
> At least MAP_DROPPABLE doesn't quite make sense with hugetlb, but at least
> the other ones do have semantics with hugetlb?

Hmm.

How about we just say that VM_DROPPABLE really is something separate
from MAP_PRIVATE or MAP_SHARED..

And then we make the rule be that VM_DROPPABLE is never dumped and
always dropped on fork, just to make things simpler.

It not only avoids a flag, but it actually makes sense: the pages
aren't stable for dumping anyway, and not copying them on fork() not
only avoids some overhead, but makes it much more reliable and
testable.

IOW, how about taking this approach:

   --- a/include/uapi/linux/mman.h
   +++ b/include/uapi/linux/mman.h
   @@ -17,5 +17,6 @@
    #define MAP_SHARED  0x01            /* Share changes */
    #define MAP_PRIVATE 0x02            /* Changes are private */
    #define MAP_SHARED_VALIDATE 0x03    /* share + validate extension flags */
   +#define MAP_DROPPABLE       0x08    /* 4 is not in MAP_TYPE on parisc? */

    /*

with do_mmap() doing:

   --- a/mm/mmap.c
   +++ b/mm/mmap.c
   @@ -1369,6 +1369,23 @@ unsigned long do_mmap(struct file *file,
                        pgoff = 0;
                        vm_flags |= VM_SHARED | VM_MAYSHARE;
                        break;
   +            case MAP_DROPPABLE:
   +                    /*
   +                     * A locked or stack area makes no sense to
   +                     * be droppable.
   +                     *
   +                     * Also, since droppable pages can just go
   +                     * away at any time, it makes no sense to
   +                     * copy them on fork or dump them.
   +                     */
   +                    if (flags & MAP_LOCKED)
   +                            return -EINVAL;
   +                    if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
   +                            return -EINVAL;
   +
   +                    vm_flags |= VM_DROPPABLE;
   +                    vm_flags |= VM_WIPEONFORK | VM_DONTDUMP;
   +                    fallthrough;
                case MAP_PRIVATE:
                        /*
                         * Set pgoff according to addr for anon_vma.

which looks rather simple.

The only oddity is that parisc thing - every other archiecture has the
MAP_TYPE bits being 0xf, but parisc uses 0x2b (also four bits, but
instead of the low four bits it's 00101011 - strange).

So using 8 as a MAP_TYPE bit for MAP_DROPPABLE works everywhere, and
if we eventually want to do a "signaling" MAP_DROPPABLE we could use
9.

This has the added advantage that if somebody does this on an old
kernel,. they *will* get an error. Because unlike the 'flag' bits in
general, the MAP_TYPE bit space has always been tested.

Hmm?

              Linus
