Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD95332612
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 06:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773208843; cv=pass; b=HCAs2m5+vWF1hnRD+XDVFyiD8zP0Co2980Q98VJvbJC8S+FYm8/bKVjnqy89y/XPSFSY0juwBSMQMBMhW5/d8RFdgykHBXpL4sBHHnkSHnm9vesomfhqPLDlLxqoNxDK8W/MNuMakI3bFxezdPJDAW+Axonr3KViF7FhzFkLSR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773208843; c=relaxed/simple;
	bh=1pU9e1VV6wQdH0AgbRuRINPzSJbE/naiF7g141qXG2U=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SDk/mWnhjSwvSBxa/gIoIUgXqIW0pagVTyYkpGQsh/lLXtrHpgqoaHbRkJZ9D9hush9KH1dlMNroTVWegFo3mdYziW1sf21L7pEXVtqWw/o3NxQiaXFA/46lonjdfeJVhD4wdn4/+6e2KaWq5rgDo/JX83TkbQ5W/w9qTQYjcUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d7Jq68qz; arc=pass smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d7Jq68qz"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-38a23cf08e0so83003491fa.3
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 23:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773208840; cv=none;
        d=google.com; s=arc-20240605;
        b=SIWLUDlhANmBgoIUSEYb/6X+lUKq02mPM3OvRpfK+PDhTtLgtlYUzOULNXG1SQmq3P
         Per+fQT5DBe0/0AGMoBwHB/uR02qn0qYDn6cQ8Yn9F5cAp2j6rD+8LPosBZYRE4CFPG2
         tcC1cbwe+yK/TyauMmIrFkvAkXjDwaP1gVk5rbujdlMvRruHK29buSue9Wbrm9992qJh
         aP+bC9i8s+VSfiJgPsmLtctYVCPVcOcdyUo9YUeJIdH13vFxV7P9JvnI4CyitLjYi4yH
         PJDDeXY1Tqz7hpe4vgEcBmutSO4DabnfDgqA02TaIM6iv/cHoeYYZ3ZE+u1TkMN8CAqG
         xxLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=WlV0D1/XllmyoZfK4RxM2lMbSn8Yq7S4U2C5Lb+KdlU=;
        fh=quGHUkwGzgiRmSiE8uLE6f4vdzhFC5mYI+Tn2zJkn/s=;
        b=gGQ8fSyoZ1wDWNNMAQ0CG+01/B6Lcf6PzGS6O1IRutVu5HjMbFv3+ZdvLPzVn9DOI7
         S6h0eUREb0lzoxIou+/Nd9r3s7jHaXnzOtrq5s/T3YjH1imIRtBijgNkeY4BCGrpOTs8
         M20vvCsrFe18NojJ31H+ZLr1/RfnD0PpJBErPTA2NJmFvXpN+qm77FZMOBhRRE9HVKUZ
         ZCo89mMaHofiYhULoubDFQSgf8cUJ31VXV/5aCVmPttAs8zMiS3vtY0ipR129zTODXlX
         uxzFZvNxz259M63C/447/WHqbNBakNpsuJnwSTOJOq4AGTUXecuWs7rbUzkTfCbZuH0T
         Yh2Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773208840; x=1773813640; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=WlV0D1/XllmyoZfK4RxM2lMbSn8Yq7S4U2C5Lb+KdlU=;
        b=d7Jq68qz9thJ7Mytez4OrrO4Vvw4joGqk4j3kZubk41nsJCxW3p+47FZAmMaYpXRaa
         VClYoDrKypg4wJ9tDAjUzZkGPVuVbm+YQClA24ce0c1d5UJ0JGk2Zzd37cqmXeKr31vd
         II1x5VNenuvcO7A5zjSyvmRaMfY+wPSvKfbPfdRuQjvdZtZ8WPxKLNeEo5MUOaRCop+c
         c1p4CBHKLfzogRIz9rIsWsfJ/4LTg/dszTLvGlGlAKHbW4MPRt88QVRRzwkINSyGS574
         wkzuBugOFtZ6Nbq281qtIHgMJIWSBdp2Ayhx664EtD0bXYZ2jKi7jXXQORfZzKGZuwVB
         mTrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773208840; x=1773813640;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WlV0D1/XllmyoZfK4RxM2lMbSn8Yq7S4U2C5Lb+KdlU=;
        b=YFWIV/TxoTBH580nR3uAHSioTRawoncG53Ozx/MYaTcjgAGTn570pR8niL3fPDg46g
         XldPFhM4+ubXyC8cJfQQXu+hL8U7DY2sC5qo9sGTxHsMEj8cdXWIz3SMfJaQQs5Nkxaf
         EIQSUnNsHysEhGA/bSP/43fv9g1TOBO+YCIyR9RKdlA1SGHR6PKrCoVhw1OnbiLbr2pu
         Zp12soHOItqAF7fvqfp9hWr8UCDHxLjQKKnOE3PXbv8y69LxwHcPkyDc/ziUcGCGyuGC
         gOt75AKSidHR7YvQ/nKsDUjD42TqwTXH6o13dnQ0gT/aOgOVyD3OjvhXJGYwjl59ZH9t
         ivbg==
