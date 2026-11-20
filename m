Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795215726;
	b=JLV4HeLFal7u3tFsB3hM8jxHPDYMpOcTj2B1EYHfbepqQzjPIl51ov0Cm3iEyfrS+qpI
	 vFw9Ikoc5yIy5Jh1IqDZp7S/LlOWWH26L5mtviopJa8En+N1U1lhMbajdCbP81yzu1pwe
	 DHW36mACfJUnJlOUkQhJpu36Qt+toDdtwl0e28bRqp7PTl17LCQRpScFnDl+Qfh4Xwyv6
	 NeloxYfozR+0EcwtWGjnP9PqPJ4d1D+p7ioH0LvCjA3tTtr6lYXxlL67yXhQYHgOboF9P
	 XO5sshn0T48z5aJ9/O89sSifubp+dDHFNFJU2Ts9M8blELQyQXqZieTXhv2MxYvmsWA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795215726;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=sB5iWeLIdXSk/z2yiFdp6RKCyaPz4LeSJqW6ibv5E1o=;
	b=NIm/+eNjqg03/7PAk4nHiZCPevWYxAdAqO4jvVUAzd/TkBipRWoviQ8/blkSOPL1GXeh
	 +fR7H/RuuOllJDHOdSI+TWeIbesIAFNxcrcyWPcCmo/VptO+rYpxZn1cIaIx6M6uZc695
	 waI0sTNoKxYxgfnXjOjQqBmvLOQOwB2R07LH3LmAplhdl7lkIuBpxSsqU8zmoVS2BRkXH
	 uXDWZRYLS4nhlLT114QJX6bTuSzdUky21AC5mblOdtiJ32WNfPoFArOcJjvZuh1yNFsK7
	 /Fc17FGopLGds1ews/AuOVtMAM9HIKBlrWsrzbHu4QQ708L3RVPg6BQkRdPDmXD7JHg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PDHhYohU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E40606A6A4
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 23:02:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00E40606A6A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PDHhYohU
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be53e5fce1so1191171e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 15:02:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795215723; cv=none;
        d=google.com; s=arc-20260327;
        b=Fn+Myeqz9CLL1HBckuPiomXF0upoDClHt08R2cvwFBMPnPrNTJIZ1F3lqtkQcvIO1Q
         73LEmTO9T1gA/RB/GJ9aVxLIb2rM/0ATyjieUOD8bk2/xMlVZFFva4eDOeAAuS+mgVK7
         D/xQSN4BVEMYhVRUR+KkiBNjlVKc1hzqvsc0AX+sODiJQIAfdfOTEun8uQwKipfXL9UP
         j6mdmDaKEci5/ZMueQytmiNn/BTtvLXDih0UouaUFukT3lB52a1IoMSlq8Rv9cWx+bsH
         SAq+cftALrN01QXTLYNJvi6o/GRPiE40O9LWOStf52NwkdyBZmAem1qgOGSGoY0G3Con
         e7Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sB5iWeLIdXSk/z2yiFdp6RKCyaPz4LeSJqW6ibv5E1o=;
        fh=dm7qgCOuaasg5icoLTqD4pp/08v8WpU1aSUU+2nVcdk=;
        b=r75G0hf7CIAj2uiZFhzaOESabVUxuB7k/2lfu9sqGqDJDZ/8Fgf9kBUqU2aNnZ2cLF
         ZQJYSGFfyY26NVoHggDxXvcPqH1gvQOii0r+kdfcrivuDW9EfsbEvTSoyJ2aEJlwZZfF
         F7b/GVQSa/NSLINT1nio1XPyc3bUreyd2Pnrqi28lpLOMvO8GBi+zNy0/ADAOEezxnn5
         BgO9fsYNoT6uXS57/rajNFC8u5oJ1ptj0x/2dgCf/KF/DSE+LXrZ1Xqg82keAhYgyeVP
         mbLTWA9LGXEQ7DXSyBbweNdVxtRqGrh1MpOih+H2macdq0E4BJxj6i0Tn43KwhhFChZG
         1qGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795215723; x=1795820523; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sB5iWeLIdXSk/z2yiFdp6RKCyaPz4LeSJqW6ibv5E1o=;
        b=PDHhYohUmZZS+wBX0o8ymsSGC1EY+NXbavNEk6S3+r9zE6NVnZsD2KyqT1bzkPqg68
         pg6PdsdGVsYrg2Ni87JZTksy4Qt6ICd+DcI/mfWmjM8pyMqNPeo689NFVrzL5w56lDuk
         ikw2UkL5Mh06+thVf3sQ6l9rvfPmTNAfbOZwrKiDpMofbQyltN3SR+uVImwywLrCHcPh
         PHG5/mJYCdFUBIbq4FRW0oPM+sJlTcupS0Xq780+IWh6MI5gr8mndOVbIjBvkqbkCgby
         oufmbhXXXTHevdAWpvfXlDckrWCVqLiCcgDP3WUe+/nvfyTXIYnR1iY1Z3Ik0rG5zxOb
         GQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795215723; x=1795820523;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sB5iWeLIdXSk/z2yiFdp6RKCyaPz4LeSJqW6ibv5E1o=;
        b=DGd/RKspS1mUq06INWrEGaEDfE0SdZ71vEnBhfMRPUBWQBvp0d2AQkVF+EszKdK8QF
         30rJLaJgluRG7/eJvB7SnaLX/h6CoMsHT4rADOs4us6OcYpNNaZn/rOO5F14y/oWbLYy
         hoOFNQ9W1+3JdePUsGD/CB1mPg0Uz+2AVQUFNIgZXokeQCDvi/nFtJgvWk7FKToALHSi
         nMhddwRnz3x8c5UzPq3BMe0Wdqb4T/f6tN24dbn0upjonbFMqjxI3GYu9rKN6hv1w1JH
         dmUn0/FrgNrKLnvyljCD8ypp3rlr5cuLWfNQU+kcoEGwQliKqMxNOuw007Gqsuk5t+Ij
         siiQ==
