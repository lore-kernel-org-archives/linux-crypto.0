Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF4BC4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35FE72133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561699552;
	bh=aMZfEfbPOVHaF3ps0biSxY9D0QevPh/SQ9F38VyxOOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YuIx/9mlUQsR8HxzCj5dgo0+jOCRPxPxxO/D50KDXwUXuRA/Dsf9FFbxc3Tnnu/tW
	 U9bAlljmBC97e9px2n3QcEQU9/OBrcpV5oxzCAWqngK4lCL6NzVxw1sEC2cfkIq65S
	 tTlDtSZL5PdGU/0sz8MCXVvWLFD9z9b+AEWaVRNg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfF1FZs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 01:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfF1FZs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 01:25:48 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D04F72133F;
        Fri, 28 Jun 2019 05:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561699546;
        bh=aMZfEfbPOVHaF3ps0biSxY9D0QevPh/SQ9F38VyxOOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mHR7MZYSCuKftGCC0a4GEMifx1yqY1mqy6gelDQX21z2J9q+qOUS3XH3w7FJiOQox
         rFofg1nwy5fMVogvoBfoe5h6fCX6BNIhcOjt+ntd9o7GwXB9pdr3IKKYhDcBprFs8s
         XZ+4N1B18kQ5aVsT+q9V2tTe/fy2D9I93+AouszQ=
Date:   Thu, 27 Jun 2019 22:25:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     keerthy <j-keerthy@ti.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        t-kristo@ti.com, linux-crypto@vger.kernel.org, nm@ti.com
Subject: Re: [RESEND PATCH 00/10] crypto: k3: Add sa2ul driver
Message-ID: <20190628052544.GH673@sol.localdomain>
References: <20190628042745.28455-1-j-keerthy@ti.com>
 <20190628045318.GC673@sol.localdomain>
 <7ca64e49-6e1f-c74e-4d8e-0e08607fe5c5@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ca64e49-6e1f-c74e-4d8e-0e08607fe5c5@ti.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 28, 2019 at 10:44:26AM +0530, keerthy wrote:
> 
> 
> On 6/28/2019 10:23 AM, Eric Biggers wrote:
> > Hi Keerthy,
> > 
> > On Fri, Jun 28, 2019 at 09:57:35AM +0530, Keerthy wrote:
> > > The series adds Crypto hardware accelerator support for SA2UL.
> > > SA2UL stands for security accelerator ultra lite.
> > > 
> > > The Security Accelerator (SA2_UL) subsystem provides hardware
> > > cryptographic acceleration for the following use cases:
> > > • Encryption and authentication for secure boot
> > > • Encryption and authentication of content in applications
> > >    requiring DRM (digital rights management) and
> > >    content/asset protection
> > > The device includes one instantiation of SA2_UL named SA2_UL0
> > > 
> > > SA2UL needs on tx channel and a pair of rx dma channels.
> > > 
> > > This series has dependency on UDMA series. Hence is based on top of:
> > > 
> > > https://patchwork.kernel.org/project/linux-dmaengine/list/?series=114105
> > > 
> > > The above series adds couple of dmaengine APIs that are used
> > > by the sa2ul driver. Hence there is a hard dependency on the
> > > above series.
> > > 
> > > Resending with linux-crypto list in Cc.
> > > 
> > > Keerthy (10):
> > >    dt-bindings: crypto: k3: Add sa2ul bindings documentation
> > >    crypto: sa2ul: Add crypto driver
> > >    crypto: sa2ul: Add AES ECB Mode support
> > >    crypto: sa2ul: Add aead support for hmac(sha1)cbc(aes) algorithm
> > >    crypto: sha256_generic: Export the Transform function
> > >    crypto: sa2ul: Add hmac(sha256)cbc(aes) AEAD Algo support
> > >    crypto: sa2ul: Add hmac(sha1) HMAC algorithm support
> > >    crypto: sa2ul: Add hmac(sha256) HMAC algorithm support
> > >    sa2ul: Add 3DES ECB & CBC Mode support
> > >    arm64: dts: k3-am6: Add crypto accelarator node
> > > 
> > >   .../devicetree/bindings/crypto/sa2ul.txt      |   47 +
> > >   arch/arm64/boot/dts/ti/k3-am65-main.dtsi      |   33 +
> > >   crypto/sha256_generic.c                       |    3 +-
> > >   drivers/crypto/Kconfig                        |   17 +
> > >   drivers/crypto/Makefile                       |    1 +
> > >   drivers/crypto/sa2ul.c                        | 2232 +++++++++++++++++
> > >   drivers/crypto/sa2ul.h                        |  384 +++
> > >   include/crypto/sha.h                          |    1 +
> > >   8 files changed, 2717 insertions(+), 1 deletion(-)
> > >   create mode 100644 Documentation/devicetree/bindings/crypto/sa2ul.txt
> > >   create mode 100644 drivers/crypto/sa2ul.c
> > >   create mode 100644 drivers/crypto/sa2ul.h
> > 
> > Did you run the crypto self-tests on this driver?  i.e. boot a kernel with
> > 
> > 	# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> > 	CONFIG_DEBUG_KERNEL=y
> > 	CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> > 
> > What are the results?
> 
> Eric,
> 
> Thanks for your response. I did try with that. All test cases
> were passing on 4.19 kernel before the testmgr revamp.
> 

That's surprising, since your driver doesn't implement update() for hashing, so
it should have been failing at least the HMAC tests.  Are you sure you really
ran the tests?

> Currently few of the test cases do fail. For ex: Appending
> the last ivlen bytes of cipher text as the IV.

Well, these need to be fixed.

> 
> > 
> > Also, this patchset does not compile for me.
> 
> This has dependency on UDMA series:
> https://patchwork.kernel.org/cover/10930969/

I had that applied.

- Eric
