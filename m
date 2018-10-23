Return-Path: <SRS0=BLQr=ND=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:54108 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbeJXDlT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Oct 2018 23:41:19 -0400
Date: Tue, 23 Oct 2018 22:16:31 +0300 (EEST)
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v4 1/7] tpm-buf: create new functions for handling TPM
 buffers
In-Reply-To: <1540193734.3202.9.camel@HansenPartnership.com>
Message-ID: <alpine.DEB.2.21.1810232214210.8524@jsakkine-mobl1>
References: <1540193596.3202.7.camel@HansenPartnership.com> <1540193734.3202.9.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 22 Oct 2018, James Bottomley wrote:
> This separates out the old tpm_buf_... handling functions from static
> inlines into tpm.h and makes them their own tpm-buf.c file.  It also
> adds handling for tpm2b structures and also incremental pointer
> advancing parsers.
>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Would also prefer simply "tpm:" tag e.g. (in all of the commits actually
in this series but I remark it just here).

"tpm: create new tpm_buf_functions for parsing and TPM2B"

/Jarkko
