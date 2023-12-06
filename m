Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="EF46/yeW"
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D18AD4F
	for <linux-crypto@vger.kernel.org>; Wed,  6 Dec 2023 09:07:53 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-2865742e256so44084a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 06 Dec 2023 09:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1701882473; x=1702487273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=62swcpHmDcdrzEklgnBANJd/n5tMHFnHaZwN9QLuoRY=;
        b=EF46/yeWWRirY2RBRcPYQ2OWvyJzVsKHJYFj6ywrqkxTgrdYsttMqxrNqI6SSeHrSv
         S0xzorAS5Q1bwzLTiGnJa7wmtV8LtBNxMudH8NljiS1HsCoMwS5ZmxlkgY2AtepgvkNB
         TxyjZZqvr6q3SQNNO98vR5zRCaPJ+e+kOPYRsEq3a0GDbhJWPZwrDJj1Tr5gltR/OfSf
         /VDUx5fr20W1ETiTS0W1/HX0YpblGDvhzjCysJduhBPBTVugISfJtAl22yL2WoAMHzSj
         EUYEgMD0sUfvflqNfCB5p/Y8RVtf/WaG0KFghFAShOvbSxDCpvd90vqeMHLwj51RnWHx
         Hp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701882473; x=1702487273;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62swcpHmDcdrzEklgnBANJd/n5tMHFnHaZwN9QLuoRY=;
        b=ONNfkjuRufV/9k5q/nc6zTyf8W8UQ+WlsyDqxL+ir/ZTQmJND8iA/8CGbgQ6dT0V93
         2IsFw91WtE3XIfoQwOYFhsLOWHvRNa8LXZy/kwreoY1zLBFHhvuI/kbSarCaefCIKrSK
         OncaX4ZcQZ0D7/SUPsvPG5Y/4ljlx3SvhVK3ejXapd73J6WlL1KMOhCYLSTtZOVR3JRW
         IN14Ta4L3MOc23zvtLMa35zYNAU+f5LuqFk34lUdIQGA8M4+nAbz9QRTFZvEtbLAmRhX
         3FC/bM7uJAT3hfgH4U/+v9N0yplVPHqabInO4+uuncLZyEMvoOqUfrCCPCe5em9jjo6E
         qs1A==
X-Gm-Message-State: AOJu0YzaRA9P8njrd7gkpUa8UDmGu5YsuBXnGPZlOlzj5em8kV+IpoF9
	l6furPmLubBwUwGVK9K+qVlHQQ==
X-Google-Smtp-Source: AGHT+IFNdOlSwSYRE5V19ix0+QEWJdVY39+A0aCl0rPmo2N3/BkNZKr80Gs2ypCNqOVZyHsks6oS4g==
X-Received: by 2002:a17:90b:8d0:b0:285:b67b:f435 with SMTP id ds16-20020a17090b08d000b00285b67bf435mr930224pjb.41.1701882472807;
        Wed, 06 Dec 2023 09:07:52 -0800 (PST)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a005a00b00286bf87e9b6sm76581pjb.29.2023.12.06.09.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:07:52 -0800 (PST)
Date: Wed, 06 Dec 2023 09:07:52 -0800 (PST)
X-Google-Original-Date: Wed, 06 Dec 2023 09:07:45 PST (-0800)
Subject:     Re: [PATCH v3 00/12] RISC-V: provide some accelerated cryptography implementations using vector extensions
In-Reply-To: <20231206074155.GA43833@sol.localdomain>
CC: jerry.shih@sifive.com, andy.chiu@sifive.com,
  Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu, herbert@gondor.apana.org.au, davem@davemloft.net,
  Conor Dooley <conor.dooley@microchip.com>, Ard Biesheuvel <ardb@kernel.org>, Conor Dooley <conor@kernel.org>,
  heiko@sntech.de, phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
  linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
From: Palmer Dabbelt <palmer@dabbelt.com>
To: ebiggers@kernel.org
Message-ID: <mhng-9f5b6a98-57f4-40a8-becc-93319bbed97c@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Tue, 05 Dec 2023 23:41:55 PST (-0800), ebiggers@kernel.org wrote:
> Hi Jerry,
>
> On Wed, Dec 06, 2023 at 03:02:40PM +0800, Jerry Shih wrote:
>> On Dec 6, 2023, at 08:46, Eric Biggers <ebiggers@kernel.org> wrote:
>> > On Tue, Dec 05, 2023 at 05:27:49PM +0800, Jerry Shih wrote:
>> >> This series depend on:
>> >> 2. support kernel-mode vector
>> >> Link: https://lore.kernel.org/all/20230721112855.1006-1-andy.chiu@sifive.com/
>> >> 3. vector crypto extensions detection
>> >> Link: https://lore.kernel.org/lkml/20231017131456.2053396-1-cleger@rivosinc.com/
>> >
>> > What's the status of getting these prerequisites merged?
>> >
>> > - Eric
>>
>> The latest extension detection patch version is v5.
>> Link: https://lore.kernel.org/lkml/20231114141256.126749-1-cleger@rivosinc.com/
>> It's still under reviewing.
>> But I think the checking codes used in this crypto patch series will not change.
>> We could just wait and rebase when it's merged.
>>
>> The latest kernel-mode vector patch version is v3.
>> Link: https://lore.kernel.org/all/20231019154552.23351-1-andy.chiu@sifive.com/
>> This patch doesn't work with qemu(hit kernel panic when using vector). It's not
>> clear for the status. Could we still do the reviewing process for the gluing code and
>> the crypto asm parts?
>
> I'm almost ready to give my Reviewed-by for this whole series.  The problem is
> that it can't be merged until its prerequisites are merged.
>
> Andy Chiu's last patchset "riscv: support kernel-mode Vector" was 2 months ago,
> but he also gave a talk at Plumbers about it more recently
> (https://www.youtube.com/watch?v=eht3PccEn5o).  So I assume he's still working
> on it.  It sounds like he's also going to include support for preemption, and
> optimizations to memcpy, memset, memmove, and copy_{to,from}_user.

So I think we just got blocked on not knowing if turning on vector 
everywhere in the kernel was a good idea -- it's not what any other port 
does despite there having been some discussions floating around, but we 
never really figured out why.  I can come up with some possible 
performance pathologies related to having vector on in many contexts, 
but it's all theory as there's not really any vector hardware that works 
upstream (though the K230 is starting to come along, so maybe that'll 
sort itself out).

Last we talked I think the general consensus is that we'd waited long 
enough, if nobody has a concrete objection we should just take it and 
see -- sure maybe there's some possible issues, but anything could have 
issues.

> I think it would be a good idea to split out the basic support for
> kernel_vector_{begin,end} so that the users of them, as well as the preemption
> support, can be considered and merged separately.  Maybe patch 1 of the series
> (https://lore.kernel.org/r/20231019154552.23351-2-andy.chiu@sifive.com) is all
> that's needed initially?

I'm fine with that sort of approach too, it's certainly more in line 
with other ports to just restrict the kernel-mode vector support to 
explicitly enabled sections.  Sure maybe there's other stuff to do in 
kernel vector land, but we can at least get something going.

> Andy, what do you think?

I'll wait on Andy to see, but I generally agree we should merge 
something for this cycle.

Andy: maybe just send a patch set with what you think is the best way to 
go?  Then we have one target approach and we can get things moving.

> - Eric
