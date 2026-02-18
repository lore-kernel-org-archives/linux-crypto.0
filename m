Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679552F261C
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 20:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771445023; cv=pass; b=GKSKlL9a8imMhlBM8ITxoii/w3O088iCWfC1o/g3cGYzJ75RmcsXCCKS261pySjYlM5gpE7v5zLh4SlAPvwndq/6xLWsMCan2Uvi/dlsX//V0q7oXy0ptQXGqUk3UWDFzusKemYpjnOHYmmL+LsdS2p05+q3MxSqWshNYbV5CRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771445023; c=relaxed/simple;
	bh=A9RFDZyZgqlQJkBPPEH0bt0olncW7jJuhWCZ9JoO/s8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fuGFOUWqnN6N/dYP9rpqgKXicuZL7m3ihWbVGeTKUaEfOzNHFyODasUlGfDvgCaDgsoCwUDaoPdSNgAv4QfRZ/qBaAaGRRi9HIx9Ex/4NJAwBp/jG4YpaEoISZNdzgvRDOt9DlbC3XgOLssAAD91jDIWFbXLEG6xCzqhs0OxjNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=OpxqkiwA; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="OpxqkiwA"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-59e64657f0cso289953e87.2
        for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 12:03:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771445020; cv=none;
        d=google.com; s=arc-20240605;
        b=U9UG00LEkw5zGDZTdfx7xBo2f5KyJUaVBNZAFu6KoV5jrKeY2Z+o4YIMJU2bQ7SObB
         evURviPTcROskT8YTnH5GLE5iJvutcX41x5qNciIS1EpusmpsHWQhbY99dGxIlz2+FZw
         YG8tj9FRbrEQDb9jDUNQ3LAAm5bhYanYtd01oHhvwWLySeS76AFpJKTl4P6Pdfoc/zuZ
         TTMoDZbf7I/y1W5e4HtBhWbEjQgUqIQ/JIYTw5u9QUyuMPkcfxx2uGqfHmZM/7EXg892
         JStQKxcOqfMPuk8Z3Zsf5TJOsI8QjRorJIUe4RXV9EoCo1AQsD/I1hslyJh5qmDOyGo7
         h88Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Vcy7R/11wcjfKOQI7WogUozCzX0mH6u0BCoPreJyb8U=;
        fh=bvCaqGwbnYjpNxlUe62RNfhWzmmTCxzPKthfyxgSVkE=;
        b=LDgDFUrSE29Qcqyju5F/rpy9vfKue0b9C+Wq098oORGCtUK74h75QeTqlJjS9HC8dD
         rfRfTKAAL/55IX9HLsfwHUVNIUcVZpZ8neSd3rdcQhB4wm9wb/pfpC9OJvXiuFgg1LvB
         rXZDPlwmAz4vGEx6hgPTqQJWElpXT+i0mg3R4CnLmOqxoZ2iY3ahzA076hS4R7DE/FGH
         Sm9695h7PpPmGVFfIHcKLu/FR20dx5y5f6yH0YcETBkOB2IJPNmW+TGjckSjNiGcP+m4
         fe2T2ggasXRDWngzbcPAHAJ+0HLNkcPzwdcNPA8c4l3Z6VPk4Yc7QSxELi0vZ+r+hv7z
         HP5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1771445020; x=1772049820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vcy7R/11wcjfKOQI7WogUozCzX0mH6u0BCoPreJyb8U=;
        b=OpxqkiwAUUWIfdMsKeV4jtOeUyJ54S5Q3gIl6IWomGB28pWLQ43/VZ2PPrPiJLFn6l
         geHXyDnsYHJCBuvKcKva6n0DQffN04OwxU/4M7eC72DW8P+FW9TGf76yQTqVcGZ39RB9
         xSDwuctxDlLpZnWMrM5/OMqLl4fuqhU/Np7zLrUC/rK+nDca8x9sisN+VjggnR/U1YVf
         BBaMNVWeYHdlS8zYxYiGoqtDsVTeqXx6Ku5JCJYMqYMej/Cvi+xikyOHdKCyULiuHfKS
         +s/YQnj8cyCckPBiCdB4cJhUF50hvTz95aJYnjMKO+epQEN4w6GWsNcRW1q7xuJ1RV2C
         VEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771445020; x=1772049820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vcy7R/11wcjfKOQI7WogUozCzX0mH6u0BCoPreJyb8U=;
        b=mTP0H2bM0NJ6ajsZswGO6EZVjYwOcPgKRzBQv3Lh3pNrXkZPfpM8JPz4FWDyy2BYF1
         8+0bSuMQ67mOPxnmpVMekT5pEk0Usk5VDtnuTXtlJe48xTa0JZL/nwZzLgqGsHhUUvPX
         /6wZ4D6g9stgryESWM9VVhBoq6odIeTa/AReb7NkqHDUjSYkfLI49SRDxAGJ8i6WxdWe
         0PSocU/qaysVfxEVk2mFe/W2nG84yeUTIrQTqqClrWjXQ4Dyt5TkqGewk81aZ6pBG4MF
         n46ozsJ2WaEqEeQyTll+Lw/gmiYu5KbNAbOK2y7d9N/LjOueSuvTOZqVzGoJtKlPjdgv
         DGMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhJR2twASmOVGEGzQwpZx7z+SkIJwhWA7goIrrMvFhCI5Z3jMhFWdvUkSxz82SdDgUpXKOiTVYcyDy4yo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuJHVrxDCi/1qlri24yltKj/kQCXd4SkNC8cYIgPXOyOGtavzk
	3YFyS/68nJVT8f8+rK/0yYA4ImYWETOfnA6cVSi+x2RxLlmcUEdHSW8hM3Tg4Xx6TxL+N7h0PUT
	+kfMZquR8R98FgYov+iSxFpGTI6A9VuO3OGIVbdySxyH1WZf7tWPxgg==
