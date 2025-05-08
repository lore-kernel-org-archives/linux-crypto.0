Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B023120B813;
	Thu,  8 May 2025 10:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746701828; cv=none; b=cPPWjf1K31zAibs3Wd3CFLlsQW0hIGmUDJjaiyZFRrO7QClD3iCF/z6e27x9RYqPSIQ5uY3mn6s/WD61wEF7WshqFG9gf+bvm0XWYRntXh6Yvdb7iHalHS0A//NBnORfX6NGBtfscaUYh2u9iq3YSzyDqBZab5ioPtJjdfYG2go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746701828; c=relaxed/simple;
	bh=BG7Y3JTwmDtgsJp4V3DTXD53Jk/adf0nr1Wnyy/PYFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ShcPTXKHS3C8sbPdX9zvkwUwPK+o9HIUZctQvE5eUktKk7hQqAQVoCuRsVYkS/oXqtfjaZJ1NWuz8y5zXEy9X0CUoXOgFk5HltBfAW9ZZdiEVPcbwlMNm+w8cWxpp0onGPVjXl4Z8SgPFPDSHKsJ/f3SQrrus2e8y4nlylraJiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bc/dXdeY; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bc/dXdeY"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-703cd93820fso8071587b3.2;
        Thu, 08 May 2025 03:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746701825; x=1747306625; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fOG3ikubiSyZnwsEmMWPgLMUnvjPrgL9XeKVEgejbNk=;
        b=Bc/dXdeYIV3wFNoAWq4gw1MxnpsV9RKLPFkfOWdDj5ZPog1aHIp8tw/onc0DfP++Xo
         0xWvrXtZxh6JBQU034imLDGqnzz8cq3k0SqmB/x4yKtBr6oWlDAQyqF1E6MLIvvKq7z1
         iULb7Z0wTXm9uw1qUSNkUMlQabAdOgSWLkm6W3zyqnwNKQZS36yiuq7ZbjCGKox/ytbD
         J+gz6uvkpJcNMAqm2C5Np7s4ikkSmWqp+o4ITV6Jkshr7KMXHJRGY3x7599vq+UMk6IR
         ExiWSL2YiMhUzuzz6c3mvNoKmq0cXgUn0g1jskkjxmCDVJ3kbjscsk58SrN85hJk27Wc
         J2GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746701825; x=1747306625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fOG3ikubiSyZnwsEmMWPgLMUnvjPrgL9XeKVEgejbNk=;
        b=cOsqdwI0X7i08jraW7lb3g2wKLjpXkYVm+rfmMumqEcM3nR+gr8YKht6pw8YElXhYT
         +dRbIhOxiiybRFnyskZ1MZ3hB6BQHwz1UbiJk9+eLVagsZBzwahrhuKIYBleDktjljdj
         JU6xciX9m8hUQZCDYIavzODrhkmQ200AWq8dgVitQIxfI6iZMDEfroLwQKIkZu15RPoO
         xHw4BnEST0AjfQv5skp5RnyUFpM1uqecrDyM2FJoKbvVoULrH1YSzIvzlfqOqJLhkvmZ
         4jWonCw+zhSxnuT7OUTYWLYVMc7QMQec3OMwHWRBMrm1jADDmc8Ej/UYKH+DUBXNF8ea
         FKZw==
X-Forwarded-Encrypted: i=1; AJvYcCVCRP9FhZH/YQH8mI139Q2Mnlg8jajVfl+H3NtJKywR50ecVMg4FMHvpC8Dul+rt1J581MBpUzi@vger.kernel.org, AJvYcCVH2O0YLpZVz5cnfO5+P3QXlAYc/TMuhxdYiTsBvB7tS/3RkM0ltOlPF5W51eZ4kQcUGYvC5FKaPtayTXg=@vger.kernel.org, AJvYcCXNOvMIlYgl5pcyQ0J8WYb79KBw2p30Eoortoc7X2QTJl/mNF+6h4WzFUurvALyg6VOHC4lvzq9foc5/iW6@vger.kernel.org
X-Gm-Message-State: AOJu0YwiJGwvPhCsUZtXVUULLsXEGTAdRTIj+Txxr35KM6KAj28P6fcy
	RjkfV0AK7aBiR4kRQSYiwBFGiAgkphJlMOaCSX0iGKN97S6G/DrxRAowdB+daMhDJ7+E9+JowrO
	JktUP364pxcFrzKx5e8nJxuBfajE=
