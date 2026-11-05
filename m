Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912965;
	b=AwCT9EFRBTBWxvwsJLRQgspM7f7Nt4Ls+Wgw3jP+iFZdAr4BYWZY0ksY+veWf0TLzbgA
	 cRaMzrvI0GTo0EHfPOmzgaHT5/HXBLP9v94AIc7qtnrWy2emKHLs0S4vh9bFgWVpij1h+
	 1hLHqIwWEqQV4DvSMUP2F7KsIKrOGrbsVJhQkNWgivckpHZoW+TUSQv8iUbitDb0aj9tJ
	 VuAv+WKLIpCcWTdauepBSaTs41gfQQQz+ez2RaVvnC3w+zMmUpO3SCf6qBpn+0HxuxDJH
	 kyxIMOr9CuoRB0a/rXtyC6jg3DM+UuxyFS1/+Ov9MLTx9LplKLADisLtRRUv61vjMlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912965;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=vIPsFgpeDDDerv0ETdjJMk/BOk+taB7WxA1rqOHL3fI=;
	b=b2icNJQy14KTrx+Wg+5bEj/e5ccoeULO4o0f+QjAz7KU2jcdLL08n36n2DPlfmWce/qg
	 2Yd8g2pcBCXd7BU++BODPAsx9DKaFh7n3d/ZucOZ8xtyx9Wcg7IkaigU4GpuUX1NR30Qz
	 uhKmpu4pDvyWnNxw+gjfxFkkR8dy391XwA3OVT3XVklJuHDgEuBavZoOEGnNpfGkpUvYt
	 JnDeR92MRUXQlBiQXST1ExFkQRTpLCwHmtxiOW6erfIfOYTVosIM4VVWvorg3yp4iTn+D
	 U0qRwNe94dGU2esyNbHXRoj94e1cb2zMiz4UkotTPDY7jD6vhYjVD9wWVqPkNKX1yVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=GsYS7TJa;
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2C7606A329
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 21:09:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA2C7606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=GsYS7TJa
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b1dae0febeso3543797a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 13:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793912962; x=1794517762; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vIPsFgpeDDDerv0ETdjJMk/BOk+taB7WxA1rqOHL3fI=;
        b=GsYS7TJa+6qr4ZmAVRDJFcphAnTXZ+C43rMWasGLW5pfvx8ZBOm+pWEzIxgrTm2PZe
         luwT4CkfM8A0Dn0kS8+UI0CxIVuMDLdp/YYatk6Wj0jUuLoWotLmyPl0lbE+Gh091bN3
         n/gKS0ox2EKNPgl7UWVnlmd7lFxXqQLtC0P4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793912962; x=1794517762;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vIPsFgpeDDDerv0ETdjJMk/BOk+taB7WxA1rqOHL3fI=;
        b=SmkNaUCbO2Upkt+jnqS4auTBKzNwIybhbWm6Lo3qbT09YkOMiTZFuWRq0ZP3ax+z2m
         9Hno9CrEjjMtFKD2whhpRozkYM+pwE0anVA3QOcQrkvehLg5wKupTuAF4YIv3uLF6LIz
         CC2NLfbbbb1mHQcrG9sJ2R/oxwc/S8JBoyM70IQjsHgG27fRvEWaleHD8OdXuIvygDbD
         QkaCnIV8Q5+3sZ+ZKpO4GSzVvN1qkP+QHtNWeseuH3RziESAmCmJDFo2BngdVjLT4A5Q
         BMSHtbBptGM0Yxn3x39j5O3ZAX/ufmi7GZbz0fnVLM6AA9qSCuCohHOndDG2jtGNzoSh
         O4mg==
X-Forwarded-Encrypted: i=1; AKwUvBx5cU3MWt4suEKXCJyLeUOw/57GOVveGk8rnhZ/xV3IfDwY/+bewcYLso4U7lcLmrylQfdgN96om0lih6A=@vger.kernel.org
X-Gm-Message-State: APuU4Z8RZlW90qzgijl4stIih9oNcdUNfedSo2s+trYmlc3JDyVHUEiW
	DT5ZIzTgVXbSVI5tS9DTs7B0IwRa1P7o5wlFv1jiUgP6a9QMv+cv1CofEIu0PnKhhz71be20DDU
	p2+W5U7RADw==
