Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB06C4361B
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Dec 2020 21:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE4F423101
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Dec 2020 21:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgLFVlp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Dec 2020 16:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgLFVlo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Dec 2020 16:41:44 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56732C0613D0;
        Sun,  6 Dec 2020 13:40:58 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 3so11878440wmg.4;
        Sun, 06 Dec 2020 13:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/BxSizpOargIZyac2nTAqdpMqu9JUHGGbqbw7p9cqXY=;
        b=GzCcTnP1hykHHnk8kieyiyxzTx6xoXN6w89uNNv3N/J1qe9T2XHMBpdfcT1Bpc+IGk
         EaaJDdlJHbvpCu2nUPwk6beSSXutJJxeoUnHHEKj/WpIDx0DvdyJh/Tmr3REV/dcDl8F
         OgBVfyso+hW5mt9i/WdzTxUOAvC9QavNiaLgpjkgxzUS6nXKSQ95ftcz+BMzAjwZ9Wd2
         eWdSCp7UT95HKHkWBEzbgFC7hSKYJiJ4bMgiwg/erq8kMbhh7yvk0xkAqJ6oJnKqaQ+b
         871rtSreI4ZfDCp/A9FyIMsDMkv965L6cx/FDnFEhDhwMa0fKQ/AJHYhuLxZM9BKCfqx
         BE4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/BxSizpOargIZyac2nTAqdpMqu9JUHGGbqbw7p9cqXY=;
        b=VNU8WDfcQzTVAyekvp6LR/43UnEx37F/yxHCW5TmrDDCFuB2LbJm1ITqm5GHRCPZwk
         Iy+sDvnUdl4/3oBe+lxULTFEHiuS31L8veytM8We3aVniZGGPYicQYtkNSNOIKb8Nw6M
         Nl0b970GtoMi8cYM25ApVfXrTMlQxfr1RmrOpDACd0lnT5PJsXzJd+lSxikI4alpDeZk
         JgzcMvohArbysdXBr8pG0UN+lE+5AOr8muNdvNkFx8bmAadgaAQGwbX/YzRcdE8K5Bys
         Noq/KOuuvDnRpvdq3Ik6oxXtJdPPLeBwa3bCr7f+Wbsm/SE9Qwl4qD65aVSDC5heav4D
         26/A==
X-Gm-Message-State: AOAM5337V8tLRL3xTsnppW5uA03nLc5vBPiv9b9cSJThGNYQclJE+ck/
        Q3DKuu2goduB/vU5wRm0wt+3/ikAoDY=
X-Google-Smtp-Source: ABdhPJzZKEbCkaETVTQleZ8rPJgbqrJ0gj7vBfgsr/S/ShhK2oE1HYMAySEm5l9TOEN0AbgN/GLHXA==
X-Received: by 2002:a1c:b78a:: with SMTP id h132mr15145028wmf.141.1607290857074;
        Sun, 06 Dec 2020 13:40:57 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id y68sm10912421wmc.0.2020.12.06.13.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 13:40:56 -0800 (PST)
Date:   Sun, 6 Dec 2020 22:40:53 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, Andrew Morton <akpm@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: crypto: sun4i-ss: error with kmap
Message-ID: <20201206214053.GA8458@Red>
References: <20201202195501.GA29296@Red>
 <877dpzexfr.fsf@nanos.tec.linutronix.de>
 <20201203173846.GA16207@Red>
 <87r1o6bh1u.fsf@nanos.tec.linutronix.de>
 <20201204132631.GA25321@Red>
 <874kl1bod0.fsf@nanos.tec.linutronix.de>
 <20201204192753.GA19782@Red>
 <87wnxx9tle.fsf@nanos.tec.linutronix.de>
 <20201205184334.GA8034@Red>
 <87mtys8268.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtys8268.fsf@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Dec 05, 2020 at 08:48:15PM +0100, Thomas Gleixner wrote:
> Corentin,
> 
> On Sat, Dec 05 2020 at 19:43, Corentin Labbe wrote:
> > On Fri, Dec 04, 2020 at 09:58:21PM +0100, Thomas Gleixner wrote:
> >> Can you please replace the debug patch with the one below and try again?
> >> That stops the trace right on the condition.
> >
> > Hello, the result could be found at http://kernel.montjoie.ovh/130739.log
> 
> Thanks for providing this. This is clearly showing where stuff goes
> wrong. It starts here at 729.550001. I removed the uninteresting parts:
> 
> 0d..2 147103293us : __kmap_local_page_prot <-sg_miter_next
> 0d..3 147103308us :__kmap_local_pfn_prot: kmap_local_pfn: 1 ffefd000
> 
> 0d..3 147103311us : __kmap_local_page_prot <-sg_miter_next
> 0d..4 147103325us : __kmap_local_pfn_prot: kmap_local_pfn: 3 ffefb000
> 
> 0d..3 147103429us : kunmap_local_indexed <-sg_miter_stop
> 0d..4 147103433us : kunmap_local_indexed: kunmap_local: 3 ffefd000
> 
> So this maps two pages and unmaps the first one. That's all called from
> sun4i_ss_opti_poll() and the bug is clearly visible there:
> 
> 	sg_miter_next(&mi);
> 	sg_miter_next(&mo);
> 
> release_ss:
> 	sg_miter_stop(&mi);
> 	sg_miter_stop(&mo);
> 
> Written by yourself :) Same issue in sun4i_ss_cipher_poll()
> 
> Fix below.
> 

Unfortunatly, the crash still happen with the fix.
See http://kernel.montjoie.ovh/131321.log
