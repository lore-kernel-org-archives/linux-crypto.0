Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31D11BBBE8
	for <linux-crypto@vger.kernel.org>; Tue,  1 Oct 2024 07:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727767430; cv=none; b=Z/sJc5pVFsJb2YZz/xvFN342CCHBl5Po8nhzo6Hs/q59YIRL7NKC6MUabe1grpKCE6pIutNOYvGoPl3fwoH4SqSECRCQT5jJkfHXBgrBT66e59ZeDtjnA5aE/goHsXmZTreGwyj50n7lVxfW2+47JLvPUn9yTD0LcdRi987eckw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727767430; c=relaxed/simple;
	bh=BUh6tRVRUSnz9JRAFV/mB0Ih/eQ7zBStnIqe5JL16Pw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e/0S/MtY4nzmbQM4W7DDxMy4fYbBYr0yowBfi1W5oiA5yVtQJs9VCY76HYaaN1CpnUgWc02/5oGJ7ml8Z2cD0asEQhslrDDT2sO/Cq9w7ELqiSRWchPR4pjS3dEesvRe9b9JzNnMluIuLLxe6OENx9qR7G3rFkw2lmCt2XddHLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=GQGBC/XP; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="GQGBC/XP"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e026a2238d8so4919900276.0
        for <linux-crypto@vger.kernel.org>; Tue, 01 Oct 2024 00:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1727767428; x=1728372228; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3BDVsIR+AWM8VLHO3U4ofx1mhP0jR6b5o+0aZeIJ+kg=;
        b=GQGBC/XPbjZiOyTJ67R62LKspFFlSjxSb+MO2aDww/940E6b9FNxtywJE6oNO0uaMP
         G6CIlQe37QNbIbhQeAwKE7jjGc5E2KaxFsb54m+SUo9G4vGITMzkD9mJmO+W1IkbGdSA
         16kzqBnYdd98g/ul1A2vaddHfycanQW3nTm/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727767428; x=1728372228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3BDVsIR+AWM8VLHO3U4ofx1mhP0jR6b5o+0aZeIJ+kg=;
        b=lm8fbkMfprOTQFZGOkD++Za9y/o41FfocdaP0tUrJYa2aJSv/sIhwtzAjqxnO16wYN
         /iT4ECWUmw9DImE0zohh3/GfLy/koPCIbuc99QBMjyFi03yb+vnCSk4hOpan6iuHDPl7
         5XVa2uQfSsQFzKrAD5LFNWDtK3ARsNOVkDcFVQ8r7Dgp0yQadr0UtkSxgqPWDlhWcFXe
         cXdfk3/0kSZrm/9qZeVeIluBrCasqLC2aO4gkHxJ2+me5jwtYPo3vTpvXz8+QixEgGIh
         1iSb8JI4xrMAEDoteKpdV3HVYUihsULTYYFIpx6Hyeg0HLhm5tfDujUfLsA+Q9GN9zvZ
         BGZA==
X-Forwarded-Encrypted: i=1; AJvYcCW8/yswtMARfjSzrdG41yr4us1HIhT8Ig4TYLiBj3N2/KPUOiNYUn503y2cgxwH54gCBcWPqeoCez1/ZJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyzxQ9UmVpDLcRYfSNND4AgELYQEq84hfXnHYJrXuYCn2XWgiY
	MRynaI7HCHTOM70poDxtYdu4hUqtA3VRNwOzb1iV5dbgIOC9iCdZnTj/1WiGH2fZ9/WByE9WMWU
	b0KKhVVBeKKAzXNxCkNWJJ9RWEqS0u4xCtyOaFw==
X-Google-Smtp-Source: AGHT+IEDx6s60OXbbnFg6D7pGUQUUjMuK6DZaBWnI4T3NO+xHZKD4YwwtWu09YZ4TXBLLfXRKiJEiRFbWe3k2eo7T5Y=
X-Received: by 2002:a05:6902:70c:b0:e26:2bb7:19d4 with SMTP id
 3f1490d57ef6-e262bb72ce4mr1861696276.7.1727767427893; Tue, 01 Oct 2024
 00:23:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240930093054.215809-1-pavitrakumarm@vayavyalabs.com>
 <20240930093054.215809-8-pavitrakumarm@vayavyalabs.com> <fsp2l2ktvwznm64kwlb23yxlvioi47inzdwcngowbvet43us4k@svi4b7eq7gx7>
In-Reply-To: <fsp2l2ktvwznm64kwlb23yxlvioi47inzdwcngowbvet43us4k@svi4b7eq7gx7>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Tue, 1 Oct 2024 12:53:36 +0530
Message-ID: <CALxtO0nPzYpW7n37c5hdcigQtq+NOSxaPmLqeiwwiB8kumHjWw@mail.gmail.com>
Subject: Re: [PATCH v9 7/7] dt-bindings: crypto: Document support for SPAcc
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: devicetree@vger.kernel.org, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, robh@kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,
  I fully agree, some things got missed out; they were supposed to be addre=
ssed
  in the v9 patch. Not contesting that. My apologies.

  We are doing a code cleanup based on your inputs and previous comments.
  I will address everything.

Warm regards,
PK



On Tue, Oct 1, 2024 at 12:03=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.or=
g> wrote:
>
> On Mon, Sep 30, 2024 at 03:00:54PM +0530, Pavitrakumar M wrote:
> > Add DT bindings related to the SPAcc driver for Documentation.
> > DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
> > Engine is a crypto IP designed by Synopsys.
> >
> > Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> > Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> > Co-developed-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> > Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> > Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
>
> Please run scripts/checkpatch.pl and fix reported warnings. Then please
> run  and (probably) fix more warnings.
> Some warnings can be ignored, especially from --strict run, but the code
> here looks like it needs a fix. Feel free to get in touch if the warning
> is not clear.
>
> Best regards,
> Krzysztof
>
