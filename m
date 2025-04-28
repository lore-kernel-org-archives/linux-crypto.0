Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBA9253B43
	for <linux-crypto@vger.kernel.org>; Mon, 28 Apr 2025 10:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745836139; cv=none; b=qC/K+vz64iFA1gc7p8hWO+3kiXtWeTW1xbhdftPa1FMHyi9eR2M266kznQSeiKNoiaRQuaQBEq/8rU6AS1OrR7ujN/uforBKgvcyhAcHaTnKORBzARA+h9Kp+uvOk+imBvyajAW6Q2OxXgW0aGTviBKfNzNXb9NgPu/viDEnckA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745836139; c=relaxed/simple;
	bh=ruIOSYQ6oFubP9SOiCH9r1ANRa+KN/sarSp1jPgeVJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T9uEdY8zkmtIZpxX3z6m+KD2sL8Z+PPPnJ0pcKVVjj+DwNVbYTbnJs1HhpcAB/e+Op33iACGKxzzfQzNjbz7YaXg5GoGYet+TTB9V6cTq+CznZfJJgg4kwkT+zlTevlJ6ffBTOBm93bWTD+wgsg15v4GGwc++RdNQAIbDriDplY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=XrUB3yLX; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="XrUB3yLX"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e6e1cd3f451so3522794276.2
        for <linux-crypto@vger.kernel.org>; Mon, 28 Apr 2025 03:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1745836137; x=1746440937; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ad2hfYAaXs4UcPz87uwN8ese08Wo0cmaLOPntlJfTgg=;
        b=XrUB3yLXzeLjS4CKeq+Orb+d/TUv7EteRcwZ1EavXq/nHS1mLSN8XESHvRWn69OlQr
         SJSwZ+2SyYB0LoGhGXBjGpsIJ9GWufJBuXN6OD4VpO/VIH6fYJ4O8GPaLiYJpyrKIOfZ
         LP3/Yn0pqFTEETknLy91OrHPz0Z54xkMfazHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745836137; x=1746440937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ad2hfYAaXs4UcPz87uwN8ese08Wo0cmaLOPntlJfTgg=;
        b=eUuTsO/j9T1ptpDCUDOC4JvJvItIap0/PZJ4OoDZWt+u/NwHMt+JkmSIwSTJyxuCvc
         HsL5m0MbXXxSZDEB1yZcKj1V8QE85zSBb8qyW8Bfsy/PTzW8bxUVvvwRYBbc3wIConxa
         F/opaWwhICBR+ItT/1NYm0iLZaVBkPIWpDwEt2epv9A30ccfGur1PllDCSaKuJMgdAME
         yuAlUPeoLNnLIfd4ZAZmGvTnSR2dx3e0Ycvp8pIJfh3ndVAsusEBQju2iqkc1PjgJv9R
         UGt65YHJFhDhD4Z8pmMUVOjS3SgL+gNEGBB5CYE2RoUS9mZOBrpBaIWII/gidxLCCf6Q
         vPPQ==
X-Gm-Message-State: AOJu0YzkUm63YIOV2NR5cNNyThvmqwt7r6dJCzs6wIpzuKu5ZIeGsFjC
	iOyl2rzqLwYk+4tn9kH0nH+QbibSPg8vqLypGeNb5U6qWNNAmswE8Mm1s6XNPYqebghGvOo56ZX
	9ff+sBdAlWDhL+Bxkohos04chh2GZcn+AUhipXA==
X-Gm-Gg: ASbGncs7vY0gR7UYJdmguV45z1r9ABSdIdLol3cTh2ZqMSeNnO/xTbylFTaeMCkIrvI
	sOdDqxo0aWe07xVPKbr4aDyk95emxU3k/H5AlI27OzAEbWf21H/O0oIa/OsnigTGxpNUc5HetDc
	Oiu2ED8ude0jLXqQUbbmK/pnQ2tlwxt+Vjfgy81nOCg82DjEpdj0Fhymk=
X-Google-Smtp-Source: AGHT+IFOb7bkGF47Z0Sj5W/G1ukJMIQOyZSKkD3DfgEzKXPBH1RQeqjnbUPM7iUBBh9JiUmhlk/NxninlzzPK6KVA3Y=
X-Received: by 2002:a05:6902:c04:b0:e71:2a10:8fd with SMTP id
 3f1490d57ef6-e73167e73f2mr14760300276.26.1745836137015; Mon, 28 Apr 2025
 03:28:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250423101518.1360552-1-pavitrakumarm@vayavyalabs.com>
 <20250423101518.1360552-2-pavitrakumarm@vayavyalabs.com> <e5f47f52-807d-45ce-bd62-090f4af72b3a@kernel.org>
 <CALxtO0k0jeZF=Y5Ut_yhX8DxC3hVHWpnrcdJeBXP_GpA=O5T4w@mail.gmail.com> <628faa57-f135-4f62-9827-5c98d9265391@kernel.org>
In-Reply-To: <628faa57-f135-4f62-9827-5c98d9265391@kernel.org>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Mon, 28 Apr 2025 15:58:45 +0530
X-Gm-Features: ATxdqUHPW2Bs_aWRQo6-S8EuhqMYj3WXHtFTMowNg0HzbX933XBEOfJ7EiAHZM4
Message-ID: <CALxtO0nFtAiK8oG=7k8bhxwwxcQo0XZawEbkRG9Prg4z6JshXQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/6] dt-bindings: crypto: Document support for SPAcc
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	herbert@gondor.apana.org.au, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, 
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,
   Its not possible to use it outside of the SoC. So for the current
SPAcc IP testing we flash it to the PL part of the Zynq. Post which it
behaves like a peripheral sitting on the system bus. The device is
memory mapped and its interrupt is connected to GIC. A platform driver
works perfectly in this case and that's what we have.
   All the drivers that we have in the kernel are for crypto
hardware/engines, which already are available as part of some SoC in
the market. But in our case its still an IP. Since I dont have any
reference/expertise, it would be great if you could suggest a way to
handle such a case.

Warm regards,
PK

On Mon, Apr 28, 2025 at 2:41=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.or=
g> wrote:
>
> On 28/04/2025 10:13, Pavitrakumar Managutte wrote:
> > Hi Krzysztof,
> >    My comments are embedded below.
> >
> > Warm regards,
> > PK
> >
> >
> > On Wed, Apr 23, 2025 at 6:23=E2=80=AFPM Krzysztof Kozlowski <krzk@kerne=
l.org> wrote:
> >
> >> On 23/04/2025 12:15, Pavitrakumar M wrote:
> >>> From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> >>>
> >>> Add DT bindings related to the SPAcc driver for Documentation.
> >>> DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
> >>
> >> These IP blocks are rarely usable on their own and need SoC
> >> customization. Where any SoC users? Where are any SoC compatibles?
> >>
> >
> > PK: This is a new IP designed by Synopsys, which we tested on the Xilin=
x
> > Zynqmp FPGA (ZCU104 board).
> >        This is NOT a part of any SoC yet, but it might be in future.
> >        Could you offer suggestions on how to handle such a case?
>
> Hm? How is it possible to use it outside of a SoC?
>
> Best regards,
> Krzysztof
