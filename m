Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697708F54;
	Sun, 20 Apr 2025 23:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745192157; cv=none; b=QtApB9uNNLQfFjse4f5HG8E16eagyT57ZMzfKGw/IeVKHOREva97mBcD5iqsGcil767BDX0BHoOXxKoBN7zjNz8owYAN/C3KHPti0LaLk6tUrVi2cgDrf/90a8cc/BKPm9vDTbXpzsyxkinilcVzeOxYGVdlws46u1mNBJXw8wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745192157; c=relaxed/simple;
	bh=qjGjTL6Po79ziqJrDu0AuZPW3ar2gbMutda943+RsN4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFDim8N7xCGJPXdlHz6SPBPtcKN2nmO63a3WuuQPYACdMPLdF+IY++uV1VJqCzImvt0UMCUP5cepdxyHnyOPYYXY6vmh3E6/xOmBPWLU4CEV5seZhsn4j5WICYo/sZ6qR5VFkbsTErxrmCaj1AY2LDdCCjgqB5OJDCbv+NFph7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LDPgk1HL; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LDPgk1HL"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6e8f7019422so35651936d6.1;
        Sun, 20 Apr 2025 16:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745192155; x=1745796955; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjGjTL6Po79ziqJrDu0AuZPW3ar2gbMutda943+RsN4=;
        b=LDPgk1HLfBgNHL44CBEF/AAP1cYqP/ihgWLbDW/ecxpe5MCpUoxAUva/VBmK3zmjxB
         5pqqwFl/DTBglIXEAT6ynqbTEBHK5XSD2jFW3qSaUzrtvp36MUJ/xlSjv2F4YM4swAie
         BS10fjFPRdbGUXM7qypYOv3KzNOQW6BpYeTuUe0qMn5BjQNfKB06H7z2YzD2E60NwewU
         QkTY+3oMzW1r3UXUICIQanWjhBuc+k0FkKaPZoJuYRMwjnT4C+5Gwn6XCASW8njK6p8v
         CeMdqMuJGRpKlEORJVckfnzDqCMTpdX69onyDJPuSGoh5bA2K6Q3E6zp/REbBbo7/40Y
         1PAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745192155; x=1745796955;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qjGjTL6Po79ziqJrDu0AuZPW3ar2gbMutda943+RsN4=;
        b=QnFC0nx3GnDpis50wkF6UaPYxOnCxWgDM2ts+r3qfjPJCPjWuJ524whutnBUOeLqvd
         6x9Bs/KLxgu5owe90w61Dtn6EnQKQ8TJlYCx08CVZXyG2P6g2c87dKx0nlHk6AaHhuc9
         wrFpeeXUCx1UwtltHH88qyn0oOs1RzdJgvRuf3scowMQJgXj5FRuT3lXTvEgiiKuKukM
         hwF50Js9uqWdf52/cbN7/+cgIrGT0ogP/OqhqmdU+w+Q+koYSfcsv6dLujAo+zuzmC6v
         A6X0qwTD717Ric5JEk7Iulc4JE0Em4bgM5o2iukhrOQg1bf/gl08HjEDJk21MXmLAdxe
         XOkg==
X-Forwarded-Encrypted: i=1; AJvYcCUcoQ5MLk8JzyNpliKWg8YZUrwcqSefDsaM/umbJyRkc6j9lkSnVkhECorIsyazvXbFbcfX2dlTfYic52JU@vger.kernel.org, AJvYcCXWmkFoxi3kYnlJGfJVg143dqwookrD0iGUGdYPjfQ2QkBzsYQPgUYmALTHOjWKMV2ZbQA9GXlLgmPjH8U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7lHdXrvEx9hBew2RuBbTCbpBBl8lEGPrrqKdZbY0aZmiiJsIF
	ore3BisgvsMjIEtdsCgFAGzfaLxAynudnXXJ31I6p3sbn6yQNi/ITfmf4lqKLy9WUR91ur74UN/
	CwfJ5qhsVRJN7odSp50/OP1BpTOM=
X-Gm-Gg: ASbGncvXoGJkRE9WafY+KbCPFKXEtQOSAR7hSxuorWMYWq/YJ1uJm2UyH+c1vy+MSQm
	rFRUZSyCyFOYLfl7ktGLZpwu3R0XoTwapp9O+l/wqav1UT5zsq3mNpbnWzVmVeXlws6LoFhrWkd
	V09MOfuDhvxyE1Ncz2+esg+g==
X-Google-Smtp-Source: AGHT+IHdNNYRsa25bnMcyh/WPT6s26Y8OwqmugmBGLcwg4wBy26Fr+V/VgqBH5VjDy5bKuGSgYmpv2ge3VKWY7HW5kc=
X-Received: by 2002:a05:6214:2125:b0:6e8:9e8f:cfb with SMTP id
 6a1803df08f44-6f2c456695fmr132115026d6.24.1745192155186; Sun, 20 Apr 2025
 16:35:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z8n5CCmELvpUwi3B@google.com> <PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z8tJOi5G_3dpK31v@google.com> <PH8SPRMB00447B066A769C76F57F8800C9D42@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z88h1mPkYNM6yOGE@google.com> <SA3PR11MB812082535F1E6D63BC0F1412C9DF2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9mB5IbNEdNdtmUp@google.com> <SA3PR11MB81206531E9B3C7F13F5740A2C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9nECMZW67F8XYoV@google.com> <SA3PR11MB8120A474C20104FF22CCE396C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9n-OnGPK7BOdGxR@google.com> <SA3PR11MB81202E35C1CAF0409711A1B0C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <20250420140116.b6db3aafcc2f99569190c97e@linux-foundation.org>
In-Reply-To: <20250420140116.b6db3aafcc2f99569190c97e@linux-foundation.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 20 Apr 2025 16:35:44 -0700
X-Gm-Features: ATxdqUEe8--dEb98CAknk8DTY3Sx-DR0xLupm5QdAGa-erg78oxKP9kiqxeU2po
Message-ID: <CAKEwX=P39kvB9Ei1xt+iOcDRMr32=ujGiKKa=e947k0MyJ7xZA@mail.gmail.com>
Subject: Re: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>, m95d@psihoexpert.ro
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 20, 2025 at 2:01=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D220035 might be related to
> this patchset?

The bug report is a bit confusing to me. The dmesg trace says the
kernel version is 6.14, but the reporter says the bisected broken
commit is one of the 6.15-rc1 merge requests?

Anyhow, this looks like a crypto/compression infra bug. Herbert, does
this ring any bell for you?
