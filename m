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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848D3C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 06:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AC49613DC
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 06:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhEJGCX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 02:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhEJGCX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 02:02:23 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4702BC061573
        for <linux-crypto@vger.kernel.org>; Sun,  9 May 2021 23:01:18 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s22so12513753pgk.6
        for <linux-crypto@vger.kernel.org>; Sun, 09 May 2021 23:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=tXVn144jSK+ewNBXIfRc1vswjU0ygw+IvP0ezkJ5gPE=;
        b=CCyemtN9DSPP5OKs4PRCf9dceKAvEMIJxRoVZ1mQcymbYR38qWNgbqH4S0utc3mO5v
         q1hcAVduynTqmCdaj1LX9+txhHG9VAfd/Wu6EBClS5+wqo9IDdaiJmE20vJN3M4XBB0E
         NRX6muynj+Ur4i6PVvwnaDj5+xBp7lfVlcTY/3TjkKn2Kv/ts7jXrkutt7bwaK8FsFEc
         wXGhOCwospqBkWgriicuOEPzu6uIIK0PtZ/mN9bnN092w/shxwE9ZUrqAuOkDbJCpZWA
         gzO5bWUwpxUejukkpNyuh3encgzHk9casegePzmZjsLhy8I28DVNJTw1CPeTalcKDh9G
         TZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=tXVn144jSK+ewNBXIfRc1vswjU0ygw+IvP0ezkJ5gPE=;
        b=kka2RIxmXigJpQt21UCyUnkEYUgjImwbKTxRRPnRH5rGVQDAQ8LhcMI8DaR9QwF222
         S93ZEqWKy+6JrvRHKhC2Kj2MJfW6LKgdcsN5domdWyI7YaL71/OxaH2B+3OPrYy7++yL
         Hc0fck0nIMTGGl8xWtjCCWgcG+ZQ39RliESyFAHx+uf86slCEINc2pERzkWQxHt1qpiC
         KlMS6kn37visn2POoTDji1jmY0dTvnCfMpxkPF74Ywg7PA8dSLyp6o+If5aRPLVKkkIj
         J40lXRHiqdr4dVqiTGveMkRVQfK0SHYVFohvnBmmyLa0hx4YAe/qDQF3qnAM/E/n59Ke
         BbNg==
X-Gm-Message-State: AOAM5305JCdy+D1AEMJYI+05S/LlWU5cbT3awlImnbvrLCpAqjYHn2e+
        K73mlt8nqVHQztW7NbVTl20=
X-Google-Smtp-Source: ABdhPJwBfVh9w60qYmp539k/2WBl/l0dUIHocwsEPbgXEkj1DTGGQDBObJ5YUWYGIAHpOq6n0EosvQ==
X-Received: by 2002:a05:6a00:16c2:b029:228:964e:8b36 with SMTP id l2-20020a056a0016c2b0290228964e8b36mr23839229pfc.11.1620626477727;
        Sun, 09 May 2021 23:01:17 -0700 (PDT)
Received: from localhost (60-241-47-46.tpgi.com.au. [60.241.47.46])
        by smtp.gmail.com with ESMTPSA id e6sm10110148pfd.219.2021.05.09.23.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:01:17 -0700 (PDT)
Date:   Mon, 10 May 2021 16:01:12 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [V3 PATCH 08/16] powerpc/pseries/VAS: Implement
 allocate/modify/deallocate HCALLS
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
        <e4c29e44cabee9197caa379e1260d2d7e33b20c7.camel@linux.ibm.com>
In-Reply-To: <e4c29e44cabee9197caa379e1260d2d7e33b20c7.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1620626049.bn914ucmrk.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of April 18, 2021 7:07 am:
>=20
> This patch adds the following HCALLs which are used to allocate,
> modify and deallocate VAS windows.

I don't like to be nitpicky about the language, but this is adding the=20
hcall wrappers. Implementing the hcall would be adding it to KVM.=20
Otherwise looks okay I think.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> H_ALLOCATE_VAS_WINDOW: Allocate VAS window
> H_DEALLOCATE_VAS_WINDOW: Close VAS window
> H_MODIFY_VAS_WINDOW: Setup window before using
>=20
> Also adds phyp call (H_QUERY_VAS_CAPABILITIES) to get all VAS
> capabilities that phyp provides.

"PAPR hcall to get VAS capabilities provided by the hypervisor"

Thanks,
Nick

