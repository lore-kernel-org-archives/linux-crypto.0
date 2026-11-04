Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793766538;
	b=zgjHs/z3dp+3HSttIeUUrRZHSHRT3EiB9s3S27usNtUU8WOlfdAKDlvsGyNIw0awkG2n
	 I/PyCXivTieMy5FvNvRM3P6Re0UM4ReeuG38jtdZZam5UZny5qlhLX1xfLSXFZBU+J3rJ
	 x452r5IyaRBMEGzwpbkDCOVt++6RlM3ZQmH7SreAd3cawjzHm5uTrQPlHU+5EhEYbbtmM
	 FOYFphNxXxHjn8VoIEWIh+3jFyu1UFeW05LRAOwNHzwMaSDXlPFd+Tu9RXbadR97NDNG6
	 N4uEETDa+iD92RSVHehGAfcOVjwP0Jc7HUOnFXl/w8YsXTQk50FMuUYkcnFejRsqJjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793766538;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=YoT0N3seRwZx2djffCaiAALCN3DDAOTgxnkps9J0Des=;
	b=i2ZyqRi6r/AJTQDhwKT77U4a+RZhoUe63dem99ZEUiPA2bUFp8QMQzonJynaZYK71R1X
	 vfbAqc6JURkGmM80RY+MPcPMJG2AiAf2K7PBolKgnDUFpel0c5BMCmoQ1P8hgGg8yIuSR
	 vkSbOJD3kn8e9FcHaaOOHzyDnN68nzgz+UDKRJlGOZ14nQLkpE1GU/4JfLnduLMZHd1Yk
	 gmyatk8c7F+N9lt6xFgjw96GVnWTuynIUsaiT7AcO1yWnmmp20YzyrZalVOZYgeDmUPkA
	 7xDxw1bYYgfoXhFJEi5w8sfvSqUzrxm4ytS84hylCLIMdlv+0WcdBgKdKjPOizf+72A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=dlxTkS6W;
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91460606A31B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 04:28:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91460606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=dlxTkS6W
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c34bff61551so46872966b.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 20:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793766535; x=1794371335; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YoT0N3seRwZx2djffCaiAALCN3DDAOTgxnkps9J0Des=;
        b=dlxTkS6WO0kkDMixr/T2OT5yCYhNLySmHefwmySTtvZ65QG2HNX1maV52KcQmjLxlX
         xzrtiU/ZCGE7ghRbCkTNT8yDJU2FUd3/5XP1UUrkCyo7B4emoEJvtbXostMivw99+ox7
         Al0yMDZGY4/zs3hPitb12/svpdGRWRjrqyKW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793766535; x=1794371335;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YoT0N3seRwZx2djffCaiAALCN3DDAOTgxnkps9J0Des=;
        b=gNCaQMjwJKiQ6ijxASvJPlO84GqP+wd7i/a6WJpB7o33Z4rhTneQlPto5GnWTE4J+p
         XVIpc8I/rRcesqzzLp59UzgFW58cnDmVKRxKfK55TrgGQdHrMXMLqyYANwoOqDvZJn2P
         WiUS05Cl97XSj9YYtoEQbFHCEucyk0azx7lIN3H+5YoIC9tkLVpOEq/5mDPSjr54dT1l
         KiiYflXT8/w+v/s2oZBP4t7IWcxSvw9WZY7bz8jxsfIGMMZLIhofRZg6TAOVWWt80d9u
         3N+OLzx98uPYc+k9AruaCLxmlLoFNKt8pDUDrr2LmFojp1xcifKxQUORZpxCRfI3G017
         pQjg==
X-Forwarded-Encrypted: i=1; AKwUvBysFSnt1kYaUzeA7bYi4zc+a1N+xNse3YOy48pbA1tEwFyzXgXlfdkJtutrnF6Y+a1Qi87ybbnY5KTwDv0=@vger.kernel.org
X-Gm-Message-State: APuU4Z95gTG0ZvDcvd4nriQyaeUN+Agv/x9rt08D4oJiACasSDJipWYl
	tFEyfPKecaSA2vxsZsaKM/b/mCJ6sNlXRVFA+CXi3xcanDvZO6BtFZYefAO9apbQsRdyZQI2NHd
	n3/UapQo=