X-Gm-Gg: AZuq6aJFRQTJgN0fMT4Vv69IVccGruAGIXi/mcA0v22hmKOTMgO0L/qyEuAtqZaK+/w
	omrxSiTOLyamuKM0Nh5V2oDawdyxSFhi0aSUtmlKEGryQMLQruIhCGxlzRMnHG+WcNKXZwCZter
	yI29lxXN521zYTPDix0I44ZmZRrFtOBLqgWekeQCn0weDKGcEF5mSt78TQ7Qenp77JXsB32KYuU
	R7ZpX1tA/EKEyZUQS5Ls9Ku16MXUKum3rvBxEpDI7s9wDXzIcNe6T1ge0TnVQ0Ia/MLcAOlKWkD
	rITF6CKi4wYBGxo=
X-Received: by 2002:a05:6512:3992:b0:59f:6edb:b7ea with SMTP id
 2adb3069b0e04-59f6edbb86bmr4081097e87.42.1771445019417; Wed, 18 Feb 2026
 12:03:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215233316.1076248-1-ross.philipson@oracle.com>
 <b5f2b5a5-b984-4ed3-a023-c06d634f9146@app.fastmail.com> <1ffd3cb5-2c76-4371-a067-3e4849907d80@apertussolutions.com>
 <49d169bf-0ad2-49be-b7d7-fceb9e7f831a@app.fastmail.com>
In-Reply-To: <49d169bf-0ad2-49be-b7d7-fceb9e7f831a@app.fastmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Feb 2026 12:03:27 -0800
X-Gm-Features: AaiRm50K0AfYUHogK4D4rjv3z3w5Xga5sdt_IpbZg6dO6uXxKWdtAoPp16KXxJI
Message-ID: <CALCETrUE8c-dxRWhtHKz_PojwZuWMXJSzOsFQf2vt5LS3ATwpA@mail.gmail.com>
Subject: Re: [PATCH v15 00/28] x86: Secure Launch support for Intel TXT
To: Ard Biesheuvel <ardb@kernel.org>
Cc: "Daniel P. Smith" <dpsmith@apertussolutions.com>, 
	Ross Philipson <ross.philipson@oracle.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, kexec@lists.infradead.org, 
	linux-efi@vger.kernel.org, iommu@lists.linux.dev, dave.hansen@linux.intel.com, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"H . Peter Anvin" <hpa@zytor.com>, mjg59@srcf.ucam.org, James.Bottomley@hansenpartnership.com, 
	peterhuewe@gmx.de, Jarkko Sakkinen <jarkko@kernel.org>, jgg@ziepe.ca, nivedita@alum.mit.edu, 
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, corbet@lwn.net, 
	ebiederm@xmission.com, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	kanth.ghatraju@oracle.com, andrew.cooper3@citrix.com, 
	trenchboot-devel@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 12, 2026 at 12:40=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> w=
rote:
>
> On Thu, 12 Feb 2026, at 20:49, Daniel P. Smith wrote:
> > On 2/9/26 09:04, Ard Biesheuvel wrote:
> ...
> >> Surprisingly, even when doing a secure launch, the EFI runtime service=
s still work happily, which means (AIUI) that code that was excluded from t=
he D-RTM TCB is still being executed at ring 0? Doesn't this defeat D-RTM e=
ntirely in the case some exploit is hidden in the EFI runtime code? Should =
we measure the contents of EfiRuntimeServicesCode regions too?
> >
> > Yes, in fact in the early days I specifically stated that we should
> > provide for the ability to measure the RS blocks. Particularly if you
> > are not in an environment where you can isolate the calls to RS from th=
e
> > TCB. While the RS can pose runtime corruption risks, the larger concern
> > is integrating the D-RTM validation of the Intel System Resources
> > Defense (ISRD), aka SMI isolation/SMM Supervisor, provided by the Intel
> > System Security Report (ISSR). Within the ISSR is a list of memory
> > regions which the SMM Policy Shim (SPS) restricts a SMI handler's acces=
s
> > when running. This allows a kernel to restrict what access a SMI handle=
r
> > are able to reach, thus allowing them to be removed from the TCB when
> > the appropriate guards are put in place.
> >
> > If you are interested in understanding these further, Satoshi Tanda has
> > probably the best technical explanation without Intel market speak.
> >
> > ISRD: https://tandasat.github.io/blog/2024/02/29/ISRD.html
> > ISSR: https://tandasat.github.io/blog/2024/03/18/ISSR.html
> >
>
> Thanks, I'll take a look at those.
>
> But would it be better to disable the runtime services by default when do=
ing a secure launch? PREEMPT_RT already does the same.

So I have a possible way to disable EFI runtime service without losing
the ability to write EFI vars.  We come up with a simple file format
to store deferred EFI var updates and we come up with a place to put
it so that we find it early-ish in boot the next time around.  (This
could be done via integration with systemd-boot or shim some other
boot loader or it could actually be part of the kernel.)  And then,
instead of writing variables directly, we write them to the deferred
list and then update them on reboot (before TXT launch, etc).  [0]
This would be a distincly nontrivial project and would not work for
all configurations.

As a maybe less painful option, we could disable EFI runtime services
but have a root-writable thing in sysfs that (a) turns them back on
but (b) first extends a PCR to say that they're turned back on.

(Or someone could try running runtime services at CPL3...)

[0] I have thought for years that Intel and AMD should do this on
their end, too.  Keep the sensitive part of SMI flash entirely locked
after boot and, instead of using magic SMM stuff to validate that
write attempts have the appropriate permissions and signatures, queue
them up as deferred upates and validate the signatures on the next
boot before locking flash.
