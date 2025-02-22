Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8292063E1;
	Sat, 22 Feb 2025 08:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740212474; cv=none; b=UCmYQetNW3hEP7gm1pNRFFr3mssnofzQDr5jKiIgcTr2jYYvhyt36xnomcViWAoK1keS+Q2ppnnnRSgD82DQpva70bXSOWBHHwsBNApVneLtVc5pFXkw+cKii6OUDzc5H+vOHb4Eg8dyAfQSe+mTCzkQdXpFcOotFKCpT+7+3B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740212474; c=relaxed/simple;
	bh=i8sFigVNpoATwzGpIUbYEoSBg++aDeFWDFcRfzG9LJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tmtd/U5JYKwonu76IkKNhjKt9vj09PLzeg78mUWkydFz1o9O06AZfqglfD2oHVnH7CWDIgB3mWgF9yfHHxMDovEgia5n3a8UWglAcPlUrcqQrNDACPMWZ/dBMje4NxDE4o3XYSzutuEe9aFU9q9zuQCYKGX1omRZwOSZ3WmljtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D3K6JGsc; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D3K6JGsc"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-51eb1a6954cso871199e0c.0;
        Sat, 22 Feb 2025 00:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740212472; x=1740817272; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ntDMtF4qlnsHXsmqaD/7fEEwXAAro8btJn/h1wgDsWA=;
        b=D3K6JGscjmdaNgZsA5N/0s4EZ26FiLKPkDgj28a93yq+FdUq5jyrjI8K44T5cH+BY6
         sNU2FStqJHvaajenyasqyCfojr9UyW6AitPornk6RfTfASUCRaO2+ROS5sBZ/fPgvBFp
         3c6GI8zYtX1WMLyrTfWRVn+xS2UvuRwkUYEY4ii+07uzsJdkoFv3h3/OSVurOduROOZx
         g9UstQvP6TV7W+vROIihPMbl3XDNz0W4aJowyH95A+K3smJWl9EvU1uzS1oIaWwrXItm
         ZlKcy558bWAOp6ubcldpZg822HjMEVMSfVLwbpD9Za9Ib7eiYu/TkCB9fs8kR7xSpXy4
         x41Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740212472; x=1740817272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ntDMtF4qlnsHXsmqaD/7fEEwXAAro8btJn/h1wgDsWA=;
        b=PQKc40EbklvqQH5D6PW1yZVFRBlBCpp716PBk6S2xKEfLhK8QKGq8GMSIGNbYU3Bgg
         d//TeL6SwJjv+ZJt6emYfLdMaoy8TZGPwoMpbOiG9/NY2CUjVwUIumdD0lRlzjgHPMIh
         pZUtTDX9PDZBsWscjb0dgUdZdWOcqsQav2ZGi7BioKmYEjwblHoxB3BTzFx+8n556xqv
         J7ZLcgBxvYOEdHq0FGX/Z9QXUKDQivMkQsUvHE9uQodzY8APwOJpGgB+WBJKMd8Gj4gj
         gXMX62mQnAmYSL70ScU4LrQK9N++HxXJarchi/5bV5RII27wfkpSyfnKZGvgrO87u8dz
         1x6w==
X-Forwarded-Encrypted: i=1; AJvYcCU5tRK7s4cCN7EjY/kRJzU2ScC6ySNiEn7zA8Tw+goC5n6tB23e3+R2dTI409wB9BviHijwy5OmMaoyee4=@vger.kernel.org, AJvYcCUzCTBWSsL7gfh1DSzLg5xDBG1eWhPMWvkTmgWoRxbilEaAf69MzVu+Rs1yGMQkyo2fNVJ90ZBRlgkPlvRx@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgo6Tvs0Zf7Tawb3fEJSj+OQrNrzyazRr8L3E1t73vzPQw7lAG
	O8ZCDsenXqaQ5qeoNLGUs0Bt3k1ZuDc4zifdWxpWIm7rjpGFQElqQG4hdTouoeAhvvKW7JpNfNs
	aLr6C8S5LeQp+/OJlr1pPiMNz9lU=
