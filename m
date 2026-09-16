Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528474E3EEE;
	Wed, 16 Sep 2026 10:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789554285; cv=none; b=DN1ewTRsKbWXZDmMSkJh8qVn/D9GaoMELttwMQHKTxT6RGIVCQOEgGMWEU+pe0rRYLor8jt4bUDx9WBBzn8Xn1b2abQa44ciZUTOgoUh3oRJxom+x1vhAGqaO1R4KYzN5PA7KbbRFFg6Vt3zxHgzvfD2YeR6qgxBOIpCChQ+eIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789554285; c=relaxed/simple;
	bh=CAFwzG14G8lE38ZHp/ZNgWiY9OzUz61TY9T4d8a2jXk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Ra3gM+/ESYESJ6miK6WI3/tTA92+Mezt3zUq/3MiwCeYdxrRCEUDxAEtxFwcN7d9I1EH5GkrpAtqFGcLAn+abfA4BNsg+u5QLEWCS+vUd0IXpbEaWjOtShzVf52ximcrwaSacCbkq3ApTbBR4ZS72TFw0FIWZYrp7hbxgWf/nt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNr7b8+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNr7b8+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7EA1F00893;
	Wed, 16 Sep 2026 10:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789554268;
	bh=/8KFOagu2ENcQCp8QY4nI5XKHph2UK8Vkc307vgiZoE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=ZNr7b8+T2n5UB/xLF1JyrGAxqHINHmTyET0UHrtU1mZR1qSoiOAXljDx02S0v6/A5
	 tV3ohsaYgR5bD3wWjJqFqmBJHb33QIEjDiG89PWaTmhiaW7/pZsC5fffi8D9FOB1UE
	 XdIi3ZYxmqHiWbD1uJJJRCP1A/f596VcWuJ9jMIASN69kcakdRRy22i8VXe2qsLkMb
	 gKmBvggI3Q8JPpa6yTwWVSiWCKSGUKbtpafGT4B3LqdVhlWgY7QTJidbvre0CN9iF/
	 TbPP9Xl1jJXJCcQou/I/ZcshdwMhll2nE17RLYEfG3RRD3nqWF+UfYpB5DSJ6ZAB8l
	 q1iTMGWuVgnhg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 5C7FE198003A;
	Wed, 16 Sep 2026 06:24:25 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 16 Sep 2026 06:24:25 -0400
X-ME-Sender: <xms:Vm6qatHUCx2TAkNxviyEAJJzADOXy4L1Vyv29BLxYrB0KFd837xPnA>
    <xme:Vm6qatI2eElCEMu6O3vufPHuinfdQ0HFfn5W5rTM_3dsiy_FACtTL7OIt1P9xt4qV
    cxOuX_9olbv6xBS6TXF_Z9SK5tEF_PPEOSRsJQST42vcpfrwDCMO3Y>
X-ME-Proxy-Cause: dmFkZTGK+vKUpRZP/PjGOSOsca6vga2HCB0cn/adgVCawoeih5dxrjPEYysN7hknm/kTqW
    yO/dNMgXdPdaxuAai+nGFaE3nS1Vya9aYKmvwLEKoKcXFwfI9uA/mpFOm5hpTr05kdN5ZX
    fkFNIawIWHslpzH19voOYNEyDMBG0SWkjz2807wRtp1FZraQ3apZ608LRk6tmDo0gIj7Y8
    YiwgT7xncQJx11QZck3yIWFBafUDdHtRClWVTjlI/f0hZwM0hpdrZV6PPWu6nD2ZO9kmRt
    d5GdO1uXNlBexM/pOz57zNEGcmBH1CPKsV0U2H37Wdyumc8Mo13nfMtV5KFbNI7wQe+UCh
    zWCQsyrY2wUsThV20iJLhKjd5d95p/6w09A7NbRxtTcjxYcB+UT7v3giuuoRUD6yEB/6sK
    xs/zIumIIX54lv7ohu2Ml6MduWdWXDpW+wErQsJl/ql0ZIcR+YQeHtWch33EAYM0CmNV59
    WyAYqWLS4w49LyF/U10CUTVfjja5H1ejxE2nmzXC1GJ+fRPhHPNgY9QiffQfwdIsE+i5iB
    uAPL0JdIpRNVTQQl4L7HKqns1qbVZUI/F5dlhPtJPvpzEJ9dN4XEVpXXRTJFV7EIUj4hpe
    zb1+CTyO9O0yWgSnCtjXjjng+KF/YW20p3lpfskcXHdPq2DbmVQsnrCWWDwQ