X-Forwarded-Encrypted: i=1; AL+hErGVDrgjomhd7GaSc/Aha1z4GppPj8LAY/JuDWBJKQAZGf9otywHnrcpxFRrvk8CO4+4OLrbtAG0b3Wzbj8=@vger.kernel.org
X-Gm-Message-State: APuU4Z90puPoRmmRWU7DV5mxNuEyxfkjehl0rap/VTr7J+LsZO8H88El
	XJuaJhluWNUWoJqOx4dQC2G8oQYQMry/fC3IrF4+zqNUE4DN7aY2YJaQOO+Ll54B7rmUKNUvjm5
	MVt/vyHxcoCxp36AK1jQMG6KRFRiLmFVuVZxnJRo=
X-Gm-Gg: AZFdTZeTcd10hpYsygMAulVKywaTH9H415cJefBZSNcLfbJ906dpu9d9bZ83ZLnBW5N
	YkmU8l+ihVAG1iWlMTneeZJ0PzVX0zAznijnwEXLvZxwzRJYpZCMsfO7vNzBPcNtBTj8EXoFg5G
	zNlwlX/pGj8Ispr81NAZ1GGetqw9/w1kFRsTvp0belX30uurrM3dtSY331YcW0p4E6/pGRlIhyN
	gNr4I2ll0D4Kk+20EMrJ6REIvcfXWAJmSpekvVcA9XtMw3UX0cvg0xWtrkKbvKcCaR2j1reJI1T
	7gn4OCh1ysTerHrVq77j/z+5qEJtLhUEU5k4fR5rWhJrqN/YoY8VFMdDRZKp3KI5eUOK4vaxgeT
	IDALDelQuQfnp09fS3xQs+tfKkm5lkAKwb//1
