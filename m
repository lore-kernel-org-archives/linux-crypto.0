Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CF7C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 12:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbiGZMfD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 08:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiGZMfC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 08:35:02 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC5F27CCB
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 05:35:00 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-10e45b51f77so174148fac.7
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 05:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=FJ9JsRUp7FfZoVaySCC5fYAoj5CWeED5W80oPdgkDq0=;
        b=ta3aviX1MV6oTPbFKP41v8EsZlKxgj4sMaBwbehSUlmu1LBcCSGmwK09ra7pDsdDH3
         kqB+M8De8cLgmbSHczuotk4T98bnNBo+psEG+8ZPH/KB/jqdyHyK7/FAUVMku7s1QNXT
         ZLJoY8ZfrnWPWMicXLn9GY/zk31FegBoBqtcpBUKXhwp0rz8OZfyY+C2SjZFfNJ+ZA0h
         a95k4BEwHzBfNavtvFALzsj0F0CSrvLSrr2T5hfjYe5A09hzEPbgMksTFx6nfD7gs2TD
         366uGHTq+li7X9V9UzQ6/fraM7I9IaoL55tb1rD87TO3Si7xVN3UBN3q29oLehGA32Sk
         xsLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=FJ9JsRUp7FfZoVaySCC5fYAoj5CWeED5W80oPdgkDq0=;
        b=GUjaKpIkcYA+60KI1vQuQkTCRjIJVPmXqbBQCaXZL2AaF7rYff2FmV/ulaAKRH3lLo
         0gRjTA88iFgwkUrREGjvG7c7sp38+/IgR8T9uDMc4wxSQ9fGvznDWZVr1OBKdP7Np9m7
         2n0ULOPk60FHFqDU48cruyPV+dHn3o2TOkT4RCnXI5x6PHMc1Fauj+BPWuao4S6581ty
         GuX5kCnVb/WPmIPGgqtou19O+GevVxb8poGYTB56s2lAB+E9U5pMNjAIPnik7dVwCHtK
         ANdcproSnn2pM7hKbOIcLJZGqsD2NrK2r7/ys+tnUVrK3moIlZfjz3+IZBzr5h4wz0s4
         K9kA==
X-Gm-Message-State: AJIora8RS28DkI/vBZ/zXMc4kXMm2Q0fNSgGUPxiK0rJzQkLA2+kr5co
        3HNAmkvs4D+qi3aUPJog/MXKEg==
X-Google-Smtp-Source: AGRyM1vzH0TKNRTqVGbTziK3xmYNFvhlSoxRMKk4QwTgRGJAxleGRc25n3QhmaW5PCaKr1jMLY5WmQ==
X-Received: by 2002:a05:6870:d788:b0:10d:7bec:b302 with SMTP id bd8-20020a056870d78800b0010d7becb302mr17467760oab.2.1658838899948;
        Tue, 26 Jul 2022 05:34:59 -0700 (PDT)
Received: from ?IPV6:2804:431:c7cb:8ded:8925:49f1:c550:ee7d? ([2804:431:c7cb:8ded:8925:49f1:c550:ee7d])
        by smtp.gmail.com with ESMTPSA id z17-20020a05683008d100b0061c9c0e858fsm6001174otg.70.2022.07.26.05.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 05:34:59 -0700 (PDT)
Message-ID: <e173ceb3-9005-fc36-8a21-f6f64f038ab6@linaro.org>
Date:   Tue, 26 Jul 2022 09:34:57 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.0.3
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        =?UTF-8?Q?Cristian_Rodr=c3=adguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <9c576e6b-77c9-88c5-50a3-a43665ea5e93@linaro.org>
 <Yt/V78eyHIG/kms3@zx2c4.com>
From:   Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Organization: Linaro
In-Reply-To: <Yt/V78eyHIG/kms3@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 26/07/22 08:54, Jason A. Donenfeld wrote:
> Hi Adhemerval,
> 
> Thanks for your review.
> 
> On Tue, Jul 26, 2022 at 08:33:23AM -0300, Adhemerval Zanella Netto wrote:
>> Ther are some missing pieces, like sysdeps/unix/sysv/linux/tls-internal.h comment,
>> sysdeps/generic/tls-internal-struct.h generic piece (it is used on hurd build),
>> maybe also change the NEWS to state this is not a CSPRNG, and we definitely need
>> to update the manual. Some comments below.
> 
> I think Eric already pointed those out, and they're fixed in v3 now.
> PTAL.
> 
>>> +  static bool have_getrandom = true, seen_initialized = false;
>>> +  int fd;
>>
>> I think it should reasonable to assume that getrandom syscall will be always
>> supported and using arc4random in an enviroment with filtered getrandom does
>> not make much sense.  We are trying to avoid add this static syscall checks
>> where possible,
> 
> I don't know glibc's requirements for kernels, though I do know that
> it'd be nice to not have to write this fallback code in every program I
> write and just use libc's thing. So in that sense, having the fallback
> to /dev/urandom makes arc4random_buf a lot more useful. But with that
> said, yea, maybe we shouldn't care about old kernels? getrandom is now
> quite old and the stable kernels on kernel.org all have it.

We do not enforce kernels version anymore, although we still support the
--enable-kernel=x.y that changes on how glibc internally assume some syscall
(so there is no need to fallback if it were the case).

So the question is where we need the fallback code for --enable-kernel=3.17.
If kernel is returning ENOSYS in this case (and assuming you are running on
kernel newer than 3.17) it means some syscall filtering, and I am not sure
we should need to actually handle it.  The main idea of adding this minor
optimization is to once we increase the minimum supported kernel we can
clean this code up.

