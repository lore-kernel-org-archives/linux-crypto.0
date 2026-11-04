Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793771160;
	b=xxv3pRttSSO/q/8fJ7QJh/ivoKX+kPg5TOyOB5AauuKPChxUdBiWE3+WPSSBeY1maPv8
	 zmH8jUNmObuOPsWSYNwO+FUgFeXCU/YN55Ec72g3PqzY29Ou+xf5DBmV2wIvxvQRKv+Ph
	 yAHkDXEiko5TuXE7BQRriBXONOT8X861PcbiF2HQ/2ThXTPskYTRSAt/vXMAg03TWJgVD
	 ETP9XcGXnxxFH3e4cxQYGEppaTOihK2tixzndsIMuza1no9QKIScUPIZ/LAPgTIvOF9HW
	 zYDmyjTYEw95iq67c23TK6vTVg8R2tH565lpwAUZjg2dbonKLcM4HIOCcu6M5TctvDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771160;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=kSMelPUMbambLzstY6Q1ODhfgtsWJixz60QR47Gg/40=;
	b=z5gidnB18fDmCHIyT0PmEH3jBHZN7bamwZxq8+8ZBQdGZ15Gj96yMQ3Vf035jDFMQuIa
	 puTsYSe9dfxkWaJR5sSYfWN5yNSJMY7tIiMW18/ec40e4BJgTdWuuwKmYujkWwe3zkqg/
	 hraDX4yvh9oClFJjMK9rf9W8jz8aSo+n7PRii6yNfuUwuo39vhhkHNXkAY6EKYmShOCk6
	 c61aPPgZaeAGJKhqhgb3zoOwp1OB8QX/goDiDJPWiE//ltmMQh+CyAxwenWrX5XQ1lz7L
	 4EK5QZiCJsNl8tB5BbEdCPyd560LkB71gyqtBvfuF98cDQ1CqigDxPqNUGL7gmSsAyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=FTIOqQFy;
	arc=none smtp.remote-ip=209.85.167.47
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2743F606A335
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 05:45:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2743F606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=FTIOqQFy
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5bccecba199so229982e87.1
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 21:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793771157; x=1794375957; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kSMelPUMbambLzstY6Q1ODhfgtsWJixz60QR47Gg/40=;
        b=FTIOqQFyWxw8VXQ2smxCBjSFp/FztUDta7afKJTHfLt7TuNGjttxTjvaJ1xc//NrzG
         9i9KaEsMiNtGTC5Oa/lG8mhje8naDy3/4uPM1B0etdCpd+tJJZE1yrpLVUBHm1fJRbO9
         TRVEfSU0qmtN+jqwZZ4H/+wHqxX2H8KrUzv/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793771157; x=1794375957;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kSMelPUMbambLzstY6Q1ODhfgtsWJixz60QR47Gg/40=;
        b=ZrS4BCL6yEJgb9CldSHmeN9Q9nsToHCdtXPysrtt9tISgSVS1diyA4k3sKS+gsnI6N
         0/rNa5w7zbg9UYLjvQBHkDGLQ8l8f0EEDYj2KNNhZtmnlHIBc31I1azgJv0lcLVKsljP
         GZWLKYJLeqfyp9YB0YE1X7yPQAsICLVaVin2H/EggezIKr4LFKGCaPiUP6md+fCQyb6t
         fa/wpKO/hhdXR7hjsSh55bcnL4ZU3hNZSxSGxExc+tXpru5uc0xAKOI/F7gKz2spQ1JM
         YUpXW8xNcGtFvPrQ3YyhdgJeK933b2fisg0DsXDtrIeUUPuXvbopuWyVQR6azvJCg3tN
         q2Sg==
