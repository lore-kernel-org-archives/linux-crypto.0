Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB833783C6
	for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 17:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774631806; cv=pass; b=h6tPS4Rt3GM6d+ckKzUUJ+5FHAeqWw3pfxnsKQjEUxGCH/TbvOOXNtRxKf73x4JQumerAjzDYPXuae2LBQY8TFUpbxCblQyi8fntKENMyoeIZd0nPmwvLrPXe1UFpdi3x8y38/qAvY8BeVSJmlcwYCRcbsQinZ4spC4HfIhS2eQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774631806; c=relaxed/simple;
	bh=F0BAAnzlVUA62NWkOkaZSw/1pa3sUYq8y+agUmZGKvM=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XDvQV62XDBTE0HvRjoCMUkLMFvM5PPVZKCWzd3VcByv/+Xw7/4D78b0KiLqs3hp9crRVozQf8Qwxi8/1wIO3eiaEIHgxYVF3iAsI6w6f/K68xNT+ck9G6cY42Zn+QHgyTSXyAynPlwb+d6chojFlG6rIz/2MNpYwvRwamb4WXsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PIPoFt73; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PIPoFt73"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-38b13652c87so20318471fa.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 10:16:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774631803; cv=none;
        d=google.com; s=arc-20240605;
        b=kWtWwVJP7P/5SD9X8Dh79VjKGAzc4oeZdlrOObdErWLlx0/aOpw2M4R7o/q8D6soWb
         ANIY4jsPL6Dyx1N8EjxeAmH8F+P8+gycAbkMk7JnyUkYhW6RO6ErDH+REsMB0qzPYnQr
         CNbt54o2SuoAsDU3IwYVdPqFcmoSZlJUJsgUWzgmVA6gLwyLmhUjIPXsblvlYDJrvhC1
         vX/Io0OSrK4hhVS6mfO++bGBbpzIrckKFEGp/o8xD5JK3pPMbawId/psIZIRnh8CaT0h
         I1wPy2OY+m9OuAjTLPNn97L9hr7EyRqPCdkLUQ9BSmNzNZumg723nDkli1VWroJBLT91
         HLSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=xnzGmIUxdGW2gU/QGGZVzuf2msDogp8wDk7SmXB7k+g=;
        fh=CYYlELn7FuW/8MdGGi4LYox0c4vZ5lCEx5UUApRk8l4=;
        b=EKtwwR2PxB7/4ljop4O2ffbyicS83xvw2nPds/bKSXZyuq78k1/bIYmayNamDtiDcm
         OEDJuyAXgiSLJ/GdO42k7YNiGM1KQhJ5xNIV6KY419N8lr9Mi7PFqwB9O1NKRCsM6P//
         7Q+rbQFkYsEr1o2Dc22FITtgSzV4yBgyEaZ/ChaJJZ7w8TXou9qswzsA5BNspHwQMnhO
         NACPCj5ZUpr7uquTqO8/Zeyr0dZlDYZaVGDGiRP3lHBaq2C45ijRSx1ME7je1ULOiAbV
         Ur0FqOrMRfSVrNPpNZGEs6Q9QFoTZvIM9VVqZyIOSsq2MMfv4/POX0dSv7yArPlWjQ+K
         D9PA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774631803; x=1775236603; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xnzGmIUxdGW2gU/QGGZVzuf2msDogp8wDk7SmXB7k+g=;
        b=PIPoFt73jUhX7yTdh+nWMCjiMcxsVJJYOrBQIqXLg0S9ukPGZMoJHT+E859k3O1WGN
         IENnszx9JUiEp4Fvm/ye9w8UZBQOUH47jCs3nPtBAVQvJmPvHnvRp33M0954tMpuYkdK
         XBQC1Mhxn98nku7QDAUMRWenaITE/OTTALXJHNU0mm0WawmXf0U7ssaHXt008dmFpr68
         8pY5tRYQ4fW+VYEIkX2v624B/1Tj6ad8pyyuM7Dg4JOXW1igUsItI6zb/5XoFKG781qB
         TBEjjTSbxUXX4ezkBc4WGtKAmOZC/v71PVXpE9pXoH+aFzY5LW2fQ9tSy/myYs9pfVbQ
         6IKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774631803; x=1775236603;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xnzGmIUxdGW2gU/QGGZVzuf2msDogp8wDk7SmXB7k+g=;
        b=qw2fF28LXptYXv5Yfoa6M4H6vh6iWbQ1K2jqFMZmnWYPOuNCSmjtmh3bg7JxuaY0bZ
         eZVsDWtzR18hBgUWq/Yu8B222t6BBAIDmeaXKg2XVgpNXS5topGM7KlZ3KHajXsvqk6t
         HHr8HPEgsp653WoLHX/ahhB46lA5Nfu2uai/wbR9CthFByYuK+ZQzpxd5dKu3w842RLY
         wREEWH76tK6EWNYGpqeYgjfmXqZiWS6btmlYJ0JEzIgojwPdt8xtyWqpl43trOH2Zkl6
         d9k04NVwtjCXWjPCIExeDjcyBdN1O4l0Ih9L95V8GiHZlMlV5uYVzU781NGqvBgZSlhm
         IsRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVNe1BpvuOhnz27AeiwNzTTKVi4xA3TkAXIkhHX6tvSh7JsFjeYa6gXmUFKcy2/v+g3gNitf2FvbBk9oQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9m2k8i8r6uaQvR/MAGpYXfqe0RQFQD6McqM7pV84MQzMXN+45
	inRLoG0iBADAgfkgo9hHRZ1Xc4I5greNKXKDR8gB7UwQRQtANdKyYIR+BbqW3CYsKw7A2r0yUbx
	6Dd8hclOndt+5Ydyfx/r+abzlEtJId0KoEmsNvLSt
