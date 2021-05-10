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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB36BC433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 05:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8126C61432
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 05:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhEJF3c (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 01:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhEJF3a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 01:29:30 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AB5C061573
        for <linux-crypto@vger.kernel.org>; Sun,  9 May 2021 22:28:25 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id j12so6409906pgh.7
        for <linux-crypto@vger.kernel.org>; Sun, 09 May 2021 22:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=2VbFkIdqBQxH26BVP9oIWdsN+5IFXGUTwRy6ERH1Tpw=;
        b=bH5pmDBc8pBK2qVKWRfnveZ5sLIOXxVMTvJTMH01IsGC1vGiGU1iFxURm99zmbIau5
         vYok6oysBrq7ez+F9eIOkMZr9KWKn1Ovj9x8ZGkKgWSAStVTv4/n4dlsCISoQSGgYhYT
         w00V9dtjLyLgWlKsMNYsvSxsC5UIeJgkyRXRcDRySz9yZQNmG/49AvU1YDMaxokoDxLt
         KlOsVRIOkKD5xYngehTRUXJxytsom2PqGEGmik9lTDF5ow6x6ueHG90Du+kcddX63zv8
         s3Ys//P9PyA2j6ldOpu+gcEtK0yqNj4oUXi5LDqeugJwFtzXqhDmmuc+OE1nhAgaInXh
         dmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=2VbFkIdqBQxH26BVP9oIWdsN+5IFXGUTwRy6ERH1Tpw=;
        b=R0owhD2AhK6VpAHbRHT6aOUTlLmEq/DJYdwerWhwlzdPOMIEMw8ZdZ51v/nJ/cv6tA
         BJdYsqnt40iQX3yK5pg2UjRXwrj8wEtFDz0o1ZvzeTdSet0MliBsfweH91jeVzjfMI2U
         VexvhuyirZ/8tqtWtqcGqAnXhYdWBzWsDsZeKQx4/oJzejV4DbigqD+vd+hoz2YowiYF
         e7ElYk2Y6KT1JhJ4wu4Q2zkDlIq/qkhX3GJvoE7SwY4gCJYEPw7oidjo4Yx+V0Gn2WvO
         oBBVHn9zsiGcyF7QAbtDfSGMq03UX6wnr8C32S/IQYhoFSjLmx7bcQKXpSXbw7E8sxwy
         gkNg==
X-Gm-Message-State: AOAM531VeofFEvVWAtXOehvt2gJssZw8jrybiWCTOuE0pvgXGIiF6uy+
        +znHUlQLuCaDPxsGfK0Hvho=
X-Google-Smtp-Source: ABdhPJyW3WImWl4HiUkBRa1xA9WOXxfEAHMN2f8/tsEIXOhS+5hd7g42J5+ohxHnSzjr6TTyKxElKw==
X-Received: by 2002:a63:8f17:: with SMTP id n23mr23748027pgd.82.1620624505405;
        Sun, 09 May 2021 22:28:25 -0700 (PDT)
Received: from localhost (60-241-47-46.tpgi.com.au. [60.241.47.46])
        by smtp.gmail.com with ESMTPSA id n8sm10018704pgm.7.2021.05.09.22.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 22:28:25 -0700 (PDT)
Date:   Mon, 10 May 2021 15:28:20 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [V3 PATCH 03/16] powerpc/vas: Create take/drop task reference
 functions
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
        <3d634fb22a1d3d87f3172b23414a48650fc9a366.camel@linux.ibm.com>
In-Reply-To: <3d634fb22a1d3d87f3172b23414a48650fc9a366.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1620624047.yy8sqcrk40.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of April 18, 2021 7:03 am:
>=20
> Take task reference when each window opens and drops during close.
> This functionality is needed for powerNV and pseries. So this patch
> defines the existing code as functions in common book3s platform
> vas-api.c
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/vas.h              | 20 ++++++++
>  arch/powerpc/platforms/book3s/vas-api.c     | 51 ++++++++++++++++++
>  arch/powerpc/platforms/powernv/vas-fault.c  | 10 ++--
>  arch/powerpc/platforms/powernv/vas-window.c | 57 ++-------------------
>  arch/powerpc/platforms/powernv/vas.h        |  6 +--
>  5 files changed, 83 insertions(+), 61 deletions(-)
>=20
> diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/va=
s.h
> index 6bbade60d8f4..2daaa1a2a9a9 100644
> --- a/arch/powerpc/include/asm/vas.h
> +++ b/arch/powerpc/include/asm/vas.h
> @@ -5,6 +5,9 @@
> =20
>  #ifndef _ASM_POWERPC_VAS_H
>  #define _ASM_POWERPC_VAS_H
> +#include <linux/sched/mm.h>
> +#include <linux/mmu_context.h>
> +#include <asm/icswx.h>
>  #include <uapi/asm/vas-api.h>
> =20
> =20
> @@ -60,6 +63,22 @@ struct vas_user_win_ops {
>  	int (*close_win)(void *);
>  };
> =20
> +struct vas_win_task {
> +	struct pid *pid;	/* Thread group ID of owner */
> +	struct pid *tgid;	/* Linux process mm_struct */
> +	struct mm_struct *mm;	/* Linux process mm_struct */
> +};

Looks okay, happy with struct vas_win_task? (and vas_user_win_ops)?

I'd be happier to have everything related to vas windows prefixed with=20
vas_window_ consistently, and have _user be present always for userspace
windows, but you have to read and type it.

> +
> +static inline void vas_drop_reference_task(struct vas_win_task *task)

This is not dropping a reference task, but a task reference. And it's=20
not really a task reference as far as Linux understands, but a
reference on pid (not task) and mm related to an open vas window. And
specifically a user window (with corresponding vas_user_win_ops).

Could it be called a 'struct vas_window_user_ref' instead?

Thanks,
Nick

> +{
> +	/* Drop references to pid and mm */
> +	put_pid(task->pid);
> +	if (task->mm) {
> +		mm_context_remove_vas_window(task->mm);
> +		mmdrop(task->mm);
> +	}
