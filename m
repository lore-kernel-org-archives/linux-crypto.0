From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] crypto: vmx - rebuild generated asm when target changes
Date: Mon, 28 Nov 2016 19:48:22 +1100
Message-ID: <20161128194822.08e42907@roar.ozlabs.ibm.com>
References: <20161126042459.1964-1-npiggin@gmail.com>
        <20161128082136.GD29256@naverao1-tp.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "Leonidas S . Barbosa" <leosilva@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34451 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754142AbcK1Ise (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 03:48:34 -0500
Received: by mail-pf0-f196.google.com with SMTP id y68so6118607pfb.1
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2016 00:48:34 -0800 (PST)
In-Reply-To: <20161128082136.GD29256@naverao1-tp.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 28 Nov 2016 13:51:36 +0530
"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> wrote:

> On 2016/11/26 03:24PM, Nicholas Piggin wrote:
> > Switching from big endian to little endian can fail to regenerate
> > the crypto assembly properly. Switch to using standard form of
> > kbuild dependency checking (i.e., use FORCE and if_changed).
> > 
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>  
> 
> Hi Nick,
> A similar patch is already in:
> https://mid.mail-archive.com/linux-crypto@vger.kernel.org/msg21855.html
> 
> - Naveen
> 

Hi Naveen,

I didn't notice your patch, thanks for pointing it out.

Thanks,
Nick
