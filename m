Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5189352016
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 19:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792177506; cv=pass; b=KZaCsmdT6z2qN61ECY/CYTrl2aN0F9cRaCNoi01L5XEXBGG7wqKSwI6v6zr5XVK1lUXhgJJQqna1dYCgaUCU3kho6HDnKP/xmuB1uyzrl0AcimcJQTyRb3sZ1C56WJZ2HnCsxyXwwZ0d6o79boA0/HTW6s/Y/ZXGlOCkYkja+sk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792177506; c=relaxed/simple;
	bh=M6p6HiXD6ueH0boimsmVmlWWlfyQBggD43Es1j4k350=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lVlV0kXWnF3J/Co9SS+3ZHeMC4fmZ/jE8yRbt+u7rdy2JPbXmwtK8tSJ7FMIVXci6NC5c/zHowZBi/dJTP2eelbJ0NRE2A8RSgp+Ii9Be+AuTVMfpbPfGK6ovjt0HHaA4gIkNVqnlPNdrPwnWf9ynfCUU78vndZv3/FSE86MT+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dElp7kYZ; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dElp7kYZ"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5bcb0f245e0so200167e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 12:05:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792177502; cv=none;
        d=google.com; s=arc-20260327;
        b=mdEvdYOGDvp06nsZJxzFl8gQViObP/K47bF5r29VoGNzvRpIsFYfMwAvUTrHLvwxF1
         QTf1LQ2LAzaq4P2DoclFAZgh43mU3dq+7I7ekrRTwUXRJCyUCVjrKe5pa2Yk87S2hWjd
         Xuv1bJ14hnJkr1BGln1YONK4Rka2B+Vijm/qdfBBxJHsdRFRpkY1o+lwUZuqNf/LsxGJ
         NmuLYgupbkWLYX6LzcMtFYDSZ/nmxRycgmEwwGtbEPwyacAj+7kJrx0JBXfb1Q542bYt
         Wqg4WdLVxNpoYrO/Js3ZG0tBovAbC3x6p1SA2rSu1by1wGgjr3kMAp1TsFnk8edFI3Tr
         jAUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eFr5a0FeYIfPj3OlM5ijOjEBoPrB3ZZlxk7SDs3PmPw=;
        fh=WMcqtlBVjbaFsw9J2Kfkl1VxRsQFolrohScMW8OP7TM=;
        b=mTpCHZMwkhUU+K8kzDBggk9iZliARFEjZRBuvlhIyhj/DBVMlbjtYIFwo0GCCuaJfz
         PfN1yTLaIPikpKYOXy1O/qrbnTNE/+6tfqBYhS7x/5grC+jq/+R7pxm99TvqwDRfyMT7
         sjcI0bGSVwCriAmLqS4LZSyYheyFTFepZ9TnauTgWVcpJQmSYnNRPsaVqBWgVlKLafeo
         N3jBvQXkKX6a/vBncr2MVD/0mchIMpq3snXcUGOwKYpgLTKU+6YS/843tzYrLwFykAWE
         ybaipZE70TsEKuWc52AGUJSQQhvilbnC/4bEIZvc6L42PXF1wv6ce9gYhgyDXxL1hbf1
         FXGg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792177502; x=1792782302; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eFr5a0FeYIfPj3OlM5ijOjEBoPrB3ZZlxk7SDs3PmPw=;
        b=dElp7kYZQoZBicmNW470HTN0awFsXpWFqPwpQwN8xRBUZkPfoj5EhFKRLmBXLCPdiC
         yG5y9QXK3EyaIS1vyMVAB2pxO+xyOQB1Rg9k+SvTBy9tG0lYvJ2ESQDgUR2wZOj5O82C
         w9XehSrA2201cUmPZtL1WCfpREsewxtszXiD+Qd8KLIexrEbQirjEiNdy+xrvDx4lZwH
         VkxVHfM6IimUG7YvgtEgo0jKlqh4iRq8k8xcKfAah7reYbElufYRDs7LkXqUytmghPVn
         KAJdtuTWltm60GO1KGG6vYuJ3PNWk1dwumYbNtkd6+plWYLuT3+wrvyutS8lBUaNJugk
         9zTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792177502; x=1792782302;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eFr5a0FeYIfPj3OlM5ijOjEBoPrB3ZZlxk7SDs3PmPw=;
        b=UXUmsctQt9tLQSkY6yn+TpoEdy+94+3d6t2Pa9+R3qoNAXH1nJWKltG/lBIfmzsP6B
         E2QzEmBOzwYb4Zx9N57h699UTo1IifjHCXvUhZxg68Zaivj8IGtrQYNoWMvoSarhrMxL
         i6u3jXD+Ufo5dC1BrxBl9ccfzww/ggt4bD7g7UVdET+EwcuJ85FxLdARD5mZYDO0/ZLB
         mNHo0WERFHSdtAQvgTT3ZPTdsicbilHuHWlNUUVF6WU3pjeYoT2HXbx/5Oxqe1GDL54D
         3BzYb01zs+WY4yos5aGzk7pTUBxqYal1pW0iFVgvLMfnoM8sSqkkMtQ4dIrNfCj9E3C6
         henw==
