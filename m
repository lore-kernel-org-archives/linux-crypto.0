Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7F2204596;
	Fri,  6 Dec 2024 20:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733518161; cv=none; b=HIWDMqVmYI39FeEDc+khWK1qYYidJ1gL4/wW2I27vzt4ue2ETTlVEc6FnRNmzPJmfgGC3EXS4aVH7i2SFaRamA5doUPihEUX+2UkbUAJ3svMiSQsTcw3WV+HH4R1NivC07GODkZSmjcD6MyRDRU0AFRK1rrw8iDrlJ6dhqVr+oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733518161; c=relaxed/simple;
	bh=NQEA2lB9T9/wPzVSEPwWnQWXojD+VqCwm2lpgX43Roc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NBxufqG+u0mGLXV0CpaJVxAh/4h9Q3c0HGf7VljG2wc00yP5FrROLAyeRlrWLuILjqMqfHt0FhX4ZcfvlmcQiQkS9rXJHfKOc0aXUYQjlOnfkN29Diq5eXUMqJSZRwwW0GcxSkDZDHP9BXTCI1qpBQEcUZwW+8JowPunQzsUIXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cICChNTW; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cICChNTW"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ee8e8e29f6so1969217a91.0;
        Fri, 06 Dec 2024 12:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733518159; x=1734122959; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hZd4xUDMM03XI/1ByYEAJjNBA2EJ8K++HTyrnX16JD4=;
        b=cICChNTWJXt3a6JuLAvpc/yYj2L9TwBCzWp2KIGxVMVRMPrT3NtzqvQk2eRGS3nN2U
         Jm5HOq7P40PY0dk4I9dwMrBWSz0CX+2CRtkelmhwYvrlLOnh+JTs2kQQLhKK+Ai51v0m
         80deiEIoFvjy0N2UZoevZJr/kRE6s76KPCvEU23xsS3Vo8e/HBdSM+O/Ve7+uC1GJJKA
         k4YChsb89CLP0ZGgTt8VMH/P/4DPYKMV2nWDY8m0GrAAStTMtJXv2Gm69L9baRClKzzK
         tUiBW2VfUk+fpR2XT6pKK2zJYNQX5kYnjnKOpJTnNQRaJyMPIUoA6nqt1syxUeiYfQkR
         coKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733518159; x=1734122959;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hZd4xUDMM03XI/1ByYEAJjNBA2EJ8K++HTyrnX16JD4=;
        b=GoPQH12CVSWcO2JQaXv6edrf05sRjJhIwekjYk8xzLWf0RMBFaURUA0BMk4arD999V
         DgfQdM+qgcysFjb5dzcQ6CjxY7Mf1pdlfBFIhWvb/BUF5k1fzqyYpP1vZqNMzEx5TkfA
         7PMUXAQPf3yue1fxULThnJY/TtInpkO+8UGFaz92aDt4g1xrF4oHeWLlhh5bwFkrntTB
         XxcW7VQWV3CPRR7f3dzLqp9tQAWEbFMuXbZjWGtmbd33IphIPsxYYiKb0sddRzMDVzhj
         TUhrvmPDie/Z6V9WwBzN0/V7Y+bSY9DRqoTQbYV4hfMggTOTlG9ePK66a3FaJEsjzJmK
         REhA==
X-Forwarded-Encrypted: i=1; AJvYcCXWfICCsc4eA8rH3VG9kUjMju7tm/ExAsa2ouZp86Wy1H2RrNMsScFrR1+UAJS9xfRFC52/6bzDXu3BdtA=@vger.kernel.org
X-Gm-Message-State: AOJu0YytbNP/N+rHW5LMGrGUja8+f5VSov+AZCtJpAHZymlKpUTlxAcC
	cndA9+uliP39E8ytliHbROMCtvJBmakqItfdMFfqhxQNArDZ5rPl
