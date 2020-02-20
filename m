Return-Path: <SRS0=ICHr=4I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC34BC11D00
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 09:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 951A32465D
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 09:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oy34RglT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgBTJDz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Feb 2020 04:03:55 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36610 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgBTJDy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Feb 2020 04:03:54 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so3718246wru.3;
        Thu, 20 Feb 2020 01:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kMRJMCeq8NZAOuDhnXD2Su6XH/Sug9+vybd1xVTnymM=;
        b=Oy34RglTmxJLtibBbGM0mOjmtCzIfi1VS84tpOVQPStsdzxw9bmDP/ccxGzVt8EqPJ
         QgLiArXg4cjojuSERHhIa8fgsIP1QgM9Y4K2rm2zhkxpu0w437Y9GZmAO3VH0xMokTRz
         k2FKaPRh7wlIh0Y5psMsLLpt9MsedKuXboQgLTepMW028eMy0jzy+79GZyDB5g4hAoJq
         Qx4XnhKsULmuMEOYNSwksD/UxjfS7UUshP7vMMiaZx7nx8msR2ipdxYAbwN4S2EapKrU
         YeQSP1DqMUaFtolcdN9QHhpD0ftXFGsefLviHaerCUre5Vivd3fft/J8fGZIIi8XtGvq
         ygXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kMRJMCeq8NZAOuDhnXD2Su6XH/Sug9+vybd1xVTnymM=;
        b=ZW2/5sH+4vvNJe7PY1mU8bMLj+LpA1vKCHhLc+gc0n1jTt0P7j5pRC5/17W9i7OQKw
         2TFl+P/WrVc1FrIuXoagb3sAZBulJ74Vd1+99YW/84imnyF3bdncZ3eTEAfBEU+D9Qhj
         i0gW1XvKCM0jo0ZYcwZSH/yI2vUn0rWIARj2/tgvvRrSsvUiB3MzESVAEo2S9Mjofd0Z
         HA6+Erv0UFh4dWtzgRa31kg7V7isAQfvub1N+4TRewJN11zwc2P2c/S82+P4124zrNQr
         h7jB+TJPLqFnr5p6YKYT7yeBeir6BawQMf4sEcHV4DO3fK+ZmDrn45FNg7mAC+WydcDA
         LdVw==
X-Gm-Message-State: APjAAAXiePPidOBBibMCFOInmt+qWxS334n2MhsvhvbHuvWpRwOlYRbx
        4QTulN5Ij8dZE+YdmIej3Kk=
X-Google-Smtp-Source: APXvYqyCkswrHjGraF8RCaW0bFvKpMzVB9ieAPAAGbQvXepjaII3MJ2D1bNhg/qX3pKIgcJCJ4JAbQ==
X-Received: by 2002:a5d:5152:: with SMTP id u18mr40578019wrt.214.1582189432341;
        Thu, 20 Feb 2020 01:03:52 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id b21sm3635764wmd.37.2020.02.20.01.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 01:03:51 -0800 (PST)
Date:   Thu, 20 Feb 2020 10:03:50 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     tj@kernel.org, jiangshanlai@gmail.com, will@kernel.org,
        mark.rutland@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20200220090350.GA19858@Red>
References: <20200217204803.GA13479@Red>
 <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 18, 2020 at 11:35:04AM -0500, Daniel Jordan wrote:
> Hi Corentin,
> 
> On Mon, Feb 17, 2020 at 09:48:03PM +0100, Corentin Labbe wrote:
> > When running some CI test jobs (targeting crypto tests), I always get the following WARNING:
> 
> Can you be more specific about which test triggers this?  I used the config
> option you mention and failed to reproduce after doing the boot-time crypto
> tests and running various tcrypt incantations.
> 

Hello

It appears before any user space start. But according to the "Modules linked", probably ghash is already loaded and perhaps tested.

Removing GHASH lead to:
[    7.920931] ------------[ cut here ]------------
[    7.920955] WARNING: CPU: 1 PID: 120 at kernel/workqueue.c:1469 __queue_work+0x370/0x388
[    7.920960] Modules linked in: ccm

And removing CCM lead to
[    7.798877] ------------[ cut here ]------------
[    7.798902] WARNING: CPU: 2 PID: 127 at kernel/workqueue.c:1469 __queue_work+0x370/0x388
[    7.798907] Modules linked in: ctr

So it confirm that the problem is not related to the tested crypto algorithm.

> > [    7.886361] ------------[ cut here ]------------
> > [    7.886388] WARNING: CPU: 2 PID: 147 at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
> > [    7.886394] Modules linked in: ghash_generic
> > [    7.886409] CPU: 2 PID: 147 Comm: modprobe Not tainted 5.6.0-rc1-next-20200214-00068-g166c9264f0b1-dirty #545
> 
> I was using just plain next-20200214.  Can't find 166c9264f0b1, what tag/branch
> were you using exactly?
> 

The pasted example has some commit to try to debug it.
But I got the same with plain next (like yesterday 5.6.0-rc2-next-20200219 and tomorow 5.6.0-rc2-next-20200220) and master got the same issue.

But for reproductability on different hardware, I agree it is difficult.
For the moment, I got it only on Allwinner H5, A64, H6 SoCs and imx8q.
[    6.611449] ------------[ cut here ]------------
[    6.613234] WARNING: CPU: 1 PID: 157 at /srv/data/clabbe/linux-next/kernel/workqueue.c:1471 __queue_work+0x324/0x3b0
[    6.623809] Modules linked in: ghash_generic
[    6.628101] CPU: 1 PID: 157 Comm: modprobe Not tainted 5.6.0-rc2-next-20200220 #82
[    6.635710] Hardware name: NXP i.MX8MNano DDR4 EVK board (DT)

I tried amlogic boards and some qemu "virt" without success.

(I have added linux-crypto@vger.kernel.org to the CC)
