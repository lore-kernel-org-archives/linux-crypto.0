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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA96C48BE6
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Jun 2021 09:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ECAA61246
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Jun 2021 09:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhFPJlB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Jun 2021 05:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbhFPJlA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jun 2021 05:41:00 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C5DC061574
        for <linux-crypto@vger.kernel.org>; Wed, 16 Jun 2021 02:38:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h16so1386296pjv.2
        for <linux-crypto@vger.kernel.org>; Wed, 16 Jun 2021 02:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=hYvyu6++tioO7eJQtbNsI7CkzBU7sA3WvkWBaGv47x4=;
        b=BPGWtadA4JhcBq1nJIPOWtEYYISK/g/n2xC2zdbNhsdjb5WbMM1bQWr/By3zo5J4FL
         bx+wtuE0TZ7/qB3LiHH+YvNGW6M3tXZD8bz75V/Vt59BwTOxlS0o8i09G0r9NTPyZflC
         1XDxfYNT/7rgNKwwh5y1/K6pbULxv/m6owXOKit0Bkyo3IMEtkGSXuQWUhmSpTO/+YBt
         PbLXCmyHs5B3GUoiPJ4Nen6T3tQ2y/se/3UZVy3ncwzBFXKJu7YP2D/UqWRGTdzUaBUi
         5VOymPTOUMx8qTX/91t8Lx8MN31yn25UvaafR2cZOzszKWVNfsblMXJA7zemKZ6vB046
         8G3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=hYvyu6++tioO7eJQtbNsI7CkzBU7sA3WvkWBaGv47x4=;
        b=O/QVCioHtTZaWhRNynFPNPoOiY/M9NllwuvU++FCezo6W9yG+bYRlJjiLUJhmduwuO
         HvWKwMlMIRPgFDu8Qf1UpOn6Pqq3Q0EtbbnB1eZRtRhWkQqg5xMRUmGTVc4llKd8GumX
         aV67FzIU8802SSKO4qnK2CXl5pqRfj4hV0bI+CRbGt+Iooj7qM9VWGLvKWnlYzhy+d2v
         VzaS/vP9UrWXHODdqYVhtUbNbyM2UtUyUaHRS/xHhi0Ku9sB5pT77yxauiSL57rS2PMB
         uxsEVTzobX0vnHSNqTjYgq8c7Ga+rapGXFhLyjSabMt75RUpHIQ1zRhmhlgocoxqj/yx
         JSrg==
X-Gm-Message-State: AOAM5333lrT79UomMr4sF4xqsBGTsMCCd9qqZeixFvKZpGHayyIBRJWO
        ws6ZcDgMxHC0LOXAOxFuDJk=
X-Google-Smtp-Source: ABdhPJwVBGiBV2rheQDOzKCb+KLNeJewP5Yhmc7ttO8fHATyk4Az+CTs3wiw8jexBkdLCWB13L0AmQ==
X-Received: by 2002:a17:90a:a585:: with SMTP id b5mr9857554pjq.10.1623836334263;
        Wed, 16 Jun 2021 02:38:54 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id r92sm5212375pja.6.2021.06.16.02.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 02:38:53 -0700 (PDT)
Date:   Wed, 16 Jun 2021 19:38:48 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 12/17] powerpc/pseries/vas: Integrate API with
 open/close windows
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
        <58c2f9debeff2ff6515ea950ebdd6483c147c843.camel@linux.ibm.com>
        <1623638159.6pp87imz6a.astroid@bobo.none>
        <91d139adcbd9e4851fdb11d30888f5f5a923b764.camel@linux.ibm.com>
