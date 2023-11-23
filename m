Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vrull.eu header.i=@vrull.eu header.b="lg7COKea"
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1030D48
	for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2023 16:36:47 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-421ae930545so1776041cf.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2023 16:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google; t=1700699806; x=1701304606; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UgUFjwg5YKCYWy20zhpg67B3oU7YcI53msCKbkLw97A=;
        b=lg7COKeacC/UyEI0OA8lqUuj6mVlar1jXBz1wI8mobRxEXmWCd4cS6fWlqz9yok4J6
         M9RuWikLhrgVpFIJXu2uoQk7xjna0K9kY5RvZXwXOXDt++mM1sfPXKTSKMqBM9me2Mqv
         xS/Q+5jcd4DGqNZz0UeKqOFlgRdjMhey+/rN+4Gf68Ab7Cv8IlPwx6wqo0HmloJdj/XW
         tNS3KORHUyzvgl/4iO97IQgqQCtEg8PSlqmSnnCdRo0lAkqi0B2P/sI6++tsMWCDeZEN
         kSOo+MsHx7LzDidSUTHvnME+x3NJuAUb7vXbHcJBm/yTnf03yDWcYWFpnot41Xd1k0wJ
         rLUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700699806; x=1701304606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UgUFjwg5YKCYWy20zhpg67B3oU7YcI53msCKbkLw97A=;
        b=j2QI5HNMtTQ0Qx/QG5O82XFbDPJ5J48SLhEk7z7nmxWNJdcV4JH1mJYQ8Vnt1A1stO
         5R8bkJWXEYkG6OAHCChmleGe1bjbsZWB/Ne3jjcDmg5tx+6Ptw3LVKDSmHM4KT1VMlek
         tP/Qi5NqyEcJIJztO8zJvuEdkZPHnfEhVz2KmRVytZzzXHGFC2XJoSHfkz63yi9qyQ2g
         e1JnmO2cr+T0CfgJpO5SGk2eQW/HCQ5MPfRL+8nEKuV9n85Wf5mpLCfeitX9E+P+JFMn
         0LW5Bw82cMGESOrIi4Wyu4PtX8rY0XDT+S2j0m00QkPJY7mvi3unKJ/2hkluMOPRhlZE
         0Zpw==
X-Gm-Message-State: AOJu0YzwWvT8wlHnTB5Z5nZ/aDQUGKApnuEQV3gBQSIi3F7o6dozLA0G
	rjAG6XcSJ1Howuyb4MKcBW9lRh4VqTSrMhaO3Cd7qQ==
X-Google-Smtp-Source: AGHT+IEuKmqdWD3L1dw4SB+jHr8Nyxf+UqLOyocrnvYK0njHkJO9dhhq5iTmWTWi5k2sLSCbhOGjXqrbMw3KHTEwC3g=
X-Received: by 2002:a05:622a:5cd:b0:41e:1a89:2534 with SMTP id
 d13-20020a05622a05cd00b0041e1a892534mr5113240qtb.53.1700699806450; Wed, 22
 Nov 2023 16:36:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230711153743.1970625-1-heiko@sntech.de> <20230914001144.GA924@sol.localdomain>
 <ZQJdnCwf99Glggin@ghost> <3A0F6A71-C521-44A5-A56C-076AF3E13897@gmail.com>
 <DD3113B1-AB9F-4D6D-BD6E-8F75A83DA45D@sifive.com> <20231006194741.GA68531@google.com>
 <AB98E114-A8DE-492E-B078-7394EE4FA83E@sifive.com> <20231102040333.GC1498@sol.localdomain>
 <20231121235109.GE2172@sol.localdomain> <3416A95B-8687-44F6-9F77-D30AD6516094@sifive.com>
 <20231122234259.GB1541@sol.localdomain>
In-Reply-To: <20231122234259.GB1541@sol.localdomain>
From: =?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>
Date: Thu, 23 Nov 2023 01:36:34 +0100
Message-ID: <CAEg0e7iPGnaMKR9bT01-bGOUUToUG0o3Q7NBS_m8CbZdYWeBXA@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] RISC-V: support some cryptography accelerations
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jerry Shih <jerry.shih@sifive.com>, Charlie Jenkins <charlie@rivosinc.com>, 
	Heiko Stuebner <heiko@sntech.de>, palmer@dabbelt.com, paul.walmsley@sifive.com, 
	aou@eecs.berkeley.edu, herbert@gondor.apana.org.au, davem@davemloft.net, 
	conor.dooley@microchip.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Heiko Stuebner <heiko.stuebner@vrull.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 23, 2023 at 12:43=E2=80=AFAM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Wed, Nov 22, 2023 at 03:58:17PM +0800, Jerry Shih wrote:
> > On Nov 22, 2023, at 07:51, Eric Biggers <ebiggers@kernel.org> wrote:
> > > On Wed, Nov 01, 2023 at 09:03:33PM -0700, Eric Biggers wrote:
> > >>
> > >> It would be nice to use a real assembler, so that people won't have =
to worry
> > >> about potential mistakes or inconsistencies in the perl-based "assem=
bler".  Also
> > >> keep in mind that if we allow people to compile this code without th=
e real
> > >> assembler support from the beginning, it might end up staying that w=
ay for quite
> > >> a while in order to avoid breaking the build for people.
> > >>
> > >> Ultimately it's up to you though; I think that you and others who ha=
ve been
> > >> working on RISC-V crypto can make the best decision about what to do=
 here.  I
> > >> also don't want this patchset to be delayed waiting for other projec=
ts, so maybe
> > >> that indeed means the perl-based "assembler" needs to be used for no=
w.
> > >
> > > Just wanted to bump up this discussion again.  In binutils, the vecto=
r crypto
> > > v1.0.0 support was released 4 months ago in 2.41.  See the NEWS file =
at
> > > https://sourceware.org/git/gitweb.cgi?p=3Dbinutils-gdb.git;a=3Dblob_p=
lain;f=3Dbinutils/NEWS;hb=3Drefs/heads/binutils-2_41-branch
> > >
> > >    * The RISC-V port now supports the following new standard extensio=
ns:
> > >      - Zicond (conditional zero instructions)
> > >      - Zfa (additional floating-point instructions)
> > >      - Zvbb, Zvbc, Zvkg, Zvkned, Zvknh[ab], Zvksed, Zvksh, Zvkn, Zvkn=
c, Zvkng,
> > >        Zvks, Zvksc, Zvkg, Zvkt (vector crypto instructions)
> > >
> > > That's every extension listed in the vector crypto v1.0.0 specificati=
on
> > > (https://github.com/riscv/riscv-crypto/releases/download/v1.0.0/riscv=
-crypto-spec-vector.pdf).
> >
> > It doesn't fit all v1.0 spec.
> > The `Zvkb` is missed in binutils. It's the subset of `Zvbb`. We needs s=
ome extra
> > works if user just try to use `Zvkb`.
> > https://github.com/riscv/riscv-crypto/blob/main/doc/vector/riscv-crypto=
-vector-zvkb.adoc
> > Some crypto algorithms are already checking for `Zvkb` instead of `Zvbb=
`.
>
> Yeah, that's unfortunate that Zvkb got missed in binutils.  However, sinc=
e all
> Zvkb instructions are part of Zvbb, which is supported, assembling Zvkb
> instructions should still work --- right?

Not forgotten, but the Zvkb extension did not exist when the patchset
was merged.
RISC-V extension support is typically merged when specifications are "froze=
n".
This means a high bar for changes, but they are possible until the
spec is ratified.
Often nothing is changed until ratification, but here Zvkb has been
(re-)introduced.

I was not aware of this untils I read this email, so I just wrote a
patch that fills the gap:
  https://sourceware.org/pipermail/binutils/2023-November/130762.html

Thanks for reporting!

BR
Christoph

>
> > > LLVM still has the vector crypto extensions marked as "experimental" =
extensions.
> > > However, there is an open pull request to mark them non-experimental:
> > > https://github.com/llvm/llvm-project/pull/69000
> > >
> > > Could we just go ahead and remove riscv.pm, develop with binutils for=
 now, and
> > > prioritize getting the LLVM support finished?
> >
> > Yes, we could.
> > But we need to handle the extensions checking for toolchains like:
> > https://github.com/torvalds/linux/commit/b6fcdb191e36f82336f9b5e126d51c=
02e7323480
> > I could do that, but I think I need some times to test the builds. And =
it will introduce
> > more dependency patch which is not related to actual crypto algorithms =
and the
> > gluing code in kernel. I will send another patch for toolchain part aft=
er the v2 patch.
> > And I am working for v2 patch with your new review comments. The v2 wil=
l still
> > use `perlasm`.
>
> Note that perlasm (.pl) vs assembly (.S), and ".inst" vs real assembler
> instructions, are actually separate concerns.  We could use real assemble=
r
> instructions while still using perlasm.  Or we could use assembly while s=
till
> using macros that generate the instructions as .inst.
>
> My preference is indeed both: assembly (.S) with real assembler instructi=
ons.
> That would keep things more straightforward.
>
> We do not necessarily need to do both before merging the code, though.  I=
t will
> be beneficial to get this code merged sooner rather than later, so that o=
ther
> people can work on improving it.
>
> I would prioritize the change to use real assembler instructions.  I do t=
hink
> it's worth thinking about getting that change in from the beginning, so t=
hat the
> toolchain prerequisites are properly in place from the beginning and peop=
le can
> properly account for them and prioritize the toolchain work as needed.
>
> - Eric
