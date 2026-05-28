Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3928E3E00AE;
	Thu, 28 May 2026 13:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779975834; cv=none; b=RhR8PBnkHbClE7HbNpTSyYKajasrtufXLDOYKFcu+ozuK8p7stqQWQdkxyih8D+hlj5hW/18c12xRGZ++xd3D2abQSzK6NQxVaYDauBAGeiCfEpz62X0RvbPPYVUEfgmtOm10Z07Bo1UaPzVyaEz5r/YUFg2tlCiAbAYRjX1eWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779975834; c=relaxed/simple;
	bh=B9knKPDls7lXRzyYof36NmOAnIwrn9ZAQB+O892r8x0=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=r0GUOXUQm6l89eR1sL0xymvY8a2fNtac6RgunloAwaaQLB5g81KtBEKmqQBU49H9xJCg84V0iJ7gspbiHwNXAjutUtUSojrLzZFhTd3Yswd4gSkiaqk6pEkLEuZm39IajKRZG2XBtl7v6EP+Vqv7IYhAj97iar/eW7808cBOJlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VBr0uz1J; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VBr0uz1J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779975833; x=1811511833;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=B9knKPDls7lXRzyYof36NmOAnIwrn9ZAQB+O892r8x0=;
  b=VBr0uz1JSTO9mhlhYHqtNgjY5NjMePl6saABpCL5CxP/5XbkYP+nCDvo
   bSGtj/ETrrgUFdM2UTdPeTcDKVATVbdmshWcFpem/Aei1qDI2QZU81N+M
   r7yPXWINUkRA98PdPBv0VcNTNd6FfjrBIhJzqTOlSFKWbrEU33LbR37nd
   k36KZeCwOZVMPI5PjTE9gbyln/OuJmZXEczEzLeHnycKbbR/bu2UOej7Q
   WgxuVHfD2qcDK+2w2V9q0T9i3Q6z+lKWGbr8l/VSNEhE3CqxfSe0MfFuh
   rMudhQM0hJwLDBYQTs5N9qX0jl1taKK9dO5UlOykGV8tqm0FNIeoyr9tX
   w==;
X-CSE-ConnectionGUID: zCNesBORRHWh4EjhWCG7Rw==
X-CSE-MsgGUID: +jRH6ry5TpyrJnxxx5YH5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80878456"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="80878456"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 06:43:52 -0700
X-CSE-ConnectionGUID: sLktg+TUTmWQiwwiBF8fYQ==
X-CSE-MsgGUID: IMb3xBN/SfC6lzLUChwI7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="266454894"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.187])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 06:43:43 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Thu, 28 May 2026 16:43:40 +0300 (EEST)
To: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
cc: airlied@gmail.com, andersson@kernel.org, bentiss@kernel.org, 
    conor+dt@kernel.org, davem@davemloft.net, devicetree@vger.kernel.org, 
    dianders@chromium.org, dri-devel@lists.freedesktop.org, 
    Hans de Goede <hansg@kernel.org>, herbert@gondor.apana.org.au, 
    jesszhan0024@gmail.com, jikos@kernel.org, konradybcio@kernel.org, 
    krzk+dt@kernel.org, linux-arm-msm@vger.kernel.org, 
    linux-crypto@vger.kernel.org, linux-input@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, luzmaximilian@gmail.com, 
    maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
    neil.armstrong@linaro.org, platform-driver-x86@vger.kernel.org, 
    robh@kernel.org, simona@ffwll.ch, tzimmermann@suse.de
Subject: Re: [PATCH v2 3/7] platform/surface: SAM: Add support for Surface
 Pro 12in
In-Reply-To: <20260528133353.33312-1-harrison.vanderbyl@gmail.com>
Message-ID: <6d8be28e-1723-d529-103b-a4ba09277b41@linux.intel.com>
References: <6808166a-423c-c801-497a-ed95cccc8d0c@linux.intel.com> <20260528133353.33312-1-harrison.vanderbyl@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1771673666-1779975820=:1291"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1771673666-1779975820=:1291
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 28 May 2026, Harrison Vanderbyl wrote:

> On Thu, 28 May 2026, Ilpo J=C3=A4rvinen wrote:
> > Could you please confirm this penstash is correct (sam vs kip)?
> >
> > Sashiko suggested it might be wrong but take it's report with a grain o=
f
> > salt, it's AI after all and sometimes seems to extrapolate about HW to =
a
> > sibling HW without any real knowledge:
>=20
> Sam is correct here, unlike the surface pro 11,=20
> The pen stash is on the reverse of the screen,
> not on the detachable keyboard.
>=20
> An image of the pen stash in use is available here:
> https://cdn-dynmedia-1.microsoft.com/is/image/microsoftcorp/B04-Surface-P=
ro-12-inch-1Ed-Family-Rear?wid=3D1200&hei=3D900&qlt=3D90&bgc=3DF2F2F2F2&fmt=
=3Djpg
>=20
> When using the above config,
> pen stash events can be seen with evtest.

Thanks for confirming (not a big surprise AI couldn't know the spec but=20
it was worth checking if it would have been because of copy-paste).

I've applied this patch 3 now to the review-ilpo-next branch.

--=20
 i.

--8323328-1771673666-1779975820=:1291--
