Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F231B87F2
	for <linux-crypto@vger.kernel.org>; Mon,  8 Sep 2025 06:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757313220; cv=none; b=OQ7X+3zq3H0shbF4je05LjPpfbqJrfIuxdVJoUmSq59tKODvBASEJEvFaePpWZzPFZAMboBVUQlHjV0HMkfzX8NSzPY43lhiXFWc8YdiemU4T+H8OaLHqiBNQAKoH6IhVZJJJjOs09LrTIPyx3sUf1P/04/Vi5cwhF26U6ghIQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757313220; c=relaxed/simple;
	bh=OhUH+Z07fRrpKhrZeUuay/g+3leOUtGetWVNCNESxDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=so+KuNk4mN79to5W4Xj11bTeYVzkF7a9Rq78BaVTiWsnCsTIL7DwiXrGzHNkyxYuDnBuWtH8jWIietE9pDvzFpp2xA1o28EGFXWeAi2ahFxoIcRvi3yB1dc3BzkSy0DxUqiXpIAxf3sFVgipBL7bLJo5Q8wD5AvYPjTM8nYGCz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bFTWNUnD; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bFTWNUnD"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-33730e1cda7so36954641fa.3
        for <linux-crypto@vger.kernel.org>; Sun, 07 Sep 2025 23:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757313217; x=1757918017; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eJwB7SCX5/adivhWJU1vqxu6DkFRbG1fAaH56kwBC8Y=;
        b=bFTWNUnDXTdJ8zqwZygqhM+R026tEMhXq5hJKHn5xVRv5croyCst+VTXG+x5I/N8ml
         bPYWqhXXs/EcO9lhzWbbPY0TC76sWhIR7g0CoqvVMgU53X9f4qg1zR/m5G7jxFUurPSx
         Yz+vwjGj0BbfyUXRISfE2ogbOVREXFnAMeB34/gaSLpW7Vj7pp6d2GiEDw53zkhK+7/p
         vJWtmPg9H4eXL29WV3YR1cnUVzWxWWCTiqf8CtHS5PTttgTu5TVvCYfl5WBzHV9ZkIOA
         ciXaUhuJ3xB19cgGC2L1c12+wJFU/1652zwcCwl4mntKypzREptftq2DehLCRouYcUDa
         ak0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757313217; x=1757918017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eJwB7SCX5/adivhWJU1vqxu6DkFRbG1fAaH56kwBC8Y=;
        b=XWZoVTVFRWhM2EV0tcMs83En0lZw3btxBTzG9pbJJ0VWHI9flQuF6rr7zpfzYTZADB
         Qvn3smXLTtLJWq2YjKXLlte/98kwncEdUSyAy5o/GCzvvn/xZflGIuSfHDiDM6GBcsgo
         A0DLyOc7ISR2TqSepQik8GyjZ2r5NgDMSQ+WEpdZh3GufbG7M2rGjCpy7xKbGzPWgnhS
         mJuS98VpTwzA9QfqtGFMXxAjpEJEwIHyUw4HJFGhgOlBMfDYGnPPfhh/SpVzTOXIw3gY
         X4bnNVxNM9inJbdbvI+tNZTEstnIRd6phCZ1vGbsAObhYHVGzLehZecWLgTNaCjup0wb
         rrfA==
X-Forwarded-Encrypted: i=1; AJvYcCUDosYSqBxYcLx+Z3jzRlLvy19p6Q7jbqCeSK3fBNPrdvxchygqkn2rEHIHjLifD4Kmx7oAl/zDJvWCLYg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjW5DQ/7yCV/mz6kuOKB7EnobXO6yP0jBxZzoVAijeHNRZB74/
	9U8va3jtlhGqRVNaRO0Gm90iqoEaBXTQxUYhjshNDIr4+jHE0klUvx7Mfrp6ZbINnuQWWnFMNiS
	gjiENVJ0C1zOMn5ds4jK5vP9KmtSL7oOtw8Cq8e38pg==
X-Gm-Gg: ASbGnct2lbv8hX+RsmCAjNLmb06yy/+8bqjeyfX0jEp/AU/yOg258zdC9DnbCzquKAw
	Tof0oa+3EoGRGsYAvUlyD0HbkBXAz8UiRmdzvZQ0zzvBOMPr+5vvYMG9axWbkbrd5IVo9wgxw5Y
	2cqm8G0/a5yWJRJDdOUS7orf/dFEnteXPeqMwG2lytBUyxc0I1q5f633f2NXSaG+Jlx1d0txiQH
	jFYEmHeLIIGzwheIw==
