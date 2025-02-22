Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA7514F121;
	Sat, 22 Feb 2025 06:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740205617; cv=none; b=VDZf0hfMw1QjdIki4fFE2TzcFGPCPNFAvehKn3wokcgqhwPHBKxsc+6xsbg+gGLB+qyn0j0hjAJSEM2PNA6KgZG2H6KNx5V9rbtEb4SWwxf68Yj8O0+g5T3347YhQlglYDY1/ON/t/M5hXZB5d37kqKPu2d6UlSKA0UUjeO8F9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740205617; c=relaxed/simple;
	bh=0/PMQ44ArUjW1pQL8nCCDGhic0qruFDpL+w+vvy3i9Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V13kUi/UIK4hcML+aqMgHeggz+gQfoDWdhsfz9uC3eCAvTZYJiQBE/n5jmA6bz+4zmNUcKtim1OZbDJaapXJQevnashs/s8hYoNyqejnIMu4SZYDwRA6TQLYVba0d3WRNGszDCLWEFwAypRLARfIZag7Yr0SME4rzP6gldbFJnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sobj/Lkc; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sobj/Lkc"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-51eb1a6ca1bso813651e0c.1;
        Fri, 21 Feb 2025 22:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740205615; x=1740810415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NIxIIVcpfvb6nwbQ771pqe0Neuy4l9HiGOBXAcMPLnM=;
        b=Sobj/LkcxXoQcCg0VBGvQH4nt3V4pdEFV8Pq1HA5MJOzVCkAPh6BA6bzej31ibBJMk
         LZdp0OBwNOHkT1rg5gB+LtCCfRE8EnIEi5YXU/3jH5QmTg3FTPRa45cYl9COac2Ni/eK
         9SBfvgWJF/ORfK9l7xdf+TVecOSB+t+dW+zTMeb7/wdCFmxwmKXZGZ3X4zfhp5zLju6Y
         fO5VyKBPPbZ1TIybnbwK9vqoKoaQe/UTiO1jMb+LpgYPQALiHE3O2CUr2J7O6Y2y91qm
         EbF0mejBIw6nqah1vzCgsP/UxYbr29gvE6yS6EIcO/Q0i9y2gRe7mefyaNfQEmBUYcFi
         0iqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740205615; x=1740810415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NIxIIVcpfvb6nwbQ771pqe0Neuy4l9HiGOBXAcMPLnM=;
        b=LbXu3+iJGp+ywPITkTUeN/cJhSookO9e5a1pATx69nPL2EUD/cLCIZ94KdmcCp5Xsv
         nEjAcvBpoM2t+lVgjfF0kfA8JNWeGD/OT8MuQJF5kT8Nk/J647p5vzueT+gvX9r/TeWl
         dCwNqpVdff+dNRK7+wN5bzZ4O/QfKDrXmuYOQ23/+p/MZX7RHtMsccqvvq//r5GWlFLp
         Cin342mGrlzS4eLd+wV66riRkkG8NcEitNuQJ1akLAMj86Vb2eTtWIGKR2b6SIGrNqX9
         +y83y/4q93q216RJomM4wUEa5uVsUy6TeZGYNJ+EoEWpR7Xd53lCs9t9xKuaLZTLR3xF
         lt1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUKoDxXC9gjZGyuO0a+p9Mz+zlWyZUNkzF8F47xT4T5dUS4r+972STakb95+1W3CTUZx8rRI/Y/sx0OFHc=@vger.kernel.org, AJvYcCUzUj/aL0vc+6BeufhCGe0p1s7trPKk8lsbYU5ytbE0TAcEgXoQcAarl6Yvy8wveF6+0NplLH244UiMrgQr@vger.kernel.org
X-Gm-Message-State: AOJu0Yy30afEuLog440cCOeF3KHxwkhsdeOVuW3FBmllik4dGc38z7g9
	guwQtteGMk1KvfJxo8j+IZ9mN4DJJLQTj7/ECFsmLc99om5FKz0M52T9ZSmfpqiFAxaTix6UaW0
	GOQgx4s9U49MTxwALzKs51mCqOss=
X-Gm-Gg: ASbGnctUVZWbDcmNU3Ou5IrSDYZbrV7MSFDZuyFY/VZhNIuMg5juYoiwnZM54NtVk/4
	iaxIjoiVr0m0/T/ENjC7IQvkdHixjV0ewIJLFH+LLQF4Oljsuaaunjr8MzY/jHyBoIquKr4MfCq
	pvJblDbPI=
X-Google-Smtp-Source: AGHT+IFiNhtcooCa0ZW3nQsQHTxZpb7DfLS1OFCj95hUoPmsr8UVPIUuHPI06xjCqFe90Conqt/5KRQtLGcyd/ySGv0=
X-Received: by 2002:a05:6102:4b18:b0:4bb:e511:159a with SMTP id
 ada2fe7eead31-4bfc0165559mr4483805137.19.1740205614755; Fri, 21 Feb 2025
 22:26:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-3-kanchana.p.sridhar@intel.com> <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
 <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au> <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au> <Z7dnPh4tPxLO1UEo@google.com>