X-Forwarded-Encrypted: i=1; AKwUvBykcUvQZV1elKCYKzq/Ml2hcBRaEmOo+LDllpIoLfd/uzkB7tR4v1L56Fxt5vwecBrq/UIJOfAUFo0NfvE=@vger.kernel.org
X-Gm-Message-State: AFq9FYLS/uJOpvF0qehZXmfI7leilikdNfbskRVEAwi+1sSsDkgk4mDT
	ac4RvAq/wQcBLi8QRtfNBu0FrWB87m+kWnHYNS0UDlK/qiqoYnv/9BwpsVvDlGFSKVyHT8Yw1GV
	BFdas0pZqt9Iv6WNDsVwA51n0H1dMniE=
X-Gm-Gg: AYBFou0ucFSFvZ4tdy8LSrn0kMkAp/lDKo1bXXMDp07XPCLfSNsQyJWHz2Tg5N0tMpP
	KV7xadTd5IBfGfYd9x47d7/+hWr6AAo7Itq9Lk19YDoxldj7b5SLM3mlOLs9JTETIvx8mIhVEX5
	pQ+qA7ReO71Cjufm73L+fmPO3dhQBtV7B7xL7EVrkhB+NCbchO+kAF4CY8fyW8E9qT8HY5LK+z/
	WBqwlPAOZvnLpwNIXaI2YGS4RwCzX9RlFm8rBzXtLYe25pRfGtc5miUmjPjSPt3AjqMcFjVKi36
	QlQumJEga8XQp9yPVIe6DRTYwhr3izI5Tvw1iq0tmceQAG28eCWgC68=
X-Received: by 2002:a05:6512:3d1e:b0:5be:4d3f:bcb with SMTP id
 2adb3069b0e04-5be509f6406mr140553e87.6.1792177501725; Fri, 16 Oct 2026
 12:05:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com> <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com>
In-Reply-To: <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 16 Oct 2026 12:04:49 -0700
X-Gm-Features: AclHuK9MIvQEnJq535pIpXHoDNUv0NJGjcL6pnvPWj57xwMyrngG-QJeAgr-Nsw
Message-ID: <CACpmpofN-JfCgJtW9D0wNu0_pL1pRWGfNphUQnE9Bse-P5tHpQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2026 at 9:14=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 8, 2026 at 11:28=E2=80=AFAM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > v1: Batched zswap_store() with compression batching
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >
> > This series is a spin-off of "v14: zswap compression batching with opti=
mized
> > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zsw=
ap
> > compression batching enablers. Resuming work on this series following a=
 gap