> 
> From my perspective, I don't have a strongly developed opinion on what
> makes sense for glibc. If Florian agrees with you, I'll send a v+1 with
> the fallback code removed. If it's contentious, maybe the fallback code
> should stay in and we can slate it for removal on another day, when the
> minimum glibc kernel version gets raised or something like that.

I think the fallback code make sense since the minimum supported kernel we
still support is 3.2, although I am not sure how getrandom and/or /dev/urandom
will play in such older kernels.

> 
>> also plain load/store to se the static have_getrandom
>> is strickly a race-condition, although it should not really matter (we use
>> relaxed load/store in such optimization (check
>> sysdeps/unix/sysv/linux/mips/mips64/getdents64.c).
> 
> I was aware of the race but figured it didn't matter, since two racing
> threads will both set it to the same result eventually. But I didn't
> know about the convention of using those relaxed wrapper functions.
> Thanks for the tip. I'll do that for v4.
> 
>> Also, does it make sense to fallback if we build for a kernel that should
>> always support getrandom?
> 
> I guess only if syscall filtering is a concern. But if not, then maybe
> yea? We could do this in a follow-up commit, or I could do this in v4.
> Would `#if __LINUX_KERNEL_VERSION >` be the right mechanism to use here?
> If so, I think the way I'd implement that would be:
> 
> diff --git a/stdlib/arc4random.c b/stdlib/arc4random.c
> index 978bf9287f..a33d9ff2c5 100644
> --- a/stdlib/arc4random.c
> +++ b/stdlib/arc4random.c
> @@ -44,8 +44,10 @@ __arc4random_buf (void *p, size_t n)
>      {
>        ssize_t l;
> 
> +#if __LINUX_KERNEL_VERSION < something
>        if (!atomic_load_relaxed (&have_getrandom))
>  	break;
> +#endif> 
>        l = __getrandom_nocancel (p, n, 0);
>        if (l > 0)
> @@ -60,11 +62,13 @@ __arc4random_buf (void *p, size_t n)
>  	arc4random_getrandom_failure (); /* Weird, should never happen. */
>        else if (l == -EINTR)
>  	continue; /* Interrupted by a signal; keep going. */
> +#if __LINUX_KERNEL_VERSION < something
>        else if (l == -ENOSYS)
>  	{
>  	  atomic_store_relaxed (&have_getrandom, false);
>  	  break; /* No syscall, so fallback to /dev/urandom. */
>  	}
> +#endif
>        arc4random_getrandom_failure (); /* Unknown error, should never happen. */
>      }
> 
> And then arc4random_getrandom_failure() being a noreturn function would
> make gcc optimize out the rest.
> 
> Does that seem like a good approach?

I think so, although he __LINUX_KERNEL_VERSION is Linux-only that should 
be moved to sysdeps/unix/sysv/linux.

Usually we do as a wrapper (static inline or hidden symbol), with the generic
implementation on sysdep/generic or include with Linux redefining on its own
folder.

We also a use __ASSUME macros (check sysdeps/unix/sysv/linux/kernel-features.h),
it should be something like __ASSUME_GETRANDOM (we did not have a use for it 
because we do not want a fallback for getrandom implementation).

So I would add something like:

sysdeps/unix/sysv/linux/arc4random_impl.h


  static inline int getentropy_arch (void *p, size_t n)
  {
    for (;;)
      {
        ssize_t l = __getrandom_nocancel (p, n, 0);
        if (l > 0)
          {
            if (l == n)
             return true;
          }
        else if (l == 0)
          return -1;
        else if (l == -EINTR)
         continue;

  #if !__ASSUME_GETRANDOM
        if (l == -ENOSYS)
          return 0;
  #endif
        return -1;
      }
    return 1;
  }

And on stdlib/arc4random.c:

  void
  __arc4random_buf (void *p, size_t n)
  {
    if (n == 0)
      return;

    int s = getentropy_arch (p, n);
    if (s > 0)
      return;
    if (s < 0)
      arc4random_getrandom_failure ()

    /* Fallback.  */
  }

> 
>>> +      l = __getrandom_nocancel (p, n, 0);
>>
>> Do we need to worry about a potentially uncancellable blocking call here? I guess
>> using GRND_NONBLOCK does not really help.
> 
> No, generally not. Also, keep in mind that getrandom(0) will trigger
> jitter entropy if the kernel isn't already initialized.

Maybe add a comment stating it.

> 
>>
>>> +      if (l > 0)
>>> +	{
>>> +	  if ((size_t) l == n)
>>
>> Do we need the cast here?
> 
> Generally it's frowned upon to have implicit signed conversion, right? l
> is signed while n is unsigned.

Good question, I don't think we enforce it in fact.

> 
>>
>>> +	    return; /* Done reading, success. */
>>
>> Minor style issue: use double space before period.
> 
> I was really confused by this, and then opened up some other files and
> saw you meant *after* period. :) Will do for v4.

Yeah, I meant after indeed.

> 
>> As Florian said we will need a non cancellable poll here.  Since you are setting
>> the timeout as undefined, I think it would be simple to just add a non cancellable
>> wrapper as:
>>
>>   int __ppoll_noncancel_notimeout (struct pollfd *fds, nfds_t nfds)
>>   {
>>   #ifndef __NR_ppoll_time64
>>   # define __NR_ppoll_time64 __NR_ppoll
>>   #endif
>>      return INLINE_SYSCALL_CALL (__NR_ppoll_time64, fds, nfds, NULL, NULL, 0);
>>   }
>>
>> So we don't need to handle the timeout for 64-bit time_t wrappers.
> 
> Oh that sounds like a good solution to the time64 situation. I'll do
> that for v4... BUT, I already implemented possibly the wrong solution
> for v3. Could you take a look at what I did there and confirm that it's
> wrong? If so, then I'll do exactly what you suggested here.
> 
> Thanks again for the review,
> Jason
