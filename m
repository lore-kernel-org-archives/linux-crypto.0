Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D210FC7618A
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 06:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0AA220838
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 06:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfGOG0a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 02:26:30 -0400
Received: from smtp3.goneo.de ([85.220.129.37]:38280 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfGOG0a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 02:26:30 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2019 02:26:28 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id C2C2623F2CD;
        Mon, 15 Jul 2019 08:17:00 +0200 (CEST)
X-Virus-Scanned: by goneo
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9DTgEevx57Ss; Mon, 15 Jul 2019 08:16:59 +0200 (CEST)
Received: from [192.168.1.127] (dyndsl-091-248-140-021.ewe-ip-backbone.de [91.248.140.21])
        by smtp3.goneo.de (Postfix) with ESMTPSA id 7016023F001;
        Mon, 15 Jul 2019 08:16:54 +0200 (CEST)
Subject: Re: [PATCH 8/8] docs: remove extra conf.py files
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-sh@vger.kernel.org, alsa-devel@alsa-project.org
References: <cover.1563115732.git.mchehab+samsung@kernel.org>
 <12a160afc9e70156f671010bd4ccff9311acdc5e.1563115732.git.mchehab+samsung@kernel.org>
From:   Markus Heiser <markus.heiser@darmarit.de>
Message-ID: <e3ff0a8a-6956-3855-07be-9c126df2da2d@darmarit.de>
Date:   Mon, 15 Jul 2019 08:16:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <12a160afc9e70156f671010bd4ccff9311acdc5e.1563115732.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Mauro,

sorry, I havn't tested your patch, but one question ...

Am 14.07.19 um 17:10 schrieb Mauro Carvalho Chehab:
> Now that the latex_documents are handled automatically, we can
> remove those extra conf.py files.

We need these conf.py also for compiling books' into HTML.  For this
the tags.add("subproject") is needed.  Should we realy drop this feature?

-- Markus --
