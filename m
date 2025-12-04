Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE0030CD81
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 21:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764884342; cv=none; b=ctGKdLipOwfecnki+t+1dg4bchMWrQGfbK+ke+51hZqI2utwTZJ1D156dXZWznHGeE/jMafEgisUdQ6Q/frXvK/A6iWhcRkm2wWLX5aGbyhS+2zykOgwg7WliuyV1QVYfdRhoxw8Hyb73/uSr67R+h+/acdUjt9qgngxPjVXhhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764884342; c=relaxed/simple;
	bh=7a4apymdvLMzvSssxC4jYelA1RIA+3s9lZemZv4hiVM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E4YqpHtMDTW6030FtjMm0BsOPBy70+lI90A02a0/t6yfNVF+Wz5mMwgStx9PpSSX5oJH/SvACD2JBjlw6fp2Y7OxkzcwwaeZXKX5KjGDjbJBev8Awto99n1+GJxGLk+/ojzyrUvfpdXhYDevadM16vJIjei2m3o7c9hBJtRt2Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VgROTT6i; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VgROTT6i"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso1658573b3a.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 13:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764884339; x=1765489139; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7a4apymdvLMzvSssxC4jYelA1RIA+3s9lZemZv4hiVM=;
        b=VgROTT6iCbymOwdWe88ItMImSnd/3klSljVqvueoiceuL9xfYAp2jEUrfe1udBpNaM
         3PA0vJkcscc8oTOwnOnT5CACoXdnJtRdaVmuSk9fnmuGyLzhpZxXKkzYFj0xzITC4SgT
         0wE98MfNqRGXpR7u/En8Elii8u1ko4b1dl7MsGbNxtEwvI5cRnTEG+J2sY6M/VsLLRQI
         H21xP0x9VaifT72XCGdVi0G1/h2vScSxA9CVNZUq2ZqjRcFT1zOzRcEtFZs0JbMDuyxM
         pcKP4oI7tQzzaXsmLay6tVCf2FOu5p2zz4NTKCNMPVi0yde7XNgxhqFPC18vseQGbIQx
         jrww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764884340; x=1765489140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7a4apymdvLMzvSssxC4jYelA1RIA+3s9lZemZv4hiVM=;
        b=q5rzjoXIzIf1yhR7U6zdA+qI06D1OvrrNjmqnRIAqkUjVh6VoHek3lrzhsBvJtL4FE
         yyqoyscejpwDAP+wG+jWRSSf31xsgCZIr/VsAOiic4eIJiNvm/l8BPFqdJRPv9Q2oxIs
         vuCp6GCMd21JSHTgd3/WJxMz9InS1xD5GWnjVCZEFBHhXiOlqz/U5QLTNSfvJVH3JCFV
         TU53N7JmbwnapfFdxx3vCt/5dUG9lhEhNlTfeqllA5V/WMm9yaQJayBuFCfESgWl7FTC
         q592AUPTOrPe/5KBb3xW2FVrvQv2E0f4lSs/9r6VMVde4M91eqWBRnix50a+WtlHcBAQ
         /zJw==
X-Forwarded-Encrypted: i=1; AJvYcCWji1poL6JqsA/BdEJjk4B6P3uwRv2omYkpOnzvxDinRJ3sA9t29uCcfnpSg1lltP79L9l4964o2+PbDEk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeW3tRIZI49xmIfMQ8ZiXNpfKoGWnLJV+veh01Chx96nScY+1C
	7/IeBuElqIBSiJv8ZSZlLJ3VV448AZXzPYixSb/x4CyrIFvwl11bzoRZGOfRd4oUW38C3wPqtRo
	68eNppA/OwZf7kHkX2DxYB2drbJGOnPs=
X-Gm-Gg: ASbGncvZ8BO4dnMA45TnJssHqm2VQgbj4ibbKG1dWhxnNfsIjNKQBWI5QtIMDlCjIAU
	x+Zme9C6++jql/TQxVX6ceUX1raxueitKhvoLEZfkbl0GMr7bkSF7vIcNKLVz5e0VRHZKAxH3bH
	ZkIauh4Ffm0H0z0iqw1Oa7JP0MwkBMuWDPn+DkaVfgEdZeXmjJLrbFlTlZOcUk0wQ8K8r+wBMaI
	Y5e16d7w3a8w7RDmtN9FnYVnb7CopsjB0n1F8WkeWRrJDcORLKXj0H3nQYbK+1TNUsm1ZqJUU0o
	kz3siTw=
X-Google-Smtp-Source: AGHT+IECekJX45uTX+rdJAmlqhj0+olEbSOJgBEbG8bNxunXp+W3mrNWLKVJtLnQ1vPBK4dnSvd+pVp/HLiKh/idEFw=
X-Received: by 2002:a05:7022:410:b0:11b:82b8:40ae with SMTP id
 a92af1059eb24-11df0c48844mr6019656c88.18.1764884339502; Thu, 04 Dec 2025
 13:38:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
 <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
 <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com>
 <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com> <CAHp75Vd9VOH2zHFmoU5rrQCRqJSBG2UDCfKgvOR6hwavDVqHeQ@mail.gmail.com>
In-Reply-To: <CAHp75Vd9VOH2zHFmoU5rrQCRqJSBG2UDCfKgvOR6hwavDVqHeQ@mail.gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Thu, 4 Dec 2025 22:38:47 +0100
X-Gm-Features: AWmQ_bkrTLjU1bji3dq_q0_9aUL2KpYGKaTrBSm-1EAw-k6T0Q2iOVkzFyxbFXs
Message-ID: <CANgxf6woLz0VBnmFqrhwQiLwrQkb5oLb+1tHoOU5+aN=a21k8Q@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Marco Elver <elver@google.com>, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, shuah@kernel.org, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 6:10=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Thu, Dec 4, 2025 at 5:36=E2=80=AFPM Marco Elver <elver@google.com> wro=
te:
> > On Thu, 4 Dec 2025 at 16:34, Andy Shevchenko <andy.shevchenko@gmail.com=
> wrote:
> > > On Thu, Dec 4, 2025 at 5:33=E2=80=AFPM Marco Elver <elver@google.com>=
 wrote:
> > > > On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail=
.com> wrote:
>
> [..]
>
> > > > > > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > > > > > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> > > > >
> > > > > I believe one of two SoBs is enough.
> > > >
> > > > Per my interpretation of
> > > > https://docs.kernel.org/process/submitting-patches.html#developer-s=
-certificate-of-origin-1-1
> > > > it's required where the affiliation/identity of the author has
> > > > changed; it's as if another developer picked up the series and
> > > > continues improving it.
> > >
> > > Since the original address does not exist, the Originally-by: or free
> > > text in the commit message / cover letter should be enough.
> >
> > The original copyright still applies, and the SOB captures that.
>
> The problem is that you put a non-existing person there. Make sure
> emails are not bouncing and I will not object (however, I just saw
> Greg's reply).

Understood. I'll stick to the single SoB in the next version as Greg
suggested.

This address is permanent, so there won't be any bouncing issues.
