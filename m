Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEBB82C7E
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723137298; cv=none; b=GoYCirvaBR3Sp28TmVQJuBqWSK66XF2zzKGNFTBuuWDOxB0GxsOWjcFnVUsrLg0L/b0qbXmHSgGebclU+mIG9mSewd8y/J+X+UjtTDBXverjpjV9TvWQTbbYKgjEljxbU9EsvP4YYQ2wf7auu/d+OHz1KLrkoOffdEigIuPIjfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723137298; c=relaxed/simple;
	bh=L7oLADHUvPGEanWDPqKnEBms2XM9B2QgFV5tRMeZQwo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HufQxn9ZKFhacuyA3d5P/WBB6JYv5o9g3ZtP4MIE39xnas7Y8c3PoJC2lZvQbQTNje2C6bkegERxcptMLRg4OKVVlb+KKEAZC1vevIpBB7Z6W675kJBss4hOiJ+ZGHfy/rh2593EaZoxhwxO9WcQZZLUcRvnWZiXcs/xB+ffLKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ARdilbZm; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ARdilbZm"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5b391c8abd7so1422836a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2024 10:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1723137294; x=1723742094; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xV4UQkFScWXkqLsiHfaQGfUyXtovasZxLVVYWBINvb8=;
        b=ARdilbZm4bKP9sI3NW2SbBZ2oHomv7bqHM5bD8vPDWP5dRZCBx4Nu9WZJ8jdwwFA8B
         uxmk9xUMb3cGRplxCvuPz03tjPuUsN2PGpd07QiH+9JJUnW+WY/0SX/+Lw7D26klUVBh
         NcxRj16VSYXT/kg2ZSvlK61e38+sNx03f5PoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723137294; x=1723742094;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xV4UQkFScWXkqLsiHfaQGfUyXtovasZxLVVYWBINvb8=;
        b=DKp3mrRi2Y5z+ziG09Buav6B69DThF3cT8HqHro7tFCsUNnOCfh7gN4WkUAwcP/jLL
         zNBktqt35bz41aharIc13u/n0/gtWCNtkWhfMOqoZMLTh+X2c4mLWgSI6ghsivXvPmZ2
         HodbDgnbBqP9iQ+xSxsk3YdMlJI+rq2m8gmYWqFNCvpZ5e24yDt5/V9kdJM9wYN7KaDk
         p/apWAUPkRV4u2BqEUEperPaLUOc4u1C0s2CuBlgbAB4M5LYXelBt/1Fnzyut1qSPcUX
         vWdXw0QZbVlKGHLW7YuMHi5SgxbEDyhuE1c9MYJVuuqKMMDe07G6H+1dfXmUc5w8cNyF
         l1+A==
X-Forwarded-Encrypted: i=1; AJvYcCVFd0PaHeRDhxTHzFSjeOs2g9L0FLkECkA0O6QpLd7OV335aGN7diJnc/dQ2/2qL1yaY9hSTNcACeMrBlxB2GNFckPhznUpYC4rPr6X
X-Gm-Message-State: AOJu0YwBoJktyu0LhssrHkF4hQKf/lWr8eVydRQGyb8+g/I5cGNUAETg
	Ev4ZdDaVmfUe9g9blK1JvatKRqJhiukCDwj4rxmj4MO12C+r7cCqJcyfwmi2JXFoar4omh8ypEc
	5ZG6MEQ==
X-Google-Smtp-Source: AGHT+IHUJwBLxS1MHvMTS5vqVIqlfjUchZ8xu4xfv7vRjUFaJhLETfksmThlRKLUNTtt5a8WPCqksw==
X-Received: by 2002:a05:6402:26d0:b0:57c:d237:4fd with SMTP id 4fb4d7f45d1cf-5bbb21f417bmr2150398a12.4.1723137294477;
        Thu, 08 Aug 2024 10:14:54 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bbb830c271sm359376a12.17.2024.08.08.10.14.52
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 10:14:53 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5b391c8abd7so1422769a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2024 10:14:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVoTBYmEPGeBeGlqPKxzSsMtPpcurAQCgHD7MufOGyj084JpJ7wpnf8IwfWbXhPoxwtWiOW8OhqX7jyxQPz6h4WagtlKW/A6CNWJPEv
X-Received: by 2002:a17:907:970c:b0:a7d:cf4f:1817 with SMTP id
 a640c23a62f3a-a80907c9862mr189430266b.0.1723137292408; Thu, 08 Aug 2024
 10:14:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZrFHLqvFqhzykuYw@shell.armlinux.org.uk> <ZrH8Wf2Fgb_qS8N4@gondor.apana.org.au>
 <ZrRjDHKHUheXkYTH@gondor.apana.org.au>
