Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB7F3ED122
	for <linux-crypto@vger.kernel.org>; Fri, 26 Jun 2026 10:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782471002; cv=none; b=Kjyt9jpfDKeo5bSe8pSvm5l7VAe282ct/X9yaWI5zkF6F+VTlAVarwxFIiKkGIUaJ/Q7+byB++t2nr8Usny95OqpLu3DHQFBq0Z87up+lWb/M4peTAjHXuxavmkRotKVAxtdKbppyaP5EqvnYyJ5VKwVnPgoFnbiC9A+1yVVcQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782471002; c=relaxed/simple;
	bh=203pWt4Jm7PC4KEO3FHeYQ3VSYID6CvF/RFcjlJ3oGU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pu9OwJqL+WDXAyaqkTXHxNZtG7I5pXzK96AUytMWhaLN3briJlw8WVTmmYdVmWlGCpNWQ0XPJrerSdm7kcDakJdnz7mvplRc3I8o5QwQBuqY6tYURHGRAPPqNr02FKefHqtgrMGccba7HgNvUXWoJW80u6eC4DKkhaB3BJu3P5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k1ckVfS5; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k1ckVfS5"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490b9318997so6237375e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jun 2026 03:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782471000; x=1783075800; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cT0BDtDugceKAggCQsSGYTrTPkbadSs08NjvUXAN76c=;
        b=k1ckVfS5NPKveV0plkyfHtxOVv+O/OK7HuboKDAW3hYpEQqHKFt21rt3aVRtI2SUmJ
         mVGNL4sF0zCAp93SOInaY05qV0YtE1tzQM2qtc/Ho5Hmvu+DRIXctgXpba5pgbCtkOXD
         JSVWUWuYeOvZv8QreZtn4R1GEU24S2UIFEA9sx2AcZSvLUVg95kf/+6Z0KD4g+Hq/5nB
         u61thapNx0qD/nW2OGUtYP6clsJzBBmFU9S+kpshx3Ev9pBmo7wenRfDEs9VubIA6sxZ
         SoBPG181asyK56eogAXErzP0GcB/RB8XEsnedCBxGOs0q96CTdq/Jtaw264KW3EV9ie0
         VdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782471000; x=1783075800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cT0BDtDugceKAggCQsSGYTrTPkbadSs08NjvUXAN76c=;
        b=m1RRukrOpVqq6wE37BS79eN3SOGv4xr1JJR/v6cLzf8rY6gD/hdzPqrY2AXbP5NQGh
         YbiSMLoytJxOCwsqwlz7qb0sZ6HIFZmAhb7n9Vk53FEUT6c88aEuFrY0Kqbpar6B2qkV
         eThskvzaOVPIEU102uRmEDz21ex/Ez9HYOCe3YReaWZWMpuIPAoM7EbN8N+CvSpGXHss
         Naiookfcl0NJbvaO0TPQ+ghr6+IpTiqO/lIffPm7Iv3Acbm++BQlFrLLi+SWK3xfgSxl
         ipqaB9j29j8LgfAdSGQ1xT9T1YlXdPn+RNIa/cGe1/ss7rWqwIyfXRYHh5ZbgMN29BqL
         tf8Q==
X-Forwarded-Encrypted: i=1; AFNElJ80WV8/WrfxURIEcYRYWbxs/16q8xNNaLqwFrnq/TbGOMrBIWo2yWtmzFFAD69WyOdOvTiH2mhP5CZzqIA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrvlZfCfqskbAjP8wF2ezDhHRXjA65Br/+8eJJ9FJDxdn3F/ie
	GsVmdyUO11/wJLyri0ajDwynP3yxBLhCJpuwra7UmiD4bNV1cnm24OHg
