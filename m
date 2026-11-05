Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793904275;
	b=jnHNx2O6qkzDx8NsOrIipnWxNLCX79j+mz85QE+aAz8jlJX6hKtbsMq9C9+CmpsG55vF
	 2QCSBdJmkKTblwf3+Ysof9iMUs03kXBJ0fuiq6OKBHGzflBuIF3jg8mvPC/7Q0zgXCfwm
	 8NHilCfXp6uMoPq2NgKUpA56axeIk9kygI5XKuT8aRQ4fu9IaXeYasW1LZQHr0oB3R2S7
	 4htopIyidCz3SMz8qRAUauNDeh3JQ4zqACfzSstzkWs1pVTTtoojm0rX7oQUiZqjcW4Gk
	 yV4ZCFrZrHF6XTHHUPad67VGwXppyeAYDfyJY2f1T4IDaaQbzpemIHYcstqTWnjMkvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793904275;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Date:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=R3MeO5bU9u9vZq0BWi1LFpN7YGyhm0gURVRh2ZqhZrE=;
	b=3X8AorGQhqtyqtNmVCErh7M5k21+4BXd5ObN1Umlse1MUODKJa6Zgj0KCbim16G/zLg/
	 YdzWI6gLWZNk6DilU0ua5JuOiZvx1GGPPVm78wpwHr4tO1jktsWHr/aq1AaTrb7o/eukN
	 1NdzcdgPmNrTCQqk+A6I8WagHw2ghl7B1viizmDDbrRGYbzHR5PTUcDMNV0PNk1Zo6bcB
	 h05W6Whxq41z4wlTa4mZcl73ZpzMI7Iv6vAU1nCjmLtIVRZWUFT6TG3zcDgbouUwkZfq5
	 CrZ0ZJGzTRwrVgAHw7I1kbyNF8wIeX/j88JwPc0PyHfuwmap7SGimYJGhkWltRL9J3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e0yO+Yt1;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DDC606A32C
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 18:44:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5DDC606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e0yO+Yt1
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c49b431f022so102077466b.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 10:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793904273; x=1794509073; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R3MeO5bU9u9vZq0BWi1LFpN7YGyhm0gURVRh2ZqhZrE=;
        b=e0yO+Yt1X9dK5zUWtqluc01kM8rGMGf1AjxO5Vx4oz11JObBFSGNEtaZoL0SyWsUqS
         QbUys7570/8D8S2wooUCG2fa83MBkuMwT4+81BD2e8XBtMDQHw7jmJNoNWVqhN4H5WrJ
         o4RjOc3YgikXkNbNIA375TNF0wptj9v6u13xV750RZBb5gXKbevXpRbMMrZbCI2M43/h
         fyVEKdY06hsmqXxDbi/h8x/t4KnPya55oFcQvnNY/ZrG3Vi50pBhuvLXE9oX8M8vGADU
         rv7jJP/d98piUPYaBt7FIAAcKsouzDpcJ7CjFebfr1McSyjYGPjKA4X7mNjtTFVa4oCm
         ehHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793904273; x=1794509073;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R3MeO5bU9u9vZq0BWi1LFpN7YGyhm0gURVRh2ZqhZrE=;
        b=Hd29WgpbD4DQFNoXH04kON4L1faLH50tLU7Ceaz9mfAgmGgnu6LSYV884LM5G0CYLb
         9Kzj/vbmX4TAakgtNGWvyfuwjS77o7aHE74lOd96Q51qtkeeqhBBKJUdpjgX7MViWJ21
         J/GiutE93USMdsyNFQwslt9lftI9C369HnEaQnXBvMbaMXM7KrEzosy8IE2OteYbL0JN
         /NDEa12Z6HYhxEyN99ftqaHr3hIeABhRcaLgYRBg02WUF4inSboFAziAMWBXmPRzRQ67
         757LqEJ8CC6F3uAX7kfw3Ic5x+jIcIF7FM+zGd60NKIk1tVWWlsNX1A6ox2x69Q9lUs2
         8rVA==
