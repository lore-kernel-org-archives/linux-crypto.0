Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB47BC47082
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 05:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9878613EE
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 05:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhFCFvP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 01:51:15 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:46027 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhFCFvO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 01:51:14 -0400
Received: by mail-pl1-f174.google.com with SMTP id 11so2303985plk.12
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jun 2021 22:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=hOp7TXbbzxwcDVaO5twCPbrsbPsqYeAyZBDbH4F+cUA=;
        b=UnvI1Q09TdXGZbuK8RLfB53qwo3E6WQdOZYKJ0M0HHXBJrkw2enL4HzQiDXnaXgrxt
         BK1VRaWLxaqMKhbGEhv2W3NPNYrZ0V9Q8NZLPCVPjMEXmfss3DfTaKvF+877FhS7La5A
         TsH4IUayaV0v8kupwrxq6nBuollykW1j9xZti5DWjvEF7/x2du39gjmMuG9KmeIXE7q6
         jHdVGmMkN9J/qKX3w+JhMl8nzrgoTb2ZrRreil07t4Y7YMwkkEypn4/K4PigNsEIBi+Z
         Xaa5HosqA+x+C35bv9o7AExDQBRED0ubIA6hu+WBLcYySMXIJnocHjtz9f9ROUDeykmB
         AT6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=hOp7TXbbzxwcDVaO5twCPbrsbPsqYeAyZBDbH4F+cUA=;
        b=QZhi0GQ5NpVtiArOFb/LGnsCRJZ1PwsnTenTZ06Y59EANKB6gk94PAVoHoEa885mSB
         BHzWydfTZj+uZ6PayHcz9TxaFvOW0Taz2FwKEw12+GOy6OAIZwK6Ph37d3MRUUG2Kwsq
         YHIn8NCaCgXnBRcraA5j9neYdhUTSHsE6P2SIkIsKtQBfLRg2/WIFZrKhlX5DsxaI/mX
         841yhPbCKJgcxjQ3PImcgDhHXGXjwWd8zfJb1F4ik1yMxo2h5mUaiDJfR41R7BnsUsq4
         brAFVn4VzJMPq/oeCiHXNOJEHa1AJRVSuOHj9iXDlmDtoX8JMbo7883YfIVPUJftxual
         8t/w==
X-Gm-Message-State: AOAM532AYlSIdUIrTAbuQeKBynMASAnY5JsukaySeTdrLEmEJpPd+fJy
        lBVVPvSKqVp0OrOrNVN27A0=
X-Google-Smtp-Source: ABdhPJxRYrVxjLMNjIKO3w0ToqQU4v73cKYA8u7ElSTEmcbcbhY25FsehBLB31QlqhRtw+9k/QCCuw==
X-Received: by 2002:a17:902:8695:b029:fd:6105:c936 with SMTP id g21-20020a1709028695b02900fd6105c936mr34402638plo.25.1622699296444;
        Wed, 02 Jun 2021 22:48:16 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id h12sm1429148pgn.54.2021.06.02.22.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:48:15 -0700 (PDT)
Date:   Thu, 03 Jun 2021 15:48:10 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 12/16] powerpc/pseries/vas: Setup IRQ and fault
 handling
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
        <5ac32e4d07bd048e3d687354501d36c334f1c8e0.camel@linux.ibm.com>
In-Reply-To: <5ac32e4d07bd048e3d687354501d36c334f1c8e0.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1622697882.lu1gj10oe8.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of May 21, 2021 7:39 pm:
>=20
> NX generates an interrupt when sees a fault on the user space
> buffer and the hypervisor forwards that interrupt to OS. Then
> the kernel handles the interrupt by issuing H_GET_NX_FAULT hcall
> to retrieve the fault CRB information.
>=20
> This patch also adds changes to setup and free IRQ per each
> window and also handles the fault by updating the CSB.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/vas.c | 111 +++++++++++++++++++++++++++
>  1 file changed, 111 insertions(+)
>=20
> diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platform=
s/pseries/vas.c
> index ef0c455f6e93..31dc17573f50 100644
> --- a/arch/powerpc/platforms/pseries/vas.c
> +++ b/arch/powerpc/platforms/pseries/vas.c
> @@ -224,6 +224,62 @@ int plpar_vas_query_capabilities(const u64 hcall, u8=
 query_type,
>  }
>  EXPORT_SYMBOL_GPL(plpar_vas_query_capabilities);
> =20
> +/*
> + * HCALL to get fault CRB from pHyp.
> + */
> +static int plpar_get_nx_fault(u32 winid, u64 buffer)
> +{
> +	int64_t rc;
> +
> +	rc =3D plpar_hcall_norets(H_GET_NX_FAULT, winid, buffer);
> +
> +	switch (rc) {
> +	case H_SUCCESS:
> +		return 0;
> +	case H_PARAMETER:
> +		pr_err("HCALL(%x): Invalid window ID %u\n", H_GET_NX_FAULT,
> +		       winid);
> +		return -EINVAL;
> +	case H_STATE:
> +		pr_err("HCALL(%x): No outstanding faults for window ID %u\n",
> +		       H_GET_NX_FAULT, winid);
> +		return -EINVAL;
> +	case H_PRIVILEGE:
> +		pr_err("HCALL(%x): Window(%u): Invalid fault buffer 0x%llx\n",
> +		       H_GET_NX_FAULT, winid, buffer);
> +		return -EACCES;
> +	default:
> +		pr_err("HCALL(%x): Unexpected error %lld for window(%u)\n",
> +		       H_GET_NX_FAULT, rc, winid);
> +		return -EIO;
> +	}
> +}

Out of curiosity, you get one of these errors and it just drops the
interrupt on the floor. Then what happens, I assume everything
stops. Should it put some error in the csb, or signal the process or
something? Or is there nothing very sane that can be done?

> +
> +/*
> + * Handle the fault interrupt.
> + * When the fault interrupt is received for each window, query pHyp to g=
et
> + * the fault CRB on the specific fault. Then process the CRB by updating
> + * CSB or send signal if the user space CSB is invalid.
> + * Note: pHyp forwards an interrupt for each fault request. So one fault
> + *	CRB to process for each H_GET_NX_FAULT HCALL.
> + */
> +irqreturn_t pseries_vas_fault_thread_fn(int irq, void *data)
> +{
> +	struct vas_window *txwin =3D data;
> +	struct coprocessor_request_block crb;
> +	struct vas_user_win_ref *tsk_ref;
> +	int rc;
> +
> +	rc =3D plpar_get_nx_fault(txwin->winid, (u64)virt_to_phys(&crb));
> +	if (!rc) {
> +		tsk_ref =3D &txwin->task_ref;
> +		vas_dump_crb(&crb);

This (and existing powernv vas code) is printk()ing a lot of lines per=20
fault. This should be pretty normal operation I think? It should avoid
filling the kernel logs, if so. Particularly if it can be triggered by=20
userspace.

I know it's existing code, so could be fixed separately from the series.


> +		vas_update_csb(&crb, tsk_ref);

> +	}

> +
> +	return IRQ_HANDLED;
> +}
> +
