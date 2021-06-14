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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4122C49361
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 02:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C91D613BE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 02:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhFNCOs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 22:14:48 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:33708 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbhFNCOs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 22:14:48 -0400
Received: by mail-pj1-f50.google.com with SMTP id k22-20020a17090aef16b0290163512accedso9629252pjz.0
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 19:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=v4Fu4xxoDiWhZlH1o8ZlqZuR7cYM6Y8M/w4ESBKxI2k=;
        b=ot2i+lwAav7/lXoGb0mcnPRLXIp3V9XIixu9sg5RpjuhXl9dX20/jtczYdpVW+TfnI
         T7WyuZuKMAYuZdz8G0eBvPXKI+qlSBH/We324I4lS8TQSDmL+t2eTrIwMtePnmAO+nFt
         3LCrYiJL4717KDHQpGzfraX2xIgOQSXcL7vsPrxcTofPNS6iskeKi7iX4pO2PmzEk8G4
         hwtXjm3CxquGFn6eplMI6MxXr9UUMK+eTNV7r3v5z6GJm3im+6F7Z5s6klcRno24jClu
         J/XUCwmkauW7+bkMUGx95PotYYrBbQ0UOBh2+PeWyHyX6Dv1JRRAfbBP+sEiIsLoddYI
         vV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=v4Fu4xxoDiWhZlH1o8ZlqZuR7cYM6Y8M/w4ESBKxI2k=;
        b=MJSW91K6ACEIrzpA4ZRb4g7bxIQNSjw1Vhy1M/+T/DwT9PQM14Z/1RYUogencG2hV3
         Bk8C0gPszkW5kHaTQ3lWLRQwUawK19GqS2wbhvZT0U2Md7R58IdykF0fda5HZ4mqZYf2
         xJTLitQEOTAzGfaq29Em+bsY4+dHDcAmnAhVOF/oiqoSm91XJH5V2oMlJHzx8EWAm7ur
         W9S8Hc0NickKkwhZN+pdQv32wNSFnAjft1nT/zV7MkfiIevH177KosD0rGv7aCy/twQG
         6lOBsHHEGxuPsGzbcs5qvpEpJx7012Lhb5zXc+ZgclRX7rw9utHU1baU5fH7nykAaMbk
         k4GQ==
X-Gm-Message-State: AOAM531bGGVp2w7dayvUnf76pNbnj4XDv0q1/FjWQx5kJUIvmkDO0jAw
        wdWAcUDqdzKnGPKNSJqjZ10=
X-Google-Smtp-Source: ABdhPJyvdMC56vD9BKqOT9vwycvqRSg53YgaRKzDvMSXqee7ZI1q656wEAqUjMGc8yiO9Nmzr4Xhxg==
X-Received: by 2002:a17:90a:4503:: with SMTP id u3mr16743381pjg.210.1623636706302;
        Sun, 13 Jun 2021 19:11:46 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id y66sm11176653pfb.91.2021.06.13.19.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 19:11:46 -0700 (PDT)
Date:   Mon, 14 Jun 2021 12:11:41 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 01/17] powerpc/powernv/vas: Release reference to tgid
 during window close
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
        <4c769385e96a9b7022a4fd22938310550ceba5e1.camel@linux.ibm.com>
In-Reply-To: <4c769385e96a9b7022a4fd22938310550ceba5e1.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623636630.ja53s1iki0.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 13, 2021 8:54 pm:
>=20
> The kernel handles the NX fault by updating CSB or sending
> signal to process. In multithread applications, children can
> open VAS windows and can exit without closing them. But the
> parent can continue to send NX requests with these windows. To
> prevent pid reuse, reference will be taken on pid and tgid
> when the window is opened and release them during window close.
>=20
> The current code is not releasing the tgid reference which can
> cause pid leak and this patch fixes the issue.
>=20
> Fixes: db1c08a740635 ("powerpc/vas: Take reference to PID and mm for user=
 space windows")
> Cc: stable@vger.kernel.org # 5.8+
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> Reported-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

> ---
>  arch/powerpc/platforms/powernv/vas-window.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/powerpc/platforms/powernv/vas-window.c b/arch/powerpc/p=
latforms/powernv/vas-window.c
> index 5f5fe63a3d1c..7ba0840fc3b5 100644
> --- a/arch/powerpc/platforms/powernv/vas-window.c
> +++ b/arch/powerpc/platforms/powernv/vas-window.c
> @@ -1093,9 +1093,9 @@ struct vas_window *vas_tx_win_open(int vasid, enum =
vas_cop_type cop,
>  		/*
>  		 * Process closes window during exit. In the case of
>  		 * multithread application, the child thread can open
> -		 * window and can exit without closing it. Expects parent
> -		 * thread to use and close the window. So do not need
> -		 * to take pid reference for parent thread.
> +		 * window and can exit without closing it. so takes tgid
> +		 * reference until window closed to make sure tgid is not
> +		 * reused.
>  		 */
>  		txwin->tgid =3D find_get_pid(task_tgid_vnr(current));
>  		/*
> @@ -1339,8 +1339,9 @@ int vas_win_close(struct vas_window *window)
>  	/* if send window, drop reference to matching receive window */
>  	if (window->tx_win) {
>  		if (window->user_win) {
> -			/* Drop references to pid and mm */
> +			/* Drop references to pid. tgid and mm */
>  			put_pid(window->pid);
> +			put_pid(window->tgid);
>  			if (window->mm) {
>  				mm_context_remove_vas_window(window->mm);
>  				mmdrop(window->mm);
> --=20
> 2.18.2
>=20
>=20
>=20
