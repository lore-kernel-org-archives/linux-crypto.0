From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 0/3] crypto: sahara: Add support for SAHARA in i.MX27.
Date: Thu, 21 Feb 2013 13:47:23 -0300
Message-ID: <CAOMZO5BrNU0mr1snG1ftiFD-=FuWfu=1_Lgi5_Q+uBxJzz1CYA@mail.gmail.com>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
	<201302211259.26763.arnd@arndb.de>
	<CACKLOr1-EPK=DLz0SY+1E35qSMdtCsueuqdzV4VZdbkoM+TD6A@mail.gmail.com>
	<201302211440.59577.arnd@arndb.de>
	<20130221152310.GA1906@pengutronix.de>
	<CAOMZO5Cw4fKY_hjtZtvR1sKFY8GvQMVN2RcRCS99FVRerS-Acg@mail.gmail.com>
	<87ehg9k4cm.fsf@lebrac.rtp-net.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sascha Hauer <s.hauer@pengutronix.de>, gcembed@gmail.com,
	swarren@nvidia.com, herbert@gondor.apana.org.au,
	Arnd Bergmann <arnd@arndb.de>, tony@atomide.com,
	javier Martin <javier.martin@vista-silicon.com>,
	kernel@pengutronix.de, shawn.guo@linaro.org, davem@davemloft.net,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50412 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3BUQrY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 11:47:24 -0500
Received: by mail-wi0-f182.google.com with SMTP id hi18so7837697wib.9
        for <linux-crypto@vger.kernel.org>; Thu, 21 Feb 2013 08:47:23 -0800 (PST)
In-Reply-To: <87ehg9k4cm.fsf@lebrac.rtp-net.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 21, 2013 at 1:40 PM, Arnaud Patard
<arnaud.patard@rtp-net.org> wrote:

> How different are the variants ? I've a imx51 device with DT support so
> if someone running sahara on a system with DT is needed, I can be this
> person (as long as a way to test it is provided too).

mx27 has Saharav2, mx51 has Saharav4. I didn't check the differences
in detail though.

For mx51 the Sahara block is described in the document "MCIMX51
Applications Processor Security Reference Manual, Rev. 1"

I can also test the sahara dt support on a mx27pdk.
