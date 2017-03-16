From: Scott Wood <oss@buserror.net>
Subject: Re: [RFC 4/7] soc/qman: add helper functions needed by caam/qi
 driver
Date: Thu, 16 Mar 2017 15:39:23 -0500
Message-ID: <1489696763.2944.42.camel@buserror.net>
References: <1488552733-20806-1-git-send-email-horia.geanta@nxp.com>
         <1488552733-20806-5-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dan Douglass <dan.douglass@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>,
        Vakul Garg <vakul@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
To: Horia =?UTF-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Roy Pledge <roy.pledge@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from host.buserror.net ([209.198.135.123]:51925 "EHLO
        host.buserror.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752122AbdCPUjc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 16:39:32 -0400
In-Reply-To: <1488552733-20806-5-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2017-03-03 at 16:52 +0200, Horia Geantă wrote:
> Add helper functions, macros, #defines for accessing / enabling
> qman functionality from caam/qi driver, such that this driver
> is not aware of the need for data conversion to big endian.

Why?  I complained about that (probably internally) when this driver was
originally submitted.

Having a bunch of accessors in a header file that just do an assignment with
an endian conversion just obfuscates things.  The driver still needs to know
that the conversion needs to happen, or else it wouldn't know that the fields
can't be accessed directly... and it gets particularly ridiculous when a
single field has a growing pile of accessors depending on exactly what flags
you want to set (e.g. qm_sg_entry_set_*).  Just open-code it unless an
accessor is justified by the call sites getting unwieldy or numerous.

It looks like GCC 6 has added an attribute (scalar_storage_order) that could
be used on structs to avoid having to manually swap such things.  I look
forward to the day when GCC 6 is old enough for the kernel to depend on this.

-Scott