In-Reply-To: <Z7dnPh4tPxLO1UEo@google.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 22 Feb 2025 19:26:43 +1300
X-Gm-Features: AWEUYZm78GL56nmXnRGMHD647u-GEBbD8ZLbSFkwxwXcyG1aAaf7Q47e3px4V3Y
Message-ID: <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
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

On Fri, Feb 21, 2025 at 6:32=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Sun, Feb 16, 2025 at 01:17:59PM +0800, Herbert Xu wrote:
> > On Mon, Jan 06, 2025 at 07:10:53PM -0800, Yosry Ahmed wrote:
> > >
> > > The main problem is memory usage. Zswap needs a PAGE_SIZE*2-sized
> > > buffer for each request on each CPU. We preallocate these buffers to
> > > avoid trying to allocate this much memory in the reclaim path (i.e.
> > > potentially allocating two pages to reclaim one).
> >
> > Actually this PAGE_SIZE * 2 thing baffles me.  Why would you
> > allocate more memory than the input? The comment says that it's
> > because certain hardware accelerators will disregard the output
> > buffer length, but surely that's just a bug in the driver?
> >
> > Which driver does this? We should fix it or remove it if it's
> > writing output with no regard to the maximum length.
> >
> > You should only ever need PAGE_SIZE for the output buffer, if
> > the output exceeds that then just fail the compression.
>
> I agree this should be fixed if it can be. This was discussed before
> here:
> https://lore.kernel.org/lkml/CAGsJ_4wuTZcGurby9h4PU2DwFaiEKB4bxuycaeyz3bP=
w3jSX3A@mail.gmail.com/
>
> Barry is the one who brought up why we need PAGE_SIZE*2. Barry, could
> you please chime in here?

I'm not sure if any real hardware driver fails to return -ERRNO, but there =
could
be another reason why zRAM doesn't want -ERRNO from the previous code
comment:
"When we receive -ERRNO from the compression backend, there's nothing more
we can do":

int zcomp_compress(struct zcomp_strm *zstrm,
                const void *src, unsigned int *dst_len)
{
        /*
         * Our dst memory (zstrm->buffer) is always `2 * PAGE_SIZE' sized
         * because sometimes we can endup having a bigger compressed data
         * due to various reasons: for example compression algorithms tend
         * to add some padding to the compressed buffer. Speaking of paddin=
g,
         * comp algorithm `842' pads the compressed length to multiple of 8
         * and returns -ENOSP when the dst memory is not big enough, which
         * is not something that ZRAM wants to see. We can handle the
         * `compressed_size > PAGE_SIZE' case easily in ZRAM, but when we
         * receive -ERRNO from the compressing backend we can't help it
         * anymore. To make `842' happy we need to tell the exact size of
         * the dst buffer, zram_drv will take care of the fact that
         * compressed buffer is too big.
         */
        *dst_len =3D PAGE_SIZE * 2;

        return crypto_comp_compress(zstrm->tfm,
                        src, PAGE_SIZE,
                        zstrm->buffer, dst_len);
}

After reviewing the zRAM code, I don't see why zram_write_page() needs
to rely on
comp_len to call write_incompressible_page().

zram_write_page()
{
        ret =3D zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
                             mem, &comp_len);
        kunmap_local(mem);

        if (unlikely(ret)) {
                zcomp_stream_put(zstrm);
                pr_err("Compression failed! err=3D%d\n", ret);
                return ret;
        }

        if (comp_len >=3D huge_class_size) {
                zcomp_stream_put(zstrm);
                return write_incompressible_page(zram, page, index);
        }
}

I mean, why can't we make it as the below:

zram_write_page()
{
        ret =3D zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
                             mem, &comp_len);
        kunmap_local(mem);

        if (unlikely(ret && ret !=3D -ENOSP)) {
                zcomp_stream_put(zstrm);
                pr_err("Compression failed! err=3D%d\n", ret);
                return ret;
        }

        if (comp_len >=3D huge_class_size || ret) {
                zcomp_stream_put(zstrm);
                return write_incompressible_page(zram, page, index);
        }
}

As long as crypto drivers consistently return -ENOSP or a specific error
code for dst_buf overflow, we should be able to eliminate the
2*PAGE_SIZE buffer.

My point is:
1. All drivers must be capable of handling dst_buf overflow.
2. All drivers must return a consistent and dedicated error code for
dst_buf overflow.

+Minchan, Sergey,
Do you think we can implement this change in zRAM by using PAGE_SIZE instea=
d
of 2 * PAGE_SIZE?

>
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> >

Thanks
Barry
