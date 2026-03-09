Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62629374177
	for <linux-crypto@vger.kernel.org>; Mon,  9 Mar 2026 09:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773046917; cv=pass; b=fyWqVPhgPQS1SFsbY2Z+MUBM79bhmWpQKy/xm1702CwCeNcHZiRkv/Ly2G2lWFurm3/ot3QUvdTaZy6BsyhHi+DwHmJwaIohCje/P/00UhypQ7PbTmsQynORP1kypIitwY9GLgrdnYul/xUI1OTaLw4U8hdevniYPxZEN3KMmYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773046917; c=relaxed/simple;
	bh=PNkPX25Cp7e7Iwb2dKtnjzov9RP8heUl93T4iWLshSg=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oVBA7zPEIb/n2vScLNqnDtskJ5NNii99f3PdT+RGi16+hkLnwkuUHWKjdgkXNrE5Oqtro0qm6rAs0S+2XNM1V1cGt9by8wCXTfiuTjjsPdNz4dM8ApeTSbkYHNQd0Qcz4zDvTaHaL7/kp22IkO9O4DRMd+vbfvzdQq5XmIv6kOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HZ+OBMvu; arc=pass smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HZ+OBMvu"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-5ff05af29b4so3855644137.1
        for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2026 02:01:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773046914; cv=none;
        d=google.com; s=arc-20240605;
        b=Pj4sa3hQ0swvSAgcDwI+IuoMSiCI8FF2aU4F0CYVmHoKeJwLP5pBOZcylalrUP24wf
         heeI6+F+026mii6h0VkotkImGs384IxpZ1gjybL2DOcBQUS2k7tK6gK6BlhpbaVeA0Qa
         b4YQFGYjJD1jzS4ndjOLo3GO56/ILboe3y2WUcV5XvNJ+IZCcjX4zazWeDpkjPTwMieY
         wh6jtrFyaRKXGkU7L6MRn8S3ptxAEyw7q6FMRTAD0TFyIHHCWGFK0LGaGbU9jVrd/GDE
         GKZMDGCTxeUGytIfBRObKfgUCH7T+61KmZSMHUUGBIZxsEkeVqA3QuGPeotS5Ghcgkof
         SUow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=RFQA1zNrgYGwPSpxXXkSccQrNeC8DGePNpNQ4Qq3K74=;
        fh=pu3ny/TA0xd8NShjHj9wFtqCa2Sa2y5k0yyRrSy80g8=;
        b=ZUJ2MjoS6lVb50CA01OFHiZpPuZZnpiGnAbdqQZ8hOeSK8fl+A16WZFW1Xlkt2vUIA
         iU5sTlidW27HJ5Eo7lx+U3bDR+NG1Eww6tvuRCumhbI0Pbwk5MQn7G3RmDDnojjCvk9P
         3U2VTfG7LRi8GNxUiQemwWEcbUxRn75fHUizj6eJfg/ML9D8WoIiI040S9YadrvQJs9a
         /6rwl+z5akue5zW4LT92HNMChpSMNbwWJfdLWnjvkMKE+f35vnIIAMkbfk0iUvkyIOEV
         Ja8TfoiELndUttzW9y9tEM8Ydc+mZTYFnRZP/MGhb1CR9ANq6tcfv42TYMXF30DQRiK5
         +rVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773046914; x=1773651714; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=RFQA1zNrgYGwPSpxXXkSccQrNeC8DGePNpNQ4Qq3K74=;
        b=HZ+OBMvu14mLMWV7Hizzd6RlJU+TG+l5CUyuTPiK3a8leO1gHkq9AhhkKPdYyvVTgl
         O7BRrxwbVPMIMuA0zGsbKSSw3GeoElrAvB3jEhKS9fyofkrGPKBcYRGf7CTrjvAPHrB6
         awiWYKqFZ/l8b39F0Qjoxd4KBA7QDMCZPVRgni3XLyZa30ARiMoLr6u9pA14p7Ki/8I6
         D+moV25McBJrtzIfddwO0l1/HtDYCxK4oTbmbDrWkJ8kokCBVwObC0wJ8k1YQ4XXAA80
         +ReTAkQREhJLLpKKquQvXk8ddfJitPFLRwVpnK+wqXLwC5RLgMlnZc0eYIMI+YkMrxk3
         EZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773046914; x=1773651714;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RFQA1zNrgYGwPSpxXXkSccQrNeC8DGePNpNQ4Qq3K74=;
        b=etmkfox735ym2dY7HudYlkIVVSzLA6sPACLdgQ79zoK/MlCqXxKiG/vUsGBk82jbVb
         rwGimHWaPLtLp64v4cJB1MssIm6nkS+4HvKYrSb3mvSpcwwVkP7kFISLhRKEemjICMLn
         SWg48HmK1UXcBYVYRZk1RRhJu4UszRTHU9d61wuD6MomqDPovILWpYBB6Ue/09K1rix7
         Bpp2ysNbUCegaO54g0H1sQ3RgbbGml0vJhrPwWkjAwpXrajdsnEVFeMW33Kvs/9vUQWW
         WH8Kjql0KLhkvoeG/MeD1I9x/+h4n9BX4sXueHnG1CvAQFCoRVBuA1j0d+48DHHo1fpj
         wfEQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3WcTDOjl9tYibTPrvQ2Fsjxx8p0djzN9mE9HczrifH5h0ZwMprVs1hBM6JJCA39WgPBRgSH4quHJe9lM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6FbHj08ybcIzbN3ccXqFa/pNhRpcFq+VG7k9Tpx0HKGfCUOju
	73AAmAbF6HD+byMaw5EFFJigMgaQfc4quTK1Kn7eWl750JogG1E2bzA54HQihwxRUWyqGu8zigd
	G6veznBHuNRKeZq3HAOCzfXwAUNtk19wZ3n2FwQfF
