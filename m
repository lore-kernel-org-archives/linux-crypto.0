Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9916C00140
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 16:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239254AbiGZQUT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 12:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239222AbiGZQUR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 12:20:17 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE3E1117
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 09:20:15 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id g19-20020a9d1293000000b0061c7bfda5dfso11168821otg.1
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 09:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Gsa9iXNQEVoECudxTAJrnmX98L+cYS5jNdNs8mm18OA=;
        b=AYRk3KUJAUiui6L6IUdP1Y6uFT1x1lKlrikg9E8zJa3v3xEfJJvWUXz44IEXsTfsR9
         G3yg8+0Lw9a1FOhhO0Tr4KNJzF1HeUs3+aVfArzNTqlMJesd79cfhTV0lhjmWkTnrGIO
         Af7tw4mhY2sPb4PBDvpdcn76HvItnO2Rrc/KUquCtwf8WNAtSkrcrdv8TBEfS/L1PnZm
         yTH9nxakXJDrMVmRGGE/bafg/r4/Wjarz6v3HOFiT+8zrqwW0zU1WgIV6LiPawzUMezw
         zGKOaB3Lj503Zmt1jxxQmsaD0dqZRCYxRfr25WXc2PndNuNwfGMdKS6LpKzU6BGoor+c
         X0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Gsa9iXNQEVoECudxTAJrnmX98L+cYS5jNdNs8mm18OA=;
        b=Hu8oSdnnAlIQ0REB1qb8SeXh9auhvKHOo14UavxlAw6NenqKk1laKSTG4vsUmZMV7v
         nGJcEI8+TzRGNSQjrNFMZHYwaSLa0d7Z4Hc7XvCUxoD21CL+xTrwcdpRRUJ1m/iztGvT
         tzv7XhsL3urL1GQqNa4jOGyyxZoTH+JrpIo1049FPun4joQ6TAb5kFMBpOHbPdmPY4l0
         /j3YGpK9CUbMfnb8QoSyeNdmsembXGmmslkfubP7h7WoL1DCdlIj6rc8rz7OHCXmYkt3
         13mQOGimdLQ5Kox6o86etMiffITtWten7j9dccmQU2DzPiuasQBOnPJesINlAcwOYL8O
         T3hw==
X-Gm-Message-State: AJIora9NUB4PEu6YLgn3pzXwaiwY/hGdYmb1o827yNJNka0Qkj2Q1mRI
        DSDQtO0TbgpL8Oja4TZw/Q0gA7IQNi0boQ==
X-Google-Smtp-Source: AGRyM1uYQhRhrHg8dZ/sDmjpMAJvnRA3qlPOlSUxwMDXcQdQn0G+JlWqUlL1rl9qMJVjfedAWuYe8g==
X-Received: by 2002:a05:6830:3689:b0:61c:ae52:e36b with SMTP id bk9-20020a056830368900b0061cae52e36bmr6977693otb.225.1658852415150;
        Tue, 26 Jul 2022 09:20:15 -0700 (PDT)
Received: from ?IPV6:2804:431:c7cb:8ded:8925:49f1:c550:ee7d? ([2804:431:c7cb:8ded:8925:49f1:c550:ee7d])
        by smtp.gmail.com with ESMTPSA id k23-20020a056870959700b000f5f4ad194bsm8180132oao.25.2022.07.26.09.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 09:20:14 -0700 (PDT)
Message-ID: <45ef8ca0-12ca-4853-98a0-9f52dfca8c57@linaro.org>
Date:   Tue, 26 Jul 2022 13:20:11 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.0.3
Subject: Re: [PATCH v4] arc4random: simplify design for better safety
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org
Cc:     Florian Weimer <fweimer@redhat.com>,
        =?UTF-8?Q?Cristian_Rodr=c3=adguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>,
        Mark Harris <mark.hsj@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220726133049.1145913-1-Jason@zx2c4.com>
From:   Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Organization: Linaro
In-Reply-To: <20220726133049.1145913-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 26/07/22 10:30, Jason A. Donenfeld wrote:

