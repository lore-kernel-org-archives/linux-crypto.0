Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20146213E9E;
	Fri, 18 Apr 2025 01:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744940955; cv=none; b=Y+rYeyiy7rb5lKye57ksgqwdWGfRcePYuO0D7vZ74Rco4RlKR/o7lxv/rju9cvtUdt/2cFFZR+CA1osg4W8lUkAsJjY/57bnYSWSh1EQqfVIVlUubX7wpsww2ROMIDGrDPA4V2eaAlbc078pNqShJiAYTa+cr0lf+/J0FEcRqho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744940955; c=relaxed/simple;
	bh=T5YSTaPq/cYz27PUavSqTEdEuOQrc6qcfRPknuXgv58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H08ZA4/AUENrq3flSjBrxngDWfr5qFgyI3j8lAbEGkLjsQDJYr32cBonTf2ubPY5p6QrBxmDul7fAvUYIl3E+himQyJeLJk1HVsaqyK3GIfoAPz/aq5R4DVdV9y2aI6GJqFHdEBjzYTsMZSRVwVoiF666AZjddaFvXz17GgXb8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HjdYTi3H; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HjdYTi3H"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e6deb3eb7dbso1261202276.0;
        Thu, 17 Apr 2025 18:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744940953; x=1745545753; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WmglLRoVsuPHltsr1TwX2csib2NZ7x5pIBHoukxn5Ak=;
        b=HjdYTi3HddjFUolq+aYWh8A1m29QnvdRDFia3EQzOOyP6n8EsuS7JoRzNMqPBgZYg+
         2ZE3KzSTOvcpZsGOSYRFd6NYwHo/LdQOwA6geC/PJmeCF3I4tLLXwbc0dSJ+mIHFcuDs
         8OE/Fpr5Bkqh3un4c0LMoh9qGpHrM0+tswqJMTzfh4wlekd2I4A/RY/nWuyVC7Zwc7F8
         Dbxw9TatTc1+UPycY7Xir2KNOdc1HEpfkz4wIawupvLP7mUOUM1XDQJoq4iyJk5ZYCnS
         OUyYxzI1Fs3c0JnZDG4I0ly05olaIYq2vwfcwKQKuf9SRMmxujT970iLJj9NKsFXMWCi
         0OOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744940953; x=1745545753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WmglLRoVsuPHltsr1TwX2csib2NZ7x5pIBHoukxn5Ak=;
        b=J//+1LFgfQ22UU9ZnPPf44fMZPVsLZz9lHCtpRnjZ/FZLRh5Nxhg5d5c68o5anLkMr
         2AXgLQ0wlJcUasODctrMfsyhfW/5wL5vE8r+FVNLEBvtrUS7LPPMTHLCu76cVoxNWpHJ
         zDaMVdSYR6BMS2w2t+gI3jZavrFv9dtgWMVkTCdMkqVhS+d8V7UOHCdRYLBBYz29u4cS
         cbfc7U0ZSPXdoMbreB6kmX+NBlX0AvPUBuNvBmx1M5sQDO2MNzrV7AZMcR31sJ8bC/8k
         5Tk1FojCt0tGUqTBjvlbtJDYEo2j/7EJqxckRs2vTf+VgFoeqXRj/bgjvbq7TF1fMfOi
         U6pw==
X-Forwarded-Encrypted: i=1; AJvYcCUnHde7F4zxnOHHPaIimqT1EgD5YzVnwrdpycWfxycOjo56hLk1cRGgCyUpf2aOG49OmEsYhX4vgrSbZsXc@vger.kernel.org, AJvYcCVdhjvxariMC/xQFNbzx8PaerxUodQzq8AoEC5ZuwnOIinEwZAqGrRiN74oGXG4LrHngKDkV9icV2ZnJ8M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvrBwQNPwsbMY2rIFi9aHL5pQItKikTsI+QRjR7U6Wmqxecigu
	t6kZKPkwtisLUTv9g+p6zbF3zfYlm8bHCK+U5jwX8fq8y1K6rEF5vOEVir+q3O5ivjMk4gxfhns
	yEniJ2ZaSbaguJHk971KI2wepE4s=