>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/vas.c | 217 +++++++++++++++++++++++++++
>  1 file changed, 217 insertions(+)
>  create mode 100644 arch/powerpc/platforms/pseries/vas.c
>=20
> diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platform=
s/pseries/vas.c
> new file mode 100644
> index 000000000000..06960151477c
> --- /dev/null
> +++ b/arch/powerpc/platforms/pseries/vas.c
> @@ -0,0 +1,217 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright 2020-21 IBM Corp.
> + */
> +
> +#define pr_fmt(fmt) "vas: " fmt
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/export.h>
> +#include <linux/types.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/irqdomain.h>
> +#include <linux/interrupt.h>
> +#include <linux/sched/mm.h>
> +#include <linux/mmu_context.h>
> +#include <asm/hvcall.h>
> +#include <asm/hvconsole.h>
> +#include <asm/machdep.h>
> +#include <asm/plpar_wrappers.h>
> +#include <asm/vas.h>
> +#include "vas.h"
> +
> +#define	VAS_INVALID_WIN_ADDRESS	0xFFFFFFFFFFFFFFFFul
> +#define	VAS_DEFAULT_DOMAIN_ID	0xFFFFFFFFFFFFFFFFul
> +/* Authority Mask Register (AMR) value is not supported in */
> +/* linux implementation. So pass '0' to modify window HCALL */
> +#define	VAS_AMR_VALUE	0
> +/* phyp allows one credit per window right now */
> +#define DEF_WIN_CREDS		1
> +
> +static int64_t hcall_return_busy_check(int64_t rc)
> +{
> +	/* Check if we are stalled for some time */
> +	if (H_IS_LONG_BUSY(rc)) {
> +		msleep(get_longbusy_msecs(rc));
> +		rc =3D H_BUSY;
> +	} else if (rc =3D=3D H_BUSY) {
> +		cond_resched();
> +	}
> +
> +	return rc;
> +}
> +
> +/*
> + * Allocate VAS window HCALL
> + */
> +static int plpar_vas_allocate_window(struct vas_window *win, u64 *domain=
,
> +				     u8 wintype, u16 credits)
> +{
> +	long retbuf[PLPAR_HCALL9_BUFSIZE] =3D {0};
> +	int64_t rc;
> +
> +	do {
> +		rc =3D plpar_hcall9(H_ALLOCATE_VAS_WINDOW, retbuf, wintype,
> +				  credits, domain[0], domain[1], domain[2],
> +				  domain[3], domain[4], domain[5]);
> +
> +		rc =3D hcall_return_busy_check(rc);
> +	} while (rc =3D=3D H_BUSY);
> +
> +	switch (rc) {
> +	case H_SUCCESS:
> +		win->winid =3D retbuf[0];
> +		win->lpar.win_addr =3D retbuf[1];
> +		win->lpar.complete_irq =3D retbuf[2];
> +		win->lpar.fault_irq =3D retbuf[3];
> +		if (win->lpar.win_addr =3D=3D VAS_INVALID_WIN_ADDRESS) {
> +			pr_err("HCALL(%x): COPY/PASTE is not supported\n",
> +				H_ALLOCATE_VAS_WINDOW);
> +			return -ENOTSUPP;
> +		}
> +		return 0;
> +	case H_PARAMETER:
> +		pr_err("HCALL(%x): Invalid window type (%u)\n",
> +			H_ALLOCATE_VAS_WINDOW, wintype);
> +		return -EINVAL;
> +	case H_P2:
> +		pr_err("HCALL(%x): Credits(%u) exceed maximum window credits\n",
> +			H_ALLOCATE_VAS_WINDOW, credits);
> +		return -EINVAL;
> +	case H_COP_HW:
> +		pr_err("HCALL(%x): User-mode COPY/PASTE is not supported\n",
> +			H_ALLOCATE_VAS_WINDOW);
> +		return -ENOTSUPP;
> +	case H_RESOURCE:
> +		pr_err("HCALL(%x): LPAR credit limit exceeds window limit\n",
> +			H_ALLOCATE_VAS_WINDOW);
> +		return -EPERM;
> +	case H_CONSTRAINED:
> +		pr_err("HCALL(%x): Credits (%u) are not available\n",
> +			H_ALLOCATE_VAS_WINDOW, credits);
> +		return -EPERM;
> +	default:
> +		pr_err("HCALL(%x): Unexpected error %lld\n",
> +			H_ALLOCATE_VAS_WINDOW, rc);
> +		return -EIO;
> +	}
> +}
> +
> +/*
> + * Deallocate VAS window HCALL.
> + */
> +static int plpar_vas_deallocate_window(u64 winid)
> +{
> +	int64_t rc;
> +
> +	do {
> +		rc =3D plpar_hcall_norets(H_DEALLOCATE_VAS_WINDOW, winid);
> +
> +		rc =3D hcall_return_busy_check(rc);
> +	} while (rc =3D=3D H_BUSY);
> +
> +	switch (rc) {
> +	case H_SUCCESS:
> +		return 0;
> +	case H_PARAMETER:
> +		pr_err("HCALL(%x): Invalid window ID %llu\n",
> +			H_DEALLOCATE_VAS_WINDOW, winid);
> +		return -EINVAL;
> +	case H_STATE:
> +		pr_err("HCALL(%x): Window(%llu): Invalid page table entries\n",
> +			H_DEALLOCATE_VAS_WINDOW, winid);
> +		return -EPERM;
> +	default:
> +		pr_err("HCALL(%x): Unexpected error %lld for window(%llu)\n",
> +			H_DEALLOCATE_VAS_WINDOW, rc, winid);
> +		return -EIO;
> +	}
> +}
> +
> +/*
> + * Modify VAS window.
> + * After the window is opened with allocate window HCALL, configure it
> + * with flags and LPAR PID before using.
> + */
> +static int plpar_vas_modify_window(struct vas_window *win)
> +{
> +	int64_t rc;
> +	u32 lpid =3D mfspr(SPRN_PID);
> +
> +	/*
> +	 * AMR value is not supported in Linux implementation
> +	 * phyp ignores it if 0 is passed.
> +	 */
> +	do {
> +		rc =3D plpar_hcall_norets(H_MODIFY_VAS_WINDOW, win->winid,
> +					lpid, 0, VAS_MOD_WIN_FLAGS,
> +					VAS_AMR_VALUE);
> +
> +		rc =3D hcall_return_busy_check(rc);
> +	} while (rc =3D=3D H_BUSY);
> +
> +	switch (rc) {
> +	case H_SUCCESS:
> +		return 0;
> +	case H_PARAMETER:
> +		pr_err("HCALL(%x): Invalid window ID %u\n",
> +			H_MODIFY_VAS_WINDOW, win->winid);
> +		return -EINVAL;
> +	case H_P2:
> +		pr_err("HCALL(%x): Window(%d): Invalid LPAR Process ID %u\n",
> +			H_MODIFY_VAS_WINDOW, lpid, win->winid);
> +		return -EINVAL;
> +	case H_P3:
> +		/* LPAR thread ID is deprecated on P10 */
> +		pr_err("HCALL(%x): Invalid LPAR Thread ID for window(%u)\n",
> +			H_MODIFY_VAS_WINDOW, win->winid);
> +		return -EINVAL;
> +	case H_STATE:
> +		pr_err("HCALL(%x): Jobs in progress, Can't modify window(%u)\n",
> +			H_MODIFY_VAS_WINDOW, win->winid);
> +		return -EBUSY;
> +	default:
> +		pr_err("HCALL(%x): Unexpected error %lld for window(%u)\n",
> +			H_MODIFY_VAS_WINDOW, rc, win->winid);
> +		return -EIO;
> +	}
> +}
> +
> +/*
> + * This HCALL is used to determine the capabilities that pHyp provides.
> + * @hcall: H_QUERY_VAS_CAPABILITIES or H_QUERY_NX_CAPABILITIES
> + * @query_type: If 0 is passed, phyp returns the overall capabilities
> + *		which provides all feature(s) that are available. Then
> + *		query phyp to get the corresponding capabilities for
> + *		the specific feature.
> + *		Example: H_QUERY_VAS_CAPABILITIES provides VAS GZIP QoS
> + *			and VAS GZIP Default capabilities.
> + *			H_QUERY_NX_CAPABILITIES provides NX GZIP
> + *			capabilities.
> + * @result: Return buffer to save capabilities.
> + */
> +int plpar_vas_query_capabilities(const u64 hcall, u8 query_type,
> +					u64 result)
> +{
> +	int64_t rc;
> +
> +	rc =3D plpar_hcall_norets(hcall, query_type, result);
> +
> +	switch (rc) {
> +	case H_SUCCESS:
> +		return 0;
> +	case H_PARAMETER:
> +		pr_err("HCALL(%llx): Invalid query type %u\n", hcall,
> +			query_type);
> +		return -EINVAL;
> +	case H_PRIVILEGE:
> +		pr_err("HCALL(%llx): Invalid result buffer 0x%llx\n",
> +			hcall, result);
> +		return -EACCES;
> +	default:
> +		pr_err("HCALL(%llx): Unexpected error %lld\n", hcall, rc);
> +		return -EIO;
> +	}
> +}
> --=20
> 2.18.2
>=20
>=20
>=20