X-Gm-Gg: ASbGnct393qfJxK4fZ1oy0Ey9aA2K9Ou4Qnm7A1JNCtpn/1JtNbz/ZJgN3PFNrMawBZ
	71lPcf+1wi5r9wjLU88dLkTUWFnML2xLFneM+dR5susSyLKolWgh8Id6Eriyd6itdydkZZCdoYg
	WCg/Pw2B4=
X-Google-Smtp-Source: AGHT+IFnU20HDFKWbdBeMRvALf42OfeXVyqWBhllkOtaj5DXEVuO1kj8+0ZgU6zEkoQp9dKCHi4KldhDr37GVdT1TzI=
X-Received: by 2002:a05:6122:1d55:b0:520:6773:e5ca with SMTP id
 71dfb90a1353d-521ee42f3c9mr3750843e0c.6.1740212472038; Sat, 22 Feb 2025
 00:21:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au> <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au> <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <Z7lv6JLax4S8vTtD@gondor.apana.org.au> <CAGsJ_4yAQxjTnSALZHAJZDdUnXKAYFvQCcjQjHiQSUip6cJGKg@mail.gmail.com>
 <Z7l0Hf-CFFjeKaZY@gondor.apana.org.au> <CAGsJ_4zFdHUPELSYDkrN4ie2c73L6e=FEdQbDL3JckS4unKFpg@mail.gmail.com>
 <Z7l7SF6a8F-pKWdi@gondor.apana.org.au>
In-Reply-To: <Z7l7SF6a8F-pKWdi@gondor.apana.org.au>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 22 Feb 2025 21:21:00 +1300
X-Gm-Features: AWEUYZnvD7tVU43TzzmfD0LP6gJCzSJnHAZvx6v8dXhBzUxBUHngxlVnDbI9AGg
Message-ID: <CAGsJ_4yAX8QbCBe+zfNj1i8USZGLXOomB7pFzm5F_+aQ=ukyAQ@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, 
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 22, 2025 at 8:23=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Sat, Feb 22, 2025 at 08:13:13PM +1300, Barry Song wrote:
> >
> > Somehow, I find your comment reasonable. Another point I want
> > to mention is the semantic difference. For example, in a system
> > with only one algorithm, a dst_buf overflow still means a successful
> > swap-out. However, other errors actually indicate an I/O failure.
> > In such cases, vmscan.c will log the relevant error in pageout() to
> > notify the user.
>
> I'm talking specifically about the error from the Crypto API,
> not any other error.  So if you werer using some sort of an
> offload device to do the compression, that could indeed fail
> due to an IO error (perhaps the PCI bus is on fire :)
>
> But because that's reported through the Crypto API, it should
> not be treated any differently than an incompressible page,
> except for reporting purposes.

I'm referring more to the mm subsystem :-)

Let me provide a concrete example. Below is a small program that will
swap out 16MB of memory to zRAM:

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#define MB (1024 * 1024)
#define SIZE (16 * MB)

int main() {
    void *addr =3D mmap(NULL, SIZE, PROT_READ | PROT_WRITE, MAP_ANON |
MAP_PRIVATE, -1, 0);
    if (addr =3D=3D MAP_FAILED) {
        perror("mmap failed");
        return 1;
    }

    for (size_t i =3D 0; i < SIZE / sizeof(int); i++) {
        ((int*)addr)[i] =3D rand();
    }

    if (madvise(addr, SIZE, MADV_PAGEOUT) !=3D 0) {
        perror("madvise failed");
        return 1;
    }

    while (1);

    return 0;
}

For errors other than dst_buf overflow, we receive:

/ # ./a.out &
/ # free
               total        used        free      shared  buff/cache   avai=
lable
Mem:          341228       77036      251872           0       20600      2=
64192
Swap:        2703356           0     2703356
[1]+  Done                       ./a.out

/ # cat /proc/vmstat | grep swp
pswpin 0
pswpout 0
...

No memory has been swapped out, the swap-out counter is zero, and
the swap file is not used at all.

If this is an incompressible page(I mean dst_buf overflow error), there is
no actual issue, and we get the following:

/ #
/ # free
               total        used        free      shared  buff/cache   avai=
lable
Mem:          341228       92948      236248           0       20372      2=
48280
Swap:        2703356       16384     2686972

/ # cat /proc/vmstat | grep swp
pswpin 0
pswpout 4096
...


>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>

Thanks
Barry
