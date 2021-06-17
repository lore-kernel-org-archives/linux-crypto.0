Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EBCC48BE5
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 00:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF36661241
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 00:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbhFQAlj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Jun 2021 20:41:39 -0400
Received: from gw.atmark-techno.com ([13.115.124.170]:36994 "EHLO
        gw.atmark-techno.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbhFQAlh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jun 2021 20:41:37 -0400
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 401BC80425
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jun 2021 09:39:29 +0900 (JST)
Received: by mail-pf1-f198.google.com with SMTP id b8-20020a056a000a88b02902e97a71383dso2627418pfl.13
        for <linux-crypto@vger.kernel.org>; Wed, 16 Jun 2021 17:39:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kzwC23yl7EiPEJTyDQAXknKKdn4AQMgQSpCxCXmT79o=;
        b=Tl3+KyMjzRWnrjM4krwiZ/sz2ACIPEFneQKMK+IsJBlIJyszjaDRfTtuCjWy0oYKC4
         euZSWqly1hBwcqkEGAe5Of27e+R4Ao7RzwZW4xh08Ic/kqWEexdaxBpHMc7E5lp33PC+
         ijFVN18E1eBBnFX+5SiUt/jeDqGs1jFuggAiSRQZN9tQlcdo9q3OvuXxeuZMyo+sxDSZ
         PXU2CfzeJw6ASZaKWkwYnLdJ83T5BLn/2W7vYIH/K0x0BHo02KQKdlOChj0Le9K/03eD
         fRqurortkEmizfY+mWGS4x9DOcCvsAfVqTlsBacxvBIyyW+XcRLFdBph76ZMYxf1GHo/
         SX4Q==
X-Gm-Message-State: AOAM531bn+lATOl9DuCyv8TGGR4Jyz6YT46cumI9vZqJOAiCBFs+WiUu
        NMjH8TP3VzivUkAU0O3ynxoT6V2LFTe+qOYkf9TgefE/3JaLf/fXhmsig5GQrAUMZBvmj5yW/Kg
        n9dKheyzrGDDsUVcqzFw63imKbbNg
X-Received: by 2002:a17:902:bb90:b029:11a:cf7c:997c with SMTP id m16-20020a170902bb90b029011acf7c997cmr2127484pls.80.1623890368374;
        Wed, 16 Jun 2021 17:39:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyS51UkDeEgbZVQN8Wk1n9noziQk43W9FAfw9kVNO3t3j63+6pTaR8t/Y11gTIfZgQLKda96A==
X-Received: by 2002:a17:902:bb90:b029:11a:cf7c:997c with SMTP id m16-20020a170902bb90b029011acf7c997cmr2127467pls.80.1623890368156;
        Wed, 16 Jun 2021 17:39:28 -0700 (PDT)
Received: from pc-0115 (35.112.198.104.bc.googleusercontent.com. [104.198.112.35])
        by smtp.gmail.com with ESMTPSA id mg22sm3149090pjb.26.2021.06.16.17.39.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jun 2021 17:39:27 -0700 (PDT)
Received: from martinet by pc-0115 with local (Exim 4.94.2)
        (envelope-from <martinet@pc-0115>)
        id 1ltg45-00FKxj-UT; Thu, 17 Jun 2021 09:39:25 +0900
Date:   Thu, 17 Jun 2021 09:39:15 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Hartmann <lukas@mntmn.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Marc Orr <marcorr@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Peter Gonda <pgonda@google.com>
Subject: Re: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb)
 stable/for-linus-5.12)
Message-ID: <YMqZswFnSNKk4Z7B@atmark-techno.com>
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local>
 <YL7XXNOnbaDgmTB9@atmark-techno.com>
 <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com>
 <20210611062153.GA30906@lst.de>
 <YMM8Ua0HMmErLIQg@0xbeefdead.lan>
 <CAMGD6P1v2JoJoxSuAYL8UjdtCaLCc4K_7xzVkumspeb0qn=LBQ@mail.gmail.com>
 <YMqW+/gQvM+uWUTw@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YMqW+/gQvM+uWUTw@fedora>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Konrad Rzeszutek Wilk wrote on Wed, Jun 16, 2021 at 08:27:39PM -0400:
> Thank you for testing that - and this is a bummer indeed.

Hm, actually not that surprising if it was working without the offset
adjustments and doing non-aligned mappings -- perhaps the nvme code just
needs to round the offsets down instead of expecting swiotlb to do it?

Note I didn't look at that part of the code at all, so I might be
stating the obvious in a way that's difficult to adjust...


> Dominique, Horia,
> 
> Are those crypto devices somehow easily available to test out the
> patches?

The one I have is included in the iMX8MP and iMX8MQ socs, the later is
included in the mnt reform and librem 5 and both have evaluation
toolkits but I wouldn't quite say they are easy to get...

I'm happy to test different patch variants if Horia doesn't beat me to
it though, it's not as practical as having the device but don't hesitate
to ask if I can run with extra debugs or something.

-- 
Dominique