X-Gm-Gg: ASbGnctqkmzPVVr+LK+opHj7ZJ7cLpsP0JndZxtG2xH/dhPI6j3nTVkP41s5cgDkqkx
	vnnRRgdkL+np18ZXRl4KmvHj12Gr1kF66ZiNM9Thzov4NY4nhqeBG/qU9nd08GzD2H3SayeSBVj
	iBemd/e+lZrrz+DZDsDTPA
X-Google-Smtp-Source: AGHT+IHqzoe/iNKl1xQ24DnirDS2g8leH+NhoYSPmAlGfKke6DDz1jKPnpNkjRfmStDnIfKQh/aOuGeqgNqfDw72s94=
X-Received: by 2002:a05:690c:6f11:b0:708:a778:b447 with SMTP id
 00721157ae682-70a1da3a702mr94184747b3.20.1746701825458; Thu, 08 May 2025
 03:57:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250502132005.611698-1-tanmay@marvell.com> <20250502132005.611698-3-tanmay@marvell.com>
 <20250506202413.GY3339421@horms.kernel.org>
In-Reply-To: <20250506202413.GY3339421@horms.kernel.org>
From: Bharat Bhushan <bharatb.linux@gmail.com>
Date: Thu, 8 May 2025 16:26:52 +0530
X-Gm-Features: ATxdqUEo3r-cozPvN7RAcVJFX9fHA1iSYVl0F1Itk67xge1xIzkz790DOCV_uss
Message-ID: <CAAeCc_naw2xvONjW9uW4cOm1-O8WXFdyKPaS3E88Zfb7g7vOgw@mail.gmail.com>
Subject: Re: [net-next PATCH v1 02/15] octeontx2-af: Configure crypto hardware
 for inline ipsec
To: Simon Horman <horms@kernel.org>
Cc: Tanmay Jagdale <tanmay@marvell.com>, bbrezillon@kernel.org, arno@natisbad.org, 
	schalla@marvell.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com, 
	jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com, 
	andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, bbhushan2@marvell.com, bhelgaas@google.com, 
	pstanner@redhat.com, gregkh@linuxfoundation.org, peterz@infradead.org, 
	linux@treblig.org, krzysztof.kozlowski@linaro.org, giovanni.cabiddu@intel.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, rkannoth@marvell.com, sumang@marvell.com, 
	gcherian@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 7, 2025 at 2:20=E2=80=AFAM Simon Horman <horms@kernel.org> wrot=
e:
>
> On Fri, May 02, 2025 at 06:49:43PM +0530, Tanmay Jagdale wrote:
> > From: Bharat Bhushan <bbhushan2@marvell.com>
> >
> > Currently cpt_rx_inline_lf_cfg mailbox is handled by CPT PF
> > driver to configures inbound inline ipsec. Ideally inbound
> > inline ipsec configuration should be done by AF driver.
> >
> > This patch adds support to allocate, attach and initialize
> > a cptlf from AF. It also configures NIX to send CPT instruction
> > if the packet needs inline ipsec processing and configures
> > CPT LF to handle inline inbound instruction received from NIX.
> >
> > Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
> > Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
>
> Hi Bharat and Tanmay,
>
> Some minor feedback from my side.

Hi Simon,

Most of the comments are ack. Please see inline