X-Forwarded-Encrypted: i=1; AJvYcCXeTLmL+aPsG/eaj02tyj4I+R+f0RPs6Qfs2qJuBQC5dwmB20hLFFQgO818xPAO5I5utx+fbOqB0/YQ5Yg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz9flB/SrB1YsTEieWxndHpZzl9hbZrsP70Nf3Ly+CfJGS2I9y
	NIH7iWLmH2y3lWDIfZ0P8dM+jQUrKnt4qso7vjYAGwbHoCnLhfHXeH3wWmiXBW/wfOXhawdbUoH
	XH6apct4yktuMU4NpBIymGXozjXMZgGiDKP0bU3DP
X-Gm-Gg: ATEYQzwi7mPTbc5UeqITkrmOr8ByLiBjoD47vMo5zBrdGuof06ZvIV7swe9Mpv2EAlb
	Uq8a1jR8zYMkKZDrM7sklFs8/MOzotthoDCV4vLTKIoXFrs62++bAs29tu1cTMJjiEC6Pn+JON+
	5905zsJqIPR72f7lOTOnSgbZVsata0mtYhxqSzxrDV7cMQipNhEsQp2whDYouF4Y0nNMXYbKM8o
	oCg75XaLwn5AmYHZ3rl2nDLNgC5TqdgTtFVklUGi6XbIGDV/ifLlweNws71jcyw7bU5tWslOVA5
	W137dMEmRJqMR+1LEF2DCzxDtDFGlM2MfjiKcvXfl2stzEr5L/BRpgQQqk2xwMktcjjhcQ==
X-Received: by 2002:a05:651c:210d:b0:386:ee99:6cb3 with SMTP id
 38308e7fff4ca-38a67dd524emr4828161fa.9.1773208838986; Tue, 10 Mar 2026
 23:00:38 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 10 Mar 2026 23:00:28 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 10 Mar 2026 23:00:28 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <98313534-af6a-4c00-a016-9d9010f145da@amd.com>
References: <cover.1772486459.git.ashish.kalra@amd.com> <ce99dc548000b5a1f4486cdd3efe510b3874684b.1772486459.git.ashish.kalra@amd.com>
 <CAEvNRgFCTNr=LUR_RM7+A4z+qHCWBZOYKe_Cbokwx0UsCtzaVw@mail.gmail.com> <98313534-af6a-4c00-a016-9d9010f145da@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 10 Mar 2026 23:00:28 -0700
