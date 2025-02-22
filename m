Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CC620127F;
	Sat, 22 Feb 2025 07:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740208407; cv=none; b=MenugAZ3gCaZtwDUoYE/WmmIi/Uc3VhgNcZ+UtsuNFOsTWyi7VrrChN9q86h/AXUbQtB+5MzYD1xxLSFjH01G1GeUKHng0lmMCOICw9Hvi0kvbwDI95WM5ePoEOi7hMyfy0C6M7NUWoeg1wTGuijraLZmGFLmlKFN7zgo0S1O/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740208407; c=relaxed/simple;
	bh=aa7CFmClhR49ePUFJmbty3X+pmWl/xPF6/ZO21Zf4G8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D8OuRiUbyebtJwL9zfC43+w+VcLvXEKgtFPh9wvG7aA8yxGE3fjRBiTfP4tADmyrvFcqB1RlD1qOdERRcMKw9n4JPo/Ui/xC1pOWa/W0mDggdRwvFHyuZ1GYvOSYKjxo1FPWOAEP1JBmkMFdT74yy3nQKZizGgHOtAApEdI+AFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fkUWRee3; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fkUWRee3"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-4be60963da5so1817226137.2;
        Fri, 21 Feb 2025 23:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740208405; x=1740813205; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w9DEPfIUaeTXMgfFcGEhuQIhfSpChWt0G71yif5xy60=;
        b=fkUWRee3F8FcY57N8qy9Lt/ls/zx/1qo1jY2ROXQVJCks3OrI2mg1M7mivwl9G8an3
         zbwS9QW7OFAxEXCGQhHtM3wuaHXFdchv+COUlPSNR96+E3qTg9fmVH3I1iY+Ot7PrdEl
         sgmEqeT/pbMc6iSMbtM6qYwImdQxuOTM0ytiozt8bV3fMvlIvLmNCv0tVfADcS5apwiA
         atHI4F+RnT/jhG99Tss6WfTe3VQuH9Xk2p4GkUFqnnm30ytHw4R03KarHgbC87wb73o2
         4hToUHhfsPVFeYHScjCaFmUo/tvIU28OuG4hGydIEYdhvFeNSVuuGQ0qnc9H9f3dXOxw
         QdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740208405; x=1740813205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w9DEPfIUaeTXMgfFcGEhuQIhfSpChWt0G71yif5xy60=;
        b=c0/sENW9zUnHz8UDYGxe82u+zsNuubuoJkV+WUwecdZFYu79WdERPuZI84hRa17/UG
         jge3RzbjOspkzH8c0S4WwkN/Jz/lbGmP3WXe7fVOs2TkzTbhOBnF19HhyIUBg4s3yJMV
         W6vQVOtLXMytwYJIdKWPOJZXEDx5/4E8rdQSy8pX0F1E8uTokPkKn+6ZQVecTqpdTKpK
         TdZ/a0OHuCX0A13VivLioNNMPw4ZU9Eo/cCYfmGaGVwhM0n0WS+SUU2JXnLc+vfefSe5
         EN5fpOScOTGRzBI6KOXE8aMacJq6xK1SyAIuqYEwTvGDhP0VRKbLUd/5nlrtFKzFipMb
         t8RA==
X-Forwarded-Encrypted: i=1; AJvYcCUnNRDfTN6+/Y+m2Ej7+VIoQHkWM94My31Y02M4Zx25UWmqLhan6pl7T9MQzT33FzO0TgeQ/kb/NZSyXg+2@vger.kernel.org, AJvYcCXwA+9dk96ItA+Z2mj56lwz6BSB/FHQMqN4K+94fl4pjpOWfLIdmhoznZ1eJbAjRrXUeb4d0NhvSHOvAsE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdFZWPtDeGf+iBpfQOMg2nk+XuXQuBqhSqHbviTcUwML3kff8c
	jJXhUReB3hi+bhuU9LvcHqdAoJ0Gp0cuyvwPPKYycLdAXrhd5c/2HnBU8PPTU+zRF6jxxWEqYK9
	vn9AbTHuXHFUKhkNXIKvyLJVIDBs=
X-Gm-Gg: ASbGnctv5/iT8U+V+4Q5Bd2jjt14EHtyn2vu/B0gvZ3gVnvL4etcFWS2d5fkP+okDGw
	OExc5PcyHkHBIRdU4HZu9q8afr1aEmby7TY046YUXLBO0bLyoiurxp47QkrGvF/D8l/C2JDo9ym
	3PfzXRUWU=
X-Google-Smtp-Source: AGHT+IEjCNuNtx0HqgQzp0hQ1PJkoUz6gjyrbF7QTZN2cGChVV7Ye8nzJ0mfsDS0KbBqSYD5fzGU3lyxkVdS/G6inkI=
X-Received: by 2002:a05:6102:3590:b0:4bb:cbbc:38 with SMTP id
 ada2fe7eead31-4bfc27af44cmr3135788137.5.1740208404697; Fri, 21 Feb 2025
 23:13:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au> <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au> <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <Z7lv6JLax4S8vTtD@gondor.apana.org.au> <CAGsJ_4yAQxjTnSALZHAJZDdUnXKAYFvQCcjQjHiQSUip6cJGKg@mail.gmail.com>
 <Z7l0Hf-CFFjeKaZY@gondor.apana.org.au>
In-Reply-To: <Z7l0Hf-CFFjeKaZY@gondor.apana.org.au>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 22 Feb 2025 20:13:13 +1300
X-Gm-Features: AWEUYZm4ocljS3cZC8vMkzKYwy5pQFoaMBXQCfkIV2ImUhm2yWeLVnECTF6-ZyA
Message-ID: <CAGsJ_4zFdHUPELSYDkrN4ie2c73L6e=FEdQbDL3JckS4unKFpg@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, 
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 22, 2025 at 7:52=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Sat, Feb 22, 2025 at 07:41:54PM +1300, Barry Song wrote:
> >
> > probably no, as an incompressible page might become compressible
> > after changing an algorithm. This is possible, users may swith an
> > algorithm to compress an incompressible page in the background.
>
> I don't understand the difference.  If something is wrong with
> the system causing the compression algorithm to fail, shouldn't
> zswap just hobble along as if the page was incompressible?
>
> In fact it would be quite reasonble to try to recompress it if
> the admin did change the algorithm later because the error may
> have been specific to the previous algorithm implementation.
>

Somehow, I find your comment reasonable. Another point I want
to mention is the semantic difference. For example, in a system
with only one algorithm, a dst_buf overflow still means a successful
swap-out. However, other errors actually indicate an I/O failure.
In such cases, vmscan.c will log the relevant error in pageout() to
notify the user.

Anyway, I'm not an authority on this, so I=E2=80=99d like to see comments
from Minchan, Sergey, and Yosry.

> Of course I totally agree that there should be a reporting
> mechanism to catch errors that admins/developers should know
> about.  But apart from reporting that error there should be
> no difference between an inherently incompressible page vs.
> buggy algorithm/broken hardware failing to compress the page.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>

Thanks
Barry
