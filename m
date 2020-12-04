Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E234C4361A
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 19:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CE5922CA0
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 19:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgLDT2k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Dec 2020 14:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgLDT2k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Dec 2020 14:28:40 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871C2C0613D1;
        Fri,  4 Dec 2020 11:27:59 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id d3so6381890wmb.4;
        Fri, 04 Dec 2020 11:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QneMMLNVLuUzcGkoHYxID8fhKLN3YdsUe/2Yohs8dUA=;
        b=IV0SFSjzZyjcw8L/C243h3FfryF5mYThxgy0t19g4KvSjCm//T09eKYiG6grBZJ7Zd
         KV8xrQuK9UnwZq2GoegFmW9e44+1S6wpETiQ2DqQqUeI+P5v/Vza1bkMzbtlsSXFPY6c
         roNHDQawUTn2DwQUDxDiqwpT62fVxNr9IIQaRQ6Ipxdfdy9vZ8DKOot/5Nl/e+oJRZu1
         sbpN0zKvpp+q22X//lSOuMr/g4Ju9kTlNbweZpl2/sM0HfLILyVNRbcyLE2kTd/TTXs7
         2e+8bf0xjv6yRCSjMOBAKFEBThecf+DBadLHbpvyN2DBslOlJXj6qwPOrehBM5hNyVvH
         /ubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QneMMLNVLuUzcGkoHYxID8fhKLN3YdsUe/2Yohs8dUA=;
        b=s6VRTIH48BHd+AkLpoXcmvPlVAeolU84lGOb+dWOHQiiVskEcWfTYexX+oV5C/wuzq
         DwxzyK09EX2r9vvuRAdEpdyEAuT16e52T5RdqpTDR9HmyvxhaGEdYKzREwwkvOpLLL7l
         2thyIFUAmUmufnV4TXqvCOK4UGKB+Ra6GuYk3yB32tZh6YLc/N1GxKl1yKU8y9b8u8Jv
         W/U1t+VkFgeR/lMgL+NgCZWY/Y71j15MuS4eC6F5dyZOfDa/kV6xMPLfoIu4LRA92l5W
         /KKNHI6osy3JIr1XZwhjTIX1zRk0tsOdagMLO2c5yygffny7a1sBn7VdMGdGDiFL/pP8
         5Jwg==
X-Gm-Message-State: AOAM530/4H0nzpjt+bjB6NeIx+3hAFbj35kLX0OaWuYtC3zraDFQ2PgH
        s7Dopf8+xxyxAegVvtUpL88=
X-Google-Smtp-Source: ABdhPJxH6CkUQbBtK+3V1EOllEwwZYEcW4D35sQNZakdnvqRKYoYX7+6zkRJDMEmNrvu5YtiowwUcw==
X-Received: by 2002:a7b:cd91:: with SMTP id y17mr5697971wmj.171.1607110077076;
        Fri, 04 Dec 2020 11:27:57 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id k16sm4684560wrl.65.2020.12.04.11.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 11:27:56 -0800 (PST)
Date:   Fri, 4 Dec 2020 20:27:53 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, Andrew Morton <akpm@linuxfoundation.org>
Subject: Re: crypto: sun4i-ss: error with kmap
Message-ID: <20201204192753.GA19782@Red>
References: <20201201135252.GA9584@Red>
 <87y2ihfw6z.fsf@nanos.tec.linutronix.de>
 <20201201144529.GA6786@Red>
 <87v9dlfthf.fsf@nanos.tec.linutronix.de>
 <20201202195501.GA29296@Red>
 <877dpzexfr.fsf@nanos.tec.linutronix.de>
 <20201203173846.GA16207@Red>
 <87r1o6bh1u.fsf@nanos.tec.linutronix.de>
 <20201204132631.GA25321@Red>
 <874kl1bod0.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kl1bod0.fsf@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 04, 2020 at 04:08:27PM +0100, Thomas Gleixner wrote:
> On Fri, Dec 04 2020 at 14:26, Corentin Labbe wrote:
> > On Fri, Dec 04, 2020 at 12:34:05AM +0100, Thomas Gleixner wrote:
> >> The unmap comes from sg_miter_stop() and looking at the previous
> >> map/unmap cycles there are never nested maps.
> >> 
> >> [  996.943030] cryptset-316       0d..4 73943317us : __kmap_local_pfn_prot: kmap_local_pfn: 1 ffefd000
> >> 
> >> is the first event which allocates a nested map. 
> >> 
> >> So something goes south either in sg_miter or in the crypto maze.
> >> 
> >> Enabling CONFIG_DEBUG_KMAP_LOCAL and function tracing might give us more clue.
> >
> > Done, http://kernel.montjoie.ovh/130466.log
> 
> Does not provide more information with the debug enabled. So can you
> please enable CONFIG_FUNCTION_TRACER and add 'ftrace=function' to the
> command line?
> 

Done, http://kernel.montjoie.ovh/130490.log