X-Gm-Features: AaiRm52f972dUARRHKzijDgoVU81dxtGZgEikl-nl7dIcDPZ6xeiqW2WuI2S4xg
Message-ID: <CAEvNRgGdaA1ynF8jxQDPh9U0U8Q0RkE0=KJx4FNrh_=+dVRaLQ@mail.gmail.com>
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
> On 3/9/2026 4:01 AM, Ackerley Tng wrote:
>> Ashish Kalra <Ashish.Kalra@amd.com> writes:
>>
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> Introduce kvm_arch_gmem_cleanup() to perform architecture-specific
>>> cleanups when the last file descriptor for the guest_memfd inode is
>>> closed. This typically occurs during guest shutdown and termination
>>> and allows for final resource release.
>>>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>
>>> [...snip...]
>>>
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index 017d84a7adf3..2724dd1099f2 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -955,6 +955,14 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
>>>
>>>  static void kvm_gmem_free_inode(struct inode *inode)
>>>  {
>>> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
>>> +	/*
>>> +	 * Finalize cleanup for the inode once the last guest_memfd
>>> +	 * reference is released. This usually occurs after guest
>>> +	 * termination.
>>> +	 */
>>> +	kvm_arch_gmem_cleanup();
>>> +#endif
>>
>> Folks have already talked about the performance implications of doing
>> the scan and rmpopt, I just want to call out that one VM could have more
>> than one associated guest_memfd too.
>
> Yes, i have observed that kvm_gmem_free_inode() gets invoked multiple times
> at SNP guest shutdown.
>
> And the same is true for kvm_gmem_destroy_inode() too.
>
>>
>> I think the cleanup function should be thought of as cleanup for the
>> inode (even if it doesn't take an inode pointer since it's not (yet)
>> required).
>>
>> So, the gmem cleanup function should not handle deduplicating cleanup
>> requests, but the arch function should, if the cleanup needs
>> deduplicating.
>
> I agree, the arch function will have to handle deduplicating,  and for that
> the arch function will probably need to be passed the inode pointer,
> to have a parameter to assist with deduplicating.
>

By the time .free_folio() is called, folio->mapping may no longer exist,
so if we definitely want to deduplicate using something in the inode,
.free_folio() won't be the right callback to use.

I was thinking that deduplicating using something in the folio would be
better. Can rmpopt take a PFN range? Then there's really no
deduplication, the cleanup would be nicely narrowed to whatever was just
freed. Perhaps the PFNs could be aligned up to the nearest PMD or PUD
size for rmpopt to do the right thing.

Or perhaps some more tracking is required to check that the entire
aligned range is freed before doing the rmpopt.

I need to implement some of this tracking for guest_memfd HugeTLB
support, so if the tracking is useful for you, we should discuss!

>>
>> Also, .free_inode() is called through RCU, so it could be called after
>> some delay. Could it be possible that .free_inode() ends up being called
>> way after the associated VM gets torn down, or after KVM the module gets
>> unloaded?  Does rmpopt still work fine if KVM the module got unloaded?
>
> Yes, .free_inode() can probably get called after the associated VM has
> been torn down and which should be fine for issuing RMPOPT to do
> RMP re-optimizations.
>
> As far as about KVM module getting unloaded, then as part of the forthcoming patch-series,
> during KVM module unload, X86_SNP_SHUTDOWN would be issued which means SNP would get
> disabled and therefore, RMP checks are also disabled.
>
> And as CC_ATTR_HOST_SEV_SNP would then be cleared, therefore, snp_perform_rmp_optimization()
> will simply return.
>

I think relying on CC_ATTR_HOST_SEV_SNP to skip optimization should be
best as long as there are no races (like the .free_inode() will
definitely not try to optimize when SNP is half shut down or something
like that.

> Another option is to add a new guest_memfd superblock operation, and then do the
> final guest_memfd cleanup using the .evict_inode() callback. This will then ensure
> that the cleanup is not called through RCU and avoids any kind of delays, as following:
>
> +static void kvm_gmem_evict_inode(struct inode *inode)
> +{
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
> +        kvm_arch_gmem_cleanup();
> +#endif
> +       truncate_inode_pages_final(&inode->i_data);
> +       clear_inode(inode);
> +}
> +
>

At the point of .evict_inode(), CoCo-shared guest_memfd pages could
still be pinned (for DMA or whatever, accidentally or maliciously), can
rmpopt work on shared pages that might still be used for DMA?

.invalidate_folio() and .free_folio() both actually happen on removal
from guest_memfd ownership, though both are not exactly when the folio
is completely not in use.

Is the best time to optimize when the pages are truly freed?

> @@ -971,6 +979,7 @@ static const struct super_operations kvm_gmem_super_operations = {
>         .alloc_inode    = kvm_gmem_alloc_inode,
>         .destroy_inode  = kvm_gmem_destroy_inode,
>         .free_inode     = kvm_gmem_free_inode,
> +       .evict_inode    = kvm_gmem_evict_inode,
>  };
>
>
> Thanks,
> Ashish
>
>>
>> IIUC the current kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
>> is fine because in kvm_gmem_exit(), there is a rcu_barrier() before
>> kmem_cache_destroy(kvm_gmem_inode_cachep);.
>>
>>>  	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
>>>  }
>>>
>>> --
>>> 2.43.0
