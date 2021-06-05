Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D700C4743C
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Jun 2021 00:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58ACA6136E
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Jun 2021 00:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhFEAp1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Jun 2021 20:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhFEAp1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jun 2021 20:45:27 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E19C061766
        for <linux-crypto@vger.kernel.org>; Fri,  4 Jun 2021 17:43:26 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l10-20020a17090a150ab0290162974722f2so6815627pja.2
        for <linux-crypto@vger.kernel.org>; Fri, 04 Jun 2021 17:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=QHrZR1MpVXC88afIWi4RkzPg8+mZpQ4oEHnl6dd+aO4=;
        b=lbe9wRJPLWPnNabjMpYPCw99mVHpECLlLhx7U/OyHwBZ9MegEZpWOHaYkPdwbviwLg
         xfEdyCwMekbyW6CzqhpcxQk6HrqS7Ctw2+/Dc0N9Md4fi6e/0ShLlo8USBpiVrmfr4RT
         GD6iiZZALn+UyJVAj7NAA+Lf2sjylp8ico+wWwHkqh28uykYPq4NUUun3U9Ctr57SLJ0
         TWlyb4f15ysg2Jxy5YWFDZDk4efLCrTaPeQSz6IXemjDvezQqKVe+s7oULKNof2Mtlpb
         ZXuFp9mG3SbnpAWJFmFM343ojj2XciC0IN30cZT3SAgmSjvR4O8OgzQer9kVeVB3lib2
         tKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=QHrZR1MpVXC88afIWi4RkzPg8+mZpQ4oEHnl6dd+aO4=;
        b=A6qQyzoyegWfpwTCLcoGQ1xnJY45YiPa2u1HFm1KX3Qf1aXyfj8YSmB5jS6njDYoz9
         SbYGpsC3D3pigiD6RhgH4vtEykHXOAunjwEihX23HnH3Zi72H7uqtj8U+7WWyv+TmjAJ
         I06O811Uw6H/ZzJKSpJoJo66dunC8k7XPMbhgw1PNyVCokYTCoYajEPtog+uKfYgdUdS
         TmWHYH4CDUm7FPlhFlON4/T+lk1S2zzNVQUzrTfDo+4IMMmFUdwXFFQ9kyZfZ83aCrQG
         buUQrBw6q/tOTi9iqxshTclbf7r2J6dQsvLVQCdqJlu/mmrUkQC5luNL9w0m7Jl8T+BD
         i4Uw==
X-Gm-Message-State: AOAM533n1GrtDNbx4JoDu8LgSk88INFz+K57SHtFUj5w5vMrgw6MFkwk
        c9DGTetz+fBTVehUW/2XYx8=
X-Google-Smtp-Source: ABdhPJxoQauggiRpOgQ8vdVgBZ1ckniDTIw+fRatj5YgB6ghUcmmpQxoxhC4WZDxR2DTtTlX0SR12A==
X-Received: by 2002:a17:902:988d:b029:ef:68aa:d775 with SMTP id s13-20020a170902988db02900ef68aad775mr6749406plp.57.1622853805555;
        Fri, 04 Jun 2021 17:43:25 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id 3sm2461847pfm.41.2021.06.04.17.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 17:43:25 -0700 (PDT)
Date:   Sat, 05 Jun 2021 10:43:19 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 12/16] powerpc/pseries/vas: Setup IRQ and fault
 handling
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
        <5ac32e4d07bd048e3d687354501d36c334f1c8e0.camel@linux.ibm.com>
        <1622697882.lu1gj10oe8.astroid@bobo.none>
        <ab831a47cae65c67e1fae41acd9dcb8f3c55ac76.camel@linux.ibm.com>
