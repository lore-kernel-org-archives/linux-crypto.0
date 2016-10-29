From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v2] crypto: mxs-dcp - Remove hash support
Date: Sat, 29 Oct 2016 13:25:29 -0200
Message-ID: <CAOMZO5CwGk-1f0jhXf3f6H01GOGb-Vjc17DZhUJ73Sq=77eA4A@mail.gmail.com>
References: <1477327394-2976-1-git-send-email-festevam@gmail.com>
 <423fc7f0-fcab-eee6-6e7b-9ba2261fd0b3@denx.de> <CAOMZO5DEdQzttFqB2rQjW_TtUU+Y29pe7rgGzhyQuZu2jcBEKA@mail.gmail.com>
 <AMSPR04MB083958F93F3E945D0B57D6EE98AD0@AMSPR04MB0839.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Marek Vasut <marex@denx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "gianfranco.costamagna@abinsula.com"
        <gianfranco.costamagna@abinsula.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>
To: Horia Geanta Neag <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:33411 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbcJ2PZd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 Oct 2016 11:25:33 -0400
Received: by mail-vk0-f67.google.com with SMTP id d65so935056vkg.0
        for <linux-crypto@vger.kernel.org>; Sat, 29 Oct 2016 08:25:33 -0700 (PDT)
In-Reply-To: <AMSPR04MB083958F93F3E945D0B57D6EE98AD0@AMSPR04MB0839.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Horia,

On Fri, Oct 28, 2016 at 5:55 PM, Horia Geanta Neag <horia.geanta@nxp.com> wrote:

> Looking on the i.MX6 Solo Lite security manual, the fix seems to consist
> in enabling context switching - i.e. setting
> DCP_CTRL[ENABLE_CONTEXT_SWITCHING] - and saving/restoring (part of) the
> context buffer.
>
> However, I am not familiar with DCP crypto engine and don't have HW to test.

I do have access to hardware to test. Could you please propose some
patches I can try?

My previous attempt to fix this issue was this one:
http://www.spinics.net/lists/linux-crypto/msg18039.html

Thanks,

Fabio Estevam
