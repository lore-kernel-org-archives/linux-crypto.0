Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775F328CF58
	for <linux-crypto@vger.kernel.org>; Wed,  4 Jun 2025 10:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749034241; cv=none; b=BvFQgcEVicn/Dk/oUqRowGn6jqqrdPFSV0xrndfpAnsQIh6c9Mr8j64hgNUwGQat0eUPCD+9e++ZCyJeqdOTN+Q1I58Grd/9uJxQzI4YJbwuKpX7QHQN2uuIa1/kAIAzS4HUmq/1dlj2LbssnGWvmzcfXxp9sj5FfglM5zXt/aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749034241; c=relaxed/simple;
	bh=jn4nygRnTKj9fV+Xag4PqoajhS/sLBPzpXAKdRZIkSk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bS6GDgXyNNrDcBwfmArYC/3DGn6pDFECOHGBnwxcVFDLExIn/XqwhJGqep2+m15bAsT4X2KJFx4xcb7r+bmS0otxH2Ssh8xyhtwUyG3e1dUoatIApqv9vwjLEnKnOKCLhr8NI+93YQ2vax436cr17WwqUs9yRa3WVexLfry+lVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=mGygoU4J; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="mGygoU4J"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e75668006b9so6239914276.3
        for <linux-crypto@vger.kernel.org>; Wed, 04 Jun 2025 03:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1749034238; x=1749639038; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMikC/irEVPa0Hohnvi6eoO332ZgA2v4xeO8L+pg4Ds=;
        b=mGygoU4JVXevxiAZITgyyF3XVDdbmuu3iDvu+ng24VEOTIbFQOCregMuKzvG8Fw/qU
         VaF4JzxnOKhKmN2rVrln9q0/8+RiNJyXvzt1KDqOtM3eK/+/DgGWAju6WLKie7o5Kfv/
         ROt/aa8DoQRA8EQYhWNp079emtGlEqqy7VRps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749034238; x=1749639038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMikC/irEVPa0Hohnvi6eoO332ZgA2v4xeO8L+pg4Ds=;
        b=p1QZVnZOoGCEsnizFM1A/YAqLeAOTY0kNiqS1RYI+1zDGMQ/E4y2w1bG60fyAQBbKy
         +9/mwFid5odqWsBf6iUfyjtkSZV0JSFNbfv7gUoRmLaX+LN/NYQ46RxkzD+Ezs2lHQw/
         UIm+FPnPLilr12WSSoZhbM4vPX3XjrX7BNT8v4DyqoQtAH76sNna8sgWna/G5FSxr38p
         WuOwy89y2ff2usgHH/aBTRaIj2o0FBsUukjaqCjiCqf2WYQhNnd4KQ36OL9NG/Xyb6Bz
         RfELS1IAKB/qaRZsafjJEzxU/DT01dM8mlEMxs4S3a6vtgzWsUBs4zFqXcFG96qzphHi
         Obkw==
X-Gm-Message-State: AOJu0YwasS23R4fvGpLh46U+sK39GH8ItFYdC1fjCstgH1R3dn36n2Ej
	Zng/yhKW1K5BY89fAAEHYLO35kov05BehZyUOCBUN/14mxqMo7nGEEF7bqJLGrT7ijTMb1dUfk5
	Fkco0h9FSaYwMXeiTDlBMAPGJrItXpp72n29JBAyrlg==
X-Gm-Gg: ASbGncvx5HXjxwFF+QsSQ/CBXS88Br4rEt5FFjBgT5qhlzbDfZGBpicKu/j2WyXRQL8
	jejaLYORIxo1ywD2qFNsVoiRwXt3hrQY4skGguZjKcgNGu7g8+WZaIXTSiIjzLTGkJS2BgFfM5t
	niyZCXTLJbcgUfIEdWszC8SzmLkVVUB8l07o9lp4kB/0N/
X-Google-Smtp-Source: AGHT+IFWlEF6Prrn96FnW4kqan/Qb0noChaG+ccVxhKjIFms+WNmINJx1a1EqZrB7XhYaXDlzutOFigrnkk7T1KJs8o=
X-Received: by 2002:a05:6902:18d0:b0:e7d:c87a:6249 with SMTP id
 3f1490d57ef6-e8179dbababmr3083480276.36.1749034238352; Wed, 04 Jun 2025
 03:50:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250602053231.403143-1-pavitrakumarm@vayavyalabs.com>
 <20250602053231.403143-3-pavitrakumarm@vayavyalabs.com> <9f6b4442-1fb0-479d-9514-410d4d8bfd98@kernel.org>
 <CALxtO0kitR0MnjzPwVT8nsuYThTRX+fbyOH9i2z1KKnCPg1dqg@mail.gmail.com> <ba13c2f1-9b08-4ba7-8093-d55c16143cb2@kernel.org>
