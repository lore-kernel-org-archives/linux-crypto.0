Return-Path: <SRS0=+ioq=2Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 859F6C32767
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Jan 2020 05:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B0072464E
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Jan 2020 05:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgADFue (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Jan 2020 00:50:34 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:48814 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgADFue (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Jan 2020 00:50:34 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1incKW-0001qx-T7; Sat, 04 Jan 2020 13:50:32 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1incKR-0005IJ-Vi; Sat, 04 Jan 2020 13:50:28 +0800
Date:   Sat, 4 Jan 2020 13:50:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tee-dev@lists.linaro.org, Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>
Subject: Re: [PATCH 0/4] TEE driver for AMD APUs
Message-ID: <20200104055027.2zlf32e5yhsdqgm2@gondor.apana.org.au>
References: <cover.1577423898.git.Rijo-john.Thomas@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1577423898.git.Rijo-john.Thomas@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 27, 2019 at 10:53:59AM +0530, Rijo Thomas wrote:
> This patch series introduces Trusted Execution Environment (TEE) driver
> for AMD APU enabled systems. The TEE is a secure area of a processor which
> ensures that sensitive data is stored, processed and protected in an
> isolated and trusted environment. The AMD Secure Processor is a dedicated
> processor which provides TEE to enable HW platform security. It offers
> protection against software attacks generated in Rich Operating
> System (Rich OS) such as Linux running on x86. The AMD-TEE Trusted OS
> running on AMD Secure Processor allows loading and execution of security
> sensitive applications called Trusted Applications (TAs). An example of
> a TA would be a DRM (Digital Rights Management) TA written to enforce
> content protection.
> 
> Linux already provides a tee subsystem, which is described in [1]. The tee
> subsystem provides a generic TEE ioctl interface which can be used by user
> space to talk to a TEE driver. AMD-TEE driver registers with tee subsystem
> and implements tee function callbacks in an AMD platform specific manner.
> 
> The following TEE commands are recognized by AMD-TEE Trusted OS:
> 1. TEE_CMD_ID_LOAD_TA : Load Trusted Application (TA) binary into TEE
>    environment
> 2. TEE_CMD_ID_UNLOAD_TA : Unload TA binary from TEE environment
> 3. TEE_CMD_ID_OPEN_SESSION : Open session with loaded TA
> 4. TEE_CMD_ID_CLOSE_SESSION : Close session with loaded TA
> 5. TEE_CMD_ID_INVOKE_CMD : Invoke a command with loaded TA
> 6. TEE_CMD_ID_MAP_SHARED_MEM : Map shared memory
> 7. TEE_CMD_ID_UNMAP_SHARED_MEM : Unmap shared memory
> 
> Each command has its own payload format. The AMD-TEE driver creates a
> command buffer payload for submission to AMD-TEE Trusted OS. The driver
> uses the services of AMD Secure Processor driver to submit commands
> to the Trusted OS. Further details can be found in [1].
> 
> This patch series is based on cryptodev-2.6 tree with base commit
> c6d633a92749 (crypto: algapi - make unregistration functions return void).
> 
> [1] https://www.kernel.org/doc/Documentation/tee.txt
> 
> Rijo Thomas (4):
>   tee: allow compilation of tee subsystem for AMD CPUs
>   tee: add AMD-TEE driver
>   tee: amdtee: check TEE status during driver initialization
>   Documentation: tee: add AMD-TEE driver details
> 
>  Documentation/tee.txt               |  81 ++++++
>  drivers/crypto/ccp/tee-dev.c        |  11 +
>  drivers/tee/Kconfig                 |   4 +-
>  drivers/tee/Makefile                |   1 +
>  drivers/tee/amdtee/Kconfig          |   8 +
>  drivers/tee/amdtee/Makefile         |   5 +
>  drivers/tee/amdtee/amdtee_if.h      | 183 +++++++++++++
>  drivers/tee/amdtee/amdtee_private.h | 159 +++++++++++
>  drivers/tee/amdtee/call.c           | 373 ++++++++++++++++++++++++++
>  drivers/tee/amdtee/core.c           | 516 ++++++++++++++++++++++++++++++++++++
>  drivers/tee/amdtee/shm_pool.c       |  93 +++++++
>  include/linux/psp-tee.h             |  18 ++
>  include/uapi/linux/tee.h            |   1 +
>  13 files changed, 1451 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/tee/amdtee/Kconfig
>  create mode 100644 drivers/tee/amdtee/Makefile
>  create mode 100644 drivers/tee/amdtee/amdtee_if.h
>  create mode 100644 drivers/tee/amdtee/amdtee_private.h
>  create mode 100644 drivers/tee/amdtee/call.c
>  create mode 100644 drivers/tee/amdtee/core.c
>  create mode 100644 drivers/tee/amdtee/shm_pool.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