In-Reply-To: <91d139adcbd9e4851fdb11d30888f5f5a923b764.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623834725.mpbd01qpyw.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 15, 2021 5:26 pm:
> On Mon, 2021-06-14 at 12:55 +1000, Nicholas Piggin wrote:
>> Excerpts from Haren Myneni's message of June 13, 2021 9:02 pm:
>> > This patch adds VAS window allocatioa/close with the corresponding
>> > hcalls. Also changes to integrate with the existing user space VAS
>> > API and provide register/unregister functions to NX pseries driver.
>> >=20
>> > The driver register function is used to create the user space
>> > interface (/dev/crypto/nx-gzip) and unregister to remove this
>> > entry.
>> >=20
>> > The user space process opens this device node and makes an ioctl
>> > to allocate VAS window. The close interface is used to deallocate
>> > window.
>> >=20
>> > Signed-off-by: Haren Myneni <haren@linux.ibm.com>
>> > ---
>> >  arch/powerpc/include/asm/vas.h          |   4 +
>> >  arch/powerpc/platforms/pseries/Makefile |   1 +
>> >  arch/powerpc/platforms/pseries/vas.c    | 223
>> > ++++++++++++++++++++++++
>> >  3 files changed, 228 insertions(+)
>> >=20
>> > diff --git a/arch/powerpc/include/asm/vas.h
>> > b/arch/powerpc/include/asm/vas.h
>> > index eefc758d8cd4..9d5646d721c4 100644
>> > --- a/arch/powerpc/include/asm/vas.h
>> > +++ b/arch/powerpc/include/asm/vas.h
>> > @@ -254,6 +254,10 @@ struct vas_all_caps {
>> >  	u64     feat_type;
>> >  };
>> > =20
>> > +int h_query_vas_capabilities(const u64 hcall, u8 query_type, u64
>> > result);
>> > +int vas_register_api_pseries(struct module *mod,
>> > +			     enum vas_cop_type cop_type, const char
>> > *name);
>> > +void vas_unregister_api_pseries(void);
>> >  #endif
>> > =20
>> >  /*
>> > diff --git a/arch/powerpc/platforms/pseries/Makefile
>> > b/arch/powerpc/platforms/pseries/Makefile
>> > index c8a2b0b05ac0..4cda0ef87be0 100644
>> > --- a/arch/powerpc/platforms/pseries/Makefile
>> > +++ b/arch/powerpc/platforms/pseries/Makefile
>> > @@ -30,3 +30,4 @@ obj-$(CONFIG_PPC_SVM)		+=3D svm.o
>> >  obj-$(CONFIG_FA_DUMP)		+=3D rtas-fadump.o
>> > =20
>> >  obj-$(CONFIG_SUSPEND)		+=3D suspend.o
>> > +obj-$(CONFIG_PPC_VAS)		+=3D vas.o
>> > diff --git a/arch/powerpc/platforms/pseries/vas.c
>> > b/arch/powerpc/platforms/pseries/vas.c
>> > index 98109a13f1c2..fe375f7a7029 100644
>> > --- a/arch/powerpc/platforms/pseries/vas.c
>> > +++ b/arch/powerpc/platforms/pseries/vas.c
>> > @@ -10,6 +10,7 @@
>> >  #include <linux/export.h>
>> >  #include <linux/types.h>
>> >  #include <linux/delay.h>
>> > +#include <linux/slab.h>
>> >  #include <asm/machdep.h>
>> >  #include <asm/hvcall.h>
>> >  #include <asm/plpar_wrappers.h>
>> > @@ -187,6 +188,228 @@ int h_query_vas_capabilities(const u64 hcall,
>> > u8 query_type, u64 result)
>> >  		return -EIO;
>> >  	}
>> >  }
>> > +EXPORT_SYMBOL_GPL(h_query_vas_capabilities);
>> > +
>> > +/*
>> > + * Allocate window and setup IRQ mapping.
>> > + */
>> > +static int allocate_setup_window(struct pseries_vas_window *txwin,
>> > +				 u64 *domain, u8 wintype)
>> > +{
>> > +	int rc;
>> > +
>> > +	rc =3D h_allocate_vas_window(txwin, domain, wintype,
>> > DEF_WIN_CREDS);
>> > +	if (rc)
>> > +		return rc;
>> > +
>> > +	txwin->vas_win.wcreds_max =3D DEF_WIN_CREDS;
>> > +
>> > +	return 0;
>> > +}
>> > +
>> > +static struct vas_window *vas_allocate_window(struct
>> > vas_tx_win_open_attr *uattr,
>> > +					      enum vas_cop_type
>> > cop_type)
>> > +{
>> > +	long domain[PLPAR_HCALL9_BUFSIZE] =3D {VAS_DEFAULT_DOMAIN_ID};
>> > +	struct vas_ct_caps *ct_caps;
>> > +	struct vas_caps *caps;
>> > +	struct pseries_vas_window *txwin;
>> > +	int rc;
>> > +
>> > +	txwin =3D kzalloc(sizeof(*txwin), GFP_KERNEL);
>> > +	if (!txwin)
>> > +		return ERR_PTR(-ENOMEM);
>> > +
>> > +	/*
>> > +	 * A VAS window can have many credits which means that many
>> > +	 * requests can be issued simultaneously. But phyp restricts
>> > +	 * one credit per window.
>> > +	 * phyp introduces 2 different types of credits:
>> > +	 * Default credit type (Uses normal priority FIFO):
>> > +	 *	A limited number of credits are assigned to partitions
>> > +	 *	based on processor entitlement. But these credits may be
>> > +	 *	over-committed on a system depends on whether the CPUs
>> > +	 *	are in shared or dedicated modes - that is, more requests
>> > +	 *	may be issued across the system than NX can service at
>> > +	 *	once which can result in paste command failure (RMA_busy).
>> > +	 *	Then the process has to resend requests or fall-back to
>> > +	 *	SW compression.
>> > +	 * Quality of Service (QoS) credit type (Uses high priority
>> > FIFO):
>> > +	 *	To avoid NX HW contention, the system admins can assign
>> > +	 *	QoS credits for each LPAR so that this partition is
>> > +	 *	guaranteed access to NX resources. These credits are
>> > +	 *	assigned to partitions via the HMC.
>> > +	 *	Refer PAPR for more information.
>> > +	 *
>> > +	 * Allocate window with QoS credits if user requested.
>> > Otherwise
>> > +	 * default credits are used.
>> > +	 */
>> > +	if (uattr->flags & VAS_TX_WIN_FLAG_QOS_CREDIT)
>> > +		caps =3D &vascaps[VAS_GZIP_QOS_FEAT_TYPE];
>> > +	else
>> > +		caps =3D &vascaps[VAS_GZIP_DEF_FEAT_TYPE];
>> > +
>> > +	ct_caps =3D &caps->caps;
>> > +
>> > +	if (atomic_inc_return(&ct_caps->used_lpar_creds) >
>> > +			atomic_read(&ct_caps->target_lpar_creds)) {
>> > +		pr_err("Credits are not available to allocate
>> > window\n");
>> > +		rc =3D -EINVAL;
>> > +		goto out;
>> > +	}
>> > +
>> > +	/*
>> > +	 * The user space is requesting to allocate a window on a VAS
>> > +	 * instance (or chip) where the process is executing.
>> > +	 * On powerVM, domain values are passed to pHyp to select chip
>> > /
>> > +	 * VAS instance. Useful if the process is affinity to NUMA
>> > node.
>> > +	 * pHyp selects VAS instance if VAS_DEFAULT_DOMAIN_ID (-1) is
>> > +	 * passed for domain values.
>> > +	 */
>>=20
>> s/powerVM/PowerVM
>> s/pHyp/PowerVM
>>=20
>> You could also just call it the hypervisor. KVM may not implement
>> the=20
>> hcalls now, but in future it could.
>>=20
>> > +	if (uattr->vas_id =3D=3D -1) {
>>=20
>> Should the above comment fit under here? vas_id =3D=3D -1 means
>> userspace=20
>> asks for any VAS but preferably a local one?
>>=20
>> > +		/*
>> > +		 * To allocate VAS window, pass same domain values
>> > returned
>> > +		 * from this HCALL.
>> > +		 */
>>=20
>> Then you could merge it with this comment and make it a bit clearer:
>> the h_allocate_vas_window hcall is defined to take a domain as
>> specified by h_home_node_associativity, so no conversions or
>> unpacking
>> needs to be done.
>>=20
>> > +		rc =3D plpar_hcall9(H_HOME_NODE_ASSOCIATIVITY, domain,
>> > +				  VPHN_FLAG_VCPU, smp_processor_id());
>> > +		if (rc !=3D H_SUCCESS) {
>> > +			pr_err("HCALL(%x): failed with ret(%d)\n",
>> > +			       H_HOME_NODE_ASSOCIATIVITY, rc);
>> > +			goto out;
>> > +		}
>> > +	}
>> > +
>> > +	/*
>> > +	 * Allocate / Deallocate window HCALLs and setup / free IRQs
>> > +	 * have to be protected with mutex.
>> > +	 * Open VAS window: Allocate window HCALL and setup IRQ
>> > +	 * Close VAS window: Deallocate window HCALL and free IRQ
>> > +	 *	The hypervisor waits until all NX requests are
>> > +	 *	completed before closing the window. So expects OS
>> > +	 *	to handle NX faults, means IRQ can be freed only
>> > +	 *	after the deallocate window HCALL is returned.
>> > +	 * So once the window is closed with deallocate HCALL before
>> > +	 * the IRQ is freed, it can be assigned to new allocate
>> > +	 * HCALL with the same fault IRQ by the hypervisor. It can
>> > +	 * result in setup IRQ fail for the new window since the
>> > +	 * same fault IRQ is not freed by the OS.
>> > +	 */
>> > +	mutex_lock(&vas_pseries_mutex);
>>=20
>> Why? What's the mutex protecting here?
> This mutex is protecting Allocate/ Deallocate HCAlls and setup/free
> IRQ.

But this lock is not protecting both, it's only around the hcall
as far as I can see... Oh, you add the irq setup in the next patch.
Okay that makes more sense.

I would possibly add the mutex lock in that patch, and move it into
allocate_setup_window?


> Basically once the window is opened and setup IRQ successfully,
> makes sure same IRQ is not assigned to otherwindow before the IRQ is
> freed in OS.=20
>=20
> Allocate window:=20
> 	Allocate window HCALL
> 	setup IRQ
>=20
> Deallocate window:
> 	Deallocate window HCALL - The hypervisor waits all credits are
> returned including any faults. Disable window on this VAS so that do
> not take new requests and wait for all pending requests (faults are
> processed)=20
> 	free IRQ (We can not free IRQ before the HCALL so that pending
> faults can be processed and credits returned)
>=20
> So if we do not jave mutex, possible that same fault IRQ may be
> assigned to different window open HCALL before it is actually freed in
> OS.
>=20
> Process A:
> Allocate window HCALL (winID 123)
> Setup IRQ (IRQ# 321)
> Process requests
> Deallocate HCALL(winID 123)       Process B:
>                                     Allocate window HCALL (winID 123)
>                                     setup IRQ (IRQ# 321) -- will fail.
> Free IRQ (IRQ#321)

Thanks. To educate me, what is the significance of #321 and 123 here?
Why could it not just allocate IRQ #322 here, or is it fixed to the
window ID?

>=20
>                        =20
>>=20
>> > +	rc =3D allocate_setup_window(txwin, (u64 *)&domain[0],
>> > +				   ct_caps->win_type);
>>=20
>> If you define the types to be the same, can you avoid this casting?
>> allocate_setup_window specifically needs an array of=20
>> PLPAR_HCALL9_BUFSIZE longs.
>=20
> Yes H_HOME_NODE_ASSOCIATIVITY returns longs (PLPAR_HCALL9_BUFSIZE) but
> H_ALLOCATE_VAS_WINDOW expects u64.

Oh, ignore me then I guess that's okay.

>=20
> Syntax:
> int64 /* H_Success, H_Parameter, H_Resource, H_Constrained */
> /* H_Cop_Hw, H_Unsupported, H_Busy */
> /* H_LongBusyOrder1mSec, LongBusyOrder10mSec */
> hcall(const uint64 H_ALLOCATE_VAS_WINDOW /* Allocate a VAS window */
> uint8 vasWindowType, /* The type of VAS window to allocate */
> uint16 numCredits, /* Number of credits to assign to the window */
> uint64 desiredAssociativityDomainIdentifier1, /* Associativity Domain
> Identifier Doubleword 1 */
> uint64 desiredAssociativityDomainIdentifier2, /* Associativity Domain
> Identifier Doubleword 2 */
> uint64 desiredAssociativityDomainIdentifier3, /* Associativity Domain
> Identifier Doubleword 3 */
> uint64 desiredAssociativityDomainIdentifier4, /* Associativity Domain
> Identifier Doubleword 4 */
> uint64 desiredAssociativityDomainIdentifier5, /* Associativity Domain
> Identifier Doubleword 5 */
> uint64 desiredAssociativityDomainIdentifier6) /* Associativity Domain
> Identifier Doubleword 6 */
>=20
>>=20
>> > +	mutex_unlock(&vas_pseries_mutex);
>> > +	if (rc)
>> > +		goto out;
>> > +
>> > +	/*
>> > +	 * Modify window and it is ready to use.
>> > +	 */
>> > +	rc =3D h_modify_vas_window(txwin);
>> > +	if (!rc)
>> > +		rc =3D get_vas_user_win_ref(&txwin->vas_win.task_ref);
>> > +	if (rc)
>> > +		goto out_free;
>> > +
>> > +	vas_user_win_add_mm_context(&txwin->vas_win.task_ref);
>> > +	txwin->win_type =3D ct_caps->win_type;
>> > +	mutex_lock(&vas_pseries_mutex);
>> > +	list_add(&txwin->win_list, &caps->list);
>> > +	mutex_unlock(&vas_pseries_mutex);
>> > +
>> > +	return &txwin->vas_win;
>> > +
>> > +out_free:
>> > +	h_deallocate_vas_window(txwin->vas_win.winid);
>>=20
>> No mutex here in this deallocate hcall.
>=20
> We do not need mutex just for this hcall which is executing during
> failure. Need mutex only for the code patch as explained above.=20
>=20
> If the window open is not returned to user space successfully, window
> close path will be:
>=20
>  free_irq_setup(txwin);
>  h_deallocate_vas_window(txwin->vas_win.winid);

Right, it's clearer in context of the next patch.

>>=20
>> I suspect you don't actually need the mutex for the hcalls
>> themselves,=20
>> but the list manipulations. I would possibly consider putting=20
>> used_lpar_creds under that same lock rather than making it atomic and
>> playing lock free games, unless you really need to.
>>=20
>> Also... "creds". credentials? credits, right? Don't go through and=20
>> change everything now, but not skimping on naming helps a lot with
>> reading code that you're not familiar with. All the vas/nx stuff
>> could probably do with a pass to make the names a bit easier.
>=20
> Yes creds is for credits. We have names like credits and capabilities
> for VAS/NX. Using creds for credits and caps for capabilities. creds is
> already used in the existing code.
>=20
>>=20
>> (creds isn't so bad, "ct" for "coprocessor type" is pretty obscure=20
>> though).
>=20
> So can I use 'copt' coprocessor type?

Sorry I don't want to get into nitpicking so much, naming is hard and=20
I'm far from perfect at it. The existing stuff is not bad, I'm just not
used to reading it but all code has its own conventions. Go with what
you have for now.

I think that takes care of my questions, I'm happy with whatever you=20
decide with the comments and mutex, they were only suggestions. So

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick
