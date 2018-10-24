Return-Path: <SRS0=schb=NE=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44514 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbeJXQKX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Oct 2018 12:10:23 -0400
Message-ID: <1540367003.3008.13.camel@HansenPartnership.com>
Subject: Re: [PATCH v4 0/7] add integrity and security to TPM2 transactions
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 24 Oct 2018 08:43:23 +0100
In-Reply-To: <alpine.DEB.2.21.1810240249180.8524@jsakkine-mobl1>
References: <1540193596.3202.7.camel@HansenPartnership.com>
         <alpine.DEB.2.21.1810240249180.8524@jsakkine-mobl1>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2018-10-24 at 02:51 +0300, Jarkko Sakkinen wrote:
> I would consider sending first a patch set that would iterate the
> existing session stuff to be ready for this i.e. merge in two
> iterations (emphasis on the word "consider"). We can probably merge
> the groundwork quite fast.

I realise we're going to have merge conflicts on the later ones, so why
don't we do this: I'll still send as one series, but you apply the ones
you think are precursors and I'll rebase and resend the rest?

James