X-Forwarded-Encrypted: i=1; AKwUvBwUioQTKmGsfdGs3zAvHnhzeTh/HNBKi/WkohfIlUnEjk1iEv5zN+e7yW8vQwpAdPtvtoZJwNAOeP7FS5k=@vger.kernel.org
X-Gm-Message-State: APuU4Z/XtYCB6KUXVay6c3kNkO1JGJNzqfStJIemMATBq4BbRYUe00gL
	Jag3sBL81lg4bLliFbkID8QtjRz40XYakqDSbX9ctyyvsTRWDzYL6XKLOMSA2PocxrU3s8pBCEs
	A0L7LsPqc1g==
X-Gm-Gg: AYBFou12UqFluVj+xDdeB/lZ4EjBGVrYH28YCUIixZoSOcUMFs6PXBDoiMinlypGrd2
	T9gneV4vlriWEeJ6EzuA46y/4pjJaloy4Y5RIkOc6Ni1F7+LXZuX+aQYV29B3F7P2XvWPvctjq3
	c91tnMxSo+eY6b2ujv3pmYOqL+WFTLskjijIOvEwm6fjl2eYJvNheTHN2JZL+7emlAYZ9Y1ciIo
	IjBvsR5C/yxB0TpKpT4PYVjr/IWNrk+XEblsqknoMWRTu2ekBvwCGhf7nHW2ZQ8jA3EQBaNwR+7
	MKj3O4mlXT4lLLqhKBvKHJEIzgQDTHyueAB6qT2Q1eT4WJwfvy1ksQqgMRzHj+hIdfJ7/4ZFefZ
	GrqzPv1hesVHbOQL0rgKodHSTJchgO1nHjRdXnH862wADeDU2QrFOcmuq2o/qG7DbQGy5cNpgNi
	V+jQTqo6z8g2Nb+BJHHuzLiYN5alUamZvrTOgZd+BDSy3tMDIiC026XNxJMNXYaVqncXd8IQC0h
	LmA97D3Zn92VDbutXgs0kf5NN5ZHrEMhD7G40td16WuiWn4NUAalnVX4KcumQeF5VIUu5czZhV9
	SbaL49gD0nhLL6onPjaRE0hdxB3PKipl4YiatFnvnPE59L705tZC18EJw/yEXFD3RgouVJZc1Ep
	4OQ==
X-Received: by 2002:a05:6512:318b:b0:5bf:ba5c:abc3 with SMTP id 2adb3069b0e04-5bfd9562afbmr5711276e87.16.1793771157244;
        Tue, 03 Nov 2026 21:45:57 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bff384c6e6sm240360e87.4.2026.11.03.21.45.56
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 21:45:57 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5bcb6faf862so229611e87.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 21:45:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzO1Kd5g9OHF3X77jbAWOdxfa41s3Vo3SbYbHTS+z9+eH8kYhawaSr8ikk3f8eX4POiFA1SY+TCkU6Dprg=@vger.kernel.org
X-Received: by 2002:a17:906:9c02:b0:c4d:f63:642 with SMTP id
 a640c23a62f3a-c4d0f63079amr48032066b.33.1793770759887; Tue, 03 Nov 2026
 21:39:19 -0800 (PST)
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
 <auqtTjXhD8is-y9f@gondor.apana.org.au> <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
In-Reply-To: <aurAxRpCwzeyXeVj@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Nov 2026 21:39:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
X-Gm-Features: AclHuK8dMub4vC2TPpv6BcEahTt6-eYYmVZ48SoCIOo5V1xGWkBIA_qqXcqQYc8
Message-ID: <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
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

On Tue, 3 Nov 2026 at 21:21, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Nov 03, 2026 at 08:28:36PM -0800, Linus Torvalds wrote:
> >
> > Sadly, the commit you point to doesn't talk about *why* that
> > braindamage was done. Looking at the original thread it seems like it
> > was for kmsan.
>
> Here is the link to the whole series that was applied (v4):

None of that says why.  It only repeats what I already said: it seems
to be due to kmsan doing bad things.

              Linus
