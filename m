Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE69369997
	for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 11:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769771670; cv=pass; b=a6zT/IqBy49U3xMdcdTaXhA9Au2oe1ca5GIBwNCWcImeJkI0wVRWIGB8HGtRK5GAEe365xsYRolR1mfHN7ZWtlo2dku6JBec4+SJojYRjChgFW/pd/ul37fjqDo//5dQFjHcbW3LOk+FwS5Tl5ZwJA8GLIUVO7+SQTevK/rSHew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769771670; c=relaxed/simple;
	bh=5NX6/8aQxy3kGKKmxgUb8QfLiJ2pU03lf0e4EyOMnpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bXxbfBRlNOYjsPpD1+ukxvgfXf+22UCBAnm/Ofa5PWghQ9cdJDaRIVGcaH5J/UgZsBLi0quC7JoEaby0cJoV1ZIyXP2O7VUQwYUpOApfsOE0nioY7zY/27ZCpqYScpSudFDjMHUwgvAMoQbOfPKubUNmMHJsjuovpvOXqOTGfqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=njpetUAn; arc=pass smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="njpetUAn"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3530715386cso1354103a91.2
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 03:14:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769771669; cv=none;
        d=google.com; s=arc-20240605;
        b=R8sLPlP5bbQwTOjGBaFfEfA+qIue16XOFQx5FjmigoDJfFSzNICdgDc15kIUD/yrix
         ps/KjlPKPZeYpOuygp/PipJ+LTGxEl2lPainCzq5n6H+Yteozl8y9woeNIvHfs/fFiNC
         zs7dqC2m6uSTp2ZEh44+O66rZr/SJhGGcWmDWLr+vX41xRbW9u2NGe8CJpIN596gs6fB
         IhMh/452OJZ7xpiSB4LTCIiNdEruswGlkut4KYMAe2G+c6KhU11GnknqWhyjBsxoGbkT
         xpqUloG+iBx5Hs6H99XRPYPm4SpOSWXq9YfxiK4927K7zwTLhnt7BSn8dp+2RM7sdh1q
         jpoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5NX6/8aQxy3kGKKmxgUb8QfLiJ2pU03lf0e4EyOMnpg=;
        fh=QHoiIXmolWsZzlQZ8upZ3XXyARSbrymxfyhZYbnriLo=;
        b=bocKuxvYNLxvoJ/1/2EFZrrz///6nVzcPNBXK3xkIMfmGne2bpc+tnwWHB+KD50G+S
         KSR5mdwjOQsdgb+c9ttID/BC8g67PlmQmzovWo0pH49gpcJKAqyytBlJWgrlMFau1STT
         Qchig7GvydoMtaDytsi1ijZlbGxschQHq4ulic8SLszldSc/4zHAnSBRE57YbqEtyF91
         PPCYj8d+lSfYTqCtafyBKkhokBJjF/Pcxb4vqhxeMn0bdStMHzFrqOUyE29A40auCTEM
         bJmLiJZj1nEeQCRwz2wQdTLXhzcq3dAB1gNXd52CjOFQbddqAN8fZP1H+4QuW3vYUfGT
         OgJQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769771669; x=1770376469; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NX6/8aQxy3kGKKmxgUb8QfLiJ2pU03lf0e4EyOMnpg=;
        b=njpetUAn0cqz1PK28IBBfX9oz7IzZeFycB1IpPo0Mi0Al15Y3b/BK9jESZ+D60I1bg
         Vnxr82FX6nmkTegahag23Eku9cqFRdsmo4O7c9OA3yeC7EmQldUrb/w9aF33F9edEhnV
         oPCpRC/nCZmSrvOLz0UFQRTF5hu2rtAJc5GRwFnc2L2amBOCLFIAu4iRH1OjvIOju+W5
         cY0Av7MFBKKSp0ifpsRmKFYNZXFBFPKMnl/5rmxyePNkPPfi01eVMCUjyPbs8V4tykbY
         9F33Qn472ixPxpY69lPPgNOLM7q5kwDXRqhFe113RyfxLSPJY15DKjo9lC0Lw2qlXiSY
         xYEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769771669; x=1770376469;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5NX6/8aQxy3kGKKmxgUb8QfLiJ2pU03lf0e4EyOMnpg=;
        b=onCTFtfNQVjcNJo4kMtXv047JOfN1MSYpib97f7gE1PjG+tYSnKFN+JKjFXhvAZqkM
         LmtCVXDpKV+Uql00mTmJhjffYrcUNn+4mvvsWSD503D8EWMHEHgXA/XajcTMGheLzQ+n
         vqR3SooPDR+482evqKip9+dvt1jn9yDiWUhTZ7DUbd1XYI7SuFmd/L2tv80Y890n4zk7
         ofqU3WXngPPWaON305maGgtaYUn6CQ710PU5yH4jaKSz31jsBL+Im2yhk1ewrnSqhUsu
         UQHQojSehLjHdeLK+UDzlI7YCY2luaDHGuSIJbfZueBxu925eu9LnGFOnbuHac0XSEK5
         16Rw==
