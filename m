From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] crypto: vmx: Remove dubiously licensed crypto code
Date: Wed, 29 Mar 2017 16:51:35 +0200
Message-ID: <20170329145135.GA28057@kroah.com>
References: <20170329125639.14288-1-msuchanek@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Michal Suchanek <msuchanek@suse.de>,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37276 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751778AbdC2Ovw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Mar 2017 10:51:52 -0400
Content-Disposition: inline
In-Reply-To: <20170329125639.14288-1-msuchanek@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 29, 2017 at 02:56:39PM +0200, Michal Suchanek wrote:
> While reviewing commit 11c6e16ee13a ("crypto: vmx - Adding asm
> subroutines for XTS") which adds the OpenSSL license header to
> drivers/crypto/vmx/aesp8-ppc.pl licensing of this driver came into
> qestion. The whole license reads:
> 
>  # Licensed under the OpenSSL license (the "License").  You may not use
>  # this file except in compliance with the License.  You can obtain a
>  # copy
>  # in the file LICENSE in the source distribution or at
>  # https://www.openssl.org/source/license.html
> 
>  #
>  # ====================================================================
>  # Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
>  # project. The module is, however, dual licensed under OpenSSL and
>  # CRYPTOGAMS licenses depending on where you obtain it. For further
>  # details see http://www.openssl.org/~appro/cryptogams/.
>  # ====================================================================
> 
> After seeking legal advice it is still not clear that this driver can be
> legally used in Linux. In particular the "depending on where you obtain
> it" part does not make it clear when you can apply the GPL and when the
> OpenSSL license.
> 
> I tried contacting the author of the code for clarification but did not
> hear back. In absence of clear licensing the only solution I see is
> removing this code.
> 
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
>  MAINTAINERS                       |   12 -
>  drivers/crypto/Kconfig            |    8 -
>  drivers/crypto/Makefile           |    1 -
>  drivers/crypto/vmx/.gitignore     |    2 -
>  drivers/crypto/vmx/Kconfig        |    9 -
>  drivers/crypto/vmx/Makefile       |   21 -
>  drivers/crypto/vmx/aes.c          |  150 --
>  drivers/crypto/vmx/aes_cbc.c      |  202 --
>  drivers/crypto/vmx/aes_ctr.c      |  191 --
>  drivers/crypto/vmx/aes_xts.c      |  190 --
>  drivers/crypto/vmx/aesp8-ppc.h    |   25 -
>  drivers/crypto/vmx/aesp8-ppc.pl   | 3789 -------------------------------------
>  drivers/crypto/vmx/ghash.c        |  227 ---
>  drivers/crypto/vmx/ghashp8-ppc.pl |  234 ---
>  drivers/crypto/vmx/ppc-xlate.pl   |  228 ---
>  drivers/crypto/vmx/vmx.c          |   88 -
>  16 files changed, 5377 deletions(-)
>  delete mode 100644 drivers/crypto/vmx/.gitignore
>  delete mode 100644 drivers/crypto/vmx/Kconfig
>  delete mode 100644 drivers/crypto/vmx/Makefile
>  delete mode 100644 drivers/crypto/vmx/aes.c
>  delete mode 100644 drivers/crypto/vmx/aes_cbc.c
>  delete mode 100644 drivers/crypto/vmx/aes_ctr.c
>  delete mode 100644 drivers/crypto/vmx/aes_xts.c
>  delete mode 100644 drivers/crypto/vmx/aesp8-ppc.h
>  delete mode 100644 drivers/crypto/vmx/aesp8-ppc.pl
>  delete mode 100644 drivers/crypto/vmx/ghash.c
>  delete mode 100644 drivers/crypto/vmx/ghashp8-ppc.pl
>  delete mode 100644 drivers/crypto/vmx/ppc-xlate.pl
>  delete mode 100644 drivers/crypto/vmx/vmx.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1b0a87ffffab..fd4cbf046ab4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6190,18 +6190,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
>  S:	Maintained
>  F:	arch/ia64/
>  
> -IBM Power VMX Cryptographic instructions
> -M:	Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
> -M:	Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>

Any reason why you didn't cc: these maintainers on your patch?

thanks,

greg k-h
