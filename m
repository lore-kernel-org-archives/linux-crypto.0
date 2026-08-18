Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC750420485
	for <linux-crypto@vger.kernel.org>; Tue, 18 Aug 2026 08:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787043243; cv=none; b=ItcfR2vsxC2YdlbVneZwUSd9DXTBtxvzH2x9v3QEG5MmwjqcUGnsOAHnLhQiPXHywW4FigtQjadKXG7s1xJCkNTqNuNOMr+8wiPWR7k4qQfziinxbfe9vIEQbcaIIChBEv3m+eWCdFibetuypWZzR3PZHUWkYBGbSpYNnA/iFH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787043243; c=relaxed/simple;
	bh=BRBqclakuJSrqoUrzNR923rzUiJVaD/pyI7+lgPChmU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UQK17mcA+85a53ROsmsObNZ7ojGKcby6CIOaieY36yJV8KqOxdHbDGSwuRTvTYDDqsHPFVsyCCGeW8zzf7nxYwdZDA6+Gn4Z69ITax+sxVWAIzf/nxpwCkBT/R17234QzHTtV1aMlOevg2pHgP2GLlTOOUO8uTP5xGC0nypd/XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qk8P1Aym; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iicnHPxN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qk8P1Aym";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iicnHPxN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787043240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CMJnkJ88VUdXuXfoihnWNaJTjZl0nlhmsfAU8nGEPNI=;
	b=Qk8P1Aymy992T3gPeqqBRm1IyNhqAC9P+hJVzO7Ya47e6o78Y+VnWqHP3x7icnuwDpiA51
	A7ZZyuYqRTpw3FMMT0PmoxTAO8eICBUMY9lzH2S6n2PzwKOiDxb8W0iMum4UgLcMaEyMoV
	lJTDBgnAzUN+3WMOEIFhMO+AOKsRCec=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-SB5efR-RNg-Qf2IgHIDZkg-1; Tue, 18 Aug 2026 04:53:59 -0400
X-MC-Unique: SB5efR-RNg-Qf2IgHIDZkg-1
X-Mimecast-MFC-AGG-ID: SB5efR-RNg-Qf2IgHIDZkg_1787043238
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso37037445e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Aug 2026 01:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787043238; x=1787648038; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CMJnkJ88VUdXuXfoihnWNaJTjZl0nlhmsfAU8nGEPNI=;
        b=iicnHPxNhdaGxlIR7Qa+Y7qCy1bCQeVb6qpYIYg5jo/YTRAAbqPINg+POMw+120v2O
         bVO1AekAKE6cuGBckRvHDDzePJ1LLlOztsqSWB15SNi6r2ErIw84o/WgjHEyxAXVhqwk
         X+HYndkx+2Bw3U63ISs6FQarTbYi22zAx9pFEbf6jgVz5uGYzVnyNOxK7mxtAIxXMbw4
         BkXZfWebGzXx/rgivel0rPqv/G8y3e+T8F/xWTjHO/Pcsfs0YmlH2tePNXYQICkVjCqI
         idewi7kvTrJljmSU0cItHukWE2LPMhWjzNcsDok1gGPKMGpsdLiGZiF0Hdj9/n4AlldL
         ll1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787043238; x=1787648038;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CMJnkJ88VUdXuXfoihnWNaJTjZl0nlhmsfAU8nGEPNI=;
        b=Ch3obwPNM3z1+OrEAhuw9wHGhkLyPEglfoTOgbmrkPwq4FVgSjjjLcdjWbQG0bk4/s
         pFqNY66vxGkfdWL3JKgUqPEVADykBxoX9yfQqt0Kd64NAUWLZX7+eFrZEKuIuwRx7Zfj
         tEpInOdq02/VtwkJ/ZteaPcLVmEoAsZ/8IH5tHiM73kfqqhF6JQJoQTwGhrjI0YwxC7y
         82CZjepEprGuyw5ZkrTDj5AIaoVdMCIn9JkWZ1yHuIskqArKUnUFjpgOMcmQpRvgy7oY
         0BY2li2qH6+4HHEMOWD0Y2wvlAS2r4Iroh8OqTZuy0WfBEghznPnkwV9nvuzXlN8Uiay
         k8Pg==
X-Forwarded-Encrypted: i=1; AHgh+Rq/QDtACWxH2yYjEAPmqSHq5djdkIC3xuEiGn9peX6h2s41Rmj0CsJFQ+1vS6A12u5BLmZgJumbOeCIqI8=@vger.kernel.org
X-Gm-Message-State: AOJu0YytOe+RRGw+dlBPYSswltGk5Tasyy7Y9EV9tzBsy4w3vJ2H16wK
	Ag0BepJ3dd20dVnSaL69IiexqkDq90Q0mk8R8TMLabLmMDhFd6UN9lnlX2XL6h7kLytbwzHNKdA
	qSfmkSf0lxb//SJMEmy3UPzPdYvubwnvJjLr+l/wBX6qgfmo2HD/n3mhcdKGdj2OnzQ==
