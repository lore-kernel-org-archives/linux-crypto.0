Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D37199234
	for <linux-crypto@vger.kernel.org>; Fri,  7 Jun 2024 15:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717775475; cv=none; b=gFbsD2NSAKU7zzaTJdPmETXTEzIaIf4CfChDp/lak+pQ3Ci58MqQcIdHzhpLiNZjWlUuYbZLhoU9o0EFMwqQ+yEqyVM6VSLqMiv6XS6XWzJ6M6DsavZOBaUkPetgCg+Z1n5VZe1kcGrHEU/m4u4dHFe89ca8SszmjO1iBsp1ZQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717775475; c=relaxed/simple;
	bh=B/nWxWSuvalMGnUtnURKHG5HNXcPjMpI5YfholgjWCY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IuXjjKKzFKCAmcSJPqyf1HDaPVxD5W2+n2MRCtMfHg4ZbSeAJYIg1UvbYWGGIYuFlV2G5s/RPL3odXloufQpTaZy6N5MlfI+WbHjipvKMhfql6M2qr9Mgy68ViGkQAgAAEFrSLaBwgUm09fxyPnu5FXcqXSrE8f0+sfwiUCGodg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eBXPt1Sc; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eBXPt1Sc"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-57c5ec83886so9946a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 07 Jun 2024 08:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717775472; x=1718380272; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPvYVfHAHLIq4Iro9sltEbUBk0XQCsjazy7jWcwOLxU=;
        b=eBXPt1ScTIT0K0Oz4PFoIrcoQL1W3t9usM9cleIFx2nMSSUC+QQkpsVRz2i96oz0aL
         HfMF2jIzUq7YBE8qC+pon9LqjG0uYqX+g7huL54eNMsMtTf70WEzDdVn5Vu3hlnLyAP1
         EZD+u7hMINh6sje92yG9ynhQaLo6t+pwGPi85OcqEr548YiPOy6j009YEwG97KU9gYCN
         8vgdKxii6v45tli8riidUXqvNpwAA3kV0dXC7x5GlGM84Pyhr/Xwl8DWcDV1Jl9pvCb5
         RNb46uriv1RN3ntuNKW4P+9YpmXJwmUYJqHtGJM2Vpc+v5LUM6DPBunLK8d6RDfRRmUa
         7hGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717775472; x=1718380272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KPvYVfHAHLIq4Iro9sltEbUBk0XQCsjazy7jWcwOLxU=;
        b=Y/+PX3TI8PmbQGlUHACo7rkGHC5iN6rBl/l2l503lRwMM0EtfImKmV5IsCCG4ejosr
         Ge8CkQapTI0TmHGPqR7k1PGmdC4dVOELTebfVC6lLgNyARia/sEMY/kUQoPjhz7rhp+7
         MliJATwIasBYlL5dt+DMcCUs4Es6mJrkf6emK5h5GENSSFm5FAge0jF7a8SFO8ebAGEK
         yyWftHUXVlLGKBtG034Y86G59W7wZDWNaq6ZyIluZ8RxnUisgjBZ8LWp6kx14Cqbzc01
         LkR6gGPvP7vLmY69T4Qjzp311ewFhdgei1rKYpFd3iQ+kf6fDvHG9ItFpd5+9hLnW4ZN
         xPjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRpZCfCIXHbhnX4qYkn2m8s6lFBi8K8cO8E5FYQx63l/sCKevuFC9EVnffcv5kk9rOURv5A5Hl9jpf9+lNvXRgNTwabgQyYBoPPJSG
X-Gm-Message-State: AOJu0YxYqKwAS8FHiWsHC4BzAWmNg4835LTeZVV8TGvSns4jYrl5l4SP
	SlUVojcV5u/ezgiUo6QFYYGOmukfeys3Kp1JDZK88r6HmLEfmnGkUJ+1btk7WiyDJDuOkcQytU+
	tjSvT+e5TJ+CZysd+92Q+/EVckP/wpKT8wZq1Dr0+IR2SccpxGxrEYqU=
X-Google-Smtp-Source: AGHT+IFeaOng9QTrsWteV8BPFpGm8tSsyktUl7ikHk3iad/5dvNpRpMcHTMxQVUYRtOOO2V2JmvFuTBVrMMVB25rokM=
X-Received: by 2002:aa7:c0c5:0:b0:57c:5ffb:9917 with SMTP id
 4fb4d7f45d1cf-57c5ffb99b5mr135769a12.4.1717775472242; Fri, 07 Jun 2024
 08:51:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528122352.2485958-1-Jason@zx2c4.com> <20240528122352.2485958-2-Jason@zx2c4.com>
 <CAG48ez0P3EDXC0uLLPjSjx3i6qB3fcdZbL2kYyuK6fZ_nJeN5w@mail.gmail.com>
 <Zlm-26QuqOSpXQg7@zx2c4.com> <CAG48ez3VhWpJnzHHn4NAJdrsd1Ts9hs0zvHa6Pqwatu4wV63Kw@mail.gmail.com>
 <ZmMamtll1Yq1yfxc@zx2c4.com> <CAG48ez0pan8aLGjHtoDdrpiP+e5YrGeuD_RzDXgzUwkUvWYLjA@mail.gmail.com>