X-Gm-Gg: ATEYQzzzsz1Nw1XGOa5tOTJiUeILEYd9OJ99Q5IJyKsYHeB4MZ5Ika3mmjt99B76DZZ
	KRFaRhIjPTr8XPN+11ijzkvveUKU3eGmelfSAqCf6vdGsBKbIskujfNQtG1KdCaEdpm92p3jyS5
	6JQEpwvQiLJONBQzXCEUITrDgoopbDdS49mAeUy0y4UI6Iq5jTmC04XW1xXNztyjWWu0V0rE9eu
	Va4HXzPH6X0eBh5UZFDy/7Cf+hiaMhVbXEsUnrwmmTa1sUtQsxCW+TAntNTQGM7hOID4Qcz2X8Y
	VhsjfRtY5dMm5Dyr/nlJi238P/f1+25kjJ1PyRr1HA7jcfx+dpWHWuTwIe+x4HrUpJGhygtrgrG
	zp6Q=
X-Received: by 2002:a2e:bea8:0:b0:38c:6b7:ad47 with SMTP id
 38308e7fff4ca-38c730c292cmr12337841fa.7.1774631802336; Fri, 27 Mar 2026
 10:16:42 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 27 Mar 2026 10:16:40 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 27 Mar 2026 10:16:40 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <75cd28a5-fb51-47ae-97c7-191fe9a6e045@amd.com>
References: <cover.1772486459.git.ashish.kalra@amd.com> <ce99dc548000b5a1f4486cdd3efe510b3874684b.1772486459.git.ashish.kalra@amd.com>
 <CAEvNRgFCTNr=LUR_RM7+A4z+qHCWBZOYKe_Cbokwx0UsCtzaVw@mail.gmail.com>
 <98313534-af6a-4c00-a016-9d9010f145da@amd.com> <CAEvNRgGdaA1ynF8jxQDPh9U0U8Q0RkE0=KJx4FNrh_=+dVRaLQ@mail.gmail.com>
 <75cd28a5-fb51-47ae-97c7-191fe9a6e045@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 27 Mar 2026 10:16:40 -0700
X-Gm-Features: AQROBzAtRdKIMBic86BLWsDOusTM6eXwJiCB6m5r-YkgCXsc-JgJUKHjclfT_hA
Message-ID: <CAEvNRgFJ8csUW0fXGB3cimjP=jev7mzaexUnfyj0p1ptFdPvCA@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] KVM: guest_memfd: Add cleanup interface for guest teardown
To: "Kalra, Ashish" <ashish.kalra@amd.com>, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	peterz@infradead.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com, 
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, 
	jackyli@google.com, pgonda@google.com, rientjes@google.com, 
	jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com, 
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com, 
	darwi@linutronix.de, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

"Kalra, Ashish" <ashish.kalra@amd.com> writes:

> Hello Ackerley,
>
> On 3/11/2026 1:00 AM, Ackerley Tng wrote:
>> "Kalra, Ashish" <ashish.kalra@amd.com> writes:
>>
>>> Hello Ackerley,
>>>
>>> On 3/9/2026 4:01 AM, Ackerley Tng wrote:
>>>> Ashish Kalra <Ashish.Kalra@amd.com> writes:
>>>>
>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>>
>>>>> Introduce kvm_arch_gmem_cleanup() to perform architecture-specific
>>>>> cleanups when the last file descriptor for the guest_memfd inode is
>>>>> closed. This typically occurs during guest shutdown and termination
>>>>> and allows for final resource release.
>>>>>
>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>> ---
>>>>>
>>>>> [...snip...]
>>>>>
>>>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>>>> index 017d84a7adf3..2724dd1099f2 100644
>>>>> --- a/virt/kvm/guest_memfd.c
>>>>> +++ b/virt/kvm/guest_memfd.c
>>>>> @@ -955,6 +955,14 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
>>>>>
>>>>>  static void kvm_gmem_free_inode(struct inode *inode)
>>>>>  {
>>>>> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
>>>>> +	/*
>>>>> +	 * Finalize cleanup for the inode once the last guest_memfd
>>>>> +	 * reference is released. This usually occurs after guest
>>>>> +	 * termination.
>>>>> +	 */
>>>>> +	kvm_arch_gmem_cleanup();
>>>>> +#endif
>>>>
>>>> Folks have already talked about the performance implications of doing
>>>> the scan and rmpopt, I just want to call out that one VM could have more
>>>> than one associated guest_memfd too.
>>>
>>> Yes, i have observed that kvm_gmem_free_inode() gets invoked multiple times
>>> at SNP guest shutdown.
>>>
>>> And the same is true for kvm_gmem_destroy_inode() too.
>>>
>>>>
>>>> I think the cleanup function should be thought of as cleanup for the
>>>> inode (even if it doesn't take an inode pointer since it's not (yet)
>>>> required).
>>>>
>>>> So, the gmem cleanup function should not handle deduplicating cleanup
>>>> requests, but the arch function should, if the cleanup needs
>>>> deduplicating.
>>>
>>> I agree, the arch function will have to handle deduplicating,  and for that
>>> the arch function will probably need to be passed the inode pointer,
>>> to have a parameter to assist with deduplicating.
>>>
>>
>> By the time .free_folio() is called, folio->mapping may no longer exist,
>> so if we definitely want to deduplicate using something in the inode,
>> .free_folio() won't be the right callback to use.
>
> Ok.
>
>>
>> I was thinking that deduplicating using something in the folio would be
>> better. Can rmpopt take a PFN range? Then there's really no
>> deduplication, the cleanup would be nicely narrowed to whatever was just
>> freed. Perhaps the PFNs could be aligned up to the nearest PMD or PUD
>> size for rmpopt to do the right thing.
>>
>
> It will really be ideal if the cleanup can be narrowed down to whatever was just freed.
>
> RMPOPT takes a SPA which is GB aligned, so if the PFNs are aligned to the nearest
> PUD, then RMPOPT will be perfectly aligned to optimize the 1G regions that contained
> memory associated with that guest being freed.
>
> This will also be the most optimal way to use RMPOPT, as we only optimize the 1G regions
> that contains memory associated with that guest, which should be much smaller than
> optimizing the whole 2TB RAM.
>
> And that's what the actual plans for RMPOPT are.
>
> We had planned for a phased RMPOPT implementation.
>
> In the first phase, we were planning to do RMP re-optimizations for entire 2TB
> RAM.
>
> Once 1GB hugetlb guest_memfd support is merged, we planned to support re-enabling
> RMPOPT optimizations during 1GB page cleanup as a follow-on series.
>
> But i believe this support is dependent on:
> 1). in-place conversion for guest_memfd,
> 2). 2M hugepage support for guest_memfd.
>

You're right about this dependency. Do you meant guest_memfd THP support
for "2M hugepage"?

> Another alternative we are considering is implementing a bitmap of 1GB regions in guest_memfd
> that tracks when they are being freed and then issue RMPOPT on those 1GB regions.
> (and this will be independent of the 1GB hugeTLB support for guest_memfd).
>
>> Or perhaps some more tracking is required to check that the entire
>> aligned range is freed before doing the rmpopt.
>>
>> I need to implement some of this tracking for guest_memfd HugeTLB
>> support, so if the tracking is useful for you, we should discuss!
>
> Yes, this tracking is going to be useful for RMPOPT.
>
> Is this going to be implemented as part of the 1GB hugeTLB support for guest_memfd ?
>

Yes, this is going to be implemented as part of the HugeTLB support
for guest_memfd. HugeTLB support for guest_memfd extends to any HugeTLB
page size the host supports, so not just 1G, 2M as well. :)

