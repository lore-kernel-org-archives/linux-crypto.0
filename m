Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6652C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 11:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A662320707
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 11:52:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fl4slJKu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgHZLwe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 07:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgHZLwN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 07:52:13 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89176C061574
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2020 04:52:12 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x5so1463633wmi.2
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2020 04:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pv1UwrcfHZa0qjph5LSIk0g8XgKzUh94wpAXHeKDylU=;
        b=Fl4slJKuET8CzoZ+aMD2Lw6sOO+PrVFE5RoTrtGJ+Gp/Yt0KvcHe/S33TptLfVFX7v
         0xlPFDyq2SPd5XXMNGuYlYL8jTVL3jvsFZESKFg2ZJ2/E4eStHLrdE90aOXOlFuUwRo3
         KIaYvfGqYHrAm07oAw43uqI0tYKSDELBqbIPbH9F5o6TLxIv18HForaCXXm3PiuDXTV5
         JP+OMTZ1MzAm/VV3oRLvBm+sZFYBrgyUGxC8V4xmmmOCpHUiOLFNZ4gpKjXKbDFj7o0c
         d2YI4hDLZzmLShKN2dyZ8LgcVgiZRprknYp6Gy7s4nFVvE5DJHnknbpcmIeI7r0BvEaB
         sC6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pv1UwrcfHZa0qjph5LSIk0g8XgKzUh94wpAXHeKDylU=;
        b=cysF2KIAn1QRqG/+JuOW4u4OBkbUrQO6/lG26c27q/nlu0uhruWs8yGtP7KhaUO/dN
         PuZwhsCqFzEP6l2t/HcO13bWb/9i1KarKLrAfh1LJYWEcUv/4/Df2QCW/rBGHHgMv8sS
         MXWIWAjRgGOGyRdylHVILs221FNpU0ynxODN5O/ABfeGtEckc2BJV50kk55i1XORFk1F
         6yOwbg8fljgJo4TvN4y9rvF+BWl4GL9eeAsCkBS2j2+oKQdQT2HITlGigFPV2O1CDM0w
         SzcMjNgb3Mnzy0FmBRzbtce3cJ1OopxCm8i8Nb4nlsS0II/XoT6qAX/+fP0iUJRRxawe
         o0Sg==
X-Gm-Message-State: AOAM531goyIRhYwGllbgOQVr3M8JCC6glCFXHynzmoZVrXMt8DaUpBDj
        2GwRREyjfG5b/eulDUWdFzc=
X-Google-Smtp-Source: ABdhPJx3BCxpq5hCIIIwvQ0uWV5EFBefAhPIO/gGlYq7D9ERqs1Sy+S7CgKXEsdRVDjXg7b+yVDQ/g==
X-Received: by 2002:a1c:e006:: with SMTP id x6mr7178397wmg.128.1598442731250;
        Wed, 26 Aug 2020 04:52:11 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id u17sm6329729wrp.81.2020.08.26.04.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 04:52:10 -0700 (PDT)
Date:   Wed, 26 Aug 2020 13:52:09 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Martin Cerveny <M.Cerveny@computer.org>
Cc:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: PROBLEM: SHA1 on Allwinner V3s failed
Message-ID: <20200826115209.GA830@Red>
References: <alpine.GSO.2.00.2008260919550.23953@dmz.c-home.cz>
 <20200826090738.GA6772@Red>
 <alpine.GSO.2.00.2008261256100.29556@dmz.c-home.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.GSO.2.00.2008261256100.29556@dmz.c-home.cz>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 26, 2020 at 01:33:20PM +0200, Martin Cerveny wrote:
> Hello.
> 
> On Wed, 26 Aug 2020, Corentin Labbe wrote:
> > On Wed, Aug 26, 2020 at 09:52:30AM +0200, Martin Cerveny wrote:
> >> Hello.
> >>
> >> [1.] One line summary of the problem:
> >>
> >> SHA1 on Allwinner V3s failed
> >>
> > Since only SHA1 is failling, could you try to use the "allwinner,sun8i-a33-crypto", just in case V3s has the same SHA1 HW quirck than A33.
> 
> Yes. This do the trick. All startup verification passes now.
> Performance (SHA1 with sha1-sun4i-ss) "tcrypt mode=303 sec=1" test output attached.
> So, all seems to be working now. Released new patch with possibility to merge.
> 
> https://github.com/mcerveny/linux/commit/e3c76436de3d8cd2b2ddaeadef879a4a4d723bf4
> 
> Regards, Martin

For proper solution, a new compatible "allwinner,sun8i-v3s-crypto" should be added instead.
Furthermore it should be added in sun4i-ss-core.s along with a new variant for v3s with .sha1_in_be = True.

The new compatible should also be added in Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml

Regards