In-Reply-To: <CAG48ez0pan8aLGjHtoDdrpiP+e5YrGeuD_RzDXgzUwkUvWYLjA@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 7 Jun 2024 17:50:34 +0200
Message-ID: <CAG48ez1k0J013tYLfmnT8NXRpG_5BR10xnH8r-yRvTLpJe-nLA@mail.gmail.com>
Subject: Re: [PATCH v16 1/5] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 5:12=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
> On Fri, Jun 7, 2024 at 4:35=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.co=
m> wrote:
> > On Fri, May 31, 2024 at 03:00:26PM +0200, Jann Horn wrote:
> > > On Fri, May 31, 2024 at 2:13=E2=80=AFPM Jason A. Donenfeld <Jason@zx2=
c4.com> wrote:
> > > > On Fri, May 31, 2024 at 12:48:58PM +0200, Jann Horn wrote:
> > > > > On Tue, May 28, 2024 at 2:24=E2=80=AFPM Jason A. Donenfeld <Jason=
@zx2c4.com> wrote:
> > > > > > c) If there's not enough memory to service a page fault, it's n=
ot fatal.
> > > > > [...]
> > > > > > @@ -5689,6 +5689,10 @@ vm_fault_t handle_mm_fault(struct vm_are=
a_struct *vma, unsigned long address,
> > > > > >
> > > > > >         lru_gen_exit_fault();
> > > > > >
> > > > > > +       /* If the mapping is droppable, then errors due to OOM =
aren't fatal. */
> > > > > > +       if (vma->vm_flags & VM_DROPPABLE)
> > > > > > +               ret &=3D ~VM_FAULT_OOM;
> > > > >
> > > > > Can you remind me how this is supposed to work? If we get an OOM
> > > > > error, and the error is not fatal, does that mean we'll just keep
> > > > > hitting the same fault handler over and over again (until we happ=
en to
> > > > > have memory available again I guess)?
> > > >
> > > > Right, it'll just keep retrying. I agree this isn't great, which is=
 why
> > > > in the 2023 patchset, I had additional code to simply skip the faul=
ting
> > > > instruction, and then the userspace code would notice the inconsist=
ency
> > > > and fallback to the syscall. This worked pretty well. But it meant
> > > > decoding the instruction and in general skipping instructions is we=
ird,
> > > > and that made this patchset very very contentious. Since the skippi=
ng
> > > > behavior isn't actually required by the /security goals/ of this, I
> > > > figured I'd just drop that. And maybe we can all revisit it togethe=
r
> > > > sometime down the line. But for now I'm hoping for something a litt=
le
> > > > easier to swallow.
> > >
> > > In that case, since we need to be able to populate this memory to mak=
e
> > > forward progress, would it make sense to remove the parts of the patc=
h
> > > that treat the allocation as if it was allowed to silently fail (the
> > > "__GFP_NOWARN | __GFP_NORETRY" and the "ret &=3D ~VM_FAULT_OOM")? I
> > > think that would also simplify this a bit by making this type of
> > > memory a little less special.
> >
> > The whole point, though, is that it needs to not fail or warn. It's
> > memory that can be dropped/zeroed at any moment, and the code is
> > deliberately robust to that.
>
> Sure - but does it have to be more robust than accessing a newly
> allocated piece of memory [which hasn't been populated with anonymous
> pages yet] or bringing a swapped-out page back from swap?
>
> I'm not an expert on OOM handling, but my understanding is that the
> kernel tries _really_ hard to avoid failing low-order GFP_KERNEL
> allocations, with the help of the OOM killer. My understanding is that
> those allocations basically can't fail with a NULL return unless the
> process has already been killed or it is in a memcg_kmem cgroup that
> contains only processes that have been marked as exempt from OOM
> killing. (Or if you're using error injection to explicitly tell the
> kernel to fail the allocation.)
> My understanding is that normal outcomes of an out-of-memory situation
> are things like the OOM killer killing processes (including
> potentially the calling one) to free up memory, or the OOM killer
> panic()ing the whole system as a last resort; but getting a NULL
> return from page_alloc(GFP_KERNEL) without getting killed is not one
> of those outcomes.

Or, from a different angle: You're trying to allocate memory, and you
can't make forward progress until that memory has been allocated
(unless the process is killed). That's what GFP_KERNEL is for. Stuff
like "__GFP_NOWARN | __GFP_NORETRY" is for when you have a backup plan
that lets you make progress (perhaps in a slightly less efficient way,
or by dropping some incoming data, or something like that), and it
hints to the page allocator that it doesn't have to try hard to
reclaim memory if it can't find free memory quickly.
