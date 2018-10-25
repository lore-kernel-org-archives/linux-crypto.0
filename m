Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:26201 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbeJZAQF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Oct 2018 20:16:05 -0400
Date: Thu, 25 Oct 2018 16:42:40 +0100 (IST)
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v4 0/7] add integrity and security to TPM2 transactions
In-Reply-To: <1540367003.3008.13.camel@HansenPartnership.com>
Message-ID: <alpine.DEB.2.21.1810251640340.4065@jsakkine-mobl1>
References: <1540193596.3202.7.camel@HansenPartnership.com>  <alpine.DEB.2.21.1810240249180.8524@jsakkine-mobl1> <1540367003.3008.13.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 24 Oct 2018, James Bottomley wrote:
> On Wed, 2018-10-24 at 02:51 +0300, Jarkko Sakkinen wrote:
>> I would consider sending first a patch set that would iterate the
>> existing session stuff to be ready for this i.e. merge in two
>> iterations (emphasis on the word "consider"). We can probably merge
>> the groundwork quite fast.
>
> I realise we're going to have merge conflicts on the later ones, so why
> don't we do this: I'll still send as one series, but you apply the ones
> you think are precursors and I'll rebase and resend the rest?
>
> James

Works for me and now I think after yesterdays dicussions etc. that this
should be merged as one series.

/Jarkko