X-Forwarded-Encrypted: i=1; AJvYcCXpXZO3SKlb/pl0Y+wU0RrkZwuHIc3MQ8dWaJiCy+5K3mbtDOMf31gAsW6/R2WHtMrj0QDJP/6OLHQ1ZTg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwsr2QCoS2cwAmELtNtEOErO/dbQKrK6ez0fDAb0T6kY6KH1IR
	/FwroZ+C/sSaJysc47naf7o1i1UwfmEWoyBnpVnG4q7L18Pj38t9uBVR06Tt0f7VEmu1QeO5+4n
	axBtwLWQnrOF4DxAOZ7UnhElb/Ya1o5YKPz+CbtRD
X-Gm-Gg: AZuq6aLFNEmcvHZnynfRDIRj90ABD6dZyuu/3+F1xp6u93SgeEHoouEY8PX/fLXbrYD
	dYx7L0V2TKxbxzOW2Fezkv0Wmjrq1gp1UGVOlbdYNQZlSHs2h9ttirTYvKWVY5N8mEuHNGvOi1A
	7cr3Ng5k94aDJWsMJr2HA6beMovjKFLkE2tJoj2OkcttaFvDTScS+jBY3LoXz2Jztey5b9XUx7p
	nvYwe0s5Fk/O/cISGk1igqzwEQrFxgxBDCcxFKpuKzdPUMwf/w9jpWKfj3yzk7bXeVaw37YrKLf
	POmBIMSr9RrcgZQJuWXHVuPNVA==
X-Received: by 2002:a17:90b:3c43:b0:352:ccae:fe65 with SMTP id
 98e67ed59e1d1-3543b2dee06mr2832480a91.4.1769771668673; Fri, 30 Jan 2026
 03:14:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com> <CAG_fn=W6wdFHYsEqkS37iWOkJUZqS0LUEg-N2HWo+3Rw-76v4A@mail.gmail.com>
In-Reply-To: <CAG_fn=W6wdFHYsEqkS37iWOkJUZqS0LUEg-N2HWo+3Rw-76v4A@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 30 Jan 2026 12:13:49 +0100
X-Gm-Features: AZwV_Qg0luMSY0y1N1xh2lvqYlNWV--Rlx3KALTJGGklX1gYVl6nq4JAZoKUMIQ
Message-ID: <CAG_fn=URHwuOuF_RNyxDCJZmjAFKSf4kHau6uTsFFPrTB=3-Kw@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] KFuzzTest: a new kernel fuzzing framework
To: shuah@kernel.org, skhan@linuxfoundation.org
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, Ethan Graham <ethan.w.s.graham@gmail.com>, jannh@google.com, 
	johannes@sipsolutions.net, kasan-dev@googlegroups.com, kees@kernel.org, 
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de, 
	mcgrof@kernel.org, rmoar@google.com, sj@kernel.org, tarasmadan@google.com, 
	wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2026 at 3:26=E2=80=AFPM Alexander Potapenko <glider@google.=
com> wrote:
>
> On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gm=
ail.com> wrote:
> >
> > This patch series introduces KFuzzTest, a lightweight framework for
> > creating in-kernel fuzz targets for internal kernel functions.
> >
> > The primary motivation for KFuzzTest is to simplify the fuzzing of
> > low-level, relatively stateless functions (e.g., data parsers, format
> > converters) that are difficult to exercise effectively from the syscall
> > boundary. It is intended for in-situ fuzzing of kernel code without
> > requiring that it be built as a separate userspace library or that its
> > dependencies be stubbed out.
> >
> > Following feedback from the Linux Plumbers Conference and mailing list
> > discussions, this version of the framework has been significantly
> > simplified. It now focuses exclusively on handling raw binary inputs,
> > removing the complexity of the custom serialization format and DWARF
> > parsing found in previous iterations.
>
> Thanks, Ethan!
> I left some comments, but overall I think we are almost there :)
>
> A remaining open question is how to handle concurrent attempts to
> write data to debugfs.
> Some kernel functions may not support reentrancy, so we'll need to
> either document this limitation or implement proper per-test case
> locking.

Hi Shuah, I wanted to bring this series to your attention.
There are some comments to be addressed in v5, but overall, do you
think the code qualifies as "having no dependency on syzkaller"?

Thanks!
