From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 24/27] staging: ccree: use a consistent file naming
 convention
Date: Mon, 8 Jan 2018 16:28:18 +0100
Message-ID: <20180108152818.GA7701@kroah.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
 <1515327285-8948-25-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58742 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933081AbeAHP2Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jan 2018 10:28:16 -0500
Content-Disposition: inline
In-Reply-To: <1515327285-8948-25-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 07, 2018 at 12:14:35PM +0000, Gilad Ben-Yossef wrote:
> The ccree driver source files were using an inconsistent
> naming convention stemming from what the company was called
> when they were added.
> 
> Move to a single consistent naming convention for better
> code readability.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/staging/ccree/Makefile           |    6 +-
>  drivers/staging/ccree/cc_aead.c          | 2709 ++++++++++++++++++++++++++++++
>  drivers/staging/ccree/cc_aead.h          |  109 ++
>  drivers/staging/ccree/cc_buffer_mgr.c    | 1657 ++++++++++++++++++
>  drivers/staging/ccree/cc_buffer_mgr.h    |   74 +
>  drivers/staging/ccree/cc_cipher.c        | 1171 +++++++++++++
>  drivers/staging/ccree/cc_cipher.h        |   74 +
>  drivers/staging/ccree/cc_debugfs.c       |    2 +-
>  drivers/staging/ccree/cc_driver.c        |  508 ++++++
>  drivers/staging/ccree/cc_driver.h        |  194 +++
>  drivers/staging/ccree/cc_fips.c          |  112 ++
>  drivers/staging/ccree/cc_fips.h          |   37 +
>  drivers/staging/ccree/cc_hash.c          | 2299 +++++++++++++++++++++++++
>  drivers/staging/ccree/cc_hash.h          |  114 ++
>  drivers/staging/ccree/cc_host_regs.h     |  142 ++
>  drivers/staging/ccree/cc_hw_queue_defs.h |    2 +-
>  drivers/staging/ccree/cc_ivgen.c         |  281 ++++
>  drivers/staging/ccree/cc_ivgen.h         |   55 +
>  drivers/staging/ccree/cc_kernel_regs.h   |  167 ++
>  drivers/staging/ccree/cc_pm.c            |  125 ++
>  drivers/staging/ccree/cc_pm.h            |   57 +
>  drivers/staging/ccree/cc_request_mgr.c   |  719 ++++++++
>  drivers/staging/ccree/cc_request_mgr.h   |   51 +
>  drivers/staging/ccree/cc_sram_mgr.c      |  107 ++
>  drivers/staging/ccree/cc_sram_mgr.h      |   65 +
>  drivers/staging/ccree/dx_crys_kernel.h   |  167 --
>  drivers/staging/ccree/dx_host.h          |  142 --
>  drivers/staging/ccree/ssi_aead.c         | 2709 ------------------------------
>  drivers/staging/ccree/ssi_aead.h         |  109 --
>  drivers/staging/ccree/ssi_buffer_mgr.c   | 1657 ------------------
>  drivers/staging/ccree/ssi_buffer_mgr.h   |   74 -
>  drivers/staging/ccree/ssi_cipher.c       | 1171 -------------
>  drivers/staging/ccree/ssi_cipher.h       |   74 -
>  drivers/staging/ccree/ssi_driver.c       |  508 ------
>  drivers/staging/ccree/ssi_driver.h       |  194 ---
>  drivers/staging/ccree/ssi_fips.c         |  112 --
>  drivers/staging/ccree/ssi_fips.h         |   37 -
>  drivers/staging/ccree/ssi_hash.c         | 2299 -------------------------
>  drivers/staging/ccree/ssi_hash.h         |  114 --
>  drivers/staging/ccree/ssi_ivgen.c        |  281 ----
>  drivers/staging/ccree/ssi_ivgen.h        |   55 -
>  drivers/staging/ccree/ssi_pm.c           |  125 --
>  drivers/staging/ccree/ssi_pm.h           |   57 -
>  drivers/staging/ccree/ssi_request_mgr.c  |  719 --------
>  drivers/staging/ccree/ssi_request_mgr.h  |   51 -
>  drivers/staging/ccree/ssi_sram_mgr.c     |  107 --
>  drivers/staging/ccree/ssi_sram_mgr.h     |   65 -
>  47 files changed, 10832 insertions(+), 10832 deletions(-)
>  create mode 100644 drivers/staging/ccree/cc_aead.c
>  create mode 100644 drivers/staging/ccree/cc_aead.h
>  create mode 100644 drivers/staging/ccree/cc_buffer_mgr.c
>  create mode 100644 drivers/staging/ccree/cc_buffer_mgr.h
>  create mode 100644 drivers/staging/ccree/cc_cipher.c
>  create mode 100644 drivers/staging/ccree/cc_cipher.h
>  create mode 100644 drivers/staging/ccree/cc_driver.c
>  create mode 100644 drivers/staging/ccree/cc_driver.h
>  create mode 100644 drivers/staging/ccree/cc_fips.c
>  create mode 100644 drivers/staging/ccree/cc_fips.h
>  create mode 100644 drivers/staging/ccree/cc_hash.c
>  create mode 100644 drivers/staging/ccree/cc_hash.h
>  create mode 100644 drivers/staging/ccree/cc_host_regs.h
>  create mode 100644 drivers/staging/ccree/cc_ivgen.c
>  create mode 100644 drivers/staging/ccree/cc_ivgen.h
>  create mode 100644 drivers/staging/ccree/cc_kernel_regs.h
>  create mode 100644 drivers/staging/ccree/cc_pm.c
>  create mode 100644 drivers/staging/ccree/cc_pm.h
>  create mode 100644 drivers/staging/ccree/cc_request_mgr.c
>  create mode 100644 drivers/staging/ccree/cc_request_mgr.h
>  create mode 100644 drivers/staging/ccree/cc_sram_mgr.c
>  create mode 100644 drivers/staging/ccree/cc_sram_mgr.h
>  delete mode 100644 drivers/staging/ccree/dx_crys_kernel.h
>  delete mode 100644 drivers/staging/ccree/dx_host.h
>  delete mode 100644 drivers/staging/ccree/ssi_aead.c
>  delete mode 100644 drivers/staging/ccree/ssi_aead.h
>  delete mode 100644 drivers/staging/ccree/ssi_buffer_mgr.c
>  delete mode 100644 drivers/staging/ccree/ssi_buffer_mgr.h
>  delete mode 100644 drivers/staging/ccree/ssi_cipher.c
>  delete mode 100644 drivers/staging/ccree/ssi_cipher.h
>  delete mode 100644 drivers/staging/ccree/ssi_driver.c
>  delete mode 100644 drivers/staging/ccree/ssi_driver.h
>  delete mode 100644 drivers/staging/ccree/ssi_fips.c
>  delete mode 100644 drivers/staging/ccree/ssi_fips.h
>  delete mode 100644 drivers/staging/ccree/ssi_hash.c
>  delete mode 100644 drivers/staging/ccree/ssi_hash.h
>  delete mode 100644 drivers/staging/ccree/ssi_ivgen.c
>  delete mode 100644 drivers/staging/ccree/ssi_ivgen.h
>  delete mode 100644 drivers/staging/ccree/ssi_pm.c
>  delete mode 100644 drivers/staging/ccree/ssi_pm.h
>  delete mode 100644 drivers/staging/ccree/ssi_request_mgr.c
>  delete mode 100644 drivers/staging/ccree/ssi_request_mgr.h
>  delete mode 100644 drivers/staging/ccree/ssi_sram_mgr.c
>  delete mode 100644 drivers/staging/ccree/ssi_sram_mgr.h

Can you redo this with the -M option to git format-patch so we can see
the files move, and not be deleted and added again?

thanks,

greg k-h