In-Reply-To: <ab831a47cae65c67e1fae41acd9dcb8f3c55ac76.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1622853468.3f8ohl3pt0.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 4, 2021 11:19 am:
> On Thu, 2021-06-03 at 15:48 +1000, Nicholas Piggin wrote:
>> Excerpts from Haren Myneni's message of May 21, 2021 7:39 pm:
>> > NX generates an interrupt when sees a fault on the user space
>> > buffer and the hypervisor forwards that interrupt to OS. Then
>> > the kernel handles the interrupt by issuing H_GET_NX_FAULT hcall
>> > to retrieve the fault CRB information.
>> >=20
>> > This patch also adds changes to setup and free IRQ per each
>> > window and also handles the fault by updating the CSB.
>> >=20
>> > Signed-off-by: Haren Myneni <haren@linux.ibm.com>
>> > ---
>> >  arch/powerpc/platforms/pseries/vas.c | 111
>> > +++++++++++++++++++++++++++
>> >  1 file changed, 111 insertions(+)
>> >=20
>> > diff --git a/arch/powerpc/platforms/pseries/vas.c
>> > b/arch/powerpc/platforms/pseries/vas.c
>> > index ef0c455f6e93..31dc17573f50 100644
>> > --- a/arch/powerpc/platforms/pseries/vas.c
>> > +++ b/arch/powerpc/platforms/pseries/vas.c
>> > @@ -224,6 +224,62 @@ int plpar_vas_query_capabilities(const u64
>> > hcall, u8 query_type,
>> >  }
>> >  EXPORT_SYMBOL_GPL(plpar_vas_query_capabilities);
>> > =20
>> > +/*
>> > + * HCALL to get fault CRB from pHyp.
>> > + */
>> > +static int plpar_get_nx_fault(u32 winid, u64 buffer)
>> > +{
>> > +	int64_t rc;
>> > +
>> > +	rc =3D plpar_hcall_norets(H_GET_NX_FAULT, winid, buffer);
>> > +
>> > +	switch (rc) {
>> > +	case H_SUCCESS:
>> > +		return 0;
>> > +	case H_PARAMETER:
>> > +		pr_err("HCALL(%x): Invalid window ID %u\n",
>> > H_GET_NX_FAULT,
>> > +		       winid);
>> > +		return -EINVAL;
>> > +	case H_STATE:
>> > +		pr_err("HCALL(%x): No outstanding faults for window ID
>> > %u\n",
>> > +		       H_GET_NX_FAULT, winid);
>> > +		return -EINVAL;
>> > +	case H_PRIVILEGE:
>> > +		pr_err("HCALL(%x): Window(%u): Invalid fault buffer
>> > 0x%llx\n",
>> > +		       H_GET_NX_FAULT, winid, buffer);
>> > +		return -EACCES;
>> > +	default:
>> > +		pr_err("HCALL(%x): Unexpected error %lld for
>> > window(%u)\n",
>> > +		       H_GET_NX_FAULT, rc, winid);
>> > +		return -EIO;
>> > +	}
>> > +}
>>=20
>> Out of curiosity, you get one of these errors and it just drops the
>> interrupt on the floor. Then what happens, I assume everything
>> stops. Should it put some error in the csb, or signal the process or
>> something? Or is there nothing very sane that can be done?
>=20
> The user space polls on CSB with timout interval. If the kernel or NX
> does not return, the request will be timeout.

Okay, if there is no sane way it can respond to the different error=20
cases that's not necessarily unreasonable to just print something in the=20
kernel log. Hopefully the kernel log would be useful to the=20
administrator / developer / etc, but that's pretty rarely the case for=20
Linux errors as it is.

> The hypervisor returns the credit after H_GET_NX_FAULT HCALL is
> successful. Also one credit is assigned for each window. So in this
> case, the error is coming from the hypervisor and the application can
> not issue another request on the same window.=20
>=20
>>=20
>> > +
>> > +/*
>> > + * Handle the fault interrupt.
>> > + * When the fault interrupt is received for each window, query
>> > pHyp to get
>> > + * the fault CRB on the specific fault. Then process the CRB by
>> > updating
>> > + * CSB or send signal if the user space CSB is invalid.
>> > + * Note: pHyp forwards an interrupt for each fault request. So one
>> > fault
>> > + *	CRB to process for each H_GET_NX_FAULT HCALL.
>> > + */
>> > +irqreturn_t pseries_vas_fault_thread_fn(int irq, void *data)
>> > +{
>> > +	struct vas_window *txwin =3D data;
>> > +	struct coprocessor_request_block crb;
>> > +	struct vas_user_win_ref *tsk_ref;
>> > +	int rc;
>> > +
>> > +	rc =3D plpar_get_nx_fault(txwin->winid, (u64)virt_to_phys(&crb));
>> > +	if (!rc) {
>> > +		tsk_ref =3D &txwin->task_ref;
>> > +		vas_dump_crb(&crb);
>>=20
>> This (and existing powernv vas code) is printk()ing a lot of lines
>> per=20
>> fault. This should be pretty normal operation I think? It should
>> avoid
>> filling the kernel logs, if so. Particularly if it can be triggered
>> by=20
>> userspace.
>>=20
>> I know it's existing code, so could be fixed separately from the
>> series.
>=20
> printk messages are only if HCALL returns failure or kernel issue (ex:
> not valid window and etc on powerNV). These errors should not be
> depending on the iser space requests. So generally we should not get
> these errors. =20

Ah I was looking at dump_crb but that's using pr_devel so that's=20
probably okay.

Thanks,
Nick