>
> ...
>
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers=
/net/ethernet/marvell/octeontx2/af/mbox.h
> > index 973ff5cf1a7d..8540a04a92f9 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > @@ -1950,6 +1950,20 @@ enum otx2_cpt_eng_type {
> >       OTX2_CPT_MAX_ENG_TYPES,
> >  };
> >
> > +struct cpt_rx_inline_lf_cfg_msg {
> > +     struct mbox_msghdr hdr;
> > +     u16 sso_pf_func;
> > +     u16 param1;
> > +     u16 param2;
> > +     u16 opcode;
> > +     u32 credit;
> > +     u32 credit_th;
> > +     u16 bpid;
>
> On arm64 (at least) there will be a 2 byte hole here. Is that intended?

It is not intentional, will mark as reserved.

>
> And, not strictly related to this patch, struct mboxhdr also has
> a 2 byte hole before it's rc member. Perhaps would be nice
> if it was it filled by a reserved member?

struct mbox_msghdr is not used globally, will prefer not to touch that
as part of this patch series.

>
> > +     u32 reserved;
> > +     u8 ctx_ilen_valid : 1;
> > +     u8 ctx_ilen : 7;
> > +};
> > +
> >  struct cpt_set_egrp_num {
> >       struct mbox_msghdr hdr;
> >       bool set;
>
> ...
>
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/=
net/ethernet/marvell/octeontx2/af/rvu.h
> > index fa403da555ff..6923fd756b19 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > @@ -525,8 +525,38 @@ struct rvu_cpt_eng_grp {
> >       u8 grp_num;
> >  };
> >
> > +struct rvu_cpt_rx_inline_lf_cfg {
> > +     u16 sso_pf_func;
> > +     u16 param1;
> > +     u16 param2;
> > +     u16 opcode;
> > +     u32 credit;
> > +     u32 credit_th;
> > +     u16 bpid;
>
> FWIIW, there is a hole here too.

ACK, will mark reserved.

>
> > +     u32 reserved;
> > +     u8 ctx_ilen_valid : 1;
> > +     u8 ctx_ilen : 7;
> > +};
>
> ...
>
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/driv=
ers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
>
> ...
>
> > @@ -1087,6 +1115,72 @@ static void cpt_rxc_teardown(struct rvu *rvu, in=
t blkaddr)
> >  #define DQPTR      GENMASK_ULL(19, 0)
> >  #define NQPTR      GENMASK_ULL(51, 32)
> >
> > +static void cpt_rx_ipsec_lf_enable_iqueue(struct rvu *rvu, int blkaddr=
,
> > +                                       int slot)
> > +{
> > +     u64 val;
> > +
> > +     /* Set Execution Enable of instruction queue */
> > +     val =3D otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_IN=
PROG);
> > +     val |=3D BIT_ULL(16);
>
> Bit 16 seems to have a meaning, it would be nice if a #define was used
> I mean something like this (but probably not actually this :)
>
> #define CPT_LF_INPROG_ENA_QUEUE BIT_ULL(16)
>
> Perhaps defined near where CPT_LF_INPROG is defined.

ACK

>
> > +     otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_INPROG, v=
al);
> > +
> > +     /* Set iqueue's enqueuing */
> > +     val =3D otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_CT=
L);
> > +     val |=3D BIT_ULL(0);
>
> Ditto.

ACK

>
> > +     otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_CTL, val)=
;
> > +}
> > +
> > +static void cpt_rx_ipsec_lf_disable_iqueue(struct rvu *rvu, int blkadd=
r,
> > +                                        int slot)
> > +{
> > +     int timeout =3D 1000000;
> > +     u64 inprog, inst_ptr;
> > +     u64 qsize, pending;
> > +     int i =3D 0;
> > +
> > +     /* Disable instructions enqueuing */
> > +     otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_CTL, 0x0)=
;
> > +
> > +     inprog =3D otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF=
_INPROG);
> > +     inprog |=3D BIT_ULL(16);
> > +     otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_INPROG, i=
nprog);
> > +
> > +     qsize =3D otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_=
Q_SIZE)
> > +              & 0x7FFF;
> > +     do {
> > +             inst_ptr =3D otx2_cpt_read64(rvu->pfreg_base, blkaddr, sl=
ot,
> > +                                        CPT_LF_Q_INST_PTR);
> > +             pending =3D (FIELD_GET(XQ_XOR, inst_ptr) * qsize * 40) +
> > +                       FIELD_GET(NQPTR, inst_ptr) -
> > +                       FIELD_GET(DQPTR, inst_ptr);
>
> nit: I don't think you need the outer parentheses here.
>      But if you do, the two lines above sould be indented by one more
>      character.
>
> > +             udelay(1);
> > +             timeout--;
> > +     } while ((pending !=3D 0) && (timeout !=3D 0));
>
> nit: I don't think you need the inner parenthese here (x2).

okay,