X-Gm-Gg: ASbGnctInX4YSeXdW4gsVftzXeOhZJZfPEgh92riCgXW+4Hn6epcGwS3YB0W8qd/JAP
	j71wDOwDqgzI71gQ00MjvoCbX/ivUDMs7oz1Kzpo3P5fqbYPU8mQBafTgcnefTFoTfJ0FnP/1Gu
	EiBGo7vYGYYOJB21r5OA/s8753Z5zF7NX7zn5pCw==
X-Google-Smtp-Source: AGHT+IGUJoDzahqgdqLndIsmYoX2akOdFbgKB06u7VmDFKJltr6uEQVcZZQMdCy9WoqoFlbvS6cd7gUnAw1TFwGFUck=
X-Received: by 2002:a05:6902:2510:b0:e72:8658:5839 with SMTP id
 3f1490d57ef6-e7297eae575mr1455987276.32.1744940952774; Thu, 17 Apr 2025
 18:49:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417064940.68469-1-dqfext@gmail.com> <CAMj1kXFPAVXOtPoETKvHB49kjZUPYrsAqsJwdL7p5Cu4xk75Rg@mail.gmail.com>
 <CALW65jY=LnVBYoKPOQnSKgGSA0brKzmo0vqoRDcqF_=jofLAng@mail.gmail.com>
 <CAMj1kXH-u7hiKGQfgYHj_16V4ATN_aHmA_wkvMSyLh+E3+QaAA@mail.gmail.com>
 <CALW65jZVYUZoka7Gbjcoh43qbkD7rGpw8gTZjjOYpZD-BhLyBQ@mail.gmail.com> <20250417165856.GB800@quark.localdomain>
In-Reply-To: <20250417165856.GB800@quark.localdomain>
From: Qingfang Deng <dqfext@gmail.com>
Date: Fri, 18 Apr 2025 09:48:56 +0800
X-Gm-Features: ATxdqUHBrp0rUxHu64YX4mBWqOm5CVQgF2oCMN8KPRYqB9bzHHQfTOroaVo3v4I
Message-ID: <CALW65jZGUQ9HsNi3QQQ-A9AAL31zcmqhVGLhKBQPfPM-CB67gg@mail.gmail.com>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, linux-crypto@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>, 
	Qingfang Deng <qingfang.deng@siflower.com.cn>, Guo Ren <guoren@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Fri, Apr 18, 2025 at 12:59=E2=80=AFAM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Thu, Apr 17, 2025 at 04:42:46PM +0800, Qingfang Deng wrote:
> > > I see. But do you have a particular configuration in mind? Does it
> > > have scalar AES too? I looked into that a while ago but I was told
> > > that nobody actually incorporates that. So what about these
> > > extensions? Are they commonly implemented?
> >
> > It's aes-generic.c (LUT-based) with accelerated GHASH.
>
> That's an odd combination.  Normally accelerated AES and GHASH go togethe=
r.
> Presumably you're targeting some specific RISC-V CPU.  Is this going to b=
e a
> one-off thing for that specific CPU?  Or can we expect many RISC-V CPUs t=
o have
> GHASH acceleration without AES?  And if so, why?

There are a few RISC-V CPUs that support the B extensions
(Zba+Zbb+Zbc+Zbs) but lack both scalar and vector crypto extensions.
One such CPU already upstreamed in the kernel is the SpacemiT K1.
Another example and the one I'm currently running this code on is the
XuanTie C908, as found in the CanMV K230.

(+Cc Guo Ren)
Guo, do you know if future XuanTie CPUs will support the RISC-V
scalar/vector crypto extensions?

[1] https://www.xrvm.com/product/xuantie/C908
[2] https://www.xrvm.com/product/xuantie/C907
[3] https://docs.banana-pi.org/en/BPI-F3/SpacemiT_K1_datasheet
>
> - Eric
