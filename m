From: "cloudy.linux" <cloudy.linux@gmail.com>
Subject: Re: RFC: support for MV_CESA with TDMA
Date: Sun, 27 May 2012 22:03:07 +0800
Message-ID: <4FC2341B.8080806@gmail.com>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60848 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2E0ODQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 27 May 2012 10:03:16 -0400
Received: by pbbrp8 with SMTP id rp8so3617018pbb.19
        for <linux-crypto@vger.kernel.org>; Sun, 27 May 2012 07:03:16 -0700 (PDT)
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2012-5-26 0:08, Phil Sutter wrote:
> Hi,
>
> The following patch series adds support for the TDMA engine built into
> Marvell's Kirkwood-based SoCs, and enhances mv_cesa.c in order to use it
> for speeding up crypto operations. Kirkwood hardware contains a security
> accelerator, which can control DMA as well as crypto engines. It allows
> for operation with minimal software intervenience, which the following
> patches implement: using a chain of DMA descriptors, data input,
> configuration, engine startup and data output repeat fully automatically
> until the whole input data has been handled.
>
> The point for this being RFC is backwards-compatibility: earlier
> hardware (Orion) ships a (slightly) different DMA engine (IDMA) along
> with the same crypto engine, so in fact mv_cesa.c is in use on these
> platforms, too. But since I don't possess hardware of this kind, I am
> not able to make this code IDMA-compatible. Also, due to the quite
> massive reorganisation of code flow, I don't really see how to make TDMA
> support optional in mv_cesa.c.
>
> Greetings, Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Could the source code from the manufacturers of hardwares using kirkwood 
be helpful?
I saw the source code of ls-wvl from buffalo contains driver for CESA. 
And it deals with both IDMA and TDMA. If you need, I can send you the 
download link.

I also have to point out that CESA of some orion revisions has hardware 
flaws that needs to be addressed which currently doesn't. Information 
about those flaws can be found in 88F5182_Functional_Errata.pdf which is 
available on the net.
