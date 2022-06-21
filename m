Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA987C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jun 2022 13:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349972AbiFUNiv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jun 2022 09:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351841AbiFUNig (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jun 2022 09:38:36 -0400
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E13AF26;
        Tue, 21 Jun 2022 06:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-ID:Content-Description;
        bh=DC4ZEyWBHqB8Ee7U3iV5pXPcACu5mfk1YFIKPVvFHL0=; b=lbBCVFbO79ungOcgVG+jyWLNrM
        /KOz1ugytuFjXsCl890ONimeyORTPAQUXBUIjHvM+X177APV2JZaL57SPVVwzPSV8sYu/AsVywSKx
        h36eglYOvSj+A+72OyE4ORJArfNcTeceSS97vUxpu/hOTBsGgoL55w72ktvIfHGZrT4dKQ31b7fQ5
        eb0emxr7GEA9U44eUsGxzEnodv9kPHcIZ8MhCDVSrbtmt/aIPrOZRX+JhIQft+ft7W8B6DM8VsVHV
        vDKEyyI75GWBzNoaDTKDO6QXfcmFEoHFXk8mJXlKwmD+q0fSf//m8h5rohnn4eLPq+fGEWexxN66h
        R+RDMOZg==;
Received: from [81.174.171.191] (helo=donbot)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john@metanate.com>)
        id 1o3e4X-00032a-3U; Tue, 21 Jun 2022 14:37:37 +0100
Date:   Tue, 21 Jun 2022 14:37:35 +0100
From:   John Keeping <john@metanate.com>
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v7 14/33] crypto: rockchip: handle reset also in PM
Message-ID: <YrHJn6Pl5B/1pj9L@donbot>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
 <20220508185957.3629088-15-clabbe@baylibre.com>
 <YrBUODGF51oUsF1f@donbot>
 <YrF74tmA9qc+I3JF@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YrF74tmA9qc+I3JF@Red>
X-Authenticated: YES
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 21, 2022 at 10:05:54AM +0200, LABBE Corentin wrote:
> Le Mon, Jun 20, 2022 at 12:04:24PM +0100, John Keeping a écrit :
> > On Sun, May 08, 2022 at 06:59:38PM +0000, Corentin Labbe wrote:
> > > reset could be handled by PM functions.
> > 
> > Is there any further rationale for this?
> > 
> > After this change there is no longer a guaranteed reset pulse on probe
> > since the reset control may already be de-asserted.  This is normally
> > the most important case for a reset as it's the only time when the state
> > of the hardware is unknown.
> > 
> > The original use of devm_add_action_or_reset() seems a bit weird already
> > since there doesn't seem to be any need to assert reset when the driver
> > is unloaded.
> > 
> 
> I am not an hw engineer, so my knowledge on reset is low.
> So why not having a reset pulse on probe is a problem ?

The point of the reset is to bring the hardware back to a known state.
Since we don't know what state the hardware will be in following the
bootloader or previous OS, I think the reset in probe is the only place
that it is important.

If this patch isn't fixing anything, I suggest just dropping it.