X-Forwarded-Encrypted: i=1; AKwUvBxHK9D/DpxVWSoGA2Cn18PGcsaNg8O6ghk5SVqQF/j9iNGNkq/iAyFwRb5+vIQ5Xjshysc36Cf3i27n2do=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Uo/VVmuBfOv+EqVFX7IDo+7EHa5rVJSyiVKSt/pg/VuiQG1lS
	wSjZpIZIka9jxWApuMxqxccPRl78iciZUKWlbwEB+Y0X7UIiBdH3w/6v
X-Gm-Gg: AYBFou2aW1UDHWGA+WmsFVGdEpu6PUEXitLpwzLl+VJj0tk/78+K3N4Kv0o4SrMIOIh
	vD4ga+9CQSKJ/8F0x4RBurNCJkuwGB8g5Gz4QAWjTGjC6SoBa/CSWPDjULpDo5Vv0MSbEnEmC6c
	7XofumAKhGYd5oSL+lNqIMIngtn4I8vXZsqMUoufq58yNGsu7YYliuk5lPZJ454lrJQuWSc7HOb
	PWTnVhn7x2MrvQuzW8736B695bT1ar83vsMBs4AhaznpEdNgu/dabGOgMznd/YKMVR4fbXegb9O
	ZI52ojtewUh0Dy5Leo+W7GpzNzufHDT4DEeNCPXbZiQF7SoD8wKI6uck/wIFoaUPkY//a9w203l
	PiNxfH8DhTh+Xduc5psgr67Leg5zRuYTWOuXLn6v4s15IXqnAH2kDZ8MljKQPDICR5pIuGoNrSW
	1ktoy7E5pyzq/Pyhdb7W3eFzvV/Q2Nq+3JvOnIxkQsme47WssYVAfXWYErPKxaRlSkBQGJ2fQDz
	+TpxNpe14EegeKTQjc6g82YNxYFll5/gza4jMcUHvBcFrVi0P8MiZI8gs8LlXofZ2Rs
X-Received: by 2002:a17:907:d0f:b0:c48:a838:c188 with SMTP id a640c23a62f3a-c4d34c59db0mr39140466b.13.1793904272964;
        Thu, 05 Nov 2026 10:44:32 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d354ac249sm8993666b.5.2026.11.05.10.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 10:44:32 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 5 Nov 2026 19:44:30 +0100
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auzOjphJ8DWpXwUy@milan>
References: <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
 <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auxDm_YO4oACA_d2@gondor.apana.org.au>

On Thu, Nov 05, 2026 at 04:51:39PM +0800, Herbert Xu wrote:
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
> 
> > Virtio ring-testing:
> >     (alloc_ring(0)), gfpflags_allow_blocking(0) does not allow blocking.
> 
> I didn't really look into this as it's just test code.
> 
> > net/ipv4/udp.c:
> >     err = bpf_iter_udp_realloc_batch(iter, batch_sks, GFP_NOWAIT);
> 
> This looks buggy in exactly the same way as rhashtable.  It's
> called under spin_lock_bh, and the same lock can be taken on
> the softirq path on another CPU.
> 
> So are there any safe users of kvmalloc with GFP_ATOMIC? If not
> I suggest that we change kvmalloc to disallow vmalloc when called
> with GFP_ATOMIC.
> 
kvmalloc() disallow and vmalloc() allow?

The deadlock looks like from below spin_lock():

<snip>
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e4570bbed854..97aac4a4a92b 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1025,7 +1025,13 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			}
 		}
 	} else {
-		spin_lock(&br->hash_lock);
+		if (in_serving_softirq()) {
+			if (!spin_trylock(&br->hash_lock))
+				return;
+		} else {
+			spin_lock(&br->hash_lock);
+		}
+
 		fdb = fdb_create(br, source, addr, vid, flags);
 		if (fdb) {
 			trace_br_fdb_update(br, source, addr, vid, flags);
<snip>

is that applicable for bridge update code?

--
Uladzislau Rezki
