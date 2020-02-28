Return-Path: <SRS0=oD/a=4Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5A5C3F2D2
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 17:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5F55246AC
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 17:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582911355;
	bh=VKhozoDerPi8gC4TBNvSd+KP8dQLu3JJCi2pZhPZpoI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=ZOXdwixh87yis+Gb/VmsWL8xNvVAmSKmW1U8eSbZp5GyXW5mQPerqLjFJDZFoBYog
	 XzLNWiiKBv5VMOxVpfjwyb8aQTnNfWC3qKjy+pDAtCrK6b23ixVBp0xflvMDK94ccJ
	 wsXI3+FUsfz7MXVtFO0GD1+/43GV0adQxOS5rW+o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgB1Rfz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Feb 2020 12:35:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgB1Rfy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Feb 2020 12:35:54 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BD512051A;
        Fri, 28 Feb 2020 17:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582911354;
        bh=VKhozoDerPi8gC4TBNvSd+KP8dQLu3JJCi2pZhPZpoI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CtX6NHqGoWLf8H/hN0qy3HV3OSTq4MlkeiMi0d98W2EYtv5RCxma+mb+ePaWSiaAa
         KBtPs973mpzxuEvGpfzGD/uZ73FOneRL0Uq6GLb8DY93TOVvoFmyIkOqRxDYa1N2tY
         vYN7NKPJZMWyWfONKaIz0+SBMP6wv/1VXBL99rwc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j7jYG-008obq-Hk; Fri, 28 Feb 2020 17:35:52 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 28 Feb 2020 17:35:52 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 13/18] arm64: kvm: Annotate assembly using modern
 annoations
In-Reply-To: <20200218195842.34156-14-broonie@kernel.org>
References: <20200218195842.34156-1-broonie@kernel.org>
 <20200218195842.34156-14-broonie@kernel.org>
Message-ID: <af4e6c640321dfa9e320ad1079aad603@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: broonie@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-crypto@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-02-18 19:58, Mark Brown wrote:
> In an effort to clarify and simplify the annotation of assembly 
> functions
> in the kernel new macros have been introduced. These replace ENTRY and
> ENDPROC with separate annotations for standard C callable functions,
> data and code with different calling conventions.  Update the more
> straightforward annotations in the kvm code to the new macros.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/hyp-init.S      |  8 ++++----
>  arch/arm64/kvm/hyp.S           |  4 ++--
>  arch/arm64/kvm/hyp/fpsimd.S    |  8 ++++----
>  arch/arm64/kvm/hyp/hyp-entry.S | 15 ++++++++-------
>  4 files changed, 18 insertions(+), 17 deletions(-)

For the three KVM/arm patches:

Acked-by: Marc Zyngier <maz@kernel.org>

I'd expect this to go as a whole via the arm64 tree, but I can also
cherry-pick them if necessary.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
