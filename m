Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C81220687;
	Mon, 10 Mar 2025 12:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741610063; cv=none; b=Lp0DHhKRQ+HM+0+MMckw3pQYlQr3nFVJlVHWtTEAayrYRd6pNIOTJ0kzhkgFvNLDvfJTG19+LElbaMwY4VufLx8vayiWQ4rgYn89CeNS4xAOr+l2VqYpefHbuk3cIMGp1Atgf5rYzx/QXYdLlOqNLIo/Vh2TMWMkGs0sqKtolB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741610063; c=relaxed/simple;
	bh=6QimkLxyHh5zBhK7nMbvk/S0VweCjJC2WpgD3iNSSvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AZ6M+kqvTl0lLf4ruFDe+6W5JNRy48bZvyX+IHu6+3O+KFBHY9E7RkstQw+f/Zog+nCd9shWAtWb19MicJswrM7w/RR90E0wO9tldNosinDzXxpjIQ5S+vugaQQqBqSxZRKnc0i4FWCY69Lkmpel7qzTKbx+QEo1ZzdCAWF2uzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 8EF2D4432D;
	Mon, 10 Mar 2025 12:34:10 +0000 (UTC)
Message-ID: <ce034f2b-2f6e-403a-81f1-680af4c72929@ghiti.fr>
Date: Mon, 10 Mar 2025 13:34:09 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] RISC-V CRC optimizations
Content-Language: en-US
To: Ignacio Encinas Rubio <ignacio@iencinas.com>,
 Eric Biggers <ebiggers@kernel.org>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>
Cc: linux-kernel-mentees@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
 Zhihang Shao <zhihang.shao.iscas@gmail.com>, Ard Biesheuvel
 <ardb@kernel.org>, Xiao Wang <xiao.w.wang@intel.com>,
 Charlie Jenkins <charlie@rivosinc.com>,
 Alexandre Ghiti <alexghiti@rivosinc.com>, skhan@linuxfoundation.org
References: <20250216225530.306980-1-ebiggers@kernel.org>
 <20250224180614.GA11336@google.com>
 <87ikorl0r5.fsf@all.your.base.are.belong.to.us>
 <20250302220426.GC2079@quark.localdomain>
 <a081958f-0ae8-4b8b-b49f-81378f3c05a7@iencinas.com>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <a081958f-0ae8-4b8b-b49f-81378f3c05a7@iencinas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdduudelfeeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpeetieeitefghfeuvddvjeeiudehheeiffffgeeviedtleehgeffgfdtveekteehudenucffohhmrghinhepihhnfhhrrgguvggrugdrohhrghenucfkphepvddttddumeekiedumeeffeekvdemvghfledtmegsfhgsgeemsggsfhhfmedvgeeisgemfegtheefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvddttddumeekiedumeeffeekvdemvghfledtmegsfhgsgeemsggsfhhfmedvgeeisgemfegtheefpdhhvghloheplgfkrfggieemvddttddumeekiedumeeffeekvdemvghfledtmegsfhgsgeemsggsfhhfmedvgeeisgemfegtheefngdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhnsggprhgtphhtthhopedugedprhgtphhtthhopehighhnrggtihhosehivghntghinhgrshdrtghomhdprhgtphhtthhopegvsghighhgvghrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheps
 ghjohhrnheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgrlhhmvghrsegurggssggvlhhtrdgtohhmpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlqdhmvghnthgvvghssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrhhishgtvheslhhishhtshdrihhnfhhrrgguvggrugdrohhrgh
X-GND-Sasl: alex@ghiti.fr

Hi Ignacio,

On 08/03/2025 13:58, Ignacio Encinas Rubio wrote:
> Hello!
>
> On 2/3/25 23:04, Eric Biggers wrote:
>> So, quite positive results.  Though, the fact the msb-first CRCs are (still) so
>> much slower than lsb-first ones indicates that be64_to_cpu() is super slow on
>> RISC-V.  That seems to be caused by the rev8 instruction from Zbb not being
>> used.  I wonder if there are any plans to make the endianness swap macros use
>> rev8, or if I'm going to have to roll my own endianness swap in the CRC code.
>> (I assume it would be fine for the CRC code to depend on both Zbb and Zbc.)
> I saw this message the other day and started working on a patch, but I
> would like to double-check I'm on the right track:
>
> - be64_to_cpu ends up being __swab64 (include/uapi/linux/swab.h)
>
> If Zbb was part of the base ISA, turning CONFIG_ARCH_USE_BUILTIN_BSWAP
> would take care of the problem, but it is not the case.
>
> Therefore, we have to define __arch_swab<X> like some "arches"(?) do in
> arch/<ARCH>/include/uapi/asm/swab.h
>
> For those functions to be correct in generic kernels, we would need to
> use ALTERNATIVE() macros like in arch/riscv/include/asm/bitops.h.
> Would this be ok? I'm not sure if the ALTERNATIVEs overhead can be a
> problem here.


Yes, using alternatives here is the right way to go. And the only 
overhead when Zbb is available would be a nop (take a look at lib/csum.c).

Thanks for working on this, looking forward to your patch,

Alex


> Thanks in advance :)
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