X-Gm-Gg: ASbGnctAylHgmaoq3toEiJyKEgNET8gK5K0uxXM9HG/rm0WAbSom82zkSshFlxqyIhk
	dxj5c18fjSFrug57tfjFqJIpwX55kZ5ofzihZng2GYSkQ+xiIRYrWIMBazMGDCp6lJbHkbzYh1u
	QW9PVm9sIHJyYDvdg1Rw8UqtzqOqwiQCGclpd2hyG11f+1DplX9LvXI41vAzGj9CbfZsU8YZ1ri
	roLw34MoBS2nVh6j9VyiVRaz570fIAjsH5GwIYbvUhkus/Fyg==
X-Google-Smtp-Source: AGHT+IGJVrmBy31vZhXtZK6qYkNrzulb0ZKB2FLrTgbi9oxdqbvApQjgZn7xFoepcMFq6nIbnCPUDA==
X-Received: by 2002:a17:90b:1dc5:b0:2ee:fc08:1bc1 with SMTP id 98e67ed59e1d1-2ef6ab25c8dmr6986305a91.37.1733518158884;
        Fri, 06 Dec 2024 12:49:18 -0800 (PST)
Received: from localhost ([216.228.125.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725a2a90371sm3456333b3a.128.2024.12.06.12.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2024 12:49:18 -0800 (PST)
Date: Fri, 6 Dec 2024 12:49:16 -0800
From: Yury Norov <yury.norov@gmail.com>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, briannorris@chromium.org, kees@kernel.org,
	nathan@kernel.org, steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com, linux-crypto@vger.kernel.org,
	linux@weissschuh.net, gjoyce@ibm.com
Subject: Re: [PATCHv2] cpumask: work around false-postive stringop-overread
 errors
Message-ID: <Z1NjTCFmu8QKY7P5@yury-ThinkPad>
References: <20241205123413.309388-1-nilay@linux.ibm.com>
 <Z1HTdtvNjm-nZSvJ@yury-ThinkPad>
 <9c99c993-c8b5-483e-af87-c94373e14e80@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c99c993-c8b5-483e-af87-c94373e14e80@linux.ibm.com>

On Fri, Dec 06, 2024 at 02:39:58PM +0530, Nilay Shroff wrote:
> 
> Thank you Yuri for insightful comments! Please see my responses inline...
> 
> On 12/5/24 21:53, Yury Norov wrote:
> > On Thu, Dec 05, 2024 at 06:04:09PM +0530, Nilay Shroff wrote:
> >> While building the powerpc code using gcc 13, I came across following
> >> errors generated for kernel/padata.c file:
> >>
> >>   CC      kernel/padata.o
> >> In file included from ./include/linux/string.h:390,
> >>                  from ./arch/powerpc/include/asm/paca.h:16,
> >>                  from ./arch/powerpc/include/asm/current.h:13,
> >>                  from ./include/linux/thread_info.h:23,
> >>                  from ./include/asm-generic/preempt.h:5,
> >>                  from ./arch/powerpc/include/generated/asm/preempt.h:1,
> >>                  from ./include/linux/preempt.h:79,
> >>                  from ./include/linux/spinlock.h:56,
> >>                  from ./include/linux/swait.h:7,
> >>                  from ./include/linux/completion.h:12,
> >>                  from kernel/padata.c:14:
> >> In function ‘bitmap_copy’,
> >>     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
> >>     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
> >> ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
> >>   114 | #define __underlying_memcpy     __builtin_memcpy
> >>       |                                 ^
> >> ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
> >>   633 |         __underlying_##op(p, q, __fortify_size);                        \
> >>       |         ^~~~~~~~~~~~~
> >> ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
> >>   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
> >>       |                          ^~~~~~~~~~~~~~~~~~~~
> >> ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
> >>   259 |                 memcpy(dst, src, len);
> >>       |                 ^~~~~~
> >> kernel/padata.c: In function ‘__padata_set_cpumasks’:
> >> kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
> >>   713 |                                  cpumask_var_t pcpumask,
> >>       |                                  ~~~~~~~~~~~~~~^~~~~~~~
> >> In function ‘bitmap_copy’,
> >>     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
> >>     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
> >> ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
> >>   114 | #define __underlying_memcpy     __builtin_memcpy
> >>       |                                 ^
> >> ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
> >>   633 |         __underlying_##op(p, q, __fortify_size);                        \
> >>       |         ^~~~~~~~~~~~~
> >> ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
> >>   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
> >>       |                          ^~~~~~~~~~~~~~~~~~~~
> >> ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
> >>   259 |                 memcpy(dst, src, len);
> >>       |                 ^~~~~~
> >> kernel/padata.c: In function ‘__padata_set_cpumasks’:
> >> kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
> >>   713 |                                  cpumask_var_t pcpumask,
> >>       |                                  ~~~~~~~~~~~~~~^~~~~~~~
> >>
> >> Apparently, above errors only manifests with GCC 13.x and config option
> >> CONFIG_FORTIFY_SOURCE. Furthermore, if I use gcc 11.x or gcc 12.x then I
> >> don't encounter above errors. Prima facie, these errors appear to be false-
> > 
> > If it works for pre-GCC13, and likely for clang, you shouldn't disable it
> > for them. It should be enabled for CONFIG_FORTIFY_SOURCE=n, as well.
> > 
> > Check config CC_NO_ARRAY_BOUNDS for an example of how versioned flags
> > are implemented.
> > 
> 
> >> positive. Brian informed me that currently some efforts are underway by
> >> GCC developers to emit more verbose information when GCC detects string
> >> overflow errors and that might help to further narrow down the root cause
> >> of this error.
> > 
> > I'm 100% sure that Brian is a great person and his information is
> > absolutely correct and complete. But this is just not how we write
> > commit messages.
> > 
> > Please avoid personal references, vague statements and news from
> > the future.
> > 
> Sure, I would do the needful for future patches.
> 
> >> So for now, silence these errors using -Wno-stringop-
> >> overread gcc option while building kernel/padata.c file until we find the
> >> root cause.
> > 
> > You didn't provide any evidence that this warning is specific for padata.
> > 
> 
> Let me just show you the test matrix for the stringop-overread error:
> 
> ARCH PowerPC:
> compiler    CONFIG_FORTIFY_SOURCE    -Werror=stringop-overread
> gcc 11.x     Y                         N
> gcc 11.x     N                         N  
> gcc 12.x     Y                         N
> gcc 12.x     N                         N
> gcc 13.x     Y                         Y
> gcc 13.x     N                         N
> clang 18.x   Y                         N
> clang 18.x   N                         N
> 
> ARCH x86_64:
> compiler    CONFIG_FORTIFY_SOURCE    -Werror=stringop-overread
> gcc 11.x     Y                         N
> gcc 11.x     N                         N  
> gcc 12.x     Y                         N
> gcc 12.x     N                         N
> gcc 13.x     Y                         N
> gcc 13.x     N                         N
> clang 18.x   Y                         N
> clang 18.x   N                         N
> 
> >From the above matrix, we could see that the sringop-overread error is only encountered
> when we use gcc 13 on PowerPC machine and the stringop-overread error is seen only when we 
> enable CONFIG_FORTIFY_SOURCE. Furthermore, so far I've only encountered this error while 
> compiling kernel/padata.c file. 
> 
> > And indeed the subject states that this is a cpumasks-related warninig.
> > Cpumask is a global subsystem. If you believe that this warning is
> > false-positive, it may show up for any other random victim. Please
> > suppress it globally.
> > 
> Yes you were correct, this warning might appear for any other random victims. But as 
> I mentioned earlier, so far I've only encountered it with kernel/padata.c file. 
> So, if we want to reduce the blast radius then wouldn't it be sufficient to just silence 
> it only while compiling kernel/padata.c file? Or do you still suggest disabling it at
> global level would be more helpful? I'm OK with either way moving forward. Please let 
> me know.

You will reduce the radius significantly if you limit sringop-overread
suppression to a specific config, compiler and architecture. Silencing 
random files is a gambling.
