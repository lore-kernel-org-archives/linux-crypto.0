Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D86F15C5
	for <linux-crypto@vger.kernel.org>; Fri, 10 Nov 2023 06:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="h6n1sT0e"
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BF37D93
	for <linux-crypto@vger.kernel.org>; Thu,  9 Nov 2023 22:45:34 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-407da05f05aso11592165e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 09 Nov 2023 22:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1699598733; x=1700203533; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6sAETdwuHDStPNydylggHJXqBMcNQvpufLInsKoFd0=;
        b=h6n1sT0eDWjYYpB4M6OsSnFvo/+t6BkpMKv1WjM1up8A0HdRSOyMgw/IsRd8HQ7BUU
         oxDqmKB36OenpUqk3YUzKZQsQJnNFl29dCuSXUfVCk+PE6aR6fFHnQxGfQrW5/GwOrpV
         03Iutp8gGUZ6KCWybW3zGBG80LD1oPXBefZJDZkn7fHhxmv2ChUnqBGIAVsYjiLECx1Y
         xtU8uSbWfb31oh4554VptelDKa9f14c5VWzE4NaTcEax1/uFwwyteQ/ODm9R68s9sRoY
         b2DlLZsqVlgVdR4xuyx947Bz5LoUV+NRKV2EzMYSZoBVe/iFTdIoTGzF8qHsPDGbIZwy
         kWfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699598733; x=1700203533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6sAETdwuHDStPNydylggHJXqBMcNQvpufLInsKoFd0=;
        b=QqkbJqVeS2xaFQ3yRDuUKyIj2lUofRdZsbMAiCqXdf/qJ7hmz7QUuGSiokYyB2xgy3
         q9dsP/H5hsLLL0Ero51GqZogIQSFvoGfDWGociFko8CFluNVh+PVZCNSmUoZxjG8H7No
         jdm5W2TwJOvz5Us1xtjj/vRV3LTzXp4n9dV6Ko+qZQnTgJO/SnfO6J/Zck+NRp8l8UXX
         CPVh/GrZdcC6IgXbbD801NIqiGmLhabU9wLo7hg0GkqteO6SKCLWqUYhkTA+Jb/bgGF+
         uhSfYZvzBmTNtHaZ+VMA+/SX2BGVCAeqK1n4CoWpQbsmZVysCtB97zxLw9HYiwaIwNrK
         UilA==
X-Gm-Message-State: AOJu0YzW4XFnFtbC0oim0e3mpDquTn+snT6IGuI4FsBfxwRl2XtK9TjW
	UeoU5fwWFa91UYZptS/fAq0PAfHajUPTYVWWSXnz95jLpuNSBmLk+VY=
X-Google-Smtp-Source: AGHT+IFiskVXU4f6KHS4fu76MT4C8NU0DvvVemixeUs0gO7+UD6OZvL9Om2hT/7BdlRp17/BfrmrUlL9CXx9Ip2tQFo=
X-Received: by 2002:a2e:98c7:0:b0:2c6:f3fd:7f0 with SMTP id
 s7-20020a2e98c7000000b002c6f3fd07f0mr5711888ljj.19.1699592304043; Thu, 09 Nov
 2023 20:58:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231025183644.8735-1-jerry.shih@sifive.com> <20231025183644.8735-7-jerry.shih@sifive.com>
 <20231102051639.GF1498@sol.localdomain> <39126F19-8FEB-4E18-B61D-4494B59C43A1@sifive.com>
 <20231109071623.GB1245@sol.localdomain>
In-Reply-To: <20231109071623.GB1245@sol.localdomain>
From: Andy Chiu <andy.chiu@sifive.com>
Date: Fri, 10 Nov 2023 12:58:12 +0800
Message-ID: <CABgGipXnGVB770ZA=60rD-6Hi5Fv_wh3tST+G+VFbTmMYzz0Mw@mail.gmail.com>
Subject: Re: [PATCH 06/12] RISC-V: crypto: add accelerated AES-CBC/CTR/ECB/XTS implementations
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jerry Shih <jerry.shih@sifive.com>, Paul Walmsley <paul.walmsley@sifive.com>, palmer@dabbelt.com, 
	Albert Ou <aou@eecs.berkeley.edu>, herbert@gondor.apana.org.au, davem@davemloft.net, 
	greentime.hu@sifive.com, conor.dooley@microchip.com, guoren@kernel.org, 
	bjorn@rivosinc.com, heiko@sntech.de, ardb@kernel.org, phoebe.chen@sifive.com, 
	hongrong.hsu@sifive.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Thu, Nov 9, 2023 at 3:16=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Tue, Nov 07, 2023 at 04:53:13PM +0800, Jerry Shih wrote:
> > On Nov 2, 2023, at 13:16, Eric Biggers <ebiggers@kernel.org> wrote:
> > > On Thu, Oct 26, 2023 at 02:36:38AM +0800, Jerry Shih wrote:
> > >> +static int ecb_encrypt(struct skcipher_request *req)
> > >> +{
> > >> +  struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
> > >> +  const struct riscv64_aes_ctx *ctx =3D crypto_skcipher_ctx(tfm);
> > >> +  struct skcipher_walk walk;
> > >> +  unsigned int nbytes;
> > >> +  int err;
> > >> +
> > >> +  /* If we have error here, the `nbytes` will be zero. */
> > >> +  err =3D skcipher_walk_virt(&walk, req, false);
> > >> +  while ((nbytes =3D walk.nbytes)) {
> > >> +          kernel_vector_begin();
> > >> +          rv64i_zvkned_ecb_encrypt(walk.src.virt.addr, walk.dst.vir=
t.addr,
> > >> +                                   nbytes & AES_BLOCK_VALID_SIZE_MA=
SK,
> > >> +                                   &ctx->key);
> > >> +          kernel_vector_end();
> > >> +          err =3D skcipher_walk_done(
> > >> +                  &walk, nbytes & AES_BLOCK_REMAINING_SIZE_MASK);
> > >> +  }
> > >> +
> > >> +  return err;
> > >> +}
> > >
> > > There's no fallback for !crypto_simd_usable() here.  I really like it=
 this way.
> > > However, for it to work (for skciphers and aeads), RISC-V needs to al=
low the
> > > vector registers to be used in softirq context.  Is that already the =
case?
> >
> > The kernel-mode-vector could be enabled in softirq, but we don't have n=
esting
> > vector contexts. Will we have the case that kernel needs to jump to sof=
tirq for
> > encryptions during the regular crypto function? If yes, we need to have=
 fallbacks
> > for all algorithms.
>
> Are you asking what happens if a softirq is taken while the CPU is betwee=
n
> kernel_vector_begin() and kernel_vector_end()?  I think that needs to be
> prevented by making kernel_vector_begin() and kernel_vector_end() disable=
 and
> re-enable softirqs, like what kernel_neon_begin() and kernel_neon_end() d=
o on
> arm64.  Refer to commit 13150149aa6ded which implemented that behavior on=
 arm64.

Yes, if making Vector available to softirq context is a must, then it
is reasonable to call local_bh_disable() in kernel_vector_begin().
However, softirq would not be the only user for Vector and disabling
it may cause extra latencies. Meanwhile, simply disabling bh in
kernel_vector_begin() will conflict with the patch[1] that takes an
approach to run Preemptible Vector. Though it is not clear yet on
whether we should run Vector without turning off preemption, I have
tested running preemptible Vector and observed some latency
improvements without sacrificing throughput. We will have a discussion
on LPC2023[2] and it'd be great if you could join or continue to
discuss it here.

Approaches can be done such as nesting, if running Vector in softirq
is required. Since it requires extra save/restore on nesting, I think
we should run some tests to get more performance (latency/throughput)
figure let the result decide the final direction. For example, we
could run Vector in either nesting with preempt-V and  non-nesting
without preempt-V and compare the following performance catachristics:
 - System-wide latency impact
 - Latency and throughput of softirq-Vector itself

>
> - Eric

 - [1] https://lore.kernel.org/all/20231019154552.23351-6-andy.chiu@sifive.=
com/
 - [2] https://lpc.events/event/17/contributions/1474/

Regard,
Andy