X-Gm-Gg: AR+sD13dHznxGiT7wgZOrF2u6I04VouG3JU9Y/3HQ2Ipv4yHQ2RkebZiwnbJiYCqrLT
	EM/Jgkp5e5e18S1ybNjUf6iCMix7jp655HoYNgBhgp/lSMX07s8h2OljVvdoCuO5z3Hzvc66fP0
	WzDN9speUwlomWwIfBB0ZoHRbelSri0WWOV0GQYDKEJ7/kLqoJuL+TApz7fDIhtB3foQppkmMdS
	TPoZWzpulesP/VoXK/nNktZQTCX34wRklEbw7RCBN6r3ezpX32XLKQP+rrFHb1CI6moT2Yf/9Ae
	0Jx1PW82DrSvdCoVjbix0auOQ0EL3xHx5hZ4oWA6Klj4/ULFZ+04yP85hY3EdSVpLjAnm2k=
X-Received: by 2002:a05:600c:4e56:b0:499:a69d:e14b with SMTP id 5b1f17b1804b1-499a69de2fbmr12309745e9.4.1787043237844;
        Tue, 18 Aug 2026 01:53:57 -0700 (PDT)
X-Received: by 2002:a05:600c:4e56:b0:499:a69d:e14b with SMTP id 5b1f17b1804b1-499a69de2fbmr12309405e9.4.1787043237494;
        Tue, 18 Aug 2026 01:53:57 -0700 (PDT)
Received: from [10.22.3.81] ([91.26.127.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999d10be27sm141261325e9.14.2026.08.18.01.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 01:53:55 -0700 (PDT)
Message-ID: <7d373eca-c23c-4f79-9391-29d75bd5a53f@redhat.com>
Date: Tue, 18 Aug 2026 10:53:53 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/11] x86/purgatory: Compile purgatory.c with
 -D__NO_FORTIFY
To: Borislav Petkov <bp@alien8.de>
Cc: Eric Biggers <ebiggers@kernel.org>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20260813134953.979481-1-thuth@redhat.com>
 <20260813134953.979481-11-thuth@redhat.com>
 <20260814152457.GBan8zSeYlWd_1oWkz@fat_crate.local>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260814152457.GBan8zSeYlWd_1oWkz@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/08/2026 17.24, Borislav Petkov wrote:
> On Thu, Aug 13, 2026 at 03:49:48PM +0200, Thomas Huth wrote:
>> From: Thomas Huth <thuth@redhat.com>
>>
>> purgatory.c includes both, the <crypto/sha2.h> header and the
>> arch/x86/boot/string.h header. The latter provides its own prototypes
>> for a lot of string functions which clash with the fortified macros
>> from <linux/string.h>.
>> The next patch will add #include <linux/string.h> to sha2.h to be able
> 
> This is exactly the problem - people are adding main include namespace headers
> from linux/ to arch/x86/boot, or, as you do, to purgatory, which are special
> - and then they have to do all kinds of hacks so that it builds.
> 
> (btw, there's no "next patch" in git history).
> 
>> to use memzero_explicit() there, so we have to compile the code in
>> purgatory.c with -D__NO_FORTIFY to avoid compilation problems in this
>> file.
> 
> How about you extract memzero_explicit() to a separate header in
> include/asm-generic/ or simply put it in include/asm-generic/string.h and then
> use that header instead?
> 
> Then you shouldn't have prototype clashes...
> 
> It does sound cleaner to me but you'd have to try it to see whether it
> actually works.
Thanks for the suggestion, I gave it a try, but I only ended up with another 
huger ugliness this way: Since memzero_explicit() needs memset(), that 
memset() has to be declared somewhere. Since I cannot include 
<linux/string.h> from the file where I put memzero_explicit(), we would need 
to make sure that all files that want to use <crypto/sha2.h> include either 
<linux/string.h> or arch/x86/boot/string.h or whatever before including 
sha2.h - i.e. this creates a likely unacceptable indirect dependency of 
sha2.h on including a string.h header first.

Adding the -D__NO_FORTIFY to the purgatory Makefile sounds like the lesser 
of the two evils to me, especially since there is already another line in 
that Makefile that adds -D__NO_FORTIFY to one of the other files there:

  CFLAGS_sha256.o := -D__DISABLE_EXPORTS -D__NO_FORTIFY

Maybe I should rather change the patch to add -D__NO_FORTIFY unconditionally 
to generic PURGATORY_CFLAGS there? Something like:

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -11,7 +11,7 @@ $(obj)/string.o: 
$(srctree)/arch/x86/boot/compressed/string.c FORCE
  $(obj)/sha256.o: $(srctree)/lib/crypto/sha256.c FORCE
         $(call if_changed_rule,cc_o_c)

-CFLAGS_sha256.o := -D__DISABLE_EXPORTS -D__NO_FORTIFY
+CFLAGS_sha256.o := -D__DISABLE_EXPORTS

  # When profile-guided optimization is enabled, llvm emits two different
  # overlapping text sections, which is not supported by kexec. Remove profile
@@ -37,6 +37,7 @@ PURGATORY_CFLAGS := -mcmodel=small -ffreestanding 
-fno-zero-initialized-in-bss -
  PURGATORY_CFLAGS += -fpic -fvisibility=hidden
  PURGATORY_CFLAGS += $(DISABLE_KSTACK_ERASE) -DDISABLE_BRANCH_PROFILING
  PURGATORY_CFLAGS += -fno-stack-protector
+PURGATORY_CFLAGS +=  -D__NO_FORTIFY

  # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
  # in turn leaves some undefined symbols like __fentry__ in purgatory and not

WDYT?

  Thomas

