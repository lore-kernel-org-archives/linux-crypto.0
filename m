Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793895796;
	b=Zrkc9SjgzDMKYNNN3TV9PimQ7T5ezYv+4/OvhCmQ6kGWLLSXfimGN3jIXC1eyBkxaxK7
	 rhdS35bNLbxqKdWgLeZssD16ePvAhO3ilU9t2O0rsHjWNhI12iOlsKHqMJcecjQ91YW85
	 JDYy90+0waZzaJOtwoNe1LUS352WI7kA1O5C7DIy1aih79TTq9VUnUXDz3huAS12ldHNO
	 5g79Em79D4Wm3uxql4rkvrF9chXtgUrNdOPaq5bBqUhE/VS5+pkvvedFrbCTapVwGgTSC
	 zz3PByNdyZ5tYtbJRko8LxOXs4EBNbxmRpFiWnpNdaCtoqjVxLShEw/Wy+2za2uusQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793895796;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=coQkw57ZP+vtxGOFNXxyJOYi0uTeh1KAeZgHd3m+lMA=;
	b=Z5/HYwhRBFT/r2+AdysmgmOytfvYZSCoBEsANgTn5SmMlsD9+I3fG8EFLUYdLWrRzs0j
	 ZS/CwaiF2IwlPgrRKIXIaOlOVPYlasPNQfaryx2Vky2vi1rOLerw63H3Bj8XMTd9O+7Jm
	 6CvrlZBJsT6bOmCJe7acWdnB1cWwknvybZwX91xSfPIMgYL45rulNt+msEmBPKkwi1YA4
	 RJzNLPDPYU/GAunLeziKyu4s55yvzCG+hx0a9CRse38UvzE47PyTw1Pnts7r1LFwZt/6I
	 /GqTQ8BzHFDd6B1ogp8XeXYVTRlJhx+l2rtW16Nb49NRTCtdhWPBEPyve5YUe6i/LSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=dCSWwY2Z;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3145606A31B
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 16:23:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3145606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=dCSWwY2Z
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso331128366b.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 08:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793895794; x=1794500594; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=coQkw57ZP+vtxGOFNXxyJOYi0uTeh1KAeZgHd3m+lMA=;
        b=dCSWwY2Z7CEdc0ulpW4sA71lEqAwrVtHVCmRDBVMBwET12eI/TFyp3PX5vcfeLvsn8
         cSSW1f1pQ/4Wg8Hb55u9sxZidqXHgEL1BtVjiX2zY3UFjz/CoTwmTTRPp6CWJRvT+D1o
         MqIIMz/helmFcjp5eAN4v0lu039zLyUpPvYes=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793895794; x=1794500594;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=coQkw57ZP+vtxGOFNXxyJOYi0uTeh1KAeZgHd3m+lMA=;
        b=lKlR0XFsnA+FiuMLFHFZe3+b2VAV9t4UXLhzST4ONxgVr1CBFep4nBIy0XdPh8hvou
         3KqRPwl6bZiA7lOAN6sCXFUuaW12wbGT/zIlFhsYlZWXZfMSWig/Stzk+gFd5/jQCDXe
         YMoVNgx9172SLvjVXhAe5+b8vZ4izy88KJpYE+tJ7eI9Hc01TyJbXl/UyPmrtnBZrZrD
         r++lCipoNf/UDxVDunfD+nOrwNjwj0P4EtKYsqSl2ItlYPq4dDK8D3XcgsNW6LWmCc9i
         QgY0A4H7WgXBBR5VUATDAE1e46MaDNE6UEEWW8Srjf10AwnX+cUcQYdwJlD4zElneJiZ
         gL9w==
X-Forwarded-Encrypted: i=1; AKwUvBzFZ1ZZ7MoDRfDAr5VQkrhDwtkVDahVHhUv5UtSJ8C8VrJRYBYCL9lB+6bUb0UYe8LuAJb9OaPglIFHA54=@vger.kernel.org
X-Gm-Message-State: APuU4Z/63wtR1CtaHUZACqtxFEdlW62d3J2agJ8vk3Y0jSUewreU/RvQ
	vLWOmhPuTwb2/TNz5jQGeJShn5g30XUj1YPZzUx3iNWpMuR0yLOA8I0f59dYh0mIEcHV5nZ8elU
	VyQQk4lk=
