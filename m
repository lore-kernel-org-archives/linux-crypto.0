Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35754C47082
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 04:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C5BE613E3
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 04:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFCE2e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 00:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhFCE2d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 00:28:33 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A48C06174A
        for <linux-crypto@vger.kernel.org>; Wed,  2 Jun 2021 21:26:34 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d16so3893935pfn.12
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jun 2021 21:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=hadN1zKWfMzs8CNVqhf3si3r1zptnb25lQyw1l4DEJo=;
        b=nlgSXqG4KLQpB0O0mupGwzaKX0KxGlZssCJFbzlrDZMaaJl7NGSLiG7dBfKx7Xlbc5
         cypvQXE0ODiFXHu3vK/TNLt57BRW7Fx1lmSWfkog+OflJ2qjPtaoU1QMvqqB6EX0U6Tp
         LZSj5SUzf54Mj/LwrEkNG9eqWV0eOZzLo/Wtn0YTWMRAEtlsTKSLPumDi40o/pgaOzLy
         7TSwcyXLkvPpNJzWw+gSWTo20R6ISEnKz+pbcwQuAVWbZv9+5XMTTIMTaEVS98RVtwCK
         N2td55lji2rY9LcHZAE8dm+9TZ3zPaTdmDOTu8pso2WV0Sf1Zfo2cBP7d0ESwgxaEt1r
         ciSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=hadN1zKWfMzs8CNVqhf3si3r1zptnb25lQyw1l4DEJo=;
        b=Cz68jg/VZqo+m5uJB6r80DHs+vHod3rcNctro7nRqQob6JSAExF5cLRVeNyEZD3kQc
         4Jey5v4XSKW3fEoZrOiMpQMAsDkMP341GD/mY4gRAcMcG+UUe60GqFnQ9xAajrPbSIF1
         uTY7Gp+h0o2uVgPksRAKEO04IYQhqM/dtoI1qwIlGs/pgeKbvcEkJhuCBxePn0hoYGrA
         sKQ4EUHOW/S4er71Lyy8HkOZ/MKASmskDi/B3UMMyvSbzneBycRAtOcMO96eP5SZ5lYT
         lc518yS1HwWP01UxhFRKhn7pMrfW6yHZJRnJ/xX2S4hp/u+q28FDT2p00EEnalrcznfh
         k8gA==
X-Gm-Message-State: AOAM531V5f8X1u3kwFQgji2oZjV9LCKa0WJDT4lXl0NsKIQnUySg8fNB
        NnAFRcsW09Tw4IWJ6WAnerU=
X-Google-Smtp-Source: ABdhPJw9xulYWMtCGTR8p5sCoVzQhygQRWw5b7lFmCWGeU36P/jdRGvSy6mz1tqOmNNUa+M/Xn7gAg==
X-Received: by 2002:a63:f615:: with SMTP id m21mr37851279pgh.282.1622694394117;
        Wed, 02 Jun 2021 21:26:34 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id j12sm1158876pgs.83.2021.06.02.21.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 21:26:33 -0700 (PDT)
Date:   Thu, 03 Jun 2021 14:26:28 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 05/16] powerpc/vas: Move update_csb/dump_crb to common
 book3s platform
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
        <b1c0661b5ff896b2ce7b1202a5e6efeb2dae68a8.camel@linux.ibm.com>
In-Reply-To: <b1c0661b5ff896b2ce7b1202a5e6efeb2dae68a8.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1622694146.br4czu7jza.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of May 21, 2021 7:32 pm:
> +
> +	pid =3D task_ref->pid;
> +	tsk =3D get_pid_task(pid, PIDTYPE_PID);
> +	/*
> +	 * Process closes send window after all pending NX requests are
> +	 * completed. In multi-thread applications, a child thread can
> +	 * open a window and can exit without closing it. May be some
> +	 * requests are pending or this window can be used by other
> +	 * threads later. We should handle faults if NX encounters
> +	 * pages faults on these requests. Update CSB with translation
> +	 * error and fault address. If csb_addr passed by user space is
> +	 * invalid, send SEGV signal to pid saved in window. If the
> +	 * child thread is not running, send the signal to tgid.
> +	 * Parent thread (tgid) will close this window upon its exit.
> +	 *
> +	 * pid and mm references are taken when window is opened by
> +	 * process (pid). So tgid is used only when child thread opens
> +	 * a window and exits without closing it.
> +	 */
> +	if (!tsk) {
> +		pid =3D task_ref->tgid;
> +		tsk =3D get_pid_task(pid, PIDTYPE_PID);
> +		/*
> +		 * Parent thread (tgid) will be closing window when it
> +		 * exits. So should not get here.
> +		 */
> +		if (WARN_ON_ONCE(!tsk))
> +			return;
> +	}
> +
> +	/* Return if the task is exiting. */
> +	if (tsk->flags & PF_EXITING) {
> +		put_task_struct(tsk);
> +		return;
> +	}

Just as an aside, I know this is existing code, after this series it=20
might be good to think about factoring out this above chunk of code=20
(possibly +/- the kthread_use_mm() bit), and put it together with the=20
rest of the task/mm refcounting stuff.

Thanks,
Nick

> +
> +	kthread_use_mm(task_ref->mm);
> +	rc =3D copy_to_user(csb_addr, &csb, sizeof(csb));
> +	/*
> +	 * User space polls on csb.flags (first byte). So add barrier
> +	 * then copy first byte with csb flags update.
> +	 */
> +	if (!rc) {
> +		csb.flags =3D CSB_V;
> +		/* Make sure update to csb.flags is visible now */
> +		smp_mb();
> +		rc =3D copy_to_user(csb_addr, &csb, sizeof(u8));
> +	}
> +	kthread_unuse_mm(task_ref->mm);
> +	put_task_struct(tsk);
> +