X-Gm-Gg: AYBFou3WpcNKoAiJr4s5LRc0DLPfBQ/AX7og+ncE+scgrxJUQuJ312hm0TvDbIK2jF3
	i9szP5TZGTNxXqL+zOATkqGqhkNxZUUX5vryrU/Ox76ldzFeglRc7JaDVjMVmxWeBBMSdwQQMDB
	qx1kIK3x6subVrkwX4pEIMVDe4kSaVUs0qNyWps5BzkopTA0IYeLinaPG6aGm+gOsgMw+SEJXwb
	J329bzQnR50ItEd/cYIP0OMadkFq1xQgSOXWBhVjPnQ99XQ+5xFn9WuBmt7rpwJ/OB3EvQ5nuWs
	am7SclouPBPsRsFynVeM6bB97cnUSCnZ7t4Wy3S88Y08ZywNKWltmhOswVzOnumw5r+3dlr7VMA
	TiPtHz4MQ/V6VUuEHfNibW+rEy4RRd+aMFMlUSEasam1iTD9XhBv9n/fiQBD9YJCb40ss9vZfSb
	kzZ3IOAQHyVwUsDYkr8JAxYcCQPldxL3qV+NopFykppHqjaK0ENdTanb4ncMEKqMzAWcrI4wiqI
	IguheTI9TQATSDZejdT2I7EodRvWm9i52Q8S8IKjfuCqmJOvLD4nZAYCjkuxOJhJVfq4IuoLnsV
	HlqPDScxzZSSLuJwgw0e3mftJQTNbaBt+46Rnmn2dCHsqMHK6iU1IgrDfa53rBWmcH3lo+FTzOU
	+ZmKE/a+flwWVfoZQrzbF5lI=
X-Received: by 2002:a05:6402:1f89:b0:6b3:f840:59b5 with SMTP id 4fb4d7f45d1cf-6b5978067a6mr308652a12.27.1793912962024;
        Thu, 05 Nov 2026 13:09:22 -0800 (PST)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b57feb668bsm905712a12.13.2026.11.05.13.09.21
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 13:09:21 -0800 (PST)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so20384785e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 13:09:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwsRO9j/myWeDSRYoOX8UuRamZuvtn4iYZyEEkBfe7ir13iCc36pWM/GY7UTcBmwEeGnWz4Bo//4B8AZNU=@vger.kernel.org
X-Received: by 2002:a17:906:c150:b0:c46:9ca9:f524 with SMTP id
 a640c23a62f3a-c4d354b9d04mr48470966b.32.1793912574580; Thu, 05 Nov 2026
 13:02:54 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au> <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au> <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au> <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au> <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au> <auzOjphJ8DWpXwUy@milan>
In-Reply-To: <auzOjphJ8DWpXwUy@milan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Nov 2026 13:02:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjcKOC7O30L8_8PMniT71aqy_3ZEYK2xyoR8zW9ZCvO7g@mail.gmail.com>
X-Gm-Features: AclHuK-6zo-9KtIYF9n0Bopl194z1pM7LoK-Wva3VmRK1J9HSt04b5Zu07i1Nu8
Message-ID: <CAHk-=wjcKOC7O30L8_8PMniT71aqy_3ZEYK2xyoR8zW9ZCvO7g@mail.gmail.com>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"Liam R. Howlett (Google)" <liam@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>, 
	Baoquan He <bhe@redhat.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Marco Elver <elver@google.com>, 
	Michal Hocko <mhocko@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Mason <mason@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Nov 2026 at 10:44, Uladzislau Rezki <urezki@gmail.com> wrote:
>
> @@ -1025,7 +1025,13 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
>                         }
>                 }
>         } else {
> -               spin_lock(&br->hash_lock);
> +               if (in_serving_softirq()) {
> +                       if (!spin_trylock(&br->hash_lock))

I don't think that in_serving_softirq() makes any sense.

If I read this code correctly - and it's possible I didn't - this is
always called under local_bh_disable().

And local_bh_disable() will have increased the preempt-count exactly
so that it looks like it's in_serving_softirq().

Maybe I got lost somewhere, but it basically looks like that test will
always be true and is pointless (and misleading).

         Linus