>>
>>>>
>>>> Also, .free_inode() is called through RCU, so it could be called after
>>>> some delay. Could it be possible that .free_inode() ends up being called
>>>> way after the associated VM gets torn down, or after KVM the module gets
>>>> unloaded?  Does rmpopt still work fine if KVM the module got unloaded?
>>>
>>> Yes, .free_inode() can probably get called after the associated VM has
>>> been torn down and which should be fine for issuing RMPOPT to do
>>> RMP re-optimizations.
>>>
>>> As far as about KVM module getting unloaded, then as part of the forthcoming patch-series,
>>> during KVM module unload, X86_SNP_SHUTDOWN would be issued which means SNP would get
>>> disabled and therefore, RMP checks are also disabled.
>>>
>>> And as CC_ATTR_HOST_SEV_SNP would then be cleared, therefore, snp_perform_rmp_optimization()
>>> will simply return.
>>>
>>
>> I think relying on CC_ATTR_HOST_SEV_SNP to skip optimization should be
>> best as long as there are no races (like the .free_inode() will
>> definitely not try to optimize when SNP is half shut down or something
>> like that.
>
> Yeah, i will have to take a look at such races.
>
>>
>>> Another option is to add a new guest_memfd superblock operation, and then do the
>>> final guest_memfd cleanup using the .evict_inode() callback. This will then ensure
>>> that the cleanup is not called through RCU and avoids any kind of delays, as following:
>>>
>>> +static void kvm_gmem_evict_inode(struct inode *inode)
>>> +{
>>> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
>>> +        kvm_arch_gmem_cleanup();
>>> +#endif
>>> +       truncate_inode_pages_final(&inode->i_data);
>>> +       clear_inode(inode);
>>> +}
>>> +
>>>
>>
>> At the point of .evict_inode(), CoCo-shared guest_memfd pages could
>> still be pinned (for DMA or whatever, accidentally or maliciously), can
>> rmpopt work on shared pages that might still be used for DMA?
>>
>
> Yes, RMPOPT should be safe to work here, as it checks the RMP table for assigned
> or private pages in the 1GB range specified. For a 1GB range full of shared pages,
> it will mark that range to be RMP optimized.
>
> If all RMPUPDATE's for all private->shared pages conversion have been completed at
> the point of .evict_inode(), then RMPOPT re-optimizations will work nicely.
>

Ah okay. The kvm_arch_gmem_invalidate() call in .free_folio is the part
that updates the RMP table to make anything private become shared.

So the RMPOPT probably needs to happen after the invalidate in .free_folio

The RMPOPT stuff is still useful even if the host never uses huge pages
for guest_memfd, right? If so, I think we still need a solution
regardless of when huge page support for guest_memfd lands.

What if we do it this way: in .free_folio, after doing the invalidate,
take the pfn of the folio being freed, align that to the GB containing
that pfn, then RMPOPT that? This way there is no dependency on the inode
being around.

RMPOPT looks up the shared/private-ness of the page in the RMP table
anyway so as long as the RMP table is updated, we should be good?

The awkward part is if RMPOPT is run twice when the RMP table state
hasn't changed. Is my understanding right that there will be no
correctness issues, just performance?

We can perhaps optimize (away or otherwise) unnecessary RMPOPTs later?

With this aligning-up-to-the-GB, at least we're not iterating the entire
host memory.

>> .invalidate_folio() and .free_folio() both actually happen on removal
>> from guest_memfd ownership, though both are not exactly when the folio
>> is completely not in use.
>>
>> Is the best time to optimize when the pages are truly freed?
>>
>
> Yes.
>
> Thanks,
> Ashish
>

Thank you!

>>> @@ -971,6 +979,7 @@ static const struct super_operations kvm_gmem_super_operations = {
>>>         .alloc_inode    = kvm_gmem_alloc_inode,
>>>         .destroy_inode  = kvm_gmem_destroy_inode,
>>>         .free_inode     = kvm_gmem_free_inode,
>>> +       .evict_inode    = kvm_gmem_evict_inode,
>>>  };
>>>
>>>
>>> Thanks,
>>> Ashish
>>>
>>>>
>>>> IIUC the current kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
>>>> is fine because in kvm_gmem_exit(), there is a rcu_barrier() before
>>>> kmem_cache_destroy(kvm_gmem_inode_cachep);.
>>>>
>>>>>  	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
>>>>>  }
>>>>>
>>>>> --
>>>>> 2.43.0
