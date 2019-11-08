Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B146C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 11:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0518821D6C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 11:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573213035;
	bh=G5j+RwShAgrettv3VQJ2Hzibs0yOoFaJu63CqOxn8Oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uVMwxzP5L345qQjr/Kqns2D7wzsdqs67k4v7LF7Tx/AG3Wz0xmOnIwEP+AwFsogHa
	 3mgfTR/QQ3QFHiihJvK9htfQZedN1Cs3SNeAD6O6RnFczDNrtxGSZnovXNgjjt/ced
	 6C03WfwYXs8D7FNvl5PNcYIRMtXnjcuAOpVMsB+Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbfKHLhJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:37:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfKHLhJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 06:37:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C480320869;
        Fri,  8 Nov 2019 11:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213028;
        bh=G5j+RwShAgrettv3VQJ2Hzibs0yOoFaJu63CqOxn8Oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iWFuYTQcqXM/DR65wCIopKLQsBH2V3ve8n4fUHcE6O0QCwEWq5LcBR7HT3UYbVuXy
         LLH+DzR/qTOHmtgWKoaaTL5pocOV+6Wehrg/cMS5rr/2mDYoYQbR8bXug4dIKrlFDH
         izPZgMynJUZ3fTgx+ygLAuT+nnb+N95WoPMCQjcs=
Date:   Fri, 8 Nov 2019 12:37:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David@rox.of.borg, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Casey Leedom <leedom@chelsio.com>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Kevin Hilman <khilman@kernel.org>, Nishanth Menon <nm@ti.com>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] power: avs: smartreflex: Remove superfluous cast in
 debugfs_create_file() call
Message-ID: <20191108113705.GA721212@kroah.com>
References: <20191021145149.31657-1-geert+renesas@glider.be>
 <20191021145149.31657-5-geert+renesas@glider.be>
 <4367615.jSCgeRn5tF@kreacher>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4367615.jSCgeRn5tF@kreacher>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 08, 2019 at 12:24:42PM +0100, Rafael J. Wysocki wrote:
> On Monday, October 21, 2019 4:51:48 PM CET Geert Uytterhoeven wrote:
> > There is no need to cast a typed pointer to a void pointer when calling
> > a function that accepts the latter.  Remove it, as the cast prevents
> > further compiler checks.
> > 
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Greg, have you taken this one by any chance?

Nope, it's all yours!  :)

