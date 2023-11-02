Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B43C4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Nov 2023 15:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjKBPgY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Nov 2023 11:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjKBPgX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2023 11:36:23 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2018913D;
        Thu,  2 Nov 2023 08:36:21 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-32d895584f1so590607f8f.1;
        Thu, 02 Nov 2023 08:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698939379; x=1699544179; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMOgTTQfwkBYFLdv7N61GXnKXP7EQxg4GSCDuZfxSVE=;
        b=ablWAJNkQQWGVKn+b9pesKMaI+ip0/gUGr5aSysYd4CdbcP4R04p1DemSukWlf9JSV
         ifPq+hdkX7stZ1vVxbAmXU4+d25nt3CUcYEZsIbsQSstmtotzQ7aj0K0UVHiuaSyhZcg
         kF8SrnU1KnURlTOdQZMWNZRJIlIzeJix/KOuO0FIxA8gcSuTLqkMBUcM6HlnyQhfzayr
         tSs8l/Ddby2STqHO7B/psBqdHihpSSsGqg12uiwcoeOaPp1ZXThgBSjxa7Te39AcA63y
         Ziv3Jfo1fBL56O57LenZRxgOGwfGq93MA85EV18xS+VOxiocChzN4oSOg60IPoBdJ/5I
         qLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698939379; x=1699544179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rMOgTTQfwkBYFLdv7N61GXnKXP7EQxg4GSCDuZfxSVE=;
        b=HhPfPO8PoTfKf0VE15X5Yn026HCeE/TVtQ66KZaOytfJZsRNxcK3qug2zzAyZSwBJr
         wEA7QVR/FrYfKAFv9pecTf6OjKFfpZIM3piNZH2BlsuZo1UQbX2A6h7DsamYckWfY8Pa
         wS2dKnAl6mehF0kVKdZ66AFTq+oJCH3Re3EE2MMb4kt1V3EHT7wqReFHnS8lFhlVUED1
         zDUPvi0JK4doFEmAIEGCjId/3skODcz3TqAeRNwIC8rm4FA6nbXAku/vOlgUzqgaTO4l
         PzSUZCDpiTsRg7aTNdMPGzCdVaSoxLyyZH8Ar93iiZ6QLoHBjCk9ecDEpdvuGMsnAPOW
         UhUg==
X-Gm-Message-State: AOJu0YzJL9ZSUTmZGK4EG4NU2UyC640vjlWHPfBUJ3qPKcr0BZKu4aYT
        /BJsZgTJbUYxX5S4PDHgPuAb1NsdV8oHKdyvDGE=
X-Google-Smtp-Source: AGHT+IGtErLNE5/niYv6UuFqjxP/VaBMOcBOA3J+nOQd1xQlkmfPqC0fXne7mIfUuUFrUfZQSx+rtAb5Tt2ImrEHILw=
X-Received: by 2002:adf:d1cb:0:b0:32f:8966:c39c with SMTP id
 b11-20020adfd1cb000000b0032f8966c39cmr9632234wrd.71.1698939379259; Thu, 02
 Nov 2023 08:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20231031134900.1432945-1-vadfed@meta.com> <dac97b74-5ff1-172b-9cd5-4cdcf07386ec@linux.dev>
 <91a6d5a7-7b18-48a2-9a74-7c00509467f8@linux.dev> <6947046d-27e3-90ee-3419-0b480af0abb0@linux.dev>
 <4258aabd-5f7b-4b7f-ab43-408b69bfdc58@linux.dev>
In-Reply-To: <4258aabd-5f7b-4b7f-ab43-408b69bfdc58@linux.dev>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 2 Nov 2023 08:36:06 -0700
Message-ID: <CAADnVQ+9pp33zv9DxouEmg24o7w27OKFUcvKChHuby_+d6-bLg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/2] bpf: add skcipher API support to TC/XDP programs
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Vadim Fedorenko <vadfed@meta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 2, 2023 at 6:44=E2=80=AFAM Vadim Fedorenko
<vadim.fedorenko@linux.dev> wrote:
>
> On 01/11/2023 23:41, Martin KaFai Lau wrote:
> > On 11/1/23 3:50=E2=80=AFPM, Vadim Fedorenko wrote:
> >>>> +static void *__bpf_dynptr_data_ptr(const struct bpf_dynptr_kern *pt=
r)
> >>>> +{
> >>>> +    enum bpf_dynptr_type type;
> >>>> +
> >>>> +    if (!ptr->data)
> >>>> +        return NULL;
> >>>> +
> >>>> +    type =3D bpf_dynptr_get_type(ptr);
> >>>> +
> >>>> +    switch (type) {
> >>>> +    case BPF_DYNPTR_TYPE_LOCAL:
> >>>> +    case BPF_DYNPTR_TYPE_RINGBUF:
> >>>> +        return ptr->data + ptr->offset;
> >>>> +    case BPF_DYNPTR_TYPE_SKB:
> >>>> +        return skb_pointer_if_linear(ptr->data, ptr->offset,
> >>>> __bpf_dynptr_size(ptr));
> >>>> +    case BPF_DYNPTR_TYPE_XDP:
> >>>> +    {
> >>>> +        void *xdp_ptr =3D bpf_xdp_pointer(ptr->data, ptr->offset,
> >>>> __bpf_dynptr_size(ptr));
> >>>
> >>> I suspect what it is doing here (for skb and xdp in particular) is
> >>> very similar to bpf_dynptr_slice. Please check if
> >>> bpf_dynptr_slice(ptr, 0, NULL, sz) will work.
> >>>
> >>
> >> Well, yes, it's simplified version of bpf_dynptr_slice. The problem is
> >> that bpf_dynptr_slice bpf_kfunc which cannot be used in another
> >> bpf_kfunc. Should I refactor the code to use it in both places? Like
> >
> > Sorry, scrolled too fast in my earlier reply :(
> >
> > I am not aware of this limitation. What error does it have?
> > The bpf_dynptr_slice_rdwr kfunc() is also calling the bpf_dynptr_slice(=
)
> > kfunc.
> >
> >> create __bpf_dynptr_slice() which will be internal part of bpf_kfunc?
>
> Apparently Song has a patch to expose these bpf_dynptr_slice* functions
> ton in-kernel users.
>
> https://lore.kernel.org/bpf/20231024235551.2769174-2-song@kernel.org/
>
> Should I wait for it to be merged before sending next version?

If you need something from another developer it's best to ask them
explicitly :)
In this case Song can respin with just that change that you need.