In-Reply-To: <ZrRjDHKHUheXkYTH@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Aug 2024 10:14:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjLFeE_kT5YHfHsX9+Mn10d2p+PQ0S-wK0M3kTFe37o_Q@mail.gmail.com>
Message-ID: <CAHk-=wjLFeE_kT5YHfHsX9+Mn10d2p+PQ0S-wK0M3kTFe37o_Q@mail.gmail.com>
Subject: Re: [BUG] More issues with arm/aes-neonbs
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
	Ard Biesheuvel <ardb@kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000036ccf0061f2f2a1e"

--00000000000036ccf0061f2f2a1e
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Aug 2024 at 23:17, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> OK I tracked it down to a recursive module load that hangs because
> of this commit:
>
> commit 9b9879fc03275ffe0da328cf5b864d9e694167c8
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon May 29 21:39:51 2023 -0400
>
>     modules: catch concurrent module loads, treat them as idempotent
>
> So what's happening here is that the first modprobe tries to load
> a fallback CBC implementation, in doing so it triggers a load of
> the exact same module due to module aliases.

Ahh. That would indeed be very wrong, but yes, the fact that it now
just ends up hanging is very annoying and not helpful for debugging.

Sadly, the "return -EBUSY" that the code initially did caused problems
because when the loading isn't recursive, but just concurrent (because
two separate users show up at the same time), you really do want to
wait for the original loader.

> Now I presume this used to just fail immediately which is OK because
> user-space would then try to load other aliases of ecb(aes).  But it
> now hangs which causes the whole thing to freeze until a timeout
> hits somwhere along the line.