In-Reply-To: <ba13c2f1-9b08-4ba7-8093-d55c16143cb2@kernel.org>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Wed, 4 Jun 2025 16:20:27 +0530
X-Gm-Features: AX0GCFvr1jBPQKug_8tsk9gqR4GmtY_mFZiWF1BuLivnsEZbP1Uhfaym79oBKSI
Message-ID: <CALxtO0nVngMjC4cg+d==p7XktnYJ9EgP_cXgwaJ1NOizPCJqZQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] Add SPAcc Skcipher support
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, 
	Shweta Raikar <shwetar@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,
   Yes, I do understand the use of static tools and the W=3D1 warning
checks on gcc/clang. Anything missed here is not intentional and I am
ready to add more tests and checks before posting patches.

I use Sparse, which did not show any errors or warnings in the code.
  make C=3D1 CHECK=3D"sparse" M=3Ddrivers/crypto/dwc-spacc/
  make C=3D2 CHECK=3D"sparse" M=3Ddrivers/crypto/dwc-spacc/

I missed Coccinelle, because I had installation problems on my Ubuntu
20.04 workstation, which has the build setup and my cross compilers. I
installed and checked SPAcc code with Coccinelle on another
workstation and I do see errors/warnings in the code.
I will fix all these and any new ones going forward.

   cocci.log:25:./spacc_device.c:132:2-9: line 132 is redundant
because platform_get_irq() already prints an error
   cocci.log:27:./spacc_device.c:301:3-8: No need to set .owner here.
The core will do it.
   cocci.log:50:./spacc_aead.c:575:8-15: ERROR: iterator variable
bound on line 572 cannot be NULL
   cocci.log:51:./spacc_skcipher.c:202:8-15: ERROR: iterator variable
bound on line 199 cannot be NULL
   cocci.log:52:./spacc_ahash.c:288:8-15: ERROR: iterator variable
bound on line 285 cannot be NULL
   cocci.log:59:./spacc_interrupt.c:117:1-7: preceding lock on line 97
(false positive)


Also I do the W=3D1 warning checks with my .config on gcc and clang

COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-13.2.0
~/lkp-tests/kbuild/make.cross W=3D1 C=3D1 CF=3D'-fdiagnostic-prefix
-D__CHECK_ENDIAN__ -fmax-errors=3Dunlimited -fmax-warnings=3Dunlimited'
O=3Dbuild_dir ARCH=3Darm64 SHELL=3D/bin/bash drivers/crypto/dwc-spacc/

COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-14.1.0
~/lkp-tests/kbuild/make.cross W=3D1 O=3Dbuild_dir ARCH=3Darm64
SHELL=3D/bin/bash drivers/crypto/

COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang-17
~/lkp-tests/kbuild/make.cross W=3D1 O=3Dbuild_dir ARCH=3Darm64
drivers/crypto/dwc-spacc

Warm regards,
PK




On Tue, Jun 3, 2025 at 5:37=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.org=
> wrote:
>
> On 03/06/2025 14:02, Pavitrakumar Managutte wrote:
>
> >> Please run standard kernel tools for static analysis, like coccinelle,
> >> smatch and sparse, and fix reported warnings. Also please check for
> >> warnings when building with W=3D1 for gcc and clang. Most of these
> >> commands (checks or W=3D1 build) can build specific targets, like some
> >> directory, to narrow the scope to only your code. The code here looks
> >> like it needs a fix. Feel free to get in touch if the warning is not c=
lear.
> >>
> Confirm that you understood this. You sent us code with obvious flaws
> which would be found with tools. It's a proof you did not run these
> static tools. It's not the job of community reviewers to replace the
> tools. Using us instead of tools is... well, a mistake but if you think
> about our limited time then kind of close to inappropriate request. So
> did you understand the need of using tools BEFORE you post it?
>
> Best regards,
> Krzysztof