X-ME-Proxy: <xmx:WW6qag-gDPKnzFFkzKpJdTQSnqbG0fkTJA-UXHAGmo3--EePbplQgQ>
    <xmx:WW6qaoTfH5UOXHXmmQrnH2cTjaVDmcmj5NAX3f0NXSBEn_fTNwmVag>
    <xmx:WW6qaqVWjolNQmuRvR6baq0bkURVj4-D4527VS6UHr0TbOaxhWpopg>
    <xmx:WW6qai-ib6qztNBcrCsGojuJujNDxzbJypp_6uAGQrzTOtcd5zalLw>
    <xmx:WW6qai3ZTWXYu_cBBLB9fYg7BsUQM9sNNGLJTzmP1FwVeQ6jScDegsdC>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 7B5EAF8007E; Wed, 16 Sep 2026 06:24:22 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 16 Sep 2026 12:24:02 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Thomas Huth" <thuth@redhat.com>, "Borislav Petkov" <bp@alien8.de>
Cc: "Eric Biggers" <ebiggers@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>, "Thomas Gleixner" <tglx@kernel.org>,
 "Ingo Molnar" <mingo@redhat.com>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, "H . Peter Anvin" <hpa@zytor.com>
Message-Id: <9c9e3958-865c-4be3-8f52-be91e090f2ae@app.fastmail.com>
In-Reply-To: <7d373eca-c23c-4f79-9391-29d75bd5a53f@redhat.com>
References: <20260813134953.979481-1-thuth@redhat.com>
 <20260813134953.979481-11-thuth@redhat.com>
 <20260814152457.GBan8zSeYlWd_1oWkz@fat_crate.local>
 <7d373eca-c23c-4f79-9391-29d75bd5a53f@redhat.com>
Subject: Re: [PATCH 10/11] x86/purgatory: Compile purgatory.c with -D__NO_FORTIFY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 18 Aug 2026, at 10:53, Thomas Huth wrote:
...

> Maybe I should rather change the patch to add -D__NO_FORTIFY unconditionally 
> to generic PURGATORY_CFLAGS there? Something like:
>
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -11,7 +11,7 @@ $(obj)/string.o: 
> $(srctree)/arch/x86/boot/compressed/string.c FORCE
>   $(obj)/sha256.o: $(srctree)/lib/crypto/sha256.c FORCE
>          $(call if_changed_rule,cc_o_c)
>
> -CFLAGS_sha256.o := -D__DISABLE_EXPORTS -D__NO_FORTIFY
> +CFLAGS_sha256.o := -D__DISABLE_EXPORTS
>
>   # When profile-guided optimization is enabled, llvm emits two different
>   # overlapping text sections, which is not supported by kexec. Remove profile
> @@ -37,6 +37,7 @@ PURGATORY_CFLAGS := -mcmodel=small -ffreestanding 
> -fno-zero-initialized-in-bss -
>   PURGATORY_CFLAGS += -fpic -fvisibility=hidden
>   PURGATORY_CFLAGS += $(DISABLE_KSTACK_ERASE) -DDISABLE_BRANCH_PROFILING
>   PURGATORY_CFLAGS += -fno-stack-protector
> +PURGATORY_CFLAGS +=  -D__NO_FORTIFY
>
>   # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
>   # in turn leaves some undefined symbols like __fentry__ in purgatory and not
>

This seems like the right solution to me.