>
> > +
> > +     if (timeout =3D=3D 0)
> > +             dev_warn(rvu->dev, "TIMEOUT: CPT poll on pending instruct=
ions\n");
> > +
> > +     timeout =3D 1000000;
> > +     /* Wait for CPT queue to become execution-quiescent */
> > +     do {
> > +             inprog =3D otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot=
,
> > +                                      CPT_LF_INPROG);
> > +             if ((FIELD_GET(INFLIGHT, inprog) =3D=3D 0) &&
> > +                 (FIELD_GET(GRB_CNT, inprog) =3D=3D 0)) {
> > +                     i++;
> > +             } else {
> > +                     i =3D 0;
> > +                     timeout--;
> > +             }
> > +     } while ((timeout !=3D 0) && (i < 10));
> > +
> > +     if (timeout =3D=3D 0)
> > +             dev_warn(rvu->dev, "TIMEOUT: CPT poll on inflight count\n=
");
> > +     /* Wait for 2 us to flush all queue writes to memory */
> > +     udelay(2);
> > +}
> > +
> >  static void cpt_lf_disable_iqueue(struct rvu *rvu, int blkaddr, int sl=
ot)
> >  {
> >       int timeout =3D 1000000;
> > @@ -1310,6 +1404,474 @@ int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcif=
unc)
> >       return 0;
> >  }
> >
> > +static irqreturn_t rvu_cpt_rx_ipsec_misc_intr_handler(int irq, void *p=
tr)
> > +{
> > +     struct rvu_block *block =3D ptr;
> > +     struct rvu *rvu =3D block->rvu;
> > +     int blkaddr =3D block->addr;
> > +     struct device *dev =3D rvu->dev;
> > +     int slot =3D 0;
> > +     u64 val;
> > +
> > +     val =3D otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_MI=
SC_INT);
> > +
> > +     if (val & (1 << 6)) {
>
> Allong the lines of my earlier comment, bit 6 seems to have a meaning too=
.
> Likewise for other bits below.

ack

>
> > +             dev_err(dev, "Memory error detected while executing CPT_I=
NST_S, LF %d.\n",
> > +                     slot);
> > +     } else if (val & (1 << 5)) {
> > +             dev_err(dev, "HW error from an engine executing CPT_INST_=
S, LF %d.",
> > +                     slot);
> > +     } else if (val & (1 << 3)) {
> > +             dev_err(dev, "SMMU fault while writing CPT_RES_S to CPT_I=
NST_S[RES_ADDR], LF %d.\n",
> > +                     slot);
> > +     } else if (val & (1 << 2)) {
> > +             dev_err(dev, "Memory error when accessing instruction mem=
ory queue CPT_LF_Q_BASE[ADDR].\n");
> > +     } else if (val & (1 << 1)) {
> > +             dev_err(dev, "Error enqueuing an instruction received at =
CPT_LF_NQ.\n");
> > +     } else {
> > +             dev_err(dev, "Unhandled interrupt in CPT LF %d\n", slot);
> > +             return IRQ_NONE;
> > +     }
> > +
> > +     /* Acknowledge interrupts */
> > +     otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_MISC_INT,
> > +                      val & CPT_LF_MISC_INT_MASK);
> > +
> > +     return IRQ_HANDLED;
> > +}
>
> ...
>
> > +/* Allocate memory for CPT outbound Instruction queue.
> > + * Instruction queue memory format is:
> > + *      -----------------------------
> > + *     | Instruction Group memory    |
> > + *     |  (CPT_LF_Q_SIZE[SIZE_DIV40] |
> > + *     |   x 16 Bytes)               |
> > + *     |                             |
> > + *      ----------------------------- <-- CPT_LF_Q_BASE[ADDR]
> > + *     | Flow Control (128 Bytes)    |
> > + *     |                             |
> > + *      -----------------------------
> > + *     |  Instruction Memory         |
> > + *     |  (CPT_LF_Q_SIZE[SIZE_DIV40] |
> > + *     |   =C3=97 40 =C3=97 64 bytes)          |
> > + *     |                             |
> > + *      -----------------------------
> > + */
>
> Nice diagram :)

:), somehow the line alignment does not look good here over email. But
looks good when patch applied. Will see how i can fix this

>
> ...
>
> > +static int rvu_rx_cpt_set_grp_pri_ilen(struct rvu *rvu, int blkaddr, i=
nt cptlf)
> > +{
> > +     u64 reg_val;
> > +
> > +     reg_val =3D rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf));
> > +     /* Set High priority */
> > +     reg_val |=3D 1;
> > +     /* Set engine group */
> > +     reg_val |=3D ((1ULL << rvu->rvu_cpt.inline_ipsec_egrp) << 48);
> > +     /* Set ilen if valid */
> > +     if (rvu->rvu_cpt.rx_cfg.ctx_ilen_valid)
> > +             reg_val |=3D rvu->rvu_cpt.rx_cfg.ctx_ilen  << 17;
>
> Along the same lines. 48 and 17 seem to have meaning.
> Perhaps define appropriate masks created using GENMASK_ULL
> and use FIELD_PREP?

