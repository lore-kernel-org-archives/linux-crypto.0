Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020242BE020
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 10:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758018130; cv=none; b=FuGSdCIOrKtqb4pVeP1o5hrFo5R/aDNNsAbA1xTchRoemxDrNfn+T1nFfYCVPd148TKmUyKi9JNCedOyTpPvV9+PThKE9b7rezFHFdBVU/TDuPCGqnEWC978j2JgUTPphwpnCNzg/KoRMfJzqJmHyvvhWBpdwsQaPRuMty0i0mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758018130; c=relaxed/simple;
	bh=A9w+UJd4v8RhCRa+BhDctAaf9V0sYFUiRfKGTUevroc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GfE7ZBeMdzQPadGh1EzLyvpId/4rkpLPaNGkH/F5MsTi1KW+HjO0GV7whRbu6ktkZ+EcNGw8WAT/GMV2e4XWOBeOfMohABSDQQ44tx2qpw44ta53aWX9Ccc1t3ujjmtYpXl+Zn8Ms1i3c7bJomuhWk4wEjeJpxXmB1MotdCRDvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4xwDrKCQ; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4xwDrKCQ"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-78defc1a2afso1306396d6.2
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 03:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758018128; x=1758622928; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8fDdVkJYP6n8rFxsmmwdyCR43GJXYJ4e6lkQY1k5jhI=;
        b=4xwDrKCQ16W5xgDkZ7lwklnNqKOSoje/r+blQKN70VfjfbRT/ckZAJAaOqEwxJ833X
         b53KI+SqkWA5KgB7eDCljezBW50xqANoatvd5W+F/qsLVUxKY26Zzz562MXGOVE00j4r
         510BKdg9IfHXH+FKHU6czPrZmxeFsfjj6c44801s8R1orIiyXvUdIt2gQhgd+66jeIk2
         qtDvKIB6h+4bAyhKfg2TBIbLCbOc5vlq9NQvSlwZRKFUqNzdhXU3eKH/tceDlg6OrQ6E
         isRGK0NdjTiVR4KFdfEB8+Q48hbwI9x3uM5qieY1Cm/wYp/+6N85VMgbxaEjCLwRo1Xj
         ZDDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758018128; x=1758622928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8fDdVkJYP6n8rFxsmmwdyCR43GJXYJ4e6lkQY1k5jhI=;
        b=d8RKF50qZj3hsuFig9GV4ED+JhzjinbIXYiuVN//zvBLYIM8yM+MWqd5Jb3edIZq3t
         SF9Zz7bKVKPi4mpNsVBgeTrjuEvqhc9JRx85ZYiWPr8D38sICSS/XRS6+qhk20kGfkeH
         0HYs9ZCeqhFc7aG9ooDuMfZHfMB3vLuHtoKKHyELdeFDRgAcr9Um4Ui3Hjh3xP2nO1yg
         KFo27YnSIoNffzsW1Py+trUSl+tcVuXrjqAxEroTK977YUolTP0+1uUwbRBi9FboruJj
         jjhOFW0WFn/MUOykVwGD+VO4Eqgw2oiIrzQISNlzP8ezYTfSueYF9v5W5SOGB68P8EJn
         K9pg==
X-Forwarded-Encrypted: i=1; AJvYcCXV1rhbDnAYZT0KAikwKhHkE7kuOnctP1LWtvHiKTdxGLrg9FeepGslKZauz1nxl+Vq9tFtVcNgxkPD6oo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWzj0dfn/JyObLEDd3Jm0cQ6cNYDj6DBaNxqMU83HSzYSphp4v
	1sYYcDVKnidrjZLbiLQfY5uiqXG8jeY1LkOPf3dbeJnBwxa8gK+/BdVtAsmrxWqq9sAh8ISebIl
	e6crh6jO616sLdJEFJpt3yn64CjUx3Ybq66H952uf
X-Gm-Gg: ASbGnctgAd4xsLZ3jUzaewh6mqdWn8ZvPRbrVuWjvoaZefC3dbViC0C5EhgjoyZxvOf
	A2RH2PhhM2dh3KB5fJzaRLL6rGHLSwttFvmlsXsNDJThxJneklfgIG087TE31h+O/+HvWifYY5N
	gDJ3kKYJEu0DkALyWj1Lntwj+k54BXgUxB9qxk/IoU91t0Q5ByqleThyRNNYn8kyi/0qafz3qjE
	GS/34nr4Qy9xiAIsi8pC9oWaOXeSt4FGy8zLWCS3EhPqS+ReyyShAA=
X-Google-Smtp-Source: AGHT+IHJjKoQJCCYYuGTfxXsKe91BImRKJTHt9tE43tLxxHwyTxwEt6wyB79lNc8nOP5l+AzdDg7yLv4Nd7/rU5xvGE=
X-Received: by 2002:a05:6214:1c4d:b0:781:a369:ef8c with SMTP id
 6a1803df08f44-781a369f19fmr98103496d6.16.1758018127627; Tue, 16 Sep 2025
 03:22:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-4-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-4-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Sep 2025 12:21:31 +0200
X-Gm-Features: AS18NWAvlqXEHGPKEvaBnkig3ksosFgvoGuvVmEMsd87qxp-V32sXYdPaxYq0Tg
Message-ID: <CAG_fn=U0dOBumngmQQ1cna=SZvbDXjJ8NrVUZyCHY5dzJV4rVg@mail.gmail.com>
Subject: Re: [PATCH v1 03/10] kfuzztest: implement core module and input processing
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 11:01=E2=80=AFAM Ethan Graham
<ethan.w.s.graham@gmail.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add the core runtime implementation for KFuzzTest. This includes the
> module initialization, and the logic for receiving and processing
> user-provided inputs through debugfs.
>
> On module load, the framework discovers all test targets by iterating
> over the .kfuzztest_target section, creating a corresponding debugfs
> directory with a write-only 'input' file for each of them.
>
> Writing to an 'input' file triggers the main fuzzing sequence:
> 1. The serialized input is copied from userspace into a kernel buffer.
> 2. The buffer is parsed to validate the region array and relocation
>    table.
> 3. Pointers are patched based on the relocation entries, and in KASAN
>    builds the inter-region padding is poisoned.
> 4. The resulting struct is passed to the user-defined test logic.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
>
> ---
> v3:

Nit: these are RFC version numbers, and they will start clashing with
the non-RFC numbers next time you update this series.
I suggest changing them to "RFC v3" and "RFC v2" respectively.

> +
> +/**
> + * kfuzztest_init - initializes the debug filesystem for KFuzzTest
> + *
> + * Each registered target in the ".kfuzztest_targets" section gets its o=
wn
> + * subdirectory under "/sys/kernel/debug/kfuzztest/<test-name>" containi=
ng one
> + * write-only "input" file used for receiving inputs from userspace.
> + * Furthermore, a directory "/sys/kernel/debug/kfuzztest/_config" is cre=
ated,
> + * containing two read-only files "minalign" and "num_targets", that ret=
urn
> + * the minimum required region alignment and number of targets respectiv=
ely.

This comment (and some below) is out of sync with the implementation.
As we've discussed offline, there's probably little value in having
"/sys/kernel/debug/kfuzztest/_config/num_targets", because that number
is equal to the number of files in "/sys/kernel/debug/kfuzztest/"
minus one.
It just came to my mind that "num_invocations" could be moved to some
"kfuzztest/_stat" directory, but it can also stay here as long as you
fix the doc comments.
