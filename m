Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A943E1D16
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 10:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777370765; cv=none; b=Yig1ifSvNIdClZwn6qQCXUpNa5EtvnSXhLXo/faZpxDjBewuvOvbK0g4l8GgckgQKFuzjDVVGhXqYS794F8xnnNDgf+0liVBofDNrbc/gU+CZi+jL6AHRbvBynRNkow/NPocG/OleXT3JSBUq7iFAyOc+IJFtJdXk6joEfIwRWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777370765; c=relaxed/simple;
	bh=g+lTY6cYsTJ2QbbSfNoaUnqecZ2+4coH/dDAUkw8fGc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YJaICWjUOWj6URuIS1qqkD9rXXkuR7XktSjWL/NM41QKulxl9w1nbtxm2pL4Lr2UNGDJV84rES2UOi1v0sEeLqIHTk3lcvAeO2WJ3LUMiH45m60Us7/1ENO0pzmbE15aEwtwpD9axHB7aFnSSm5Eb02OwRHlws8sa3k9Qc50I8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-56d933b555cso3544674e0c.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 03:06:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777370763; x=1777975563;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JI4uziET6JAWo+FMAiSC3ZAIZqYosnFx+7pkmhqLPAI=;
        b=REJlvMSnBPCagaKOJ07DPG7n6a+UfOG/aQ6h/Qy/SrMS1IMo8wOWTBw9+KIwWMzcZb
         o1GpioLogVQpex3VlFm9FGT4lP2qBXSVv9wra4bC2zYMIyL7X5VldIKyQsSWHRzoQf3F
         jOKyYiXUY4CvoJNQ3JcaxiJGkD4D4Ig79emuWi0RJ30bQJaCXi02S728WBXqdkrQPW28
         K+9h4GBrD9PIgu0XFRa9D5S2hNlxDKHWCK5q1LaM9JIhO6Oe1Df4FNFFpb0utQds5lgb
         lX/iEBDCGVFFX3GAKul78ZBAlqYZPMgLcPOqvPIIDS1VvVCpdEZ8b6O7Pj8Bv2j03YG/
         ieew==
X-Forwarded-Encrypted: i=1; AFNElJ/SltFuZMNTBf52zB7ADlU3yLRYy/NAAMi2UYDsMt9ijdrM1BiNYHESqPrPFjFm7kqEFmOj+iDEFVELQYo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz62IkLmiz22ENfM8p7sUGO2vLHk0EWU4FfeUvPttbgzxCc3fl3
	vyhSWFH6QoUBccrgwr7kNKfFfHHjjC+OKIKTwkvKDM8iRj/RATDhPNS4EYhq6684+Oc=
X-Gm-Gg: AeBDievIYUDBIRf4a3dxXJzJRTC01r8o098wKn6Lq2h4FmtYaMOO0qZxl2nifrNx+DZ
	bJz5fQN+tz9hUlYEx/8PDso+WtpP9Wn0LoSbDm31oCS8pLUTsCmKmYtuRjAnOO/xD2R5bwfl1WL
	bbTR1sTPjt7foeV5LdddCZ6EcdFOaamahHgHWesnNQeWhBNwwmt/UyUM4Ay2EhWmHdW+EJxOyKp
	1VOxkG7J02s5UOFYRaMhv0cndryevxiXaBv1ajNBQtF0iwqNQ+Un6EM7FwXuUSKO9qBKaHtcASO
	ySpu0QRjtm1HA24bPfwUMLpqByNVUu0jFNZHx0zZjWPbpifCbos0ETMWHXl35f+vyWz3CZ6yL5k
	59++ChPj86QAr7J7Slb7HNkYX/K22v1L+cMZgFRGAYDoq6SK62R8nhkHOP7KFRzricGsGdNEhB9
	he0fcmZ6ZEwWPLFlGZ/DMEJfwbnUdAqcc3notcbUkQ2hZX/Fx1U48latLZpi4AuBaTKCzsnYM=
X-Received: by 2002:a05:6122:8297:b0:56b:5e7e:d3fb with SMTP id 71dfb90a1353d-573a56a3c38mr745793e0c.12.1777370763047;
        Tue, 28 Apr 2026 03:06:03 -0700 (PDT)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com. [209.85.222.53])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-95ca0a51193sm937548241.0.2026.04.28.03.06.02
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 03:06:02 -0700 (PDT)
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-95673f7b5baso2800152241.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 03:06:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ85TlDx+QBkpIIJTtJ32Q9Vr0gL9k619UfjB6MsHa18PPa3fvn3Fg3waRKiZ+3I5G+JsgaXjXGrRssAHU8=@vger.kernel.org
X-Received: by 2002:a05:6102:3914:b0:605:4ff8:fc21 with SMTP id
 ada2fe7eead31-6280956efa3mr686151137.8.1777370761950; Tue, 28 Apr 2026
 03:06:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428024400.123337-1-ebiggers@kernel.org> <20260428024400.123337-6-ebiggers@kernel.org>
In-Reply-To: <20260428024400.123337-6-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Apr 2026 12:05:50 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUz3f9d6Fnz5FUNp=QwxMckQdmqMUpp9pJN2OXmt_1=ag@mail.gmail.com>
X-Gm-Features: AVHnY4JehlpIYgHeh5BF_H4nn36U985ndwS087_C0M83zeCp2dtWlb4GELXGrzQ
Message-ID: <CAMuHMdUz3f9d6Fnz5FUNp=QwxMckQdmqMUpp9pJN2OXmt_1=ag@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] crypto: pcbc - Remove support for PCBC mode
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 Apr 2026 at 04:49, Eric Biggers <ebiggers@kernel.org> wrote:
> The only user of PCBC mode (Propagating Cipher Block Chaining mode) was
> net/rxrpc/rxkad.c, which now uses local code instead.
>
> While PCBC was an interesting cryptographic experiment, it has largely
> been relegated to the history books and academic exercises.  It is
> non-parallelizable (i.e., very slow) and doesn't actually achieve the
> integrity properties it was apparently intended to achieve.
>
> Remove support for it from the crypto API.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

>  arch/m68k/configs/amiga_defconfig             |   1 -
>  arch/m68k/configs/apollo_defconfig            |   1 -
>  arch/m68k/configs/atari_defconfig             |   1 -
>  arch/m68k/configs/bvme6000_defconfig          |   1 -
>  arch/m68k/configs/hp300_defconfig             |   1 -
>  arch/m68k/configs/mac_defconfig               |   1 -
>  arch/m68k/configs/multi_defconfig             |   1 -
>  arch/m68k/configs/mvme147_defconfig           |   1 -
>  arch/m68k/configs/mvme16x_defconfig           |   1 -
>  arch/m68k/configs/q40_defconfig               |   1 -
>  arch/m68k/configs/sun3_defconfig              |   1 -
>  arch/m68k/configs/sun3x_defconfig             |   1 -

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
