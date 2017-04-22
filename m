From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] crypto: Allow ecb(cipher_null) in FIPS mode
Date: Sat, 22 Apr 2017 15:57:04 +0800
Message-ID: <CACXcFm=F=tPK+2oYrDVdQ+THpM+6LDGuEkTMuR8xNxA=cyTyuA@mail.gmail.com>
References: <20170421121820.GA14381@gondor.apana.org.au> <8205294.2qxUD6mCvD@tauon.chronox.de>
 <9105605.SAXsSHs1iB@tauon.chronox.de> <CACXcFm=HAew+fMAZXWL9WtT49GVdvUdVShnOOsDLEqUwU5cJng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>, linux-crypto@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36857 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752381AbdDVH5G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Apr 2017 03:57:06 -0400
Received: by mail-wm0-f45.google.com with SMTP id o81so29693733wmb.1
        for <linux-crypto@vger.kernel.org>; Sat, 22 Apr 2017 00:57:06 -0700 (PDT)
In-Reply-To: <CACXcFm=HAew+fMAZXWL9WtT49GVdvUdVShnOOsDLEqUwU5cJng@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 22, 2017 at 3:54 PM, Sandy Harris <sandyinchina@gmail.com> wrote:

> In the FreeS/WAN project, back around the turn of the century,
> we refused to implement several things required by the RFCs

Link to documentation:
http://www.freeswan.org/freeswan_trees/freeswan-2.06/doc/compat.html#dropped