> +      l = __getrandom_nocancel (p, n, 0);
> +      if (l > 0)
> +	{
> +	  if ((size_t) l == n)
> +	    return; /* Done reading, success.  */
> +	  p = (uint8_t *) p + l;
> +	  n -= l;
> +	  continue; /* Interrupted by a signal; keep going.  */
> +	}
> +      else if (l == 0)
> +	arc4random_getrandom_failure (); /* Weird, should never happen.  */
> +      else if (l == -EINTR)
> +	continue; /* Interrupted by a signal; keep going.  */
> +      else if (!__ASSUME_GETRANDOM && l == -ENOSYS)
> +	{
> +	  atomic_store_relaxed (&have_getrandom, false);

I still think there is no much gain in this optimization, the syscall will
most likely be present and it is one less static data.  Also, we avoid to
use __ASSUME_GETRANDOM on generic code (all __ASSUME usage within
sysdeps and/or nptl).

> diff --git a/sysdeps/unix/sysv/linux/Makefile b/sysdeps/unix/sysv/linux/Makefile
> index 2ccc92b6b8..2f4f9784ee 100644
> --- a/sysdeps/unix/sysv/linux/Makefile
> +++ b/sysdeps/unix/sysv/linux/Makefile
> @@ -380,7 +380,8 @@ sysdep_routines += xstatconv internal_statvfs \
>  		   open_nocancel open64_nocancel \
>  		   openat_nocancel openat64_nocancel \
>  		   read_nocancel pread64_nocancel \
> -		   write_nocancel statx_cp stat_t64_cp
> +		   write_nocancel statx_cp stat_t64_cp \
> +		   ppoll_nocancel
>  
>  sysdep_headers += bits/fcntl-linux.h
>  
> diff --git a/sysdeps/unix/sysv/linux/Versions b/sysdeps/unix/sysv/linux/Versions
> index 65d2ceda2c..febe1ad421 100644
> --- a/sysdeps/unix/sysv/linux/Versions
> +++ b/sysdeps/unix/sysv/linux/Versions
> @@ -320,6 +320,7 @@ libc {
>      __read_nocancel;
>      __pread64_nocancel;
>      __close_nocancel;
> +    __ppoll_infinity_nocancel;
>      __sigtimedwait;
>      # functions used by nscd
>      __netlink_assert_response;

There is no need to export on GLIBC_PRIVATE, since it is not currently usage
libc.so.  Just define is a hidden (attribute_hidden).

> diff --git a/sysdeps/unix/sysv/linux/kernel-features.h b/sysdeps/unix/sysv/linux/kernel-features.h
> index 74adc3956b..75d5f953d4 100644
> --- a/sysdeps/unix/sysv/linux/kernel-features.h
> +++ b/sysdeps/unix/sysv/linux/kernel-features.h
> @@ -236,4 +236,11 @@
>  # define __ASSUME_FUTEX_LOCK_PI2 0
>  #endif
>  
> +/* The getrandom() syscall was added in 3.17.  */
> +#if __LINUX_KERNEL_VERSION >= 0x031100
> +# define __ASSUME_GETRANDOM 1
> +#else
> +# define __ASSUME_GETRANDOM 0
> +#endif
> +
>  #endif /* kernel-features.h */
> diff --git a/sysdeps/unix/sysv/linux/not-cancel.h b/sysdeps/unix/sysv/linux/not-cancel.h
> index 2c58d5ae2f..d3df8fa79e 100644
> --- a/sysdeps/unix/sysv/linux/not-cancel.h
> +++ b/sysdeps/unix/sysv/linux/not-cancel.h
> @@ -23,6 +23,7 @@
>  #include <sysdep.h>
>  #include <errno.h>
>  #include <unistd.h>
> +#include <sys/poll.h>
>  #include <sys/syscall.h>
>  #include <sys/wait.h>
>  #include <time.h>
> @@ -77,6 +78,10 @@ __getrandom_nocancel (void *buf, size_t buflen, unsigned int flags)
>  /* Uncancelable fcntl.  */
>  __typeof (__fcntl) __fcntl64_nocancel;
>  
> +/* Uncancelable ppoll.  */
> +int
> +__ppoll_infinity_nocancel (struct pollfd *fds, nfds_t nfds);

Use attribute_hidden here and remove it from sysdeps/unix/sysv/linux/Versions.

> +
>  #if IS_IN (libc) || IS_IN (rtld)
>  hidden_proto (__open_nocancel)
>  hidden_proto (__open64_nocancel)
> @@ -87,6 +92,7 @@ hidden_proto (__pread64_nocancel)
>  hidden_proto (__write_nocancel)
>  hidden_proto (__close_nocancel)
>  hidden_proto (__fcntl64_nocancel)
> +hidden_proto (__ppoll_infinity_nocancel)
>  #endif
>  
>  #endif /* NOT_CANCEL_H  */

Also update the hurd sysdeps/mach/hurd/not-cancel.h with a wrapper to 
__poll (since it does not really support pthread cancellation).


> diff --git a/sysdeps/generic/chacha20_arch.h b/sysdeps/unix/sysv/linux/ppoll_nocancel.c
> similarity index 62%
> rename from sysdeps/generic/chacha20_arch.h
> rename to sysdeps/unix/sysv/linux/ppoll_nocancel.c
> index 1b4559ccbc..28c8761566 100644
> --- a/sysdeps/generic/chacha20_arch.h
> +++ b/sysdeps/unix/sysv/linux/ppoll_nocancel.c
> @@ -1,5 +1,5 @@
> -/* Chacha20 implementation, generic interface for encrypt.
> -   Copyright (C) 2022 Free Software Foundation, Inc.
> +/* Linux ppoll syscall implementation -- non-cancellable.
> +   Copyright (C) 2018-2022 Free Software Foundation, Inc.
>     This file is part of the GNU C Library.
>  
>     The GNU C Library is free software; you can redistribute it and/or
> @@ -16,9 +16,16 @@
>     License along with the GNU C Library; if not, see
>     <https://www.gnu.org/licenses/>.  */
>  
> -static inline void
> -chacha20_crypt (uint32_t *state, uint8_t *dst, const uint8_t *src,
> -		size_t bytes)
> +#include <unistd.h>
> +#include <sysdep-cancel.h>
> +#include <not-cancel.h>
> +
> +int
> +__ppoll_infinity_nocancel (struct pollfd *fds, nfds_t nfds)
>  {
> -  chacha20_crypt_generic (state, dst, src, bytes);
> +#ifndef __NR_ppoll_time64
> +# define __NR_ppoll_time64 __NR_ppoll
> +#endif
> +  return INLINE_SYSCALL_CALL (ppoll_time64, fds, nfds, NULL, NULL, 0);
>  }
> +hidden_def (__ppoll_infinity_nocancel)

Maybe just add an inline wrapper on sysdeps/unix/sysv/linux/not-cancel.h, 
as for __getrandom_nocancel:

  static inline int
  __ppoll_infinity_nocancel (struct pollfd *fds, nfds_t nfds)
  {
  #ifndef __NR_ppoll_time64
  # define __NR_ppoll_time64 __NR_ppoll
  #endif
    return INLINE_SYSCALL_CALL (ppoll_time64, fds, nfds, NULL, NULL, 0);
  }

It avoids a lot of boilerplate code to add the internal symbol.