X-Gm-Gg: AYBFou0OtCo9uqq5p5SMPVM+5RVTtub3OQ8a58uovBx8cjPAacy6cvrZp/1TejLAbHL
	S7+5GwdxiztzdJZf6h3uEBGAkzcT2+FyybTyaF63tcJlT6cgO80CwLrmSDrqUpRChTPyxa2CGPo
	Ri6oqPaaMyVNhbFhTcL1+GrqM9K/Z9S0mfFhHhrCb/ISNaG8lRnv75PzLIgRaC+doFgzv2aa8aA
	0n6kFpRPxUxtUnp+1XclSSNyQzanMetoiBRODjkC1vZxBuX1TBwuP9fZTufOk4fT83IFu6Wb9O0
	57zl/t6zMbGogKR/VvVjuXeIU3DuESLVdSSyU8Fv+IC83I7lLcNBzGmUXy1wlN+QFZADloznjb+
	jtZQUwd2LB2PXPK+LdQIj7FKs0nD9rtw5B7btP98RoN4vJyrUeXg7I5VgdGkSrEsAMzuy/noHb+
	/yqoqaUC6BtsnBkgo9E1ZuH+27vJHdIMLGAX19HBFuUXuf2bmPfaa3LJHxVlFnNPmNpW/sqYK4u
	ok7t11gT1xcIfzsWJ3foBqssMrS4PV6yrdsPctad+flmjiw1MZHC/3S2YzKJ6/87Xo5XdY1Xwvq
	9mi1Nc94qr1kaGO92vIyAMWnxKt2RJMgm3k/sB3SaNuoYwjQM0a4AWLzrlb4ZzTT3+Ovadv8SKg
	TjA==
X-Received: by 2002:a17:907:6e8a:b0:c49:ca4e:b978 with SMTP id a640c23a62f3a-c4ca7aed610mr1269375666b.49.1793766534848;
        Tue, 03 Nov 2026 20:28:54 -0800 (PST)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e43f49fsm28998966b.36.2026.11.03.20.28.53
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 20:28:54 -0800 (PST)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c3fd91337baso47566266b.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 20:28:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxAyieYuZJvNQm6Bn5jU6bSrTjPp5cW5eRxDtLD2bGixkLMguHoxrwRFqJGIQ32JRul5pNxkK4xxkqL48M=@vger.kernel.org
X-Received: by 2002:a17:907:3e8c:b0:c31:8984:7fad with SMTP id
 a640c23a62f3a-c4ca7a4bdd3mr1249450166b.15.1793766533308; Tue, 03 Nov 2026
 20:28:53 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028154218.1668182-1-liam@infradead.org> <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au> <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au> <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
In-Reply-To: <auqtTjXhD8is-y9f@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Nov 2026 20:28:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
X-Gm-Features: AclHuK8Q2xxyDr0nTOpQBX0hGVCNXuqdZQKlHZIGiyhVn_ThF61kvu3f6cKlY_8
Message-ID: <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Liam R. Howlett (Google)" <liam@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Mason <mason@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 3 Nov 2026 at 19:58, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> To recap, kvmalloc was modified in 2025 such that it can use vmalloc
> even when called with GFP_ATOMIC (commit c6307674ed82).  Unfortunately,
> it does so in a way where it has to wait for other CPUs to do certain
> work.  As a result, if you call kvmalloc with GFP_ATOMIC under an
> external lock, this easily leads to a dead-lock when other CPUs end
> up blocking on the same external lock.

Ok, so it sounds like that change was clearly complete garbage and needs fixing.

The only reason for GFP_ATOMIC is that you're in a context where you
can't block. That's the *point*. So if GFP_ATOMIC waits for something,
it's just fundamentally buggy.

Sadly, the commit you point to doesn't talk about *why* that
braindamage was done. Looking at the original thread it seems like it
was for kmsan.

I didn't actually find the kmsan use case, but I didn't search very
hard. I absolutely *DETEST* it when "debug infrastructure" causes
actual bugs and mis-designs. That's the opposite of debugging.

IOW, I guess we do have to split those allocation cases up, and we
damn well should remove GFP_ATOMIC support from vmalloc() again since
it's clearly buggered beyond belief.

              Linus
