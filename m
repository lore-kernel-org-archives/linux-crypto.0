Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43DCC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 21:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B056115A
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 21:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbhIUWBJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Sep 2021 18:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235766AbhIUWBJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Sep 2021 18:01:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BA5961019;
        Tue, 21 Sep 2021 21:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632261579;
        bh=2pzwqy6lIqIzqKUOtcOetgKUkFn022GfsoxI/JVuA50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CNv6IJ+ItHvfpI9kKpFXRsKE44FdSPdiTYTJ//cZyeKrD64OgUgLFKypkwE+KPo08
         qDHA09VhX/Z76tOXl8C+1+QlwTdBTIpVyS7sPL3uOjYTmQF2Ukxp1rG9edwApOPKN8
         /dV1lSko4LSOAfqSlmTgRfQH2c6c2QLIp69UN9vSSQIv8j6/TO2kYFckN52YjtWZLd
         KI1+EETZscWQ0YZbvxVnRJOhdHmFbQiHmmfrFA+5SOkS7LgOdbmfjBBZQHhHHBhXLt
         z++MouszFcOPocs+oB08S1yAqzuFb4bbJO/O328GwDoPZHRluk1PZZk5USSFKBoTLz
         3XJzfTrdbXIjQ==
Date:   Tue, 21 Sep 2021 14:59:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
Cc:     linux-crypto@vger.kernel.org, Ash Logan <ash@heyquark.com>,
        Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.ne@posteo.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/4] crypto: nintendo-aes - add a new AES driver
Message-ID: <YUpVyTN7MQbMShdf@gmail.com>
References: <20210921213930.10366-1-linkmauve@linkmauve.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210921213930.10366-1-linkmauve@linkmauve.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 21, 2021 at 11:39:26PM +0200, Emmanuel Gil Peyrot wrote:
> This engine implements AES in CBC mode, using 128-bit keys only.  It is
> present on both the Wii and the Wii U, and is apparently identical in
> both consoles.
> 
> The hardware is capable of firing an interrupt when the operation is
> done, but this driver currently uses a busy loop, I’m not too sure
> whether it would be preferable to switch, nor how to achieve that.
> 
> It also supports a mode where no operation is done, and thus could be
> used as a DMA copy engine, but I don’t know how to expose that to the
> kernel or whether it would even be useful.
> 
> In my testing, on a Wii U, this driver reaches 80.7 MiB/s, while the
> aes-generic driver only reaches 30.9 MiB/s, so it is a quite welcome
> speedup.
> 
> This driver was written based on reversed documentation, see:
> https://wiibrew.org/wiki/Hardware/AES
> 
> Emmanuel Gil Peyrot (4):
>   crypto: nintendo-aes - add a new AES driver
>   dt-bindings: nintendo-aes: Document the Wii and Wii U AES support
>   powerpc: wii.dts: Expose the AES engine on this platform
>   powerpc: wii_defconfig: Enable AES by default

Does this pass the self-tests, including the fuzz tests which are enabled by
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?

- Eric