X-Gm-Gg: AfdE7clsOCS4vVtR06yQtfZI9HKj9wO7FbVNxvYnujI6UvaElIlo7DJNs5QChzpYU65
	QgadW8w4gzqo0byqDHrRblpkkAWOILDHUx4IqffvFBPfnIaTSp68f3H6lRhtbMj6H68+tWPvM77
	0V3mNabG8USi4AlazPt1bgg77MwJpK8eYXNrnOcC12DLGHxAZblICdn+llEH8+8MYuDWpoEmj9L
	0jxo0Wx4xKxNZkRs5mOj1waDdpvDZHkTGWweriL+X07eA3NV8MefvZN/f8FJ4ph7hwaL8mVOBAJ
	K90gICcGxiMKKW6R/qTTkEkF6xzuhLdPilE+9Jy1z0m3QMXXQp0HbLDPKjjvQUSu+WSvHHb5iV+
	56mQ00/icjJJjYJ1VgaLxagB66cQlwEtuLQyL406FF9f8sfBS8zU7w7vkLQzKQkdSGXL9yBh/tK
	SXDREIHPrl7PqdlMobDUi6VIM0oiM1coXyW4D4cfhsTApfJ8Jdfw==
X-Received: by 2002:a05:600d:8494:20b0:490:5cb3:e94a with SMTP id 5b1f17b1804b1-4926684a83fmr72058605e9.2.1782470999554;
        Fri, 26 Jun 2026 03:49:59 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d9371sm25352587f8f.21.2026.06.26.03.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 03:49:59 -0700 (PDT)
Date: Fri, 26 Jun 2026 11:49:57 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Eric Biggers <ebiggers@kernel.org>, x86@kernel.org,
 linux-um@lists.infradead.org, linux-raid@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph
 Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/8] um: Check for missing AVX and AVX-512 xstate bits
Message-ID: <20260626114957.1a2b7e5b@pumpkin>
In-Reply-To: <6a20b442-b97f-4cae-9168-30201d5ef82c@cambridgegreys.com>
References: <20260626043731.319287-1-ebiggers@kernel.org>
	<20260626043731.319287-3-ebiggers@kernel.org>
	<20260626084113.42eae31c@pumpkin>
	<6a20b442-b97f-4cae-9168-30201d5ef82c@cambridgegreys.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Jun 2026 09:21:49 +0100
Anton Ivanov <anton.ivanov@cambridgegreys.com> wrote:

> On 26/06/2026 08:41, David Laight wrote:
> > On Thu, 25 Jun 2026 21:37:25 -0700
> > Eric Biggers <ebiggers@kernel.org> wrote:
> >   
> >> If the CPU declares AVX or AVX-512 support, verify that all the
> >> corresponding xstate bits are also set.  If any are missing, warn and
> >> don't set the corresponding X86_FEATURE_* flags.
> >>
> >> This eliminates the perceived need for UML-supporting AVX and AVX-512
> >> optimized code in the kernel (that is, lib/raid/ currently) to start
> >> checking the xstate bits in addition to X86_FEATURE_AVX*.
> >>  
> > ...  
> >>   static void __init parse_host_cpu_flags(char *line)
> >>   {
> >> +	u64 xcr0 = read_xcr0();
> >>   	int i;
> >> +
> >>   	for (i = 0; i < 32*NCAPINTS; i++) {
> >>   		if ((x86_cap_flags[i] != NULL) && strstr(line, x86_cap_flags[i]))  
> > 
> > 'line' comes from /proc/cpuinfo
> > Surely something would be terribly wrong if that included something the kernel
> > had disabled (or didn't support).
> > 
> > 	David
> > 
> >   
> >> -			set_cpu_cap(&boot_cpu_data, i);
> >> +			validate_and_set_cpu_cap(i, xcr0);
> >>   	}
> >>   }
> >>   
> >>   static void __init parse_cache_line(char *line)
> >>   {  
> > 
> > 
> > 
>  >  
> Lots of other stuff will go wrong before that. Glibc, things compiled with LLVM, python, perl, etc.
> 
> Half of the userland will go belly up, because AVX is used in string operations and hashing if it is available.

And glibc will check xcr0.

> 
> UML is just another userland application from this perspective, so there is no reason for it to behave any different from the rest of the userland.