X-Received: by 2002:a05:6512:39c4:b0:5c1:4f00:7b77 with SMTP id
 2adb3069b0e04-5c1bc6804cemr1456732e87.1.1795215722461; Fri, 20 Nov 2026
 15:02:02 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-6-kanchanapsridhar2026@gmail.com> <CAKEwX=P7To+AV9X3cXLCcuw5yoigdB8w5Ns9c9mDxJf+u5k8xA@mail.gmail.com>
In-Reply-To: <CAKEwX=P7To+AV9X3cXLCcuw5yoigdB8w5Ns9c9mDxJf+u5k8xA@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 15:01:50 -0800
X-Gm-Features: Aa3M54reRvLfoPZ5kvwPE0ioyJYfTZ8WSgE2duE6U9TLy4oHWqSA0alj0n9Xqgc
Message-ID: <CACpmpodffHWFu_Zfzx8tb3ghO_PJAMu1+LyaRXtmwK5a5GmzSw@mail.gmail.com>
Subject: Re: [PATCH v4 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 2:46=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > When storing a folio in zswap, save the folio's node id in the zswap
> > entry instead of relying on the zswap_entry being allocated on the same
> > node. This enables optimizations such as batch allocation of zswap
> > entries for large folios using kmem_cache_alloc_bulk() that does not
> > support specifying a node id.
> >
> > Accordingly, replace the SLUB allocation in zswap_entry_cache_alloc() t=
o
> > be node-agnostic.
> >
> > The size of the zswap_entry remains unchanged as 'referenced' is lumped
> > in with the 'length' (as it doesn't need a full unsigned int anyway).
> > A build time assertion checks for the zswap_entry's 'length' bitfield
> > being large enough to represent PAGE_SIZE, which can be 256KB on some
> > architectures.
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> LGTM for the most part:
>
> Acked-by: Nhat Pham <nphamcs@gmail.com>

Many thanks, Nhat :) !!

>
> > ---
> > + * nid - NUMA node id of the page for which this is the zswap entry.
>
> Maybe "NUMA node id of the original page of this zswap entry"?

Sure. Will make this change in my next rev/patchlet.

>
> >   * handle - zsmalloc allocation handle that stores the compressed page=
 data
> >   * objcg - the obj_cgroup that the compressed memory is charged to
> >   * lru - handle to the pool's lru used to evict pages.
> >   */
> >  struct zswap_entry {
> >         swp_entry_t swpentry;
> > -       unsigned int length;
> > -       bool referenced;
> > -       u8 pool_idx;
> > +       struct {
> > +               unsigned int length:ZSWAP_MAX_COMPR_LENGTH_SHIFT;
>
> I could have sworn we agreed to just inline this macro.

True, however, per Yosry's earlier suggestion, I added a build time
assertion for whether ZSWAP_MAX_COMPR_LENGTH_SHIFT has enough bits to
represent the architecture's PAGE_SIZE, and could not determine a
sizeof/other API that returns a bitfield's size in bits. Hence I
resorted to the macro.

>
> (btw how many bits do we still have here? )

We now have 4 bits after "referenced":

struct zswap_entry {
        swp_entry_t                swpentry;             /*     0     8 */
        struct {
                unsigned int       length:19;            /*     8: 0  4 */

                /* Bitfield combined with next fields */

                bool               referenced:1;         /*    10: 3  1 */

                /* XXX 4 bits hole, try to pack */

                u8                 pool_idx;             /*    11     1 */
        };                                               /*     8     4 */
        int                        nid;                  /*    12     4 */
        struct zs_handle           handle;               /*    16     8 */
        struct obj_cgroup *        objcg;                /*    24     8 */
        struct list_head           lru;                  /*    32    16 */

        /* size: 48, cachelines: 1, members: 6 */
        /* last cacheline: 48 bytes */
};
