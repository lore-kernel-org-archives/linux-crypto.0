Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3797DC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Apr 2022 08:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343899AbiDKIjf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Apr 2022 04:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiDKIjc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Apr 2022 04:39:32 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4BB3EA89
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 01:37:18 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l9-20020a05600c4f0900b0038ccd1b8642so8536347wmq.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 01:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GmeaL9LDzXt1lPoYGs5/whgdTpbkv+uMLJxNx67on5U=;
        b=En1vDoVLLQ4z3hVfItCZlMRphp0aoIeyvop6pZQ99iOwzMH5A3TI1Y0hkHiuygYWJO
         W0kkWHK1yWNXviBp/bUinRXdJewpQTwevUxvBoXbKbci5bLfrzQfE0FRRnN3v+YcgH79
         azH4p5jr19pAMhsZZXM1slPZnEaEdIpsPlDO8sl41Esei69Ni/UQ9cNerAE9MTf3gRg6
         5CI1AVaNcHO9c5yJnpMQoY56ZAV3QuPiKh6LReY7NWqHAmSkakaKr3yrl9gl/vlMx+0n
         tAm/3DlnYLBS9qcqN3/0fbY9mmpqJNujSthe5ex2K8OygUBOfFwgyoHBSQ1ZeH3lP7cB
         Q77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GmeaL9LDzXt1lPoYGs5/whgdTpbkv+uMLJxNx67on5U=;
        b=jVz53pzXajRvH6yXEV3oQ9XYMVgm64sCoO9rdx2oFKHBQ3k2M/iyJGOavwl9+UjYC6
         n3L6Kn6ZA3x9vS7pxxh24sBatZ5qIZFb7n2bcWvZDl3ig3ruj9dHhcCXTZ0m64raOcb4
         gB76atuucKP7cN77Sp/Xmv304pbS39dgnw6JX65P18vw2oVsPFa0JGJvHY1oY6wIROe4
         fNSSDDvpkbnxlYF8wFGYc1iaZYBIGsAI172+8jROMHhYMrVmt+iTqO+Iv81LJRKrR2K8
         JBTg5RXASi570GUHDbU/U7VydFUQDd7KYC5VPX/itS+ggv/NldweJmIM83Psvfg3PZ8n
         zVWQ==
X-Gm-Message-State: AOAM531r8+Vqtq3ubJ+joppdajd/MW+IBxXnGYNzupLZwP4ADseQutRN
        j5RRgk+/ffEaFSOaT+wDeyp75Q==
X-Google-Smtp-Source: ABdhPJxYx2mY9F3f959XsRTlxs/Nym64Waidy4p3tUy1+g4fDUkZw66J/o+5dxLZJ+oc0hIHE7/jqw==
X-Received: by 2002:a05:600c:682:b0:38e:b64f:f11d with SMTP id a2-20020a05600c068200b0038eb64ff11dmr7210510wmn.202.1649666232377;
        Mon, 11 Apr 2022 01:37:12 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id z5-20020a05600c0a0500b0037bb8df81a2sm19621474wmp.13.2022.04.11.01.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 01:37:11 -0700 (PDT)
Date:   Mon, 11 Apr 2022 10:37:10 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     jernej.skrabec@gmail.com, samuel@sholland.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 00/19] crypto: allwinner: lots of fixes
Message-ID: <YlPotuZilcnenky0@Red>
References: <20220317205605.3924836-1-clabbe@baylibre.com>
 <Yk/xNIjjINj9Hvki@gondor.apana.org.au>
 <YlPasmjElADX+7u5@Red>
 <YlPbbM7RurahUMn/@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YlPbbM7RurahUMn/@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Mon, Apr 11, 2022 at 03:40:28PM +0800, Herbert Xu a écrit :
> On Mon, Apr 11, 2022 at 09:37:22AM +0200, LABBE Corentin wrote:
> >
> > Coul you give me more details ?
> > I do not have any sparse error.
> 
> Did you compile with C=1? Anyway, for a start hash_pad is broken as
> it tries to store an le32 value into a u32.

Yes I compile with both W=1 and C=1.
But rigth, hash_pad takes a u32 but the origin variable bf is __le32, so perhaps it is why sparse dont see a problem.
Anyway I will fix hash_pad declaration.

Thanks
