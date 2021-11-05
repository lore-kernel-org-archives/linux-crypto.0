Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD16C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 14:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED8461186
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 14:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhKEOgP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Nov 2021 10:36:15 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:51865 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233230AbhKEOgP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Nov 2021 10:36:15 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id D3718580873;
        Fri,  5 Nov 2021 10:33:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 05 Nov 2021 10:33:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7vHGH5
        fsWp+AmiltcS8fSgzVtFKPV6KtppB0gEokIww=; b=ZtwKF4f/OZwYUAfoIxksjl
        eLsbDweOswOJhxqMcdKfCjt6sk0ObD3uMVNPUP7lRF/vwbmmhKs/Ddy5h2YtGITO
        uW+evRjVm7z6TkBwiZKzXb8GrRW8kJe0sQVuIgJwUpq6YrZw8MvQkkW3rThe+Vv6
        BEZvElSUfG61SmwPvtoND+ICMSA5Ac2VrrZgGkV7Du6cdlbbhdo92AdMnp6aw5zc
        u9xyQ4iTuHSAiC6UdCuzLsuZHr8Kgtbqx3vdiFRKEFNJMryF7LDYyxA93vpJwlLh
        Gdw3mDSEtxHUGdRMJvX63R5YxGpfmzxzLKGvFLF1yci26Xkd9sUbDvKlpXBNDWYA
        ==
X-ME-Sender: <xms:vUCFYfe1oqMLVxtZh4uEd42AnTNQVpgE5N3blhaqxS4fudOHsuVhrg>
    <xme:vUCFYVOAbRVtZf9ujPlJ8sM8igG0zuPyTOoCydW_Fpu99Pmq-TQ0EuPS_g81JT_NA
    D4rZVVqJ5eeP34>
X-ME-Received: <xmr:vUCFYYiNzr5m-2jGUAfKjOPsY91AaYrWYt9R0W571MhU-RraTA2zigTaC1A85ERs6PYQ8JOCDHAhQgK4mHnwxsZ6Xw6NfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrtdeigdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfejvefhvdegiedukeetudevgeeujeefffeffeetkeekueeuheejudeltdejuedu
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vUCFYQ_fXX9PkOHvculQRZ68o5e2JDJ54IYOpSUOWs1P4dMVgXrdjQ>
    <xmx:vUCFYbs3d3G7qUea5InpNwIrXV9I-d_zdc6BDs_V0FTBP87ZS8w7GQ>
    <xmx:vUCFYfFYH3ccf4rW94Gv8Z8HLS0ezT_nOByD9L6_66eaghTJSVak6Q>
    <xmx:vkCFYZLhdOKiPWfAFUYGC_pNzOVpkXJnO1cvfKB-qmhwqelA6_bZ9w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Nov 2021 10:33:32 -0400 (EDT)
Date:   Fri, 5 Nov 2021 16:33:29 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        kernel test robot <lkp@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: crypto: api - Fix boot-up crash when crypto manager is disabled
Message-ID: <YYVAuRaITKKvAhSp@shredder>
References: <YV0K+EbrAqDdw2vp@archlinux-ax161>
 <20211019132802.GA14233@gondor.apana.org.au>
 <alpine.DEB.2.22.394.2111021636040.2330984@ramsan.of.borg>
 <DM6PR04MB708155E447FD9A79AB89686DE78D9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <CAMuHMdW1wLAt9Y=-GMMuk8HWE3UnRgKNMmD9fq34Rq8J7QyrzQ@mail.gmail.com>
 <20211104121612.GA8044@gondor.apana.org.au>
 <CAMuHMdWAAWWS+TgeN1AajHBS5w9-datMEeXqAN8RjxRd9bX63Q@mail.gmail.com>
 <20211104133044.GA8563@gondor.apana.org.au>
 <YYP5ypSPOcP4WGCr@shredder>
 <20211105072608.GA13584@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105072608.GA13584@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 05, 2021 at 03:26:08PM +0800, Herbert Xu wrote:
> On Thu, Nov 04, 2021 at 05:18:34PM +0200, Ido Schimmel wrote:
> >
> > Attached my config. I can easily test patches.
> 
> Thanks!
> 
> Could you all try this patch please?
> 
> ---8<---
> When the crypto manager is disabled, we need to explicitly set
> the crypto algorithms' tested status so that they can be used.
> 
> Fixes: cad439fc040e ("crypto: api - Do not create test larvals if...")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks, Herbert!