X-Google-Smtp-Source: AGHT+IEul/1lSleLADsQmlrAbcXYeBBuWKXApeelPhH6Kv5m9iAfewvsZxvDD9Q8TaRpetI9kTEL7mGQ3gSQzcdeg6E=
X-Received: by 2002:a05:651c:1509:b0:337:f597:60e8 with SMTP id
 38308e7fff4ca-33b57c43673mr14686061fa.32.1757313217067; Sun, 07 Sep 2025
 23:33:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250822103904.3776304-1-huangchenghai2@huawei.com>
 <20250822103904.3776304-4-huangchenghai2@huawei.com> <2025082208-coauthor-pagan-e72c@gregkh>
 <CABQgh9GEZSasZq5bDthQrTZnJ_Uo8G-swDsrM_gWCecWbtTKgA@mail.gmail.com> <2025090608-afloat-grumbling-e729@gregkh>
In-Reply-To: <2025090608-afloat-grumbling-e729@gregkh>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Mon, 8 Sep 2025 14:33:25 +0800
X-Gm-Features: Ac12FXyZQX5Os5_Vuo_rHeb-rj7bzuNbJX-4hZesPdDN-WYbjkO2Mi2fWIpsSFA
Message-ID: <CABQgh9EWysbiOJv1HwpB-EUzxDbOcumnXzAn-p2PvsyB4ZcQJg@mail.gmail.com>
Subject: Re: [PATCH 3/4] uacce: implement mremap in uacce_vm_ops to return -EPERM
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chenghai Huang <huangchenghai2@huawei.com>, wangzhou1@hisilicon.com, 
	linux-kernel@vger.kernel.org, linuxarm@huawei.com, 
	linux-crypto@vger.kernel.org, fanghao11@huawei.com, shenyang39@huawei.com, 
	qianweili@huawei.com, linwenkai6@hisilicon.com, liulongfang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Sat, 6 Sept 2025 at 20:03, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Aug 28, 2025 at 01:59:48PM +0800, Zhangfei Gao wrote:
> > Hi, Greg
> >
> > On Fri, 22 Aug 2025 at 19:46, Greg KH <gregkh@linuxfoundation.org> wrot=
e:
> > >
> > > On Fri, Aug 22, 2025 at 06:39:03PM +0800, Chenghai Huang wrote:
> > > > From: Yang Shen <shenyang39@huawei.com>
> > > >
> > > > The current uacce_vm_ops does not support the mremap operation of
> > > > vm_operations_struct. Implement .mremap to return -EPERM to remind
> > > > users
> > >
> > > Why is this needed?  If mremap is not set, what is the value returned=
?
> >
> > Did some debug locally.
> >
> > By default, mremap is permitted.
> >
> > With mremap, the original vma is released,
> > The vma_close is called and free resources, including q->qfr.
> >
> > However, vma->vm_private_data (q) is copied to the new vma.
> > When the new vma is closed, vma_close will get q and q->qft=3D0.
> >
> > So disable mremap here looks safer.
> >
> > >
> > > And why is -EPERM the correct value to return here?  That's not what =
the
> > > man pages say is valid :(
> >
> > if disable mremap, -1 is returned as MAP_FAILED.
> > The errno is decided by the return value, -EPERM (-1) or -EINVAL (-22).
> > man mremap only lists -EINVAL.
> >
> > However, here the driver wants to disable mremap, looks -EPERM is more =
suitable.
>
> Disabling mremap is not a permission issue, it's more of an invalid

OK=EF=BC=8Cit's fine.

> call?  I don't know, what do other drivers do?

Found one example in kernel/events/uprobes.c

commit c16e2fdd746c78f5b2ce3c2ab8a26a61b6ed09e5
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Sun Sep 29 16:42:58 2024 +0200

    uprobes: deny mremap(xol_vma)

+static int xol_mremap(const struct vm_special_mapping *sm, struct
vm_area_struct *new_vma)
+{
+       return -EPERM;
+}


Thanks
