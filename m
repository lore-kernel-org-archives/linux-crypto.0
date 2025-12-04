Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32F82D1F64
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 15:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764862142; cv=none; b=n3z3j55rXpkHjyOP7ZHvUMGt43PxHtdSFnvbSZXS73Ln0SHGXn6dbwx+fTeT7KmeQKcqQQmI/RJCpTAXMuIZ0MWBfQ7vQ0IqBYBZ7QaPVdWanvTANJiBA3dCeLPoQWMawE6ZwHetyDlT/tK3unyKWRbI/PGFzv60TPdaYwxBI7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764862142; c=relaxed/simple;
	bh=1MI5aTy+R1SqmI1yzGL1uAuu8o2FFOs1gD1ZnAhB164=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FYm48KW7ngOVIOt0ql0vYUxHqu3dtLl3nR4GEEY7MiERFujB17ANTZ7HN6Dx+GyUpwHyh46qLuCbdF6I6IMUzzMhSQeOizIkCmYrL9HfZ49ZA5RHPkkjI1j+2WOeZKr1EyIM424mH0p7lQ3NY92l4+zWzeIb82ez1YHWkIxmrg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QWZ5FDZv; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QWZ5FDZv"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b734fcbf1e3so236003366b.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 07:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764862138; x=1765466938; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1MI5aTy+R1SqmI1yzGL1uAuu8o2FFOs1gD1ZnAhB164=;
        b=QWZ5FDZv96+KwA1rTK+DkIFg+s76XKo3z89q+CdnFDfXb2Vik7rMJIa6CD7ojj28ZO
         DR2imRI824JQTdJwIkFJjeIzNw3rirEHzTHfoG7hcTH8SkjSgxUGR9Jg3b7ej66/eAcb
         bYGh2tPVh9HvAgGADAKd4AAKy/ua0lMAZoMTBH2W2hGirJAT7vaUvjt+Xo/4Xx5nWJZW
         TDtBk7ZWOANXmxH96UeAiuN6G04aX6/I5Lnrr4Xq4rtS3iEhiJQi1uMkmu3vW2sgobvL
         j49ysw2FKKO8F3r72HMAd/KtR4PQEKmY6Ux5mTHkXFLFzkNdf7+OPUP6K2QscSih/h9x
         IKhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862138; x=1765466938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1MI5aTy+R1SqmI1yzGL1uAuu8o2FFOs1gD1ZnAhB164=;
        b=bxvEySQ5AZ6RTQ4N9tWjc/VQ3oaR7Aui+lfe9B93J+eC6lrjASqkEIuNF3x6UP5gUO
         xQzyHMcK0pSsXVB++TEHciTtyQqAkMyUZb6jLZNq6ALe9WEABNygmbWZXgKGJxoes2T9
         8rnrXaCgBQaI1DbkctHhYXajsjlhumay0puZTFyB9UUeuilqZypfh5eHb3vnW+q/xagQ
         MRWGBccSX5s3KSWDIt9TGW9JchyQBndJNyeyF/aDmW8KPxzbptgkzqvgO2z41vkV2vWo
         EOXKiYm1MaZg30pZOYEssonJh/YBeeuL3my569VKCgSdvXyk7OTeRkzre+q0TfYRXWOo
         Y9NQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYkppFzVH6COPD1A9X0ucKptoTTz8q7l+kiLmGHXp81f2BJwVGaVWdoGazUIiJEiP5nL8JEK4WZdg+w2M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGyatHyWLveJAovLUZ/9yLrSB5MApgxJl0S7BG4iFJwWJoTGDB
	m1rBQzo9cFsx+XidZ72/zzlQAt3MO6avfX+jD6oJEyhujeBI6dKvr7Kfnoaravn6QIHTL9h8qVw
	k/CuCpkK22IzC7SvJYQpzS24crEMbous=
X-Gm-Gg: ASbGncu+ght5+10c1zBNriH1EWqwZHHe0009wtoHqsiTLvpUvIhBd9YUTOKzvxlnTET
	V9kzYJa9moKhA2ol0/6jC+/l5QYJVPh7L+pwYCw8F9bkfRiSdKLXSZNR/I5PsA8XEEabkuyw7uA
	v2EEoIJDeer5zmsWYDwVyYEFKXFxn5qbUIByAB9N/6qIAWJvcaIZU8hfvCfstbf46CavsBxqAd4
	5Y6G2rLaBrkqwx8R5r6WnVMBbzcHsfaoY7pfN1fTdtl2lhziJLOXUQ6/v3I0EF8o9IOs29zV84r
	9XDf08xyMg953VgAetsFUNKe8jRPR1w2YVuKtRFod48fB3Uc44mVN2MrDIopDaaY7UKQHOb9bAr
	pSGz6KA==
X-Google-Smtp-Source: AGHT+IH6eUYV4d+UfitIHpvZN9b37gSPLRdlm7zTBgPDJFCsNGp7+lPPZkPWyRsTwe+8SSCyA0Xqdo2giH7fy6Ln9N4=
X-Received: by 2002:a17:907:7b85:b0:b73:8792:c3ca with SMTP id
 a640c23a62f3a-b79dc51af8cmr691284766b.32.1764862137818; Thu, 04 Dec 2025
 07:28:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
In-Reply-To: <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 4 Dec 2025 17:28:21 +0200
X-Gm-Features: AWmQ_bneRNOGjAW4jDt5halz319V6V9HvLuc9jLOtFFaLshPIC4KOutQs5--etw
Message-ID: <CAHp75VfgETRHgGkJdVezraFDogtB-KQT1UDWn2RyWeNZ6hCU=A@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: glider@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 5:26=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Thu, Dec 4, 2025 at 4:13=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gma=
il.com> wrote:

> > From: Ethan Graham <ethangraham@google.com>

OK, this bounces. Please update the series to make sure you have no
dead addresses in it.

--=20
With Best Regards,
Andy Shevchenko