What used to happen is that the recursive loader would *also* load the
module into memory (so it's loaded twice), but then the two loaders at
the end get serialized by the 'module_mutex' when it does the
add_unformed_module()

So at that point the module_patient_check_exists() would notice that
one or the other loaded module is a duplicate, and would exit with an
error (EBUSY or EEXIST depending on whether the "winning" module got
to MODULE_STATE_LIVE in the meantime).

The new code exists exactly because on big machines, the "load X
modules concurrently" was a huge cost, and would use literally
gigabytes of memory loading the same duplicated module multiple times
concurrently, only for all but one of them to fail.

So now we catch that "we're already loading this module" early, and
wait for the first loader to do it all.

But yes, it does mean that you can't recursively load the same module
from the kernel.

... which was obviously always bogus, but now it's actively very wrong.

Sadly, loading modules recursively is very much required in general
(because modules depend on each other). So we do need to deal with
that. It's only loading the *same* module recurively that is very very
bad.

I guess we could at least add a timeout and a big fat warning when it
triggers. But what's the right timeout? Sometimes module loading can
really be very slow, if it problems hardware.

Let me think about this, because the new behavior is obviously not
great for this situation, even if it was triggered by a different
kernel bug / misfeature. From a debugging standpoint, that "silent
hang" is most definitely bad.

It did apparently take a long time for people to notice (that module
loading behavior is over a year old by now). How hard is it to just
fix the recursive load?

ANYWAY.

While I think some more about this, does this attached patch at least
give you an error printout? It won't fix the situation, but at least
the "silently wait forever" should turn into a "wait forever but with
a warning".

Which isn't perfect, but is better, and would presumably have made it
a whole lot easier to debug this nasty situation.

Hmm?

(Please note: ENTIRELY UNTESTED! It compiles for me, but I might have
done something incredibly stupid and maybe there's some silly and
fatal bug in what _appears_ trivially correct).

                 Linus

--00000000000036ccf0061f2f2a1e
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_lzljfy8s0>
X-Attachment-Id: f_lzljfy8s0

IGtlcm5lbC9tb2R1bGUvbWFpbi5jIHwgMjggKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLQog
MSBmaWxlIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEva2VybmVsL21vZHVsZS9tYWluLmMgYi9rZXJuZWwvbW9kdWxlL21haW4uYwppbmRleCBk
OTU5MjE5NWM1YmIuLjQxNTBhNTQ2YTAwYSAxMDA2NDQKLS0tIGEva2VybmVsL21vZHVsZS9tYWlu
LmMKKysrIGIva2VybmVsL21vZHVsZS9tYWluLmMKQEAgLTMxODMsMTUgKzMxODMsMjkgQEAgc3Rh
dGljIGludCBpZGVtcG90ZW50X2luaXRfbW9kdWxlKHN0cnVjdCBmaWxlICpmLCBjb25zdCBjaGFy
IF9fdXNlciAqIHVhcmdzLCBpbnQKIAlpZiAoIWYgfHwgIShmLT5mX21vZGUgJiBGTU9ERV9SRUFE
KSkKIAkJcmV0dXJuIC1FQkFERjsKIAotCS8qIFNlZSBpZiBzb21lYm9keSBlbHNlIGlzIGRvaW5n
IHRoZSBvcGVyYXRpb24/ICovCi0JaWYgKGlkZW1wb3RlbnQoJmlkZW0sIGZpbGVfaW5vZGUoZikp
KSB7Ci0JCXdhaXRfZm9yX2NvbXBsZXRpb24oJmlkZW0uY29tcGxldGUpOwotCQlyZXR1cm4gaWRl
bS5yZXQ7CisJLyogQXJlIHdlIHRoZSB3aW5uZXJzIG9mIHRoZSByYWNlIGFuZCBnZXQgdG8gZG8g
dGhpcz8gKi8KKwlpZiAoIWlkZW1wb3RlbnQoJmlkZW0sIGZpbGVfaW5vZGUoZikpKSB7CisJCWlu
dCByZXQgPSBpbml0X21vZHVsZV9mcm9tX2ZpbGUoZiwgdWFyZ3MsIGZsYWdzKTsKKwkJcmV0dXJu
IGlkZW1wb3RlbnRfY29tcGxldGUoJmlkZW0sIHJldCk7CiAJfQogCi0JLyogT3RoZXJ3aXNlLCB3
ZSdsbCBkbyBpdCBhbmQgY29tcGxldGUgb3RoZXJzICovCi0JcmV0dXJuIGlkZW1wb3RlbnRfY29t
cGxldGUoJmlkZW0sCi0JCWluaXRfbW9kdWxlX2Zyb21fZmlsZShmLCB1YXJncywgZmxhZ3MpKTsK
KwkvKgorCSAqIFNvbWVib2R5IGVsc2Ugd29uIHRoZSByYWNlIGFuZCBpcyBsb2FkaW5nIHRoZSBt
b2R1bGUuCisJICoKKwkgKiBXZSBoYXZlIHRvIHdhaXQgZm9yIGl0IGZvcmV2ZXIsIHNpbmNlIG91
ciAnaWRlbScgaXMKKwkgKiBvbiB0aGUgc3RhY2sgYW5kIHRoZSBsaXN0IGVudHJ5IHN0YXlzIHRo
ZXJlIHVudGlsCisJICogY29tcGxldGVkIChidXQgd2UgY291bGQgZml4IGl0IHVuZGVyIHRoZSBp
ZGVtX2xvY2spCisJICoKKwkgKiBJdCdzIGFsc28gdW5jbGVhciB3aGF0IGEgcmVhbCB0aW1lb3V0
IG1pZ2h0IGJlLAorCSAqIGJ1dCB3ZSBjb3VsZCBtYXliZSBhdCBsZWFzdCBtYWtlIHRoaXMga2ls
bGFibGUKKwkgKiBhbmQgcmVtb3ZlIHRoZSBpZGVtIGVudHJ5IGluIHRoYXQgY2FzZT8KKwkgKi8K
Kwlmb3IgKDs7KSB7CisJCWludCByZXQgPSB3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVvdXQoJmlk
ZW0uY29tcGxldGUsIDEwKkhaKTsKKwkJaWYgKGxpa2VseSghcmV0KSkKKwkJCXJldHVybiBpZGVt
LnJldDsKKwkJcHJfd2Fybl9vbmNlKCJtb2R1bGUgJyVwRCcgdGFraW5nIGEgbG9uZyB0aW1lIHRv
IGxvYWQiLCBmKTsKKwl9CiB9CiAKIFNZU0NBTExfREVGSU5FMyhmaW5pdF9tb2R1bGUsIGludCwg
ZmQsIGNvbnN0IGNoYXIgX191c2VyICosIHVhcmdzLCBpbnQsIGZsYWdzKQo=
--00000000000036ccf0061f2f2a1e--