> > since v14 (January 2026). Please note that my email address and affilia=
tion have
> > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail=
.com. I
> > have retained the original Intel sign-offs on prior patches for histori=
cal
> > attribution while signing off v1 of this series with my current address=
.
> >
> > To summarize the main contribution of this patch series: Batching is in=
troduced
> > in zswap_store() of large folios: we carve out a large folio into batch=
es of
> > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
> > batch. Moving the fundamental operations that need to be happen to stor=
e a page
> > to now work at the granularity of a batch offers opportunities to optim=
ize them
> > from these perspectives:
> >
> > 1) Utilize existing kernel API that minimize obtaining locks for bulk
> >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> >
> > 2) We keep the working set for each of the core store functionalities (=
alloc
> >    entries, compress pages, store pages in zsmalloc) to be focused on a
> >    batch, thereby minimizing cache evictions and benefiting from cache
> >    locality.
> >
> > 3) Along the lines of (1), the main zswap_compress() batching routine o=
btains
> >    the acomp_ctx mutex lock once per batch, and releases it after it ha=
s
> >    processed all pages in that batch.
> >
> > 4) Any zswap store functionality that works on a batch can potentially =
be
> >    parallelized as a next step, to further improve performance.
> >
> > Performance data: usemem with 60% over-commit:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Validation was done with mm-unstable as of 10-3-2026 (Baseline) and wit=
h this
> > patch series.
> >
> > Testing was done on a Chromebook with a QEMU "vng" VM running in Crosti=
ni.
> >
> > Chromebook Diagnostics reports:
> >   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
> >   RAM: 16GB
> >
> > vng setup:
> >          Memory: 7G
> >            Swap: 3G
> >     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
> >
> > zswap compressor:
> >   ZSTD
> >
> > mTHP enabled:
> >   64kB
> >
> > vm-scalability/usemem setup:
> >
> >   cgroup memory.high: 3G
> >   4 usemem processes, each allocates 1200M anonymous memory, reads the
> >   Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
> >   writes to each unsigned long in the 1200M, sleeps for 10 sec, then
> >   frees the memory and exits.
> >
> >     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M
>
> What is --read-silesia? Is this a local change you made to usemem?

Yes, this is a local change I made because I wanted to get compressed
lengths besides 565, which is the only compressed length of data
swapped out from the original usemem.

To replicate my setup:

1) Setup Silesia dataset to be read by usemem:

wget https://wanos.co/assets/silesia.tar
tar -xvf silesia.tar
# concatenate the 12 binary files into one
cat * >> /tmp/silesia.bin

2) Modifications to usemem:

usemem_orig.c is
https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree=
/usemem.c.

diff usemem.c usemem_orig.c:

75,76d74
< unsigned long silesia_bytes =3D 211938580UL;
< char *silesia_dataset;
103d100
< int opt_read_silesia =3D 0;
166d162
<       "    --read-silesia      write memory with data from
Silesia.tar to allocate the pages from Linux kernel after
malloc/mmap\n"
209d204
<       { "read-silesia", 0, NULL,   0 },
352,373d346
< static void fill_buffer_from_silesia(char *buf, size_t length, const
char *silesia_path)
< {
<     size_t bytes_read =3D 0;
<
<     int fd =3D open(silesia_path, O_RDONLY);
<     if (fd < 0) {
<         perror("Failed to open Silesia dataset");
<         return;
<     }
<
<     while (bytes_read < length) {
<         ssize_t res =3D read(fd, buf + bytes_read, length - bytes_read);
<         if (res <=3D 0) {
<             /* Loop back to beginning of silesia.bin if allocation
exceeds ~210MB */
<             lseek(fd, 0, SEEK_SET);
<             continue;
<         }
<         bytes_read +=3D res;
<     }
<     close(fd);
< }
<
613,623d585
< static inline void copy_silesia_to_buffer(char *from, char *to, size_t le=
ngth)
< {
<       size_t nr_bytes_copied =3D 0, remaining_bytes;
<
<       while (nr_bytes_copied < length) {
<               remaining_bytes =3D min(silesia_bytes, length - nr_bytes_co=
pied);
<               memcpy(to + nr_bytes_copied, from, remaining_bytes);
<               nr_bytes_copied +=3D remaining_bytes;
<       }
< }
<
638,642d599
<
<               if (opt_read_silesia) {
<                       copy_silesia_to_buffer(silesia_dataset, (char
*)p, (size_t)bytes);
<               }
<
1053,1054d1009
<                       } else if (strcmp(opts[opt_index].name,
"read-silesia") =3D=3D 0) {
<                               opt_read_silesia =3D 1;
1263,1268d1217
<       }
<
<
<       if (opt_read_silesia) {
<               silesia_dataset =3D (char *)allocate(silesia_bytes);
<               fill_buffer_from_silesia(silesia_dataset,
(size_t)silesia_bytes, "/tmp/silesia.bin");