X-Gm-Gg: ATEYQzwYU+V7ek8JTv8g44HjPpV0UXmFRvpsFI6kLqTDjAop3m8cRiAU67wwvXZ/lLh
	Suy72H370lvclbm4O/5K44HVym3ido8RYbhGtKN9AAibiufktuXsvIZ/Wqk9fA0vmM0SHVMKYuo
	JFCS5SCdqLPRlx8OAW2dw5Q3FqH306dlmVp+p6XhQ/+5wEpezP4jFTmn2+L0F4SfgLxnebozMF6
	vjU+NOkSYRd68S1mhLVnwtu1gjhu3jcOoJiZG/EhBRuFw7vFCCLyAhsL9mteIeCnqx48uhRIHWn
	n9EAkLIR3O9Q7bjkSJkHiuhL5cHrYcOXqfC4OjKDh13nFXEzDiwt7TOXDGLZaUllFsaQ5w==
X-Received: by 2002:a05:6102:3f0b:b0:5ef:a644:ca4 with SMTP id
 ada2fe7eead31-5ffe6134835mr3557573137.23.1773046913874; Mon, 09 Mar 2026
 02:01:53 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 02:01:53 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 02:01:53 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ce99dc548000b5a1f4486cdd3efe510b3874684b.1772486459.git.ashish.kalra@amd.com>
References: <cover.1772486459.git.ashish.kalra@amd.com> <ce99dc548000b5a1f4486cdd3efe510b3874684b.1772486459.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 9 Mar 2026 02:01:53 -0700
X-Gm-Features: AaiRm523pnGIGt0JrK2mF_UJQjN59ASDAQJnNicAgeYGdxK3jDgLfp_34dMqkIY
Message-ID: <CAEvNRgFCTNr=LUR_RM7+A4z+qHCWBZOYKe_Cbokwx0UsCtzaVw@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] KVM: guest_memfd: Add cleanup interface for guest teardown
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
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

Ashish Kalra <Ashish.Kalra@amd.com> writes:

> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Introduce kvm_arch_gmem_cleanup() to perform architecture-specific
> cleanups when the last file descriptor for the guest_memfd inode is
> closed. This typically occurs during guest shutdown and termination
> and allows for final resource release.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>
> [...snip...]
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 017d84a7adf3..2724dd1099f2 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -955,6 +955,14 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
>
>  static void kvm_gmem_free_inode(struct inode *inode)
>  {
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
> +	/*
> +	 * Finalize cleanup for the inode once the last guest_memfd
> +	 * reference is released. This usually occurs after guest
> +	 * termination.
> +	 */
> +	kvm_arch_gmem_cleanup();
> +#endif

Folks have already talked about the performance implications of doing
the scan and rmpopt, I just want to call out that one VM could have more
than one associated guest_memfd too.

I think the cleanup function should be thought of as cleanup for the
inode (even if it doesn't take an inode pointer since it's not (yet)
required).

So, the gmem cleanup function should not handle deduplicating cleanup
requests, but the arch function should, if the cleanup needs
deduplicating.

Also, .free_inode() is called through RCU, so it could be called after
some delay. Could it be possible that .free_inode() ends up being called
way after the associated VM gets torn down, or after KVM the module gets
unloaded?  Does rmpopt still work fine if KVM the module got unloaded?

IIUC the current kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
is fine because in kvm_gmem_exit(), there is a rcu_barrier() before
kmem_cache_destroy(kvm_gmem_inode_cachep);.

>  	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
>  }
>
> --
> 2.43.0