ack

>
> > +
> > +     rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), reg_val);
> > +     return 0;
> > +}
>
> ...
>
> > +static void rvu_rx_cptlf_cleanup(struct rvu *rvu, int blkaddr, int slo=
t)
> > +{
> > +     /* IRQ cleanup */
> > +     rvu_cpt_rx_inline_cleanup_irq(rvu, blkaddr, slot);
> > +
> > +     /* CPTLF cleanup */
> > +     rvu_cpt_rx_inline_cptlf_clean(rvu, blkaddr, slot);
> > +}
> > +
> > +int rvu_mbox_handler_cpt_rx_inline_lf_cfg(struct rvu *rvu,
> > +                                       struct cpt_rx_inline_lf_cfg_msg=
 *req,
> > +                                       struct msg_rsp *rsp)
>
> Compilers warn that rvu_mbox_handler_cpt_rx_inline_lf_cfg doesn't have
> a prototype.
>
> I think this can be resolved by squashing the following hunk,
> which appears in a subsequent patch in this series, into this patch.
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/n=
et/ethernet/marvell/octeontx2/af/mbox.h
> index 8540a04a92f9..ad74a27888da 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> @@ -213,6 +213,8 @@ M(CPT_FLT_ENG_INFO,     0xA09, cpt_flt_eng_info, cpt_=
flt_eng_info_req,      \
>                                cpt_flt_eng_info_rsp)                    \
>  M(CPT_SET_ENG_GRP_NUM,  0xA0A, cpt_set_eng_grp_num, cpt_set_egrp_num,   =
\
>                                 msg_rsp)                                \
> +M(CPT_RX_INLINE_LF_CFG, 0xBFE, cpt_rx_inline_lf_cfg, cpt_rx_inline_lf_cf=
g_msg, \
> +                               msg_rsp) \
>  /* SDP mbox IDs (range 0x1000 - 0x11FF) */                             \
>  M(SET_SDP_CHAN_INFO, 0x1000, set_sdp_chan_info, sdp_chan_info_msg, msg_r=
sp) \
>  M(GET_SDP_CHAN_INFO, 0x1001, get_sdp_chan_info, msg_req, sdp_get_chan_in=
fo_msg) \

ack

>
> ...
>
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h b/driv=
ers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
>
> ...
>
> > +/* CPT instruction queue length in bytes */
> > +#define RVU_CPT_INST_QLEN_BYTES                                       =
        \
> > +             ((RVU_CPT_SIZE_DIV40 * 40 * RVU_CPT_INST_SIZE) +         =
    \
> > +             RVU_CPT_INST_QLEN_EXTRA_BYTES)
>
> nit: I think the line above should be indented by one more character

Somehow this looks good when this patch applied, I need to see why
indentation got broken in email.

>
> > +
> > +/* CPT instruction group queue length in bytes */
> > +#define RVU_CPT_INST_GRP_QLEN_BYTES                                   =
        \
> > +             ((RVU_CPT_SIZE_DIV40 + RVU_CPT_EXTRA_SIZE_DIV40) * 16)
> > +
> > +/* CPT FC length in bytes */
> > +#define RVU_CPT_Q_FC_LEN 128
> > +
> > +/* CPT LF_Q_SIZE Register */
> > +#define CPT_LF_Q_SIZE_DIV40 GENMASK_ULL(14, 0)
> > +
> > +/* CPT invalid engine group num */
> > +#define OTX2_CPT_INVALID_CRYPTO_ENG_GRP 0xFF
> > +
> > +/* Fastpath ipsec opcode with inplace processing */
> > +#define OTX2_CPT_INLINE_RX_OPCODE (0x26 | (1 << 6))
> > +#define CN10K_CPT_INLINE_RX_OPCODE (0x29 | (1 << 6))
>
> Along the lines of earlier comments, bit 6 seems to have a meaning here.

ack

>
> > +
> > +/* Calculate CPT register offset */
> > +#define CPT_RVU_FUNC_ADDR_S(blk, slot, offs) \
> > +             (((blk) << 20) | ((slot) << 12) | (offs))
>
> And perhaps this is another candidate for GENMASK + FIELD_PREP.

ack.

Thanks
-Bharat

>
> ...
>
