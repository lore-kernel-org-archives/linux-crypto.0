From: Stephan Mueller <smueller@chronox.de>
Subject: Re: scatterwalk.c: Nullpointer dereference
Date: Mon, 14 Aug 2017 14:37:32 +0200
Message-ID: <2773822.4WQlVsijTS@tauon.chronox.de>
References: <1415BA6E-28BB-4AA6-8049-1FB19FE3BBE1@hpi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Plauth, Max" <Max.Plauth@hpi.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58798 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753143AbdHNMhf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 08:37:35 -0400
In-Reply-To: <1415BA6E-28BB-4AA6-8049-1FB19FE3BBE1@hpi.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 14. August 2017, 14:25:49 CEST schrieb Plauth, Max:

Hi Max,

> Dear linux-crypto community,
> 
> I think I might have run into a bug in crypto/scatterwalk.c:
> - at the end of scatterwalk_pagedone, sg_next(walk->sg) is fed as an
> argument to scatterwalk_start(...) - sg_next (lib/scatterlist.c) returns
> NULL in the case of sg_is_last(sg) - In this case, NULL is being fed into
> scatterwalk_start
> - there, a NULL value of *sg leads to a NULL pointer dereference:
> walk->sg = sg;
> walk->offset = sg->offset;
> 
> I stumbled across this issue when I tried to extend the cryptodev-linux
> Kernel module with support for compression algorithms
> (https://github.com/plauth/cryptodev-linux).

You are quite right that this looks like a nullpointer. But you should never 
run into this problem because the scatterwalk length definition should ensure 
that this never happens. I.e. the scatterwalk length should not be longer than 
the underlying SGL.

Thus, the bug you report is rather a bug in the scatterlist / scatterwalk 
length definition.

Ciao
Stephan