X-Gm-Gg: AYBFou3eikU/y/P6ZpB82lS4IqmloSzcGpQXZ3MMDR5PsO+mS7K4sTmJL1UCTwRc9XK
	215dQZQDetZFCFv4QpVnD9xnx7oCPjGAM7r9yCI3JSmYUDAx7HjYiVeRi/W0WrwJhnNKps9Pe+n
	4AqOz5kT+iCcxORkarlGpSSVMU5Ke5ZKxAeqSx7RNKzFJjFbFK5jVi6E/6ApqkukVopV/GR5+fd
	B1OaL8S8uFwltF/dz+AkkluLvZOhMIlbEvjf9vlWp/CANpV6uB/sMETVRRf5vSuwP34dekdc+Y/
	t/SUQRo2GXSGgO9q1k8P0FaMHeVV5R9uIVQDAH9iWvoHq+Om/j8Uq/YSqtdKPA9qY4l2GhWhzv3
	f747tZ7EfPEv1Vpx1y9AHO+j0MuHQSbQ8ssXcwjpHXJwmAwBxTmDedfDTloWbPz7VL5OXmgPVFJ
	C6GE+e2JJtZDo6KAB+dsCKXu5lvECTywiCa33FE+dk085I7+903CqhwwytZsaePnoSK2L/mBcgj
	O0JRIFFPDP7YA9h2Ayj/DfUhYb77ePitBHntiFPljta6BCIdpTBHArHK9XKvR1jywTdDxK1W/N8
	g5Rr3IB335JI3I0u33oEUMT6VaraP8ToqvJaYh14YCZ8fkrG/Sv2c+ji9WPITTOqZsvnZExJt1+
	ZUw==
X-Received: by 2002:a17:907:7fa5:b0:c3e:ee86:d2c with SMTP id a640c23a62f3a-c4ca7a66b26mr1789074266b.27.1793895793979;
        Thu, 05 Nov 2026 08:23:13 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e468326sm181210466b.55.2026.11.05.08.23.08
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 08:23:10 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b56bbf8330so2392179a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 08:23:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBz2rFWY5OZp8waEtZu/nUXmC6Ug8r75kx8u958f6tdordmXSVT+OYQPV9g7DfcBao/tFKHt14E8Qv9D2YI=@vger.kernel.org
X-Received: by 2002:a05:6402:3899:b0:6b5:76b9:5040 with SMTP id
 4fb4d7f45d1cf-6b576b95165mr2666079a12.41.1793895788549; Thu, 05 Nov 2026
 08:23:08 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au> <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au> <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au> <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au> <ausS3LQNkdc6lBy3@milan> <auxDm_YO4oACA_d2@gondor.apana.org.au>
In-Reply-To: <auxDm_YO4oACA_d2@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Nov 2026 08:22:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
X-Gm-Features: AclHuK_lYzOySVnPMTXkh-HXGHC850mf9gNJxZLEPPhkqoVD1gRX0QozBFysw7g
Message-ID: <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett (Google)" <liam@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Mason <mason@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Nov 2026 at 00:51, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Nov 04, 2026 at 12:11:24PM +0100, Uladzislau Rezki wrote:
> >
> > There are users in kernel. For example:
>
> Thanks for the list.
>
> > drivers/GPU
> >     /* Allocate the file in vmalloc memory, it's likely to be big */
> >     iter.start = __vmalloc(file_size, GFP_NOWAIT);
> >
> > AMD-GPU:
> >     kvzalloc(size, GFP_NOWAIT);
> >     kvzalloc_objs(struct amdgpu_coredump_ring, GFP_NOWAIT);
> >     kvzalloc(ring->ring_size, GFP_NOWAIT);
>
> These appear to be executing out of process context without spin
> locks so they're not really GFP_ATOMIC.

Historically, GFP_ATOMIC and GFP_NOWAIT have been largely the same
except for GFP_ATOMIC eating into reserves.

But I wonder if we might be able to soften that a bit, or add a new
form, because it looks like the AMD-GPU case at least doesn't really
care about any kind of "don't sleep", what it really just wants is an
"optimistic allocation" - try to get the memory, but don't spend
effort on freeing things if there is not enough memort.

The AMD code in question literally has a comment that says

        /* Dump ring content if memory allocation succeeds. */

so while it's possible that it has some atomicity requirements, it
doesn't look that way to me from a very quick look.

The etnaviv case looks to be the exact same thing: it is definitely
called in normal process context (that code takes a mutex lock around
it all).

So those two cases really don't looke like they are about "atomicity" at all.

> > net/ipv4/udp.c:
> >     err = bpf_iter_udp_realloc_batch(iter, batch_sks, GFP_NOWAIT);
>
> This looks buggy in exactly the same way as rhashtable.  It's
> called under spin_lock_bh, and the same lock can be taken on
> the softirq path on another CPU.

Yeah, that case is definitely actually atomic and holds a lock. Not great.

Is there any way to limit the vmalloc() case to the actuall atomic one
and just fail when it needs to busy-wait?

               Linus
