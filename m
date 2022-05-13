Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60E7C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 May 2022 10:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiEMKGa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 06:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379292AbiEMKGZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 06:06:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B50C3055B
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 03:06:22 -0700 (PDT)
Date:   Fri, 13 May 2022 12:06:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1652436380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H1LrKNO29KP/u05Y7WaZv1tbe+rr2wRUubCJPU33HN4=;
        b=AsEriMcZhcK2Jfui36OQ8MDhMlz6s3JDk4oFcUj7vWeybMSokFOKz+jNtpoFIPY+wBJry8
        UNpGVoOCYMdJKDtBi1/+za3FsZRrAufuKFuiWiIrUJju/UB7ViZM2hz/yMFDNv/RAFaBbg
        nkdnqAz7hKpkIWI/PyT97LUQGoZVjyMv2YbK11/GpmBZbIf2RDe78usdoSdoTK4txXtrcd
        GvcYq7yBZ29wivLFLS0WLwxOBNlp3Y2c7RfUVizlcoAh2YfXOr/SiUxh1IamfOng/is7Yb
        RtTdyl9T6EASdUNUyfeL7594cvjbjNDHflggAxpazEPzUHKIvyYcQ0qTNoqhRg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1652436380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H1LrKNO29KP/u05Y7WaZv1tbe+rr2wRUubCJPU33HN4=;
        b=fKxwzlmk4Pofsm1buxs7wQNtgdF3Jbt0etWReeDb/XWlaDb6cTQUbYNo5hle0BGy26peFR
        vFX6cmjQEv45GwAg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: cryptd - Protect per-CPU resource by disabling
 BH.
Message-ID: <Yn4tm0XNl+xNkPJ1@linutronix.de>
References: <YnKWuLQZdPwSdRTh@linutronix.de>
 <Yn4mY9ydSqto7oF5@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yn4mY9ydSqto7oF5@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022-05-13 17:35:31 [+0800], Herbert Xu wrote:
> 
> Good catch! This bug has been around for a while.  Did you detect
> this in the field or was it through code-review?

It caused warnings in RT and we had a RT specific workaround for quite
some time. Now that we try to get RT upstream I've been looking how to
solve this differently and came up with this.

> Patch applied.  Thanks.

Thank you.

Sebastian
